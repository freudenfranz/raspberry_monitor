"""
Embedded MQTT Broker Setup and Management.

This module is responsible for:
- Configuring and instantiating the `amqtt` broker.
- Setting up MQTT listeners (ports, TLS).
- Integrating the custom Authenticator and Authorization (ACL) plugins.
- Managing the broker's lifecycle (start, stop).
- Providing an interface for the HardwareManager to publish events.
"""
import asyncio
import dataclasses
import json
import logging
import queue
from typing import Callable, Optional
from pi_mqtt_gpio.server.models import BasePayload, DeviceStatePayload, MQTTMessage, RPCResponsePayload, SystemStatus, SystemStatusPayload, TelemetryPayload # Import our manager
from pi_mqtt_gpio.server.rpc_handler import RPCHandler
# from pi_mqtt_gpio.server.security import CustomAuthenticator # Will be imported in Phase 5
from aiomqtt import Client as MQTTClient, ProtocolVersion, Will
from paho.mqtt.properties import Properties
from paho.mqtt.packettypes import PacketTypes

logger = logging.getLogger(__name__)

class MQTTManager:
    event_queue: asyncio.Queue
    config: dict
    topic_template: str
    host: str 
    port: int     
    _main_task: Optional[asyncio.Task]
    username: Optional[str]
    password: Optional[str]
    client_id: str
    status_topic: str
    telemetry_topic: str
    rpc_handler: Optional[object] 
    _message_callbacks: Callable

    """
    Manages the lifecycle and configuration of the embedded AMQTT broker.
    """
    def __init__(self, event_queue: asyncio.Queue, config: dict):
        self.event_queue = event_queue

        # Configuration extraction with defaults
        self.config = config
        mqtt_conf = self.config.get('mqtt', {})
        self.topic_template = self.config.get('topic_pattern', 'pi/devices/{device}/state')
        self.host = mqtt_conf.get('host', 'localhost')
        self.port = int(mqtt_conf.get('port', 1883)) # Must be int 
        
        # Identity & Auth
        self.client_id = mqtt_conf.get('client_id', 'pi-gatekeeper')
        self.username = mqtt_conf.get('username', None)
        self.password = mqtt_conf.get('password', None)
        self.status_topic = self.config.get('status_topic', 'pi/status')  # Last Will status
        self.telemetry_topic = self.config.get('telemetry_topic', 'pi/system/telemetry') # Telemetry topic

        # Internal state
        self._main_task: Optional[asyncio.Task] = None
         # Add a list to hold incoming message callbacks
        self._message_callbacks = [] 

    async def start(self):
        """
        Launches the main MQTT loop in the background.
        """
        logger.info(f"Starting MQTT Manager, connecting to {self.host}:{self.port}...")
        self._main_task = asyncio.create_task(self._main_loop())

    async def stop(self):
        """
        Cancels the main loop, which closes the connection.
        """
        if self._main_task:
            logger.info("Stopping MQTT Manager...")
            self._main_task.cancel()
            try:
                await self._main_task
            except asyncio.CancelledError:
                logger.info("MQTT Manager stopped gracefully.")
            except Exception as e:
                logger.error(f"Error during MQTT stop: {e}")
    
    async def _main_loop(self):
        """
        The persistent connection loop. 
        It handles reconnection automatically if the context manager exits unexpectedly 
        (though aiomqtt usually handles this via its own retry logic, we wrap it to be safe).
        """
         # If we crash, the broker sets pi/status = "offline" (retained)
        lastWill = Will(
            topic=self.status_topic,
            payload=SystemStatusPayload(status=SystemStatus.OFFLINE).to_bytes(), 
            qos=1,
            retain=True
        )

        while True:
            try:
                # The connection is ONLY valid inside this block
                async with MQTTClient(  self.host, 
                                        self.port, 
                                        protocol=ProtocolVersion.V5, 
                                        identifier=self.client_id,
                                        username=self.username,
                                        password=self.password,
                                        will=lastWill) as client:
                    await client.publish(self.status_topic, payload=SystemStatusPayload(status=SystemStatus.ONLINE).to_bytes(), retain=True)
                    logger.info(f"Connected to Mosquito Broker as {self.client_id}! Status: online")

                    
                    # Run publisher loop INSIDE the connection context, so it has access to the active client.
                    # Use asyncio.gather to run BOTH infinite loops at the same time
                    logger.info("Starting publisher and listener tasks...")
                    await asyncio.gather(
                        self._publisher_loop(client),
                        self._mqtt_listen_task(client)
                    )
            
            except asyncio.CancelledError:
                raise # Let the stop() method handle this
            except Exception as e:
                logger.error(f"MQTT Connection lost: {e}. Retrying in 5s...")
                await asyncio.sleep(5)

    async def _publisher_loop(self, client: MQTTClient):
        """The background worker that pushes events to the world."""
        while True:
            # 1. Wait for an item from the event_queue
            event: DeviceStatePayload = await self.event_queue.get()
            
            topic = None
            properties = None  # Default to no v5 properties

            if isinstance(event, DeviceStatePayload):
                # 2. Extract data from the event dict
                topic:str = self.topic_template.format(device=event.device)
            elif isinstance(event, TelemetryPayload):
                # This payload does NOT have a 'device' field
                topic = self.telemetry_topic # Use the configured telemetry topic
            elif isinstance(event, SystemStatusPayload):
                topic = self.status_topic # Publish to the status topic defined in config
            elif isinstance(event, RPCResponsePayload):
                topic = event.response_topic # The RPC handler will set this dynamically based on the request's ResponseTopic property
               
                # aiomqtt properties dictionary
                if event.correlation_data:
                    # Instantiate it with the correct packet type
                    properties = Properties(PacketTypes.PUBLISH)
                    # Attach MQTT v5 properties specifically for RPC responses
                    properties.CorrelationData = event.correlation_data
                
            else:
                # Handle unknown payloads
                logger.warning(f"Unknown payload type dropped: {type(event)}")
                self.event_queue.task_done()
                continue
            
            # Serialize and Publish
            try: 
                # amqtt expects the payload to be raw bytes so we need to convert our dict to JSON and then encode it
                bytes_payload:bytes = event.to_bytes()

                # Use amqtt to publish
                message = MQTTMessage(topic=topic, message=bytes_payload) # This is only for type checking
                await client.publish(
                    topic=message.topic, 
                    payload=message.message, 
                    properties=properties
                )
                logger.debug(f"Published event to topic '{topic}': {event.to_json()}") 
            except Exception as e:
                logger.error(f"Failed to publish message to '{topic}': {e}")
            
            finally:
                # 4. Mark as done, ensuring the queue doesn't hang even if publish fails
                self.event_queue.task_done()

    def publish_event(self, payload: BasePayload):
        """   
        The public interface for sending any hardware fact or system log 
        to the outside world. This is part of our "Async/Sync Bridge" 
        that allows the synchronous(!) HardwareManager to communicate with the async(!) MQTTManager.
        
        We are passing this as a callback to the HardwareManager, 
        which will call it from its worker thread whenever it has an event to report.
        Make sure to use async_loop.call_soon_threadsafe(self.publish_event, event)
        
        Accepts a high-level Payload object and places it in the 
        internal queue for the background loop to process.
        """
        # 1. Log that a publish request was received
        logger.debug(f"Request to publish: {payload}")
    
        # 2. Put the payload into the queue
        # Make sure to use async_loop.call_soon_threadsafe(self.publish_event, event)
        # to handle it!
        self.event_queue.put_nowait(payload)
  
    # MQTT client listening for RCP commands and passing them to the RPCHandler            
    async def _mqtt_listen_task(self, client:MQTTClient):
        # Subscribe
        await client.subscribe("pi/rpc/commands")
        logger.info("Subscribed to pi/rpc/commands")
        
        async for message in client.messages:
            # Shout to anyone listening!
            for callback in self._message_callbacks:
                # Run the callback in the background so it doesn't block the listener
                # Pass the raw MQTT v5 properties and payload to the handlers
                asyncio.create_task(
                    callback(
                        topic=str(message.topic), 
                        payload=message.payload, 
                        properties=message.properties
                        )
                )


    # Registration method for incoming MQTT message callbacks (like the RPC handler)
    def register_message_callback(self, callback_coroutine):
        """Allows external classes to subscribe to incoming MQTT messages."""
        self._message_callbacks.append(callback_coroutine)
    
    
    # You might want methods to expose config or status if needed
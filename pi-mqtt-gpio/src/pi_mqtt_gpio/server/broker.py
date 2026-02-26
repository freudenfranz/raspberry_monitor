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
from typing import Optional
from amqtt.broker import Broker as AMQTTBroker 
from amqtt.client import MQTTClient as AMQTTClient
from amqtt.mqtt.constants import QOS_0 # For publishing events
from pi_mqtt_gpio.server.models import BasePayload, DeviceStatePayload, MQTTMessage # Import our manager
# from pi_mqtt_gpio.server.security import CustomAuthenticator # Will be imported in Phase 5


class EmbeddedBroker:
    command_queue: queue.Queue
    event_queue: asyncio.Queue
    config: dict
    broker: AMQTTBroker
    internal_client: AMQTTClient
    eventLoop: asyncio.AbstractEventLoop
    _publisher_task: Optional[asyncio.Task] = None
    topic_template: str

    """
    Manages the lifecycle and configuration of the embedded AMQTT broker.
    """
    def __init__(self, command_queue: asyncio.Queue, event_queue: asyncio.Queue, config: dict, loop: asyncio.BaseEventLoop):
        # Store a reference to the HardwareManager to allow event publishing
        # Store configuration for the broker
        # Initialize AMQTTBroker with relevant config (ports, authenticator, etc.)
        # Keep track of a client instance for publishing internal events
        self.command_queue = command_queue
        self.event_queue = event_queue
        self.config = config or {}
        self.eventLoop = loop
        self.broker = AMQTTBroker(self.config, loop=self.eventLoop)
        self.internal_client = AMQTTClient() # This client will be used for internal publishing
        self.topic_template = self.config.get('topic_pattern', 'pi/devices/{device}/state')

    async def start(self):
        """
        Starts the embedded AMQTT broker and any necessary background tasks.
        """
        # Start the AMQTTBroker as an asyncio task
        # Start the event publishing task from HardwareManager
        # Register the RPC handler's callback for incoming commands
        try:
            await self.broker.start()
            logging.info("Embedded MQTT Broker started successfully.")
            if(self.config['listeners']['default']):
                uri="mqtt://" + self.config['listeners']['default'].get('bind', 'localhost:1883')+ "/"
                await self.internal_client.connect(uri)
                logging.info("Internal MQTT client started successfully.")
            else:
                logging.warning("No default listener configured for the broker. Internal MQTT client will not be able to connect.")

            self._publisher_task = asyncio.create_task(self._publisher_loop())
            logging.info("Publisher loop started successfully.")
    
        except Exception as e:
            logging.error(f"Failed to start embedded MQTT Broker: {e}")
            raise
        
    # 1. Await self.broker.start()
    # 2. Start the background publisher loop
    # Hint: self._publisher_task = asyncio.create_task(self._publisher_loop())


    async def stop(self):
        """
        Stops the embedded AMQTT broker and cleans up resources.
        """
        # Stop the AMQTTBroker
        # Cancel any background tasks
        try:
            if hasattr(self, '_publisher_task'):
                self._publisher_task.cancel()
                try:
                    # We await to make sure the loop finished its cleanup
                    await self._publisher_task 
                except asyncio.CancelledError:
                    # We catch it here just in case the loop re-raises or 
                    # the system marks the task as cancelled during the await.
                    pass 
            await self.internal_client.disconnect()
            logging.info("Internal MQTT client disconnected successfully.")
            await self.broker.shutdown()
            logging.info("Embedded MQTT Broker stopped successfully.")
                
        except Exception as e:
            logging.error(f"Failed to stop embedded MQTT Broker: {e}")
            raise

    async def _publisher_loop(self):
        """The background worker that pushes events to the world."""
        try:
            while True:
                # 1. Wait for an item from the event_queue
                event: DeviceStatePayload = await self.event_queue.get()
                
                # 2. Extract data from the event dict
                topic:str = self.topic_template.format(device=event.device)
                # amqtt expects the payload to be raw bytes so we need to convert our dict to JSON and then encode it
                bytes_payload:bytes = event.to_bytes()

                # 3. Use amqtt to publish
                message = MQTTMessage(topic=topic, message=bytes_payload)
                await self.internal_client.publish(**message.to_publish_args())
                logging.debug(f"Published event to topic '{topic}': {event.to_json()}") 

                # 4. Mark as done
                self.event_queue.task_done()
               
        except asyncio.CancelledError:
            # Graceful shutdown logic
            logging.info("Publisher loop has been cancelled. Shutting down publisher task.")
            # TODO: Potentially check if there are any critical 'Last Will' messages left in the queue to send before dying. 
            raise

    def publish_hardware_event(self, payload: BasePayload):
        """   
        The public interface for sending any hardware fact or system log 
        to the outside world.
        
        Accepts a high-level Payload object and places it in the 
        internal queue for the background loop to process.

        Make sure to use async_loop.call_soon_threadsafe(self.publish_hardware_event, event)
        """
        # 1. Log that a publish request was received
        logging.debug(f"Request to publish: {payload}")
    
        # 2. Put the payload into the queue
        # Make sure to use async_loop.call_soon_threadsafe(self.publish_hardware_event, event)
        # to handle it!
        self.event_queue.put_nowait(payload)
  
    # You might want methods to expose config or status if needed

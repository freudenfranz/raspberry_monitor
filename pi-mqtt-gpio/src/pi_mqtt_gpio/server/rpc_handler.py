"""
MQTT v5 RPC Request Handler and Response Publisher.

This module is responsible for:
- Subscribing to MQTT topics for incoming RPC commands.
- Parsing MQTT v5 messages, extracting RPC methods, arguments,
  response topics, and correlation data.
- Placing RPC commands onto the `HardwareManager`'s Command Queue.
- Handling successful and failed command execution by publishing
  MQTT v5 RPC responses back to the requesting client.
"""
import asyncio
import json
import logging
from amqtt.session import Session # For accessing client session properties
from amqtt.mqtt.constants import QOS_0 # For publishing responses
from pi_mqtt_gpio.server.hardware import HardwareManager
from pi_mqtt_gpio.server.models import RPCResponsePayload # Import our manager

logger = logging.getLogger(__name__)

class RPCHandler:
    """
    Handles incoming MQTT v5 RPC requests and publishes responses.
    """
    hardware_manager: HardwareManager # Reference to sync HardwareManager wich will execute the commands
    broker_publish_method: callable # Reference to the MQTT broker's publish method for sending responses
    
    def __init__(self, hardware_manager: HardwareManager, broker_publish_method):
        # Store a reference to the HardwareManager to access its command_queue
        # Store the broker's publish method (from EmbeddedBroker)
        # Define the MQTT topic for incoming RPC requests
        self.hardware_manager = hardware_manager
        self.broker_publish_method = broker_publish_method

    async def subscribe_to_commands(self, client_id: str, topic: str):
        """
        This method will be called by the broker to register subscriptions
        for incoming RPC command topics.
        """
        # Return a list of (topic, qos) tuples for subscription
        pass

    async def mqtt_message_handler(self, topic: str, payload: bytes, properties: dict):
        # Extract MQTT v5 response_topic and correlation_data from properties
        
        # Create a command dictionary for the HardwareManager's queue
        # Place the command onto the HardwareManager's command_queue
        # Use asyncio.create_task for RPC response handling
        """
        Callback for processing incoming MQTT messages.
        """
        # Enforce Universal Inbox
        if topic != "pi/rpc/commands":
            logger.warning(f"RPCHandler received message on invalid topic: {topic}. Ignoring.")
            return

    
        # Extract RPC method, args, kwargs from the JSON payload
        try:
            # Parse Payload
            payload_str = payload.decode('utf-8')
            data = json.loads(payload_str)
            
            # Extract Core Routing Data
            device_name = data.get("device")
            method_name = data.get("method")

            if not device_name or not method_name:
                logger.error(f"RPC payload missing required 'device' or 'method' keys. Payload: {payload_str}")
                return
            
            # Extract MQTT v5 Properties
            response_topic = None
            correlation_data = None
            if properties: # The properties object might be None if client is not v5
                response_topic = getattr(properties, 'ResponseTopic', None)
                correlation_data = getattr(properties, 'CorrelationData', None)

            # Create an asyncio Future to wait for the sync Hardware thread returning the success/error result of the command execution
            loop = asyncio.get_running_loop()
            command_future = loop.create_future()

            # Build the internal command dictionary
            command = {
                "device": device_name,
                "method": method_name,
                "args": data.get("args", []),
                "kwargs": data.get("kwargs", {}),
                "rpc_response_topic": response_topic,
                "correlation_data": correlation_data,
                "future": command_future # Attach the future!
            }

            # Put onto the HardwareManager's thread-safe queue
            # (Using put_nowait because we are in an async loop calling a sync queue)
            self.hardware_manager.inbound_command_queue.put_nowait(command)
            logger.debug(f"Queued command for {device_name}: {method_name}")

            # If the client asked for a response, launch a background task to wait for it
            if response_topic:
                asyncio.create_task(self._handle_rpc_response(command))

        except json.JSONDecodeError:
            logger.error(f"Failed to decode RPC payload: {payload}")
        except Exception as e:
            logger.error(f"Error handling RPC message on {topic}: {e}")

    async def _handle_rpc_response(self, command: dict):
        """
        Internal method to manage RPC response publishing after command execution.
        This will be run as an asyncio task.
        """
        # Get the response_topic and correlation_data from the command dict
        # Await the result from the HardwareManager's command execution (or a future/event)
        # Publish success or error response using broker_publish_method
        """
        Internal method to manage RPC response publishing after command execution.
        Runs as an asyncio task, awaiting the Future resolved by the HardwareManager.
        """
        response_topic = command["rpc_response_topic"]
        correlation_data = command["correlation_data"]
        
        try:
            result = await command["future"]
            
            # Use your dataclass directly!
            response = RPCResponsePayload(
                response_topic=response_topic,
                status="success",
                result=result,
                message="",
                correlation_data=correlation_data # Make sure this is added to models.py!
            )
        except Exception as e:
            response = RPCResponsePayload(
                response_topic=response_topic,
                status="error",
                message=str(e),
                correlation_data=correlation_data
            )

        # Call gateway method with put_nowait under the hood)
        try:
            self.broker_publish_method(response)
            logger.debug(f"Queued RPC response for {response_topic}")
        except Exception as e:
             logger.error(f"Failed to queue RPC response: {e}")
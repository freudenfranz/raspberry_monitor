import dataclasses
import logging

from pi_mqtt_gpio.server.models import DeviceStatePayload, MQTTMessage
import pytest
import asyncio
import json
import queue # <-- IMPORT for the blocking queue
from unittest.mock import MagicMock, AsyncMock, patch

# Assume paho is installed from our pyproject.toml
import paho.mqtt.client as mqtt
from pi_mqtt_gpio.server.broker import EmbeddedBroker

"""
Phase 3 Tests: Embedded MQTT Broker Setup and Lifecycle.
Tests the functionality of the broker.py module, ensuring the embedded
MQTT broker starts, stops, and handles basic client connections correctly.
"""

@pytest.fixture
def test_config():
    """Provides a basic broker configuration for testing."""
    return {
        'listeners': {
            'default': {
                'type': 'tcp',
                'bind': '127.0.0.1:1883', # Use localhost for tests
            }
        },
        'topic-check': {
            'enabled': False # Disable topic checks for simple broker tests
        }
    }

@pytest.fixture
def mock_queues():
    """Provides the correct queue types needed by the system."""
    return {
        "command_queue": queue.Queue(),      # Blocking queue for the sync worker
        "event_queue": asyncio.Queue(),    # Async queue for the event loop
    }


@pytest.mark.asyncio
async def test_broker_starts_and_stops_cleanly(test_config, mock_queues):
    """
    Verifies that the embedded MQTT broker can be started, accept a connection,
    and then be stopped cleanly.
    """
    loop = asyncio.get_running_loop()
    broker = EmbeddedBroker(
        mock_queues["command_queue"], 
        mock_queues["event_queue"], 
        test_config,
        loop=loop
    )
    
    # Start the broker in the background
    await broker.start()
    await asyncio.sleep(0.1) # Give the broker a moment to start up

    # Use a real client to verify it's running
    # We are using a different library (paho-mqtt) here to test the broker's compatibility with standard MQTT clients
    client_connected = asyncio.Event()
    def on_connect(client, userdata, flags, rc, properties=None): # Adjusted for paho-mqtt v2
        if rc == 0:
            client_connected.set()
            logging.info("Test MQTT client connected successfully.")
        else:
            logging.error(f"Test MQTT client failed to connect with result code {rc}.")

     

    test_client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2)
    test_client.on_connect = on_connect
    test_client.connect_async('127.0.0.1', 1883)
    test_client.loop_start()

    try:
        # Wait for the client to connect, with a timeout
        await asyncio.wait_for(client_connected.wait(), timeout=1.0)
    except asyncio.TimeoutError:
        pytest.fail("Test MQTT client failed to connect to the embedded broker.")
    finally:
        test_client.loop_stop()

    # Stop the broker
    await broker.stop()
    await asyncio.sleep(0.05) # Give it a moment to shut down

    # Verify the client can no longer connect
    with pytest.raises(ConnectionRefusedError):
        # Using connect() here as it's synchronous and will raise immediately
        test_client.connect('127.0.0.1', 1883)


@pytest.mark.asyncio
async def test_event_publisher_publishes_from_queue(test_config, mock_queues):
    """
    Tests that the event publisher task correctly pulls an event from the
    event_queue and publishes it as an MQTT message.
    """
    loop = asyncio.get_running_loop()
    broker = EmbeddedBroker(
        mock_queues["command_queue"], 
        mock_queues["event_queue"], 
        test_config,
        loop=loop
    )
    await broker.start()
    await asyncio.sleep(0.05)

    message_received_future = loop.create_future()
    def on_message(client, userdata, msg):
        message_received_future.set_result({
            "topic": msg.topic,
            "message": json.loads(msg.payload.decode('utf-8')),
        })
        logging.info(f"Test MQTT client received message on topic {msg.topic}: {msg.payload.decode('utf-8')}")

    def on_subscribe(client, userdata, mid, reason_code_list, properties):
        loop.call_soon_threadsafe(mock_queues["event_queue"].put_nowait, test_event)
    
    test_client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2)
    test_client.on_message = on_message
    test_client.connect('127.0.0.1', 1883)
    test_client.subscribe("pi/devices/button_27/state")
    test_client.on_subscribe = on_subscribe
    test_client.loop_start()
    
    # simulate an event being published by putting it in the event queue
    test_event = DeviceStatePayload(device="button_27", event="state", value="pressed")
    # we don't neet do construct this, since we don't need the Object and will only get the parameters out again. 
    # But since the broker is doing it too I wanna showcase it here as well.
    test_message = MQTTMessage(topic="pi/devices/button_27/state", message=test_event)

    try:
        received_message = await asyncio.wait_for(message_received_future, timeout=1.0)
        assert received_message["topic"] == test_message.topic
        assert received_message["message"] ==dataclasses.asdict(test_message.message)
 
    except asyncio.TimeoutError:
        pytest.fail("Event publisher did not publish the message from the queue in time.")
    finally:
        test_client.loop_stop()
        await broker.stop()

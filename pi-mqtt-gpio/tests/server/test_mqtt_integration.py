import pytest
import asyncio
import json
import dataclasses
from aiomqtt import Client, ProtocolVersion
from pi_mqtt_gpio.server.mqtt import MQTTManager
from pi_mqtt_gpio.server.models import DeviceStatePayload

@pytest.fixture
def integration_config():
    """Config pointing to the real local Mosquitto."""
    return {
        'mqtt': {
            'host': 'localhost',
            'port': 1883
        },
        'topic_pattern': 'pi/integration_test/{device}/state'
    }

@pytest.fixture
def event_queue():
    return asyncio.Queue()

@pytest.mark.asyncio
async def test_mqtt_manager_publishes_to_real_broker(integration_config, event_queue):
    """
    Integration Test:
    1. Starts MQTTManager (connects to localhost:1883).
    2. Starts a separate TestClient (connects to localhost:1883).
    3. Pushes an event to the Manager.
    4. Verifies the TestClient receives it over the loopback network.
    """
    # 1. Setup the System Under Test (SUT)
    manager = MQTTManager(event_queue=event_queue, config=integration_config)
    
    # Start the manager in the background
    await manager.start()
    
    # Allow a moment for the manager to connect
    await asyncio.sleep(0.1)

    # 2. Setup the Observer (Test Client)
    received_future = asyncio.get_running_loop().create_future()

    async def run_observer():
        host= integration_config['mqtt']['host']
        port = integration_config['mqtt']['port']
        protocol= ProtocolVersion.V5
        
        async with Client(host, port, protocol=protocol) as client:
            await client.subscribe("pi/integration_test/#")
            async for message in client.messages:
                # When we get the message, resolve the future and stop listening
                payload = json.loads(message.payload.decode())
                received_future.set_result({
                    "topic": str(message.topic),
                    "payload": payload
                })
                break

    # Start the observer task
    observer_task = asyncio.create_task(run_observer())
    
    # Wait briefly for observer to connect and subscribe
    await asyncio.sleep(0.1)

    # 3. Action: Inject a hardware event
    test_payload = DeviceStatePayload(
        device="test_led", 
        event="active", 
        value=True
    )
    
    # Use the public gateway method
    manager.publish_hardware_event(test_payload)

    # 4. Assertion: Wait for the network round-trip
    try:
        result = await asyncio.wait_for(received_future, timeout=2.0)
        
        expected_topic = "pi/integration_test/test_led/state"
        
        assert result["topic"] == expected_topic
        # Compare dictionary content (ignoring timestamp precision diffs if necessary, 
        # but here we check exact match of the serialized data)
        assert result["payload"]["device"] == "test_led"
        assert result["payload"]["value"] is True
        
    except asyncio.TimeoutError:
        pytest.fail("Timed out waiting for message from Mosquitto.")
        
    finally:
        # Cleanup
        await manager.stop()
        observer_task.cancel()
        try:
            await observer_task
        except asyncio.CancelledError:
            pass

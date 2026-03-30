"""
Phase 3/5 Tests: MQTT v5 RPC Request Handler and Response Publisher.
Tests the functionality of the rpc_handler.py module using the universal
'pi/rpc/commands' inbox, ensuring correct parsing, queuing, and v5 responses.
"""
import asyncio
import json
import pytest
from unittest.mock import AsyncMock

from pi_mqtt_gpio.server.rpc_handler import RPCHandler
from pi_mqtt_gpio.server.hardware import HardwareManager

 #Add this small helper class at the top of your test file
class MockProperties:
    def __init__(self, response_topic=None, correlation_data=None):
        self.ResponseTopic = response_topic
        self.CorrelationData = correlation_data

@pytest.fixture
def mock_hardware_manager_for_rpc(mocker):
    """Mocks the HardwareManager for RPC handler tests."""
    mock_hm = mocker.MagicMock(spec=HardwareManager)
    
    # Explicitly attach a mock queue so we can track the 'put_nowait' calls
    mock_hm.inbound_command_queue = mocker.MagicMock()
    
    return mock_hm

@pytest.fixture
def mock_mqtt_client_for_rpc(mocker):
    """Mocks the aiomqtt client interface for the RPC handler."""
    mock_client = mocker.MagicMock()
    mock_client.publish = AsyncMock() 
    return mock_client

@pytest.mark.asyncio
async def test_rpc_handler_parses_and_queues_command(mock_hardware_manager_for_rpc, mock_mqtt_client_for_rpc):
    """Tests that a command sent to the universal inbox is parsed and queued."""
    handler = RPCHandler(hardware_manager=mock_hardware_manager_for_rpc, broker_publish_method=mock_mqtt_client_for_rpc.publish)
    
    topic = "pi/rpc/commands"
    # Notice the device is inside the payload now!
    payload = json.dumps({"device": "led_17", "method": "on", "args": [], "kwargs": {}}).encode('utf-8')
    
    await handler.mqtt_message_handler(topic, payload, properties={})
    
    # Assert it was put in the queue
    mock_hardware_manager_for_rpc.inbound_command_queue.put_nowait.assert_called_once()
    queued_cmd = mock_hardware_manager_for_rpc.inbound_command_queue.put_nowait.call_args[0][0]
    
    assert queued_cmd["device"] == "led_17"
    assert queued_cmd["method"] == "on"
    assert isinstance(queued_cmd["future"], asyncio.Future) 

@pytest.mark.asyncio
async def test_rpc_handler_handles_mqtt_v5_request_response(mock_hardware_manager_for_rpc, mock_mqtt_client_for_rpc):
    """Verifies that the RPC handler extracts MQTT v5 Request/Response properties."""
    handler = RPCHandler(hardware_manager=mock_hardware_manager_for_rpc, broker_publish_method=mock_mqtt_client_for_rpc.publish)
    
    topic = "pi/rpc/commands"
    payload = json.dumps({"device": "led_17", "method": "on"}).encode('utf-8')
    properties = MockProperties(response_topic="client/123/response", correlation_data=b"req-abc")
    
    await handler.mqtt_message_handler(topic, payload, properties)
    
    queued_cmd = mock_hardware_manager_for_rpc.inbound_command_queue.put_nowait.call_args[0][0]
    assert queued_cmd["rpc_response_topic"] == "client/123/response"
    assert queued_cmd["correlation_data"] == b"req-abc"

@pytest.mark.asyncio
async def test_rpc_handler_publishes_success_response_on_hardware_success(mock_hardware_manager_for_rpc, mock_mqtt_client_for_rpc):
    """Tests that a success response is published back to the client."""
    handler = RPCHandler(hardware_manager=mock_hardware_manager_for_rpc, broker_publish_method=mock_mqtt_client_for_rpc.publish)
    
    topic = "pi/rpc/commands"
    payload = json.dumps({"device": "led_17", "method": "on"}).encode('utf-8')
    properties = MockProperties(response_topic="client/123/response", correlation_data=b"req-abc")

    await handler.mqtt_message_handler(topic, payload, properties)
    queued_cmd = mock_hardware_manager_for_rpc.inbound_command_queue.put_nowait.call_args[0][0]
    future: asyncio.Future = queued_cmd["future"]
    
    # Simulate success
    future.set_result({"state": "ON"}) 
    await asyncio.sleep(0.01) # Yield to the event loop
    
    # Assert response
    mock_mqtt_client_for_rpc.publish.assert_called_once()
    args, kwargs = mock_mqtt_client_for_rpc.publish.call_args
    
    publish_args = args[0]
    
    assert publish_args.response_topic == "client/123/response"    
    assert b"ON" in publish_args.result['state'].encode('utf-8')
    assert publish_args.correlation_data == b"req-abc"

@pytest.mark.asyncio
async def test_rpc_handler_publishes_error_response_on_hardware_failure(mock_hardware_manager_for_rpc, mock_mqtt_client_for_rpc):
    """Tests that an error response is published if hardware fails."""
    handler = RPCHandler(hardware_manager=mock_hardware_manager_for_rpc, broker_publish_method=mock_mqtt_client_for_rpc.publish)
    
    topic = "pi/rpc/commands"
    payload = json.dumps({"device": "led_17", "method": "on"}).encode('utf-8')
    properties = MockProperties(response_topic="client/123/response", correlation_data=b"req-abc")
    
    await handler.mqtt_message_handler(topic, payload, properties)
    queued_cmd = mock_hardware_manager_for_rpc.inbound_command_queue.put_nowait.call_args[0][0]
    
    # Simulate failure
    queued_cmd["future"].set_exception(ValueError("Pin 17 is on fire"))
    await asyncio.sleep(0.01)
    
    mock_mqtt_client_for_rpc.publish.assert_called_once()
    
    args, kwargs = mock_mqtt_client_for_rpc.publish.call_args
    publish_args = args[0]
    assert b"error" in publish_args.status.encode('utf-8')
    assert b"on fire" in publish_args.message.encode('utf-8')

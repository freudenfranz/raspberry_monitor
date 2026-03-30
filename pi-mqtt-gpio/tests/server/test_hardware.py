from pi_mqtt_gpio.server.models import DeviceStatePayload
import pytest
import asyncio
import time
import sys
from unittest.mock import MagicMock, call
from gpiozero import LED, Button # Import the actual gpiozero classes (they'll be mocked by conftest)

# Import the HardwareManager
from pi_mqtt_gpio.server.hardware import HardwareManager

"""
Phase 2 Tests: The Core Bridge (Sync/Async).
Tests the functionality of the HardwareManager, ensuring safe and ordered
transfer of commands to hardware and events from hardware.
"""

# Dummy config so HardwareManager knows what devices to create in the tests!
DUMMY_CONFIG = {
    "devices": [
        {"name": "led_17", "pin": 17, "type": "LED"},
        {"name": "button_27", "pin": 27, "type": "Button"}
    ]
}

@pytest.mark.asyncio
async def test_hardware_manager_command_execution():
    """
    Tests that commands placed on the queue are picked up and executed by the worker thread.
    This uses gpiozero's MockFactory set up in conftest.py, so LED(17) is a mock LED.
    """
    # Create an instance of our HardwareManager
    manager = HardwareManager(
        async_loop=asyncio.get_running_loop(), 
        publish_callback=MagicMock(), # We don't care about publishing in this test
        config=DUMMY_CONFIG
    )
    
    # Initialize the gpiozero devices. These will be MockFactory's mock devices.
    manager.initialize_gpio_devices() 

    # Get references to the mock devices initialized by the manager
    mock_led = manager.devices["led_17"] 
    assert isinstance(mock_led, LED) # Verify it's a gpiozero.LED instance (backed by a mock pin)

    # Start the worker thread
    manager.start_worker_thread()

    # Define a command to turn on an LED
    command_on = {
        "device": "led_17",
        "method": "on",
        "args": [],
        "kwargs": {},
        "rpc_response_topic": None
    }
    command_off = {
        "device": "led_17",
        "method": "off",
        "args": [],
        "kwargs": {},
        "rpc_response_topic": None
    }

    # Place commands onto the queue
    manager.inbound_command_queue.put(command_on)
     # Allow time for worker thread to pick up and execute both commands
    await asyncio.sleep(0.1) 
    assert mock_led.is_lit is True # Should be on after on command

    manager.inbound_command_queue.put(command_off)
    # Allow time for worker thread to pick up and execute both commands
    await asyncio.sleep(0.1) 
    assert mock_led.is_lit is False # Should be off after both on/off commands

    # Clean up: stop the worker thread
    manager.stop_worker_thread()


@pytest.mark.asyncio
async def test_hardware_manager_event_handling():
    """
    Tests that gpiozero callbacks safely enqueue events to the async event queue.
    This simulates a button press on a mock button.
    """
    # Local asyncio Queue just for this test to capture the callbacks
    test_event_queue = asyncio.Queue()

    manager = HardwareManager(
        async_loop=asyncio.get_running_loop(),
        publish_callback=test_event_queue.put_nowait, # Route callbacks into our test queue!
        config=DUMMY_CONFIG
    )
    manager.initialize_gpio_devices()
    manager.setup_gpio_callbacks() # This sets up when_pressed/when_released

    mock_button = manager.devices["button_27"]
    assert isinstance(mock_button, Button) # Verify it's a gpiozero.Button instance

    # Simulate a button press using MockPin's drive_low method
    mock_button.pin.drive_low() 

    # Wait for the async loop to process the call_soon_threadsafe callback
    # The event should now be inside our test_event_queue
    received_event: DeviceStatePayload = await asyncio.wait_for(test_event_queue.get(), timeout=1)

    # Assert against the Object properties, not dictionary keys
    assert received_event.device == "button_27"
    assert received_event.event == "pressed"
    assert isinstance(received_event.timestamp, float) 

    # Simulate release
    mock_button.pin.drive_high()
    
    received_release_event: DeviceStatePayload = await asyncio.wait_for(test_event_queue.get(), timeout=1)
    assert received_release_event.event == "released"


@pytest.mark.asyncio
async def test_hardware_manager_blocks_private_method_access():
    """
    SECURITY TEST:
    Verifies that the HardwareManager rejects any attempt to execute
    methods or access properties that start with an underscore (e.g., __del__).
    This prevents severe reflection vulnerabilities.
    """
    manager = HardwareManager(async_loop=asyncio.get_event_loop(), publish_callback=MagicMock(), config={})
    
    # We must mock the devices dictionary so it finds the device
    mock_led = MagicMock()
    manager.devices = {"led_17": mock_led}
    
    # Create an asyncio Future to capture the exception
    future = asyncio.Future()

    # 1. The Malicious Command (Trying to call a dunder method)
    malicious_command = {
        "device": "led_17",
        "method": "__class__", # A classic Python reflection target
        "args": [],
        "kwargs": {},
        "future": future
    }

    # 2. Execute the command directly (bypassing the queue for faster testing)
    manager._execute_command(malicious_command)

    # Allow the event loop to process the call_soon_threadsafe callback
    await asyncio.sleep(0.01)

    # 3. Assertions
    # The Future MUST have an exception set on it
    assert future.exception() is not None
    
    # The exception MUST be a PermissionError (or similar security error)
    assert isinstance(future.exception(), PermissionError)
    
    # Check that the mock was never interacted with at all.
    assert len(mock_led.mock_calls) == 0
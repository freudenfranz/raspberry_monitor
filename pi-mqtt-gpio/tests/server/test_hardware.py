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

@pytest.mark.asyncio
async def test_hardware_manager_command_execution():
    """
    Tests that commands placed on the queue are picked up and executed by the worker thread.
    This uses gpiozero's MockFactory set up in conftest.py, so LED(17) is a mock LED.
    """
    # Create an instance of our HardwareManager
    manager = HardwareManager(async_loop=asyncio.get_event_loop())
    
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
    manager.inboud_command_queue.put(command_on)
     # Allow time for worker thread to pick up and execute both commands
    await asyncio.sleep(0.1) 
    assert mock_led.is_lit is True # Should be on after on command

    manager.inboud_command_queue.put(command_off)
    # Allow time for worker thread to pick up and execute both commands
    await asyncio.sleep(0.1) 
    assert mock_led.is_lit is False # Should be off after both on/off commands

    # Assert specific method calls (if needed, but testing state is better with MockFactory)
    # If you wanted to assert 'on' was called, you'd need to mock the LED *instance* if it didn't track calls.
    # MockFactory pins track their value, so checking state is often sufficient.
    
    # Clean up: stop the worker thread
    manager.stop_worker_thread()


@pytest.mark.asyncio
async def test_hardware_manager_event_handling():
    """
    Tests that gpiozero callbacks safely enqueue events to the async event queue.
    This simulates a button press on a mock button.
    """
    manager = HardwareManager(async_loop=asyncio.get_event_loop())
    manager.initialize_gpio_devices()
    manager.setup_gpio_callbacks() # This sets up when_pressed/when_released

    mock_button = manager.devices["button_27"]
    assert isinstance(mock_button, Button) # Verify it's a gpiozero.Button instance

    # Store the expected event for later comparison
    expected_event = {"device": "button_27", "event_type": "pressed", "timestamp": float} # Timestamp will be float, check type
    
    # Simulate a button press using MockPin's drive_low method
    # This directly simulates the electrical change that gpiozero would detect
    mock_button.pin.drive_low() 
    await asyncio.sleep(0.1) 

    # The event should now be in the async event_queue
    received_event = await asyncio.wait_for(manager.outbound_event_queue.get(), timeout=1)

    assert received_event["device"] == expected_event["device"]
    assert received_event["event_type"] == expected_event["event_type"]
    assert isinstance(received_event["timestamp"], float) # Check timestamp type

    # Simulate release
    mock_button.pin.drive_high()
    received_release_event = await asyncio.wait_for(manager.outbound_event_queue.get(), timeout=1)
    assert received_release_event["event_type"] == "released"
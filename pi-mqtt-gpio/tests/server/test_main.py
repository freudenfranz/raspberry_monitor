import pytest
import asyncio
from unittest.mock import patch, AsyncMock, MagicMock

# Import the function we want to test
from pi_mqtt_gpio.server.main import main_application_runner, shutdown

@pytest.fixture
def mock_config():
    """Provides a fake configuration dictionary."""
    return {
        "mqtt": {"host": "localhost", "port": 1883},
        "devices": [{"name": "test_led", "pin": 17, "type": "LED"}]
    }

@pytest.mark.asyncio
# We use @patch to replace the real classes with fake ones ONLY during this test
@patch('pi_mqtt_gpio.server.main.load_config')
@patch('pi_mqtt_gpio.server.main.HardwareManager')
@patch('pi_mqtt_gpio.server.main.MQTTManager')
async def test_main_orchestrates_startup_and_wiring(
    MockMQTTManager, 
    MockHardwareManager, 
    mock_load_config, 
    mock_config
):
    """
    Tests that main_application_runner correctly instantiates and wires
    the core managers together based on the configuration.
    """
    # 1. Setup the mocks
    mock_load_config.return_value = mock_config
    
    # Create fake instances that the Mock classes will return
    mock_hw_instance = MagicMock()
    mock_mqtt_instance = MagicMock()
    mock_mqtt_instance.start = AsyncMock() # start() is async!
    mock_mqtt_instance.stop = AsyncMock()  # stop() is async!
    
    MockHardwareManager.return_value = mock_hw_instance
    MockMQTTManager.return_value = mock_mqtt_instance

    # 2. Run the main function as a background task
    # (Because main_application_runner contains an infinite loop `await asyncio.Future()`,
    # we CANNOT just await it directly, or the test will hang forever!)
    main_task = asyncio.create_task(main_application_runner())
    
    # Give the task a tiny moment to execute its startup sequence
    await asyncio.sleep(0.1)

    # 3. Assertions: Did it do its job?
    
    # Did it load config?
    mock_load_config.assert_called_once_with("config.yaml")
    
    # Did it initialize hardware with the config list?
    mock_hw_instance.initialize_gpio_devices.assert_called_once()
    
    # Did it wire the Gateway Method? (Inversion of Control)
    # We assert that HardwareManager was instantiated with the correct arguments
    # Look at the 'kwargs' of the call to ensure the callback was passed correctly
    _, kwargs = MockHardwareManager.call_args
    assert kwargs['publish_callback'] == mock_mqtt_instance.publish_hardware_event
    
    # Did it start the services?
    mock_hw_instance.start_worker_thread.assert_called_once()
    mock_mqtt_instance.start.assert_awaited_once()

    # 4. Cleanup: Cancel the infinite loop so the test can finish
    main_task.cancel()
    try:
        await main_task
    except asyncio.CancelledError:
        pass


@pytest.mark.asyncio
async def test_shutdown_sequence():
    """
    Tests that the shutdown handler stops services in the correct order.
    """
    # Setup fakes
    mock_loop = MagicMock()
    mock_loop.stop = MagicMock()
    
    mock_mqtt = MagicMock()
    mock_mqtt.stop = AsyncMock()
    
    mock_hw = MagicMock()
    mock_hw.stop_worker_thread = MagicMock()

    # Call the shutdown function
    await shutdown("SIGINT", mock_loop, mock_mqtt, mock_hw)

    # Assert correct shutdown order
    mock_mqtt.stop.assert_awaited_once()
    mock_hw.stop_worker_thread.assert_called_once()
    mock_loop.stop.assert_called_once()
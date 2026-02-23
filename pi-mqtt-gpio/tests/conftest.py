"""
Pytest Configuration and Fixtures for the pi_mqtt_gpio project.

This module provides essential mocks for hardware-specific libraries (like gpiozero)
to enable tests to run on any development machine, not just a Raspberry Pi.
"""

import sys
from unittest.mock import MagicMock
import pytest
import logging

# --- Hardware Mocking for Cross-Platform Testing ---

# Create a fake 'lgpio' module if not running on a Pi
# This prevents ImportError when gpiozero tries to import it, or when our code does.
# This part remains as lgpio itself is a C library, not a Python mockable object.
mock_lgpio_module = MagicMock()
if 'lgpio' not in sys.modules:
    sys.modules['lgpio'] = mock_lgpio_module

# --- Configure GPIO Zero to use MockFactory ---
# This is the core change. We hijack gpiozero's pin factory.
try:
    from gpiozero import Device
    from gpiozero.pins.mock import MockFactory, MockPWMPin
    
    # We create a single instance of MockFactory
    # MockPWMPin is used because our project expects hardware PWM capabilities
    # Read https://gpiozero.readthedocs.io/en/stable/api_pins.html for more details on pin factories.
    _mock_factory_instance = MockFactory(pin_class=MockPWMPin)
    
    # We patch Device.pin_factory at the module level.
    # This means any call to LED(pin), Button(pin) etc. will use our mock factory.
    Device.pin_factory = _mock_factory_instance

    # We still keep a mock_gpiozero_module reference for general mocking if needed,
    # but actual LED/Button objects will be created by gpiozero's own MockFactory.
    # This just ensures 'gpiozero' is in sys.modules if it wasn't there before.
    if 'gpiozero' not in sys.modules:
        sys.modules['gpiozero'] = MagicMock() # A generic mock
        sys.modules['gpiozero'].pins = MagicMock() # Mock the pins submodule
        sys.modules['gpiozero'].pins.mock = MagicMock() # Mock the mock submodule
        sys.modules['gpiozero'].pins.mock.MockFactory = MockFactory
        sys.modules['gpiozero'].pins.mock.MockPWMPin = MockPWMPin
        sys.modules['gpiozero'].Device = Device # Ensure Device is also accessible

    print("GPIO Zero configured with MockFactory for testing.")

except ImportError:
    # Fallback for systems where even gpiozero isn't installed (unlikely with .dev install)
    print("Warning: gpiozero or its mock factory not found. Using generic MagicMocks.")
    if 'gpiozero' not in sys.modules:
        sys.modules['gpiozero'] = MagicMock()
        sys.modules['gpiozero'].LED = MagicMock()
        sys.modules['gpiozero'].Button = MagicMock()
        sys.modules['gpiozero'].Motor = MagicMock()

@pytest.fixture(scope="session", autouse=True)
def setup_test_logging():
    """
    Configures the Python logging framework globally for all tests.
    Because tests bypass main.py, this ensures our logs are formatted
    and visible exactly how we want them during test runs.
    """
    # 1. Define how you want the log messages to look.
    # Hint: Look up `logging.Formatter` please keep the same distance between levelname to the message! 
    formatter = logging.Formatter(fmt="%(levelname)-8s %(message)s - %(funcName)s:%(lineno)d ")
    # 2. Create a handler that tells the logs where to go (e.g., the console).
    # Hint: Look up `logging.StreamHandler`
    handler = logging.StreamHandler(stream=sys.stdout) # Default to standard output, but can be customized if needed
    # 3. Attach your formatter to your handler.
    handler.setFormatter(formatter)
    # 4. Get the "root" logger (the parent of all loggers).
    # Hint: `logging.getLogger()` without a name returns the root.
    logger = logging.getLogger()
    # 5. Set the minimum log level for the root logger (e.g., DEBUG or INFO).
    logger.setLevel(logging.DEBUG)
    # 6. Add your handler to the root logger.
    logger.addHandler(handler) # Add your handler to the root logger

@pytest.fixture(autouse=True)
def reset_mock_gpio_pins_before_each_test():
    """
    Resets the MockFactory's pins before each test to ensure a clean state.
    This fixture is autoused, meaning it runs automatically for every test.
    """
    if '_mock_factory_instance' in globals():
        _mock_factory_instance.reset()
    # If there are other specific mocks that need resetting, add them here
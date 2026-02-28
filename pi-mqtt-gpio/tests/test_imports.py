"""
Phase 1 Tests: Verify package structure and module imports.
Ensures that the core application modules can be imported without syntax errors,
confirming correct package setup and path configuration.
"""

def test_server_imports():
    """Assert that the server modules can be imported without syntax errors."""
    try:
        import pi_mqtt_gpio.server.main
        import pi_mqtt_gpio.server.mqtt
        import pi_mqtt_gpio.server.hardware
        import pi_mqtt_gpio.server.security
        import pi_mqtt_gpio.server.rpc_handler
        success = True
    except ImportError as e:
        success = False
        print(f"Server Import Failed: {e}")
        
    assert success is True


def test_client_imports():
    """Assert that the client modules can be imported without syntax errors."""
    try:
        import pi_mqtt_gpio.client.connection
        import pi_mqtt_gpio.client.devices
        success = True
    except ImportError as e:
        success = False
        print(f"Client Import Failed: {e}")
        
    assert success is True

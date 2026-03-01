"""
Hardware Management and the Async/Sync Bridge.

This module contains the `HardwareManager` class, which is the core
of the concurrency model. It is responsible for:
- Initializing and holding `gpiozero` objects (LED, Button, Motor, etc.).
- Managing the Command Queue (network -> hardware) for sequential execution.
- Managing the Event Queue (hardware -> network) for safe event propagation.
- Running the single, dedicated worker thread for synchronous hardware operations.
- Setting up `gpiozero` event callbacks using `loop.call_soon_threadsafe`.
- Dynamically executing hardware commands based on RPC requests.
"""
import asyncio
import logging as log
import queue
import threading
import functools # Will be used for partial function application in gpiozero callbacks

# These imports will use the mocked gpiozero on non-Pi systems
# and the real one on a Pi (due to pyproject.toml optional dependencies)
from gpiozero import Device, LED, Button, Motor
from pi_mqtt_gpio.server.models import DeviceStatePayload # Placeholder for device types
# from gpiozero.pins.lgpio import LGPIONoSerial, LGPIOFactory # Will be used for factory setup

# Map string names to classes
DEVICE_CLASSES = {
    "LED": LED,
    "Button": Button,
    "Motor": Motor
}

logger = log.getLogger(__name__)

class HardwareManager:
    config: dict
    async_loop: asyncio.BaseEventLoop # reference to the main asyncio event loop
    devices: dict[str, Device] # instantiated gpiozero device objects
    
    # To make sure hardware is accessed sequentially and safely, we use a standard `queue.Queue` for commands.
    # This allows the worker thread to block on `get()` while the broker thread can continue to enqueue commands without blocking.
    inbound_command_queue: queue.Queue # queue for inbound commands (write: Async broker -> Sync writes)
    
    _worker_thread: threading.Thread | None # It can be a Thread object or None
    _worker_running: threading.Event
    
    publish_callback: callable
    #TODO: should we limit the size of these queues to prevent memory issues? (e.g., maxsize=100) including errorhandling
    
    """
    Manages gpiozero devices and the bridge between asyncio and synchronous hardware operations.
    """
    def __init__(self, async_loop: asyncio.BaseEventLoop, publish_callback: callable, config:dict):
        self.config = config
        self.async_loop = async_loop
        self.devices: dict[str, Device] = {}
        self.inbound_command_queue = queue.Queue()
        # Initialize a `threading.Thread` for the worker and a `threading.Event` to control its lifecycle
        self._worker_thread = None
        self._worker_running = threading.Event()
        self._publish_hardware_event = None # This will be set by the broker when it starts, allowing us to publish events from the worker thread
        self._publish_callback = publish_callback

    def initialize_gpio_devices(self):
        """
        Loads configuration from a config file and creates gpiozero device objects.
        For MVP, hardcode a few devices (e.g., LED, Button) for testing.
        Ensure gpiozero's pin factory is set to LGPIOFactory on a real Pi,
        or relies on mocks in the test environment.
        """
        device_config = self.config.get("devices", [])

        for dev_conf in device_config:
            name = dev_conf.get("name")
            pin = dev_conf.get("pin")
            type_name = dev_conf.get("type")
            
            if not all([name, pin, type_name]):
                logger.error(f"Invalid device config: {dev_conf}")
                continue
                
            device_class = DEVICE_CLASSES.get(type_name)
            if not device_class:
                logger.error(f"Unknown device type: {type_name}")
                continue
                
            try:
                # Instantiate (e.g., LED(17))
                # Note: This uses the factory set in conftest/main
                self.devices[name] = device_class(pin)
                logger.info(f"Initialized {name} ({type_name} on Pin {pin})")
            except Exception as e:
                logger.error(f"Failed to initialize {name}: {e}")

    def setup_gpio_callbacks(self):
        """
        Configures gpiozero event callbacks (`when_pressed`, `when_released`)
        to safely push events onto the async event queue via `call_soon_threadsafe`.
        """
        # Iterate through relevant gpiozero input devices in self.devices
        # For each device, use functools.partial to wrap `self.generic_event_handler`
        # Assign the partial function to gpiozero callbacks (e.g., button.when_pressed)
        
        if "button_27" in self.devices:
            button:Device = self.devices["button_27"]
            
            # Use functools.partial to create a callback that includes device_name and event_type
            # This allows our generic_event_handler to know which button and what event occurred
            button.when_pressed = functools.partial(self.generic_event_handler, "button_27", button, event="pressed")
            button.when_released = functools.partial(self.generic_event_handler, "button_27", button, event="released")
            logger.debug("Configured callbacks for button_27.")
        else:
            logger.warning("no device found. Callbacks not configured for it.")

    def start_worker_thread(self):
        """
        Starts the dedicated synchronous worker thread if it's not already running.
        """
        # Set the flag to allow the worker loop to run
        # Create and start the `threading.Thread` instance
        # Set the thread as a daemon to allow the main process to exit
        if self._worker_thread is None or not self._worker_thread.is_alive():
            self._worker_running.set() # Allow the worker loop to run
            self._worker_thread = threading.Thread(target=self._worker_loop, name="HardwareWorker", daemon=True )
            self._worker_thread.start()
            logger.info("Hardware worker thread started.")
        else:
            logger.warning("Attempted to start worker thread, but it's already running.")

    def stop_worker_thread(self):
        """
        Signals the worker thread to stop and waits for it to finish.
        """
        # Clear the flag to stop the worker loop
        # Put a sentinel value (e.g., None) into the command queue to unblock the worker if it's waiting
        # Join the worker thread to wait for its graceful termination
        if self._worker_thread and self._worker_thread.is_alive():
            self._worker_running.clear() # Signal the worker loop to stop
            self.inbound_command_queue.put(None) # Sentinel value to unblock the worker if it's waiting
            self._worker_thread.join() # Wait for the worker thread to finish
            logger.info("Hardware worker thread stopped.")
        else:
            logger.warning("Attempted to stop worker thread, but it was not running.")

    def _worker_loop(self):
        """
        The main loop for the synchronous hardware worker thread.
        It continuously pulls commands from the command_queue and executes them.
        """
        # Loop while the running flag is set
        # Get commands from the command_queue (blocking call with timeout)
        # Handle sentinel value for graceful shutdown
        # Call `_execute_command` for actual hardware interaction
        # Implement basic error handling for command execution
        # Ensure `command_queue.task_done()` is called
        logger.info("Hardware worker loop has started.")
       
        while self._worker_running.is_set():
            try:
                # timeout as needed so is_set() can be checked regularly for shutdown. Adjust as necessary!
                command = self.inbound_command_queue.get(timeout=0.1) 
                if command is None: # Sentinel value for shutdown
                    logger.info("Worker loop received shutdown signal. Unblocking...")
                    self.inbound_command_queue.task_done()
                    break
                try:
                    self._execute_command(command)
                except Exception as e:
                    logger.error(f"Error executing command: {e}")
                
                # We successfully got a command, so we MUST mark it done,
                # regardless of whether _execute_command succeeded or failed.
                self.inbound_command_queue.task_done()

            except queue.Empty:
                # No commands, just loop again to check _worker_running flag
                pass    
            except Exception as e:
                logger.error(f"Error in hardware worker thread: {e}")
                # TODO: What do we do with commands that resulted in an error?!
                # 1. Inform the caller somehow, as they did not get what they wanted.
            
        logger.info("Hardware worker loop has stopped.")

    def _execute_command(self, command: dict):
        """
        Executes a single hardware command on the appropriate gpiozero device.
        This method performs the dynamic method calling.
        """
        # Extract device_name, method_name, args, kwargs from the command dictionary
        # Retrieve the gpiozero object from self.devices
        # Use `getattr` to dynamically find the method on the device object
        # Call the method with its arguments and keyword arguments
        # Implement basic error handling for device/method not found or execution errors
        # (Future: Handle MQTT v5 RPC success/error response publishing)
        device_name = command.get("device")
        method_name = command.get("method")
        args = command.get("args", [])
        kwargs = command.get("kwargs", {})
        rpc_response_topic = command.get("rpc_response_topic") # For MQTT v5 RPC
        if device_name not in self.devices:
            error_msg = f"Device '{device_name}' not found."
            logger.error(f"Error: {error_msg}")
            # TODO: publish RPC error response
            return error_msg

        device_obj = self.devices[device_name]
        method_to_call = getattr(device_obj, method_name, None)
        
        if method_to_call is None:
            error_msg = f"Method '{method_name}' not found on device '{device_name}'"
            logger.error(f"Error: {error_msg}")
            # TODO: publish RPC error response
            return error_msg
        try:
            logger.debug(f"Attempting to execute command {method_name} on device '{device_name}'  with args={args} kwargs={kwargs}")
            result = method_to_call(*args, **kwargs)
            logger.debug(f"Command executed successfully. Result: {result}")
        except Exception as e:
            error_msg = f"Error executing command '{method_name}' on device '{device_name}': {e}"
            logger.error(f"Error: {error_msg}")
            # TODO: publish RPC error response
            return error_msg

    def generic_event_handler(self, device_name: str, device: Device, action: str):
        """
        This callback is assigned to gpiozero events. It runs in a separate thread.
        It safely enqueues the event payload onto the asyncio event_queue.
        """
        # Construct the event payload dictionary (device_name, event_type, timestamp)
        # Use `self.async_loop.call_soon_threadsafe` to safely put the event onto `self.event_queue`
        # Implement basic error handling for queueing failure
        event = DeviceStatePayload(device=device_name, event=action, value=device.value)

        # This is the 'magic': safely schedule a task on the main async loop from this worker thread
        try:
            self.async_loop.call_soon_threadsafe(self.publish_callback, event)
            logger.debug(f"Event published: {event.to_json()}")
        except Exception as e:
            logger.error(f"Error publishing event from hardware thread: {e}")


# --- Main Application Runner Placeholder (for local testing during development) ---
async def run_hardware_manager_test():
    """
    An asynchronous function to test the HardwareManager locally.
    This will eventually be integrated into `server/main.py`.
    """
    # Instantiate HardwareManager
    # Call its initialization and setup methods
    # Start the worker thread
    # Simulate placing commands onto the command_queue
    # Create an async task to consume events from the event_queue
    # Keep the event loop running
    # Ensure graceful shutdown on KeyboardInterrupt
    raise NotImplementedError("This is a placeholder for local testing of HardwareManager. It will be implemented in server/main.py.")

if __name__ == "__main__":
    # Placeholder for running the test function directly
    # Ensure it uses asyncio.run()
    raise NotImplementedError("This is a placeholder for local testing of HardwareManager. It will be implemented in server/main.py.")
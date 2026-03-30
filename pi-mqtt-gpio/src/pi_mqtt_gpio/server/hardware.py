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
from gpiozero import PWMLED, Device, LED, Button, Motor
from pi_mqtt_gpio.server.models import DeviceStatePayload # Placeholder for device types
# from gpiozero.pins.lgpio import LGPIONoSerial, LGPIOFactory # Will be used for factory setup

# Map string names to classes
DEVICE_CLASSES = {
    "LED": LED,
    "PWMLED": PWMLED,
    "Button": Button,
    "Motor": Motor,
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
    
    _publish_callback: callable
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
        self._publish_callback = publish_callback

    def initialize_gpio_devices(self):
        """
        WARNING: This config prevents malicious users from creating arbitrary devices. 
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
        Dynamically discovers and configures ALL gpiozero event callbacks.
        """
        callbacks_configured = 0

        for device_name, device_obj in self.devices.items():
            for attr_name in dir(device_obj):
                if attr_name.startswith("when_"):
                    action_name = attr_name.replace("when_", "")
                    
                    callback_func = functools.partial(
                        self.generic_event_handler,
                        device_name,
                        # Pass 'action_name' as a POSITIONAL argument, not a keyword argument.
                        action_name  
                    )

                    try:
                        setattr(device_obj, attr_name, callback_func)
                        callbacks_configured += 1
                        logger.debug(f"Bound generic handler to '{attr_name}' event on device '{device_name}'")
                    except Exception as e:
                        logger.warning(f"Could not set callback for '{attr_name}' on '{device_name}': {e}")

        logger.info(f"Dynamically configured {callbacks_configured} event callbacks.")

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
        target_attr = command.get("method") 
        raw_args = command.get("args", [])
        raw_kwargs = command.get("kwargs", {})
        
        try:
            # SECURITY CHECK: The "No Dunder" Rule
            # Reject any attempt to access private variables, methods, or Python magic methods.
            if not isinstance(target_attr, str) or str(target_attr).startswith("_"):
                    raise PermissionError(f"Access to private attribute '{target_attr}' is forbidden.")
            
            # Verify Device Exists
            device_obj = self.devices.get(device_name)
            if not device_obj:
                    raise ValueError(f"Device '{device_name}' not found in registry.")
            
            # The "Magic Translation" Step (for linking devices over MQTT)
            def resolve_arg(arg):
                if isinstance(arg, str) and arg.startswith("@device:"):
                    target_device_id = arg.split(":", 1)[1]
                    if target_device_id in self.devices:
                        if target_attr == "source":
                            return self.devices[target_device_id].values
                        return self.devices[target_device_id]
                    else:
                        raise ValueError(f"Cannot link to unknown device: {target_device_id}")
                return arg
            
            args = [resolve_arg(a) for a in raw_args]
            kwargs = {k: resolve_arg(v) for k, v in raw_kwargs.items()}

            # Get the target attribute safely (it's public, and the device exists)
            attr = getattr(device_obj, target_attr)

            # Execute or Assign    
            if callable(attr):
                # It is a function (e.g., led.on())
                logger.debug(f"Attempting to execute command {target_attr} on device '{device_name}'  with args={args} kwargs={kwargs}")
                result = attr(*args, **kwargs)
            else:
                # It is setting a property (e.g., led.value = 0.5)
                if args:
                    logger.debug(f"Attempting to set attribute {target_attr} on device '{device_name}'  with args={args} kwargs={kwargs}")    
                    setattr(device_obj, target_attr, args[0])
                    # If we just set 'source', don't read it back (it's a generator)
                    if target_attr == "source":
                        result = f"Linked to {args[0]}" 
                    else:
                        # For simple things like .value, reading it back is fine
                        result = getattr(device_obj, target_attr)
                # Or reading a property (e.g., target_attr.is_pressed)
                else:
                    logger.debug(f"Attempting to execute command {target_attr} on device '{device_name}'  with args={args} kwargs={kwargs}")
                    result = attr
            
            # Resolve Success
            if "future" in command:
                self.async_loop.call_soon_threadsafe(command["future"].set_result, result)
        
        except Exception as e:
            logger.error(f"Error executing command '{target_attr}' on '{device_name}': {e}")
            if "future" in command:
                # This tells the RPCHandler that the command failed, allowing it to send an MQTT Error Response!
                self.async_loop.call_soon_threadsafe(command["future"].set_exception, e)

    def generic_event_handler(self, device_name: str, action: str, *args):
        """
        This callback is assigned to gpiozero events. It runs in a separate thread.
        It safely enqueues the event payload onto the asyncio event_queue.
        The '*args' parameter is used to soak up any unexpected positional
        arguments that gpiozero might send with its callbacks.
        """
        try:
            # Look up the device object using the name passed by the partial
            device = self.devices.get(device_name)
            if not device:
                logger.warning(f"Event received for unknown device: {device_name}")
                return

            event = DeviceStatePayload(device=device_name, event=action, value=device.value)

            # Safely schedule a task on the main async loop
            self.async_loop.call_soon_threadsafe(self._publish_callback, event)
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
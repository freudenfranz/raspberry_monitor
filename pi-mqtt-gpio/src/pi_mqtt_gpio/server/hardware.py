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
import logging
import queue
import threading
import time
import functools # Will be used for partial function application in gpiozero callbacks

# These imports will use the mocked gpiozero on non-Pi systems
# and the real one on a Pi (due to pyproject.toml optional dependencies)
from gpiozero import Device,LED, Button, Motor # Placeholder for device types
# from gpiozero.pins.lgpio import LGPIONoSerial, LGPIOFactory # Will be used for factory setup


class HardwareManager:
    async_loop: asyncio.BaseEventLoop # reference to the main asyncio event loop
    devices: dict[str, Device] # instantiated gpiozero device objects
    
    # To make sure hardware is accessed sequentially and safely, we use a standard `queue.Queue` for commands.
    # This allows the worker thread to block on `get()` while the broker thread can continue to enqueue commands without blocking.
    inbound_command_queue: queue.Queue # queue for inbound commands (write: Async broker -> Sync writes)
    
    # For events coming from hardware (e.g., button presses), we use an `asyncio.Queue` to allow the worker thread to safely enqueue events that the broker thread can consume and publish to MQTT.
    outbound_event_queue: asyncio.Queue # queue for outbound events (read: Sync reads -> Async broker)
    
    _worker_thread: threading.Thread | None # It can be a Thread object or None
    _worker_running: threading.Event
    
    #TODO: should we limit the size of these queues to prevent memory issues? (e.g., maxsize=100) including errorhandling
    
    """
    Manages gpiozero devices and the bridge between asyncio and synchronous hardware operations.
    """
    def __init__(self, async_loop: asyncio.BaseEventLoop):
        self.async_loop = async_loop
        self.devices: dict[str, Device] = {}
        self.inboud_command_queue = queue.Queue()
        self.outbound_event_queue = asyncio.Queue()
        # Initialize a `threading.Thread` for the worker and a `threading.Event` to control its lifecycle
        self._worker_thread = None
        self._worker_running = threading.Event()
    
    def initialize_gpio_devices(self):
        """
        Loads configuration (from a future config file) and creates gpiozero device objects.
        For MVP, hardcode a few devices (e.g., LED, Button) for testing.
        Ensure gpiozero's pin factory is set to LGPIOFactory on a real Pi,
        or relies on mocks in the test environment.
        """
        # Placeholder for setting gpiozero's pin_factory
        # Instantiate your hardcoded gpiozero devices and store them in self.devices
        # TODO: Initialize devices based on configuration file or over MQTT in the future!
        self.devices["led_17"] = LED(17)
        self.devices["button_27"] = Button(27)

    def setup_gpio_callbacks(self):
        """
        Configures gpiozero event callbacks (`when_pressed`, `when_released`)
        to safely push events onto the async event queue via `call_soon_threadsafe`.
        """
        # Iterate through relevant gpiozero input devices in self.devices
        # For each device, use functools.partial to wrap `self.generic_event_handler`
        # Assign the partial function to gpiozero callbacks (e.g., button.when_pressed)
        
        if "button_27" in self.devices:
            button = self.devices["button_27"]
            
            # Use functools.partial to create a callback that includes device_name and event_type
            # This allows our generic_event_handler to know which button and what event occurred
            button.when_pressed = functools.partial(self.generic_event_handler, "button_27", "pressed")
            button.when_released = functools.partial(self.generic_event_handler, "button_27", "released")
            logging.debug("Configured callbacks for button_27.")
        else:
            logging.warning("no device found. Callbacks not configured for it.")

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
            logging.info("Hardware worker thread started.")
        else:
            logging.warning("Attempted to start worker thread, but it's already running.")

    def stop_worker_thread(self):
        """
        Signals the worker thread to stop and waits for it to finish.
        """
        # Clear the flag to stop the worker loop
        # Put a sentinel value (e.g., None) into the command queue to unblock the worker if it's waiting
        # Join the worker thread to wait for its graceful termination
        if self._worker_thread and self._worker_thread.is_alive():
            self._worker_running.clear() # Signal the worker loop to stop
            self.inboud_command_queue.put(None) # Sentinel value to unblock the worker if it's waiting
            self._worker_thread.join() # Wait for the worker thread to finish
            logging.info("Hardware worker thread stopped.")
        else:
            logging.warning("Attempted to stop worker thread, but it was not running.")

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
        while self._worker_running.is_set():
            logging.info("Hardware worker loop has started.")
            try:
                # timeout as needed so is_set() can be checked regularly for shutdown. Adjust as necessary!
                command = self.inboud_command_queue.get(timeout=0.1) 
                if command is None: # Sentinel value for shutdown
                    logging.info("Worker loop received shutdown signal. Unblocking...")
                    break
                self._execute_command(command)
            except queue.Empty:
            # No commands, just loop again to check _worker_running flag
                pass    
            except Exception as e:
                logging.error(f"Error in hardware worker thread: {e}")
                # TODO: What do we do with commands that resulted in an error?!
                # 1. Inform the caller somehow, as they did not get what they wanted.
                # 2. Acknowledge that the QUEUE now contains one less item that requires further work.
                self.inboud_command_queue.task_done()   # Need to account for task if exception occurred while executing as well!

        logging.info("Hardware worker loop has stopped.")

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
            logging.error(f"Error: {error_msg}")
            # TODO: publish RPC error response
            return error_msg

        device_obj = self.devices[device_name]
        method_to_call = getattr(device_obj, method_name, None)
        
        if method_to_call is None:
            error_msg = f"Method '{method_name}' not found on device '{device_name}'"
            logging.error(f"Error: {error_msg}")
            # TODO: publish RPC error response
            return error_msg
        try:
            logging.debug(f"Attempting to execute command {method_name} on device '{device_name}'  with args={args} kwargs={kwargs}")
            result = method_to_call(*args, **kwargs)
            logging.debug(f"Command executed successfully. Result: {result}")
        except Exception as e:
            error_msg = f"Error executing command '{method_name}' on device '{device_name}': {e}"
            logging.error(f"Error: {error_msg}")
            # TODO: publish RPC error response
            return error_msg

    def generic_event_handler(self, device_name: str, event_type: str):
        """
        This callback is assigned to gpiozero events. It runs in a separate thread.
        It safely enqueues the event payload onto the asyncio event_queue.
        """
        # Construct the event payload dictionary (device_name, event_type, timestamp)
        # Use `self.async_loop.call_soon_threadsafe` to safely put the event onto `self.event_queue`
        # Implement basic error handling for queueing failure
        event_payload = {
            "device": device_name,
            "event_type": event_type,
            "timestamp": time.time() # Add a timestamp for better logging/analysis
        }
        
        # This is the 'magic': safely schedule a task on the main async loop from this worker thread
        try:
            self.async_loop.call_soon_threadsafe(self.outbound_event_queue.put_nowait, event_payload)
            logging.debug(f"Event enqueued: {event_payload}")
        except Exception as e:
            logging.error(f"Error enqueueing event from hardware thread: {e}")


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
    pass

if __name__ == "__main__":
    # Placeholder for running the test function directly
    # Ensure it uses asyncio.run()
    pass
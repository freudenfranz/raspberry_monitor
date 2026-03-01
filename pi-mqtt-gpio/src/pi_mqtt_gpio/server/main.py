"""
Main entry point for the Raspberry Pi MQTT GPIO Gatekeeper application.

This module is responsible for:
- Parsing configuration (e.g., from a YAML file).
- Initializing the HardwareManager.
- Initializing and starting the embedded MQTT broker.
- Setting up the Async/Sync bridge (event publisher).
- Managing the overall application lifecycle (start, stop).
- Potentially setting up command-line arguments.
"""

import asyncio
import logging 
import signal
import time

from pathlib import Path
from typing import Dict, Any

from pi_mqtt_gpio.server.config_loader import load_config
from pi_mqtt_gpio.server.hardware import HardwareManager
from pi_mqtt_gpio.server.models import DeviceStatePayload, SystemStatus, SystemStatusPayload, TelemetryPayload
from pi_mqtt_gpio.server.mqtt import MQTTManager 

def setup_logging():
    """
    Configures the global logging settings for the entire application.
    This should be called as early as possible during startup.
    """
    logging.basicConfig(
        level=logging.INFO,
        format='%(asctime)s [%(levelname)-8s] %(name)s.%(funcName)s: %(message)s'
    )
    pass

logger = logging.getLogger(__name__)

async def system_telemetry_loop(mqtt_manager: MQTTManager):
    """Background task for sending system health metrics."""
    logger.info("System telemetry loop started.")
    start_time = time.time()
    
    try:
        while True:
            # Gather system facts
            current_uptime = time.time() - start_time
            
            # Create the payload
            payload = TelemetryPayload(
                uptime=current_uptime,
                status=SystemStatus.RUNNING
            )
            
            # Publish facts using the MQTTManager's Gateway
            # Note: We do NOT need call_soon_threadsafe here, because this loop 
            # is an async task running ON the same event loop as the broker!
            mqtt_manager.publish_hardware_event(payload)
            
            # Sleep for 5 seconds
            await asyncio.sleep(5)

    except asyncio.CancelledError:
        logger.info("System telemetry loop stopped.")

async def shutdown(signal_name:str, loop:asyncio.BaseEventLoop, mqtt_manager:MQTTManager, hardware_manager:HardwareManager):
    """Graceful shutdown handler."""
    logger.info(f"Received exit signal {signal_name}...")
    
    # Send the Graceful Shutdown message before we stop the MQTT manager!
    goodbye_payload = TelemetryPayload(status='shutting_down')
    mqtt_manager.publish_hardware_event(goodbye_payload)
    logger.info(f"publishing shutdown message to telementry topic before stopping services...")
    
    # Also explicitly send the 'offline' status to the status topic, since the Last Will might not be delivered if MQTTManager is gracefully stopped.
    offline_payload = SystemStatusPayload(status='offline')
    # The topic should be pi/status as defined in your config
    mqtt_manager.publish_hardware_event(offline_payload)
    logger.info(f"publishing shutdown message to {mqtt_manager.status_topic} before stopping services...")
    
    await asyncio.sleep(0.1) # Give it a moment to publish before we tear down the broker
    
    # Stop MQTT Manager (Async)
    await mqtt_manager.stop()
    
    # Stop Hardware Manager (Sync)
    hardware_manager.stop_worker_thread()
    
    # Cancel all running tasks (like the telemetry loop)
    tasks = [t for t in asyncio.all_tasks() if t is not asyncio.current_task()]
    for task in tasks:
        task.cancel()
    
    # Await cancellation to finish safely
    await asyncio.gather(*tasks, return_exceptions=True)
    
    # Stop the loop
    loop.stop()
    
async def main_application_runner():
    setup_logging()
    logger.info("Starting Gatekeeper...")

    # Load config
    script_dir = Path(__file__).parent
    config:Dict[str, Any] = load_config(script_dir / "config.yaml")
    
    # Get loop
    loop = asyncio.get_event_loop()
    
    # Instantiate MQTTManager (Needs event_queue, config)
    event_queue = asyncio.Queue()
    mqtt_manager = MQTTManager(event_queue=event_queue, config=config)

    # Instantiate HardwareManager
    hardware_manager = HardwareManager(async_loop=loop, publish_callback=mqtt_manager.publish_hardware_event, config=config)
    
    # Initialize GPIO Devices
    hardware_manager.initialize_gpio_devices()
    
    # Start Services
    hardware_manager.setup_gpio_callbacks()
    hardware_manager.start_worker_thread() # Starts the GPIO event loop in a separate thread
    await mqtt_manager.start() # Starts the MQTT loop in the background

    # Start Telemetry Loop as a background task
    telemetry_task = asyncio.create_task(system_telemetry_loop(mqtt_manager))

    # Setup Signal Handlers for OS interrupts
    # This tells Python what to do when you press Ctrl+C in the terminal.
    for sig in (signal.SIGINT, signal.SIGTERM):
         loop.add_signal_handler(
             sig, 
             lambda s=sig: asyncio.create_task(shutdown(s, loop, mqtt_manager, hardware_manager))
         )

    logger.info("Gatekeeper is fully operational. Press Ctrl+C to exit.")
    
    # 9. The Infinite Wait
    try:
        await asyncio.Future() 
    except asyncio.CancelledError:
        pass

if __name__ == "__main__":
    try:
        asyncio.run(main_application_runner())
    except KeyboardInterrupt:
        # Handled by the signal handler, but good to catch here just in case.
        pass
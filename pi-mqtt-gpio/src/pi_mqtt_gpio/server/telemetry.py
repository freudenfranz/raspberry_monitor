"""
System Telemetry and Health Monitoring.

Responsible for:
- Tracking application uptime.
- Monitoring Raspberry Pi hardware health (CPU Temp, RAM, etc.).
- Publishing periodic heartbeat/telemetry payloads via MQTT.
"""
import asyncio
import logging
import time

# Optional: Uncomment if you want actual hardware stats
# import psutil
# from gpiozero import CPUTemperature

from pi_mqtt_gpio.server.models import TelemetryPayload, SystemStatus
from pi_mqtt_gpio.server.mqtt import MQTTManager

logger = logging.getLogger(__name__)

class TelemetryMonitor:
    def __init__(self, mqtt_manager: MQTTManager, interval_seconds: int = 5):
        self.mqtt_manager = mqtt_manager
        self.interval = interval_seconds
        self.start_time = time.time()
        self._main_task = None
        
        # Optional: Initialize hardware readers here
        # self.cpu = CPUTemperature()

    async def start(self):
        """Launches the telemetry loop in the background."""
        logger.info(f"Starting System Telemetry Monitor (every {self.interval}s)...")
        self.start_time = time.time() # Reset uptime on start
        self._main_task = asyncio.create_task(self._loop())

    async def stop(self):
        """Cancels the telemetry loop."""
        if self._main_task:
            logger.info("Stopping Telemetry Monitor...")
            self._main_task.cancel()
            try:
                await self._main_task
            except asyncio.CancelledError:
                logger.info("Telemetry Monitor stopped.")

    def publish_shutdown_message(self):
        """Publishes the final goodbye message before the app dies."""
        goodbye_payload = TelemetryPayload(status='shutting_down')
        self.mqtt_manager.publish_hardware_event(goodbye_payload)
        logger.info("Published 'shutting_down' telemetry message.")

    async def _loop(self):
        """The background loop that gathers and sends metrics."""
        try:
            while True:
                current_uptime = time.time() - self.start_time
                
                # Create the payload (Add temperature/CPU here later if you want)
                payload = TelemetryPayload(
                    uptime=current_uptime,
                    status=SystemStatus.RUNNING
                    # temperature=round(self.cpu.temperature, 1) 
                )
                
                # Publish using the MQTTManager's Gateway
                self.mqtt_manager.publish_hardware_event(payload)
                
                # Sleep until next tick
                await asyncio.sleep(self.interval)

        except asyncio.CancelledError:
            # We catch this silently here because stop() handles the logging
            pass
        except Exception as e:
            logger.error(f"Error in telemetry loop: {e}")
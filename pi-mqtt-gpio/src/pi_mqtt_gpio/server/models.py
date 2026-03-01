"""
Data Models for Internal Communication and MQTT Payloads.

Defines a hierarchy of models to ensure consistency across 
Hardware, Broker, and Network layers.
"""
from dataclasses import dataclass, field, asdict
import json
from typing import Any, Dict, List, Optional
import time

from enum import Enum
class SystemStatus(str, Enum):
    RUNNING = "running"
    SHUTTING_DOWN = "shutting_down"
    ERROR = "error" 

# --- Base Classes (The "Blueprints") ---

@dataclass(frozen=True, kw_only=True) 
class BasePayload:
    """Base class for all JSON payloads sent over MQTT."""
    timestamp: int = field(default_factory=time.time_ns)

    def to_json(self) -> str:
        """Converts the object to a JSON string."""
        return json.dumps(asdict(self))

    def to_bytes(self) -> bytes:
        """Converts the object to UTF-8 encoded bytes for MQTT."""
        return self.to_json().encode('utf-8')

# --- The "Letters" (Content Variants) ---

@dataclass(frozen=True, kw_only=True)
class DeviceStatePayload(BasePayload):
    """Payload representing a hardware event/monitoring update."""
    device: str
    event: str
    value: Any

@dataclass(frozen=True, kw_only=True)
class RPCCommandPayload(BasePayload):
    """Payload representing a command request from a client."""
    device: str
    method: str
    args: List[Any] = field(default_factory=list)
    kwargs: Dict[str, Any] = field(default_factory=dict)

@dataclass(frozen=True, kw_only=True)
class LogPayload(BasePayload):
    """Payload for remote logging/telemetry."""
    level: str
    module: str
    message: str

@dataclass(frozen=True, kw_only=True)
class TelemetryPayload(BasePayload):
    """Payload representing system health metrics."""
    cpu_temp: float = 0.0 # Optional, for future use
    uptime: float = 0.0
    status: SystemStatus = SystemStatus.RUNNING # status can be "running", "shutting_down", "error", etc.
    
# --- The "Envelope" (The MQTT Context) ---

@dataclass(frozen=True)
class MQTTMessage:
    """
    Represents a full MQTT message (Envelope + Letter).
    This is what the Broker handles.

    Make sure to exactly match the parameter names of the amqtt.broker.publish method,
    since we will use the spread operator to pass this directly to it.
    """
    topic: str
    message: BasePayload
    qos: int = 0
    retain: bool = False
    
    # MQTT v5 Properties
    response_topic: Optional[str] = None
    correlation_data: Optional[bytes] = None

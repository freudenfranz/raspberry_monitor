"""
Data Models for Internal Communication and MQTT Payloads.

Defines a hierarchy of models to ensure consistency across 
Hardware, Broker, and Network layers.
"""
import asyncio
import base64
from dataclasses import dataclass, field, asdict
import json
from typing import Any, Dict, List, Optional
import time

from enum import Enum
class SystemStatus(str, Enum):
    RUNNING = "running"
    SHUTTING_DOWN = "shutting_down"
    ERROR = "error"
    ONLINE = "online"
    OFFLINE = "offline"

# --- Base Classes (The "Blueprints") ---

# Helper function for the JSON encoder
def custom_json_serializer(obj):
    """Custom JSON serializer for objects not serializable by default json code"""
    if isinstance(obj, bytes):
        # We can't send raw bytes, so we encode them as a Base64 string.
        # This is a standard way to represent binary data in JSON.
        return base64.b64encode(obj).decode('utf-8')
    
    # If we don't know what it is (like a generator), just return its string representation
    # This prevents the 'cannot pickle' or 'not JSON serializable' errors.
    try:
        return str(obj)
    except Exception:
        return f"<Unserializable {type(obj).__name__}>"
    
@dataclass(frozen=True, kw_only=True) 
class BasePayload:
    """Base class for all JSON payloads sent over MQTT."""
    timestamp: float = field(default_factory=time.time) 

    def to_json(self) -> str:
        """Converts the object to a JSON string, handling bytes correctly."""
        # Use the `default` argument to handle special types like bytes
        return json.dumps(asdict(self), default=custom_json_serializer)

    def to_bytes(self) -> bytes:
        """Converts the object to UTF-8 encoded bytes for MQTT."""
        return self.to_json().encode('utf-8')

# --- The "Letters" (Content Variants) ---

@dataclass(frozen=True, kw_only=True)
class SystemStatusPayload(BasePayload):
    """Payload representing the overall system's operational status."""    
    status: SystemStatus = field(default=SystemStatus.ONLINE)
    
@dataclass(frozen=True, kw_only=True)
class TelemetryPayload(BasePayload):
    """Payload representing system health metrics."""
    status: SystemStatus = field(default=SystemStatus.RUNNING)
    cpu_temp: float = 0.0 # Optional, for future use
    uptime: float = 0.0
    
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
    rpc_response_topic: str = field(default_factory=str)
    correlation_data: bytes = field(default_factory=bytes)
    future: asyncio.Future = field(default_factory=asyncio.Future)

@dataclass(frozen=True, kw_only=True)
class RPCResponsePayload(BasePayload):
    """Payload representing a command response to be sent back to the client."""
    response_topic: str
    status: str
    result: Any = None
    message: str = ""
    correlation_data: Optional[bytes] = None #
    
@dataclass(frozen=True, kw_only=True)
class LogPayload(BasePayload):
    """Payload for remote logging/telemetry."""
    level: str
    module: str
    message: str

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

    def to_aiomqtt_args(self) -> Dict[str, Any]:
        """Returns dict suitable for client.publish(**args)"""
        return {
            "topic": self.topic,
            "payload": self.message, # aiomqtt uses 'payload', not 'message'
            "qos": self.qos,
            "retain": self.retain,
            # Handle v5 properties if they are set
            **({'response_topic': self.response_topic} if self.response_topic else {}),
            **({'correlation_data': self.correlation_data} if self.correlation_data else {}),
        }
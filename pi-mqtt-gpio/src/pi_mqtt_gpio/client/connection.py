"""
MQTT v5 Client Connection and RPC Request/Response Management.

This module provides:
- A wrapper around `paho-mqtt` for connecting to the embedded broker.
- Logic for handling MQTT v5 Request/Response (RPC) patterns, including
  generating correlation IDs and managing pending responses.
- Automatic reconnection and error handling for the MQTT client.
"""

"""
Remote GPIO Device Stubs.

This module contains `gpiozero`-like classes (e.g., `RemoteLED`, `RemoteButton`, `RemoteMotor`)
that allow remote Python applications to interact with the Pi's GPIOs.
These classes translate high-level method calls into MQTT v5 RPC requests
sent via the `connection` module.
"""

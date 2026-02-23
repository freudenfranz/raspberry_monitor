"""
Security Components for the Embedded MQTT Broker and Hardware Access.

This module is responsible for:
- Implementing the custom `amqtt` Authenticator plugin for user validation.
- (Future) Implementing the Authorization (ACL) plugin for fine-grained permissions.
- Implementing the `ControlLeaseManager` to prevent conflicting write commands from multiple clients.
- Managing hashed user credentials.
"""

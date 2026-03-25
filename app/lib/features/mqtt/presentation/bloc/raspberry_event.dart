import 'package:equatable/equatable.dart';
import 'package:raspberry_monitor/features/mqtt/domain/entities/pi_system_status_entity.dart';
import 'package:raspberry_monitor/features/mqtt/domain/entities/pi_telemetry_entity.dart';

/// Base class for all events related to the Raspberry Pi monitoring.
sealed class RaspberryEvent extends Equatable {
  const RaspberryEvent();

  @override
  List<Object> get props => [];
}

/// Dispatched when the user wants to initiate a connection to the Pi.
class ConnectToPiStarted extends RaspberryEvent {
  const ConnectToPiStarted();
}

/// Dispatched when the user wants to sever the connection to the Pi.
class DisconnectFromPiStarted extends RaspberryEvent {
  const DisconnectFromPiStarted();
}

/// Internal event dispatched whenever a new status arrives from the stream.
class PiStatusReceived extends RaspberryEvent {
  const PiStatusReceived(this.status);

  /// The latest status entity received from the MQTT stream.
  final PiSystemStatusEntity status;

  @override
  List<Object> get props => [status];
}

/// Internal event dispatched whenever new telemetry data arrives from the stream.
class PiTelemetryReceived extends RaspberryEvent {
  const PiTelemetryReceived(this.telemetry);

  /// The latest telemetry entity received from the MQTT stream.
  final PiTelemetryEntity telemetry;

  @override
  List<Object> get props => [telemetry];
}

/// Internal event dispatched if the telemetry stream throws an error.
class PiStatusStreamError extends RaspberryEvent {
  const PiStatusStreamError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

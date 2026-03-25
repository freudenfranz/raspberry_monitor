import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:raspberry_monitor/features/mqtt/domain/entities/pi_system_status_entity.dart';
import 'package:raspberry_monitor/features/mqtt/domain/entities/pi_telemetry_entity.dart';
import 'package:raspberry_monitor/features/mqtt/presentation/bloc/raspberry_bloc.dart'
    show RaspberryBloc;

part 'raspberry_state.freezed.dart';

/// Base class for all states emitted by the [RaspberryBloc].
@freezed
sealed class RaspberryState with _$RaspberryState {
  /// The initial state before any connection attempts are made.
  const factory RaspberryState.initial() = RaspberryInitial;

  /// State emitted while the app is negotiating the MQTT connection.
  const factory RaspberryState.connecting() = RaspberryConnecting;

  /// State emitted when connected, but waiting for the first payload.
  const factory RaspberryState.connected() = RaspberryConnected;

  /// State emitted every time new telemetry data is successfully parsed.
  const factory RaspberryState.loaded({
    /// The current state of the Raspberry Pi.
    required PiSystemStatusEntity? status,
    required PiTelemetryEntity? telementry,
  }) = RaspberryLoaded;

  /// State emitted when the connection fails or the stream emits bad data.
  const factory RaspberryState.error({
    /// The user-facing error message.
    required String message,
  }) = RaspberryError;
}

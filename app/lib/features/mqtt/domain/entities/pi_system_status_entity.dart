import 'package:freezed_annotation/freezed_annotation.dart';

part 'pi_system_status_entity.freezed.dart';
part 'pi_system_status_entity.g.dart';

/// Represents the systems online status of the Raspberry Pi,
/// which is broadcasted by the Pi over MQTT.
@freezed
sealed class PiSystemStatusEntity with _$PiSystemStatusEntity {
  /// Creates a new[PiSystemStatusEntity] instance.
  ///
  /// All parameters are required to ensure the app always has a complete
  /// snapshot of the Raspberry Pi's current state.
  const factory PiSystemStatusEntity({
    /// The current online state of the raspberry system.
    required PiSystemStatus status,
  }) = _PiSystemStatusEntity;

  /// Creates a[PiSystemStatusEntity] from a JSON dictionary.
  ///
  /// This factory is automatically implemented by `json_serializable` and is
  /// used by the Repository layer to parse incoming MQTT string payloads.
  factory PiSystemStatusEntity.fromJson(Map<String, dynamic> json) =>
      _$PiSystemStatusEntityFromJson(json);
}

/// Various states of the remote pi system
enum PiSystemStatus {
  /// Raspberry is currently online
  running,

  /// Raspberry is currently shutting down
  shuttingDown,

  /// Raspberry is currently shutting down
  error,

  /// Raspberry is currently shutting down
  online,

  /// Raspberry is currently shutting down
  offline,
}

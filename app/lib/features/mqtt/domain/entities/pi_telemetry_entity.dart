import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:raspberry_monitor/features/mqtt/domain/entities/pi_system_status_entity.dart';

part 'pi_telemetry_entity.freezed.dart';
part 'pi_telemetry_entity.g.dart';

/// Represents the real-time system health and status of the Raspberry Pi.
///
/// This entity encapsulates telemetry data such as temperature, memory usage,
/// and CPU load, which is broadcasted by the Pi over MQTT.
@freezed
sealed class PiTelemetryEntity with _$PiTelemetryEntity {
  /// Creates a new[PiTelemetryEntity] instance.
  ///
  /// All parameters are required to ensure the app always has a complete
  /// snapshot of the Raspberry Pi's current state.
  const factory PiTelemetryEntity({
    /// The telemetry snapshots timestamp.
    @JsonKey(
      name: 'timestamp',
      fromJson: _dateTimeFromString,
      toJson: _dateTimeToString,
    )
    required DateTime timestamp,

    /// The current temperature of the Raspberry Pi's CPU in degrees Celsius.
    @JsonKey(name: 'cpu_temp') required double cpuTemperature,

    /// The current online state of the raspberry system.
    required PiSystemStatus status,

    /// The current percentage of RAM being used (e.g., 45.5 for 45.5%).
    //@JsonKey(name: 'ram_usage') required double ramUsage,

    /// The overall CPU usage percentage across all cores (e.g., 12.0 for 12%).
    //@JsonKey(name: 'cpu_usage') required double cpuUsage,

    /// The total system uptime in seconds.
    @JsonKey(name: 'uptime') required double uptime,

    /// The current percentage of disk/storage space used.
    //@JsonKey(name: 'disk_usage') required double diskUsage,
  }) = _PiTelemetryEntity;

  /// Creates a[PiTelemetryEntity] from a JSON dictionary.
  ///
  /// This factory is automatically implemented by `json_serializable` and is
  /// used by the Repository layer to parse incoming MQTT string payloads.
  factory PiTelemetryEntity.fromJson(Map<String, dynamic> json) =>
      _$PiTelemetryEntityFromJson(json);
}

DateTime _dateTimeFromString(double tstp) =>
    DateTime.fromMillisecondsSinceEpoch((tstp * 1000).round());
String _dateTimeToString(DateTime date) => date.toIso8601String();

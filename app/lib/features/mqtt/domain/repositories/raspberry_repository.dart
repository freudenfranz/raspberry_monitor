import 'package:dartz/dartz.dart';
import 'package:raspberry_monitor/core/error/failures.dart';
import 'package:raspberry_monitor/features/mqtt/domain/entities/pi_system_status_entity.dart';
import 'package:raspberry_monitor/features/mqtt/domain/entities/pi_telemetry_entity.dart';
// Adjust import path to match your project

/// Repository interface for managing Raspberry Pi monitoring operations.
///
/// Acts as the domain layer's gateway to the underlying MQTT data source,
/// translating exceptions into functional [Failure] objects and mapping
/// raw data models into pure domain entities.
abstract class RaspberryRepository {
  /// Attempts to connect to the Raspberry Pi's MQTT broker and subscribe
  /// to the necessary telemetry topics.
  ///
  /// Returns [Right] with `void` on success, or a [Left] containing a
  /// [Failure] (such as a ServerFailure) if the connection fails.
  Future<Either<Failure, void>> connectToPi();

  /// Gracefully disconnects from the Raspberry Pi's MQTT broker.
  ///
  /// Returns [Right] on success, or [Left] with a [Failure] on error.
  Future<Either<Failure, void>> disconnectFromPi();

  /// Provides a continuous stream of the Raspberry Pi's status.
  ///
  /// Emits [PiStatusEntity] objects whenever new telemetry data
  /// (e.g., temperature, CPU usage) is received from the broker.
  Stream<PiSystemStatusEntity> watchPiStatus();
  Stream<PiTelemetryEntity> watchPiTelemetry();
}

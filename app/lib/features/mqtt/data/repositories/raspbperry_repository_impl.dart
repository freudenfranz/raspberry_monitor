import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:raspberry_monitor/core/error/exceptions.dart';
import 'package:raspberry_monitor/core/error/failures.dart';
// Adjust import paths to match your project
import 'package:raspberry_monitor/features/mqtt/data/datasources/mqtt_remote_data_source.dart'
    show MQTTRemoteDataSource;
import 'package:raspberry_monitor/features/mqtt/domain/entities/pi_system_status_entity.dart';
import 'package:raspberry_monitor/features/mqtt/domain/entities/pi_telemetry_entity.dart';
import 'package:raspberry_monitor/features/mqtt/domain/repositories/raspberry_repository.dart'
    show RaspberryRepository;

/// Implementation of [RaspberryRepository] using[MQTTRemoteDataSource].
///
/// Handles the conversion of raw MQTT payloads into [PiStatusEntity]s
/// and catches[ServerException]s to yield [ServerFailure]s.
@LazySingleton(as: RaspberryRepository)
class RaspberryRepositoryImpl implements RaspberryRepository {
  /// Creates a [RaspberryRepositoryImpl].
  ///
  /// Requires a [remoteDataSource] to handle network communication with
  /// the MQTT broker.
  const RaspberryRepositoryImpl({required this.remoteDataSource});

  /// The remote data source used for low-level MQTT communication.
  final MQTTRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, void>> connectToPi() async {
    try {
      await remoteDataSource.connect();
      // Once connected, subscribe to the topics required by this repository
      remoteDataSource
        ..subscribe('pi/status')
        ..subscribe('pi/system/telemetry');
      return const Right(null);
    } on ServerException catch (e) {
      return Left(
        ServerFailure(userMessage: e.message ?? 'Could not connect to pi'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> disconnectFromPi() async {
    try {
      remoteDataSource.disconnect();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(
        ServerFailure(
          userMessage: e.message ?? 'Had a problem disconnecting from pi',
        ),
      );
    }
  }

  @override
  Stream<PiSystemStatusEntity> watchPiStatus() => remoteDataSource.messageStream
      // Filter out messages that don't belong to the status topic
      .where((msg) => msg.topic == 'pi/status')
      // Transform the raw payload into a domain entity
      .map((msg) {
        try {
          // Assuming the Pi sends data as JSON strings.
          // E.g.: {"status": "online"}
          final Map<String, dynamic> jsonMap = jsonDecode(msg.payload);

          // Assuming your entity has a factory constructor like fromJson or fromMap
          return PiSystemStatusEntity.fromJson(jsonMap);
        } on Exception {
          // If the Pi sends malformed data, throw an exception that the
          // stream listener (e.g., your BLoC) can catch.
          throw const FormatException('Failed to parse incoming Pi data.');
        }
      });

  @override
  Stream<PiTelemetryEntity> watchPiTelemetry() => remoteDataSource.messageStream
      // Filter out messages that don't belong to the status topic
      .where((msg) => msg.topic == 'pi/system/telemetry')
      // Transform the raw payload into a domain entity
      .map((msg) {
        try {
          // Assuming the Pi sends data as JSON strings.
          // E.g.: {"cpu_temp": 45.2, "ram_usage": 60}
          final Map<String, dynamic> jsonMap = jsonDecode(msg.payload);

          // Assuming your entity has a factory constructor like fromJson or fromMap
          return PiTelemetryEntity.fromJson(jsonMap);
        } on Exception {
          // If the Pi sends malformed data, throw an exception that the
          // stream listener (e.g., your BLoC) can catch.
          throw const FormatException(
            'Failed to parse incoming Pi telemetry data.',
          );
        }
      });
}

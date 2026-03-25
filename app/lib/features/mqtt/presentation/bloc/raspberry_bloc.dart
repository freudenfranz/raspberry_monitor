import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:raspberry_monitor/features/mqtt/domain/entities/pi_system_status_entity.dart';
import 'package:raspberry_monitor/features/mqtt/domain/entities/pi_telemetry_entity.dart';
import 'package:raspberry_monitor/features/mqtt/domain/repositories/raspberry_repository.dart'
    show RaspberryRepository;

import 'raspberry_event.dart';
import 'raspberry_state.dart';

/// Manages the state and business logic for the Raspberry Pi dashboard.
///
/// This BLoC handles the connection lifecycle to the MQTT broker, listens
/// to the real-time telemetry stream from the [RaspberryRepository], and
/// emits corresponding[RaspberryState]s to update the UI reactively.
///
@injectable
class RaspberryBloc extends Bloc<RaspberryEvent, RaspberryState> {
  /// Creates a new [RaspberryBloc] instance.
  ///
  /// Requires a [repository] to handle the underlying domain operations
  /// and data streaming. The BLoC begins in the[RaspberryInitial] state.
  RaspberryBloc({required this.repository}) : super(const RaspberryInitial()) {
    on<ConnectToPiStarted>(_onConnectToPiStarted);
    on<DisconnectFromPiStarted>(_onDisconnectFromPiStarted);
    on<PiStatusReceived>(_onPiStatusReceived);
    on<PiTelemetryReceived>(_onPiTelemetryReceived);
    on<PiStatusStreamError>(_onPiStatusStreamError);
  }

  /// The repository providing the domain-level operations and MQTT communication for the Raspberry Pi.
  final RaspberryRepository repository;

  // Private variable (does not trigger public member documentation warnings)
  StreamSubscription<PiSystemStatusEntity>? _statusSubscription;
  StreamSubscription<PiTelemetryEntity>? _telemetrySubscription;

  Future<void> _onConnectToPiStarted(
    ConnectToPiStarted event,
    Emitter<RaspberryState> emit,
  ) async {
    emit(const RaspberryConnecting());

    final failureOrSuccess = await repository.connectToPi();

    // Fold the Either result from the repository
    failureOrSuccess.fold(
      (failure) => emit(RaspberryError(message: failure.userMessage)),
      (_) {
        emit(const RaspberryConnected());

        // Cancel any existing subscription before starting a new one
        _statusSubscription?.cancel();

        // Start listening to status stream and mapping its outputs to BLoC events
        _statusSubscription = repository.watchPiStatus().listen(
          (status) {
            add(PiStatusReceived(status));
          },
          onError: (error) {
            add(PiStatusStreamError(error.toString()));
          },
        );

        // Start listening to telementry stream and mapping its outputs to BLoC events
        _telemetrySubscription = repository.watchPiTelemetry().listen(
          (telemetry) {
            add(PiTelemetryReceived(telemetry));
          },
          onError: (error) {
            add(PiStatusStreamError(error.toString()));
          },
        );
      },
    );
  }

  void _onPiStatusReceived(
    PiStatusReceived event,
    Emitter<RaspberryState> emit,
  ) {
    final currentState = state;
    if (currentState is RaspberryLoaded) {
      emit(
        RaspberryLoaded(
          status: event.status,
          telementry: currentState.telementry,
        ),
      );
    } else {
      emit(RaspberryLoaded(status: event.status, telementry: null));
    }
  }

  void _onPiTelemetryReceived(
    PiTelemetryReceived event,
    Emitter<RaspberryState> emit,
  ) {
    final currentState = state;
    if (currentState is RaspberryLoaded) {
      emit(
        RaspberryLoaded(
          status: currentState.status,
          telementry: event.telemetry,
        ),
      );
    } else {
      emit(RaspberryLoaded(status: null, telementry: event.telemetry));
    }
  }

  void _onPiStatusStreamError(
    PiStatusStreamError event,
    Emitter<RaspberryState> emit,
  ) {
    emit(RaspberryError(message: 'Stream error: ${event.message}'));
  }

  Future<void> _onDisconnectFromPiStarted(
    DisconnectFromPiStarted event,
    Emitter<RaspberryState> emit,
  ) async {
    await _statusSubscription?.cancel();
    await _telemetrySubscription?.cancel();
    await repository.disconnectFromPi();
    emit(const RaspberryInitial());
  }

  /// Closes the BLoC and performs necessary cleanup operations.
  ///
  /// Cancels the active MQTT stream subscription and gracefully disconnects
  /// from the broker before shutting down the BLoC.
  @override
  Future<void> close() {
    _statusSubscription?.cancel();
    repository.disconnectFromPi();
    return super.close();
  }
}

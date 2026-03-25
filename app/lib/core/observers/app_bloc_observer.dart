import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raspberry_monitor/core/util/logger.dart';

/// BLoC observer that logs state changes and transitions for debugging.
///
/// This observer helps with:
/// - Debugging state management issues
/// - Monitoring BLoC performance
/// - Tracking state transitions in development
class AppBlocObserver extends BlocObserver {
  /// Creates an instance of [AppBlocObserver].
  AppBlocObserver();

  /// Logger used to log Bloc events
  final _logger = logger(AppBlocObserver);

  @override
  void onCreate(BlocBase<dynamic> bloc) {
    super.onCreate(bloc);
    final name = bloc.runtimeType.toString();
    _logger.debug('onCreate: $name');
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);

    // Extract strings FIRST to prevent accidental stream evaluation
    final blocName = bloc.runtimeType.toString();
    final current = change.currentState.runtimeType.toString();
    final next = change.nextState.runtimeType.toString();

    _logger.debug('[onChange]($blocName): $current -> $next');
  }

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);

    final blocName = bloc.runtimeType.toString();
    final eventName = transition.event.runtimeType.toString();

    _logger.info('onTransition($blocName): $eventName');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);

    final blocName = bloc.runtimeType.toString();
    _logger.error('onError($blocName)', error: error, stackTrace: stackTrace);
  }

  @override
  void onClose(BlocBase<dynamic> bloc) {
    super.onClose(bloc);
    final name = bloc.runtimeType.toString();
    _logger.debug('onClose: $name');
  }
}

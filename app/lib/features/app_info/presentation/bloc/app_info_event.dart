import 'package:equatable/equatable.dart';

/// Events for AppInfoBloc
sealed class AppInfoEvent extends Equatable {
  /// Creates a new app info event
  const AppInfoEvent();

  @override
  List<Object?> get props =>[];
}

/// Event to load app information
final class LoadAppInfo extends AppInfoEvent {
  /// Creates load event
  const LoadAppInfo();
}

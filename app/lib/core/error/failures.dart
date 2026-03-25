import 'package:equatable/equatable.dart';

/// Base class for all failures in the domain layer
/// Failures represent expected errors that can occur during business logic execution
///
/// **Important**: [userMessage] is meant for end-user display and MUST be
/// internationalized (i18n'd) before showing in the UI. Use it as a key to
/// your translation system, or ensure it's marked for translation.
abstract class Failure extends Equatable {

  /// Creates a new failure
  const Failure({
    required this.userMessage,
    this.technicalDetails,
  });
  /// User-facing error message - MUST be i18n'd before display in UI.
  /// This signals to developers that the message is for end-users.
  final String userMessage;

  /// Technical error details for logging and debugging (NOT shown to user).
  /// Use this for detailed error information that helps with debugging.
  final String? technicalDetails;

  @override
  List<Object?> get props => [userMessage, technicalDetails];
}

// General failures

/// Failure when server operation fails
class ServerFailure extends Failure {
  /// Creates a server failure
  const ServerFailure({
    super.userMessage = 'An error occurred on the server',
    super.technicalDetails,
  });
}

/// Failure when cache operation fails
class CacheFailure extends Failure {
  /// Creates a cache failure
  const CacheFailure({
    super.userMessage = 'Failed to load cached data',
    super.technicalDetails,
  });
}

/// Failure when network operation fails
class NetworkFailure extends Failure {
  /// Creates a network failure
  const NetworkFailure({
    super.userMessage = 'Network connection failed',
    super.technicalDetails,
  });
}

/// Failure when input validation fails
class InvalidInputFailure extends Failure {
  /// Creates an invalid input failure
  const InvalidInputFailure({
    super.userMessage = 'Invalid input - please check your input and try again',
    super.technicalDetails,
  });
}

/// Failure when operation times out
class TimeoutFailure extends Failure {
  /// Creates a timeout failure
  const TimeoutFailure({
    super.userMessage = 'Request took too long',
    super.technicalDetails,
  });
}

/// Failure when data parsing fails
class DataParseFailure extends Failure {
  /// Creates a data parse failure
  const DataParseFailure({
    super.userMessage = 'Error processing server response',
    super.technicalDetails,
  });
}

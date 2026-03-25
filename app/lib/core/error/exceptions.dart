/// Base class for all exceptions in the data layer
/// Exceptions represent unexpected errors that can occur during data operations
/// and are caught and converted to Failures in repositories.
///
/// **Important**: Never let raw exceptions escape to the presentation layer.
/// Always catch exceptions in repositories and convert them to Failures.
abstract class AppException implements Exception {
  /// Creates a new app exception
  const AppException({this.message});

  /// The error message describing what went wrong
  final String? message;

  @override
  String toString() => message ?? runtimeType.toString();
}

// Network-related exceptions

/// Exception thrown when network connection is unavailable
class NetworkException extends AppException {
  /// Creates a network exception
  const NetworkException({super.message = 'Network connection failed'});
}

/// Exception thrown when a request times out
class TimeoutException extends AppException {
  /// Creates a timeout exception
  const TimeoutException({super.message = 'Request timeout'});
}

// Server/API exceptions

/// Exception thrown when server returns an error response
class ServerException extends AppException {
  /// Creates a server exception
  const ServerException({super.message = 'Server error', this.statusCode});

  /// HTTP status code from the server (if available)
  final int? statusCode;
}

// Data parsing exceptions

/// Exception thrown when data cannot be parsed
class DataParseException extends AppException {
  /// Creates a data parse exception
  const DataParseException({super.message = 'Failed to parse data'});
}

// Cache/Storage exceptions

/// Exception thrown when cache operation fails
class CacheException extends AppException {
  /// Creates a cache exception
  const CacheException({super.message = 'Cache operation failed'});
}

// Validation exceptions

/// Exception thrown when input validation fails
class ValidationException extends AppException {
  /// Creates a validation exception
  const ValidationException({required super.message});
}

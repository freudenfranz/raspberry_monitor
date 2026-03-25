import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

/// Creates a new logger instance scoped to the given [type].
/// Usage: `final _logger = logger(MyClass);`
Logger logger(Type type) => _LoggerImpl(type.toString());

/// Abstract logger interface to enforce consistent log levels.
/// Abstract logger interface to enforce a consistent API for logging
/// throughout the application.
abstract class Logger {
  /// Logs a message at the debug level.
  ///
  /// Typically used for fine-grained information only useful in a debugging context.
  void debug(String message, {Object? error, StackTrace? stackTrace});

  /// Logs a message at the info level.
  ///
  /// Used for tracking general application flow and state transitions.
  void info(String message, {Object? error, StackTrace? stackTrace});

  /// Logs a message at the warning level.
  ///
  /// Used for potentially harmful situations or non-critical errors
  /// that do not require immediate action but should be noted.
  void warning(String message, {Object? error, StackTrace? stackTrace});

  /// Logs a message at the error level.
  ///
  /// Used for serious errors, exceptions, and failures that
  /// indicate a problem in the application's operation.
  void error(String message, {Object? error, StackTrace? stackTrace});
}

class _LoggerImpl implements Logger {
  _LoggerImpl(this.name);

  final String name;

  // ANSI Color Codes for the local debug console.
  // These are ignored by production logging tools.
  static const String _reset = '\x1B[0m';
  static const String _gray = '\x1B[90m';
  static const String _blue = '\x1B[34m';
  static const String _yellow = '\x1B[33m';
  static const String _red = '\x1B[31m';
  static const String _cyan = '\x1B[36m';

  void _log(
    String levelName,
    String color,
    int level,
    String message,
    Object? error,
    StackTrace? stackTrace,
  ) {
    // Only use color codes in debug mode.
    final formattedMessage = kDebugMode
        ? '$color[${levelName.padRight(5)}] $_cyan$message$_reset'
        : '[${levelName.padRight(5)}] $message';

    developer.log(
      formattedMessage,
      name: name,
      level: level,
      error: error,
      stackTrace: stackTrace,
    );
  }

  @override
  void debug(String message, {Object? error, StackTrace? stackTrace}) {
    _log('DEBUG', _gray, 500, message, error, stackTrace);
  }

  @override
  void info(String message, {Object? error, StackTrace? stackTrace}) {
    _log('INFO', _blue, 800, message, error, stackTrace);
  }

  @override
  void warning(String message, {Object? error, StackTrace? stackTrace}) {
    _log('WARN', _yellow, 900, message, error, stackTrace);
  }

  @override
  void error(String message, {Object? error, StackTrace? stackTrace}) {
    _log('ERROR', _red, 1000, message, error, stackTrace);
  }
}

import 'package:internet_connection_checker/internet_connection_checker.dart';

/// Abstract interface for checking network connectivity
/// This abstraction allows for easier testing and swapping of implementations
abstract class NetworkInfo {
  /// Check if device is connected to network
  Future<bool> get isConnected;
}

/// Concrete implementation of NetworkInfo using the data_connection_checker_plus package
class NetworkInfoImpl implements NetworkInfo {

  /// Creates NetworkInfoImpl with the provided connection checker
  NetworkInfoImpl(this.connectionChecker);
  /// Internet connection checker dependency
  final InternetConnectionChecker connectionChecker;

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
}

import 'package:injectable/injectable.dart';

@lazySingleton
class MQTTConfig {
  /// The IP address or domain name of the MQTT broker.
  final String hostName = '127.0.0.1';

  /// A unique string identifying this client session to the broker.
  final String clientId = 'flutter_raspberry_monitor';

  /// The network port the MQTT broker is listening on.
  final int port = 1883;
}

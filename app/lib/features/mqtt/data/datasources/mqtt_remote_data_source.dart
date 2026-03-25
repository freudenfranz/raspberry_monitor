import 'package:raspberry_monitor/core/core.dart' show ServerException;
import 'package:raspberry_monitor/core/error/error.dart' show ServerException;
import 'package:raspberry_monitor/core/error/exceptions.dart'
    show ServerException;
import 'package:raspberry_monitor/features/mqtt/data/models/mqtt_message_model.dart';

/// Abstract data source interface for communicating with an MQTT broker.
///
/// Defines the contract for connecting, disconnecting, publishing,
/// subscribing, and listening to real-time messages.
abstract class MQTTRemoteDataSource {
  /// Initializes the MQTT client and attempts to establish a connection
  /// with the broker.
  ///
  /// Throws a [ServerException] if the connection fails or is refused.
  Future<void> connect();

  /// Disconnects gracefully from the broker.
  void disconnect();

  /// Subscribes the client to a specific MQTT [topic].
  ///
  /// The client must be connected before calling this method, otherwise
  /// a [ServerException] is thrown.
  void subscribe(String topic);

  /// Unsubscribes the client from a previously subscribed MQTT [topic].
  void unsubscribe(String topic);

  /// Publishes a text [message] to a specific MQTT [topic].
  ///
  /// The client must be connected before calling this method, otherwise
  /// a [ServerException] is thrown.
  void publish(String topic, String message);

  /// A continuous stream of incoming [MQTTMessageModel] objects.
  ///
  /// Emits new events whenever a message is published to any of the
  /// currently subscribed topics.
  Stream<MQTTMessageModel> get messageStream;
}

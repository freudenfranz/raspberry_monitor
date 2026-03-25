/// A data transfer object representing a received MQTT message.
///
/// Encapsulates the raw string payload and the topic it was published to,
/// shielding the rest of the application from the underlying MQTT package's
/// complex byte structures.
class MQTTMessageModel {
  /// Creates a new [MQTTMessageModel] instance.
  ///
  /// Both [topic] and [payload] are required to successfully process
  /// the incoming message.
  const MQTTMessageModel({required this.topic, required this.payload});

  /// The specific MQTT topic path this message was received on
  /// (e.g., 'pi/status' or 'pi/cpu_temp').
  final String topic;

  /// The decoded string content of the message.
  ///
  /// Usually contains JSON data or a simple string value sent by the broker.
  final String payload;
}

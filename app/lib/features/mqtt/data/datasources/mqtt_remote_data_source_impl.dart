// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:mqtt5_client/mqtt5_client.dart';
import 'package:mqtt5_client/mqtt5_server_client.dart';
import 'package:raspberry_monitor/core/error/exceptions.dart';
import 'package:raspberry_monitor/core/util/util.dart'; // Assuming your logger is here
import 'package:raspberry_monitor/features/mqtt/data/datasources/mqtt_config.dart';
import 'package:raspberry_monitor/features/mqtt/data/models/mqtt_message_model.dart';

import 'mqtt_remote_data_source.dart';

/// Implementation of [MQTTRemoteDataSource] using the `mqtt5_client` package.
///
/// Handles the low-level socket connections, state management, and payload
/// parsing required to communicate with an MQTT 5.0 broker.
@LazySingleton(as: MQTTRemoteDataSource)
class MQTTRemoteDataSourceImpl implements MQTTRemoteDataSource {
  /// Creates a new [MQTTRemoteDataSourceImpl].
  ///
  /// Requires a [hostName] (e.g., '192.168.1.100') and a [clientId]
  /// unique to this device. The [port] defaults to 1883 (standard MQTT).
  MQTTRemoteDataSourceImpl({required this.config}) {
    _initClient(cb: logSubscriptionState);
  }

  /// client configuration object containging hostName, clientID and port.
  final MQTTConfig config;

  /// The underlying MQTT server client instance responsible for network I/O.
  late final MqttServerClient client;

  /// The logger instance used for debugging and error tracking within this class.
  final log = logger(MQTTRemoteDataSourceImpl);

  void _initClient({
    void Function()? onDisconnected,
    void Function()? onConnected,
    void Function(MqttSubscription)? cb,
  }) {
    client = MqttServerClient.withPort(
      config.hostName,
      config.clientId,
      config.port,
    );
    client
      ..logging(on: false)
      ..keepAlivePeriod = 60
      ..socketTimeout = 2000
      ..onDisconnected = onDisconnected
      ..onConnected = onConnected
      ..onSubscribed = cb
      ..pongCallback = () => log.debug('Ping response received');

    final connMess = MqttConnectMessage().startClean().withUserProperties([
      MqttUserProperty()
        ..pairName = 'App'
        ..pairValue = 'RaspberryMonitor',
    ]);

    client.connectionMessage = connMess;
  }

  @override
  Future<void> connect() async {
    log.debug('Attempting to connect to $client.hostName:$client.port...');
    try {
      await client.connect();
    } on MqttNoConnectionException catch (e) {
      log.error('Client connection exception - $e');
      client.disconnect();
      throw const ServerException(
        message: 'Failed to connect to broker: No connection',
      );
    } on SocketException catch (e) {
      log.error('Socket exception - $e');
      client.disconnect();
      throw const ServerException(
        message: 'Failed to connect to broker: Socket error',
      );
    } catch (e) {
      log.error('Unknown error - $e');
      client.disconnect();
      throw ServerException(message: 'An unexpected error occurred: $e');
    }

    // Check if it actually connected successfully
    if (client.connectionStatus!.state != MqttConnectionState.connected) {
      client.disconnect();
      throw ServerException(
        message:
            'Failed to connect, status is ${client.connectionStatus!.state}',
      );
    }
  }

  @override
  void disconnect() {
    log.debug('Disconnecting...');
    client.disconnect();
  }

  @override
  void subscribe(String topic) {
    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      log.debug('Subscribing to $topic');
      final subscription = client.subscribe(topic, MqttQos.atLeastOnce);
      if (subscription == null) {
        log.error('Subscribing to $topic returned null');
      }
    } else {
      throw const ServerException(
        message: 'Cannot subscribe, client is not connected.',
      );
    }
  }

  /// Helper Method to log subscriptions including their status
  void logSubscriptionState(MqttSubscription s) {
    final status = client.getSubscriptionStatus(s);
    log.debug(
      'Subscription status is of ${s.topic} with option ${s.option} is $status',
    );
  }

  @override
  void unsubscribe(String topic) {
    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      client.unsubscribeStringTopic(topic);
    }
  }

  @override
  void publish(String topic, String message) {
    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      final builder = MqttPayloadBuilder()..addString(message);
      client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
    } else {
      throw ServerException(
        message: 'Cannot publish, client is not connected.',
      );
    }
  }

  @override
  Stream<MQTTMessageModel> get messageStream =>
      client.updates.map((List<MqttReceivedMessage<MqttMessage>> c) {
        final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;

        // Extract the payload as a string
        final String payload = MqttPublishPayload.bytesToStringAsString(
          recMess.payload.message!,
        );
        final String topic = c[0].topic ?? '';

        log.debug('Received message on topic: $topic, payload: $payload');

        return MQTTMessageModel(topic: topic, payload: payload);
      });
}

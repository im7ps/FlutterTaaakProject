import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:io';
import 'package:uuid/uuid.dart';

import 'package:taaak/constants/constants.dart';

class MqttService extends ChangeNotifier {
  StreamController<String> _messageStreamController = StreamController.broadcast();
  bool _isConnected = false;
  bool _isConnecting = false;
  late MqttServerClient _client;
  String? _errorMessage;

  Stream<String> get messageStream => _messageStreamController.stream;
  bool get isConnected => _isConnected;
  String? get errorMessage => _errorMessage;
  String clientID = Uuid().v4();

  MqttService() {
    _client = MqttServerClient('test.mosquitto.org', clientID); // mqttServer comes from lib/constants
    _client.port = 1883;
    _client.logging(on: false);
    _client.setProtocolV311();
    _client.keepAlivePeriod = 20;
    _client.onDisconnected = disconnect;
    _client.onConnected = connect;
  }

  Future<bool> connect() async {
    if (_isConnecting) return false;
    debugPrint('Attempting to connect...');
    _isConnecting = true;

    try {
      _client.connectionMessage = MqttConnectMessage()
      .withClientIdentifier(clientID)
      .startClean();

      await _client.connect();
    }
    on NoConnectionException catch (e) {
      // Raised by the client when connection fails.
      debugPrint('EXAMPLE::client exception - $e');
      _client.disconnect();
    }
    on SocketException catch (e) {
      // Raised by the socket layer
      debugPrint('EXAMPLE::socket exception - $e');
      _client.disconnect();
    }
    finally {
      _isConnecting = false;
    }


    // debugPrint('222');
    if (_client.connectionStatus!.state == MqttConnectionState.connected) {
      debugPrint('EXAMPLE::Mosquitto _client connected');
      _isConnected = true;
      return true;
    } 
    else if (_client.connectionStatus!.state == MqttConnectionState.connecting)
    {
      debugPrint('woooooooooo');
    }
    else {
      /// Use status here rather than state if you also want the broker return code.
      debugPrint('EXAMPLE::ERROR Mosquitto _client connection failed - disconnecting, status is ${_client.connectionStatus!.state}');
      debugPrint('EXAMPLE::Return code: ${_client.connectionStatus?.returnCode}');
      _client.disconnect();
    }
    return false;
  }


  void subscribe(String topic) {
    if (_client.connectionStatus!.state == MqttConnectionState.disconnected) {
      debugPrint('MQTT Client non connesso!');
      return ;
    }
    else if (_client.connectionStatus!.state == MqttConnectionState.connected)
    {
      debugPrint('MQTT Client subscribing!');
      _client.subscribe(topic, MqttQos.atMostOnce);
    }



    _client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      debugPrint('MQTT Client listening!');
      final recMess = c![0].payload as MqttPublishMessage;
      final payloadString  = MqttPublishPayload.bytesToStringAsString(
          recMess.payload.message,
        );
      debugPrint('Messaggio ricevuto su $topic: $payloadString');
      _messageStreamController.add(payloadString);
    });

    // _client.published!.listen((MqttPublishMessage message) {
    //   debugPrint(
    //     'EXAMPLE::Published notification:: topic is ${message.variableHeader!.topicName}, with Qos ${message.header!.qos}',
    //   );
    // });

    return ;
  }

  void publish(String topic, String message)
  {
    if (!_isConnected) {
      debugPrint('MQTT Client non connesso!');
      return ;
    }

    final builder = MqttClientPayloadBuilder();
    builder.addString(message);

    debugPrint('EXAMPLE::Subscribing to the topic');
    _client.subscribe(topic, MqttQos.exactlyOnce);

    debugPrint('EXAMPLE::Publishing our topic');
    _client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
  }


  void unsubscribe(String topic) {
    debugPrint('unsubscribing');
    _client.unsubscribe(topic);
    _client.disconnect();
  }


  void onSubscribed(String topic) {
    debugPrint('EXAMPLE::Subscription confirmed for topic $topic');
  }

/// The successful connect callback
  void onConnected() {
    debugPrint(
      'EXAMPLE::OnConnected client callback - Client connection was successful',
    );
  }

void disconnect() {
    debugPrint('EXAMPLE::OnDisconnected client callback - Client disconnection');
    if (_client.connectionStatus!.disconnectionOrigin ==
        MqttDisconnectionOrigin.solicited) {
      debugPrint('EXAMPLE::OnDisconnected callback is solicited, this is correct');
    } else {
      debugPrint(
        'EXAMPLE::OnDisconnected callback is unsolicited or none, this is incorrect - exiting',
      );
      exit(-1);
    }
  }
}
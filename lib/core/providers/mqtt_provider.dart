import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:io';
import 'package:uuid/uuid.dart';

import 'package:taaak/constants/constants.dart';

class MqttService extends ChangeNotifier {
  bool _isConnected = false;
  bool _isConnecting = false;
  late MqttServerClient _client;
  String? _errorMessage;

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

  Future<void> connect() async {
    if (_isConnecting) return;
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
      print('EXAMPLE::client exception - $e');
      _client.disconnect();
    }
    on SocketException catch (e) {
      // Raised by the socket layer
      print('EXAMPLE::socket exception - $e');
      _client.disconnect();
    }
    finally {
      _isConnecting = false;
    }


    debugPrint('222');
    if (_client.connectionStatus!.state == MqttConnectionState.connected) {
      debugPrint('EXAMPLE::Mosquitto _client connected');
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
      exit(-1);
    }

  }

  void disconnect() {
    print('EXAMPLE::OnDisconnected client callback - Client disconnection');
    if (_client.connectionStatus!.disconnectionOrigin ==
        MqttDisconnectionOrigin.solicited) {
      print('EXAMPLE::OnDisconnected callback is solicited, this is correct');
    } else {
      print(
          'EXAMPLE::OnDisconnected callback is unsolicited or none, this is incorrect - exiting');
      exit(-1);
    }
  }
}
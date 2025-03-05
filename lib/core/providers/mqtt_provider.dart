import 'package:flutter/material.dart';

class MqttProvider extends ChangeNotifier {
  bool _connectionState = false;

  bool get connectionState => _connectionState;

  void connect()
  {
    _connectionState = true;
    notifyListeners();
  }

  void disconnect()
  {
    _connectionState = false;
    notifyListeners();
  }
}
import 'package:flutter/material.dart';

class BluetoothProvider extends ChangeNotifier {
  bool _bluetoothState = false;

  bool get bluetoothState => _bluetoothState;

  void active()
  {
    _bluetoothState = true;
    notifyListeners();
  }

  void stop()
  {
    _bluetoothState = false;
    notifyListeners();
  }
}
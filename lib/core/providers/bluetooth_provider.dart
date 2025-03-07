import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:async';

class BluetoothService extends ChangeNotifier {
  late List<String> _devices;
  late bool _bluetoothState;
  late bool _isSearching;
  late bool _bluetoothPresent;

  bool get bluetoothState => _bluetoothState;
  bool get isSearching => _isSearching;
  List<String> get devices => _devices;

  BluetoothService() {
    _bluetoothState = false;
    _devices = [];
    _isSearching = false;
    _bluetoothPresent = false;

    _init();
  }

  Future<void> _init() async {
    _bluetoothPresent = await FlutterBluePlus.isSupported;
    notifyListeners();
  }

  void stop() {
    FlutterBluePlus.stopScan();
  }

  void active() async {
    if (_bluetoothState) return;
    bool isBluetoothSupported = await FlutterBluePlus.isSupported;
    if (!isBluetoothSupported) {
      debugPrint('Bluetooth not supported');
      return;
    }
    if (!kIsWeb && Platform.isAndroid) {
      await FlutterBluePlus.turnOn();
    }
    BluetoothAdapterState bluetoothIsOn = await FlutterBluePlus.adapterState.firstWhere((state) => state == BluetoothAdapterState.on);
    if (bluetoothIsOn == BluetoothAdapterState.on)
    {
      _bluetoothState = true;
      notifyListeners();
    }
    else {
      debugPrint('Bluetooth activation failed');
    }
  }

  Future<void> scanForDevices() async {
    var subscription = FlutterBluePlus.onScanResults.listen((results) {
            if (results.isNotEmpty) {
                ScanResult r = results.last; // the most recently found device
                debugPrint('${r.device.remoteId}: "${r.advertisementData.advName}" found!');
            }
        },
        onError: (e) => debugPrint(e),
    );
    FlutterBluePlus.cancelWhenScanComplete(subscription);
    await FlutterBluePlus.adapterState.where((val) => val == BluetoothAdapterState.on).first;
    await FlutterBluePlus.startScan(
    timeout: Duration(seconds:30));

    // wait for scanning to stop
    await FlutterBluePlus.isScanning.where((val) => val == false).first;
    notifyListeners();
  }

}
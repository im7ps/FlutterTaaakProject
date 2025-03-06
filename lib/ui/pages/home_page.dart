import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taaak/common/buttons/buttons.dart';
import 'package:taaak/constants/constants.dart';
import 'package:taaak/core/providers/mqtt_provider.dart';
import 'package:taaak/core/providers/bluetooth_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});


  void _navigateTo(BuildContext context, String destination)
  {
    Navigator.pushNamed(context, destination);
  }


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final spacing = screenHeight * spacingMultiplier; // spacingMultiplier is from lib/constants
    
    final buttons = [
      {'text': 'Publish MQTT', 'route': '/publish'}, 
      {'text': 'Subscribe MQTT', 'route': '/subscribe'}, 
      {'text': 'Bluetooth', 'route': '/bluetooth'},
    ];

    return Consumer2<MqttService, BluetoothProvider> (
      builder: (context, mqttService, bluetoothProvider, _) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: spacing,
            children: buttons.map(
                (btn) => ButtonBaseText(
                  onPressed: () => _navigateTo(context, btn['route']!),
                  buttonText: btn['text']!,
                )
              ).toList(),
          ),
        );
      }
    );
  }
}
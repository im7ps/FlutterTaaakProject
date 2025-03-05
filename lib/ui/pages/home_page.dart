import 'package:flutter/material.dart';
import 'package:taaak/common/buttons/buttons.dart';
import 'package:taaak/constants/constants.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});


  void _navigateTo(BuildContext context, String destination)
  {
    debugPrint(destination);
    Navigator.pushNamed(context, destination);
  }


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final spacing = screenHeight * spacingMultiplier;
    
    final buttons = [
      {'text': 'Publish MQTT', 'route': '/publish'}, 
      {'text': 'Subscribe MQTT', 'route': '/subscribe'}, 
      {'text': 'Bluetooth', 'route': '/bluetooth'},
    ];

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
}
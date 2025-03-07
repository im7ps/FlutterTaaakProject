import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:flutter/foundation.dart';
import 'package:taaak/common/buttons/buttons.dart';
import 'package:taaak/core/providers/mqtt_provider.dart';
import 'dart:async';
import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';

import 'package:taaak/constants/constants.dart';


class SubscribePageMQTT extends StatelessWidget {
  const SubscribePageMQTT({super.key});

  void _showTopicChat(MqttService mqttService, String topic) {
    mqttService.subscribe(topic);
  }

  @override
  Widget build(BuildContext context) {
   return Material(
     child: Center(
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
          Consumer<MqttService>(
            builder: (context, mqttService, _) {
              return 
              _TextFieldSection(
                onSubscibe: (topic) async {
                  _showTopicChat(mqttService, topic);
                },
              );
            },
          )
         ],
       ),
     ),
   );
  }
}

class _TextFieldSection extends StatefulWidget {
  final void Function(String topic) onSubscibe;
  const _TextFieldSection({required this.onSubscibe});

  @override
  State<_TextFieldSection> createState() => _TextFieldSectionState();
}

class _TextFieldSectionState extends State<_TextFieldSection> {
  final TextEditingController _topicController = TextEditingController();


  @override
  void dispose() {
    _topicController.dispose();
    super.dispose();
  }

  void _handleSubscription() {
    widget.onSubscibe(_topicController.text);
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double spacing = screenHeight * spacingMultiplier;
    return Column(
      spacing: spacing,
      children: [
        TextField(controller: _topicController),
        ButtonBaseText(
          onPressed: _handleSubscription,
          buttonText: 'Show chat',
        ),
        Consumer<MqttService>(
          builder: (context, mqttService, _) {
            return StreamBuilder<String>(
              stream: mqttService.messageStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Text("Nessun messaggio ricevuto");
                }
                return Text("Messaggio: ${snapshot.data}");
              },
            );
          },
        ),
      ],
    );
  }
}

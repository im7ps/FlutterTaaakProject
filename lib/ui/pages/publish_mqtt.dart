import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taaak/constants/constants.dart';
import 'package:taaak/common/buttons/buttons.dart';
import 'package:taaak/core/providers/mqtt_provider.dart';


class PublishPageMQTT extends StatelessWidget {
  const PublishPageMQTT({super.key});

  void _publishTextOnTopic(MqttService mqttService, String topic, String text) async {
    debugPrint('Chiamata a _publishTextOnTopic');
    bool isConnected = await mqttService.connect();
    if (isConnected)
    {
      mqttService.publish(topic, text);
    }
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
                onPublish: (topic, text) async {
                  _publishTextOnTopic(mqttService, topic, text);
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
  final void Function(String topic, String text) onPublish;
  const _TextFieldSection({required this.onPublish});

  @override
  State<_TextFieldSection> createState() => _TextFieldSectionState();
}

class _TextFieldSectionState extends State<_TextFieldSection> {
  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _inputTextController = TextEditingController();


  @override
  void dispose() {
    _topicController.dispose();
    _inputTextController.dispose();
    super.dispose();
  }

  void _handlePublish() {
    widget.onPublish(_topicController.text, _inputTextController.text);
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double spacing = screenHeight * spacingMultiplier;
    return Column(
      spacing: spacing,
      children: [
        TextField(controller: _topicController),
        TextField(controller: _inputTextController),
        ButtonBaseText(
          onPressed: _handlePublish,
          buttonText: 'Invio',
        ),
      ],
    );
  }
}

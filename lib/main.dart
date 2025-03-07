import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import 'core/theme/app_theme.dart';

import 'ui/pages/home_page.dart';

import 'core/providers/bluetooth_provider.dart';
import 'core/providers/mqtt_provider.dart';

import 'core/navigation/router.dart';

void main() {
  runApp(const TaaakApp());
}

class TaaakApp extends StatelessWidget {
  const TaaakApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MqttService()),
        ChangeNotifierProvider(create: (_) => BluetoothService()),
      ],
      child: MaterialApp(
        title: 'Taaak App',
        theme: AppTheme.appTheme,
        initialRoute: '/',
        onGenerateRoute: AppRouter.generateRoute,
        home: HomePage(),
      ),
    );
  }
}

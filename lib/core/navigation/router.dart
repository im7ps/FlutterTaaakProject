import 'package:flutter/material.dart';

import 'package:taaak/ui/pages/home_page.dart';
import 'package:taaak/ui/pages/bluetooth.dart';
import 'package:taaak/ui/pages/subscribe_mqtt.dart';
import 'package:taaak/ui/pages/publish_mqtt.dart';
import 'package:taaak/ui/pages/page_not_found.dart';

class AppRouter {
  static const String home = '/';
  static const String publish = '/publish';
  static const String subscribe = '/subscribe';
  static const String bluetooth = '/bluetooth';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch(settings.name)
    {
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case publish:
        return MaterialPageRoute(builder: (_) => const PublishPageMQTT());
      case subscribe:
        return MaterialPageRoute(builder: (_) => const SubscribePageMQTT());
      case bluetooth:
        return MaterialPageRoute(builder: (_) => const BluetoothPage());
      default:
        return MaterialPageRoute(builder: (_) => const PageNotFound());
    }
  }

}



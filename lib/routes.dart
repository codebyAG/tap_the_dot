import 'package:flutter/material.dart';

import '../features/home/presentation/pages/home_page.dart';

class AppRoutes {
  AppRoutes._();

  static const String home = '/';

  static Map<String, WidgetBuilder> get routes => {
    home: (_) => const HomePage(),
  };
}

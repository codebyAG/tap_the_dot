import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tap_the_dot/constants/app_constants.dart';
import 'package:tap_the_dot/theme/app_theme.dart';
import 'package:tap_the_dot/dependencies.dart';
import 'package:tap_the_dot/routes.dart';

class TapTheDotApp extends StatelessWidget {
  const TapTheDotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: buildAppProviders(),
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        initialRoute: AppRoutes.splash,
        routes: AppRoutes.routes,
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:tap_the_dot/screens/game_page.dart';
import 'package:tap_the_dot/screens/home_page.dart';
import 'package:tap_the_dot/screens/profile_screen.dart';
import 'package:tap_the_dot/screens/rewards_screen.dart';
import 'package:tap_the_dot/screens/settings_screen.dart';
import 'package:tap_the_dot/screens/shop_screen.dart';
import 'package:tap_the_dot/screens/splash_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String home = '/home';
  static const String game = '/game';
  static const String shop = '/shop';
  static const String settings = '/settings';
  static const String profile = '/profile';
  static const String rewards = '/rewards';

  static Map<String, WidgetBuilder> get routes => {
    splash: (_) => const SplashScreen(),
    home: (_) => const HomePage(),
    game: (_) => const GamePage(),
    shop: (_) => const ShopScreen(),
    settings: (_) => const SettingsScreen(),
    profile: (_) => const ProfileScreen(),
    rewards: (_) => const RewardsScreen(),
  };
}

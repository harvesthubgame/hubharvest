import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/privacy_screen.dart';
import '../screens/main_menu_screen.dart';
import '../screens/level_select_screen.dart';
import '../screens/gameplay_screen.dart';
import '../screens/tutorial_screen.dart';
import '../screens/settings_screen.dart';

class GameRoutes {
  static const String splash = '/';
  static const String privacy = '/privacy';
  static const String mainMenu = '/menu';
  static const String levelSelect = '/level_select';
  static const String gameplay = '/game';
  static const String tutorial = '/tutorial';
  static const String settings = '/settings';

  static Map<String, WidgetBuilder> get routes => {
    splash: (context) => const SplashScreen(),
    privacy: (context) => const PrivacyScreen(),
    mainMenu: (context) => const MainMenuScreen(),
    levelSelect: (context) => const LevelSelectScreen(),
    gameplay: (context) => const GameplayScreen(),
    tutorial: (context) => const TutorialScreen(),
    settings: (context) => const SettingsScreen(),
  };
}

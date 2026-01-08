import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../config/theme.dart';
import '../config/routes.dart';
import '../widgets/game_button.dart';
import '../screens/settings_screen.dart';
import '../game/managers/audio_manager.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  @override
  void initState() {
    super.initState();
    // Play Menu BGM
    AudioManager().playBgm('menubg.mp3');
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        
        final shouldExit = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(HarvestHubTheme.cardRadius),
            ),
            title: Text('Exit Game', style: HarvestHubTheme.themeData.textTheme.displayMedium),
            content: Text('Are you sure you want to exit?', style: HarvestHubTheme.themeData.textTheme.bodyLarge),
            actions: [
               TextButton(
                child: Text('Cancel', style: TextStyle(color: HarvestHubTheme.growthGreen, fontSize: 18)),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              TextButton(
                child: Text('Exit', style: TextStyle(color: HarvestHubTheme.barnRed, fontSize: 18)),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          ),
        );

        if (shouldExit == true) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Image.asset(
              'assets/images/main_menu_background.png',
              fit: BoxFit.cover,
              errorBuilder: (c, o, s) => Container(color: HarvestHubTheme.skyBlue),
            ),
          ),
          
          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset(
                  'assets/images/logo.png',
                  width: 300,
                  errorBuilder: (c, o, s) => Text('Harvest Hub', style: HarvestHubTheme.themeData.textTheme.displayLarge),
                ),
                const SizedBox(height: 40),
                
                // Play Button
                GameButton(
                  label: 'Play',
                  color: HarvestHubTheme.growthGreen,
                  onPressed: () {
                    Navigator.of(context).pushNamed(GameRoutes.levelSelect);
                  },
                ),
                const SizedBox(height: 20),
                
                // Tutorial Button
                GameButton(
                  label: 'How to Play',
                  color: HarvestHubTheme.harvestGold,
                  onPressed: () {
                    Navigator.of(context).pushNamed(GameRoutes.tutorial);
                  },
                ),
                const SizedBox(height: 20),
                
                // Settings Button
                GameButton(
                  label: 'Settings',
                  color: HarvestHubTheme.lightGrey,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => const SettingsScreen(),
                      barrierDismissible: true,
                    );
                  },
                ),
              ],
            ),
          ),

          // Exit Button (Android Back Button handling is usually global or per screen, but explicit exit is nice)
          Positioned(
            top: 20,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.exit_to_app, size: 32, color: Colors.white),
              onPressed: () {
                SystemNavigator.pop();
              },
            ),
          ),
        ],
      ),
      ),
    );
  }
}

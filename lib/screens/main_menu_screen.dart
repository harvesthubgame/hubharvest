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
          
          // Content - Scrollable for small screens
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Calculate responsive logo size (max 250, min 120)
                final logoSize = (constraints.maxWidth * 0.45).clamp(120.0, 250.0);
                // Calculate responsive spacing
                final verticalSpacing = (constraints.maxHeight * 0.025).clamp(12.0, 24.0);
                final logoSpacing = (constraints.maxHeight * 0.04).clamp(20.0, 40.0);
                
                return Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      vertical: verticalSpacing,
                      horizontal: 20,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Logo - responsive size
                        Image.asset(
                          'assets/images/logo.png',
                          width: logoSize,
                          height: logoSize,
                          errorBuilder: (c, o, s) => Text('Harvest Hub', style: HarvestHubTheme.themeData.textTheme.displayLarge),
                        ),
                        SizedBox(height: logoSpacing),
                        
                        // Play Button
                        GameButton(
                          label: 'Play',
                          color: HarvestHubTheme.growthGreen,
                          onPressed: () {
                            Navigator.of(context).pushNamed(GameRoutes.levelSelect);
                          },
                        ),
                        SizedBox(height: verticalSpacing),
                        
                        // Tutorial Button
                        GameButton(
                          label: 'How to Play',
                          color: HarvestHubTheme.harvestGold,
                          onPressed: () {
                            Navigator.of(context).pushNamed(GameRoutes.tutorial);
                          },
                        ),
                        SizedBox(height: verticalSpacing),
                        
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
                );
              },
            ),
          ),

          // Exit Button (Android Back Button handling is usually global or per screen, but explicit exit is nice)
          Positioned(
            top: 20,
            left: 20,
            child: SafeArea(
              child: IconButton(
                icon: const Icon(Icons.exit_to_app, size: 32, color: Colors.white),
                onPressed: () {
                  SystemNavigator.pop();
                },
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}

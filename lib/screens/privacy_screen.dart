import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../config/routes.dart';
import '../widgets/game_button.dart';
import '../services/storage_service.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54, // Dimmed background
      body: Center(
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(HarvestHubTheme.spacingLarge),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(HarvestHubTheme.cardRadius),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Welcome to Harvest Hub!',
                style: HarvestHubTheme.themeData.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: HarvestHubTheme.spacingMedium),
              Text(
                'This game is offline. We don\'t collect any data.',
                style: HarvestHubTheme.themeData.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: HarvestHubTheme.spacingLarge),
              GameButton(
                label: 'Accept & Continue',
                color: HarvestHubTheme.growthGreen,
                onPressed: () async {
                  await StorageService().setPrivacyAccepted(true);
                  if (context.mounted) {
                    Navigator.of(context).pushReplacementNamed(GameRoutes.mainMenu);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

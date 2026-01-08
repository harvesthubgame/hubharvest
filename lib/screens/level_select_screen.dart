import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../config/routes.dart';
import '../services/storage_service.dart';
import '../widgets/level_card.dart';
import '../game/managers/audio_manager.dart';

class LevelSelectScreen extends StatefulWidget {
  const LevelSelectScreen({super.key});

  @override
  State<LevelSelectScreen> createState() => _LevelSelectScreenState();
}

class _LevelSelectScreenState extends State<LevelSelectScreen> {
  late int _maxLevelUnlocked;

  @override
  void initState() {
    super.initState();
    _loadProgress();
    // Ensure BGM is playing (if returning from game)
    AudioManager().playBgm('menubg.mp3');
  }

  void _loadProgress() {
    setState(() {
      _maxLevelUnlocked = StorageService().maxLevelUnlocked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HarvestHubTheme.skyBlue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: HarvestHubTheme.darkGrey),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Select Level', 
          style: HarvestHubTheme.themeData.textTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(HarvestHubTheme.spacingLarge),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            childAspectRatio: 1.2,
            crossAxisSpacing: HarvestHubTheme.spacingMedium,
            mainAxisSpacing: HarvestHubTheme.spacingMedium,
          ),
          itemCount: 15,
          itemBuilder: (context, index) {
            final day = index + 1;
            final locked = day > _maxLevelUnlocked;
            final stars = StorageService().getStarsForLevel(day);

            return LevelCard(
              day: day,
              stars: stars,
              locked: locked,
              onTap: () {
                Navigator.of(context).pushNamed(
                  GameRoutes.gameplay,
                  arguments: day,
                ).then((_) {
                  // Refresh progress when returning
                  _loadProgress();
                  // Restart menu music
                  AudioManager().playBgm('menubg.mp3');
                });
              },
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../game/harvest_hub_game.dart';
import '../config/theme.dart';
import '../widgets/game_button.dart';
import '../services/storage_service.dart';

class LevelCompleteOverlay extends StatefulWidget {
  final HarvestHubGame game;

  const LevelCompleteOverlay({super.key, required this.game});

  @override
  State<LevelCompleteOverlay> createState() => _LevelCompleteOverlayState();
}

class _LevelCompleteOverlayState extends State<LevelCompleteOverlay>
    with TickerProviderStateMixin {
  late AnimationController _modalController;
  late Animation<double> _modalScale;

  final List<AnimationController> _starControllers = [];
  final List<Animation<double>> _starAnimations = [];

  @override
  void initState() {
    super.initState();

    // Save progress immediately
    final stars = widget.game.gameManager.stars;
    final day = widget.game.initialLevel;
    StorageService().setStarsForLevel(day, stars);
    if (day < 10) {
      StorageService().setMaxLevelUnlocked(day + 1);
    }

    // Modal Bounce In
    _modalController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _modalScale = CurvedAnimation(
      parent: _modalController,
      curve: Curves.elasticOut,
    );
    _modalController.forward();

    // Stars setup
    for (int i = 0; i < 3; i++) {
      final controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400),
      );
      _starControllers.add(controller);
      _starAnimations.add(
        CurvedAnimation(parent: controller, curve: Curves.bounceOut),
      );

      // Stagger animations for earned stars only
      // Show placeholders immediately or animate them differently?
      // Plan says "Animated star rating (pop in 1-2-3)"
      // Let's pop in the earned stars.
      if (i < stars) {
        Future.delayed(Duration(milliseconds: 500 + (i * 300)), () {
          if (mounted) controller.forward();
        });
      }
    }
  }

  @override
  void dispose() {
    _modalController.dispose();
    for (var c in _starControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stars = widget.game.gameManager.stars;
    final score = widget.game.gameManager.score.value;
    final day = widget.game.initialLevel;
    
    final screenSize = MediaQuery.of(context).size;
    // Responsive width: 90% of screen width, max 340
    final dialogWidth = (screenSize.width * 0.90).clamp(280.0, 340.0);
    final starSize = (dialogWidth * 0.15).clamp(40.0, 52.0);
    final buttonWidth = (dialogWidth - 60) / (day < 10 ? 3 : 2) - 4;

    return Scaffold(
      backgroundColor: Colors.black54,
      body: Center(
        child: ScaleTransition(
          scale: _modalScale,
          child: Container(
            width: dialogWidth,
            padding: const EdgeInsets.symmetric(
              horizontal: HarvestHubTheme.spacingMedium,
              vertical: HarvestHubTheme.spacingLarge,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(HarvestHubTheme.cardRadius),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Day Complete!',
                  style: HarvestHubTheme.themeData.textTheme.displayMedium,
                ),
                const SizedBox(height: 16),

                // Stars
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    if (index < stars) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ScaleTransition(
                          scale: _starAnimations[index],
                          child: Image.asset(
                            'assets/images/stargold.png',
                            width: starSize,
                            height: starSize,
                          ),
                        ),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Image.asset(
                          'assets/images/starsilver.png',
                          width: starSize,
                          height: starSize,
                        ),
                      );
                    }
                  }),
                ),
                const SizedBox(height: 12),

                Text(
                  'Score: $score',
                  style: HarvestHubTheme.themeData.textTheme.titleMedium,
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GameButton(
                      label: 'Menu',
                      color: HarvestHubTheme.lightGrey,
                      width: buttonWidth,
                      height: 46,
                      fontSize: 16,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    GameButton(
                      label: 'Replay',
                      color: HarvestHubTheme.harvestGold,
                      width: buttonWidth,
                      height: 46,
                      fontSize: 16,
                      onPressed: () {
                        Navigator.of(
                          context,
                        ).pushReplacementNamed('/game', arguments: day);
                      },
                    ),
                    if (day < 10)
                      GameButton(
                        label: 'Next',
                        color: HarvestHubTheme.growthGreen,
                        width: buttonWidth,
                        height: 46,
                        fontSize: 16,
                        onPressed: () {
                          Navigator.of(
                            context,
                          ).pushReplacementNamed('/game', arguments: day + 1);
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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

    return Scaffold(
      backgroundColor: Colors.black54,
      body: Center(
        child: ScaleTransition(
          scale: _modalScale,
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
                  'Day Complete!',
                  style: HarvestHubTheme.themeData.textTheme.displayLarge,
                ),
                const SizedBox(height: 20),

                // Stars
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    // Logic:
                    // If index < stars, use ScaleTransition with _starAnimations[index] and gold star
                    // If index >= stars, show silver star (maybe static or faded in)

                    if (index < stars) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ScaleTransition(
                          scale: _starAnimations[index],
                          child: Image.asset(
                            'assets/images/stargold.png',
                            width: 64,
                            height: 64,
                          ),
                        ),
                      );
                    } else {
                      // Empty/Silver stars show immediately
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/images/starsilver.png',
                          width: 64,
                          height: 64,
                        ),
                      );
                    }
                  }),
                ),
                const SizedBox(height: 20),

                Text(
                  'Score: $score',
                  style: HarvestHubTheme.themeData.textTheme.titleLarge,
                ),
                const SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GameButton(
                      label: 'Menu',
                      color: HarvestHubTheme.lightGrey,
                      width: 140,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    GameButton(
                      label: 'Replay',
                      color: HarvestHubTheme.harvestGold,
                      width: 140,
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
                        width: 140,
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

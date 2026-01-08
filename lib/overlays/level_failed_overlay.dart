import 'package:flutter/material.dart';
import '../game/harvest_hub_game.dart';
import '../config/theme.dart';
import '../widgets/game_button.dart';

class LevelFailedOverlay extends StatefulWidget {
  final HarvestHubGame game;

  const LevelFailedOverlay({super.key, required this.game});

  @override
  State<LevelFailedOverlay> createState() => _LevelFailedOverlayState();
}

class _LevelFailedOverlayState extends State<LevelFailedOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scaleAnimation = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Center(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            width: 450,
            padding: const EdgeInsets.all(HarvestHubTheme.spacingLarge),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(HarvestHubTheme.cardRadius),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Day Failed', 
                  style: HarvestHubTheme.themeData.textTheme.displayLarge?.copyWith(color: HarvestHubTheme.barnRed),
                ),
                const SizedBox(height: 20),
                
                Text(
                  widget.game.gameManager.failureReason ?? 'Don\'t give up!', 
                  style: HarvestHubTheme.themeData.textTheme.titleLarge,
                ),
                const SizedBox(height: 30),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GameButton(
                      label: 'Menu',
                      color: HarvestHubTheme.lightGrey,
                      width: 150,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    GameButton(
                      label: 'Try Again',
                      color: HarvestHubTheme.harvestGold,
                      width: 150,
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed(
                          '/game',
                          arguments: widget.game.initialLevel,
                        );
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

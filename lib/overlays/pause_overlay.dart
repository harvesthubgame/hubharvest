import 'package:flutter/material.dart';
import '../game/harvest_hub_game.dart';
import '../game/managers/game_manager.dart';
import '../config/theme.dart';
import '../widgets/game_button.dart';

class PauseOverlay extends StatefulWidget {
  final HarvestHubGame game;

  const PauseOverlay({super.key, required this.game});

  @override
  State<PauseOverlay> createState() => _PauseOverlayState();
}

class _PauseOverlayState extends State<PauseOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
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
            width: 400,
            padding: const EdgeInsets.all(HarvestHubTheme.spacingLarge),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(HarvestHubTheme.cardRadius),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Paused', style: HarvestHubTheme.themeData.textTheme.displayLarge),
                const SizedBox(height: 30),
                GameButton(
                  label: 'Resume',
                  color: HarvestHubTheme.growthGreen,
                  onPressed: () {
                     // Reverse animation then remove
                     _controller.reverse().then((_) {
                        widget.game.overlays.remove('Pause');
                        widget.game.gameManager.state.value = GameState.playing;
                        widget.game.resumeEngine();
                     });
                  },
                ),
                const SizedBox(height: 20),
                GameButton(
                  label: 'Restart',
                  color: HarvestHubTheme.harvestGold,
                  onPressed: () {
                    widget.game.overlays.remove('Pause');
                    widget.game.resumeEngine();
                    Navigator.of(context).pushReplacementNamed(
                      '/game',
                      arguments: widget.game.initialLevel,
                    );
                  },
                ),
                const SizedBox(height: 20),
                GameButton(
                  label: 'Quit',
                  color: HarvestHubTheme.barnRed,
                  onPressed: () {
                    widget.game.overlays.remove('Pause');
                    Navigator.of(context).pop(); 
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

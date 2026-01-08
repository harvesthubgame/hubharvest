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
    final screenSize = MediaQuery.of(context).size;
    // Responsive width: 85% of screen width, max 320
    final dialogWidth = (screenSize.width * 0.85).clamp(240.0, 320.0);
    
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Center(
        child: ScaleTransition(
          scale: _scaleAnimation,
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
                Text('Paused', style: HarvestHubTheme.themeData.textTheme.displayMedium),
                const SizedBox(height: 20),
                GameButton(
                  label: 'Resume',
                  color: HarvestHubTheme.growthGreen,
                  width: dialogWidth - 48,
                  height: 50,
                  fontSize: 20,
                  onPressed: () {
                     // Reverse animation then remove
                     _controller.reverse().then((_) {
                        widget.game.overlays.remove('Pause');
                        widget.game.gameManager.state.value = GameState.playing;
                        widget.game.resumeEngine();
                     });
                  },
                ),
                const SizedBox(height: 12),
                GameButton(
                  label: 'Restart',
                  color: HarvestHubTheme.harvestGold,
                  width: dialogWidth - 48,
                  height: 50,
                  fontSize: 20,
                  onPressed: () {
                    widget.game.overlays.remove('Pause');
                    widget.game.resumeEngine();
                    Navigator.of(context).pushReplacementNamed(
                      '/game',
                      arguments: widget.game.initialLevel,
                    );
                  },
                ),
                const SizedBox(height: 12),
                GameButton(
                  label: 'Quit',
                  color: HarvestHubTheme.barnRed,
                  width: dialogWidth - 48,
                  height: 50,
                  fontSize: 20,
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

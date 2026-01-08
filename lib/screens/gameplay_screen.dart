import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../game/harvest_hub_game.dart';
import '../game/managers/game_manager.dart';
import '../overlays/hud_overlay.dart';
import '../overlays/pause_overlay.dart';
import '../overlays/level_complete_overlay.dart';
import '../overlays/level_failed_overlay.dart';

class GameplayScreen extends StatefulWidget {
  const GameplayScreen({super.key});

  @override
  State<GameplayScreen> createState() => _GameplayScreenState();
}

class _GameplayScreenState extends State<GameplayScreen> {
  late HarvestHubGame _game;
  late int _level;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Get arguments
    _level = ModalRoute.of(context)?.settings.arguments as int? ?? 1;

    _game = HarvestHubGame(initialLevel: _level);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        // If not already paused or game over, pause it
        if (_game.gameManager.state.value == GameState.playing) {
          _game.gameManager.state.value = GameState.paused;
          _game.pauseEngine();
          _game.overlays.add('Pause');
        }
      },
      child: Scaffold(
        body: GameWidget(
          key: ValueKey('game_level_$_level'),
          game: _game,
          overlayBuilderMap: {
            'HUD': (context, HarvestHubGame game) => HUDOverlay(game: game),
            'Pause': (context, HarvestHubGame game) => PauseOverlay(game: game),
            'LevelComplete': (context, HarvestHubGame game) =>
                LevelCompleteOverlay(game: game),
            'LevelFailed': (context, HarvestHubGame game) =>
                LevelFailedOverlay(game: game),
          },
          initialActiveOverlays: const ['HUD'],
        ),
      ),
    );
  }
}

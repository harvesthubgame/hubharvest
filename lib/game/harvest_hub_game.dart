import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'components/conveyor_belt.dart';
import 'components/animal.dart';
import 'components/truck.dart';
import 'managers/game_manager.dart';
import 'managers/spawn_manager.dart';
import 'managers/audio_manager.dart';
import 'levels/level_config.dart';

/// The main game class for Harvest Hub
class HarvestHubGame extends FlameGame {
  late final GameManager gameManager;
  late final SpawnManager spawnManager;
  final int initialLevel;

  HarvestHubGame({this.initialLevel = 1});

  @override
  Color backgroundColor() => const Color(0xFF87CEEB); // Sky blue background

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Initialize Audio
    await AudioManager().init();
    AudioManager().playBgm('gameplay_bgsound.mp3');

    // Load Level Config
    // If level not found, default to level 1
    final levelConfig = LevelConfig.levels.firstWhere(
      (l) => l.day == initialLevel,
      orElse: () => LevelConfig.levels.first,
    );

    // Managers
    gameManager = GameManager(levelConfig: levelConfig);
    add(gameManager);

    spawnManager = SpawnManager(levelConfig: levelConfig);
    add(spawnManager);

    // Listen to game state changes
    gameManager.state.addListener(_onStateChange);

    // Load background
    add(
      SpriteComponent(
        sprite: await loadSprite('gameplay_background.png'),
        size: size,
        priority: -10, // Behind everything
      ),
    );

    // Add Conveyor Belt (Left 25%)
    final conveyor = ConveyorBelt();
    add(conveyor);

    // Add Truck (Right 25%)
    add(Truck());

    // Add Animals (Center 50%)
    final centerZoneStart = size.x * 0.25;
    final centerZoneWidth = size.x * 0.5;
    
    final animalWidth = centerZoneWidth / 3; // Fixed slot size
    final animalHeight = size.y * 0.3;
    final animalY = size.y * 0.5 - animalHeight / 2;

    int i = 0;
    for (var type in levelConfig.animals) {
      add(Animal(
        type: type,
        position: Vector2(centerZoneStart + (i * animalWidth) + 10, animalY),
        size: Vector2(animalWidth - 20, animalWidth - 20),
      ));
      i++;
    }
  }

  void _onStateChange() {
    switch (gameManager.state.value) {
      case GameState.levelComplete:
        pauseEngine();
        overlays.add('LevelComplete');
        AudioManager().playSfx('win.mp3');
        break;
      case GameState.gameOver:
        pauseEngine();
        overlays.add('LevelFailed');
        AudioManager().playSfx('lose.mp3');
        break;
      case GameState.playing:
        // Ensure no overlays blocking if we reset state to playing (e.g. from pause)
        // Note: Pause overlay handles its own removal usually
        break;
      default:
        break;
    }
  }

  @override
  void onRemove() {
    gameManager.state.removeListener(_onStateChange);
    super.onRemove();
  }
}

import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import '../harvest_hub_game.dart';

class ConveyorBelt extends ParallaxComponent<HarvestHubGame> {
  ConveyorBelt() : super(priority: 0);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Set size to left 25% of screen
    size = Vector2(game.size.x * 0.25, game.size.y);
    position = Vector2.zero();

    // Create a vertical scrolling parallax
    parallax = await game.loadParallax(
      [ParallaxImageData('conveyor_belt.png')],
      baseVelocity: Vector2(0, 50), // Scroll downwards
      repeat: ImageRepeat.repeatY,
      fill: LayerFill.width,
    );
  }

  /// Define spawn point for feed items (top center of belt) in world coordinates
  Vector2 get spawnPoint => Vector2(position.x + size.x / 2, -64); // Start slightly off-screen
}

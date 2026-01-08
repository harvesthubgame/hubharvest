import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import '../harvest_hub_game.dart';

class Truck extends SpriteComponent with HasGameReference<HarvestHubGame> {
  Truck() : super(priority: 5);

  Vector2? _initialPosition;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await game.loadSprite('truck.png');
    
    // Use percentage-based sizing that preserves aspect ratio
    // Target size is approximately 20% of the screen's smaller dimension
    final targetScale = game.size.x * 0.20;
    
    // Get the original sprite dimensions to calculate aspect ratio
    final originalWidth = sprite!.srcSize.x;
    final originalHeight = sprite!.srcSize.y;
    final aspectRatio = originalWidth / originalHeight;
    
    // Scale uniformly based on width, preserving aspect ratio
    size = Vector2(targetScale, targetScale / aspectRatio);
    
    // Position in the right zone, bottom aligned with padding
    position = Vector2(
      game.size.x * 0.75 + (game.size.x * 0.25 - size.x) / 2, // Centered in right 25%
      game.size.y - size.y - 20,
    );
    anchor = Anchor.topLeft;
    _initialPosition = position.clone();
  }

  void driveAway() {
    if (_initialPosition == null) return;

    // Drive off to the right
    add(
      MoveEffect.by(
        Vector2(size.x + 50, 0),
        EffectController(duration: 1.0, curve: Curves.easeIn),
        onComplete: () {
          // Teleport to off-screen right and slide back in
          position = _initialPosition! + Vector2(size.x + 50, 0);
          add(
            MoveEffect.to(
              _initialPosition!,
              EffectController(duration: 1.0, curve: Curves.easeOut),
            ),
          );
        },
      ),
    );
  }
}

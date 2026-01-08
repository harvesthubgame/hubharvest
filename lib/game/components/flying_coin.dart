import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import '../harvest_hub_game.dart';

class FlyingCoin extends SpriteComponent with HasGameReference<HarvestHubGame> {
  FlyingCoin({required Vector2 position})
    : super(position: position, size: Vector2.all(32), priority: 100);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await game.loadSprite('coin.png');

    // Target position (approximate top right HUD score location)
    final target = Vector2(game.size.x - 50, 50);

    add(
      MoveEffect.to(
        target,
        EffectController(duration: 0.8, curve: Curves.easeInOut),
        onComplete: () {
          removeFromParent();
        },
      ),
    );

    add(ScaleEffect.to(Vector2.all(0.5), EffectController(duration: 0.8)));
  }
}

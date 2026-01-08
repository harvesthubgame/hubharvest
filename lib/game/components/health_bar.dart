import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../harvest_hub_game.dart';

class HealthBar extends PositionComponent
    with HasGameReference<HarvestHubGame> {
  double health = 1.0;
  late SpriteComponent _fill;

  HealthBar({required Vector2 position, required Vector2 size})
    : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Empty background
    add(
      SpriteComponent(
        sprite: await game.loadSprite('progressbar_empty.png'),
        size: size,
      ),
    );

    // Fill
    _fill = SpriteComponent(
      sprite: await game.loadSprite('progressbar_loading.png'),
      size: size,
    );
    add(_fill);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Scale width based on health
    _fill.size.x = size.x * health;

    // Tint color
    Color color;
    if (health > 0.6) {
      color = const Color(0xFF4CAF50); // Green
    } else if (health > 0.3) {
      color = const Color(0xFFFFC107); // Yellow
    } else {
      color = const Color(0xFFE53935); // Red
    }

    _fill.paint.color = color;
  }
}

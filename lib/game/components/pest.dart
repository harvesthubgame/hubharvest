import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import '../harvest_hub_game.dart';
import '../managers/audio_manager.dart';
import '../../config/constants.dart';
import 'feed_item.dart';
import 'flying_coin.dart';

enum PestType { rat, crow }

class Pest extends SpriteComponent
    with HasGameReference<HarvestHubGame>, TapCallbacks {
  final PestType type;
  late Timer _lifeTimer;

  Pest({required this.type, required Vector2 position})
    : super(
        position: position,
        size: Vector2(64, 64),
        anchor: Anchor.center,
        priority: 20, // Above feed items
      );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    String spriteName = type == PestType.rat ? 'rat.png' : 'crow.png';
    sprite = await game.loadSprite(spriteName);

    // Timer to escape/steal
    _lifeTimer = Timer(
      GameConstants.pestEscapeTime,
      onTick: _stealFeed,
      repeat: false,
    );
    _lifeTimer.start();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _lifeTimer.update(dt);
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (isRemoving) return;

    // Shoo away
    AudioManager().playSfx('coin_collected.mp3');

    game.gameManager.addScore(GameConstants.pestBonus);
    game.add(FlyingCoin(position: position));

    _lifeTimer.stop();

    // Vanish animation
    add(
      ScaleEffect.to(
        Vector2.zero(),
        EffectController(duration: 0.2, curve: Curves.easeIn),
        onComplete: () => removeFromParent(),
      ),
    );
  }

  void _stealFeed() {
    // Try to find a feed item to steal
    final feedItems = game.children.whereType<FeedItem>().toList();
    if (feedItems.isNotEmpty) {
      // Steal the first one (or closest)
      // Simple logic: just take the first one found
      final target = feedItems.first;
      target.removeFromParent();
    }
    removeFromParent();
  }
}

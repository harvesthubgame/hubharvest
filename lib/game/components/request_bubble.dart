import 'package:flame/components.dart';
import '../harvest_hub_game.dart';
import 'feed_item.dart';

class RequestBubble extends PositionComponent
    with HasGameReference<HarvestHubGame> {
  final FeedType requestedFeed;
  final bool showHint;

  RequestBubble({required this.requestedFeed, this.showHint = true});

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Bubble background
    final bubble = SpriteComponent(
      sprite: await game.loadSprite('message.png'),
      size: Vector2(64, 64),
    );
    add(bubble);

    // Only show food icon hint in early levels (1-2)
    if (showHint) {
      String iconName;
      switch (requestedFeed) {
        case FeedType.hay:
          iconName = 'hay.png';
          break;
        case FeedType.grain:
          iconName = 'grain.png';
          break;
        case FeedType.vitamin:
          iconName = 'vitamin_bag.png';
          break;
      }

      final icon = SpriteComponent(
        sprite: await game.loadSprite(iconName),
        size: Vector2(32, 32),
        position: Vector2(16, 12), // Centered roughly inside bubble
      );
      add(icon);
    }

    size = bubble.size;
  }
}

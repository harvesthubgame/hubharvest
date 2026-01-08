import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import '../harvest_hub_game.dart';
import '../managers/game_manager.dart';
import 'animal.dart';

enum FeedType { hay, grain, vitamin }

class FeedItem extends SpriteComponent
    with DragCallbacks, HasGameReference<HarvestHubGame> {
  final FeedType type;
  Vector2? _dragStartPosition;
  Animal? _hoveredAnimal;

  FeedItem({required this.type, required Vector2 position})
    : super(
        position: position,
        size: Vector2(64, 64), // Default size, adjust as needed
        anchor: Anchor.center,
        priority: 10,
      );

  bool _isOnConveyor = true;
  static const double _conveyorSpeed = 50.0; // Pixels per second

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    String spriteName;
    switch (type) {
      case FeedType.hay:
        spriteName = 'hay.png';
        break;
      case FeedType.grain:
        spriteName = 'grain.png';
        break;
      case FeedType.vitamin:
        spriteName = 'vitamin_bag.png';
        break;
    }

    sprite = await game.loadSprite(spriteName);
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    // Don't move if game is not playing
    if (game.gameManager.state.value != GameState.playing) return;
    
    // Move down the conveyor belt when not being dragged
    if (_isOnConveyor) {
      position.y += _conveyorSpeed * dt;
      
      // Remove if it goes off the bottom of the screen - this wastes feed!
      if (position.y > game.size.y + size.y) {
        _onFeedWasted();
        removeFromParent();
      }
    }
  }

  void _onFeedWasted() {
    // Notify game manager about wasted feed
    game.gameManager.wasteFeed();
    game.gameManager.resetCombo(); // Break combo when feed is wasted
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    _dragStartPosition = position.clone();
    _isOnConveyor = false; // Stop conveyor movement while dragging
    scale = Vector2.all(1.2);
    priority = 100; // Bring to front
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    position += event.localDelta;

    // Visual feedback for hovering
    final drops = game.componentsAtPoint(position).whereType<Animal>();

    if (drops.isNotEmpty) {
      final animal = drops.first;
      if (_hoveredAnimal != animal) {
        _hoveredAnimal?.scale = Vector2.all(1.0); // Reset previous
        _hoveredAnimal = animal;
        _hoveredAnimal?.scale = Vector2.all(1.1); // Highlight new
      }
    } else {
      if (_hoveredAnimal != null) {
        _hoveredAnimal?.scale = Vector2.all(1.0);
        _hoveredAnimal = null;
      }
    }
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    scale = Vector2.all(1.0);
    priority = 10;

    // Reset hover effect
    _hoveredAnimal?.scale = Vector2.all(1.0);
    _hoveredAnimal = null;

    // Check for drop target
    final drops = game.componentsAtPoint(position).whereType<Animal>();

    if (drops.isNotEmpty) {
      final animal = drops.first;

      bool accepted = animal.acceptFeed(type);
      if (accepted) {
        removeFromParent();
      } else {
        _returnToConveyor();
      }
    } else {
      _returnToConveyor();
    }
  }

  void _returnToConveyor() {
    if (_dragStartPosition != null) {
      add(
        MoveEffect.to(
          _dragStartPosition!,
          EffectController(duration: 0.3, curve: Curves.easeOut),
          onComplete: () {
            _isOnConveyor = true; // Resume conveyor movement after returning
          },
        ),
      );
    }
  }
}

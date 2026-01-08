import 'dart:async' as async; // For Future
import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import '../harvest_hub_game.dart';
import 'feed_item.dart';
import 'truck.dart';
import 'request_bubble.dart';
import 'health_bar.dart';
import 'feeding_progress.dart';
import 'tap_indicator.dart';
import '../managers/game_manager.dart';
import '../managers/audio_manager.dart';
import '../../config/constants.dart';

import 'package:flame/effects.dart'; // Import effects
import 'flying_coin.dart';

enum AnimalType { cow, sheep, goat }

enum AnimalState { idle, hungry, eating, ready }

class Animal extends SpriteComponent
    with HasGameReference<HarvestHubGame>, TapCallbacks {
  final AnimalType type;
  AnimalState _state = AnimalState.idle;
  int _feedingsCount = 0;
  double _health = 1.0;
  FeedType? _requestedFeed;

  // Timers
  Timer? _hungerTimer;
  Timer? _eatingTimer;
  Timer? _autoCollectTimer;

  // Components
  RequestBubble? _bubble;
  HealthBar? _healthBar;
  FeedingProgress? _feedingProgress;
  TapIndicator? _tapIndicator;

  // Pulsing effect for ready state
  SequenceEffect? _pulsingEffect;

  // Wrong feed penalty - slowdown
  Timer? _slowdownTimer;
  bool _isSlowedDown = false;
  static const double _slowdownDuration = 3.0; // seconds
  static const double _normalHungerInterval = 3.0;
  static const double _slowedHungerInterval = 6.0; // Doubled when slowed

  Animal({required this.type, required Vector2 position, required Vector2 size})
    : super(position: position, size: size, priority: 1);

  AnimalState get state => _state; // Public getter for state
  int get feedingsCount => _feedingsCount; // Public getter for progress

  @override
  async.Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox());
    await _updateSprite();

    // Add feeding progress indicator
    _feedingProgress = FeedingProgress(
      position: Vector2(size.x / 2, -25),
      maxFeedings: GameConstants.feedingsToReady,
    );
    add(_feedingProgress!);

    // Start hunger cycle randomly
    _hungerTimer = Timer(
      2.0 + (type.index * 1.5), // Stagger start times
      onTick: _becomeHungry,
      repeat: false,
    );
    _hungerTimer!.start();
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (game.gameManager.state.value != GameState.playing) return;

    _hungerTimer?.update(dt);
    _eatingTimer?.update(dt);
    _autoCollectTimer?.update(dt);
    _slowdownTimer?.update(dt);

    if (_state == AnimalState.hungry) {
      _health -= dt * 0.05; // Health drains over ~20 seconds (1.0 / 0.05 = 20)
      if (_health <= 0) {
        _health = 0;
        game.gameManager.forceGameOver(
          "Animal got sick!",
        ); // Sick animal = Game Over
      }
      _healthBar?.health = _health;
    }
  }

  void _becomeHungry() {
    if (_state != AnimalState.idle) return;

    _state = AnimalState.hungry;
    _health = 1.0;

    // Determine requested feed based on type
    switch (type) {
      case AnimalType.cow:
        _requestedFeed = FeedType.hay;
        break;
      case AnimalType.sheep:
        _requestedFeed = FeedType.grain;
        break;
      case AnimalType.goat:
        _requestedFeed = FeedType.vitamin;
        break;
    }

    // Show bubble - only show food hint icon in levels 1-2
    final currentLevel = game.gameManager.levelConfig.day;
    final showHint = currentLevel <= 2;
    _bubble = RequestBubble(requestedFeed: _requestedFeed!, showHint: showHint);
    _bubble!.position = Vector2(size.x, -20); // Top right
    add(_bubble!);

    // Show health bar
    _healthBar = HealthBar(
      position: Vector2(0, size.y + 10),
      size: Vector2(size.x, 10),
    );
    add(_healthBar!);
  }

  bool acceptFeed(FeedType feedType) {
    if (_state != AnimalState.hungry) return false;

    if (feedType == _requestedFeed) {
      _handleCorrectFeed();
      return true;
    } else {
      _handleWrongFeed();
      return true; // Consumed but wrong
    }
  }

  void _handleCorrectFeed() {
    AudioManager().playSfx('correct_feed.mp3');
    
    // Calculate combo bonus
    int comboBonus = game.gameManager.getComboBonus();
    int totalScore = GameConstants.correctFeedCoins + comboBonus;
    game.gameManager.addScore(totalScore);
    game.gameManager.incrementCombo();

    // Flying Coin
    game.add(FlyingCoin(position: position + size / 2));

    // Particle Burst
    final random = Random();
    game.add(
      ParticleSystemComponent(
        particle: Particle.generate(
          count: 20,
          lifespan: 0.8,
          generator: (i) => AcceleratedParticle(
            acceleration: Vector2(0, 200), // Gravity
            speed: Vector2.random(random) * 200 - Vector2.all(100),
            position: position + size / 2,
            child: CircleParticle(
              radius: 4,
              paint: Paint()
                ..color = i % 2 == 0
                    ? const Color(0xFF4CAF50) // Green
                    : const Color(0xFFFFC107), // Gold
            ),
          ),
        ),
      ),
    );

    // Remove bubble and health bar
    if (_bubble != null) {
      _bubble!.removeFromParent();
      _bubble = null;
    }
    if (_healthBar != null) {
      _healthBar!.removeFromParent();
      _healthBar = null;
    }

    // Eat
    _state = AnimalState.eating;
    _updateSprite();

    _feedingsCount++;
    _feedingProgress?.setProgress(_feedingsCount);

    _eatingTimer = Timer(
      1.0,
      onTick: () {
        if (_feedingsCount >= GameConstants.feedingsToReady) {
          _becomeReady();
        } else {
          _state = AnimalState.idle;
          _updateSprite();
          // Set timer for next hunger (affected by slowdown)
          _hungerTimer = Timer(_currentHungerInterval, onTick: _becomeHungry, repeat: false);
          _hungerTimer!.start();
        }
      },
      repeat: false,
    );
    _eatingTimer!.start();
  }

  void _handleWrongFeed() {
    AudioManager().playSfx('wrong_feed.mp3');
    game.gameManager.addScore(-GameConstants.wrongFeedPenalty);
    game.gameManager.resetCombo(); // Break combo on wrong feed

    // Apply slowdown penalty - animal gets confused/upset
    _applySlowdown();

    // Drain some health as penalty
    _health -= 0.15;
    if (_health < 0.1) _health = 0.1; // Don't let it kill from wrong feed alone
    _healthBar?.health = _health;

    // Screen Shake using a sequence of rapid movements
    game.camera.viewfinder.add(
      SequenceEffect([
        MoveByEffect(Vector2(5, 0), EffectController(duration: 0.05)),
        MoveByEffect(Vector2(-10, 0), EffectController(duration: 0.05)),
        MoveByEffect(Vector2(10, 0), EffectController(duration: 0.05)),
        MoveByEffect(Vector2(-10, 0), EffectController(duration: 0.05)),
        MoveByEffect(Vector2(5, 0), EffectController(duration: 0.05)),
      ]),
    );

    // Visual feedback - turn slightly red/gray temporarily
    add(
      ColorEffect(
        const Color(0xFFFF6B6B),
        EffectController(
          duration: 0.3,
          reverseDuration: 0.5,
        ),
        opacityFrom: 0,
        opacityTo: 0.5,
      ),
    );
  }

  void _applySlowdown() {
    _isSlowedDown = true;
    
    // Cancel any existing slowdown timer
    _slowdownTimer?.stop();
    
    // Start slowdown timer
    _slowdownTimer = Timer(
      _slowdownDuration,
      onTick: _endSlowdown,
      repeat: false,
    );
    _slowdownTimer!.start();

    // Visual indicator - slight gray tint and smaller scale
    add(
      ScaleEffect.to(
        Vector2.all(0.9),
        EffectController(duration: 0.2),
      ),
    );
  }

  void _endSlowdown() {
    _isSlowedDown = false;
    
    // Restore normal scale
    add(
      ScaleEffect.to(
        Vector2.all(1.0),
        EffectController(duration: 0.2),
      ),
    );
  }

  double get _currentHungerInterval => 
      _isSlowedDown ? _slowedHungerInterval : _normalHungerInterval;

  void _becomeReady() {
    _state = AnimalState.ready;
    _updateSprite();

    // Play ready sound
    AudioManager().playSfx('coin_collected.mp3');

    // Add pulsing animation
    _startPulsingEffect();

    // Show TAP indicator
    _tapIndicator = TapIndicator(position: Vector2(size.x / 2, -50));
    add(_tapIndicator!);

    // Start auto-collect timer
    _autoCollectTimer = Timer(
      GameConstants.readyAutoCollectTime,
      onTick: _autoCollect,
      repeat: false,
    );
    _autoCollectTimer!.start();
  }

  void _startPulsingEffect() {
    _pulsingEffect = SequenceEffect(
      [
        ScaleEffect.to(
          Vector2.all(1.1),
          EffectController(duration: 0.5, curve: Curves.easeInOut),
        ),
        ScaleEffect.to(
          Vector2.all(1.0),
          EffectController(duration: 0.5, curve: Curves.easeInOut),
        ),
      ],
      infinite: true,
    );
    add(_pulsingEffect!);
  }

  void _stopPulsingEffect() {
    _pulsingEffect?.removeFromParent();
    _pulsingEffect = null;
    scale = Vector2.all(1.0);
  }

  void _autoCollect() {
    if (_state != AnimalState.ready) return;
    
    // Auto-collect with reduced bonus
    AudioManager().playSfx('coin_collected.mp3');
    game.gameManager.addScore(GameConstants.reducedDistributionBonus);

    // Single flying coin for reduced bonus
    game.add(FlyingCoin(position: position + size / 2));

    _resetAfterCollection();
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (_state == AnimalState.ready) {
      _collectProduce();
    }
  }

  void _collectProduce() {
    // Stop auto-collect timer
    _autoCollectTimer?.stop();
    _autoCollectTimer = null;

    AudioManager().playSfx('coin_collected.mp3');
    game.gameManager.addScore(GameConstants.distributionBonus);

    // Flying Coins (spawn a few)
    for (int i = 0; i < 5; i++) {
      Future.delayed(Duration(milliseconds: i * 100), () {
        if (isMounted) {
          game.add(FlyingCoin(position: position + size / 2));
        }
      });
    }

    _resetAfterCollection();

    // Truck animation trigger
    game.children.whereType<Truck>().firstOrNull?.driveAway();
  }

  void _resetAfterCollection() {
    // Stop pulsing
    _stopPulsingEffect();

    // Remove TAP indicator
    if (_tapIndicator != null) {
      _tapIndicator!.removeFromParent();
      _tapIndicator = null;
    }

    _feedingsCount = 0;
    _feedingProgress?.setProgress(0);
    _state = AnimalState.idle;
    _updateSprite();

    // Restart hunger cycle (affected by slowdown)
    _hungerTimer = Timer(_currentHungerInterval, onTick: _becomeHungry, repeat: false);
    _hungerTimer!.start();
  }

  async.Future<void> _updateSprite() async {
    String prefix;
    switch (_state) {
      case AnimalState.idle:
        prefix = 'idle';
        break;
      case AnimalState.hungry:
        prefix = 'idle';
        break; // Still idle sprite, bubble indicates hunger
      case AnimalState.eating:
        prefix = 'chewing';
        break;
      case AnimalState.ready:
        prefix = 'glowing';
        break;
    }

    String suffix;
    switch (type) {
      case AnimalType.cow:
        suffix = '_cow.png';
        break;
      case AnimalType.sheep:
        suffix = '_sheep.png';
        break;
      case AnimalType.goat:
        suffix = '_goat.png';
        break;
    }

    sprite = await game.loadSprite(prefix + suffix);
  }
}

import 'dart:math';
import 'package:flame/components.dart';
import '../harvest_hub_game.dart';
import '../levels/level_config.dart';
import '../components/feed_item.dart';
import '../components/conveyor_belt.dart';
import '../components/pest.dart';
import 'game_manager.dart';

class SpawnManager extends Component with HasGameReference<HarvestHubGame> {
  final LevelConfig levelConfig;
  final Random _random = Random();
  double _timer = 0;
  double _nextSpawnTime = 0;
  double _outOfStockTimer = 0;
  static const double _outOfStockGameOverDelay = 3.0; // Seconds with no feed before game over

  SpawnManager({required this.levelConfig});

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _scheduleNextSpawn();
  }

  void _scheduleNextSpawn() {
    // Use level-specific spawn intervals for difficulty scaling
    final range = levelConfig.spawnIntervalMax - levelConfig.spawnIntervalMin;
    _nextSpawnTime = levelConfig.spawnIntervalMin + _random.nextDouble() * range;
    _timer = 0;
  }

  /// Count current feed items on screen
  int _getCurrentFeedCount() {
    return game.children.whereType<FeedItem>().length;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (game.gameManager.state.value != GameState.playing) return;

    _timer += dt;
    if (_timer >= _nextSpawnTime) {
      _trySpawnFeed();
      _scheduleNextSpawn();
    }

    // Check for out of stock game over condition
    _checkOutOfStockCondition(dt);
  }

  void _checkOutOfStockCondition(double dt) {
    final feedOnScreen = _getCurrentFeedCount();
    final hasStock = game.gameManager.hasFeedStock;

    if (!hasStock && feedOnScreen == 0) {
      _outOfStockTimer += dt;
      if (_outOfStockTimer >= _outOfStockGameOverDelay) {
        game.gameManager.forceGameOver("Out of feed!");
      }
    } else {
      _outOfStockTimer = 0;
    }
  }

  void _trySpawnFeed() {
    // Check if we've reached the maximum feed items for this level
    if (_getCurrentFeedCount() >= levelConfig.maxFeedOnScreen) {
      // Don't spawn more feed - wait for player to use some
      return;
    }

    // Check if we have feed stock
    if (!game.gameManager.consumeFeedStock()) {
      // No stock left, can't spawn
      return;
    }

    _spawnFeed();
  }

  void _spawnFeed() {
    // Pick a random feed type from level config
    if (levelConfig.feedTypes.isEmpty) return;

    final feedType =
        levelConfig.feedTypes[_random.nextInt(levelConfig.feedTypes.length)];

    // Find conveyor belt to get spawn position
    final conveyor = game.children.whereType<ConveyorBelt>().firstOrNull;
    if (conveyor != null) {
      game.add(FeedItem(type: feedType, position: conveyor.spawnPoint));
    }

    // Check for pest spawn
    if (levelConfig.pestProbability > 0 &&
        _random.nextDouble() < levelConfig.pestProbability) {
      _spawnPest();
    }
  }

  void _spawnPest() {
    final type = _random.nextBool() ? PestType.rat : PestType.crow;

    // Spawn somewhere on screen, preferably near conveyor or animals
    // Let's spawn them randomly in the game area but avoid edges
    final padding = 50.0;
    final x = padding + _random.nextDouble() * (game.size.x - 2 * padding);
    final y = padding + _random.nextDouble() * (game.size.y - 2 * padding);

    game.add(Pest(type: type, position: Vector2(x, y)));
  }
}

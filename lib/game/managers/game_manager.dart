import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import '../levels/level_config.dart';
import '../harvest_hub_game.dart';
import '../../config/constants.dart';

enum GameState { intro, playing, paused, gameOver, levelComplete }

class GameManager extends Component with HasGameReference<HarvestHubGame> {
  final LevelConfig levelConfig;

  // Game State
  final ValueNotifier<int> score = ValueNotifier(0);
  final ValueNotifier<int> timeLeft = ValueNotifier(0);
  final ValueNotifier<GameState> state = ValueNotifier(GameState.intro);
  final ValueNotifier<int> feedStock = ValueNotifier(0);
  final ValueNotifier<int> combo = ValueNotifier(0);
  String? failureReason;

  double _timer = 0;
  int _currentCombo = 0;

  GameManager({required this.levelConfig});

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    reset();
  }

  void reset() {
    score.value = 0;
    timeLeft.value = levelConfig.timeLimit;
    _timer = levelConfig.timeLimit.toDouble();
    feedStock.value = levelConfig.feedStock;
    _currentCombo = 0;
    combo.value = 0;
    state.value = GameState.playing;
    failureReason = null;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (state.value == GameState.playing) {
      _timer -= dt;
      timeLeft.value = _timer.ceil();

      if (_timer <= 0) {
        _timer = 0;
        endLevel();
      }
    }
  }

  void addScore(int amount) {
    if (state.value != GameState.playing) return;
    score.value += amount;
    if (score.value < 0) score.value = 0;
  }

  // Combo System
  void incrementCombo() {
    _currentCombo++;
    combo.value = _currentCombo;
  }

  void resetCombo() {
    _currentCombo = 0;
    combo.value = 0;
  }

  int getComboBonus() {
    if (_currentCombo >= 5) return GameConstants.combo5PlusBonus;
    if (_currentCombo >= 4) return GameConstants.combo4Bonus;
    if (_currentCombo >= 3) return GameConstants.combo3Bonus;
    if (_currentCombo >= 2) return GameConstants.combo2Bonus;
    return 0;
  }

  // Feed Stock System
  bool consumeFeedStock() {
    if (feedStock.value <= 0) return false;
    feedStock.value--;
    return true;
  }

  void wasteFeed() {
    // Penalty for wasted feed
    addScore(-GameConstants.wastedFeedPenalty);
    
    // Check if out of stock and no feed on screen
    // The spawn manager will handle the game over condition
  }

  bool get hasFeedStock => feedStock.value > 0;

  void endLevel() {
    if (score.value >= levelConfig.quota) {
      state.value = GameState.levelComplete;
    } else {
      failureReason = "Time's up!";
      state.value = GameState.gameOver;
    }
  }

  void forceGameOver(String reason) {
    failureReason = reason;
    state.value = GameState.gameOver;
  }

  // Calculate stars based on quota
  int get stars {
    if (score.value >= levelConfig.quota * 2) return 3;
    if (score.value >= levelConfig.quota * 1.5) return 2;
    if (score.value >= levelConfig.quota) return 1;
    return 0;
  }
}

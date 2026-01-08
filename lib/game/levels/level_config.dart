import '../components/animal.dart';
import '../components/feed_item.dart';

class LevelConfig {
  final int day;
  final int timeLimit; // in seconds
  final List<AnimalType> animals;
  final List<FeedType> feedTypes;
  final double pestProbability; // 0.0 to 1.0
  final int quota;

  // Difficulty parameters
  final int maxFeedOnScreen; // Maximum number of feed items visible at once
  final double spawnIntervalMin; // Minimum seconds between spawns
  final double spawnIntervalMax; // Maximum seconds between spawns
  final int feedStock; // Limited feed available for the level

  const LevelConfig({
    required this.day,
    required this.timeLimit,
    required this.animals,
    required this.feedTypes,
    required this.pestProbability,
    required this.quota,
    required this.maxFeedOnScreen,
    required this.spawnIntervalMin,
    required this.spawnIntervalMax,
    required this.feedStock,
  });

  static const List<LevelConfig> levels = [
    // === EASY LEVELS (Days 1-3) - Tutorial/Learning Phase ===
    // Level 1: Introduction - Just cow and hay
    LevelConfig(
      day: 1,
      timeLimit: 60,
      animals: [AnimalType.cow],
      feedTypes: [FeedType.hay],
      pestProbability: 0.0,
      quota: 80,
      maxFeedOnScreen: 3,
      spawnIntervalMin: 2.0,
      spawnIntervalMax: 3.5,
      feedStock: 20,
    ),

    // Level 2: Add sheep - two animals, two feed types
    LevelConfig(
      day: 2,
      timeLimit: 75,
      animals: [AnimalType.cow, AnimalType.sheep],
      feedTypes: [FeedType.hay, FeedType.grain],
      pestProbability: 0.0,
      quota: 150,
      maxFeedOnScreen: 4,
      spawnIntervalMin: 1.8,
      spawnIntervalMax: 3.0,
      feedStock: 30,
    ),

    // Level 3: All three animals - complete variety
    LevelConfig(
      day: 3,
      timeLimit: 90,
      animals: [AnimalType.cow, AnimalType.sheep, AnimalType.goat],
      feedTypes: [FeedType.hay, FeedType.grain, FeedType.vitamin],
      pestProbability: 0.0,
      quota: 220,
      maxFeedOnScreen: 4,
      spawnIntervalMin: 1.5,
      spawnIntervalMax: 2.8,
      feedStock: 40,
    ),

    // === MEDIUM LEVELS (Days 4-6) - Pests Introduced ===
    LevelConfig(
      day: 4,
      timeLimit: 90,
      animals: [AnimalType.cow, AnimalType.sheep, AnimalType.goat],
      feedTypes: [FeedType.hay, FeedType.grain, FeedType.vitamin],
      pestProbability: 0.08,
      quota: 300,
      maxFeedOnScreen: 5,
      spawnIntervalMin: 1.3,
      spawnIntervalMax: 2.5,
      feedStock: 45,
    ),

    LevelConfig(
      day: 5,
      timeLimit: 100,
      animals: [AnimalType.cow, AnimalType.sheep, AnimalType.goat],
      feedTypes: [FeedType.hay, FeedType.grain, FeedType.vitamin],
      pestProbability: 0.12,
      quota: 400,
      maxFeedOnScreen: 5,
      spawnIntervalMin: 1.2,
      spawnIntervalMax: 2.2,
      feedStock: 55,
    ),

    LevelConfig(
      day: 6,
      timeLimit: 100,
      animals: [AnimalType.cow, AnimalType.sheep, AnimalType.goat],
      feedTypes: [FeedType.hay, FeedType.grain, FeedType.vitamin],
      pestProbability: 0.15,
      quota: 500,
      maxFeedOnScreen: 6,
      spawnIntervalMin: 1.0,
      spawnIntervalMax: 2.0,
      feedStock: 65,
    ),

    // === HARD LEVELS (Days 7-10) - Full Challenge ===
    LevelConfig(
      day: 7,
      timeLimit: 110,
      animals: [AnimalType.cow, AnimalType.sheep, AnimalType.goat],
      feedTypes: [FeedType.hay, FeedType.grain, FeedType.vitamin],
      pestProbability: 0.18,
      quota: 600,
      maxFeedOnScreen: 6,
      spawnIntervalMin: 0.9,
      spawnIntervalMax: 1.8,
      feedStock: 75,
    ),

    LevelConfig(
      day: 8,
      timeLimit: 110,
      animals: [AnimalType.cow, AnimalType.sheep, AnimalType.goat],
      feedTypes: [FeedType.hay, FeedType.grain, FeedType.vitamin],
      pestProbability: 0.22,
      quota: 700,
      maxFeedOnScreen: 7,
      spawnIntervalMin: 0.8,
      spawnIntervalMax: 1.6,
      feedStock: 85,
    ),

    LevelConfig(
      day: 9,
      timeLimit: 120,
      animals: [AnimalType.cow, AnimalType.sheep, AnimalType.goat],
      feedTypes: [FeedType.hay, FeedType.grain, FeedType.vitamin],
      pestProbability: 0.25,
      quota: 850,
      maxFeedOnScreen: 7,
      spawnIntervalMin: 0.7,
      spawnIntervalMax: 1.4,
      feedStock: 100,
    ),

    LevelConfig(
      day: 10,
      timeLimit: 120,
      animals: [AnimalType.cow, AnimalType.sheep, AnimalType.goat],
      feedTypes: [FeedType.hay, FeedType.grain, FeedType.vitamin],
      pestProbability: 0.28,
      quota: 1000,
      maxFeedOnScreen: 8,
      spawnIntervalMin: 0.6,
      spawnIntervalMax: 1.2,
      feedStock: 115,
    ),

    // === EXPERT LEVELS (Days 11-15) - Master Challenge ===
    // Level 11: Increased pressure with tighter feed stock
    LevelConfig(
      day: 11,
      timeLimit: 120,
      animals: [AnimalType.cow, AnimalType.sheep, AnimalType.goat],
      feedTypes: [FeedType.hay, FeedType.grain, FeedType.vitamin],
      pestProbability: 0.32,
      quota: 1100,
      maxFeedOnScreen: 8,
      spawnIntervalMin: 0.55,
      spawnIntervalMax: 1.1,
      feedStock: 120,
    ),

    // Level 12: Higher quota, faster pace
    LevelConfig(
      day: 12,
      timeLimit: 130,
      animals: [AnimalType.cow, AnimalType.sheep, AnimalType.goat],
      feedTypes: [FeedType.hay, FeedType.grain, FeedType.vitamin],
      pestProbability: 0.35,
      quota: 1250,
      maxFeedOnScreen: 9,
      spawnIntervalMin: 0.5,
      spawnIntervalMax: 1.0,
      feedStock: 130,
    ),

    // Level 13: Relentless pest attacks
    LevelConfig(
      day: 13,
      timeLimit: 130,
      animals: [AnimalType.cow, AnimalType.sheep, AnimalType.goat],
      feedTypes: [FeedType.hay, FeedType.grain, FeedType.vitamin],
      pestProbability: 0.40,
      quota: 1400,
      maxFeedOnScreen: 9,
      spawnIntervalMin: 0.45,
      spawnIntervalMax: 0.9,
      feedStock: 140,
    ),

    // Level 14: Near impossible - tight resources
    LevelConfig(
      day: 14,
      timeLimit: 140,
      animals: [AnimalType.cow, AnimalType.sheep, AnimalType.goat],
      feedTypes: [FeedType.hay, FeedType.grain, FeedType.vitamin],
      pestProbability: 0.45,
      quota: 1600,
      maxFeedOnScreen: 10,
      spawnIntervalMin: 0.4,
      spawnIntervalMax: 0.85,
      feedStock: 150,
    ),

    // Level 15: Ultimate Master Challenge
    LevelConfig(
      day: 15,
      timeLimit: 150,
      animals: [AnimalType.cow, AnimalType.sheep, AnimalType.goat],
      feedTypes: [FeedType.hay, FeedType.grain, FeedType.vitamin],
      pestProbability: 0.50,
      quota: 2000,
      maxFeedOnScreen: 10,
      spawnIntervalMin: 0.35,
      spawnIntervalMax: 0.75,
      feedStock: 170,
    ),
  ];
}

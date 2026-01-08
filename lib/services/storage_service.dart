import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  late SharedPreferences _prefs;

  // Keys
  static const String keyPrivacyAccepted = 'privacy_accepted';
  static const String keyMusicOn = 'music_on';
  static const String keySfxOn = 'sfx_on';
  static const String keyMaxLevelUnlocked = 'max_level_unlocked';
  
  // Helper for star keys: "level_1_stars", "level_2_stars", etc.
  static String keyLevelStars(int level) => 'level_${level}_stars';

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Privacy
  bool get privacyAccepted => _prefs.getBool(keyPrivacyAccepted) ?? false;
  Future<void> setPrivacyAccepted(bool value) => _prefs.setBool(keyPrivacyAccepted, value);

  // Settings
  bool get musicOn => _prefs.getBool(keyMusicOn) ?? true;
  Future<void> setMusicOn(bool value) => _prefs.setBool(keyMusicOn, value);

  bool get sfxOn => _prefs.getBool(keySfxOn) ?? true;
  Future<void> setSfxOn(bool value) => _prefs.setBool(keySfxOn, value);

  // Progress
  int get maxLevelUnlocked => _prefs.getInt(keyMaxLevelUnlocked) ?? 1;
  Future<void> setMaxLevelUnlocked(int level) async {
    int current = maxLevelUnlocked;
    if (level > current) {
      await _prefs.setInt(keyMaxLevelUnlocked, level);
    }
  }

  int getStarsForLevel(int level) => _prefs.getInt(keyLevelStars(level)) ?? 0;
  Future<void> setStarsForLevel(int level, int stars) async {
    int current = getStarsForLevel(level);
    if (stars > current) {
      await _prefs.setInt(keyLevelStars(level), stars);
    }
  }
}

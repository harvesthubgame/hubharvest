import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';
import '../../services/storage_service.dart';

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;
  AudioManager._internal();

  Future<void> init() async {
    // Preload audio
    await FlameAudio.audioCache.loadAll([
      'menubg.mp3',
      'gameplay_bgsound.mp3',
      'tap.mp3',
      'coin_collected.mp3',
      'correct_feed.mp3',
      'wrong_feed.mp3',
      'win.mp3',
      'lose.mp3',
    ]);
  }

  void playBgm(String filename) {
    if (StorageService().musicOn) {
      try {
        FlameAudio.bgm.play(filename);
      } catch (e) {
        // Handle potential audio session errors
        debugPrint('Error playing BGM: $e');
      }
    }
  }

  void stopBgm() {
    FlameAudio.bgm.stop();
  }

  void playSfx(String filename) {
    if (StorageService().sfxOn) {
      FlameAudio.play(filename);
    }
  }
}

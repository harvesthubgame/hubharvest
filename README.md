# Harvest Hub

A farming game built with Flutter and the Flame game engine.

## Getting Started

### Prerequisites

- Flutter SDK 3.38.5+
- Dart SDK 3.10.4+

### Installation

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to start the app

### Dependencies

- **flame**: ^1.34.0 - 2D game engine for Flutter
- **flame_audio**: ^2.11.12 - Audio support for Flame games
- **google_fonts**: ^6.3.3 - Google Fonts support (fallback)
- **shared_preferences**: ^2.5.4 - Local key-value storage for progress & settings

### Project Structure

```
lib/
├── main.dart              # App entry point
└── game/
    └── harvest_hub_game.dart  # Main game class

assets/
├── images/                # Game sprites and UI elements
├── audio/                 # Sound effects and background music
└── fonts/                 # Rubik font family (bundled for offline use)
```

### Platforms

- Android (package: `com.harvesthub.aishabm`)
- iOS (bundle: `com.harvesthub.aishabm`)
- Windows

## License

This project is proprietary.

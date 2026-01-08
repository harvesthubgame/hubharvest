import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// Shows feeding progress as dots (e.g., ●●○ for 2/3 feedings)
class FeedingProgress extends PositionComponent {
  final int maxFeedings;
  int _currentProgress = 0;
  
  final List<CircleComponent> _dots = [];

  FeedingProgress({
    required Vector2 position,
    required this.maxFeedings,
  }) : super(position: position, anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    const double dotRadius = 6;
    const double spacing = 18;
    final double totalWidth = (maxFeedings - 1) * spacing;
    final double startX = -totalWidth / 2;

    for (int i = 0; i < maxFeedings; i++) {
      final dot = CircleComponent(
        radius: dotRadius,
        position: Vector2(startX + i * spacing, 0),
        anchor: Anchor.center,
        paint: Paint()
          ..color = const Color(0xFF9E9E9E) // Gray for empty
          ..style = PaintingStyle.fill,
      );
      
      // Add border
      dot.add(CircleComponent(
        radius: dotRadius,
        anchor: Anchor.center,
        paint: Paint()
          ..color = const Color(0xFF424242)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      ));
      
      _dots.add(dot);
      add(dot);
    }
  }

  void setProgress(int progress) {
    _currentProgress = progress.clamp(0, maxFeedings);
    _updateDots();
  }

  void _updateDots() {
    for (int i = 0; i < _dots.length; i++) {
      if (i < _currentProgress) {
        // Filled - gold color
        _dots[i].paint.color = const Color(0xFFFFC107);
      } else {
        // Empty - gray color
        _dots[i].paint.color = const Color(0xFF9E9E9E);
      }
    }
  }
}

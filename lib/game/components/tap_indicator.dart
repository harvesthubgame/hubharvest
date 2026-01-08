import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

/// Bouncing "TAP!" indicator shown above ready animals
class TapIndicator extends PositionComponent {
  TapIndicator({required Vector2 position})
    : super(position: position, anchor: Anchor.center, priority: 50);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Background pill shape
    final background = RectangleComponent(
      size: Vector2(60, 28),
      anchor: Anchor.center,
      paint: Paint()..color = const Color(0xFF4CAF50),
    );
    
    // Round the corners using a custom paint
    background.paint = Paint()
      ..color = const Color(0xFF4CAF50)
      ..style = PaintingStyle.fill;
    
    add(background);

    // TAP text
    final textPaint = TextPaint(
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontFamily: 'Fredoka',
      ),
    );
    
    final tapText = TextComponent(
      text: 'TAP!',
      textRenderer: textPaint,
      anchor: Anchor.center,
      position: Vector2(0, -1),
    );
    add(tapText);

    // Add bouncing animation
    add(
      SequenceEffect(
        [
          MoveByEffect(
            Vector2(0, -8),
            EffectController(duration: 0.4, curve: Curves.easeOut),
          ),
          MoveByEffect(
            Vector2(0, 8),
            EffectController(duration: 0.4, curve: Curves.easeIn),
          ),
        ],
        infinite: true,
      ),
    );
  }
}

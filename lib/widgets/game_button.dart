import 'package:flutter/material.dart';
import '../config/theme.dart';

class GameButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final Color color;
  final Widget? icon;
  final double width;
  final double height;
  final double fontSize;

  const GameButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color = HarvestHubTheme.growthGreen,
    this.icon,
    this.width = 200,
    this.height = 60,
    this.fontSize = 24,
  });

  @override
  State<GameButton> createState() => _GameButtonState();
}

class _GameButtonState extends State<GameButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.1,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onPressed();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(HarvestHubTheme.buttonRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                offset: const Offset(0, 4),
                blurRadius: 4,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.icon != null) ...[
                    widget.icon!,
                    const SizedBox(width: 8),
                  ],
                  Text(
                    widget.label,
                    style: HarvestHubTheme.themeData.textTheme.labelLarge?.copyWith(
                      fontSize: widget.fontSize,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

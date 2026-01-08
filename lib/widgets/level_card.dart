import 'package:flutter/material.dart';
import '../config/theme.dart';

class LevelCard extends StatelessWidget {
  final int day;
  final int stars;
  final bool locked;
  final VoidCallback onTap;

  const LevelCard({
    super.key,
    required this.day,
    required this.stars,
    required this.locked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: locked ? null : onTap,
      child: Container(
        decoration: BoxDecoration(
          color: locked ? HarvestHubTheme.lightGrey : Colors.white,
          borderRadius: BorderRadius.circular(HarvestHubTheme.cardRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Day Number
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Day $day',
                    style: HarvestHubTheme.themeData.textTheme.titleLarge
                        ?.copyWith(
                          color: locked
                              ? Colors.grey[600]
                              : HarvestHubTheme.darkGrey,
                        ),
                  ),
                  const SizedBox(height: 8),
                  if (!locked)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: Image.asset(
                            index < stars
                                ? 'assets/images/stargold.png'
                                : 'assets/images/starsilver.png',
                            width: 24,
                            height: 24,
                            errorBuilder: (c, o, s) => Icon(
                              Icons.star,
                              color: index < stars ? Colors.amber : Colors.grey,
                              size: 24,
                            ),
                          ),
                        );
                      }),
                    ),
                ],
              ),
            ),

            // Lock Icon
            if (locked)
              Center(
                child: Image.asset(
                  'assets/images/padlock.png',
                  width: 48,
                  height: 48,
                  color: Colors.black26,
                  errorBuilder: (c, o, s) =>
                      const Icon(Icons.lock, size: 48, color: Colors.black26),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

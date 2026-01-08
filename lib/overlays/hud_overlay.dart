import 'package:flutter/material.dart';
import '../game/harvest_hub_game.dart';
import '../game/managers/game_manager.dart';
import '../config/theme.dart';

class HUDOverlay extends StatelessWidget {
  final HarvestHubGame game;

  const HUDOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(HarvestHubTheme.spacingMedium),
      child: Column(
        children: [
          // Top row: Day, Timer, Score, Pause
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Day
              _buildPill(
                child: Text(
                  'Day ${game.initialLevel}',
                  style: HarvestHubTheme.themeData.textTheme.titleLarge,
                ),
              ),

              // Timer
              ValueListenableBuilder<int>(
                valueListenable: game.gameManager.timeLeft,
                builder: (context, value, child) {
                  final color = value <= 10
                      ? HarvestHubTheme.barnRed
                      : HarvestHubTheme.darkGrey;
                  return _buildPill(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.timer, color: color, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          '${value}s',
                          style: HarvestHubTheme.themeData.textTheme.titleLarge
                              ?.copyWith(color: color),
                        ),
                      ],
                    ),
                  );
                },
              ),

              // Feed Stock
              ValueListenableBuilder<int>(
                valueListenable: game.gameManager.feedStock,
                builder: (context, value, child) {
                  final color = value <= 5
                      ? HarvestHubTheme.barnRed
                      : HarvestHubTheme.darkGrey;
                  return _buildPill(
                    backgroundColor: value <= 5
                        ? Colors.red.withValues(alpha: 0.2)
                        : Colors.white.withValues(alpha: 0.8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/hay.png',
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$value',
                          style: HarvestHubTheme.themeData.textTheme.titleLarge
                              ?.copyWith(color: color),
                        ),
                      ],
                    ),
                  );
                },
              ),

              // Score & Pause
              Row(
                children: [
                  ValueListenableBuilder<int>(
                    valueListenable: game.gameManager.score,
                    builder: (context, value, child) {
                      return _buildPill(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/images/coin.png',
                              width: 24,
                              height: 24,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$value / ${game.gameManager.levelConfig.quota}',
                              style: HarvestHubTheme
                                  .themeData.textTheme.titleLarge,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: Image.asset(
                      'assets/images/pause.png',
                      width: 48,
                      height: 48,
                    ),
                    onPressed: () {
                      game.gameManager.state.value = GameState.paused;
                      game.pauseEngine();
                      game.overlays.add('Pause');
                    },
                  ),
                ],
              ),
            ],
          ),

          // Combo indicator (shows when combo >= 2)
          ValueListenableBuilder<int>(
            valueListenable: game.gameManager.combo,
            builder: (context, value, child) {
              if (value < 2) return const SizedBox.shrink();
              
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.orange.shade400,
                        Colors.amber.shade400,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withValues(alpha: 0.5),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.local_fire_department,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'COMBO x$value',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Fredoka',
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '+${_getComboBonus(value)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white70,
                          fontFamily: 'Fredoka',
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPill({required Widget child, Color? backgroundColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }

  int _getComboBonus(int combo) {
    if (combo >= 5) return 15;
    if (combo >= 4) return 10;
    if (combo >= 3) return 5;
    if (combo >= 2) return 2;
    return 0;
  }
}

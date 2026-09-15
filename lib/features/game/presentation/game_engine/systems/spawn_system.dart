import 'dart:math';

import 'package:flame/components.dart';

import '../../../../../core/constants/game_constants.dart';

/// Picks a random on-screen spawn position for a target, staying inside a
/// safe margin so targets never sit under HUD elements or screen edges.
class SpawnSystem {
  final Random _random = Random();

  Vector2 randomPosition({required Vector2 canvasSize, required double targetRadius}) {
    final marginX = canvasSize.x * GameConstants.safeAreaMarginFraction + targetRadius;
    final marginTop = canvasSize.y * 0.22 + targetRadius;
    final marginBottom = canvasSize.y * 0.15 + targetRadius;

    final usableWidth = (canvasSize.x - marginX * 2).clamp(1.0, canvasSize.x);
    final usableHeight = (canvasSize.y - marginTop - marginBottom).clamp(1.0, canvasSize.y);

    final x = marginX + _random.nextDouble() * usableWidth;
    final y = marginTop + _random.nextDouble() * usableHeight;
    return Vector2(x, y);
  }
}

import 'dart:math';

import 'package:flame/components.dart';

import '../../../../../core/constants/game_constants.dart';

/// Picks a random on-screen spawn position for a target, staying inside a
/// safe margin so targets never sit under HUD elements or screen edges,
/// and never repeating too close to the previous spot. Also decides
/// Golden Dot spawn chance — both are "randomness" concerns that belong
/// together rather than scattered across the game engine.
class SpawnSystem {
  final Random _random = Random();
  Vector2? _lastPosition;

  static const int _maxRetries = 6;

  Vector2 randomPosition({required Vector2 canvasSize, required double targetRadius}) {
    final marginX = canvasSize.x * GameConstants.safeAreaMarginFraction + targetRadius;
    final marginTop = canvasSize.y * 0.22 + targetRadius;
    final marginBottom = canvasSize.y * 0.15 + targetRadius;

    final usableWidth = max(1.0, canvasSize.x - marginX * 2);
    final usableHeight = max(1.0, canvasSize.y - marginTop - marginBottom);

    final minSeparation = min(canvasSize.x, canvasSize.y) * GameConstants.minSpawnSeparationFraction;

    Vector2 candidate;
    var attempt = 0;
    do {
      final x = marginX + _random.nextDouble() * usableWidth;
      final y = marginTop + _random.nextDouble() * usableHeight;
      candidate = Vector2(x, y);
      attempt++;
    } while (_lastPosition != null &&
        candidate.distanceTo(_lastPosition!) < minSeparation &&
        attempt < _maxRetries);

    _lastPosition = candidate;
    return candidate;
  }

  /// Biases the first spawn(s) of a run toward the center of the safe
  /// area, so an "easy start" target is always comfortably reachable
  /// rather than landing in a far corner by chance.
  Vector2 centeredPosition({required Vector2 canvasSize, required double targetRadius}) {
    final marginTop = canvasSize.y * 0.22 + targetRadius;
    final marginBottom = canvasSize.y * 0.15 + targetRadius;
    final centerY = marginTop + (canvasSize.y - marginTop - marginBottom) / 2;
    final position = Vector2(canvasSize.x / 2, centerY);
    _lastPosition = position;
    return position;
  }

  bool shouldSpawnGolden() => _random.nextDouble() < GameConstants.goldenDotSpawnChance;

  void reset() => _lastPosition = null;
}

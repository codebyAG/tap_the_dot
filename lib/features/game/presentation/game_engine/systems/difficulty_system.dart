import '../../../../../core/constants/game_constants.dart';

/// Maps elapsed run time to the current target size / spawn pace. Pure
/// Dart so it's trivial to tune and reason about independently of Flame.
class DifficultySystem {
  double _progress(double elapsedSeconds) {
    return (elapsedSeconds / GameConstants.difficultyRampDurationSeconds).clamp(0.0, 1.0);
  }

  double targetRadiusFor(double elapsedSeconds) {
    final t = _progress(elapsedSeconds);
    return _lerp(GameConstants.targetRadiusStart, GameConstants.targetRadiusMin, t);
  }

  double spawnIntervalFor(double elapsedSeconds) {
    final t = _progress(elapsedSeconds);
    return _lerp(GameConstants.spawnIntervalStart, GameConstants.spawnIntervalMin, t);
  }

  double _lerp(double a, double b, double t) => a + (b - a) * t;
}

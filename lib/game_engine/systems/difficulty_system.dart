import 'package:tap_the_dot/constants/game_constants.dart';

/// Maps elapsed run time to the current target size / spawn pace. Pure
/// Dart so it's trivial to tune and reason about independently of Flame.
class DifficultySystem {
  /// Pinned at 0 (easiest) for the first [GameConstants.easyStartSeconds]
  /// so a fresh player gets a few guaranteed easy, satisfying hits before
  /// the ramp begins — then ramps smoothly to 1 over the remaining time.
  double _progress(double elapsedSeconds) {
    if (elapsedSeconds <= GameConstants.easyStartSeconds) return 0.0;
    final rampSpan =
        GameConstants.difficultyRampDurationSeconds -
        GameConstants.easyStartSeconds;
    final t = (elapsedSeconds - GameConstants.easyStartSeconds) / rampSpan;
    return t.clamp(0.0, 1.0);
  }

  double targetRadiusFor(double elapsedSeconds) {
    final t = _progress(elapsedSeconds);
    return _lerp(
      GameConstants.targetRadiusStart,
      GameConstants.targetRadiusMin,
      t,
    );
  }

  double spawnIntervalFor(double elapsedSeconds) {
    final t = _progress(elapsedSeconds);
    return _lerp(
      GameConstants.spawnIntervalStart,
      GameConstants.spawnIntervalMin,
      t,
    );
  }

  double _lerp(double a, double b, double t) => a + (b - a) * t;
}

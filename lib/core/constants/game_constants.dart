/// Tunable gameplay numbers. Kept separate from [AppConstants] so game
/// balance can be adjusted without touching app-wide configuration.
class GameConstants {
  GameConstants._();

  /// Total length of a single run.
  static const int gameDurationSeconds = 30;

  /// Target radius range (logical pixels), lerped down as difficulty rises.
  static const double targetRadiusStart = 55;
  static const double targetRadiusMin = 30;

  /// Seconds between target spawns, lerped down as difficulty rises. This
  /// governs how long a target stays alive before expiring unclaimed —
  /// NOT the gap after a successful hit (see [postHitSpawnDelay]).
  static const double spawnIntervalStart = 1.1;
  static const double spawnIntervalMin = 0.45;

  /// Short, fixed delay before the next target appears after a hit. Kept
  /// small and constant (not difficulty-scaled) so gameplay always feels
  /// instant — replay/pacing must never have a dead gap between targets.
  static const double postHitSpawnDelay = 0.15;
  static const double postExpireSpawnDelay = 0.25;

  /// Radius (as a fraction of target radius) that counts as a "perfect" hit.
  static const double perfectHitZoneFraction = 0.35;
  static const double goodHitZoneFraction = 0.7;

  static const int scoreNormalHit = 1;
  static const int scoreGoodHit = 2;
  static const int scorePerfectHit = 3;

  /// How long difficulty takes to ramp from start to max, in seconds.
  static const double difficultyRampDurationSeconds = 25;

  /// Fraction of the playable height/width kept clear as a safe margin
  /// around HUD elements when picking a spawn position.
  static const double safeAreaMarginFraction = 0.12;
}

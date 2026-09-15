/// Immutable configuration for a single run. Defaults come from
/// [GameConstants]; a distinct config (e.g. Daily Challenge) can override
/// fields without touching gameplay code.
class GameConfig {
  const GameConfig({
    required this.durationSeconds,
    this.bombsEnabled = true,
    this.fakeTargetsEnabled = true,
    this.scoreMultiplier = 1,
  });

  final int durationSeconds;
  final bool bombsEnabled;
  final bool fakeTargetsEnabled;
  final int scoreMultiplier;
}

/// Persistent player state — everything that survives across runs.
class PlayerProgress {
  const PlayerProgress({
    this.bestScore = 0,
    this.coins = 0,
    this.unlockedSkinIds = const ['classic'],
    this.selectedSkinId = 'classic',
    this.soundEnabled = true,
    this.musicEnabled = true,
    this.hapticsEnabled = true,
  });

  final int bestScore;
  final int coins;
  final List<String> unlockedSkinIds;
  final String selectedSkinId;
  final bool soundEnabled;
  final bool musicEnabled;
  final bool hapticsEnabled;

  PlayerProgress copyWith({
    int? bestScore,
    int? coins,
    List<String>? unlockedSkinIds,
    String? selectedSkinId,
    bool? soundEnabled,
    bool? musicEnabled,
    bool? hapticsEnabled,
  }) {
    return PlayerProgress(
      bestScore: bestScore ?? this.bestScore,
      coins: coins ?? this.coins,
      unlockedSkinIds: unlockedSkinIds ?? this.unlockedSkinIds,
      selectedSkinId: selectedSkinId ?? this.selectedSkinId,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      musicEnabled: musicEnabled ?? this.musicEnabled,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
    );
  }
}

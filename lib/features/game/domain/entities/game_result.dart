/// Outcome of a completed run — what [GamePage] shows on the game-over
/// screen, and what gets persisted via [SaveScore].
class GameResult {
  const GameResult({
    required this.score,
    required this.coinsEarned,
    required this.isNewBest,
    required this.bestScore,
    required this.totalHits,
    required this.perfectHits,
    required this.bestCombo,
  });

  final int score;
  final int coinsEarned;
  final bool isNewBest;
  final int bestScore;
  final int totalHits;
  final int perfectHits;
  final int bestCombo;
}

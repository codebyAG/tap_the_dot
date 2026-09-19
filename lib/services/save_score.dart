import '../entities/game_result.dart';
import '../repositories/game_repository.dart';

/// Persists the outcome of a run, updating the best score if beaten.
/// totalHits/perfectHits/bestCombo are per-run display stats — they pass
/// straight through into [GameResult] without being persisted.
class SaveScore {
  SaveScore(this._repository);

  final GameRepository _repository;

  Future<GameResult> call({
    required int score,
    required int coinsEarned,
    required int totalHits,
    required int perfectHits,
    required int bestCombo,
  }) async {
    final progress = await _repository.getPlayerProgress();
    final isNewBest = score > progress.bestScore;
    final newBest = isNewBest ? score : progress.bestScore;

    await _repository.savePlayerProgress(
      progress.copyWith(
        bestScore: newBest,
        coins: progress.coins + coinsEarned,
      ),
    );

    return GameResult(
      score: score,
      coinsEarned: coinsEarned,
      isNewBest: isNewBest,
      bestScore: newBest,
      totalHits: totalHits,
      perfectHits: perfectHits,
      bestCombo: bestCombo,
    );
  }
}

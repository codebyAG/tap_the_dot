import '../entities/game_result.dart';
import '../repositories/game_repository.dart';

/// Persists the outcome of a run, updating the best score if beaten.
/// Coin rewards are handled separately by [AddCoins].
class SaveScore {
  SaveScore(this._repository);

  final GameRepository _repository;

  Future<GameResult> call({required int score, required int coinsEarned}) async {
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
    );
  }
}

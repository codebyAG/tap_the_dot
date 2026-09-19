import '../entities/player_progress.dart';
import '../repositories/game_repository.dart';

/// Fetches full persisted progress (best score + coin total) — used by
/// GameController to populate the Home screen without a separate
/// single-field usecase per property.
class GetPlayerProgress {
  GetPlayerProgress(this._repository);

  final GameRepository _repository;

  Future<PlayerProgress> call() => _repository.getPlayerProgress();
}

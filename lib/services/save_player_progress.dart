import 'package:tap_the_dot/models/player_progress.dart';
import 'package:tap_the_dot/services/game_repository.dart';

/// Persists an updated [PlayerProgress] snapshot as-is — used for anything
/// that isn't "the outcome of a completed run" (which goes through
/// [SaveScore] instead): skin purchase/selection, settings toggles.
class SavePlayerProgress {
  SavePlayerProgress(this._repository);

  final GameRepository _repository;

  Future<void> call(PlayerProgress progress) =>
      _repository.savePlayerProgress(progress);
}

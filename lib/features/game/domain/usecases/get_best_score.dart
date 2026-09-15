import '../repositories/game_repository.dart';

class GetBestScore {
  GetBestScore(this._repository);

  final GameRepository _repository;

  Future<int> call() async {
    final progress = await _repository.getPlayerProgress();
    return progress.bestScore;
  }
}

import '../entities/player_progress.dart';

abstract class GameRepository {
  Future<PlayerProgress> getPlayerProgress();
  Future<void> savePlayerProgress(PlayerProgress progress);
}

import 'package:tap_the_dot/models/player_progress.dart';

abstract class GameRepository {
  Future<PlayerProgress> getPlayerProgress();
  Future<void> savePlayerProgress(PlayerProgress progress);
}

import 'package:tap_the_dot/models/player_progress.dart';
import 'package:tap_the_dot/services/game_repository.dart';
import 'package:tap_the_dot/services/game_local_datasource.dart';
import 'package:tap_the_dot/models/player_progress_model.dart';

class GameRepositoryImpl implements GameRepository {
  GameRepositoryImpl(this._localDataSource);

  final GameLocalDataSource _localDataSource;

  @override
  Future<PlayerProgress> getPlayerProgress() =>
      _localDataSource.getPlayerProgress();

  @override
  Future<void> savePlayerProgress(PlayerProgress progress) {
    return _localDataSource.savePlayerProgress(
      PlayerProgressModel.fromEntity(progress),
    );
  }
}

import '../../domain/entities/player_progress.dart';
import '../../domain/repositories/game_repository.dart';
import '../datasources/game_local_datasource.dart';
import '../models/player_progress_model.dart';

class GameRepositoryImpl implements GameRepository {
  GameRepositoryImpl(this._localDataSource);

  final GameLocalDataSource _localDataSource;

  @override
  Future<PlayerProgress> getPlayerProgress() => _localDataSource.getPlayerProgress();

  @override
  Future<void> savePlayerProgress(PlayerProgress progress) {
    return _localDataSource.savePlayerProgress(
      PlayerProgressModel.fromEntity(progress),
    );
  }
}

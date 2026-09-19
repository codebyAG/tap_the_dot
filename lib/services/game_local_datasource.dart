import 'package:tap_the_dot/constants/app_constants.dart';
import 'package:tap_the_dot/services/storage_service.dart';
import 'package:tap_the_dot/models/player_progress_model.dart';

class GameLocalDataSource {
  GameLocalDataSource(this._storage);

  final StorageService _storage;

  Future<PlayerProgressModel> getPlayerProgress() async {
    final raw = await _storage.getString(AppConstants.storagePlayerProgressKey);
    if (raw == null) return const PlayerProgressModel();
    return PlayerProgressModel.fromJsonString(raw);
  }

  Future<void> savePlayerProgress(PlayerProgressModel progress) async {
    await _storage.setString(
      AppConstants.storagePlayerProgressKey,
      progress.toJsonString(),
    );
  }
}

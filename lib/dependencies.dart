import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'package:tap_the_dot/services/audio_service.dart';
import 'package:tap_the_dot/services/haptic_service.dart';
import 'package:tap_the_dot/services/storage_service.dart';
import 'package:tap_the_dot/services/game_local_datasource.dart';
import 'package:tap_the_dot/services/game_repository_impl.dart';
import 'package:tap_the_dot/services/game_repository.dart';
import 'package:tap_the_dot/services/get_player_progress.dart';
import 'package:tap_the_dot/services/save_player_progress.dart';
import 'package:tap_the_dot/services/save_score.dart';
import 'package:tap_the_dot/services/game_controller.dart';

/// Manual composition root. Small app, so a simple factory of
/// [ChangeNotifierProvider]/[Provider] entries is enough — no DI codegen
/// package needed (rule 36.17: don't add a dependency without clear value).
List<SingleChildWidget> buildAppProviders() {
  final storageService = StorageService();
  final audioService = AudioService();
  final hapticService = HapticService();

  final localDataSource = GameLocalDataSource(storageService);
  final GameRepository gameRepository = GameRepositoryImpl(localDataSource);

  final getPlayerProgress = GetPlayerProgress(gameRepository);
  final saveScore = SaveScore(gameRepository);
  final savePlayerProgress = SavePlayerProgress(gameRepository);

  return [
    Provider<AudioService>.value(value: audioService),
    Provider<HapticService>.value(value: hapticService),
    ChangeNotifierProvider<GameController>(
      create: (_) => GameController(
        getPlayerProgress: getPlayerProgress,
        saveScore: saveScore,
        savePlayerProgress: savePlayerProgress,
        audioService: audioService,
        hapticService: hapticService,
      ),
    ),
  ];
}

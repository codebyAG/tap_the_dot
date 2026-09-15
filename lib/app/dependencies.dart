import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../core/services/audio/audio_service.dart';
import '../core/services/haptic/haptic_service.dart';
import '../core/services/storage/storage_service.dart';
import '../features/game/data/datasources/game_local_datasource.dart';
import '../features/game/data/repositories/game_repository_impl.dart';
import '../features/game/domain/repositories/game_repository.dart';
import '../features/game/domain/usecases/get_best_score.dart';
import '../features/game/domain/usecases/save_score.dart';
import '../features/game/presentation/controllers/game_controller.dart';

/// Manual composition root. Small app, so a simple factory of
/// [ChangeNotifierProvider]/[Provider] entries is enough — no DI codegen
/// package needed (rule 36.17: don't add a dependency without clear value).
List<SingleChildWidget> buildAppProviders() {
  final storageService = StorageService();
  final audioService = AudioService();
  final hapticService = HapticService();

  final localDataSource = GameLocalDataSource(storageService);
  final GameRepository gameRepository = GameRepositoryImpl(localDataSource);

  final getBestScore = GetBestScore(gameRepository);
  final saveScore = SaveScore(gameRepository);

  return [
    Provider<AudioService>.value(value: audioService),
    Provider<HapticService>.value(value: hapticService),
    ChangeNotifierProvider<GameController>(
      create: (_) => GameController(
        getBestScore: getBestScore,
        saveScore: saveScore,
        audioService: audioService,
        hapticService: hapticService,
      ),
    ),
  ];
}

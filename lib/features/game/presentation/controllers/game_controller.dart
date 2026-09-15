import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../../core/constants/game_constants.dart';
import '../../../../core/services/audio/audio_service.dart';
import '../../../../core/services/haptic/haptic_service.dart';
import '../../domain/entities/game_result.dart';
import '../../domain/entities/target.dart';
import '../../domain/usecases/get_best_score.dart';
import '../../domain/usecases/save_score.dart';

/// App-level gameplay state and rules. Owns the 30-second countdown,
/// score, and combo — Flame only owns real-time visuals and reports hits
/// up through [registerHit]/[registerMistake].
class GameController extends ChangeNotifier {
  GameController({
    required GetBestScore getBestScore,
    required SaveScore saveScore,
    required AudioService audioService,
    required HapticService hapticService,
  }) : _getBestScore = getBestScore,
       _saveScore = saveScore,
       _audioService = audioService,
       _hapticService = hapticService {
    _loadBestScore();
  }

  final GetBestScore _getBestScore;
  final SaveScore _saveScore;
  final AudioService _audioService;
  final HapticService _hapticService;

  int score = 0;
  int combo = 0;
  int bestScore = 0;
  double timeRemaining = GameConstants.gameDurationSeconds.toDouble();
  bool isPlaying = false;
  bool isGameOver = false;
  GameResult? lastResult;

  Timer? _countdownTimer;

  Future<void> _loadBestScore() async {
    bestScore = await _getBestScore();
    notifyListeners();
  }

  void startGame() {
    _countdownTimer?.cancel();
    score = 0;
    combo = 0;
    timeRemaining = GameConstants.gameDurationSeconds.toDouble();
    isPlaying = true;
    isGameOver = false;
    lastResult = null;

    _countdownTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      timeRemaining = (timeRemaining - 0.1).clamp(0, GameConstants.gameDurationSeconds.toDouble());
      if (timeRemaining <= 0) {
        endGame();
      } else {
        notifyListeners();
      }
    });

    notifyListeners();
  }

  /// Called by [TapDotGame] when a real target is hit.
  void registerHit(HitZone zone) {
    if (!isPlaying) return;

    final points = TargetScoring.pointsFor(zone);
    score += points;
    combo += 1;

    switch (zone) {
      case HitZone.perfect:
        _hapticService.perfectHit();
        _audioService.play(SoundEffect.perfect);
        break;
      case HitZone.good:
      case HitZone.normal:
        _hapticService.normalHit();
        _audioService.play(SoundEffect.tap);
        break;
      case HitZone.miss:
        break;
    }

    notifyListeners();
  }

  /// Called when the player taps a fake target / misses badly.
  void registerMistake() {
    if (!isPlaying) return;
    combo = 0;
    _hapticService.mistake();
    notifyListeners();
  }

  Future<void> endGame() async {
    if (!isPlaying) return;
    _countdownTimer?.cancel();
    isPlaying = false;
    isGameOver = true;
    timeRemaining = 0;
    // Notify immediately so the Flame world stops spawning/accepting taps
    // right away — the result card can lag slightly behind the save below.
    notifyListeners();

    final coinsEarned = score ~/ 10;
    lastResult = await _saveScore(score: score, coinsEarned: coinsEarned);
    bestScore = lastResult!.bestScore;

    _audioService.play(SoundEffect.gameOver);
    if (lastResult!.isNewBest) {
      await _hapticService.newBest();
      _audioService.play(SoundEffect.newBest);
    }

    notifyListeners();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }
}

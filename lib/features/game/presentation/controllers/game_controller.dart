import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../../core/constants/game_constants.dart';
import '../../../../core/services/audio/audio_service.dart';
import '../../../../core/services/haptic/haptic_service.dart';
import '../../domain/entities/combo.dart';
import '../../domain/entities/game_result.dart';
import '../../domain/entities/target.dart';
import '../../domain/usecases/get_best_score.dart';
import '../../domain/usecases/save_score.dart';

/// App-level gameplay state and rules. Owns the 30-second countdown,
/// score, combo, Fever Mode and coins — Flame only owns real-time visuals
/// and reports what happened through [registerHit]/[registerWrongTap]/
/// [registerTimeout].
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
  int comboMultiplier = 1;
  int bestCombo = 0;
  int totalHits = 0;
  int perfectHits = 0;
  int coinsThisRun = 0;
  bool isFeverActive = false;
  double feverTimeRemaining = 0;

  int bestScore = 0;
  double timeRemaining = GameConstants.gameDurationSeconds.toDouble();
  bool isPlaying = false;
  bool isGameOver = false;
  GameResult? lastResult;

  Timer? _countdownTimer;
  int _lastComboMultiplier = 1;

  Future<void> _loadBestScore() async {
    bestScore = await _getBestScore();
    notifyListeners();
  }

  void startGame() {
    _countdownTimer?.cancel();
    score = 0;
    combo = 0;
    comboMultiplier = 1;
    bestCombo = 0;
    totalHits = 0;
    perfectHits = 0;
    coinsThisRun = 0;
    isFeverActive = false;
    feverTimeRemaining = 0;
    _lastComboMultiplier = 1;
    timeRemaining = GameConstants.gameDurationSeconds.toDouble();
    isPlaying = true;
    isGameOver = false;
    lastResult = null;

    _countdownTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      timeRemaining = (timeRemaining - 0.1).clamp(0, GameConstants.gameDurationSeconds.toDouble());

      if (isFeverActive) {
        feverTimeRemaining -= 0.1;
        if (feverTimeRemaining <= 0) {
          _endFever();
        }
      }

      if (timeRemaining <= 0) {
        endGame();
      } else {
        notifyListeners();
      }
    });

    notifyListeners();
  }

  /// Called by [TapDotGame] when a real target is hit. Returns the actual
  /// points awarded (base zone score, boosted by combo/Fever/Golden
  /// bonuses) so the Flame layer can show an accurate floating number.
  int registerHit(HitZone zone, {bool isGolden = false}) {
    if (!isPlaying) return 0;

    combo += 1;
    totalHits += 1;
    if (zone == HitZone.perfect) perfectHits += 1;
    if (combo > bestCombo) bestCombo = combo;

    comboMultiplier = ComboRules.multiplierFor(combo);
    final feverMultiplier = isFeverActive ? GameConstants.feverScoreMultiplier : 1;
    final baseScore = TargetScoring.pointsFor(zone) + (isGolden ? GameConstants.goldenDotBonusScore : 0);
    final earned = baseScore * comboMultiplier * feverMultiplier;
    score += earned;

    if (isGolden) {
      coinsThisRun += GameConstants.goldenDotBonusCoins;
      _hapticService.goldenHit();
      _audioService.play(SoundEffect.coin);
    } else {
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
    }

    // Only fire the celebration on the way UP into a new tier, never when
    // recalculating after a wrong-tap/timeout drop.
    if (comboMultiplier > _lastComboMultiplier) {
      _hapticService.comboMilestone();
      _audioService.play(SoundEffect.combo);
    }
    _lastComboMultiplier = comboMultiplier;

    if (!isFeverActive && combo == GameConstants.feverTriggerCombo) {
      _startFever();
    }

    notifyListeners();
    return earned;
  }

  /// Called when the player taps outside the active target. A forgiving,
  /// skill-based nudge — combo drops by exactly one step, never below
  /// zero, and nothing else about the run is affected.
  void registerWrongTap() {
    if (!isPlaying) return;
    combo = combo > 0 ? combo - 1 : 0;
    comboMultiplier = ComboRules.multiplierFor(combo);
    _lastComboMultiplier = comboMultiplier;
    _hapticService.mistake();
    _audioService.play(SoundEffect.miss);
    notifyListeners();
  }

  /// Called when a target's lifetime runs out unclaimed. Distinct from a
  /// wrong tap: no score either way, but the combo fully resets.
  void registerTimeout() {
    if (!isPlaying) return;
    combo = 0;
    comboMultiplier = 1;
    _lastComboMultiplier = 1;
    notifyListeners();
  }

  void _startFever() {
    isFeverActive = true;
    feverTimeRemaining = GameConstants.feverDurationSeconds;
    _hapticService.feverStart();
    _audioService.play(SoundEffect.combo);
  }

  void _endFever() {
    isFeverActive = false;
    feverTimeRemaining = 0;
  }

  Future<void> endGame() async {
    if (!isPlaying) return;
    _countdownTimer?.cancel();
    isPlaying = false;
    isGameOver = true;
    isFeverActive = false;
    timeRemaining = 0;
    // Notify immediately so the Flame world stops spawning/accepting taps
    // right away — the result card can lag slightly behind the save below.
    notifyListeners();

    final coinsEarned = coinsThisRun + (score ~/ 10);
    lastResult = await _saveScore(
      score: score,
      coinsEarned: coinsEarned,
      totalHits: totalHits,
      perfectHits: perfectHits,
      bestCombo: bestCombo,
    );
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

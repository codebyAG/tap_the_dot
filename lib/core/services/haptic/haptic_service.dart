import 'package:flutter/services.dart';

/// Thin wrapper around [HapticFeedback] so gameplay code depends on an
/// intent-named API ("normal hit", "bomb") instead of raw platform calls,
/// and so haptics can be globally muted from settings.
class HapticService {
  bool enabled = true;

  void normalHit() {
    if (!enabled) return;
    HapticFeedback.lightImpact();
  }

  void perfectHit() {
    if (!enabled) return;
    HapticFeedback.mediumImpact();
  }

  void mistake() {
    if (!enabled) return;
    HapticFeedback.selectionClick();
  }

  void bomb() {
    if (!enabled) return;
    HapticFeedback.heavyImpact();
  }

  Future<void> newBest() async {
    if (!enabled) return;
    HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 120));
    HapticFeedback.mediumImpact();
  }

  void buttonTap() {
    if (!enabled) return;
    HapticFeedback.selectionClick();
  }
}

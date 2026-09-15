import '../../../../core/constants/game_constants.dart';

/// Pure combo-tier rules — score multiplier for a given consecutive-hit
/// count. No Flutter/Flame dependency so it's trivial to unit test and
/// reuse from both [GameController] and the Flame visual layer.
class ComboRules {
  ComboRules._();

  static int multiplierFor(int combo) {
    if (combo >= GameConstants.comboTier5) return 5;
    if (combo >= GameConstants.comboTier4) return 4;
    if (combo >= GameConstants.comboTier3) return 3;
    if (combo >= GameConstants.comboTier2) return 2;
    return 1;
  }
}

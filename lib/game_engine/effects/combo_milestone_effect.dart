import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

import 'package:tap_the_dot/theme/app_colors.dart';

/// Big "COMBO x5!" celebration text shown once when the combo multiplier
/// steps up to a new tier — see ComboRules. Purely visual; the actual
/// tier-crossing detection and audio/haptic live in GameController.
class ComboMilestoneEffect extends PositionComponent {
  ComboMilestoneEffect({required Vector2 position, required int multiplier})
    : _multiplier = multiplier,
      super(position: position, anchor: Anchor.center);

  final int _multiplier;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    scale = Vector2.zero();
    add(
      TextComponent(
        text: 'COMBO x$_multiplier!',
        anchor: Anchor.center,
        textRenderer: TextPaint(
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w900,
            color: AppColors.gold,
            shadows: [
              Shadow(
                color: Colors.black45,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
      ),
    );
    add(
      SequenceEffect([
        ScaleEffect.to(
          Vector2.all(1.2),
          EffectController(duration: 0.18, curve: Curves.easeOut),
        ),
        ScaleEffect.to(Vector2.all(1.0), EffectController(duration: 0.1)),
        ScaleEffect.to(Vector2.all(1.0), EffectController(duration: 0.45)),
        ScaleEffect.to(
          Vector2.zero(),
          EffectController(duration: 0.2, curve: Curves.easeIn),
        ),
      ], onComplete: removeFromParent),
    );
  }
}

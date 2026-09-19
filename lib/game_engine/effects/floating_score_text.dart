import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/target.dart';

/// "+12" / "PERFECT! +12" / "GOLDEN! +25" floating feedback above a hit
/// target. [score] is the FINAL awarded amount (already boosted by combo
/// multiplier / Fever / Golden bonus) so the number always matches what
/// actually landed in the score — see GameController.registerHit.
class FloatingScoreText extends TextComponent {
  FloatingScoreText({
    required Vector2 position,
    required int score,
    required HitZone zone,
    bool isGolden = false,
  }) : super(
         text: '${_labelFor(zone, isGolden)}+$score',
         position: position,
         anchor: Anchor.center,
         textRenderer: TextPaint(
           style: TextStyle(
             fontSize: (zone == HitZone.perfect || isGolden) ? 24 : 18,
             fontWeight: FontWeight.w900,
             color: isGolden
                 ? AppColors.gold
                 : (zone == HitZone.perfect ? AppColors.gold : AppColors.textLight),
             shadows: const [Shadow(color: Colors.black38, blurRadius: 4, offset: Offset(0, 1))],
           ),
         ),
       );

  static String _labelFor(HitZone zone, bool isGolden) {
    if (isGolden) return 'GOLDEN! ';
    if (zone == HitZone.perfect) return 'PERFECT! ';
    return '';
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Plain TextComponent doesn't implement HasPaint/OpacityProvider, so
    // OpacityEffect would throw at runtime — animate position/scale only.
    scale = Vector2.zero();
    add(
      MoveByEffect(
        Vector2(0, -50),
        EffectController(duration: 0.6, curve: Curves.easeOut),
      ),
    );
    add(
      SequenceEffect([
        ScaleEffect.to(Vector2.all(1.0), EffectController(duration: 0.12, curve: Curves.easeOut)),
        ScaleEffect.to(Vector2.all(1.0), EffectController(duration: 0.33)),
        ScaleEffect.to(Vector2.zero(), EffectController(duration: 0.15, curve: Curves.easeIn)),
      ], onComplete: removeFromParent),
    );
  }
}

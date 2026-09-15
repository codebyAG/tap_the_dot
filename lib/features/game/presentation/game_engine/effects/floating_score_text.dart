import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/target.dart';

/// "+3" / "PERFECT!" style feedback that floats up and fades out above a
/// hit target. Removes itself once the animation completes.
class FloatingScoreText extends TextComponent {
  FloatingScoreText({required Vector2 position, required HitZone zone})
    : super(
        text: zone == HitZone.perfect ? 'PERFECT! +${TargetScoring.pointsFor(zone)}' : '+${TargetScoring.pointsFor(zone)}',
        position: position,
        anchor: Anchor.center,
        textRenderer: TextPaint(
          style: TextStyle(
            fontSize: zone == HitZone.perfect ? 22 : 18,
            fontWeight: FontWeight.w900,
            color: zone == HitZone.perfect ? AppColors.gold : AppColors.textLight,
            shadows: const [Shadow(color: Colors.black38, blurRadius: 4, offset: Offset(0, 1))],
          ),
        ),
      );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Plain TextComponent doesn't implement HasPaint/OpacityProvider, so
    // OpacityEffect would throw at runtime — animate position/scale only.
    add(
      MoveByEffect(
        Vector2(0, -50),
        EffectController(duration: 0.6, curve: Curves.easeOut),
      ),
    );
    add(
      SequenceEffect([
        ScaleEffect.to(Vector2.all(1.0), EffectController(duration: 0.45)),
        ScaleEffect.to(Vector2.zero(), EffectController(duration: 0.15, curve: Curves.easeIn)),
      ], onComplete: removeFromParent),
    );
  }
}

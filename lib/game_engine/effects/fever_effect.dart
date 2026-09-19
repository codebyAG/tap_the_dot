import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

/// Persistent, low-alpha warm tint drawn over the whole play area while
/// Fever Mode is active — subtle atmosphere, not a flashy overlay. Added
/// on fever start and removed on fever end by [TapDotGame].
class FeverOverlay extends PositionComponent {
  FeverOverlay({required Vector2 size}) : super(position: Vector2.zero(), size: size, priority: -5);

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = AppColors.accent.withValues(alpha: 0.10);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), paint);
  }
}

/// One-shot "FEVER! ⚡" banner shown when Fever Mode kicks in.
class FeverBannerEffect extends PositionComponent {
  FeverBannerEffect({required Vector2 position}) : super(position: position, anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    scale = Vector2.zero();
    add(
      TextComponent(
        text: 'FEVER! ⚡ 2X SCORE',
        anchor: Anchor.center,
        textRenderer: TextPaint(
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w900,
            color: AppColors.accent,
            shadows: [Shadow(color: Colors.black45, blurRadius: 6, offset: Offset(0, 2))],
          ),
        ),
      ),
    );
    add(
      SequenceEffect([
        ScaleEffect.to(Vector2.all(1.2), EffectController(duration: 0.2, curve: Curves.easeOut)),
        ScaleEffect.to(Vector2.all(1.0), EffectController(duration: 0.15)),
        ScaleEffect.to(Vector2.all(1.0), EffectController(duration: 0.55)),
        ScaleEffect.to(Vector2.zero(), EffectController(duration: 0.25, curve: Curves.easeIn)),
      ], onComplete: removeFromParent),
    );
  }
}

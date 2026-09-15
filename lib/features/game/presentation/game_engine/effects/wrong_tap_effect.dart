import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

/// Small, unobtrusive feedback for a tap that missed the active target —
/// a soft ripple + tiny "MISS" label. Deliberately brief and quiet so a
/// wrong tap reads as "be more precise", not a punishment.
class WrongTapEffect extends PositionComponent {
  WrongTapEffect({required Vector2 position})
    : super(position: position, anchor: Anchor.center, size: Vector2.all(60));

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    scale = Vector2.zero();
    add(
      TextComponent(
        text: 'MISS',
        anchor: Anchor.center,
        position: Vector2(size.x / 2, size.y / 2 - 22),
        textRenderer: TextPaint(
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark.withValues(alpha: 0.7),
          ),
        ),
      ),
    );
    add(
      SequenceEffect([
        ScaleEffect.to(Vector2.all(1.0), EffectController(duration: 0.12, curve: Curves.easeOut)),
        ScaleEffect.to(Vector2.all(1.0), EffectController(duration: 0.1)),
        ScaleEffect.to(Vector2.zero(), EffectController(duration: 0.18, curve: Curves.easeIn)),
      ], onComplete: removeFromParent),
    );
  }

  @override
  void render(Canvas canvas) {
    final center = Offset(size.x / 2, size.y / 2);
    final ripplePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = AppColors.textDark.withValues(alpha: 0.25);
    canvas.drawCircle(center, 18, ripplePaint);
  }
}

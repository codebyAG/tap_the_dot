import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/game_constants.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/target.dart';
import '../effects/floating_score_text.dart';
import '../effects/target_hit_effect.dart';

typedef TargetHitCallback = void Function(TargetComponent target, HitZone zone);
typedef TargetExpiredCallback = void Function(TargetComponent target);

/// The real, tappable dot. Rendering + tap-resolution only — scoring
/// rules live in [TargetScoring] and app state lives in GameController;
/// this component just reports what happened via its callbacks.
class TargetComponent extends PositionComponent with TapCallbacks {
  TargetComponent({
    required Vector2 position,
    required this.radius,
    required this.lifetime,
    required this.onHit,
    required this.onExpired,
    this.sprite,
  }) : super(
         position: position,
         anchor: Anchor.center,
         size: Vector2.all(radius * 2),
       );

  final double radius;
  final double lifetime;
  final TargetHitCallback onHit;
  final TargetExpiredCallback onExpired;

  /// The dot's cosmetic skin image. Falls back to a procedural circle if
  /// not provided (e.g. asset failed to load).
  final Sprite? sprite;

  bool _resolved = false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    scale = Vector2.zero();
    add(
      SequenceEffect([
        ScaleEffect.to(Vector2.all(1.15), EffectController(duration: 0.15, curve: Curves.easeOut)),
        ScaleEffect.to(Vector2.all(1.0), EffectController(duration: 0.1, curve: Curves.easeIn)),
      ]),
    );
    add(
      TimerComponent(
        period: lifetime,
        removeOnFinish: true,
        onTick: _expire,
      ),
    );
  }

  @override
  void render(Canvas canvas) {
    final center = Offset(size.x / 2, size.y / 2);

    final skin = sprite;
    if (skin != null) {
      skin.render(canvas, size: size);
    } else {
      final fillPaint = Paint()
        ..shader = RadialGradient(
          colors: [AppColors.targetHighlight, AppColors.targetFill],
          stops: const [0.0, 1.0],
          center: const Alignment(-0.3, -0.35),
        ).createShader(Rect.fromCircle(center: center, radius: radius));
      canvas.drawCircle(center, radius, fillPaint);

      final glossPaint = Paint()..color = Colors.white.withValues(alpha: 0.35);
      canvas.drawCircle(
        center.translate(-radius * 0.28, -radius * 0.32),
        radius * 0.26,
        glossPaint,
      );
    }

    final perfectRingPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = AppColors.perfectRing.withValues(alpha: 0.55);
    canvas.drawCircle(center, radius * GameConstants.perfectHitZoneFraction, perfectRingPaint);
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (_resolved) return;
    _resolved = true;
    event.continuePropagation = false;

    final distance = (event.localPosition - size / 2).length;
    final zone = TargetScoring.zoneForDistance(
      distanceFromCenter: distance,
      radius: radius,
      perfectFraction: GameConstants.perfectHitZoneFraction,
      goodFraction: GameConstants.goodHitZoneFraction,
    );

    _playHitFeedback(zone);
    onHit(this, zone);
  }

  void _playHitFeedback(HitZone zone) {
    final strong = zone == HitZone.perfect;
    parent?.add(
      TargetHitEffect.burst(
        position: position.clone(),
        color: strong ? AppColors.gold : AppColors.targetHighlight,
        strong: strong,
      ),
    );
    parent?.add(FloatingScoreText(position: position.clone() - Vector2(0, radius), zone: zone));

    // Plain PositionComponent doesn't implement HasPaint/OpacityProvider,
    // so OpacityEffect would throw at runtime — pop via scale instead.
    add(
      SequenceEffect([
        ScaleEffect.to(Vector2.all(1.3), EffectController(duration: 0.08)),
        ScaleEffect.to(Vector2.zero(), EffectController(duration: 0.12, curve: Curves.easeIn)),
      ], onComplete: removeFromParent),
    );
  }

  void _expire() {
    if (_resolved) return;
    _resolved = true;
    onExpired(this);
    removeFromParent();
  }
}

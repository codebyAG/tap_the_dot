import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import 'package:tap_the_dot/constants/game_constants.dart';
import 'package:tap_the_dot/theme/app_colors.dart';
import 'package:tap_the_dot/models/target.dart';
import 'package:tap_the_dot/game_engine/effects/floating_score_text.dart';
import 'package:tap_the_dot/game_engine/effects/target_hit_effect.dart';

/// Returns the actual score awarded (combo/Fever/Golden-boosted) so the
/// floating feedback text can show the real number.
typedef TargetHitCallback =
    int Function(TargetComponent target, HitZone zone, bool isGolden);
typedef TargetExpiredCallback = void Function(TargetComponent target);

/// The real, tappable dot. Rendering + tap-resolution only — scoring
/// rules live in [TargetScoring]/GameController; this component just
/// reports what happened via its callbacks.
class TargetComponent extends PositionComponent with TapCallbacks {
  TargetComponent({
    required Vector2 position,
    required this.radius,
    required this.lifetime,
    required this.onHit,
    required this.onExpired,
    this.sprite,
    this.isGolden = false,
    this.feverBoost = false,
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

  /// Rare bonus target — clearly different visual, bigger reward.
  final bool isGolden;

  /// Snapshot of Fever Mode at spawn time, used to boost hit-particle
  /// intensity for targets spawned while Fever is active.
  final bool feverBoost;

  bool _resolved = false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    scale = Vector2.zero();
    add(
      SequenceEffect([
        ScaleEffect.to(
          Vector2.all(1.15),
          EffectController(duration: 0.15, curve: Curves.easeOut),
        ),
        ScaleEffect.to(
          Vector2.all(1.0),
          EffectController(duration: 0.1, curve: Curves.easeIn),
        ),
      ]),
    );
    add(
      TimerComponent(period: lifetime, removeOnFinish: true, onTick: _expire),
    );
  }

  /// Circular hit-test matching the visual dot, instead of the default
  /// square bounding box — a tap just outside the circle (but inside the
  /// component's square) must count as a wrong tap on the background, not
  /// a hit on this target.
  @override
  bool containsLocalPoint(Vector2 point) {
    return (point - size / 2).length <= radius;
  }

  @override
  void render(Canvas canvas) {
    final center = Offset(size.x / 2, size.y / 2);

    if (isGolden) {
      final glowPaint = Paint()
        ..color = AppColors.gold.withValues(alpha: 0.45)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14);
      canvas.drawCircle(center, radius * 1.3, glowPaint);
    }

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

    if (isGolden) {
      final goldRingPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..color = AppColors.gold;
      canvas.drawCircle(center, radius * 0.98, goldRingPaint);
    }

    final perfectRingPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = AppColors.perfectRing.withValues(alpha: 0.55);
    canvas.drawCircle(
      center,
      radius * GameConstants.perfectHitZoneFraction,
      perfectRingPaint,
    );
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

    final earnedScore = onHit(this, zone, isGolden);
    _playHitFeedback(zone, earnedScore);
  }

  void _playHitFeedback(HitZone zone, int earnedScore) {
    final isPerfect = zone == HitZone.perfect;
    final strong = isPerfect || isGolden || feverBoost;

    parent?.add(
      TargetHitEffect.burst(
        position: position.clone(),
        color: isGolden
            ? AppColors.gold
            : (isPerfect ? AppColors.gold : AppColors.targetHighlight),
        strong: strong,
      ),
    );
    // Perfect/Golden get a second, wider sparkle layer plus an expanding
    // ring so they read as clearly bigger moments than a normal hit.
    if (isPerfect || isGolden) {
      parent?.add(
        TargetHitEffect.burst(
          position: position.clone(),
          color: AppColors.gold,
          strong: true,
        ),
      );
      parent?.add(
        ExpandingRingEffect(
          position: position.clone(),
          color: AppColors.gold,
          startRadius: radius,
        ),
      );
    }
    parent?.add(
      FloatingScoreText(
        position: position.clone() - Vector2(0, radius),
        score: earnedScore,
        zone: zone,
        isGolden: isGolden,
      ),
    );

    // Plain PositionComponent doesn't implement HasPaint/OpacityProvider,
    // so OpacityEffect would throw at runtime — pop via scale instead.
    add(
      SequenceEffect([
        ScaleEffect.to(
          Vector2.all(isPerfect || isGolden ? 1.45 : 1.3),
          EffectController(duration: 0.08),
        ),
        ScaleEffect.to(
          Vector2.zero(),
          EffectController(duration: 0.12, curve: Curves.easeIn),
        ),
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

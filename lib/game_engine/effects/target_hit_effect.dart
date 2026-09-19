import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

/// Procedural particle burst played on a successful hit. Intensity scales
/// with [strong] so perfect hits feel noticeably bigger than normal ones —
/// see section 12/9 of the design spec ("game juice").
class TargetHitEffect {
  TargetHitEffect._();

  static ParticleSystemComponent burst({
    required Vector2 position,
    required Color color,
    bool strong = false,
  }) {
    final random = Random();
    final count = strong ? 22 : 12;
    final speed = strong ? 220.0 : 140.0;

    return ParticleSystemComponent(
      position: position,
      particle: Particle.generate(
        count: count,
        lifespan: strong ? 0.65 : 0.45,
        generator: (i) {
          final angle = random.nextDouble() * 2 * pi;
          final magnitude = speed * (0.5 + random.nextDouble() * 0.5);
          final velocity = Vector2(cos(angle), sin(angle)) * magnitude;
          return AcceleratedParticle(
            speed: velocity,
            acceleration: velocity * -1.8,
            child: CircleParticle(
              radius: 2 + random.nextDouble() * (strong ? 4 : 3),
              paint: Paint()..color = color.withValues(alpha: 0.9),
            ),
          );
        },
      ),
    );
  }
}

/// Ring that pops out from the hit point and expands away, reserved for
/// Perfect/Golden hits so they read as noticeably bigger moments than a
/// normal hit's particle burst alone.
class ExpandingRingEffect extends PositionComponent {
  ExpandingRingEffect({
    required Vector2 position,
    required this.color,
    required this.startRadius,
  }) : super(
         position: position,
         anchor: Anchor.center,
         size: Vector2.all(startRadius * 2),
       );

  final Color color;
  final double startRadius;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(
      ScaleEffect.to(
        Vector2.all(2.2),
        EffectController(duration: 0.4, curve: Curves.easeOut),
        onComplete: removeFromParent,
      ),
    );
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = color.withValues(alpha: 0.55);
    canvas.drawCircle(Offset(size.x / 2, size.y / 2), startRadius, paint);
  }
}

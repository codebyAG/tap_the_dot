/// How close a tap landed to the target's center. Pure gameplay rule —
/// no Flame/Flutter dependency, per the domain layer constraint.
enum HitZone { perfect, good, normal, miss }

/// Score rules for a hit. Kept here (not in a Flame component) so it can
/// be unit tested and reused by both the game engine and the controller.
class TargetScoring {
  TargetScoring._();

  static const int normal = 1;
  static const int good = 2;
  static const int perfect = 3;

  static int pointsFor(HitZone zone) {
    switch (zone) {
      case HitZone.perfect:
        return perfect;
      case HitZone.good:
        return good;
      case HitZone.normal:
        return normal;
      case HitZone.miss:
        return 0;
    }
  }

  /// Given a tap distance from center and the target's radius, determine
  /// which accuracy zone was hit. [perfectFraction] and [goodFraction]
  /// are fractions of [radius] (perfect < good < 1.0).
  static HitZone zoneForDistance({
    required double distanceFromCenter,
    required double radius,
    required double perfectFraction,
    required double goodFraction,
  }) {
    if (distanceFromCenter > radius) return HitZone.miss;
    if (distanceFromCenter <= radius * perfectFraction) return HitZone.perfect;
    if (distanceFromCenter <= radius * goodFraction) return HitZone.good;
    return HitZone.normal;
  }
}

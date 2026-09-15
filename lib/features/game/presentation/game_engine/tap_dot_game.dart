import 'package:flame/components.dart';
import 'package:flame/game.dart';

import '../../../../core/constants/asset_constants.dart';
import '../../../../core/constants/game_constants.dart';
import '../../domain/entities/target.dart';
import '../controllers/game_controller.dart';
import 'components/target_component.dart';
import 'systems/difficulty_system.dart';
import 'systems/spawn_system.dart';

/// Owns the real-time gameplay world: spawning targets, their positions,
/// animations and particles. Business state (score/timer/combo) lives in
/// [GameController] — this class only reads it and reports hits back.
class TapDotGame extends FlameGame {
  TapDotGame({required this.controller});

  final GameController controller;

  final SpawnSystem _spawnSystem = SpawnSystem();
  final DifficultySystem _difficultySystem = DifficultySystem();

  TargetComponent? _activeTarget;
  double _elapsedPlayTime = 0;
  double _spawnCooldown = 0;

  Sprite? _dotSprite;
  SpriteComponent? _background;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    await images.loadAll([AssetConstants.dotClassic, AssetConstants.background]);
    _dotSprite = Sprite(images.fromCache(AssetConstants.dotClassic));

    _background = SpriteComponent(
      sprite: Sprite(images.fromCache(AssetConstants.background)),
      size: size,
      position: Vector2.zero(),
    );
    await add(_background!);

    controller.addListener(_onControllerChanged);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _background?.size = size;
  }

  @override
  void onRemove() {
    controller.removeListener(_onControllerChanged);
    super.onRemove();
  }

  bool _wasPlaying = false;

  /// Edge-triggered on isPlaying so start/stop only fire once each,
  /// regardless of how many other notifyListeners() calls happen while
  /// playing (score/combo/timer all go through the same listener).
  void _onControllerChanged() {
    final isPlaying = controller.isPlaying;
    if (isPlaying && !_wasPlaying) {
      _startRun();
    } else if (!isPlaying && _wasPlaying) {
      _stopRun();
    }
    _wasPlaying = isPlaying;
  }

  void _startRun() {
    _elapsedPlayTime = 0;
    _spawnCooldown = 0;
    _activeTarget?.removeFromParent();
    _activeTarget = null;
    _spawnTarget();
  }

  void _stopRun() {
    _activeTarget?.removeFromParent();
    _activeTarget = null;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!controller.isPlaying) return;

    _elapsedPlayTime += dt;

    if (_activeTarget == null) {
      _spawnCooldown -= dt;
      if (_spawnCooldown <= 0) {
        _spawnTarget();
      }
    }
  }

  void _spawnTarget() {
    final radius = _difficultySystem.targetRadiusFor(_elapsedPlayTime);
    final position = _spawnSystem.randomPosition(canvasSize: size, targetRadius: radius);
    final lifetime = _difficultySystem.spawnIntervalFor(_elapsedPlayTime) * 2.4;

    final target = TargetComponent(
      position: position,
      radius: radius,
      lifetime: lifetime,
      onHit: _handleHit,
      onExpired: _handleExpired,
      sprite: _dotSprite,
    );

    _activeTarget = target;
    add(target);
  }

  void _handleHit(TargetComponent target, HitZone zone) {
    if (!controller.isPlaying) return;
    controller.registerHit(zone);
    _activeTarget = null;
    _spawnCooldown = GameConstants.postHitSpawnDelay;
  }

  void _handleExpired(TargetComponent target) {
    if (!controller.isPlaying) return;
    _activeTarget = null;
    _spawnCooldown = GameConstants.postExpireSpawnDelay;
  }
}

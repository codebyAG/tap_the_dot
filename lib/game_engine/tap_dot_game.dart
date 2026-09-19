import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';

import 'package:tap_the_dot/constants/asset_constants.dart';
import 'package:tap_the_dot/constants/game_constants.dart';
import 'package:tap_the_dot/theme/app_colors.dart';
import 'package:tap_the_dot/models/combo.dart';
import 'package:tap_the_dot/models/skin_config.dart';
import 'package:tap_the_dot/models/target.dart';
import 'package:tap_the_dot/services/game_controller.dart';
import 'package:tap_the_dot/game_engine/components/target_component.dart';
import 'package:tap_the_dot/game_engine/effects/combo_milestone_effect.dart';
import 'package:tap_the_dot/game_engine/effects/fever_effect.dart';
import 'package:tap_the_dot/game_engine/effects/target_hit_effect.dart';
import 'package:tap_the_dot/game_engine/effects/wrong_tap_effect.dart';
import 'package:tap_the_dot/game_engine/systems/difficulty_system.dart';
import 'package:tap_the_dot/game_engine/systems/spawn_system.dart';

/// Owns the real-time gameplay world: spawning targets, their positions,
/// animations and particles. Business state (score/timer/combo/Fever)
/// lives in [GameController] — this class only reads it and reports what
/// happened back through registerHit/registerWrongTap/registerTimeout.
///
/// Also catches taps that don't land on any target — TapCallbacks here
/// fires only when no child component consumed the event first, which is
/// exactly what "wrong tap" means.
class TapDotGame extends FlameGame with TapCallbacks {
  TapDotGame({required this.controller});

  final GameController controller;

  final SpawnSystem _spawnSystem = SpawnSystem();
  final DifficultySystem _difficultySystem = DifficultySystem();

  TargetComponent? _activeTarget;
  double _elapsedPlayTime = 0;
  double _spawnCooldown = 0;
  bool _isFirstSpawnOfRun = true;

  Sprite? _dotSprite;
  SpriteComponent? _background;
  FeverOverlay? _feverOverlay;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    images.prefix = AssetConstants.flameImagePrefix;

    final skinPath = SkinCatalog.byId(controller.selectedSkinId).asset;
    await images.loadAll([skinPath, AssetConstants.backgroundGame]);
    _dotSprite = Sprite(images.fromCache(skinPath));

    _background = SpriteComponent(
      sprite: Sprite(images.fromCache(AssetConstants.backgroundGame)),
      size: size,
      position: Vector2.zero(),
      priority: -10,
    );
    await add(_background!);

    controller.addListener(_onControllerChanged);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _background?.size = size;
    _feverOverlay?.size = size;
  }

  @override
  void onRemove() {
    controller.removeListener(_onControllerChanged);
    super.onRemove();
  }

  /// A tap that reached the game itself means no target consumed it —
  /// i.e. the player tapped outside the active dot.
  @override
  void onTapDown(TapDownEvent event) {
    if (!controller.isPlaying) return;
    controller.registerWrongTap();
    add(WrongTapEffect(position: event.localPosition.clone()));
  }

  bool _wasPlaying = false;
  int _lastComboMultiplier = 1;
  bool _wasFeverActive = false;

  /// Edge-triggered on isPlaying so start/stop only fire once each, plus
  /// combo-milestone/Fever visual transitions — all driven off controller
  /// state changes, regardless of how many other notifyListeners() calls
  /// happen while playing (score/timer tick through the same listener).
  void _onControllerChanged() {
    final isPlaying = controller.isPlaying;
    if (isPlaying && !_wasPlaying) {
      _startRun();
    } else if (!isPlaying && _wasPlaying) {
      _stopRun();
    }
    _wasPlaying = isPlaying;

    if (isPlaying) {
      final tier = ComboRules.multiplierFor(controller.combo);
      if (tier > _lastComboMultiplier) {
        _showComboMilestone(tier);
      }
      _lastComboMultiplier = tier;

      if (controller.isFeverActive && !_wasFeverActive) {
        _showFeverStart();
      } else if (!controller.isFeverActive && _wasFeverActive) {
        _hideFeverOverlay();
      }
      _wasFeverActive = controller.isFeverActive;
    }
  }

  void _startRun() {
    _elapsedPlayTime = 0;
    _spawnCooldown = 0;
    _isFirstSpawnOfRun = true;
    _lastComboMultiplier = 1;
    _wasFeverActive = false;
    _activeTarget?.removeFromParent();
    _activeTarget = null;
    _spawnSystem.reset();
    _hideFeverOverlay();
    _spawnTarget();
  }

  void _stopRun() {
    _activeTarget?.removeFromParent();
    _activeTarget = null;
    _hideFeverOverlay();
  }

  void _showComboMilestone(int tier) {
    final center = Vector2(size.x / 2, size.y * 0.32);
    add(ComboMilestoneEffect(position: center, multiplier: tier));
    add(
      TargetHitEffect.burst(
        position: center,
        color: AppColors.gold,
        strong: true,
      ),
    );
  }

  void _showFeverStart() {
    _feverOverlay = FeverOverlay(size: size);
    add(_feverOverlay!);
    add(FeverBannerEffect(position: Vector2(size.x / 2, size.y * 0.3)));
  }

  void _hideFeverOverlay() {
    _feverOverlay?.removeFromParent();
    _feverOverlay = null;
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
    final lifetime = _difficultySystem.spawnIntervalFor(_elapsedPlayTime) * 2.4;
    final isGolden = !_isFirstSpawnOfRun && _spawnSystem.shouldSpawnGolden();

    final position = _isFirstSpawnOfRun
        ? _spawnSystem.centeredPosition(canvasSize: size, targetRadius: radius)
        : _spawnSystem.randomPosition(canvasSize: size, targetRadius: radius);
    _isFirstSpawnOfRun = false;

    final target = TargetComponent(
      position: position,
      radius: radius,
      lifetime: lifetime,
      onHit: _handleHit,
      onExpired: _handleExpired,
      sprite: _dotSprite,
      isGolden: isGolden,
      feverBoost: controller.isFeverActive,
    );

    _activeTarget = target;
    add(target);
  }

  int _handleHit(TargetComponent target, HitZone zone, bool isGolden) {
    if (!controller.isPlaying) return 0;
    final earned = controller.registerHit(zone, isGolden: isGolden);
    _activeTarget = null;
    _spawnCooldown = GameConstants.postHitSpawnDelay;
    return earned;
  }

  void _handleExpired(TargetComponent target) {
    if (!controller.isPlaying) return;
    controller.registerTimeout();
    _activeTarget = null;
    _spawnCooldown = GameConstants.postExpireSpawnDelay;
  }
}

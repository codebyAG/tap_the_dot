# Tap The Dot — Project Context

_Last updated: 2026-09-19. This file is a snapshot for orientation, not a source of truth — verify against code before relying on specifics._

## What this is
A Flutter + Flame casual reflex/tapping mobile game. Player taps dots as they spawn within a 30-second run, building combo multipliers, triggering Fever Mode, and earning coins. Android is the primary target platform.

## Stack
- Flutter (Dart SDK ^3.10.0), Material 3
- `flame` — real-time game engine/canvas layer
- `provider` — app-level state management
- `shared_preferences` — local persistence
- `audioplayers` — sound effects

## Folder structure (flat, as of this session's restructure)
```
lib/
  main.dart            entry point
  app.dart             MaterialApp + MultiProvider root
  dependencies.dart     composition root (manual DI, builds providers)
  routes.dart           named route table
  constants/            app_constants, asset_constants, game_constants (tunables)
  theme/                app_colors, app_text_styles, app_theme (rounded cartoon style)
  models/               domain entities: target (HitZone/TargetScoring), combo (ComboRules),
                         game_result, player_progress(+model), game_config
  services/              GameController (ChangeNotifier, app-level gameplay state),
                         AudioService, HapticService, StorageService,
                         GameRepository(+impl), GameLocalDataSource,
                         usecases: get_player_progress, save_score
  game_engine/           Flame layer only: TapDotGame, components/, effects/, systems/
                         (difficulty ramp, spawn positions/golden-dot rolls)
  screens/               one file per route/page
  widgets/               reusable Flutter widgets shared across screens
```
This was migrated in-session from a clean-architecture `features/{game,home}/{domain,data,presentation}`
layout to this flatter one at the user's request. All internal imports use absolute
`package:tap_the_dot/...` paths (not relative) by design, to avoid deep `../../../` chains.

## Assets (`assets/`)
- `images/`: background.png, bomb.png, coin.png, trophy.png, soft_glow.png,
  and 6 dot skins — dot_classic/candy/fire/ice/neon/rainbow.png
- `audio/`: tap_sound.mp3, success_sound.mp3, coin_collect.mp3, bomb_explode.mp3
  (4 more sfx are referenced by name in `AssetConstants` but not yet imported —
  `AudioService.play()` no-ops silently for those, by design)
- `pubspec.yaml` declares both asset folders wholesale — no per-file listing needed.

## Gameplay systems (already fully implemented, not a skeleton)
- **GameController** (`services/game_controller.dart`): owns the 30s countdown, score,
  combo, Fever Mode, coins. `TapDotGame` only reports outcomes to it via
  `registerHit` / `registerWrongTap` / `registerTimeout`.
- **Combo**: 5 tiers (x1–x5) by consecutive-hit thresholds (`ComboRules`). Wrong tap
  steps combo down by 1; a timed-out target resets combo to 0.
- **Fever Mode**: triggers at 10-combo, lasts 5s, doubles score.
- **Difficulty ramp** (`DifficultySystem`): first 4s pinned to easiest; ramps target
  size down / spawn rate up over 25s total.
- **Spawn** (`SpawnSystem`): safe-margin random positions, min separation from last
  spawn, 5% chance of a bonus "Golden Dot" (+10 score, +5 coins).
- **Hit zones**: perfect/good/normal/miss by tap distance from target center.
- **Persistence**: `PlayerProgress` (bestScore, coins, unlockedSkinIds, selectedSkinId,
  sound/music/haptics flags) round-trips through `GameLocalDataSource` as JSON via
  `shared_preferences`. Only `bestScore` and `coins` are currently read/written by
  `GameController`; the skin/settings fields exist on the model but aren't yet wired
  end-to-end (see "Known gaps" below).

## Screens / navigation (in progress this session)
Building out: Splash, Home, Game, Shop, Settings, Profile, Rewards, Game Over/Result.
- Game Over is an **overlay** (`GameOverOverlay`) shown on top of the Flame `GameWidget`
  inside `GamePage`, not a separate pushed route — intentional, avoids tearing down the
  Flame game to show results.
- Shop/Settings/Profile/Rewards are being added as new screens + named routes, using
  only existing assets (dot skins for shop cards, trophy/coin for stat badges).
- Reusable widgets being introduced: `CartoonPanel`, `StatBadge` (coin/trophy display),
  `CartoonIconButton`, `ScreenTopBar`, `ShopSkinCard`, `RewardCard` — alongside the
  existing `GameButton`.

## Known gaps / intentionally not built yet
- No skin purchase/selection persistence — Shop is visual/cosmetic only for now
  (explicit instruction: "do not add backend yet").
- No settings persistence — Settings screen toggles `AudioService`/`HapticService`
  fields directly (in-memory only), doesn't write back to `PlayerProgress`.
- Rewards screen derives state purely from existing `bestScore` (no new reward-claim
  persistence).
- In-game dot skin is hardcoded to `dot_classic.png` in `TapDotGame.onLoad` — selecting
  a different skin in the Shop does not yet change what renders in a run.
- Only 4 of ~9 planned sound effects are imported (see `AssetConstants` comments).

## Conventions / preferences observed this session
- User wants a flat `lib/` layout (screens/widgets/models/services/theme), not
  feature-based clean architecture — confirmed via explicit choice when asked.
- Prefers existing working logic preserved during refactors ("move, don't rebuild").
- Incremental: build UI first, no backend/persistence additions until asked.
- Wants `flutter analyze` run and all errors fixed before considering a task done.

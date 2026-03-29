import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'dino.dart';
import 'enemy_manager.dart';
import '../models/player_data.dart';
import '../models/settings.dart';
import '../widgets/hud.dart';
import '../widgets/game_over_menu.dart';
import '../widgets/settings.dart' as settings_widget;

// This is the main flame game class.
class DinoRun extends FlameGame with TapDetector, HasCollisionDetection {
  DinoRun({super.camera});

  // List of all the image assets.
  static const _imageAssets = [
    'DinoSprites - tard.png',
    'AngryPig/Walk (36x30).png',
    'Bat/Flying (46x30).png',
    'Rino/Run (52x34).png',
    'parallax/plx-1.png',
    'parallax/plx-2.png',
    'parallax/plx-3.png',
    'parallax/plx-4.png',
    'parallax/plx-5.png',
    'parallax/plx-6.png',
  ];

  late Dino _dino;
  PlayerData playerData = PlayerData();
  Settings settings = Settings();
  late EnemyManager _enemyManager;
  late SpriteComponent _ground;

  Vector2 get virtualSize => camera.viewport.virtualSize;

  // This method get called while flame is preparing this game.
  @override
  Future<void> onLoad() async {
    // Makes the game full screen and landscape only.
    await Flame.device.fullScreen();
    await Flame.device.setLandscape();

    /// Read [PlayerData] and [Settings] from hive.
    playerData = await _readPlayerData();
    settings = await _readSettings();

    // Cache all the images.
    await images.loadAll(_imageAssets);

    // This makes the camera look at the center of the viewport.
    camera.viewfinder.position = camera.viewport.virtualSize * 0.5;

    /// Create a simple background
    final background = SpriteComponent()
      ..sprite = Sprite(images.fromCache('parallax/plx-1.png'))
      ..size = Vector2(virtualSize.x, virtualSize.y);
    world.add(background);
    
    /// Create a simple ground
    _ground = SpriteComponent()
      ..sprite = Sprite(images.fromCache('DinoSprites - tard.png'))
      ..size = Vector2(virtualSize.x * 2, 50)
      ..position = Vector2(0, virtualSize.y - 50);
    world.add(_ground);
  }

  /// This method add the already created [Dino]
  /// and [EnemyManager] to this game.
  void startGamePlay() {
    _dino = Dino(images.fromCache('DinoSprites - tard.png'), playerData);
    _enemyManager = EnemyManager();

    world.add(_dino);
    world.add(_enemyManager);
  }

  // This method remove all the actors from the game.
  void _disconnectActors() {
    _dino.removeFromParent();
    _enemyManager.removeAllEnemies();
    _enemyManager.removeFromParent();
  }

  // This method reset the whole game world to initial state.
  void reset() {
    // First disconnect all actions from game world.
    _disconnectActors();

    // Reset player data to inital values.
    playerData.currentScore = 0;
    playerData.lives = 5;
  }

  // This method gets called for each tick/frame of the game.
  @override
  void update(double dt) {
    // If number of lives is 0 or less, game is over.
    if (playerData.lives <= 0) {
      overlays.add(GameOverMenu.id);
      overlays.remove(Hud.id);
      pauseEngine();
    }
    super.update(dt);
  }

  // This will get called for each tap on the screen.
  @override
  void onTapDown(TapDownInfo info) {
    // Make dino jump only when game is playing.
    // When game is in playing state, only Hud will be the active overlay.
    if (overlays.isActive(Hud.id)) {
      _dino.jump();
    }
    super.onTapDown(info);
  }

  /// This method is called when this game is removed.
  @override
  void onRemove() {
    // Save player data.
    playerData.save();
    super.onRemove();
  }

  /// Reads the player data from local storage.
  Future<PlayerData> _readPlayerData() async {
    return playerData;
  }

  /// Reads the settings from local storage.
  Future<Settings> _readSettings() async {
    return settings;
  }

  /// This method is called when the app is paused.
  @override
  void lifecycleStateChange(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        pauseEngine();
        break;
      case AppLifecycleState.resumed:
        resumeEngine();
        break;
      default:
        break;
    }
    super.lifecycleStateChange(state);
  }

  // Stub methods for compatibility
  Future<void> updateTheme(dynamic theme) async {}
  dynamic get themeManager => null;
  dynamic get effectsManager => null;
  dynamic get assetPreloader => null;
  dynamic get playerProfile => null;
  dynamic get characterManager => null;
  dynamic get challengeManager => null;
  dynamic get skillManager => null;
  dynamic get bossManager => null;
}

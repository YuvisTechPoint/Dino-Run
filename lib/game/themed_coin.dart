import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

import 'dino.dart';
import 'dino_run.dart';
import 'audio_manager.dart';
import '../models/player_data.dart';
import '../models/game_theme.dart';

/// Themed collectible that changes appearance based on current theme
class ThemedCoin extends SpriteAnimationComponent with HasGameReference<DinoRun>, CollisionCallbacks {
  static final Map<GameThemeType, SpriteAnimationData> _animationData = {
    GameThemeType.classic: SpriteAnimationData.sequenced(
      amount: 8,
      stepTime: 0.1,
      textureSize: Vector2(16, 16),
    ),
    GameThemeType.desert: SpriteAnimationData.sequenced(
      amount: 6,
      stepTime: 0.15,
      textureSize: Vector2(20, 20),
    ),
    GameThemeType.forest: SpriteAnimationData.sequenced(
      amount: 8,
      stepTime: 0.12,
      textureSize: Vector2(18, 18),
    ),
    GameThemeType.city: SpriteAnimationData.sequenced(
      amount: 4,
      stepTime: 0.2,
      textureSize: Vector2(22, 22),
    ),
  };

  final PlayerData playerData;
  late GameThemeType _currentTheme;

  ThemedCoin(Image image, this.playerData) : super.fromFrameData(image, _animationData[GameThemeType.classic]!) {
    _currentTheme = GameThemeType.classic;
  }

  @override
  Future<void> onLoad() async {
    _updateForTheme();
    
    add(
      RectangleHitbox.relative(
        Vector2.all(0.8),
        parentSize: size,
        position: Vector2(size.x * 0.1, size.y * 0.1) / 2,
      ),
    );
    
    super.onLoad();
  }

  @override
  void update(double dt) {
    // Check if theme has changed
    final currentTheme = game.themeManager.currentTheme.type;
    if (_currentTheme != currentTheme) {
      _updateForTheme();
      _currentTheme = currentTheme;
    }
    
    super.update(dt);
  }

  void _updateForTheme() {
    final theme = game.themeManager.currentTheme;
    
    // Update animation based on theme
    animation = SpriteAnimation.fromFrameData(
      _getThemeImage(theme),
      _animationData[theme.type]!,
    );
    
    // Update size based on theme
    final animData = _animationData[theme.type]!;
    size = Vector2(16, 16); // Fixed size for now
  }

  Image _getThemeImage(GameTheme theme) {
    // For now, use placeholder images - in real implementation, these would be actual theme assets
    switch (theme.type) {
      case GameThemeType.classic:
        return game.images.fromCache('DinoSprites - tard.png'); // Placeholder for coin
      case GameThemeType.desert:
        return game.images.fromCache('DinoSprites - tard.png'); // Placeholder for water drop
      case GameThemeType.forest:
        return game.images.fromCache('DinoSprites - tard.png'); // Placeholder for berry
      case GameThemeType.city:
        return game.images.fromCache('DinoSprites - tard.png'); // Placeholder for energy drink
      case GameThemeType.ocean:
      case GameThemeType.space:
      case GameThemeType.candy:
      case GameThemeType.winter:
      case GameThemeType.jungle:
      case GameThemeType.volcano:
        // New themes use placeholder until specific assets are available
        return game.images.fromCache('DinoSprites - tard.png');
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Dino && !other.isHit) {
      // Play collection sound
      AudioManager.instance.playSfx('coin.wav');
      
      // Add theme-specific bonus points
      final bonus = _getThemeBonus();
      playerData.currentScore += bonus;
      
      // Remove collectible from game
      removeFromParent();
    }
  }

  int _getThemeBonus() {
    switch (_currentTheme) {
      case GameThemeType.classic:
        return 10; // Standard coin value
      case GameThemeType.desert:
        return 15; // Water drops are more valuable in desert
      case GameThemeType.forest:
        return 12; // Berries have moderate value
      case GameThemeType.city:
        return 20; // Energy drinks are most valuable
      case GameThemeType.ocean:
      case GameThemeType.space:
      case GameThemeType.candy:
      case GameThemeType.winter:
      case GameThemeType.jungle:
      case GameThemeType.volcano:
        return 12; // Default value for new themes
    }
  }

  /// Get the collectible name for the current theme
  String getCollectibleName() {
    switch (_currentTheme) {
      case GameThemeType.classic:
        return 'Coin';
      case GameThemeType.desert:
        return 'Water Drop';
      case GameThemeType.forest:
        return 'Berry';
      case GameThemeType.city:
        return 'Energy Drink';
      case GameThemeType.ocean:
        return 'Pearl';
      case GameThemeType.space:
        return 'Star Crystal';
      case GameThemeType.candy:
        return 'Candy';
      case GameThemeType.winter:
        return 'Snowflake';
      case GameThemeType.jungle:
        return 'Exotic Fruit';
      case GameThemeType.volcano:
        return 'Fire Gem';
    }
  }
}

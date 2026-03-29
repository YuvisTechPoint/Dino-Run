import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

import 'dino.dart';
import 'dino_run.dart';
import 'audio_manager.dart';
import '../models/player_data.dart';
import '../models/game_theme.dart';
import 'themed_parallax.dart';

/// Enum for different types of power-ups
enum PowerUpType {
  invincibility,
  doubleJump,
  speedBoost,
}

/// Themed power-up that changes appearance based on current theme
class ThemedPowerUp extends SpriteAnimationComponent with HasGameReference<DinoRun>, CollisionCallbacks {
  static final Map<GameThemeType, Map<PowerUpType, SpriteAnimationData>> _animationData = {
    GameThemeType.classic: {
      PowerUpType.invincibility: SpriteAnimationData.sequenced(
        amount: 8,
        stepTime: 0.1,
        textureSize: Vector2(24, 24),
      ),
      PowerUpType.doubleJump: SpriteAnimationData.sequenced(
        amount: 6,
        stepTime: 0.15,
        textureSize: Vector2(20, 20),
      ),
      PowerUpType.speedBoost: SpriteAnimationData.sequenced(
        amount: 10,
        stepTime: 0.08,
        textureSize: Vector2(22, 22),
      ),
    },
    GameThemeType.desert: {
      PowerUpType.invincibility: SpriteAnimationData.sequenced(
        amount: 6,
        stepTime: 0.12,
        textureSize: Vector2(26, 26),
      ),
      PowerUpType.doubleJump: SpriteAnimationData.sequenced(
        amount: 8,
        stepTime: 0.1,
        textureSize: Vector2(24, 24),
      ),
      PowerUpType.speedBoost: SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 0.2,
        textureSize: Vector2(28, 28),
      ),
    },
    GameThemeType.forest: {
      PowerUpType.invincibility: SpriteAnimationData.sequenced(
        amount: 7,
        stepTime: 0.11,
        textureSize: Vector2(25, 25),
      ),
      PowerUpType.doubleJump: SpriteAnimationData.sequenced(
        amount: 9,
        stepTime: 0.09,
        textureSize: Vector2(21, 21),
      ),
      PowerUpType.speedBoost: SpriteAnimationData.sequenced(
        amount: 5,
        stepTime: 0.18,
        textureSize: Vector2(23, 23),
      ),
    },
    GameThemeType.city: {
      PowerUpType.invincibility: SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 0.2,
        textureSize: Vector2(30, 30),
      ),
      PowerUpType.doubleJump: SpriteAnimationData.sequenced(
        amount: 6,
        stepTime: 0.13,
        textureSize: Vector2(26, 26),
      ),
      PowerUpType.speedBoost: SpriteAnimationData.sequenced(
        amount: 8,
        stepTime: 0.1,
        textureSize: Vector2(24, 24),
      ),
    },
  };

  final PowerUpType type;
  final PlayerData playerData;
  late GameThemeType _currentTheme;

  ThemedPowerUp(Image image, this.type, this.playerData) : super.fromFrameData(image, _animationData[GameThemeType.classic]![type]!) {
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
    
    // Update animation based on theme and type
    animation = SpriteAnimation.fromFrameData(
      _getThemeImage(theme),
      _animationData[theme.type]![type]!,
    );
    
    // Update size based on theme
    size = Vector2(24, 24); // Fixed size for now
  }

  Image _getThemeImage(GameTheme theme) {
    // For now, use placeholder images - in real implementation, these would be actual theme assets
    switch (theme.type) {
      case GameThemeType.classic:
        return game.images.fromCache('DinoSprites - tard.png'); // Placeholder for star power-up
      case GameThemeType.desert:
        return game.images.fromCache('DinoSprites - tard.png'); // Placeholder for canteen
      case GameThemeType.forest:
        return game.images.fromCache('DinoSprites - tard.png'); // Placeholder for mushroom
      case GameThemeType.city:
        return game.images.fromCache('DinoSprites - tard.png'); // Placeholder for helmet
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Dino && !other.isHit) {
      // Play power-up sound
      AudioManager.instance.playSfx('powerup.wav');
      
      // Apply power-up effect
      _applyPowerUpEffect();
      
      // Add bonus points
      playerData.currentScore += 25;
      
      // Remove power-up from game
      removeFromParent();
    }
    super.onCollision(intersectionPoints, other);
  }

  void _applyPowerUpEffect() {
    // Find the dino in the game world
    final dino = game.world.children.whereType<Dino>().firstOrNull;
    if (dino == null) return;
    
    switch (type) {
      case PowerUpType.invincibility:
        // Make dino invincible for 5 seconds
        dino.makeInvincible(5.0);
        break;
      case PowerUpType.doubleJump:
        // Enable double jump permanently
        dino.enableDoubleJump();
        break;
      case PowerUpType.speedBoost:
        // Apply speed boost through the themed parallax system
        final parallaxSystem = game.world.children.whereType<ThemedParallax>().firstOrNull;
        if (parallaxSystem != null) {
          parallaxSystem.applySpeedBoost(2.0); // Double speed
          
          // Reset after 3 seconds
          Future.delayed(const Duration(seconds: 3), () {
            if (parallaxSystem.isMounted) {
              parallaxSystem.resetSpeed();
            }
          });
        }
        
        // Add bonus points for speed boost
        playerData.currentScore += 10;
        break;
    }
  }

  /// Get the power-up name for the current theme
  String getPowerUpName() {
    switch (_currentTheme) {
      case GameThemeType.classic:
        switch (type) {
          case PowerUpType.invincibility: return 'Star';
          case PowerUpType.doubleJump: return 'Feather';
          case PowerUpType.speedBoost: return 'Lightning';
        }
      case GameThemeType.desert:
        switch (type) {
          case PowerUpType.invincibility: return 'Canteen';
          case PowerUpType.doubleJump: return 'Sandals';
          case PowerUpType.speedBoost: return 'Turban';
        }
      case GameThemeType.forest:
        switch (type) {
          case PowerUpType.invincibility: return 'Mushroom';
          case PowerUpType.doubleJump: return 'Vine';
          case PowerUpType.speedBoost: return 'Leaf';
        }
      case GameThemeType.city:
        switch (type) {
          case PowerUpType.invincibility: return 'Helmet';
          case PowerUpType.doubleJump: return 'Jetpack';
          case PowerUpType.speedBoost: return 'Skateboard';
        }
    }
  }
}

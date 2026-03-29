import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/parallax.dart';

import 'dino.dart';
import 'dino_run.dart';
import 'audio_manager.dart';
import '../models/player_data.dart';

/// Enum for different types of power-ups
enum PowerUpType {
  invincibility,
  doubleJump,
  speedBoost,
}

/// This represents a power-up in the game.
class PowerUp extends SpriteAnimationComponent with HasGameReference<DinoRun>, CollisionCallbacks {
  static final _animationData = SpriteAnimationData.sequenced(
    amount: 6,
    stepTime: 0.15,
    textureSize: Vector2.all(20),
  );

  final PowerUpType type;
  final PlayerData playerData;

  PowerUp(Image image, this.type, this.playerData) : super.fromFrameData(image, _animationData);

  @override
  void onMount() {
    add(
      RectangleHitbox.relative(
        Vector2(0.8, 0.8),
        parentSize: size,
        position: Vector2(size.x * 0.1, size.y * 0.1) / 2,
      ),
    );
    super.onMount();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Dino) {
      _collect();
    }
    super.onCollision(intersectionPoints, other);
  }

  void _collect() {
    // Apply power-up effect
    _applyPowerUpEffect();
    
    // Play collection sound
    AudioManager.instance.playSfx('powerup.wav');
    
    // Add bonus points
    playerData.currentScore += 25;
    
    // Remove power-up from game
    removeFromParent();
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
        // Increase game speed temporarily
        // This would be implemented in the game manager
        _applySpeedBoost();
        break;
    }
  }
  
  void _applySpeedBoost() {
    // For now, just add bonus points for speed boost
    // The visual speed effect would require more complex implementation
    // involving the parallax system which doesn't expose baseVelocity directly
    playerData.currentScore += 10; // Bonus points for speed boost
  }
}

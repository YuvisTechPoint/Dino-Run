import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import 'dino.dart';
import 'dino_run.dart';
import 'audio_manager.dart';
import '../models/player_data.dart';

/// This represents a collectible coin in the game.
class Coin extends SpriteAnimationComponent with HasGameReference<DinoRun>, CollisionCallbacks {
  static final _animationData = SpriteAnimationData.sequenced(
    amount: 8,
    stepTime: 0.1,
    textureSize: Vector2.all(16),
  );

  final PlayerData playerData;

  Coin(Image image, this.playerData) : super.fromFrameData(image, _animationData);

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
    // Add points to the score
    playerData.currentScore += 10;
    
    // Play collection sound
    AudioManager.instance.playSfx('coin.wav');
    
    // Remove coin from game
    removeFromParent();
  }
}

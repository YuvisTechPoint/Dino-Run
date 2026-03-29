import 'dart:math';

import 'package:flame/components.dart';

import 'power_up.dart';
import 'dino_run.dart';
import '../models/player_data.dart';

/// This class manages spawning and handling power-ups in the game.
class PowerUpManager extends Component with HasGameReference<DinoRun> {
  final Random _random = Random();
  final Timer _timer = Timer(8, repeat: true); // Spawn every 8 seconds

  PowerUpManager() {
    _timer.onTick = _spawnPowerUp;
  }

  void _spawnPowerUp() {
    // Randomly select power-up type
    final powerUpTypes = PowerUpType.values;
    final randomType = powerUpTypes[_random.nextInt(powerUpTypes.length)];
    
    // Load power-up image (using placeholder for now)
    final powerUpImage = game.images.fromCache('DinoSprites - tard.png'); // Placeholder
    final powerUp = PowerUp(powerUpImage, randomType, game.playerData);

    // Set power-up position
    powerUp.anchor = Anchor.bottomLeft;
    powerUp.position = Vector2(
      game.virtualSize.x + 32,
      game.virtualSize.y - 24 - _random.nextDouble() * 80, // Random height
    );
    powerUp.size = Vector2.all(20);

    game.world.add(powerUp);
  }

  @override
  void onMount() {
    _timer.start();
    super.onMount();
  }

  @override
  void update(double dt) {
    _timer.update(dt);
    super.update(dt);
  }

  void removeAllPowerUps() {
    final powerUps = game.world.children.whereType<PowerUp>();
    for (var powerUp in powerUps) {
      powerUp.removeFromParent();
    }
  }
}

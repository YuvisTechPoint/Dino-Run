import 'dart:math';

import 'package:flame/components.dart';

import 'coin.dart';
import 'dino_run.dart';
import '../models/player_data.dart';

/// This class manages spawning and handling coins in the game.
class CoinManager extends Component with HasGameReference<DinoRun> {
  final Random _random = Random();
  final Timer _timer = Timer(3, repeat: true);

  CoinManager() {
    _timer.onTick = _spawnCoin;
  }

  void _spawnCoin() {
    // Load coin image (using a placeholder for now)
    final coinImage = game.images.fromCache('DinoSprites - tard.png'); // Placeholder
    final coin = Coin(coinImage, game.playerData);

    // Set coin position
    coin.anchor = Anchor.bottomLeft;
    coin.position = Vector2(
      game.virtualSize.x + 32,
      game.virtualSize.y - 24 - _random.nextDouble() * 100, // Random height
    );
    coin.size = Vector2.all(16);

    game.world.add(coin);
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

  void removeAllCoins() {
    final coins = game.world.children.whereType<Coin>();
    for (var coin in coins) {
      coin.removeFromParent();
    }
  }
}

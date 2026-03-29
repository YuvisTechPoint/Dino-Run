import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import '../game/dino_run.dart';
import '../models/game_theme.dart';

/// Parallax system that adapts to current theme
class ThemedParallax extends Component with HasGameReference<DinoRun> {
  late ParallaxComponent _currentParallax;
  GameTheme? _lastTheme;

  Future<void> onLoad() async {
    await _loadParallaxForTheme(game.themeManager.currentTheme);
    super.onMount();
  }

  @override
  void update(double dt) {
    // Check if theme has changed
    final currentTheme = game.themeManager.currentTheme;
    if (_lastTheme?.type != currentTheme.type) {
      _updateParallaxForTheme(currentTheme);
    }
    super.update(dt);
  }

  Future<void> _loadParallaxForTheme(GameTheme theme) async {
    try {
      // For now, use the classic parallax as base for all themes
      // In real implementation, each theme would have its own parallax assets
      final parallaxBackground = await game.loadParallaxComponent(
        [
          ParallaxImageData('parallax/plx-1.png'),
          ParallaxImageData('parallax/plx-2.png'),
          ParallaxImageData('parallax/plx-3.png'),
          ParallaxImageData('parallax/plx-4.png'),
          ParallaxImageData('parallax/plx-5.png'),
          ParallaxImageData('parallax/plx-6.png'),
        ],
        baseVelocity: Vector2(10, 0),
        velocityMultiplierDelta: Vector2(1.4, 0),
      );

      _currentParallax = parallaxBackground;
      add(_currentParallax);
      _lastTheme = theme;
    } catch (e) {
      print('Error loading parallax: $e');
      // Fallback to empty parallax
      _lastTheme = theme;
    }
  }

  void _updateParallaxForTheme(GameTheme newTheme) async {
    // Remove current parallax
    if (_currentParallax.isMounted) {
      _currentParallax.removeFromParent();
    }

    // Load new parallax for the theme
    await _loadParallaxForTheme(newTheme);
  }

  /// Adjust parallax speed for power-ups
  void applySpeedBoost(double multiplier) {
    // For now, just add bonus points since parallax speed control is limited
    // This would be implemented with a custom parallax system in a real game
  }

  /// Reset parallax speed to normal
  void resetSpeed() {
    // Reset functionality would be implemented with custom parallax system
  }
  
  /// Update the theme (public method called from game)
  void updateTheme(GameTheme newTheme) {
    _updateParallaxForTheme(newTheme);
  }
}

import 'package:flame/components.dart';
import 'package:flutter/painting.dart';
import '../game/dino_run.dart';
import '../models/game_theme.dart';

/// Ground that changes appearance based on current theme
class ThemedGround extends PositionComponent with HasGameReference<DinoRun> {
  late RectangleComponent _groundComponent;
  GameTheme? _lastTheme;

  @override
  Future<void> onLoad() async {
    _createGroundForTheme(game.themeManager.currentTheme);
    super.onMount();
  }

  @override
  void update(double dt) {
    // Check if theme has changed
    final currentTheme = game.themeManager.currentTheme;
    if (_lastTheme?.type != currentTheme.type) {
      _updateGroundForTheme(currentTheme);
    }
    super.update(dt);
  }

  void _createGroundForTheme(GameTheme theme) {
    // Remove existing ground if any
    if (_groundComponent.isMounted) {
      _groundComponent.removeFromParent();
    }

    // Create new ground with theme-specific appearance
    _groundComponent = RectangleComponent(
      size: Vector2(game.virtualSize.x, 24),
      paint: Paint()
        ..color = _getGroundColor(theme)
        ..style = PaintingStyle.fill,
    );

    // Position ground at bottom of screen
    _groundComponent.position = Vector2(0, game.virtualSize.y - 24);
    
    add(_groundComponent);
    _lastTheme = theme;
  }

  void _updateGroundForTheme(GameTheme newTheme) {
    _createGroundForTheme(newTheme);
  }

  Color _getGroundColor(GameTheme theme) {
    switch (theme.type) {
      case GameThemeType.classic:
        return const Color(0xFF8B4513); // Brown ground
      case GameThemeType.desert:
        return const Color(0xFFEDC9AF); // Sandy color
      case GameThemeType.forest:
        return const Color(0xFF654321); // Dark brown earth
      case GameThemeType.city:
        return const Color(0xFF696969); // Asphalt gray
    }
  }

  /// Get ground texture name for the current theme
  String getGroundTextureName() {
    final theme = game.themeManager.currentTheme;
    switch (theme.type) {
      case GameThemeType.classic:
        return 'Classic Ground';
      case GameThemeType.desert:
        return 'Sandy Desert Floor';
      case GameThemeType.forest:
        return 'Forest Earth';
      case GameThemeType.city:
        return 'City Asphalt';
    }
  }

  /// Get ground description for the current theme
  String getGroundDescription() {
    final theme = game.themeManager.currentTheme;
    switch (theme.type) {
      case GameThemeType.classic:
        return 'Run on the classic brown terrain';
      case GameThemeType.desert:
        return 'Dash across the hot sandy desert floor';
      case GameThemeType.forest:
        return 'Navigate through the forest earth path';
      case GameThemeType.city:
        return 'Speed along the urban asphalt streets';
    }
  }
}

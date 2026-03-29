import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'game_theme.g.dart';

/// Enum for different game themes
enum GameThemeType {
  classic,    // Original theme
  desert,     // Desert theme with sand and cacti
  forest,     // Forest theme with trees and nature
  city,       // Urban theme with buildings
}

/// Represents a game theme with all its visual and gameplay elements
@HiveType(typeId: 3)
class GameTheme extends ChangeNotifier with HiveObjectMixin {
  @HiveField(0)
  GameThemeType type;
  
  @HiveField(1)
  String name;
  
  @HiveField(2)
  String description;
  
  @HiveField(3)
  Color primaryColor;
  
  @HiveField(4)
  Color secondaryColor;
  
  @HiveField(5)
  Color backgroundColor;
  
  @HiveField(6)
  List<String> parallaxLayers;
  
  @HiveField(7)
  String groundTexture;
  
  @HiveField(8)
  List<String> enemyTypes;
  
  @HiveField(9)
  String collectibleType;
  
  @HiveField(10)
  String powerUpType;
  
  @HiveField(11)
  bool isUnlocked;

  GameTheme({
    required this.type,
    required this.name,
    required this.description,
    required this.primaryColor,
    required this.secondaryColor,
    required this.backgroundColor,
    required this.parallaxLayers,
    required this.groundTexture,
    required this.enemyTypes,
    required this.collectibleType,
    required this.powerUpType,
    this.isUnlocked = false,
  });

  /// Get predefined themes
  static List<GameTheme> getPredefinedThemes() {
    return [
      // Classic Theme (Original)
      GameTheme(
        type: GameThemeType.classic,
        name: 'Classic',
        description: 'The original Dino Run experience',
        primaryColor: const Color(0xFF4ECDC4),
        secondaryColor: const Color(0xFF44A3AA),
        backgroundColor: const Color(0xFF87CEEB),
        parallaxLayers: [
          'parallax/plx-1.png',
          'parallax/plx-2.png',
          'parallax/plx-3.png',
          'parallax/plx-4.png',
          'parallax/plx-5.png',
          'parallax/plx-6.png',
        ],
        groundTexture: 'ground/classic_ground.png',
        enemyTypes: ['AngryPig/Walk (36x30).png', 'Bat/Flying (46x30).png', 'Rino/Run (52x34).png'],
        collectibleType: 'collectibles/coin.png',
        powerUpType: 'powerups/star.png',
        isUnlocked: true, // Classic theme is always unlocked
      ),
      
      // Desert Theme
      GameTheme(
        type: GameThemeType.desert,
        name: 'Desert Adventure',
        description: 'Survive the harsh desert with cacti and sand dunes',
        primaryColor: const Color(0xFFEDC9AF),
        secondaryColor: const Color(0xFFDEB887),
        backgroundColor: const Color(0xFFF4E4C1),
        parallaxLayers: [
          'desert/desert_sky.png',
          'desert/desert_mountains.png',
          'desert/desert_dunes1.png',
          'desert/desert_dunes2.png',
          'desert/desert_dunes3.png',
          'desert/desert_ground.png',
        ],
        groundTexture: 'ground/desert_ground.png',
        enemyTypes: ['desert/scorpion.png', 'desert/vulture.png', 'desert/snake.png'],
        collectibleType: 'collectibles/water_drop.png',
        powerUpType: 'powerups/canteen.png',
        isUnlocked: false,
      ),
      
      // Forest Theme
      GameTheme(
        type: GameThemeType.forest,
        name: 'Forest Run',
        description: 'Dash through the mystical forest with ancient trees',
        primaryColor: const Color(0xFF228B22),
        secondaryColor: const Color(0xFF90EE90),
        backgroundColor: const Color(0xFF87CEEB),
        parallaxLayers: [
          'forest/forest_sky.png',
          'forest/forest_mountains.png',
          'forest/forest_trees1.png',
          'forest/forest_trees2.png',
          'forest/forest_trees3.png',
          'forest/forest_ground.png',
        ],
        groundTexture: 'ground/forest_ground.png',
        enemyTypes: ['forest/wolf.png', 'forest/bear.png', 'forest/eagle.png'],
        collectibleType: 'collectibles/berry.png',
        powerUpType: 'powerups/mushroom.png',
        isUnlocked: false,
      ),
      
      // City Theme
      GameTheme(
        type: GameThemeType.city,
        name: 'Urban Escape',
        description: 'Navigate through the bustling city streets',
        primaryColor: const Color(0xFF708090),
        secondaryColor: const Color(0xFFB0C4DE),
        backgroundColor: const Color(0xFF4A5568),
        parallaxLayers: [
          'city/city_sky.png',
          'city/city_buildings1.png',
          'city/city_buildings2.png',
          'city/city_buildings3.png',
          'city/city_streets.png',
          'city/city_ground.png',
        ],
        groundTexture: 'ground/city_ground.png',
        enemyTypes: ['city/car.png', 'city/dog.png', 'city/robot.png'],
        collectibleType: 'collectibles/energy_drink.png',
        powerUpType: 'powerups/helmet.png',
        isUnlocked: false,
      ),
    ];
  }
  
  /// Unlock this theme
  void unlock() {
    if (!isUnlocked) {
      isUnlocked = true;
      notifyListeners();
      save();
    }
  }
  
  /// Check if this theme is unlocked
  bool get unlocked => isUnlocked;
}

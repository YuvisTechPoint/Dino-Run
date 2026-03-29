import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'game_theme.g.dart';

/// Enum for different game themes
enum GameThemeType {
  classic,    // Original theme
  desert,     // Desert theme with sand and cacti
  forest,     // Forest theme with trees and nature
  city,       // Urban theme with buildings
  ocean,      // Underwater ocean theme
  space,      // Space theme with stars and planets
  candy,      // Sweet candy land theme
  winter,     // Snowy winter wonderland
  jungle,     // Dense jungle theme
  volcano,    // Lava volcano theme
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
  
  @HiveField(12)
  List<String> specialEffects;
  
  @HiveField(13)
  String backgroundMusic;
  
  @HiveField(14)
  List<String> particleEffects;
  
  @HiveField(15)
  String weatherEffect;

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
    this.isUnlocked = true, // All themes unlocked by default
    this.specialEffects = const [],
    this.backgroundMusic = 'audio/default_theme.mp3',
    this.particleEffects = const [],
    this.weatherEffect = 'none',
  });

  /// Get predefined themes
  static List<GameTheme> getPredefinedThemes() {
    return [
      // Classic Theme (Original)
      GameTheme(
        type: GameThemeType.classic,
        name: 'Classic',
        description: 'The original Dino Run experience with retro graphics',
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
        isUnlocked: true,
        specialEffects: ['retro_filter', 'pixel_dust'],
        backgroundMusic: 'audio/classic_theme.mp3',
        particleEffects: ['dust_clouds', 'retro_sparkles'],
        weatherEffect: 'none',
      ),
      
      // Desert Theme
      GameTheme(
        type: GameThemeType.desert,
        name: 'Desert Adventure',
        description: 'Survive the harsh desert with cacti, sand dunes and mirages',
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
        isUnlocked: true,
        specialEffects: ['heat_shimmer', 'mirage'],
        backgroundMusic: 'audio/desert_theme.mp3',
        particleEffects: ['sand_storm', 'heat_waves'],
        weatherEffect: 'sandstorm',
      ),
      
      // Forest Theme
      GameTheme(
        type: GameThemeType.forest,
        name: 'Forest Run',
        description: 'Dash through the mystical forest with ancient trees and fireflies',
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
        isUnlocked: true,
        specialEffects: ['fireflies', 'falling_leaves'],
        backgroundMusic: 'audio/forest_theme.mp3',
        particleEffects: ['leaf_particles', 'firefly_glow'],
        weatherEffect: 'gentle_breeze',
      ),
      
      // City Theme
      GameTheme(
        type: GameThemeType.city,
        name: 'Urban Escape',
        description: 'Navigate through the bustling city streets with neon lights',
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
        isUnlocked: true,
        specialEffects: ['neon_glow', 'traffic_lights'],
        backgroundMusic: 'audio/city_theme.mp3',
        particleEffects: ['smoke_effects', 'neon_sparkles'],
        weatherEffect: 'rain',
      ),
      
      // Ocean Theme
      GameTheme(
        type: GameThemeType.ocean,
        name: 'Deep Ocean',
        description: 'Explore the underwater world with coral reefs and sea creatures',
        primaryColor: const Color(0xFF006994),
        secondaryColor: const Color(0xFF40E0D0),
        backgroundColor: const Color(0xFF001F3F),
        parallaxLayers: [
          'ocean/ocean_surface.png',
          'ocean/ocean_layer1.png',
          'ocean/ocean_layer2.png',
          'ocean/ocean_layer3.png',
          'ocean/ocean_layer4.png',
          'ocean/ocean_floor.png',
        ],
        groundTexture: 'ground/ocean_floor.png',
        enemyTypes: ['ocean/shark.png', 'ocean/jellyfish.png', 'ocean/octopus.png'],
        collectibleType: 'collectibles/pearl.png',
        powerUpType: 'powerups/oxygen_tank.png',
        isUnlocked: true,
        specialEffects: ['bubble_animation', 'underwater_glow'],
        backgroundMusic: 'audio/ocean_theme.mp3',
        particleEffects: ['bubbles', 'water_rays'],
        weatherEffect: 'underwater_current',
      ),
      
      // Space Theme
      GameTheme(
        type: GameThemeType.space,
        name: 'Space Odyssey',
        description: 'Journey through space with stars, planets and asteroids',
        primaryColor: const Color(0xFF9D4EDD),
        secondaryColor: const Color(0xFFC77DFF),
        backgroundColor: const Color(0xFF10002B),
        parallaxLayers: [
          'space/stars_far.png',
          'space/stars_medium.png',
          'space/stars_close.png',
          'space/nebula.png',
          'space/asteroids.png',
          'space/space_station.png',
        ],
        groundTexture: 'ground/moon_surface.png',
        enemyTypes: ['space/alien.png', 'space/asteroid.png', 'space/ufo.png'],
        collectibleType: 'collectibles/star_crystal.png',
        powerUpType: 'powerups/jetpack.png',
        isUnlocked: true,
        specialEffects: ['starfield', 'zero_gravity'],
        backgroundMusic: 'audio/space_theme.mp3',
        particleEffects: ['star_particles', 'comet_trails'],
        weatherEffect: 'meteor_shower',
      ),
      
      // Candy Theme
      GameTheme(
        type: GameThemeType.candy,
        name: 'Candy Land',
        description: 'Sweet adventure in a world made of candy and sweets',
        primaryColor: const Color(0xFFFF69B4),
        secondaryColor: const Color(0xFFFFB6C1),
        backgroundColor: const Color(0xFFFFE4E1),
        parallaxLayers: [
          'candy/candy_clouds.png',
          'candy/candy_mountains.png',
          'candy/lollipop_forest.png',
          'candy/candy_cane_trees.png',
          'candy/gumdrop_hills.png',
          'candy/candy_ground.png',
        ],
        groundTexture: 'ground/candy_ground.png',
        enemyTypes: ['candy/gummy_bear.png', 'candy/lollipop_monster.png', 'candy/chocolate_blob.png'],
        collectibleType: 'collectibles/candy_coin.png',
        powerUpType: 'powerups/sugar_rush.png',
        isUnlocked: true,
        specialEffects: ['rainbow_trail', 'candy_sparkle'],
        backgroundMusic: 'audio/candy_theme.mp3',
        particleEffects: ['candy_confetti', 'sprinkles'],
        weatherEffect: 'candy_rain',
      ),
      
      // Winter Theme
      GameTheme(
        type: GameThemeType.winter,
        name: 'Winter Wonderland',
        description: 'Run through snowy landscapes with ice and aurora lights',
        primaryColor: const Color(0xFF87CEEB),
        secondaryColor: const Color(0xFFE0FFFF),
        backgroundColor: const Color(0xFFF0F8FF),
        parallaxLayers: [
          'winter/winter_sky.png',
          'winter/aurora.png',
          'winter/snow_mountains.png',
          'winter/snow_trees.png',
          'winter/igloos.png',
          'winter/snow_ground.png',
        ],
        groundTexture: 'ground/snow_ground.png',
        enemyTypes: ['winter/snowman.png', 'winter/ice_wolf.png', 'winter/polar_bear.png'],
        collectibleType: 'collectibles/snowflake.png',
        powerUpType: 'powerups/hot_chocolate.png',
        isUnlocked: true,
        specialEffects: ['aurora_lights', 'ice_reflection'],
        backgroundMusic: 'audio/winter_theme.mp3',
        particleEffects: ['snowflakes', 'ice_sparkles'],
        weatherEffect: 'snow',
      ),
      
      // Jungle Theme
      GameTheme(
        type: GameThemeType.jungle,
        name: 'Amazon Jungle',
        description: 'Dense jungle adventure with exotic wildlife and ancient ruins',
        primaryColor: const Color(0xFF355E3B),
        secondaryColor: const Color(0xFF538D22),
        backgroundColor: const Color(0xFF2E7D32),
        parallaxLayers: [
          'jungle/jungle_sky.png',
          'jungle/jungle_canopy.png',
          'jungle/jungle_vines.png',
          'jungle/ancient_ruins.png',
          'jungle/jungle_ferns.png',
          'jungle/jungle_ground.png',
        ],
        groundTexture: 'ground/jungle_ground.png',
        enemyTypes: ['jungle/tiger.png', 'jungle/monkey.png', 'jungle/snake.png'],
        collectibleType: 'collectibilities/exotic_fruit.png',
        powerUpType: 'powerups/torch.png',
        isUnlocked: true,
        specialEffects: ['vine_swing', 'ancient_glow'],
        backgroundMusic: 'audio/jungle_theme.mp3',
        particleEffects: ['fireflies', 'leaf_swirl'],
        weatherEffect: 'humidity',
      ),
      
      // Volcano Theme
      GameTheme(
        type: GameThemeType.volcano,
        name: 'Volcanic Escape',
        description: 'Escape the erupting volcano with lava flows and fire effects',
        primaryColor: const Color(0xFFFF4500),
        secondaryColor: const Color(0xFFFF6347),
        backgroundColor: const Color(0xFF8B0000),
        parallaxLayers: [
          'volcano/volcano_sky.png',
          'volcano/smoke_clouds.png',
          'volcano/lava_falls.png',
          'volcano/rock_formations.png',
          'volcano/lava_pools.png',
          'volcano/volcano_ground.png',
        ],
        groundTexture: 'ground/volcano_ground.png',
        enemyTypes: ['volcano/fire_demon.png', 'volcano/lava_monster.png', 'volcano/ash_cloud.png'],
        collectibleType: 'collectibles/fire_gem.png',
        powerUpType: 'powerups/fire_shield.png',
        isUnlocked: true,
        specialEffects: ['lava_glow', 'ash_fall'],
        backgroundMusic: 'audio/volcano_theme.mp3',
        particleEffects: ['lava_sparks', 'smoke_particles'],
        weatherEffect: 'ash_storm',
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

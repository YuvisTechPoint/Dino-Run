import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

// TODO: Generate Hive adapter with: flutter packages pub run build_runner build
// part 'character.g.dart';

/// Enum representing different character abilities
enum CharacterAbility {
  none,
  dash,           // Speed burst forward
  doubleJump,     // Enhanced double jump
  magnet,         // Coin magnet passive
  shield,         // Temporary invincibility
  glide,          // Slow fall after jump
  tiny,           // Smaller hitbox
}

/// Represents a playable character in the game
@HiveType(typeId: 5)
class Character extends ChangeNotifier with HiveObjectMixin {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String description;
  
  @HiveField(3)
  final String spriteSheetPath;
  
  @HiveField(4)
  final CharacterAbility ability;
  
  @HiveField(5)
  final double speedMultiplier;
  
  @HiveField(6)
  final double jumpMultiplier;
  
  @HiveField(7)
  final double hitboxScale;
  
  @HiveField(8)
  final int unlockCostCoins;
  
  @HiveField(9)
  final int unlockCostGems;
  
  @HiveField(10)
  bool _isUnlocked;
  
  @HiveField(11)
  int _playCount;
  
  @HiveField(12)
  int _highScore;

  Character({
    required this.id,
    required this.name,
    required this.description,
    required this.spriteSheetPath,
    required this.ability,
    this.speedMultiplier = 1.0,
    this.jumpMultiplier = 1.0,
    this.hitboxScale = 1.0,
    this.unlockCostCoins = 0,
    this.unlockCostGems = 0,
    bool isUnlocked = false,
  })  : _isUnlocked = isUnlocked,
        _playCount = 0,
        _highScore = 0;

  // Getters
  bool get isUnlocked => _isUnlocked;
  int get playCount => _playCount;
  int get highScore => _highScore;

  /// Unlock the character
  void unlock() {
    if (!_isUnlocked) {
      _isUnlocked = true;
      notifyListeners();
      save();
    }
  }

  /// Record a play session
  void recordPlay() {
    _playCount++;
    notifyListeners();
    save();
  }

  /// Update high score if beaten
  void updateHighScore(int score) {
    if (score > _highScore) {
      _highScore = score;
      notifyListeners();
      save();
    }
  }

  /// Get ability description
  String get abilityDescription {
    switch (ability) {
      case CharacterAbility.none:
        return 'Balanced stats, no special ability';
      case CharacterAbility.dash:
        return 'Tap twice to dash forward';
      case CharacterAbility.doubleJump:
        return 'Higher double jump with glide';
      case CharacterAbility.magnet:
        return 'Automatically attracts nearby coins';
      case CharacterAbility.shield:
        return 'Starts with temporary shield';
      case CharacterAbility.glide:
        return 'Hold jump to glide slowly';
      case CharacterAbility.tiny:
        return 'Smaller hitbox, easier to dodge';
    }
  }

  /// Get formatted cost string
  String get costString {
    if (unlockCostGems > 0) {
      return '$unlockCostGems Gems';
    } else if (unlockCostCoins > 0) {
      return '$unlockCostCoins Coins';
    }
    return 'Free';
  }

  /// Check if character can be unlocked with given resources
  bool canUnlock(int availableCoins, int availableGems) {
    if (_isUnlocked) return true;
    return availableCoins >= unlockCostCoins && availableGems >= unlockCostGems;
  }

  /// Get predefined characters
  static List<Character> getPredefinedCharacters() {
    return [
      Character(
        id: 'dino',
        name: 'Dino',
        description: 'The classic dinosaur. Balanced and reliable.',
        spriteSheetPath: 'DinoSprites - tard.png',
        ability: CharacterAbility.none,
        speedMultiplier: 1.0,
        jumpMultiplier: 1.0,
        hitboxScale: 1.0,
        isUnlocked: true,
      ),
      Character(
        id: 'speedy',
        name: 'Speedy',
        description: 'Fast as lightning! Dash ability for quick escapes.',
        spriteSheetPath: 'characters/speedy.png',
        ability: CharacterAbility.dash,
        speedMultiplier: 1.2,
        jumpMultiplier: 0.9,
        hitboxScale: 1.0,
        unlockCostCoins: 500,
      ),
      Character(
        id: 'jumper',
        name: 'Jumper',
        description: 'Can jump higher than anyone. Great for coin collecting!',
        spriteSheetPath: 'characters/jumper.png',
        ability: CharacterAbility.doubleJump,
        speedMultiplier: 0.95,
        jumpMultiplier: 1.3,
        hitboxScale: 1.0,
        unlockCostCoins: 1000,
      ),
      Character(
        id: 'collector',
        name: 'Collector',
        description: 'Coin magnet passive. Perfect for building wealth.',
        spriteSheetPath: 'characters/collector.png',
        ability: CharacterAbility.magnet,
        speedMultiplier: 0.9,
        jumpMultiplier: 1.0,
        hitboxScale: 1.0,
        unlockCostCoins: 2000,
      ),
      Character(
        id: 'tank',
        name: 'Tank',
        description: 'Larger but tougher. Can take more hits.',
        spriteSheetPath: 'characters/tank.png',
        ability: CharacterAbility.shield,
        speedMultiplier: 0.85,
        jumpMultiplier: 0.9,
        hitboxScale: 1.2,
        unlockCostGems: 50,
      ),
      Character(
        id: 'ninja',
        name: 'Ninja',
        description: 'Small and nimble. Harder to hit!',
        spriteSheetPath: 'characters/ninja.png',
        ability: CharacterAbility.tiny,
        speedMultiplier: 1.1,
        jumpMultiplier: 1.0,
        hitboxScale: 0.75,
        unlockCostGems: 100,
      ),
    ];
  }
}

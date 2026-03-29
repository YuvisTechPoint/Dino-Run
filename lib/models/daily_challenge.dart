import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'daily_challenge.g.dart';

/// Challenge types and difficulties
enum ChallengeType {
  score,           // Reach target score
  distance,        // Run specific distance
  coins,           // Collect coins
  enemies,         // Defeat enemies
  powerUps,        // Collect power-ups
  perfectRun,      // Complete without damage
  speedRun,        // Complete in time
  theme,           // Use specific theme
  character,       // Use specific character
  combo,           // Maintain combo
}

enum ChallengeDifficulty {
  easy,            // Low rewards, simple requirements
  medium,          // Moderate rewards and difficulty
  hard,            // High rewards, challenging
  legendary,       // Epic rewards, very difficult
}

/// Daily challenge with rewards and requirements
@HiveType(typeId: 6)
class DailyChallenge extends ChangeNotifier with HiveObjectMixin {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String title;
  
  @HiveField(2)
  final String description;
  
  @HiveField(3)
  final ChallengeType type;
  
  @HiveField(4)
  final ChallengeDifficulty difficulty;
  
  @HiveField(5)
  final int targetValue;
  
  @HiveField(6)
  final int rewardCoins;
  
  @HiveField(7)
  final int rewardExperience;
  
  @HiveField(8)
  final String specialReward;
  
  @HiveField(9)
  final DateTime dateCreated;
  
  @HiveField(10)
  final DateTime? dateCompleted;
  
  @HiveField(11)
  final Map<String, dynamic> requirements; // Additional requirements
  
  @HiveField(12)
  bool isCompleted;

  DailyChallenge({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.difficulty,
    required this.targetValue,
    required this.rewardCoins,
    required this.rewardExperience,
    this.specialReward = '',
    required this.dateCreated,
    this.dateCompleted,
    this.requirements = const {},
    this.isCompleted = false,
  });

  /// Generate daily challenges for the day
  static List<DailyChallenge> generateDailyChallenges() {
    final today = DateTime.now();
    final seed = today.day + today.month * 31; // Simple seed for consistency
    
    final challenges = <DailyChallenge>[];
    final random = seed; // Use seed for consistent daily challenges
    
    // Generate 3 challenges of varying difficulties
    challenges.addAll([
      _generateChallenge('daily_1', ChallengeType.score, ChallengeDifficulty.easy, random),
      _generateChallenge('daily_2', ChallengeType.distance, ChallengeDifficulty.medium, random + 1),
      _generateChallenge('daily_3', ChallengeType.enemies, ChallengeDifficulty.hard, random + 2),
    ]);
    
    return challenges;
  }

  /// Generate a single challenge
  static DailyChallenge _generateChallenge(String id, ChallengeType type, ChallengeDifficulty difficulty, int seed) {
    final random = seed % 1000;
    
    switch (type) {
      case ChallengeType.score:
        return DailyChallenge(
          id: id,
          title: 'Score Hunter',
          description: 'Score ${_getTargetValue(type, difficulty, random)} points',
          type: type,
          difficulty: difficulty,
          targetValue: _getTargetValue(type, difficulty, random),
          rewardCoins: _getCoinReward(difficulty),
          rewardExperience: _getExpReward(difficulty),
          specialReward: _getSpecialReward(difficulty),
          dateCreated: DateTime.now(),
        );
        
      case ChallengeType.distance:
        return DailyChallenge(
          id: id,
          title: 'Distance Runner',
          description: 'Run ${_getTargetValue(type, difficulty, random)} meters',
          type: type,
          difficulty: difficulty,
          targetValue: _getTargetValue(type, difficulty, random),
          rewardCoins: _getCoinReward(difficulty),
          rewardExperience: _getExpReward(difficulty),
          specialReward: _getSpecialReward(difficulty),
          dateCreated: DateTime.now(),
        );
        
      case ChallengeType.coins:
        return DailyChallenge(
          id: id,
          title: 'Coin Collector',
          description: 'Collect ${_getTargetValue(type, difficulty, random)} coins',
          type: type,
          difficulty: difficulty,
          targetValue: _getTargetValue(type, difficulty, random),
          rewardCoins: _getCoinReward(difficulty),
          rewardExperience: _getExpReward(difficulty),
          specialReward: _getSpecialReward(difficulty),
          dateCreated: DateTime.now(),
        );
        
      case ChallengeType.enemies:
        return DailyChallenge(
          id: id,
          title: 'Enemy Defeater',
          description: 'Defeat ${_getTargetValue(type, difficulty, random)} enemies',
          type: type,
          difficulty: difficulty,
          targetValue: _getTargetValue(type, difficulty, random),
          rewardCoins: _getCoinReward(difficulty),
          rewardExperience: _getExpReward(difficulty),
          specialReward: _getSpecialReward(difficulty),
          dateCreated: DateTime.now(),
        );
        
      case ChallengeType.powerUps:
        return DailyChallenge(
          id: id,
          title: 'Power Up Master',
          description: 'Collect ${_getTargetValue(type, difficulty, random)} power-ups',
          type: type,
          difficulty: difficulty,
          targetValue: _getTargetValue(type, difficulty, random),
          rewardCoins: _getCoinReward(difficulty),
          rewardExperience: _getExpReward(difficulty),
          specialReward: _getSpecialReward(difficulty),
          dateCreated: DateTime.now(),
        );
        
      case ChallengeType.perfectRun:
        return DailyChallenge(
          id: id,
          title: 'Perfect Runner',
          description: 'Complete a run without taking damage',
          type: type,
          difficulty: difficulty,
          targetValue: 1,
          rewardCoins: _getCoinReward(difficulty) * 2,
          rewardExperience: _getExpReward(difficulty) * 2,
          specialReward: _getSpecialReward(difficulty),
          dateCreated: DateTime.now(),
        );
        
      case ChallengeType.speedRun:
        return DailyChallenge(
          id: id,
          title: 'Speed Demon',
          description: 'Score ${_getTargetValue(type, difficulty, random)} points in under 2 minutes',
          type: type,
          difficulty: difficulty,
          targetValue: _getTargetValue(type, difficulty, random),
          rewardCoins: _getCoinReward(difficulty),
          rewardExperience: _getExpReward(difficulty),
          specialReward: _getSpecialReward(difficulty),
          dateCreated: DateTime.now(),
          requirements: {'timeLimit': 120},
        );
        
      case ChallengeType.theme:
        final themes = ['desert', 'forest', 'city', 'ocean', 'space', 'candy', 'winter', 'jungle', 'volcano'];
        final selectedTheme = themes[random % themes.length];
        return DailyChallenge(
          id: id,
          title: 'Theme Explorer',
          description: 'Score ${_getTargetValue(type, difficulty, random)} points using $selectedTheme theme',
          type: type,
          difficulty: difficulty,
          targetValue: _getTargetValue(type, difficulty, random),
          rewardCoins: _getCoinReward(difficulty),
          rewardExperience: _getExpReward(difficulty),
          specialReward: _getSpecialReward(difficulty),
          dateCreated: DateTime.now(),
          requirements: {'theme': selectedTheme},
        );
        
      case ChallengeType.character:
        final characters = ['dino_speed', 'dino_tank', 'dino_mystic', 'dino_scout', 'dino_warrior', 'dino_explorer'];
        final selectedCharacter = characters[random % characters.length];
        return DailyChallenge(
          id: id,
          title: 'Character Specialist',
          description: 'Score ${_getTargetValue(type, difficulty, random)} points as $selectedCharacter',
          type: type,
          difficulty: difficulty,
          targetValue: _getTargetValue(type, difficulty, random),
          rewardCoins: _getCoinReward(difficulty),
          rewardExperience: _getExpReward(difficulty),
          specialReward: _getSpecialReward(difficulty),
          dateCreated: DateTime.now(),
          requirements: {'character': selectedCharacter},
        );
        
      case ChallengeType.combo:
        return DailyChallenge(
          id: id,
          title: 'Combo Master',
          description: 'Maintain a ${_getTargetValue(type, difficulty, random)}x combo',
          type: type,
          difficulty: difficulty,
          targetValue: _getTargetValue(type, difficulty, random),
          rewardCoins: _getCoinReward(difficulty),
          rewardExperience: _getExpReward(difficulty),
          specialReward: _getSpecialReward(difficulty),
          dateCreated: DateTime.now(),
        );
    }
  }

  /// Get target value based on type and difficulty
  static int _getTargetValue(ChallengeType type, ChallengeDifficulty difficulty, int random) {
    final baseValues = {
      ChallengeType.score: {'easy': 500, 'medium': 1000, 'hard': 2500, 'legendary': 5000},
      ChallengeType.distance: {'easy': 500, 'medium': 1000, 'hard': 2000, 'legendary': 3000},
      ChallengeType.coins: {'easy': 25, 'medium': 50, 'hard': 100, 'legendary': 200},
      ChallengeType.enemies: {'easy': 10, 'medium': 25, 'hard': 50, 'legendary': 100},
      ChallengeType.powerUps: {'easy': 3, 'medium': 5, 'hard': 10, 'legendary': 20},
      ChallengeType.perfectRun: {'easy': 1, 'medium': 1, 'hard': 1, 'legendary': 1},
      ChallengeType.speedRun: {'easy': 500, 'medium': 1000, 'hard': 2000, 'legendary': 3500},
      ChallengeType.theme: {'easy': 300, 'medium': 750, 'hard': 1500, 'legendary': 3000},
      ChallengeType.character: {'easy': 400, 'medium': 800, 'hard': 1800, 'legendary': 3200},
      ChallengeType.combo: {'easy': 5, 'medium': 10, 'hard': 20, 'legendary': 50},
    };
    
    final baseValue = baseValues[type]?[difficulty.name] ?? 100;
    final variation = (random % 20) - 10; // ±10% variation
    return (baseValue * (1 + variation / 100)).round();
  }

  /// Get coin reward based on difficulty
  static int _getCoinReward(ChallengeDifficulty difficulty) {
    switch (difficulty) {
      case ChallengeDifficulty.easy:
        return 50;
      case ChallengeDifficulty.medium:
        return 150;
      case ChallengeDifficulty.hard:
        return 300;
      case ChallengeDifficulty.legendary:
        return 750;
    }
  }

  /// Get experience reward based on difficulty
  static int _getExpReward(ChallengeDifficulty difficulty) {
    switch (difficulty) {
      case ChallengeDifficulty.easy:
        return 25;
      case ChallengeDifficulty.medium:
        return 75;
      case ChallengeDifficulty.hard:
        return 150;
      case ChallengeDifficulty.legendary:
        return 400;
    }
  }

  /// Get special reward based on difficulty
  static String _getSpecialReward(ChallengeDifficulty difficulty) {
    switch (difficulty) {
      case ChallengeDifficulty.easy:
        return 'Basic Chest';
      case ChallengeDifficulty.medium:
        return 'Silver Chest';
      case ChallengeDifficulty.hard:
        return 'Gold Chest';
      case ChallengeDifficulty.legendary:
        return 'Diamond Chest';
    }
  }

  /// Get difficulty color
  Color getDifficultyColor() {
    switch (difficulty) {
      case ChallengeDifficulty.easy:
        return Colors.green;
      case ChallengeDifficulty.medium:
        return Colors.orange;
      case ChallengeDifficulty.hard:
        return Colors.red;
      case ChallengeDifficulty.legendary:
        return Colors.purple;
    }
  }

  /// Get challenge icon
  IconData getChallengeIcon() {
    switch (type) {
      case ChallengeType.score:
        return Icons.scoreboard;
      case ChallengeType.distance:
        return Icons.straighten;
      case ChallengeType.coins:
        return Icons.monetization_on;
      case ChallengeType.enemies:
        return Icons.warning;
      case ChallengeType.powerUps:
        return Icons.bolt;
      case ChallengeType.perfectRun:
        return Icons.star;
      case ChallengeType.speedRun:
        return Icons.timer;
      case ChallengeType.theme:
        return Icons.palette;
      case ChallengeType.character:
        return Icons.person;
      case ChallengeType.combo:
        return Icons.local_fire_department;
    }
  }

  /// Check if challenge is expired (older than 24 hours)
  bool isExpired() {
    final now = DateTime.now();
    final difference = now.difference(dateCreated);
    return difference.inHours > 24;
  }

  /// Complete the challenge
  void complete() {
    if (!isCompleted) {
      isCompleted = true;
      dateCompleted = DateTime.now();
      notifyListeners();
      save();
    }
  }

  /// Check progress for this challenge
  bool checkProgress({
    int? score,
    int? distance,
    int? coins,
    int? enemies,
    int? powerUps,
    bool? perfectRun,
    int? timeElapsed,
    String? themeUsed,
    String? characterUsed,
    int? maxCombo,
  }) {
    if (isCompleted) return true;

    bool meetsRequirement = false;

    switch (type) {
      case ChallengeType.score:
        meetsRequirement = (score ?? 0) >= targetValue;
        break;
      case ChallengeType.distance:
        meetsRequirement = (distance ?? 0) >= targetValue;
        break;
      case ChallengeType.coins:
        meetsRequirement = (coins ?? 0) >= targetValue;
        break;
      case ChallengeType.enemies:
        meetsRequirement = (enemies ?? 0) >= targetValue;
        break;
      case ChallengeType.powerUps:
        meetsRequirement = (powerUps ?? 0) >= targetValue;
        break;
      case ChallengeType.perfectRun:
        meetsRequirement = perfectRun == true;
        break;
      case ChallengeType.speedRun:
        final timeLimit = requirements['timeLimit'] as int? ?? 120;
        meetsRequirement = (score ?? 0) >= targetValue && (timeElapsed ?? 999) <= timeLimit;
        break;
      case ChallengeType.theme:
        final requiredTheme = requirements['theme'] as String?;
        meetsRequirement = themeUsed == requiredTheme && (score ?? 0) >= targetValue;
        break;
      case ChallengeType.character:
        final requiredCharacter = requirements['character'] as String?;
        meetsRequirement = characterUsed == requiredCharacter && (score ?? 0) >= targetValue;
        break;
      case ChallengeType.combo:
        meetsRequirement = (maxCombo ?? 0) >= targetValue;
        break;
    }

    if (meetsRequirement) {
      complete();
    }

    return meetsRequirement;
  }

  /// Get progress percentage
  double getProgress({
    int? score,
    int? distance,
    int? coins,
    int? enemies,
    int? powerUps,
    int? maxCombo,
  }) {
    if (isCompleted) return 1.0;

    int current = 0;
    switch (type) {
      case ChallengeType.score:
        current = score ?? 0;
        break;
      case ChallengeType.distance:
        current = distance ?? 0;
        break;
      case ChallengeType.coins:
        current = coins ?? 0;
        break;
      case ChallengeType.enemies:
        current = enemies ?? 0;
        break;
      case ChallengeType.powerUps:
        current = powerUps ?? 0;
        break;
      case ChallengeType.combo:
        current = maxCombo ?? 0;
        break;
      default:
        return 0.0; // Can't calculate progress for other types
    }

    return (current / targetValue).clamp(0.0, 1.0);
  }
}

/// Manager for daily challenges
class DailyChallengeManager extends ChangeNotifier {
  List<DailyChallenge> _challenges = [];
  DateTime? _lastGenerated;

  List<DailyChallenge> get challenges => List.unmodifiable(_challenges);

  DailyChallengeManager() {
    _loadChallenges();
  }

  /// Load or generate challenges for today
  void _loadChallenges() {
    final today = DateTime.now();
    
    // Check if we need to generate new challenges
    if (_lastGenerated == null || !_isSameDay(_lastGenerated!, today)) {
      _challenges = DailyChallenge.generateDailyChallenges();
      _lastGenerated = today;
      _saveChallenges();
    }
  }

  /// Check if two dates are the same day
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && 
           date1.month == date2.month && 
           date1.day == date2.day;
  }

  /// Save challenges to storage
  Future<void> _saveChallenges() async {
    // Implementation would save to Hive or other storage
    // For now, this is a placeholder
  }

  /// Check all challenges against game results
  void checkChallenges({
    int? score,
    int? distance,
    int? coins,
    int? enemies,
    int? powerUps,
    bool? perfectRun,
    int? timeElapsed,
    String? themeUsed,
    String? characterUsed,
    int? maxCombo,
  }) {
    for (final challenge in _challenges) {
      challenge.checkProgress(
        score: score,
        distance: distance,
        coins: coins,
        enemies: enemies,
        powerUps: powerUps,
        perfectRun: perfectRun,
        timeElapsed: timeElapsed,
        themeUsed: themeUsed,
        characterUsed: characterUsed,
        maxCombo: maxCombo,
      );
    }
    
    notifyListeners();
  }

  /// Get completed challenges count
  int get completedCount {
    return _challenges.where((c) => c.isCompleted).length;
  }

  /// Get total rewards available
  int getTotalCoinsAvailable() {
    return _challenges
        .where((c) => !c.isCompleted)
        .fold(0, (sum, challenge) => sum + challenge.rewardCoins);
  }

  /// Get total experience available
  int getTotalExperienceAvailable() {
    return _challenges
        .where((c) => !c.isCompleted)
        .fold(0, (sum, challenge) => sum + challenge.rewardExperience);
  }
}

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'player_stats.g.dart';

/// Stores comprehensive gameplay statistics
@HiveType(typeId: 8)
class PlayerStats extends ChangeNotifier with HiveObjectMixin {
  // Basic Stats
  @HiveField(0)
  int totalRuns = 0;
  
  @HiveField(1)
  int totalPlaytimeMinutes = 0;
  
  @HiveField(2)
  int totalDistance = 0; // in meters
  
  // Score Stats
  @HiveField(3)
  int highestScore = 0;
  
  @HiveField(4)
  int totalScore = 0;
  
  @HiveField(5)
  double averageScore = 0.0;
  
  // Collection Stats
  @HiveField(6)
  int totalCoinsCollected = 0;
  
  @HiveField(7)
  Map<String, int> coinsByType = {};
  
  @HiveField(8)
  int powerUpsCollected = 0;
  
  // Combat Stats
  @HiveField(9)
  int enemiesDodged = 0;
  
  @HiveField(10)
  int hitsTaken = 0;
  
  @HiveField(11)
  int nearMisses = 0;
  
  // Combo Stats
  @HiveField(12)
  int highestCombo = 0;
  
  @HiveField(13)
  int totalCombos = 0;
  
  // Theme Stats
  @HiveField(14)
  Map<String, int> themePlayTime = {};
  
  @HiveField(15)
  Map<String, int> themeHighScores = {};
  
  // Character Stats
  @HiveField(16)
  Map<String, int> characterRuns = {};
  
  @HiveField(17)
  Map<String, int> characterHighScores = {};
  
  // Session Stats
  @HiveField(18)
  int longestRun = 0; // in seconds
  
  @HiveField(19)
  double averageRunTime = 0.0;
  
  // Achievement Stats
  @HiveField(20)
  int achievementsUnlocked = 0;
  
  @HiveField(21)
  DateTime? firstPlayDate;
  
  @HiveField(22)
  DateTime? lastPlayDate;
  
  // Shop Stats
  @HiveField(23)
  int totalCoinsSpent = 0;
  
  @HiveField(24)
  int totalGemsSpent = 0;
  
  // Daily Stats
  @HiveField(25)
  int challengesCompleted = 0;
  
  @HiveField(26)
  int challengeStreak = 0;
  
  // Death Stats
  @HiveField(27)
  Map<String, int> deathsByEnemy = {};
  
  @HiveField(28)
  int totalDeaths = 0;

  PlayerStats() {
    if (firstPlayDate == null) {
      firstPlayDate = DateTime.now();
    }
    lastPlayDate = DateTime.now();
  }

  /// Record a completed run
  void recordRun({
    required int score,
    required int duration,
    required int distance,
    required int coins,
    required String themeId,
    required String characterId,
    required int combo,
  }) {
    totalRuns++;
    totalPlaytimeMinutes += (duration / 60).ceil();
    totalDistance += distance;
    totalScore += score;
    totalCoinsCollected += coins;
    
    // Update average score
    averageScore = totalScore / totalRuns;
    
    // Update high score
    if (score > highestScore) {
      highestScore = score;
    }
    
    // Update combo stats
    if (combo > highestCombo) {
      highestCombo = combo;
    }
    totalCombos++;
    
    // Update theme stats
    themePlayTime[themeId] = (themePlayTime[themeId] ?? 0) + duration;
    if ((themeHighScores[themeId] ?? 0) < score) {
      themeHighScores[themeId] = score;
    }
    
    // Update character stats
    characterRuns[characterId] = (characterRuns[characterId] ?? 0) + 1;
    if ((characterHighScores[characterId] ?? 0) < score) {
      characterHighScores[characterId] = score;
    }
    
    // Update run time stats
    if (duration > longestRun) {
      longestRun = duration;
    }
    averageRunTime = (averageRunTime * (totalRuns - 1) + duration) / totalRuns;
    
    lastPlayDate = DateTime.now();
    
    notifyListeners();
    save();
  }

  /// Record coin collection
  void recordCoin(String coinType, int value) {
    coinsByType[coinType] = (coinsByType[coinType] ?? 0) + value;
    notifyListeners();
    save();
  }

  /// Record enemy dodge
  void recordEnemyDodged(String enemyType) {
    enemiesDodged++;
    notifyListeners();
    save();
  }

  /// Record hit taken
  void recordHit(String? enemyType) {
    hitsTaken++;
    totalDeaths++;
    if (enemyType != null) {
      deathsByEnemy[enemyType] = (deathsByEnemy[enemyType] ?? 0) + 1;
    }
    notifyListeners();
    save();
  }

  /// Record power-up collection
  void recordPowerUp() {
    powerUpsCollected++;
    notifyListeners();
    save();
  }

  /// Record shop purchase
  void recordPurchase(int coins, int gems) {
    totalCoinsSpent += coins;
    totalGemsSpent += gems;
    notifyListeners();
    save();
  }

  /// Record challenge completion
  void recordChallengeCompleted() {
    challengesCompleted++;
    notifyListeners();
    save();
  }

  /// Get playtime as formatted string
  String get formattedPlaytime {
    final hours = totalPlaytimeMinutes ~/ 60;
    final minutes = totalPlaytimeMinutes % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  /// Get days since first play
  int get daysSinceFirstPlay {
    if (firstPlayDate == null) return 0;
    return DateTime.now().difference(firstPlayDate!).inDays;
  }

  /// Get favorite theme
  String? get favoriteTheme {
    if (themePlayTime.isEmpty) return null;
    return themePlayTime.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  /// Get favorite character
  String? get favoriteCharacter {
    if (characterRuns.isEmpty) return null;
    return characterRuns.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  /// Get most dangerous enemy
  String? get mostDangerousEnemy {
    if (deathsByEnemy.isEmpty) return null;
    return deathsByEnemy.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  /// Get accuracy (dodges vs hits)
  double get dodgeAccuracy {
    final total = enemiesDodged + hitsTaken;
    if (total == 0) return 0.0;
    return (enemiesDodged / total) * 100;
  }

  /// Get distance as formatted string
  String get formattedDistance {
    if (totalDistance >= 1000) {
      return '${(totalDistance / 1000).toStringAsFixed(1)} km';
    }
    return '$totalDistance m';
  }

  /// Load stats from storage
  static Future<PlayerStats> load() async {
    final box = await Hive.openBox<PlayerStats>('DinoRun.StatsBox');
    var stats = box.get('DinoRun.PlayerStats');
    
    if (stats == null) {
      stats = PlayerStats();
      await box.put('DinoRun.PlayerStats', stats);
    }
    
    return stats;
  }
}

import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/daily_challenge.dart';
import '../models/wallet.dart';

/// Manages daily challenges generation and tracking
class ChallengeManager extends ChangeNotifier {
  static const String _challengesBoxName = 'DinoRun.ChallengesBox';
  static const String _lastGeneratedKey = 'last_generated';
  static const String _streakKey = 'streak';
  static const int _challengesPerDay = 3;
  
  List<DailyChallenge> _challenges = [];
  int _streak = 0;
  DateTime? _lastGenerated;
  final Wallet _wallet;
  
  List<DailyChallenge> get challenges => List.unmodifiable(_challenges);
  int get streak => _streak;
  int get completedCount => _challenges.where((c) => c.isCompleted).length;
  int get totalCount => _challenges.length;
  bool get allCompleted => completedCount == totalCount && totalCount > 0;
  bool get canClaimRewards => _challenges.any((c) => c.canClaimReward);
  
  ChallengeManager(this._wallet) {
    _loadChallenges();
    _checkAndGenerateNewChallenges();
    
    // Listen to wallet changes
    _wallet.addListener(() {
      notifyListeners();
    });
  }
  
  /// Load challenges from storage
  Future<void> _loadChallenges() async {
    try {
      final box = await Hive.openBox<DailyChallenge>(_challengesBoxName);
      final lastGenBox = await Hive.openBox<DateTime>('${_challengesBoxName}_meta');
      
      _lastGenerated = lastGenBox.get(_lastGeneratedKey);
      _streak = lastGenBox.get(_streakKey) ?? 0;
      
      // Load valid challenges only
      _challenges = box.values.where((c) => c.isValid).toList();
      
      notifyListeners();
    } catch (e) {
      print('Error loading challenges: $e');
    }
  }
  
  /// Save challenges to storage
  Future<void> _saveChallenges() async {
    try {
      final box = await Hive.openBox<DailyChallenge>(_challengesBoxName);
      final metaBox = await Hive.openBox<DateTime>('${_challengesBoxName}_meta');
      
      await box.clear();
      for (final challenge in _challenges) {
        await box.put(challenge.id, challenge);
      }
      
      if (_lastGenerated != null) {
        await metaBox.put(_lastGeneratedKey, _lastGenerated!);
      }
      await metaBox.put(_streakKey, _streak);
    } catch (e) {
      print('Error saving challenges: $e');
    }
  }
  
  /// Check if new challenges need to be generated
  void _checkAndGenerateNewChallenges() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    if (_lastGenerated == null) {
      _generateNewChallenges();
      return;
    }
    
    final lastGenDay = DateTime(
      _lastGenerated!.year,
      _lastGenerated!.month,
      _lastGenerated!.day,
    );
    
    // If it's a new day, generate new challenges
    if (today.isAfter(lastGenDay)) {
      // Check if streak continues (completed all yesterday)
      if (!allCompleted && _challenges.isNotEmpty) {
        _streak = 0; // Reset streak
      } else if (allCompleted) {
        _streak++; // Increase streak
      }
      
      _generateNewChallenges();
    }
  }
  
  /// Generate new daily challenges
  void _generateNewChallenges() {
    final seed = DateTime.now().millisecondsSinceEpoch;
    final random = Random(seed);
    
    _challenges = [];
    
    for (int i = 0; i < _challengesPerDay; i++) {
      final challenge = DailyChallenge.generateRandom(seed + i);
      
      // Ensure variety (no duplicate types)
      final existingTypes = _challenges.map((c) => c.type).toSet();
      if (!existingTypes.contains(challenge.type)) {
        _challenges.add(challenge);
      } else {
        // Generate another one
        i--;
      }
    }
    
    _lastGenerated = DateTime.now();
    _saveChallenges();
    notifyListeners();
  }
  
  /// Update challenge progress
  void updateProgress(ChallengeType type, int value, {String? themeId}) {
    for (final challenge in _challenges) {
      if (challenge.isCompleted) continue;
      
      if (challenge.type == type) {
        // Check theme requirement for theme challenges
        if (type == ChallengeType.specificTheme && themeId != null) {
          if (challenge.themeId != themeId) continue;
        }
        
        challenge.updateProgress(value);
      }
    }
    
    _saveChallenges();
    notifyListeners();
  }
  
  /// Add progress to challenge
  void addProgress(ChallengeType type, int amount, {String? themeId}) {
    for (final challenge in _challenges) {
      if (challenge.isCompleted) continue;
      
      if (challenge.type == type) {
        if (type == ChallengeType.specificTheme && themeId != null) {
          if (challenge.themeId != themeId) continue;
        }
        
        challenge.addProgress(amount);
      }
    }
    
    _saveChallenges();
    notifyListeners();
  }
  
  /// Claim reward for completed challenge
  bool claimReward(String challengeId) {
    final challenge = _challenges.firstWhere(
      (c) => c.id == challengeId,
      orElse: () => null as DailyChallenge,
    );
    
    if (challenge.canClaimReward) {
      // Add rewards
      _wallet.addCoins(challenge.coinReward);
      if (challenge.gemReward > 0) {
        _wallet.addGems(challenge.gemReward);
      }
      
      challenge.claimReward();
      _saveChallenges();
      notifyListeners();
      return true;
    }
    
    return false;
  }
  
  /// Claim all available rewards
  Map<String, int> claimAllRewards() {
    int totalCoins = 0;
    int totalGems = 0;
    
    for (final challenge in _challenges) {
      if (challenge.canClaimReward) {
        totalCoins += challenge.coinReward;
        totalGems += challenge.gemReward;
        challenge.claimReward();
      }
    }
    
    if (totalCoins > 0 || totalGems > 0) {
      _wallet.addCoins(totalCoins);
      _wallet.addGems(totalGems);
      _saveChallenges();
      notifyListeners();
    }
    
    return {'coins': totalCoins, 'gems': totalGems};
  }
  
  /// Get challenge by ID
  DailyChallenge? getChallengeById(String id) {
    try {
      return _challenges.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }
  
  /// Force refresh challenges (for testing)
  void refreshChallenges() {
    _generateNewChallenges();
  }
  
  /// Track gameplay events for challenges
  void trackScore(int score) {
    updateProgress(ChallengeType.score, score);
    updateProgress(ChallengeType.noHit, score);
  }
  
  void trackCoins(int coins) {
    addProgress(ChallengeType.coins, coins);
  }
  
  void trackDistance(int meters) {
    addProgress(ChallengeType.distance, meters);
  }
  
  void trackEnemyDodged() {
    addProgress(ChallengeType.enemies, 1);
  }
  
  void trackCombo(int combo) {
    updateProgress(ChallengeType.combo, combo);
  }
  
  void trackPowerUp() {
    addProgress(ChallengeType.powerUps, 1);
  }
  
  void trackThemePlay(String themeId, int score) {
    updateProgress(ChallengeType.specificTheme, score, themeId: themeId);
  }
}

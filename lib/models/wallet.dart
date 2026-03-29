import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'wallet.g.dart';

/// Represents different types of coins with their values
enum CoinType {
  bronze(1),
  silver(5),
  gold(10),
  diamond(50);

  final int value;
  const CoinType(this.value);
}

/// Manages player's currency (coins and gems)
@HiveType(typeId: 4)
class Wallet extends ChangeNotifier with HiveObjectMixin {
  @HiveField(0)
  int _coins = 0;

  @HiveField(1)
  int _gems = 0;

  @HiveField(2)
  int _totalCoinsEarned = 0; // All-time statistic

  @HiveField(3)
  int _totalGemsEarned = 0; // All-time statistic

  // Getters
  int get coins => _coins;
  int get gems => _gems;
  int get totalCoinsEarned => _totalCoinsEarned;
  int get totalGemsEarned => _totalGemsEarned;

  /// Add coins to wallet
  void addCoins(int amount) {
    if (amount > 0) {
      _coins += amount;
      _totalCoinsEarned += amount;
      notifyListeners();
      save();
    }
  }

  /// Spend coins from wallet
  /// Returns true if successful, false if insufficient balance
  bool spendCoins(int amount) {
    if (amount <= 0) return true;
    if (_coins >= amount) {
      _coins -= amount;
      notifyListeners();
      save();
      return true;
    }
    return false;
  }

  /// Add gems to wallet
  void addGems(int amount) {
    if (amount > 0) {
      _gems += amount;
      _totalGemsEarned += amount;
      notifyListeners();
      save();
    }
  }

  /// Spend gems from wallet
  /// Returns true if successful, false if insufficient balance
  bool spendGems(int amount) {
    if (amount <= 0) return true;
    if (_gems >= amount) {
      _gems -= amount;
      notifyListeners();
      save();
      return true;
    }
    return false;
  }

  /// Convert gems to coins (for purchasing when short on coins)
  /// Rate: 1 gem = 10 coins
  bool convertGemsToCoins(int gemAmount) {
    if (_gems >= gemAmount) {
      _gems -= gemAmount;
      _coins += gemAmount * 10;
      notifyListeners();
      save();
      return true;
    }
    return false;
  }

  /// Add coins based on coin type
  void addCoinsByType(CoinType type, int count) {
    addCoins(type.value * count);
  }

  /// Check if player can afford an item
  bool canAfford(int coinCost, {int gemCost = 0}) {
    return _coins >= coinCost && _gems >= gemCost;
  }

  /// Get formatted coin string (e.g., "1.5K" for 1500)
  String get formattedCoins {
    if (_coins >= 1000000) {
      return '${(_coins / 1000000).toStringAsFixed(1)}M';
    } else if (_coins >= 1000) {
      return '${(_coins / 1000).toStringAsFixed(1)}K';
    }
    return _coins.toString();
  }

  /// Reset wallet (for testing or new game)
  void reset() {
    _coins = 0;
    _gems = 0;
    notifyListeners();
    save();
  }

  /// Load wallet from Hive or create new one
  static Future<Wallet> load() async {
    final box = await Hive.openBox<Wallet>('DinoRun.WalletBox');
    var wallet = box.get('DinoRun.Wallet');
    
    if (wallet == null) {
      wallet = Wallet();
      await box.put('DinoRun.Wallet', wallet);
    }
    
    return wallet;
  }
}

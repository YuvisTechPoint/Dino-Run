import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

/// Enum for different shop item categories
enum ShopItemCategory {
  powerUp,
  cosmetic,
  upgrade,
  character,
}

/// Represents an item available in the shop
// TODO: Generate Hive adapter with: flutter packages pub run build_runner build
// part 'shop_item.g.dart';
class ShopItem extends ChangeNotifier with HiveObjectMixin {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String description;
  
  @HiveField(3)
  final ShopItemCategory category;
  
  @HiveField(4)
  final String iconPath;
  
  @HiveField(5)
  final int coinCost;
  
  @HiveField(6)
  final int gemCost;
  
  @HiveField(7)
  final int maxQuantity; // 0 for unlimited, 1 for single purchase
  
  @HiveField(8)
  int _quantityOwned;
  
  @HiveField(9)
  final Map<String, dynamic> effectData; // Stores effect parameters

  ShopItem({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.iconPath,
    this.coinCost = 0,
    this.gemCost = 0,
    this.maxQuantity = 0,
    this.effectData = const {},
  }) : _quantityOwned = 0;

  // Getters
  int get quantityOwned => _quantityOwned;
  bool get isSinglePurchase => maxQuantity == 1;
  bool get isPurchased => maxQuantity == 1 && _quantityOwned > 0;
  bool get canPurchaseMore => maxQuantity == 0 || _quantityOwned < maxQuantity;

  /// Purchase one unit of this item
  void purchase() {
    if (canPurchaseMore) {
      _quantityOwned++;
      notifyListeners();
      save();
    }
  }

  /// Use one unit (for consumables)
  bool use() {
    if (_quantityOwned > 0) {
      _quantityOwned--;
      notifyListeners();
      save();
      return true;
    }
    return false;
  }

  /// Get formatted cost string
  String get costString {
    if (gemCost > 0 && coinCost > 0) {
      return '$coinCost Coins + $gemCost Gems';
    } else if (gemCost > 0) {
      return '$gemCost Gems';
    } else if (coinCost > 0) {
      return '$coinCost Coins';
    }
    return 'Free';
  }

  /// Check if item can be afforded
  bool canAfford(int availableCoins, int availableGems) {
    return availableCoins >= coinCost && availableGems >= gemCost;
  }

  /// Get predefined shop items
  static List<ShopItem> getPredefinedItems() {
    return [
      // Power-ups
      ShopItem(
        id: 'extra_life',
        name: 'Extra Life',
        description: 'Start with an additional life',
        category: ShopItemCategory.powerUp,
        iconPath: 'shop/extra_life.png',
        coinCost: 100,
        maxQuantity: 0, // Unlimited
      ),
      ShopItem(
        id: 'coin_magnet',
        name: 'Coin Magnet',
        description: 'Attracts coins for 10 seconds',
        category: ShopItemCategory.powerUp,
        iconPath: 'shop/coin_magnet.png',
        coinCost: 150,
        maxQuantity: 0,
      ),
      ShopItem(
        id: 'score_multiplier',
        name: 'Score Booster',
        description: '2x score multiplier for 30 seconds',
        category: ShopItemCategory.powerUp,
        iconPath: 'shop/score_multiplier.png',
        coinCost: 200,
        maxQuantity: 0,
      ),
      ShopItem(
        id: 'shield',
        name: 'Shield',
        description: 'Temporary invincibility for 5 seconds',
        category: ShopItemCategory.powerUp,
        iconPath: 'shop/shield.png',
        coinCost: 250,
        maxQuantity: 0,
      ),
      
      // Cosmetics
      ShopItem(
        id: 'rainbow_trail',
        name: 'Rainbow Trail',
        description: 'Leave a colorful trail when jumping',
        category: ShopItemCategory.cosmetic,
        iconPath: 'shop/rainbow_trail.png',
        coinCost: 500,
        gemCost: 10,
        maxQuantity: 1,
      ),
      ShopItem(
        id: 'sparkle_jump',
        name: 'Sparkle Jump',
        description: 'Sparkle effects when jumping',
        category: ShopItemCategory.cosmetic,
        iconPath: 'shop/sparkle_jump.png',
        coinCost: 300,
        maxQuantity: 1,
      ),
      ShopItem(
        id: 'golden_skin',
        name: 'Golden Dino',
        description: 'Shiny golden appearance',
        category: ShopItemCategory.cosmetic,
        iconPath: 'shop/golden_skin.png',
        coinCost: 1000,
        gemCost: 25,
        maxQuantity: 1,
      ),
      
      // Permanent Upgrades
      ShopItem(
        id: 'upgrade_lives',
        name: 'Extra Life Slot',
        description: 'Permanently increase max lives by 1',
        category: ShopItemCategory.upgrade,
        iconPath: 'shop/upgrade_lives.png',
        coinCost: 2000,
        gemCost: 50,
        maxQuantity: 2, // Can buy up to 2 times (max 7 lives)
      ),
      ShopItem(
        id: 'upgrade_coins',
        name: 'Coin Value',
        description: 'All coins worth 25% more',
        category: ShopItemCategory.upgrade,
        iconPath: 'shop/upgrade_coins.png',
        coinCost: 1500,
        gemCost: 30,
        maxQuantity: 4, // Up to 100% bonus
      ),
      ShopItem(
        id: 'upgrade_jump',
        name: 'Jump Boost',
        description: 'Jump 10% higher',
        category: ShopItemCategory.upgrade,
        iconPath: 'shop/upgrade_jump.png',
        coinCost: 1200,
        gemCost: 25,
        maxQuantity: 3, // Up to 30% boost
      ),
    ];
  }
}

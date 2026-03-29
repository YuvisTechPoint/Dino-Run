import 'package:flutter/material.dart';
import '../models/shop_item.dart';
import '../models/wallet.dart';

/// Manages the shop inventory and purchase logic
class ShopManager extends ChangeNotifier {
  static const String _shopBoxName = 'DinoRun.ShopBox';
  
  List<ShopItem> _items = [];
  final Wallet _wallet;
  
  List<ShopItem> get items => List.unmodifiable(_items);
  
  ShopManager(this._wallet) {
    _initializeItems();
  }
  
  void _initializeItems() {
    _items = ShopItem.getPredefinedItems();
    _loadItemStates();
    
    // Listen to wallet changes
    _wallet.addListener(() {
      notifyListeners();
    });
  }
  
  /// Load item purchase states from storage
  Future<void> _loadItemStates() async {
    try {
      final box = await Hive.openBox<int>(_shopBoxName);
      
      for (final item in _items) {
        final savedQuantity = box.get(item.id);
        if (savedQuantity != null && savedQuantity > 0) {
          // Restore quantity by purchasing (without spending)
          for (int i = 0; i < savedQuantity; i++) {
            item.purchase();
          }
        }
      }
      
      notifyListeners();
    } catch (e) {
      print('Error loading shop items: $e');
    }
  }
  
  /// Save item purchase state
  Future<void> _saveItemState(ShopItem item) async {
    try {
      final box = await Hive.openBox<int>(_shopBoxName);
      await box.put(item.id, item.quantityOwned);
    } catch (e) {
      print('Error saving shop item: $e');
    }
  }
  
  /// Purchase an item
  Future<bool> purchaseItem(ShopItem item) async {
    // Check if can purchase more
    if (!item.canPurchaseMore) {
      return false;
    }
    
    // Check if can afford
    if (!item.canAfford(_wallet.coins, _wallet.gems)) {
      return false;
    }
    
    // Spend currency
    bool success = true;
    if (item.coinCost > 0) {
      success = _wallet.spendCoins(item.coinCost);
    }
    if (success && item.gemCost > 0) {
      success = _wallet.spendGems(item.gemCost);
    }
    
    if (success) {
      item.purchase();
      await _saveItemState(item);
      notifyListeners();
      return true;
    }
    
    return false;
  }
  
  /// Use a consumable item
  bool useItem(String itemId) {
    final item = getItemById(itemId);
    if (item != null && item.category == ShopItemCategory.powerUp) {
      if (item.use()) {
        _saveItemState(item);
        notifyListeners();
        return true;
      }
    }
    return false;
  }
  
  /// Get items by category
  List<ShopItem> getItemsByCategory(ShopItemCategory category) {
    return _items.where((item) => item.category == category).toList();
  }
  
  /// Get item by ID
  ShopItem? getItemById(String id) {
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }
  
  /// Check if player can afford an item
  bool canAfford(ShopItem item) {
    return item.canAfford(_wallet.coins, _wallet.gems);
  }
  
  /// Get total spent coins (approximate)
  int get totalSpent {
    int total = 0;
    for (final item in _items) {
      total += item.coinCost * item.quantityOwned;
    }
    return total;
  }
  
  /// Get owned cosmetics
  List<ShopItem> get ownedCosmetics {
    return _items.where((item) => 
      item.category == ShopItemCategory.cosmetic && 
      item.isPurchased
    ).toList();
  }
  
  /// Get active upgrades
  List<ShopItem> get activeUpgrades {
    return _items.where((item) => 
      item.category == ShopItemCategory.upgrade && 
      item.quantityOwned > 0
    ).toList();
  }
  
  /// Get total coin multiplier from upgrades
  double get coinMultiplier {
    final coinUpgrade = getItemById('upgrade_coins');
    if (coinUpgrade != null) {
      return 1.0 + (coinUpgrade.quantityOwned * 0.25);
    }
    return 1.0;
  }
  
  /// Get total jump multiplier from upgrades
  double get jumpMultiplier {
    final jumpUpgrade = getItemById('upgrade_jump');
    if (jumpUpgrade != null) {
      return 1.0 + (jumpUpgrade.quantityOwned * 0.10);
    }
    return 1.0;
  }
  
  /// Get extra lives from upgrades
  int get extraLives {
    final livesUpgrade = getItemById('upgrade_lives');
    if (livesUpgrade != null) {
      return livesUpgrade.quantityOwned;
    }
    return 0;
  }
}

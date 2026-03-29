import 'package:flutter/material.dart';
import '../game/dino_run.dart';
import '../managers/shop_manager.dart';
import '../models/shop_item.dart';
import '../models/wallet.dart';

/// Shop menu overlay for purchasing items
class ShopMenu extends StatefulWidget {
  static const String id = 'ShopMenu';
  final DinoRun game;

  const ShopMenu(this.game, {super.key});

  @override
  State<ShopMenu> createState() => _ShopMenuState();
}

class _ShopMenuState extends State<ShopMenu> with SingleTickerProviderStateMixin {
  late ShopManager _shopManager;
  late Wallet _wallet;
  late TabController _tabController;
  ShopItemCategory _selectedCategory = ShopItemCategory.powerUp;

  @override
  void initState() {
    super.initState();
    _shopManager = ShopManager(widget.game.playerData as Wallet);
    _wallet = widget.game.playerData as Wallet;
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedCategory = ShopItemCategory.values[_tabController.index];
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.85),
      body: SafeArea(
        child: Column(
          children: [
            // Header with wallet display
            _buildHeader(),
            
            // Category tabs
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(icon: Icon(Icons.bolt), text: 'Power-ups'),
                Tab(icon: Icon(Icons.palette), text: 'Cosmetics'),
                Tab(icon: Icon(Icons.upgrade), text: 'Upgrades'),
              ],
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white54,
              indicatorColor: Colors.green,
            ),
            
            // Shop items grid
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildItemsGrid(ShopItemCategory.powerUp),
                  _buildItemsGrid(ShopItemCategory.cosmetic),
                  _buildItemsGrid(ShopItemCategory.upgrade),
                ],
              ),
            ),
            
            // Back button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  widget.game.overlays.remove(ShopMenu.id);
                  widget.game.overlays.add('MainMenu');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  minimumSize: const Size(200, 50),
                ),
                child: const Text('Back', style: TextStyle(fontSize: 20)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.green.shade800, Colors.green.shade900],
        ),
      ),
      child: Column(
        children: [
          const Text(
            'SHOP',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Coins display
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.amber, width: 2),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.monetization_on, color: Colors.amber),
                    const SizedBox(width: 8),
                    Text(
                      _wallet.formattedCoins,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Gems display
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.purple, width: 2),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.diamond, color: Colors.purple),
                    const SizedBox(width: 8),
                    Text(
                      '${_wallet.gems}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItemsGrid(ShopItemCategory category) {
    final items = _shopManager.getItemsByCategory(category);
    
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildItemCard(item);
      },
    );
  }

  Widget _buildItemCard(ShopItem item) {
    final canAfford = _shopManager.canAfford(item);
    final isMaxed = !item.canPurchaseMore;
    
    Color cardColor;
    if (isMaxed) {
      cardColor = Colors.green.withOpacity(0.3);
    } else if (!canAfford) {
      cardColor = Colors.red.withOpacity(0.3);
    } else {
      cardColor = Colors.white.withOpacity(0.1);
    }

    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isMaxed 
              ? Colors.green 
              : (canAfford ? Colors.white54 : Colors.red),
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: isMaxed ? null : () => _showPurchaseDialog(item),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Item icon placeholder
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: _getCategoryColor(item.category).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getCategoryIcon(item.category),
                  color: _getCategoryColor(item.category),
                  size: 32,
                ),
              ),
              const SizedBox(height: 8),
              // Item name
              Text(
                item.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              // Item description
              Text(
                item.description,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              // Cost or status
              if (isMaxed)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'MAXED',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: canAfford ? Colors.amber : Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    item.costString,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              // Quantity indicator
              if (item.quantityOwned > 0 && !item.isSinglePurchase)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    'Owned: ${item.quantityOwned}',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPurchaseDialog(ShopItem item) {
    final canAfford = _shopManager.canAfford(item);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: Text(
          item.name,
          style: const TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              item.description,
              style: TextStyle(color: Colors.white.withOpacity(0.8)),
            ),
            const SizedBox(height: 16),
            Text(
              'Cost: ${item.costString}',
              style: TextStyle(
                color: canAfford ? Colors.amber : Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            if (!canAfford)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Insufficient funds!',
                  style: TextStyle(
                    color: Colors.red.shade300,
                    fontSize: 14,
                  ),
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          if (canAfford)
            ElevatedButton(
              onPressed: () async {
                final success = await _shopManager.purchaseItem(item);
                Navigator.pop(context);
                
                if (success) {
                  _showSuccessMessage('${item.name} purchased!');
                } else {
                  _showErrorMessage('Purchase failed. Please try again.');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text('Buy'),
            ),
        ],
      ),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Color _getCategoryColor(ShopItemCategory category) {
    switch (category) {
      case ShopItemCategory.powerUp:
        return Colors.yellow;
      case ShopItemCategory.cosmetic:
        return Colors.pink;
      case ShopItemCategory.upgrade:
        return Colors.blue;
      case ShopItemCategory.character:
        return Colors.green;
    }
  }

  IconData _getCategoryIcon(ShopItemCategory category) {
    switch (category) {
      case ShopItemCategory.powerUp:
        return Icons.bolt;
      case ShopItemCategory.cosmetic:
        return Icons.palette;
      case ShopItemCategory.upgrade:
        return Icons.upgrade;
      case ShopItemCategory.character:
        return Icons.person;
    }
  }
}

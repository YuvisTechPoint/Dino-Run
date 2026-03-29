import 'package:flutter/material.dart';
import '../models/game_theme.dart';
import '../game/dino_run.dart';
import '../managers/theme_manager.dart';

/// Menu for selecting and previewing game themes
class ThemeSelectionMenu extends StatefulWidget {
  static const String id = 'ThemeSelectionMenu';
  
  final DinoRun game;

  const ThemeSelectionMenu(this.game, {super.key});

  @override
  State<ThemeSelectionMenu> createState() => _ThemeSelectionMenuState();
}

class _ThemeSelectionMenuState extends State<ThemeSelectionMenu> {
  late ThemeManager _themeManager;
  GameTheme? _selectedTheme;

  @override
  void initState() {
    super.initState();
    _themeManager = ThemeManager();
    _selectedTheme = _themeManager.currentTheme;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.9),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF2C2C2C),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: _selectedTheme?.primaryColor ?? const Color(0xFF4ECDC4), width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Select Theme',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'All Themes Unlocked',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // Themes List
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 400, maxWidth: 500),
                child: SingleChildScrollView(
                  child: Column(
                    children: _themeManager.themes.map((theme) {
                      return _ThemeTile(
                        theme: theme,
                        isSelected: _selectedTheme == theme,
                        onTap: () {
                          setState(() {
                            _selectedTheme = theme;
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      widget.game.overlays.remove(ThemeSelectionMenu.id);
                      widget.game.overlays.add('MainMenu');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    child: const Text('Back'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      widget.game.updateTheme(_selectedTheme!);
                      widget.game.overlays.remove(ThemeSelectionMenu.id);
                      widget.game.overlays.add('MainMenu');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedTheme?.primaryColor ?? const Color(0xFF4ECDC4),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    child: const Text('Select Theme'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemeTile extends StatelessWidget {
  final GameTheme theme;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeTile({
    required this.theme,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: isSelected 
                ? theme.primaryColor.withOpacity(0.3)
                : Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected 
                  ? theme.primaryColor
                  : Colors.grey,
              width: isSelected ? 3 : 1,
            ),
          ),
          child: Row(
            children: [
              // Theme Preview
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.primaryColor,
                      theme.secondaryColor,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                    _getThemeIcon(theme.type),
                    color: Colors.white,
                    size: 30,
                  ),
              ),
              
              const SizedBox(width: 15),
              
              // Theme Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      theme.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      theme.description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          '🎯 ${_getThemeFeatures(theme.type)}',
                          style: TextStyle(
                            fontSize: 10,
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          '✨ ${_getThemeEffects(theme.type)}',
                          style: TextStyle(
                            fontSize: 10,
                            color: theme.secondaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Selection Indicator
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: theme.primaryColor,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }
  
  IconData _getThemeIcon(GameThemeType type) {
    switch (type) {
      case GameThemeType.classic:
        return Icons.pets;
      case GameThemeType.desert:
        return Icons.wb_sunny;
      case GameThemeType.forest:
        return Icons.park;
      case GameThemeType.city:
        return Icons.location_city;
      case GameThemeType.ocean:
        return Icons.water;
      case GameThemeType.space:
        return Icons.star;
      case GameThemeType.candy:
        return Icons.cake;
      case GameThemeType.winter:
        return Icons.ac_unit;
      case GameThemeType.jungle:
        return Icons.nature;
      case GameThemeType.volcano:
        return Icons.local_fire_department;
    }
  }
  
  String _getThemeFeatures(GameThemeType type) {
    switch (type) {
      case GameThemeType.classic:
        return 'Classic enemies & coins';
      case GameThemeType.desert:
        return 'Water drops & canteens';
      case GameThemeType.forest:
        return 'Berries & mushrooms';
      case GameThemeType.city:
        return 'Energy drinks & helmets';
      case GameThemeType.ocean:
        return 'Pearls & oxygen tanks';
      case GameThemeType.space:
        return 'Star crystals & jetpacks';
      case GameThemeType.candy:
        return 'Candy coins & sugar rush';
      case GameThemeType.winter:
        return 'Snowflakes & hot chocolate';
      case GameThemeType.jungle:
        return 'Exotic fruits & torches';
      case GameThemeType.volcano:
        return 'Fire gems & fire shields';
    }
  }
  
  String _getThemeEffects(GameThemeType type) {
    switch (type) {
      case GameThemeType.classic:
        return 'Retro filter & pixel dust';
      case GameThemeType.desert:
        return 'Heat shimmer & mirage';
      case GameThemeType.forest:
        return 'Fireflies & falling leaves';
      case GameThemeType.city:
        return 'Neon glow & traffic lights';
      case GameThemeType.ocean:
        return 'Bubbles & underwater glow';
      case GameThemeType.space:
        return 'Starfield & zero gravity';
      case GameThemeType.candy:
        return 'Rainbow trail & candy sparkle';
      case GameThemeType.winter:
        return 'Aurora lights & ice reflection';
      case GameThemeType.jungle:
        return 'Vine swing & ancient glow';
      case GameThemeType.volcano:
        return 'Lava glow & ash fall';
    }
  }
}

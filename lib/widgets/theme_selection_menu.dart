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
                    '${_themeManager.unlockedCount}/${_themeManager.totalCount}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
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
                          if (theme.unlocked) {
                            setState(() {
                              _selectedTheme = theme;
                            });
                          }
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
                    onPressed: _selectedTheme?.unlocked == true ? () {
                      _themeManager.switchTheme(_selectedTheme!);
                      widget.game.overlays.remove(ThemeSelectionMenu.id);
                      widget.game.overlays.add('MainMenu');
                    } : null,
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
        onTap: theme.unlocked ? onTap : null,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: isSelected 
                ? theme.primaryColor.withOpacity(0.3)
                : theme.unlocked 
                    ? Colors.grey.withOpacity(0.2)
                    : Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected 
                  ? theme.primaryColor
                  : theme.unlocked 
                      ? Colors.grey
                      : Colors.red,
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
                child: theme.unlocked 
                    ? Icon(
                        _getThemeIcon(theme.type),
                        color: Colors.white,
                        size: 30,
                      )
                    : Icon(
                        Icons.lock,
                        color: Colors.white70,
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
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: theme.unlocked ? Colors.white : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      theme.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.unlocked ? Colors.white70 : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          '🎯 ${_getThemeFeatures(theme.type)}',
                          style: TextStyle(
                            fontSize: 10,
                            color: theme.unlocked ? theme.primaryColor : Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    if (!theme.unlocked)
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          '🔒 Complete achievements to unlock',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.red[300],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
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
    }
  }
}

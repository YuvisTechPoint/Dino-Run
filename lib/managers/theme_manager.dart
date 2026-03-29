import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/game_theme.dart';

/// Manages game themes and current theme selection
class ThemeManager extends ChangeNotifier {
  static const String _themeBoxName = 'DinoRun.ThemeBox';
  static const String _currentThemeKey = 'current_theme';
  
  List<GameTheme> _themes = [];
  GameTheme _currentTheme = GameTheme.getPredefinedThemes().first; // Default to classic theme
  
  List<GameTheme> get themes => List.unmodifiable(_themes);
  GameTheme get currentTheme => _currentTheme;
  
  ThemeManager() {
    _initializeThemes();
  }
  
  void _initializeThemes() {
    _themes = GameTheme.getPredefinedThemes();
    _currentTheme = _themes.first; // Default to classic theme
    _loadCurrentTheme();
  }
  
  /// Load the current theme from storage
  Future<void> _loadCurrentTheme() async {
    try {
      final themeBox = await Hive.openBox(_themeBoxName);
      final currentThemeType = themeBox.get(_currentThemeKey);
      
      if (currentThemeType != null) {
        final theme = _themes.where((t) => t.type.toString() == currentThemeType).firstOrNull;
        if (theme != null) {
          _currentTheme = theme;
        }
      }
    } catch (e) {
      // If loading fails, keep default theme
      print('Error loading theme: $e');
    }
    notifyListeners();
  }
  
  /// Switch to a different theme
  Future<void> switchTheme(GameTheme theme) async {
    if (!theme.unlocked) {
      throw Exception('Theme is not unlocked');
    }
    
    _currentTheme = theme;
    await _saveCurrentTheme();
    notifyListeners();
  }
  
  /// Save the current theme to storage
  Future<void> _saveCurrentTheme() async {
    try {
      final themeBox = await Hive.openBox(_themeBoxName);
      await themeBox.put(_currentThemeKey, _currentTheme.type.toString());
    } catch (e) {
      print('Error saving theme: $e');
    }
  }
  
  /// Unlock a theme
  void unlockTheme(GameThemeType themeType) {
    final theme = _themes.where((t) => t.type == themeType).firstOrNull;
    if (theme != null) {
      theme.unlock();
    }
  }
  
  /// Get theme by type
  GameTheme? getThemeByType(GameThemeType type) {
    try {
      return _themes.firstWhere((t) => t.type == type);
    } catch (e) {
      return null;
    }
  }
  
  /// Check how many themes are unlocked
  int get unlockedCount {
    return _themes.where((t) => t.unlocked).length;
  }
  
  /// Get total number of themes
  int get totalCount => _themes.length;
  
  /// Unlock themes based on achievements
  void unlockThemesByScore(int score) {
    // Unlock desert theme at 100 points
    if (score >= 100) {
      unlockTheme(GameThemeType.desert);
    }
    
    // Unlock forest theme at 500 points
    if (score >= 500) {
      unlockTheme(GameThemeType.forest);
    }
    
    // Unlock city theme at 1000 points
    if (score >= 1000) {
      unlockTheme(GameThemeType.city);
    }
  }
}

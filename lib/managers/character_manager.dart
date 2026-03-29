import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/character.dart';
import '../models/wallet.dart';

/// Manages all playable characters and their unlock states
class CharacterManager extends ChangeNotifier {
  static const String _charactersBoxName = 'DinoRun.CharactersBox';
  static const String _selectedCharacterKey = 'selected_character';
  
  List<Character> _characters = [];
  Character _selectedCharacter;
  final Wallet _wallet;
  
  List<Character> get characters => List.unmodifiable(_characters);
  Character get selectedCharacter => _selectedCharacter;
  
  CharacterManager(this._wallet) : _selectedCharacter = Character.getPredefinedCharacters().first {
    _initializeCharacters();
  }
  
  void _initializeCharacters() {
    _characters = Character.getPredefinedCharacters();
    _loadSelectedCharacter();
  }
  
  /// Load selected character from storage
  Future<void> _loadSelectedCharacter() async {
    try {
      final box = await Hive.openBox<String>(_charactersBoxName);
      final selectedId = box.get(_selectedCharacterKey);
      
      if (selectedId != null) {
        final character = _characters.firstWhere(
          (c) => c.id == selectedId,
          orElse: () => _characters.first,
        );
        if (character.isUnlocked) {
          _selectedCharacter = character;
        }
      }
    } catch (e) {
      print('Error loading selected character: $e');
    }
    notifyListeners();
  }
  
  /// Save selected character to storage
  Future<void> _saveSelectedCharacter() async {
    try {
      final box = await Hive.openBox<String>(_charactersBoxName);
      await box.put(_selectedCharacterKey, _selectedCharacter.id);
    } catch (e) {
      print('Error saving selected character: $e');
    }
  }
  
  /// Select a character (must be unlocked)
  Future<void> selectCharacter(Character character) async {
    if (!character.isUnlocked) {
      throw Exception('Character is not unlocked');
    }
    
    _selectedCharacter = character;
    await _saveSelectedCharacter();
    notifyListeners();
  }
  
  /// Unlock a character using wallet
  bool unlockCharacter(Character character) {
    if (character.isUnlocked) return true;
    
    // Try to spend coins first, then gems
    bool success = false;
    
    if (character.unlockCostCoins > 0) {
      success = _wallet.spendCoins(character.unlockCostCoins);
    } else if (character.unlockCostGems > 0) {
      success = _wallet.spendGems(character.unlockCostGems);
    }
    
    if (success) {
      character.unlock();
      notifyListeners();
      return true;
    }
    
    return false;
  }
  
  /// Check if a character can be unlocked with current wallet balance
  bool canUnlockCharacter(Character character) {
    return character.canUnlock(_wallet.coins, _wallet.gems);
  }
  
  /// Get unlocked character count
  int get unlockedCount => _characters.where((c) => c.isUnlocked).length;
  
  /// Get total character count
  int get totalCount => _characters.length;
  
  /// Get character by ID
  Character? getCharacterById(String id) {
    try {
      return _characters.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }
  
  /// Record play for selected character
  void recordPlay() {
    _selectedCharacter.recordPlay();
  }
  
  /// Update high score for selected character
  void updateHighScore(int score) {
    _selectedCharacter.updateHighScore(score);
  }
  
  /// Get characters sorted by unlock status (unlocked first)
  List<Character> getCharactersSorted() {
    final sorted = List<Character>.from(_characters);
    sorted.sort((a, b) {
      if (a.isUnlocked && !b.isUnlocked) return -1;
      if (!a.isUnlocked && b.isUnlocked) return 1;
      return a.unlockCostCoins.compareTo(b.unlockCostCoins);
    });
    return sorted;
  }
}

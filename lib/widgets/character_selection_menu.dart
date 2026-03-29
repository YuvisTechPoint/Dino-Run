import 'package:flutter/material.dart';
import '../game/dino_run.dart';
import '../managers/character_manager.dart';
import '../models/character.dart';

/// Menu for selecting and unlocking characters
class CharacterSelectionMenu extends StatefulWidget {
  static const String id = 'CharacterSelectionMenu';
  final DinoRun game;

  const CharacterSelectionMenu(this.game, {super.key});

  @override
  State<CharacterSelectionMenu> createState() => _CharacterSelectionMenuState();
}

class _CharacterSelectionMenuState extends State<CharacterSelectionMenu> {
  late CharacterManager _characterManager;

  @override
  void initState() {
    super.initState();
    _characterManager = widget.game._characterManager;
    _characterManager.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.9),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _buildCharacterGrid(),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  widget.game.overlays.remove(CharacterSelectionMenu.id);
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.purple.shade800, Colors.purple.shade900],
        ),
      ),
      child: Column(
        children: [
          const Text(
            'CHARACTERS',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${_characterManager.unlockedCount}/${_characterManager.totalCount} Unlocked',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterGrid() {
    final characters = _characterManager.getCharactersSorted();

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: characters.length,
      itemBuilder: (context, index) {
        final character = characters[index];
        return _buildCharacterCard(character);
      },
    );
  }

  Widget _buildCharacterCard(Character character) {
    final isSelected = _characterManager.selectedCharacter.id == character.id;
    final isUnlocked = character.isUnlocked;
    final canUnlock = _characterManager.canUnlockCharacter(character);

    return Card(
      color: isSelected
          ? Colors.purple.withOpacity(0.3)
          : (isUnlocked
              ? Colors.white.withOpacity(0.1)
              : Colors.grey.withOpacity(0.1)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected
              ? Colors.purple
              : (isUnlocked ? Colors.white54 : Colors.grey),
          width: isSelected ? 3 : 1,
        ),
      ),
      child: InkWell(
        onTap: isUnlocked
            ? () => _selectCharacter(character)
            : (canUnlock ? () => _unlockCharacter(character) : null),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Character icon placeholder
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: isUnlocked
                      ? Colors.purple.withOpacity(0.3)
                      : Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isUnlocked ? Icons.person : Icons.lock,
                  color: isUnlocked ? Colors.purple : Colors.grey,
                  size: 40,
                ),
              ),
              const SizedBox(height: 8),
              // Character name
              Text(
                character.name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isUnlocked ? Colors.white : Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              // Ability description
              Text(
                character.abilityDescription,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              // Status indicator
              if (isSelected)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'SELECTED',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                )
              else if (!isUnlocked)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: canUnlock ? Colors.amber : Colors.red.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    character.costString,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: canUnlock ? Colors.black : Colors.red,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectCharacter(Character character) {
    _characterManager.selectCharacter(character);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${character.name} selected!'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _unlockCharacter(Character character) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: Text(
          'Unlock ${character.name}?',
          style: const TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              character.description,
              style: TextStyle(color: Colors.white.withOpacity(0.8)),
            ),
            const SizedBox(height: 16),
            Text(
              'Cost: ${character.costString}',
              style: const TextStyle(
                color: Colors.amber,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () {
              final success = _characterManager.unlockCharacter(character);
              Navigator.pop(context);
              
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${character.name} unlocked!'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Not enough currency!'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Unlock'),
          ),
        ],
      ),
    );
  }
}

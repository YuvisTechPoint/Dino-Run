// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CharacterAdapter extends TypeAdapter<Character> {
  @override
  final int typeId = 5;

  @override
  Character read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Character(
      id: fields[0] as String,
      name: fields[1] as String,
      type: fields[2] as CharacterType,
      description: fields[3] as String,
      baseHealth: fields[4] as int,
      baseSpeed: fields[5] as double,
      baseJumpHeight: fields[6] as double,
      spritePath: fields[7] as String,
      unlockCost: fields[8] as int,
      requirement: fields[9] as String,
      isUnlocked: fields[10] as bool,
      currentLevel: fields[11] as int,
      experience: fields[12] as int,
    )..unlockedAbilities = (fields[13] as Map).cast<String, bool>();
  }

  @override
  void write(BinaryWriter writer, Character obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.baseHealth)
      ..writeByte(5)
      ..write(obj.baseSpeed)
      ..writeByte(6)
      ..write(obj.baseJumpHeight)
      ..writeByte(7)
      ..write(obj.spritePath)
      ..writeByte(8)
      ..write(obj.unlockCost)
      ..writeByte(9)
      ..write(obj.requirement)
      ..writeByte(10)
      ..write(obj.isUnlocked)
      ..writeByte(11)
      ..write(obj.currentLevel)
      ..writeByte(12)
      ..write(obj.experience)
      ..writeByte(13)
      ..write(obj.unlockedAbilities);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharacterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

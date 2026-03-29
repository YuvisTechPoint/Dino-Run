// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'skill_tree.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SkillAdapter extends TypeAdapter<Skill> {
  @override
  final int typeId = 7;

  @override
  Skill read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Skill(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      type: fields[3] as SkillType,
      category: fields[4] as SkillCategory,
      maxLevel: fields[5] as int,
      costPerLevel: fields[6] as int,
      requirements: (fields[7] as List).cast<String>(),
      effects: (fields[8] as Map).cast<String, double>(),
      currentLevel: fields[9] as int,
      isUnlocked: fields[10] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Skill obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.maxLevel)
      ..writeByte(6)
      ..write(obj.costPerLevel)
      ..writeByte(7)
      ..write(obj.requirements)
      ..writeByte(8)
      ..write(obj.effects)
      ..writeByte(9)
      ..write(obj.currentLevel)
      ..writeByte(10)
      ..write(obj.isUnlocked);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SkillAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

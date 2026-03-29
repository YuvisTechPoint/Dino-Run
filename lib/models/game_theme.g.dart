// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_theme.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GameThemeAdapter extends TypeAdapter<GameTheme> {
  @override
  final int typeId = 3;

  @override
  GameTheme read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GameTheme(
      type: fields[0] as GameThemeType,
      name: fields[1] as String,
      description: fields[2] as String,
      primaryColor: fields[3] as Color,
      secondaryColor: fields[4] as Color,
      backgroundColor: fields[5] as Color,
      parallaxLayers: (fields[6] as List).cast<String>(),
      groundTexture: fields[7] as String,
      enemyTypes: (fields[8] as List).cast<String>(),
      collectibleType: fields[9] as String,
      powerUpType: fields[10] as String,
      isUnlocked: fields[11] as bool,
      specialEffects: (fields[12] as List).cast<String>(),
      backgroundMusic: fields[13] as String,
      particleEffects: (fields[14] as List).cast<String>(),
      weatherEffect: fields[15] as String,
    );
  }

  @override
  void write(BinaryWriter writer, GameTheme obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.primaryColor)
      ..writeByte(4)
      ..write(obj.secondaryColor)
      ..writeByte(5)
      ..write(obj.backgroundColor)
      ..writeByte(6)
      ..write(obj.parallaxLayers)
      ..writeByte(7)
      ..write(obj.groundTexture)
      ..writeByte(8)
      ..write(obj.enemyTypes)
      ..writeByte(9)
      ..write(obj.collectibleType)
      ..writeByte(10)
      ..write(obj.powerUpType)
      ..writeByte(11)
      ..write(obj.isUnlocked)
      ..writeByte(12)
      ..write(obj.specialEffects)
      ..writeByte(13)
      ..write(obj.backgroundMusic)
      ..writeByte(14)
      ..write(obj.particleEffects)
      ..writeByte(15)
      ..write(obj.weatherEffect);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameThemeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

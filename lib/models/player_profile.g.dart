// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_profile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlayerProfileAdapter extends TypeAdapter<PlayerProfile> {
  @override
  final int typeId = 4;

  @override
  PlayerProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlayerProfile()
      ..playerName = fields[0] as String
      ..playerLevel = fields[1] as int
      ..experiencePoints = fields[2] as int
      ..totalCoins = fields[3] as int
      ..totalGamesPlayed = fields[4] as int
      ..totalPlayTime = fields[5] as int
      ..longestRun = fields[6] as int
      ..totalDistance = fields[7] as int
      ..totalEnemiesDefeated = fields[8] as int
      ..totalPowerUpsCollected = fields[9] as int
      ..perfectRuns = fields[10] as int
      ..themeMastery = (fields[11] as Map).cast<String, int>()
      ..unlockedCharacters = (fields[12] as List).cast<String>()
      ..selectedCharacter = fields[13] as String
      ..playerTitle = fields[14] as int
      ..completedChallenges = (fields[15] as List).cast<String>()
      ..currentStreak = fields[16] as int
      ..lastPlayDate = fields[17] as DateTime
      ..skillUnlocks = (fields[18] as Map).cast<String, bool>();
  }

  @override
  void write(BinaryWriter writer, PlayerProfile obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.playerName)
      ..writeByte(1)
      ..write(obj.playerLevel)
      ..writeByte(2)
      ..write(obj.experiencePoints)
      ..writeByte(3)
      ..write(obj.totalCoins)
      ..writeByte(4)
      ..write(obj.totalGamesPlayed)
      ..writeByte(5)
      ..write(obj.totalPlayTime)
      ..writeByte(6)
      ..write(obj.longestRun)
      ..writeByte(7)
      ..write(obj.totalDistance)
      ..writeByte(8)
      ..write(obj.totalEnemiesDefeated)
      ..writeByte(9)
      ..write(obj.totalPowerUpsCollected)
      ..writeByte(10)
      ..write(obj.perfectRuns)
      ..writeByte(11)
      ..write(obj.themeMastery)
      ..writeByte(12)
      ..write(obj.unlockedCharacters)
      ..writeByte(13)
      ..write(obj.selectedCharacter)
      ..writeByte(14)
      ..write(obj.playerTitle)
      ..writeByte(15)
      ..write(obj.completedChallenges)
      ..writeByte(16)
      ..write(obj.currentStreak)
      ..writeByte(17)
      ..write(obj.lastPlayDate)
      ..writeByte(18)
      ..write(obj.skillUnlocks);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

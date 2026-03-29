// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_challenge.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailyChallengeAdapter extends TypeAdapter<DailyChallenge> {
  @override
  final int typeId = 6;

  @override
  DailyChallenge read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyChallenge(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      type: fields[3] as ChallengeType,
      difficulty: fields[4] as ChallengeDifficulty,
      targetValue: fields[5] as int,
      rewardCoins: fields[6] as int,
      rewardExperience: fields[7] as int,
      specialReward: fields[8] as String,
      dateCreated: fields[9] as DateTime,
      dateCompleted: fields[10] as DateTime?,
      requirements: (fields[11] as Map).cast<String, dynamic>(),
      isCompleted: fields[12] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, DailyChallenge obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.difficulty)
      ..writeByte(5)
      ..write(obj.targetValue)
      ..writeByte(6)
      ..write(obj.rewardCoins)
      ..writeByte(7)
      ..write(obj.rewardExperience)
      ..writeByte(8)
      ..write(obj.specialReward)
      ..writeByte(9)
      ..write(obj.dateCreated)
      ..writeByte(10)
      ..write(obj.dateCompleted)
      ..writeByte(11)
      ..write(obj.requirements)
      ..writeByte(12)
      ..write(obj.isCompleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyChallengeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

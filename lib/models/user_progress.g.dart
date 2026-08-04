// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_progress.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProgressAdapter extends TypeAdapter<UserProgress> {
  @override
  final int typeId = 8;

  @override
  UserProgress read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProgress(
      totalWordsLearned: fields[0] as int,
      totalScenesCompleted: fields[1] as int,
      streakDays: fields[2] as int,
      lastStudyDate: fields[3] as DateTime?,
      completedScenes: (fields[4] as Map?)?.cast<String, bool>(),
      pronunciationScores: (fields[5] as Map?)?.cast<String, int>(),
      todayReviewed: fields[6] as int,
      createdAt: fields[7] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, UserProgress obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.totalWordsLearned)
      ..writeByte(1)
      ..write(obj.totalScenesCompleted)
      ..writeByte(2)
      ..write(obj.streakDays)
      ..writeByte(3)
      ..write(obj.lastStudyDate)
      ..writeByte(4)
      ..write(obj.completedScenes)
      ..writeByte(5)
      ..write(obj.pronunciationScores)
      ..writeByte(6)
      ..write(obj.todayReviewed)
      ..writeByte(7)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProgressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

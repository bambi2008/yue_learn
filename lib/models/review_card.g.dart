// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_card.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReviewCardAdapter extends TypeAdapter<ReviewCard> {
  @override
  final int typeId = 7;

  @override
  ReviewCard read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReviewCard(
      id: fields[0] as String,
      vocabId: fields[1] as String,
      cantonese: fields[2] as String,
      jyutping: fields[3] as String,
      mandarin: fields[4] as String,
      audioPath: fields[5] as String,
      exampleCantonese: fields[6] as String,
      exampleMandarin: fields[7] as String,
      easiness: fields[8] as double,
      interval: fields[9] as int,
      repetitions: fields[10] as int,
      nextReview: fields[11] as DateTime?,
      createdAt: fields[12] as DateTime?,
      lastReviewedAt: fields[13] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, ReviewCard obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.vocabId)
      ..writeByte(2)
      ..write(obj.cantonese)
      ..writeByte(3)
      ..write(obj.jyutping)
      ..writeByte(4)
      ..write(obj.mandarin)
      ..writeByte(5)
      ..write(obj.audioPath)
      ..writeByte(6)
      ..write(obj.exampleCantonese)
      ..writeByte(7)
      ..write(obj.exampleMandarin)
      ..writeByte(8)
      ..write(obj.easiness)
      ..writeByte(9)
      ..write(obj.interval)
      ..writeByte(10)
      ..write(obj.repetitions)
      ..writeByte(11)
      ..write(obj.nextReview)
      ..writeByte(12)
      ..write(obj.createdAt)
      ..writeByte(13)
      ..write(obj.lastReviewedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReviewCardAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

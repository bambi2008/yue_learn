// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CourseCategoryAdapter extends TypeAdapter<CourseCategory> {
  @override
  final int typeId = 0;

  @override
  CourseCategory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CourseCategory(
      id: fields[0] as String,
      name: fields[1] as String,
      icon: fields[2] as String,
      description: fields[3] as String,
      completedScenes: fields[4] as int,
      totalScenes: fields[5] as int,
      sceneIds: (fields[6] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, CourseCategory obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.icon)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.completedScenes)
      ..writeByte(5)
      ..write(obj.totalScenes)
      ..writeByte(6)
      ..write(obj.sceneIds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CourseCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SceneAdapter extends TypeAdapter<Scene> {
  @override
  final int typeId = 1;

  @override
  Scene read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Scene(
      id: fields[0] as String,
      categoryId: fields[1] as String,
      title: fields[2] as String,
      subtitle: fields[3] as String,
      coverImage: fields[4] as String,
      dialogues: (fields[5] as List).cast<Dialogue>(),
      vocabulary: (fields[6] as List).cast<VocabItem>(),
      grammarNotes: (fields[7] as List).cast<GrammarNote>(),
    );
  }

  @override
  void write(BinaryWriter writer, Scene obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.categoryId)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.subtitle)
      ..writeByte(4)
      ..write(obj.coverImage)
      ..writeByte(5)
      ..write(obj.dialogues)
      ..writeByte(6)
      ..write(obj.vocabulary)
      ..writeByte(7)
      ..write(obj.grammarNotes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SceneAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DialogueAdapter extends TypeAdapter<Dialogue> {
  @override
  final int typeId = 2;

  @override
  Dialogue read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Dialogue(
      id: fields[0] as String,
      title: fields[1] as String,
      sentences: (fields[2] as List).cast<Sentence>(),
    );
  }

  @override
  void write(BinaryWriter writer, Dialogue obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.sentences);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DialogueAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SentenceAdapter extends TypeAdapter<Sentence> {
  @override
  final int typeId = 3;

  @override
  Sentence read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Sentence(
      id: fields[0] as String,
      cantonese: fields[1] as String,
      jyutping: fields[2] as String,
      mandarin: fields[3] as String,
      audioPath: fields[4] as String,
      speaker: fields[5] as String,
      wordBreakdown: (fields[6] as List).cast<WordBreakdown>(),
    );
  }

  @override
  void write(BinaryWriter writer, Sentence obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.cantonese)
      ..writeByte(2)
      ..write(obj.jyutping)
      ..writeByte(3)
      ..write(obj.mandarin)
      ..writeByte(4)
      ..write(obj.audioPath)
      ..writeByte(5)
      ..write(obj.speaker)
      ..writeByte(6)
      ..write(obj.wordBreakdown);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SentenceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WordBreakdownAdapter extends TypeAdapter<WordBreakdown> {
  @override
  final int typeId = 4;

  @override
  WordBreakdown read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WordBreakdown(
      cantonese: fields[0] as String,
      jyutping: fields[1] as String,
      mandarin: fields[2] as String,
      literal: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, WordBreakdown obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.cantonese)
      ..writeByte(1)
      ..write(obj.jyutping)
      ..writeByte(2)
      ..write(obj.mandarin)
      ..writeByte(3)
      ..write(obj.literal);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordBreakdownAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class VocabItemAdapter extends TypeAdapter<VocabItem> {
  @override
  final int typeId = 5;

  @override
  VocabItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VocabItem(
      id: fields[0] as String,
      sceneId: fields[1] as String,
      cantonese: fields[2] as String,
      jyutping: fields[3] as String,
      mandarin: fields[4] as String,
      partOfSpeech: fields[5] as String,
      audioPath: fields[6] as String,
      exampleCantonese: fields[7] as String,
      exampleMandarin: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, VocabItem obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.sceneId)
      ..writeByte(2)
      ..write(obj.cantonese)
      ..writeByte(3)
      ..write(obj.jyutping)
      ..writeByte(4)
      ..write(obj.mandarin)
      ..writeByte(5)
      ..write(obj.partOfSpeech)
      ..writeByte(6)
      ..write(obj.audioPath)
      ..writeByte(7)
      ..write(obj.exampleCantonese)
      ..writeByte(8)
      ..write(obj.exampleMandarin);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VocabItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GrammarNoteAdapter extends TypeAdapter<GrammarNote> {
  @override
  final int typeId = 6;

  @override
  GrammarNote read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GrammarNote(
      title: fields[0] as String,
      explanation: fields[1] as String,
      cantoneseExample: fields[2] as String,
      mandarinExample: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, GrammarNote obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.explanation)
      ..writeByte(2)
      ..write(obj.cantoneseExample)
      ..writeByte(3)
      ..write(obj.mandarinExample);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GrammarNoteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

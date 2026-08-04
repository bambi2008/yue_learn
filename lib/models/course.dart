import 'package:hive/hive.dart';

part 'course.g.dart';

/// 课程分类
@HiveType(typeId: 0)
class CourseCategory extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name; // e.g. "餐饮"

  @HiveField(2)
  final String icon; // emoji

  @HiveField(3)
  final String description;

  @HiveField(4)
  final int completedScenes;

  @HiveField(5)
  final int totalScenes;

  @HiveField(6)
  final List<String> sceneIds;

  CourseCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
    this.completedScenes = 0,
    required this.totalScenes,
    required this.sceneIds,
  });

  double get progress =>
      totalScenes > 0 ? completedScenes / totalScenes : 0.0;
}

/// 场景（一门课）
@HiveType(typeId: 1)
class Scene extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String categoryId;

  @HiveField(2)
  final String title; // e.g. "茶餐厅点餐"

  @HiveField(3)
  final String subtitle; // 简介

  @HiveField(4)
  final String coverImage; // 封面图

  @HiveField(5)
  final List<Dialogue> dialogues;

  @HiveField(6)
  final List<VocabItem> vocabulary;

  @HiveField(7)
  final List<GrammarNote> grammarNotes;

  Scene({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.subtitle,
    this.coverImage = '',
    required this.dialogues,
    required this.vocabulary,
    this.grammarNotes = const [],
  });
}

/// 对话
@HiveType(typeId: 2)
class Dialogue extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title; // e.g. "入座点餐"

  @HiveField(2)
  final List<Sentence> sentences;

  Dialogue({
    required this.id,
    required this.title,
    required this.sentences,
  });
}

/// 句子
@HiveType(typeId: 3)
class Sentence extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String cantonese; // 粤语汉字

  @HiveField(2)
  final String jyutping; // 粤拼

  @HiveField(3)
  final String mandarin; // 普通话翻译

  @HiveField(4)
  final String audioPath; // 音频文件路径

  @HiveField(5)
  final String speaker; // 说话人

  @HiveField(6)
  final List<WordBreakdown> wordBreakdown; // 逐词拆解

  Sentence({
    required this.id,
    required this.cantonese,
    required this.jyutping,
    required this.mandarin,
    required this.audioPath,
    this.speaker = '',
    this.wordBreakdown = const [],
  });
}

/// 逐词拆解
@HiveType(typeId: 4)
class WordBreakdown extends HiveObject {
  @HiveField(0)
  final String cantonese; // "唔該"

  @HiveField(1)
  final String jyutping; // "m4 goi1"

  @HiveField(2)
  final String mandarin; // "麻烦/谢谢"

  @HiveField(3)
  final String literal; // 直译

  WordBreakdown({
    required this.cantonese,
    required this.jyutping,
    required this.mandarin,
    this.literal = '',
  });
}

/// 生词
@HiveType(typeId: 5)
class VocabItem extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String sceneId;

  @HiveField(2)
  final String cantonese;

  @HiveField(3)
  final String jyutping;

  @HiveField(4)
  final String mandarin;

  @HiveField(5)
  final String partOfSpeech; // 词性

  @HiveField(6)
  final String audioPath;

  @HiveField(7)
  final String exampleCantonese; // 例句(粤)

  @HiveField(8)
  final String exampleMandarin; // 例句(普)

  VocabItem({
    required this.id,
    required this.sceneId,
    required this.cantonese,
    required this.jyutping,
    required this.mandarin,
    this.partOfSpeech = '',
    required this.audioPath,
    this.exampleCantonese = '',
    this.exampleMandarin = '',
  });
}

/// 语法笔记
@HiveType(typeId: 6)
class GrammarNote extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String explanation; // 普通话解释

  @HiveField(2)
  final String cantoneseExample;

  @HiveField(3)
  final String mandarinExample;

  GrammarNote({
    required this.title,
    required this.explanation,
    this.cantoneseExample = '',
    this.mandarinExample = '',
  });
}

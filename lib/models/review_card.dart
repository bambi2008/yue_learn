import 'package:hive/hive.dart';

part 'review_card.g.dart';

/// SRS 复习卡片
@HiveType(typeId: 7)
class ReviewCard extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String vocabId; // 关联 VocabItem.id

  @HiveField(2)
  final String cantonese;

  @HiveField(3)
  final String jyutping;

  @HiveField(4)
  final String mandarin;

  @HiveField(5)
  final String audioPath;

  @HiveField(6)
  final String exampleCantonese;

  @HiveField(7)
  final String exampleMandarin;

  // SM-2 算法字段
  @HiveField(8)
  double easiness; // 容易度 (默认 2.5)

  @HiveField(9)
  int interval; // 间隔天数

  @HiveField(10)
  int repetitions; // 复习次数

  @HiveField(11)
  DateTime nextReview; // 下次复习日期

  @HiveField(12)
  DateTime createdAt;

  @HiveField(13)
  DateTime lastReviewedAt;

  ReviewCard({
    required this.id,
    required this.vocabId,
    required this.cantonese,
    required this.jyutping,
    required this.mandarin,
    required this.audioPath,
    this.exampleCantonese = '',
    this.exampleMandarin = '',
    this.easiness = 2.5,
    this.interval = 0,
    this.repetitions = 0,
    DateTime? nextReview,
    DateTime? createdAt,
    DateTime? lastReviewedAt,
  })  : nextReview = nextReview ?? DateTime.now(),
        createdAt = createdAt ?? DateTime.now(),
        lastReviewedAt = lastReviewedAt ?? DateTime.now();

  /// 是否该今天复习
  bool get isDue =>
      nextReview.isBefore(DateTime.now()) ||
      nextReview.difference(DateTime.now()).inHours < 1;

  /// SM-2 评分后更新
  void update(int quality) {
    // quality: 0=重来, 1=困难, 2=良好, 3=简单
    if (quality < 0) quality = 0;
    if (quality > 3) quality = 3;

    // 映射到 SuperMemo 的 0-5 分制
    final sm2Quality = _toSm2Quality(quality);

    if (sm2Quality >= 3) {
      // 正确回答
      if (repetitions == 0) {
        interval = 1;
      } else if (repetitions == 1) {
        interval = 3;
      } else {
        interval = (interval * easiness).round();
      }
      repetitions++;
    } else {
      // 错误回答 - 重置
      repetitions = 0;
      interval = 1;
    }

    // 更新 easiness
    easiness = easiness + (0.1 - (4 - sm2Quality) * (0.08 + (4 - sm2Quality) * 0.02));
    if (easiness < 1.3) easiness = 1.3;

    // 设置下次复习时间
    nextReview = DateTime.now().add(Duration(days: interval));
    lastReviewedAt = DateTime.now();
  }

  int _toSm2Quality(int appQuality) {
    // App 的 4 级映射到 SM-2 的 0-5
    switch (appQuality) {
      case 0:
        return 0; // 完全忘记
      case 1:
        return 2; // 记得但困难
      case 2:
        return 4; // 良好
      case 3:
        return 5; // 完美
      default:
        return 0;
    }
  }
}

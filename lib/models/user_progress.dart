import 'package:hive/hive.dart';

part 'user_progress.g.dart';

/// 用户学习进度
@HiveType(typeId: 8)
class UserProgress extends HiveObject {
  @HiveField(0)
  int totalWordsLearned; // 已学总词汇

  @HiveField(1)
  int totalScenesCompleted; // 已完成场景数

  @HiveField(2)
  int streakDays; // 连续打卡天数

  @HiveField(3)
  DateTime lastStudyDate; // 最后学习日期

  @HiveField(4)
  Map<String, bool> completedScenes; // sceneId → 是否完成

  @HiveField(5)
  Map<String, int> pronunciationScores; // 最近评分记录

  @HiveField(6)
  int todayReviewed; // 今日已复习数

  @HiveField(7)
  DateTime createdAt;

  UserProgress({
    this.totalWordsLearned = 0,
    this.totalScenesCompleted = 0,
    this.streakDays = 0,
    DateTime? lastStudyDate,
    Map<String, bool>? completedScenes,
    Map<String, int>? pronunciationScores,
    this.todayReviewed = 0,
    DateTime? createdAt,
  }) : lastStudyDate = lastStudyDate ?? DateTime.now(),
       completedScenes = completedScenes ?? {},
       pronunciationScores = pronunciationScores ?? {},
       createdAt = createdAt ?? DateTime.now();

  /// 标记今日学习（更新打卡）
  void markStudied() {
    final now = DateTime.now();

    // 新用户第一次学习时，默认的 lastStudyDate 也是今天，
    // 因此需要优先建立第一天的连续学习记录。
    if (streakDays == 0) {
      streakDays = 1;
      lastStudyDate = now;
      return;
    }

    final today = DateTime(now.year, now.month, now.day);
    final last = DateTime(
      lastStudyDate.year,
      lastStudyDate.month,
      lastStudyDate.day,
    );

    if (today == last) return; // 今天已打过卡

    if (today.difference(last).inDays == 1) {
      streakDays++;
    } else {
      streakDays = 1; // 断签，重新计算
    }

    lastStudyDate = now;
  }
}

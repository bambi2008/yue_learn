import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_progress.dart';
import '../utils/constants.dart';

class UserProvider extends ChangeNotifier {
  final UserProgress _progress;
  final Box<UserProgress> _box = Hive.box<UserProgress>(
    AppConstants.userProgressBox,
  );

  UserProvider(this._progress);

  UserProgress get progress => _progress;

  int get streakDays => _progress.streakDays;
  int get totalWordsLearned => _progress.totalWordsLearned;
  int get totalScenesCompleted => _progress.totalScenesCompleted;
  Map<String, bool> get completedScenes => _progress.completedScenes;

  /// 标记场景完成
  void completeScene(String sceneId) {
    if (_progress.completedScenes[sceneId] == true) return;

    _progress.completedScenes[sceneId] = true;
    _progress.totalScenesCompleted++;
    _progress.markStudied();
    _save();
  }

  /// 添加已学词汇
  void addWordsLearned(int count) {
    _progress.totalWordsLearned += count;
    _progress.markStudied();
    _save();
  }

  /// 记录发音评分
  void recordPronunciationScore(int score) {
    final key = DateTime.now().toIso8601String();
    _progress.pronunciationScores[key] = score;
    // 只保留最近 50 条
    if (_progress.pronunciationScores.length > 50) {
      final oldestKey = _progress.pronunciationScores.keys.first;
      _progress.pronunciationScores.remove(oldestKey);
    }
    _save();
  }

  /// 记录一次“今日开口”练习，不要求完成整门场景课。
  void recordPracticeSession() {
    _progress.markStudied();
    _save();
  }

  /// 今日复习计数
  void incrementTodayReviewed() {
    _progress.todayReviewed++;
    // 复习也属于学习行为，更新学习日期后，下一天才能正确重置计数。
    _progress.markStudied();
    _save();
  }

  /// 重置今日复习计数（每天零点调用）
  void resetTodayReviewedIfNeeded() {
    final now = DateTime.now();
    final last = _progress.lastStudyDate;
    if (now.day != last.day ||
        now.month != last.month ||
        now.year != last.year) {
      _progress.todayReviewed = 0;
      _save();
    }
  }

  void _save() {
    _box.put('progress', _progress);
    notifyListeners();
  }
}

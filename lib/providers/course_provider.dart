import 'package:flutter/foundation.dart';
import '../models/course.dart';
import '../data/sample_courses.dart';

class CourseProvider extends ChangeNotifier {
  List<CourseCategory> _categories = [];
  List<Scene> _scenes = [];
  Map<String, Scene> _scenesById = {};

  List<CourseCategory> get categories => _categories;
  List<Scene> get scenes => _scenes;

  /// 加载课程数据（首次启动从内置数据导入）
  void loadCourses() {
    // 从内置数据加载
    _categories = SampleCourses.categories;
    _scenes = [];

    for (final cat in _categories) {
      final catScenes =
          SampleCourses.scenes.where((s) => s.categoryId == cat.id).toList();
      _scenes.addAll(catScenes);
    }

    // 建立索引
    _scenesById = {for (final s in _scenes) s.id: s};

    notifyListeners();
  }

  /// 获取某个分类的场景列表
  List<Scene> getScenesByCategory(String categoryId) {
    return _scenes.where((s) => s.categoryId == categoryId).toList();
  }

  /// 获取场景
  Scene? getScene(String sceneId) {
    return _scenesById[sceneId];
  }

  /// 获取某分类的完成场景数
  int getCompletedCount(String categoryId, Map<String, bool> completedScenes) {
    return getScenesByCategory(categoryId)
        .where((s) => completedScenes[s.id] == true)
        .length;
  }
}

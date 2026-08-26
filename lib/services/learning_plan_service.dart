import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../models/learning_plan.dart';
import '../utils/constants.dart';

class LearningPlanService extends ChangeNotifier {
  static const _key = 'learning_plan';

  final Box _box;
  LearningPlan? _plan;

  LearningPlanService({Box? box})
    : _box = box ?? Hive.box(AppConstants.settingsBox);

  LearningPlan? get plan => _plan;
  bool get hasPlan => _plan != null;

  void load() {
    final raw = _box.get(_key) as String?;
    if (raw == null) return;
    try {
      _plan = LearningPlan.decode(raw);
    } catch (_) {
      _plan = null;
      _box.delete(_key);
    }
    notifyListeners();
  }

  Future<void> createPlan({
    required String goalKey,
    required String goalLabel,
    required String levelKey,
    required String levelLabel,
    required int minutesPerDay,
  }) async {
    final sceneIds = _sceneIdsFor(goalKey);
    final plan = LearningPlan(
      goalKey: goalKey,
      goalLabel: goalLabel,
      levelKey: levelKey,
      levelLabel: levelLabel,
      minutesPerDay: minutesPerDay,
      sceneIds: sceneIds,
      dailyFocus: const [
        '先听懂最常用的一句',
        '学会自己点餐或回应',
        '练一次问路和确认',
        '把一句话换成自己的版本',
        '完成一次买东西的对话',
        '复习前五天，减少停顿',
        '完成一轮完整角色扮演',
      ],
      createdAt: DateTime.now(),
    );
    _plan = plan;
    await _box.put(_key, plan.encode());
    notifyListeners();
  }

  Future<void> clear() async {
    _plan = null;
    await _box.delete(_key);
    notifyListeners();
  }

  List<String> _sceneIdsFor(String goalKey) {
    switch (goalKey) {
      case 'travel':
        return const [
          'transport_1',
          'transport_2',
          'dining_1',
          'shopping_1',
          'transport_3',
          'dining_2',
          'shopping_2',
        ];
      case 'work':
        return const [
          'workplace_1',
          'workplace_2',
          'workplace_3',
          'transport_1',
          'dining_1',
          'workplace_1',
          'workplace_2',
        ];
      default:
        return const [
          'dining_1',
          'transport_1',
          'shopping_1',
          'dining_2',
          'transport_2',
          'shopping_2',
          'dining_3',
        ];
    }
  }
}

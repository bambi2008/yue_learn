import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

import 'package:yue_learn/services/learning_plan_service.dart';

void main() {
  late Directory directory;

  setUpAll(() async {
    directory = await Directory.systemTemp.createTemp('yue_learn_plan_');
    Hive.init(directory.path);
  });

  tearDownAll(() async {
    await directory.delete(recursive: true);
  });

  test('creates and persists a seven-day plan', () async {
    final box = await Hive.openBox('settings_test');
    final service = LearningPlanService(box: box);

    await service.createPlan(
      goalKey: 'travel',
      goalLabel: '旅行生活',
      levelKey: 'beginner',
      levelLabel: '完全不会',
      minutesPerDay: 5,
    );

    expect(service.plan, isNotNull);
    expect(service.plan!.sceneIds, hasLength(7));
    expect(service.plan!.todayFocus, isNotEmpty);

    final restored = LearningPlanService(box: box)..load();
    expect(restored.plan!.goalKey, 'travel');
    expect(restored.plan!.minutesPerDay, 5);

    await box.close();
  });
}

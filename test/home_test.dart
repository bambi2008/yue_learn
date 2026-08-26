import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import 'package:yue_learn/models/review_card.dart';
import 'package:yue_learn/models/user_progress.dart';
import 'package:yue_learn/providers/course_provider.dart';
import 'package:yue_learn/providers/srs_provider.dart';
import 'package:yue_learn/providers/user_provider.dart';
import 'package:yue_learn/screens/home/home_screen.dart';
import 'package:yue_learn/utils/constants.dart';

void main() {
  late Directory testDirectory;

  setUpAll(() async {
    testDirectory = await Directory.systemTemp.createTemp('yue_learn_home_');
    Hive.init(testDirectory.path);
    Hive.registerAdapter(ReviewCardAdapter());
    Hive.registerAdapter(UserProgressAdapter());
    await Hive.openBox<ReviewCard>(AppConstants.reviewCardsBox);
    final progressBox = await Hive.openBox<UserProgress>(
      AppConstants.userProgressBox,
    );
    await progressBox.put('progress', UserProgress());
  });

  tearDownAll(() async {
    await Hive.box<ReviewCard>(AppConstants.reviewCardsBox).close();
    await Hive.box<UserProgress>(AppConstants.userProgressBox).close();
    await testDirectory.delete(recursive: true);
  });

  testWidgets('new users see the first lesson CTA', (tester) async {
    final progress = Hive.box<UserProgress>(
      AppConstants.userProgressBox,
    ).get('progress')!;
    final courseProvider = CourseProvider();
    final userProvider = UserProvider(progress);
    final srsProvider = SRSProvider();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: courseProvider),
          ChangeNotifierProvider.value(value: userProvider),
          ChangeNotifierProvider.value(value: srsProvider),
        ],
        child: const MaterialApp(home: HomeScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('开始第一课'), findsOneWidget);
    expect(find.text('茶餐厅点餐 · 约 5 分钟，学会第一句粤语'), findsOneWidget);

    courseProvider.dispose();
    userProvider.dispose();
    srsProvider.dispose();
  });
}

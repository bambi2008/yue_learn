import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'providers/course_provider.dart';
import 'providers/audio_provider.dart';
import 'providers/user_provider.dart';
import 'providers/srs_provider.dart';
import 'providers/speech_provider.dart';
import 'services/purchase_service.dart';
import 'models/course.dart';
import 'models/review_card.dart';
import 'models/user_progress.dart';
import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化 Hive
  await Hive.initFlutter();

  // 注册 TypeAdapters (由 build_runner 生成)
  Hive.registerAdapter(CourseCategoryAdapter());
  Hive.registerAdapter(SceneAdapter());
  Hive.registerAdapter(DialogueAdapter());
  Hive.registerAdapter(SentenceAdapter());
  Hive.registerAdapter(WordBreakdownAdapter());
  Hive.registerAdapter(VocabItemAdapter());
  Hive.registerAdapter(GrammarNoteAdapter());
  Hive.registerAdapter(ReviewCardAdapter());
  Hive.registerAdapter(UserProgressAdapter());

  // 打开 Boxes
  await Hive.openBox(AppConstants.coursesBox);
  await Hive.openBox<ReviewCard>(AppConstants.reviewCardsBox);
  final userBox = await Hive.openBox<UserProgress>(
    AppConstants.userProgressBox,
  );

  // 确保有 UserProgress
  if (userBox.isEmpty) {
    userBox.put('progress', UserProgress());
  }

  final userProgress = userBox.get('progress')!;

  // 初始化购买服务
  final purchaseService = PurchaseService();
  await purchaseService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CourseProvider()),
        ChangeNotifierProvider(create: (_) => AudioProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider(userProgress)),
        ChangeNotifierProvider(create: (_) => SRSProvider()),
        ChangeNotifierProvider(create: (_) => SpeechProvider()),
        ChangeNotifierProvider.value(value: purchaseService),
      ],
      child: const YueLearnApp(),
    ),
  );
}

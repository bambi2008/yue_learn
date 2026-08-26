import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/course_provider.dart';
import '../../providers/srs_provider.dart';
import '../../providers/user_provider.dart';
import '../../models/course.dart';
import '../../theme/app_colors.dart';
import '../../widgets/progress_ring.dart';
import '../courses/course_list_screen.dart';
import '../courses/dialogue_screen.dart';
import '../coach/coach_screen.dart';
import '../profile/profile_screen.dart';
import '../review/flashcard_screen.dart';
import '../quick_start/quick_start_screen.dart';
import '../../widgets/adaptive_content.dart';
import '../../services/learning_plan_service.dart';
import '../diagnostic/diagnostic_screen.dart';
import '../learning_plan/learning_plan_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    // 延后到首帧之后，避免在 Provider 祖先构建期间触发 notifyListeners。
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<CourseProvider>().loadCourses();
      context.read<UserProvider>().resetTodayReviewedIfNeeded();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentTab,
        children: [
          _buildHomeTab(),
          _buildCoursesTab(),
          _buildCoachTab(),
          _buildProfileTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTab,
        onTap: (i) => setState(() => _currentTab = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: '首页'),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_rounded),
            label: '课程',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.chat_rounded), label: '阿明'),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: '我的',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeTab() {
    return Consumer3<UserProvider, SRSProvider, CourseProvider>(
      builder: (context, user, srs, courses, _) {
        final firstScene = courses.getScene('dining_1');
        final learningPlan = Provider.of<LearningPlanService?>(context);

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: AdaptiveContent(
              maxWidth: 720,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '粤讲粤易',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            '每日学几句，开口讲粤语',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      ProgressRing(
                        progress: user.totalScenesCompleted / 12,
                        size: 60,
                        strokeWidth: 5,
                        child: Text(
                          '${user.totalScenesCompleted}/12',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  if (firstScene != null) ...[
                    _buildQuickStartCard(context, firstScene),
                    const SizedBox(height: 20),
                  ],

                  if (learningPlan != null && !learningPlan.hasPlan) ...[
                    _buildDiagnosticCard(context),
                    const SizedBox(height: 20),
                  ] else if (learningPlan?.hasPlan == true) ...[
                    _buildPlanCard(context, learningPlan!),
                    const SizedBox(height: 20),
                  ],

                  // Streak & stats
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon: Icons.local_fire_department,
                          iconColor: AppColors.primary,
                          value: '${user.streakDays}',
                          label: '连续打卡',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.mic,
                          iconColor: AppColors.jyutping,
                          value: '${srs.dueCount}',
                          label: '待复习',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.auto_stories,
                          iconColor: AppColors.success,
                          value: '${user.totalWordsLearned}',
                          label: '已学词汇',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Quick action: Review
                  if (srs.dueCount > 0)
                    _buildReviewCard(context, srs.dueCount)
                  else if (user.totalScenesCompleted == 0 && firstScene != null)
                    _buildFirstLessonCard(context, firstScene),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickStartCard(BuildContext context, Scene scene) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => QuickStartScreen(scene: scene)),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.primaryLight],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.22),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            const Text('🗣️', style: TextStyle(fontSize: 38)),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '今天先开口',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '5 分钟学 3 句，听 → 跟读 → 真正讲出来',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white70,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiagnosticCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const DiagnosticScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.warmSurface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.14)),
        ),
        child: const Row(
          children: [
            Text('🧭', style: TextStyle(fontSize: 30)),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '先做 3 分钟诊断',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '按你的目标，生成 7 天最快开口路线',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.primary),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(BuildContext context, LearningPlanService service) {
    final plan = service.plan!;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const LearningPlanScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.warmSurface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.14)),
        ),
        child: Row(
          children: [
            const Text('🗓️', style: TextStyle(fontSize: 30)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '第 ${plan.todayIndex + 1} 天 · ${plan.todayFocus}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${plan.goalLabel} · ${plan.minutesPerDay} 分钟，打开 7 天计划',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewCard(BuildContext context, int dueCount) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const FlashcardScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.primaryLight],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Icon(Icons.replay_rounded, color: Colors.white, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '开始今日复习',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '$dueCount 张卡片等待复习',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white70,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFirstLessonCard(BuildContext context, Scene scene) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DialogueScreen(scene: scene)),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.warmSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            const Text('🍜', style: TextStyle(fontSize: 32)),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '开始第一课',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '茶餐厅点餐 · 约 5 分钟，学会第一句粤语',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildCoursesTab() {
    return const CourseListScreen();
  }

  Widget _buildCoachTab() {
    return const CoachScreen();
  }

  Widget _buildProfileTab() {
    return const ProfileScreen();
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

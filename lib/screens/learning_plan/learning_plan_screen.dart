import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/course_provider.dart';
import '../../services/learning_plan_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/adaptive_content.dart';
import '../quick_start/quick_start_screen.dart';

class LearningPlanScreen extends StatelessWidget {
  final bool showStartButton;

  const LearningPlanScreen({super.key, this.showStartButton = true});

  @override
  Widget build(BuildContext context) {
    final plan = context.watch<LearningPlanService>().plan;
    final courses = context.watch<CourseProvider>();
    if (plan == null) {
      return const Scaffold(body: Center(child: Text('还没有生成学习计划')));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('我的 7 天开口计划')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: AdaptiveContent(
            maxWidth: 640,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryLight],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${plan.goalLabel} · ${plan.levelLabel}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '每天 ${plan.minutesPerDay} 分钟，先听懂，再讲出来。',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ...List.generate(plan.sceneIds.length, (index) {
                  final scene = courses.getScene(plan.sceneIds[index]);
                  final isToday = index == plan.todayIndex;
                  return _DayTile(
                    day: index + 1,
                    focus: plan.dailyFocus[index],
                    sceneTitle: scene?.title ?? '实用粤语',
                    isToday: isToday,
                  );
                }),
                if (showStartButton) ...[
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      final scene = courses.getScene(plan.todaySceneId);
                      if (scene == null) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => QuickStartScreen(scene: scene),
                        ),
                      );
                    },
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: const Text('开始今天的练习'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DayTile extends StatelessWidget {
  final int day;
  final String focus;
  final String sceneTitle;
  final bool isToday;

  const _DayTile({
    required this.day,
    required this.focus,
    required this.sceneTitle,
    required this.isToday,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isToday
            ? AppColors.primary.withValues(alpha: 0.1)
            : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isToday ? AppColors.primary : Colors.black12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 17,
            backgroundColor: isToday ? AppColors.primary : Colors.black12,
            child: Text(
              '$day',
              style: TextStyle(
                color: isToday ? Colors.white : AppColors.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isToday ? '今天 · $sceneTitle' : '第 $day 天 · $sceneTitle',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 3),
                Text(
                  focus,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (isToday)
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.primary,
            ),
        ],
      ),
    );
  }
}

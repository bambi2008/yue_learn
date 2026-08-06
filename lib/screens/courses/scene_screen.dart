import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/course_provider.dart';
import '../../providers/user_provider.dart';
import '../../theme/app_colors.dart';
import '../../models/course.dart';
import '../../widgets/adaptive_content.dart';
import 'dialogue_screen.dart';

class SceneScreen extends StatelessWidget {
  final CourseCategory category;

  const SceneScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final courseProvider = context.read<CourseProvider>();
    final scenes = courseProvider.getScenesByCategory(category.id);
    final completed = context.watch<UserProvider>().completedScenes;

    return Scaffold(
      appBar: AppBar(title: Text('${category.icon} ${category.name}')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: scenes.length,
        itemBuilder: (context, index) {
          final scene = scenes[index];
          final isDone = completed[scene.id] == true;

          return AdaptiveContent(
            maxWidth: 720,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Card(
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DialogueScreen(scene: scene),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: isDone
                                ? AppColors.success.withValues(alpha: 0.15)
                                : AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            isDone
                                ? Icons.check_circle
                                : Icons.play_circle_outline,
                            color: isDone
                                ? AppColors.success
                                : AppColors.primary,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                scene.title,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: isDone
                                      ? AppColors.textSecondary
                                      : AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                scene.subtitle,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isDone)
                          const Icon(
                            Icons.check_circle,
                            color: AppColors.success,
                            size: 22,
                          )
                        else
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: AppColors.textSecondary,
                            size: 16,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/learning_plan_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/adaptive_content.dart';
import '../learning_plan/learning_plan_screen.dart';

class DiagnosticScreen extends StatefulWidget {
  const DiagnosticScreen({super.key});

  @override
  State<DiagnosticScreen> createState() => _DiagnosticScreenState();
}

class _DiagnosticScreenState extends State<DiagnosticScreen> {
  String? _goal;
  String? _level;
  int _minutes = 5;

  static const _goals = [
    ('travel', '旅行生活', '点餐、问路、购物，马上用得上'),
    ('daily', '日常聊天', '听懂朋友说话，敢于自然回应'),
    ('work', '工作交流', '自我介绍、开会和职场沟通'),
  ];
  static const _levels = [
    ('beginner', '完全不会', '只会几句普通话式粤语'),
    ('listener', '听得懂一点', '见过常用词，但还不敢讲'),
    ('speaker', '会讲几句', '想讲得更顺、更像香港人'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('3 分钟定位你的路线')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: AdaptiveContent(
            maxWidth: 640,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  '唔使由头学晒，先学你最想用的。',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                const Text(
                  '回答三个问题，我会帮你排一条 7 天开口路线。每天只练最有用的几句。',
                  style: TextStyle(color: AppColors.textSecondary, height: 1.5),
                ),
                const SizedBox(height: 28),
                _buildQuestion(
                  title: '你最想先解决什么？',
                  children: _goals
                      .map(
                        (item) => _ChoiceTile(
                          title: item.$2,
                          subtitle: item.$3,
                          selected: _goal == item.$1,
                          onTap: () => setState(() => _goal = item.$1),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 24),
                _buildQuestion(
                  title: '你现在的粤语状态？',
                  children: _levels
                      .map(
                        (item) => _ChoiceTile(
                          title: item.$2,
                          subtitle: item.$3,
                          selected: _level == item.$1,
                          onTap: () => setState(() => _level = item.$1),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 24),
                _buildQuestion(
                  title: '每天可以练多久？',
                  children: [
                    Wrap(
                      spacing: 10,
                      children: [5, 10, 15]
                          .map(
                            (minutes) => ChoiceChip(
                              label: Text('$minutes 分钟'),
                              selected: _minutes == minutes,
                              onSelected: (_) =>
                                  setState(() => _minutes = minutes),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _goal == null || _level == null ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(54),
                  ),
                  child: const Text('生成我的 7 天开口计划'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuestion({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        ...children,
      ],
    );
  }

  Future<void> _submit() async {
    final goal = _goals.firstWhere((item) => item.$1 == _goal);
    final level = _levels.firstWhere((item) => item.$1 == _level);
    await context.read<LearningPlanService>().createPlan(
      goalKey: goal.$1,
      goalLabel: goal.$2,
      levelKey: level.$1,
      levelLabel: level.$2,
      minutesPerDay: _minutes,
    );
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const LearningPlanScreen(showStartButton: false),
      ),
    );
  }
}

class _ChoiceTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _ChoiceTile({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primary.withValues(alpha: 0.1)
                : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? AppColors.primary : Colors.black12,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_off,
                color: selected ? AppColors.primary : AppColors.textSecondary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

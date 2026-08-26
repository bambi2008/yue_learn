import 'package:flutter/material.dart';
import '../../services/purchase_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/adaptive_content.dart';

class PaywallScreen extends StatelessWidget {
  final PurchaseService purchaseService;

  const PaywallScreen({super.key, required this.purchaseService});

  @override
  Widget build(BuildContext context) {
    final isTrialExpired = purchaseService.state == PurchaseState.expired;

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: AdaptiveContent(
            maxWidth: 600,
            child: Column(
              children: [
                const SizedBox(height: 40),

                // Header
                const Text('🇭🇰', style: TextStyle(fontSize: 56)),
                const SizedBox(height: 16),
                const Text(
                  '粤讲粤易',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '最高效的港式粤语学习工具',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),

                const SizedBox(height: 40),

                // Value props
                _ValueProp(
                  icon: '⚡',
                  title: '7天应急开口，30天日常聊天',
                  subtitle: '最短时间实现粤语基本交流',
                ),
                _ValueProp(
                  icon: '🤖',
                  title: 'AI 教练「阿明」24小时陪练',
                  subtitle: '像跟香港朋友聊天一样自然学习',
                ),
                _ValueProp(
                  icon: '🎯',
                  title: '音素级发音纠错',
                  subtitle: '精确到每个声母、韵母、声调的反馈',
                ),
                _ValueProp(
                  icon: '🧠',
                  title: '智能学习路径',
                  subtitle: 'AI诊断你的薄弱点，只练不会的',
                ),

                const SizedBox(height: 32),

                // Pricing card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        '终身买断',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '¥68',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          '含 3 天免费试用',
                          style: TextStyle(
                            color: AppColors.success,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 12),
                      ..._features.map(
                        (f) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: AppColors.success,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  f,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // CTA
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: isTrialExpired
                        ? null
                        : () => _startTrial(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      isTrialExpired ? '试用已结束' : '免费试用 3 天',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                if (isTrialExpired) ...[
                  const SizedBox(height: 8),
                  const Text(
                    '试用期已结束，正式购买功能尚未接入。',
                    style: TextStyle(fontSize: 12, color: Colors.white54),
                  ),
                ],
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () => _purchase(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white38),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      '购买 ¥68',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // 对比文案
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(fontSize: 12, color: Colors.white54),
                    children: const [
                      TextSpan(text: 'YumCha 一年 ¥145 | 我们是 ¥68 永久\n'),
                      TextSpan(text: '一杯咖啡的价格，掌握一门语言'),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    // 恢复购买
                    purchaseService.restorePurchase();
                  },
                  child: const Text(
                    '恢复购买',
                    style: TextStyle(color: Colors.white38),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _startTrial(BuildContext context) async {
    await purchaseService.startTrial();
  }

  Future<void> _purchase(BuildContext context) async {
    final result = await purchaseService.purchase();
    if (!context.mounted || result == PurchaseResult.completed) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('正式支付尚未接入，请先使用免费试用。')));
  }

  static const _features = [
    '全部 12 个场景课程',
    'AI 智能学习路径',
    'AI 教练「阿明」无限陪练',
    'Azure 音素级发音评分',
    '智能 SRS 间隔复习',
    '声调雷达图 + 进步趋势',
    '永久有效，无需续费',
  ];
}

class _ValueProp extends StatelessWidget {
  final String icon, title, subtitle;

  const _ValueProp({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 13, color: Colors.white54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

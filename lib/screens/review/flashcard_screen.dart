import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/srs_provider.dart';
import '../../providers/user_provider.dart';
import '../../models/review_card.dart';
import '../../widgets/flashcard.dart';
import '../../theme/app_colors.dart';

class FlashcardScreen extends StatelessWidget {
  const FlashcardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SRSProvider>(
      builder: (context, srsProvider, _) {
        final card = srsProvider.nextDueCard;

        if (card == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('复习')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('🎊',
                      style: TextStyle(fontSize: 64)),
                  const SizedBox(height: 16),
                  const Text('今日复习已完成！',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  const Text('明天再来吧',
                      style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary)),
                  const SizedBox(height: 24),
                  Text('已掌握 ${srsProvider.totalCards} 个词汇',
                      style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary)),
                ],
              ),
            ),
          );
        }

        return _ReviewPage(card: card);
      },
    );
  }
}

class _ReviewPage extends StatefulWidget {
  final ReviewCard card;

  const _ReviewPage({required this.card});

  @override
  State<_ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<_ReviewPage> {
  bool _showRating = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '复习 (${context.watch<SRSProvider>().dueCount} 张)'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          // Progress indicator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: context.watch<SRSProvider>().totalCards > 0
                    ? 1 -
                        context.watch<SRSProvider>().dueCount /
                            context.watch<SRSProvider>().totalCards
                    : 0,
                minHeight: 4,
                backgroundColor:
                    AppColors.primary.withValues(alpha: 0.1),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text('点击卡片翻转查看答案',
              style: const TextStyle(
                  fontSize: 12, color: AppColors.textSecondary)),
          const SizedBox(height: 24),

          // Flashcard
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: FlashcardWidget(
                card: widget.card,
                showBack: _showRating,
              ),
            ),
          ),

          // Rating buttons
          if (!_showRating)
            Padding(
              padding: const EdgeInsets.all(24),
              child: ElevatedButton.icon(
                onPressed: () => _flipCard(),
                icon: const Icon(Icons.flip),
                label: const Text('翻转看答案'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                ),
              ),
            ),

          if (_showRating) _buildRatingButtons(),
        ],
      ),
    );
  }

  void _flipCard() {
    setState(() => _showRating = true);
  }

  Widget _buildRatingButtons() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: Column(
        children: [
          const Text('你记得如何？',
              style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Row(
            children: [
              _RatingButton(
                label: '重来',
                color: AppColors.srsAgain,
                onTap: () => _rate(0),
              ),
              _RatingButton(
                label: '困难',
                color: AppColors.srsHard,
                onTap: () => _rate(1),
              ),
              _RatingButton(
                label: '良好',
                color: AppColors.srsGood,
                onTap: () => _rate(2),
              ),
              _RatingButton(
                label: '简单',
                color: AppColors.srsEasy,
                onTap: () => _rate(3),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _rate(int quality) {
    final srsProvider = context.read<SRSProvider>();
    final userProvider = context.read<UserProvider>();

    srsProvider.rateCard(widget.card.id, quality);
    userProvider.incrementTodayReviewed();

    setState(() => _showRating = false);
  }
}

class _RatingButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _RatingButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(label,
              style: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}

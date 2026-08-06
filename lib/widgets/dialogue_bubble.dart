import 'package:flutter/material.dart';
import '../models/course.dart';
import '../theme/app_colors.dart';
import 'audio_button.dart';

class DialogueBubble extends StatelessWidget {
  final Sentence sentence;
  final bool isLeft; // 对方（左）还是用户角色（右）
  final bool showDetail;
  final VoidCallback onTap;
  final VoidCallback? onPractice;

  const DialogueBubble({
    super.key,
    required this.sentence,
    this.isLeft = true,
    this.showDetail = false,
    required this.onTap,
    this.onPractice,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: isLeft
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (isLeft) ...[_buildAvatar(isLeft), const SizedBox(width: 8)],
          Flexible(
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isLeft ? Colors.white : AppColors.primary,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: isLeft
                        ? const Radius.circular(4)
                        : const Radius.circular(16),
                    bottomRight: isLeft
                        ? const Radius.circular(16)
                        : const Radius.circular(4),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (sentence.speaker.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          sentence.speaker,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isLeft ? AppColors.primary : Colors.white70,
                          ),
                        ),
                      ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            sentence.cantonese,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: isLeft
                                  ? AppColors.textPrimary
                                  : Colors.white,
                            ),
                          ),
                        ),
                        if (sentence.audioPath.isNotEmpty)
                          AudioButton(
                            audioPath: sentence.audioPath,
                            size: 34,
                            color: isLeft ? AppColors.primary : Colors.white,
                          ),
                      ],
                    ),
                    if (showDetail) ...[
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isLeft
                              ? AppColors.warmSurface
                              : Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              sentence.jyutping,
                              style: TextStyle(
                                fontSize: 14,
                                color: isLeft
                                    ? AppColors.jyutping
                                    : Colors.white.withValues(alpha: 0.9),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              sentence.mandarin,
                              style: TextStyle(
                                fontSize: 14,
                                color: isLeft
                                    ? AppColors.textSecondary
                                    : Colors.white.withValues(alpha: 0.8),
                              ),
                            ),
                            if (sentence.wordBreakdown.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              const Divider(height: 1),
                              const SizedBox(height: 8),
                              ...sentence.wordBreakdown.map(
                                (w) => Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 60,
                                        child: Text(
                                          w.cantonese,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 80,
                                        child: Text(
                                          w.jyutping,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors.jyutping,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          w.mandarin,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                    if (onPractice != null) ...[
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: onPractice,
                          icon: const Icon(Icons.mic_none, size: 16),
                          label: const Text('跟读评分'),
                          style: TextButton.styleFrom(
                            foregroundColor: isLeft
                                ? AppColors.primary
                                : Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          if (!isLeft) ...[const SizedBox(width: 8), _buildAvatar(isLeft)],
        ],
      ),
    );
  }

  Widget _buildAvatar(bool left) {
    return CircleAvatar(
      radius: 16,
      backgroundColor: left
          ? AppColors.jyutping.withValues(alpha: 0.2)
          : AppColors.primary.withValues(alpha: 0.2),
      child: Icon(
        left ? Icons.person : Icons.face,
        size: 16,
        color: left ? AppColors.jyutping : AppColors.primary,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/speech_provider.dart';
import '../../providers/user_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/adaptive_content.dart';

class PronunciationScreen extends StatefulWidget {
  final String cantonese;
  final String jyutping;
  final String mandarin;

  const PronunciationScreen({
    super.key,
    required this.cantonese,
    required this.jyutping,
    required this.mandarin,
  });

  @override
  State<PronunciationScreen> createState() => _PronunciationScreenState();
}

class _PronunciationScreenState extends State<PronunciationScreen> {
  @override
  void dispose() {
    context.read<SpeechProvider>().reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('跟读练习')),
      body: Consumer<SpeechProvider>(
        builder: (context, speech, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: AdaptiveContent(
              maxWidth: 600,
              child: Column(
                children: [
                  const SizedBox(height: 16),

                  // 参考句子
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.08),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          '🎯 请跟读以下句子',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.cantonese,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.jyutping,
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.jyutping,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.mandarin,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // 录音按钮 / 评分结果
                  if (speech.state == SpeechState.idle ||
                      speech.state == SpeechState.recording)
                    _buildRecordButton(speech)
                  else if (speech.state == SpeechState.assessing)
                    _buildAssessingIndicator()
                  else if (speech.state == SpeechState.done)
                    _buildResult(speech),

                  // 错误信息
                  if (speech.errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        speech.errorMessage,
                        style: const TextStyle(
                          color: AppColors.error,
                          fontSize: 13,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecordButton(SpeechProvider speech) {
    final isRecording = speech.state == SpeechState.recording;

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (isRecording) {
              speech.stopAndAssess(context.read<UserProvider>());
            } else {
              speech.startRecording(widget.cantonese);
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: isRecording ? AppColors.error : AppColors.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (isRecording ? AppColors.error : AppColors.primary)
                      .withValues(alpha: 0.3),
                  blurRadius: 20,
                  spreadRadius: isRecording ? 8 : 2,
                ),
              ],
            ),
            child: Icon(
              isRecording ? Icons.stop : Icons.mic,
              color: Colors.white,
              size: 36,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          isRecording ? '点击停止' : '点击录音',
          style: TextStyle(
            fontSize: 13,
            color: isRecording ? AppColors.error : AppColors.textSecondary,
          ),
        ),
        if (isRecording) ...[
          const SizedBox(height: 8),
          const Text(
            '🔴 录音中... 最长 30 秒',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
        ],
      ],
    );
  }

  Widget _buildAssessingIndicator() {
    return const Column(
      children: [
        SizedBox(height: 24),
        SizedBox(
          width: 40,
          height: 40,
          child: CircularProgressIndicator(strokeWidth: 3),
        ),
        SizedBox(height: 16),
        Text(
          '正在评估发音...',
          style: TextStyle(fontSize: 15, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildResult(SpeechProvider speech) {
    final result = speech.lastResult!;

    return Column(
      children: [
        // 总分环
        _ScoreRing(score: result.overallScore),
        const SizedBox(height: 8),
        Text(
          _scoreLabel(result.overallScore),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: _scoreColor(result.overallScore),
          ),
        ),
        const SizedBox(height: 24),

        // 三维评分
        Row(
          children: [
            _ScoreChip(label: '准确度', score: result.accuracyScore),
            _ScoreChip(label: '流利度', score: result.fluencyScore),
            _ScoreChip(label: '完整度', score: result.completenessScore),
          ],
        ),
        const SizedBox(height: 24),

        // 逐词评分 (如果有)
        if (result.words.isNotEmpty) ...[
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '逐词评分',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: result.words.map((w) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: w.isCorrect
                      ? AppColors.success.withValues(alpha: 0.1)
                      : AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: w.isCorrect ? AppColors.success : AppColors.error,
                    width: 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      w.word,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: w.isCorrect
                            ? AppColors.success
                            : AppColors.error,
                      ),
                    ),
                    Text(
                      '${w.accuracyScore.round()}分',
                      style: const TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],

        const SizedBox(height: 24),

        // 按钮
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            OutlinedButton.icon(
              onPressed: () {
                speech.reset();
                speech.startRecording(widget.cantonese);
              },
              icon: const Icon(Icons.replay, size: 18),
              label: const Text('再试一次'),
            ),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.check, size: 18),
              label: const Text('完成'),
            ),
          ],
        ),
      ],
    );
  }

  String _scoreLabel(double score) {
    if (score >= 85) return '👍 发音标准！';
    if (score >= 70) return '👌 还不错，继续练习';
    if (score >= 50) return '📖 需要多加练习';
    if (score > 0) return '🔰 继续加油！';
    return '需要配置 Azure 才能评分';
  }

  Color _scoreColor(double score) {
    if (score >= 85) return AppColors.success;
    if (score >= 70) return AppColors.jyutping;
    if (score >= 50) return AppColors.warning;
    return AppColors.error;
  }
}

class _ScoreRing extends StatelessWidget {
  final double score;

  const _ScoreRing({required this.score});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: 1.0,
            strokeWidth: 10,
            color: AppColors.primary.withValues(alpha: 0.1),
          ),
          CircularProgressIndicator(
            value: score / 100,
            strokeWidth: 10,
            color: _color,
            strokeCap: StrokeCap.round,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                score > 0 ? '${score.round()}' : '--',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  color: _color,
                ),
              ),
              const Text(
                '分',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color get _color {
    if (score >= 85) return AppColors.success;
    if (score >= 70) return AppColors.jyutping;
    if (score >= 50) return AppColors.warning;
    return AppColors.error;
  }
}

class _ScoreChip extends StatelessWidget {
  final String label;
  final double score;

  const _ScoreChip({required this.label, required this.score});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Column(
            children: [
              Text(
                score > 0 ? '${score.round()}' : '--',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

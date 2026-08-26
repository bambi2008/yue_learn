import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/course.dart';
import '../../providers/user_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/adaptive_content.dart';
import '../../widgets/audio_button.dart';
import '../pronunciation/pronunciation_screen.dart';

/// The shortest path from opening the app to saying something useful.
/// It deliberately teaches three lines instead of dropping a new learner into
/// the full catalogue.
class QuickStartScreen extends StatefulWidget {
  final Scene scene;

  const QuickStartScreen({super.key, required this.scene});

  @override
  State<QuickStartScreen> createState() => _QuickStartScreenState();
}

class _QuickStartScreenState extends State<QuickStartScreen> {
  late final List<Sentence> _sentences;
  int _index = 0;
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    _sentences = widget.scene.dialogues
        .expand((dialogue) => dialogue.sentences)
        .take(3)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_finished) return _buildFinished(context);

    final sentence = _sentences[_index];
    return Scaffold(
      appBar: AppBar(title: const Text('今天先开口')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: AdaptiveContent(
            maxWidth: 640,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildProgress(),
                const SizedBox(height: 20),
                Text(
                  _index == 0 ? '先学最有用的一句' : '继续，已经开口 $_index 句',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  '先听两次，再跟读一次。今天不追求学完，只追求敢讲。',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 20),
                _buildSentenceCard(sentence),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => _practice(context, sentence),
                  icon: const Icon(Icons.mic_none_rounded),
                  label: const Text('跟读这句，听听自己讲得点样'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                  ),
                ),
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: _next,
                  child: Text(
                    _index == _sentences.length - 1 ? '我会了，完成今日开口' : '我会了，下一句',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgress() {
    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: (_index + 1) / _sentences.length,
              minHeight: 8,
              backgroundColor: AppColors.primary.withValues(alpha: 0.12),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          '${_index + 1}/${_sentences.length}',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }

  Widget _buildSentenceCard(Sentence sentence) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.14)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            sentence.speaker.isEmpty ? '实用粤语' : sentence.speaker,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            sentence.cantonese,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          Text(
            sentence.jyutping,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: AppColors.jyutping),
          ),
          const SizedBox(height: 6),
          Text(
            sentence.mandarin,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 18),
          AudioButton(
            audioPath: sentence.audioPath,
            text: sentence.cantonese,
            size: 52,
          ),
          const SizedBox(height: 8),
          const Text(
            '点喇叭听粤语发音',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Future<void> _practice(BuildContext context, Sentence sentence) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PronunciationScreen(
          cantonese: sentence.cantonese,
          jyutping: sentence.jyutping,
          mandarin: sentence.mandarin,
        ),
      ),
    );
  }

  void _next() {
    if (_index == _sentences.length - 1) {
      context.read<UserProvider>().recordPracticeSession();
      setState(() => _finished = true);
      return;
    }
    setState(() => _index++);
  }

  Widget _buildFinished(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('今日开口')),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: AdaptiveContent(
              maxWidth: 520,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🎉', style: TextStyle(fontSize: 64)),
                  const SizedBox(height: 16),
                  const Text(
                    '今日开口完成！',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '你已经会讲「${_sentences.last.cantonese}」\n明日再加三句，就会越来越顺。',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('回到首页'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

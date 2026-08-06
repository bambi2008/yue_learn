import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/course.dart';
import '../../providers/user_provider.dart';
import '../../providers/srs_provider.dart';
import '../../widgets/dialogue_bubble.dart';
import '../../theme/app_colors.dart';
import '../review/flashcard_screen.dart';
import '../pronunciation/pronunciation_screen.dart';

class DialogueScreen extends StatefulWidget {
  final Scene scene;

  const DialogueScreen({super.key, required this.scene});

  @override
  State<DialogueScreen> createState() => _DialogueScreenState();
}

class _DialogueScreenState extends State<DialogueScreen> {
  int _currentDialogue = 0;
  int? _expandedSentence;
  bool _allDone = false;

  List<Dialogue> get _dialogues => widget.scene.dialogues;

  @override
  Widget build(BuildContext context) {
    final dialogue = _dialogues[_currentDialogue];
    final isLastDialogue = _currentDialogue == _dialogues.length - 1;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.scene.title),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _expandedSentence = _expandedSentence == -1 ? null : -1;
              });
            },
            child: Text(
              _expandedSentence == -1 ? '收起' : '展开全部',
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Dialogue tabs
          if (_dialogues.length > 1)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: List.generate(_dialogues.length, (i) {
                  final isActive = i == _currentDialogue;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() {
                        _currentDialogue = i;
                        _expandedSentence = null;
                      }),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.primary
                              : AppColors.warmSurface,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          dialogue.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isActive
                                ? Colors.white
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

          // Dialogue content
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: dialogue.sentences.length,
              itemBuilder: (context, index) {
                final sentence = dialogue.sentences[index];
                final isEven = index % 2 == 0;
                final isExpanded = _expandedSentence == index;

                return DialogueBubble(
                  sentence: sentence,
                  isLeft: isEven,
                  showDetail: isExpanded || _expandedSentence == -1,
                  onPractice: () => _openPronunciation(context, sentence),
                  onTap: () {
                    setState(() {
                      _expandedSentence = _expandedSentence == index
                          ? null
                          : index;
                    });
                  },
                );
              },
            ),
          ),

          // Bottom bar
          SafeArea(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  if (_currentDialogue > 0)
                    OutlinedButton.icon(
                      onPressed: () => setState(() {
                        _currentDialogue--;
                        _expandedSentence = null;
                      }),
                      icon: const Icon(Icons.arrow_back, size: 18),
                      label: const Text('上一段'),
                    ),
                  const Spacer(),
                  if (!isLastDialogue || !_allDone)
                    ElevatedButton.icon(
                      onPressed: () {
                        if (isLastDialogue) {
                          _completeScene(context);
                        } else {
                          setState(() {
                            _currentDialogue++;
                            _expandedSentence = null;
                          });
                        }
                      },
                      icon: Icon(
                        isLastDialogue ? Icons.check : Icons.arrow_forward,
                        size: 18,
                      ),
                      label: Text(isLastDialogue ? '完成课程' : '下一段'),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openPronunciation(BuildContext context, Sentence sentence) {
    Navigator.push(
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

  void _completeScene(BuildContext context) {
    setState(() => _allDone = true);

    final userProvider = context.read<UserProvider>();
    final srsProvider = context.read<SRSProvider>();
    final alreadyCompleted =
        userProvider.completedScenes[widget.scene.id] == true;

    if (!alreadyCompleted) {
      // 标记场景完成
      userProvider.completeScene(widget.scene.id);

      // 生词加入 SRS
      for (final v in widget.scene.vocabulary) {
        srsProvider.addCard(
          vocabId: v.id,
          cantonese: v.cantonese,
          jyutping: v.jyutping,
          mandarin: v.mandarin,
          audioPath: v.audioPath,
          exampleCantonese: v.exampleCantonese,
          exampleMandarin: v.exampleMandarin,
        );
      }

      // 更新已学词汇数
      userProvider.addWordsLearned(widget.scene.vocabulary.length);
    }

    // 显示完成弹窗
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Text('🎉', style: TextStyle(fontSize: 32)),
            SizedBox(width: 8),
            Text('课程完成！'),
          ],
        ),
        content: Text(
          alreadyCompleted
              ? '这个场景已经完成，复习队列没有重复添加。'
              : '已学会 ${widget.scene.vocabulary.length} 个生词\n已加入复习队列',
          style: const TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop(); // 返回场景列表
            },
            child: const Text('返回课程'),
          ),
          ElevatedButton(
            onPressed: () {
              final navigator = Navigator.of(context);
              Navigator.of(ctx).pop();
              navigator.pop();
              navigator.push(
                MaterialPageRoute(builder: (_) => const FlashcardScreen()),
              );
            },
            child: const Text('开始复习'),
          ),
        ],
      ),
    );
  }
}

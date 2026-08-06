import 'package:flutter/material.dart';
import '../../services/ai_coach_service.dart';
import '../../theme/app_colors.dart';

class CoachScreen extends StatefulWidget {
  const CoachScreen({super.key});

  @override
  State<CoachScreen> createState() => _CoachScreenState();
}

class _CoachScreenState extends State<CoachScreen> {
  final AICoachService _coach = AICoachService();
  final TextEditingController _textCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();
  final List<CoachMessage> _messages = [];
  bool _isLoading = false;
  String _scene = '茶餐厅点餐';

  static const _scenes = ['茶餐厅点餐', '港铁问路', '商场买衫', '自我介绍', '开会讨论', '自由倾偈'];

  @override
  void initState() {
    super.initState();
    _messages.add(
      CoachMessage(
        role: 'ming',
        text:
            '嗨！我係阿明，你嘅粵語朋友～\n'
            '你想練咩場景呀？揀一個，或者隨便傾都得㗎！ 😄',
      ),
    );
  }

  @override
  void dispose() {
    _textCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🤖 阿明教练'),
        actions: [
          if (_messages.length > 2)
            TextButton(
              onPressed: _reviewSession,
              child: const Text('复盘', style: TextStyle(fontSize: 13)),
            ),
        ],
      ),
      body: Column(
        children: [
          // 场景选择
          _buildSceneChips(),
          const Divider(height: 1),

          // 对话列表
          Expanded(
            child: ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length) {
                  return _buildTypingIndicator();
                }
                return _buildMessage(_messages[index]);
              },
            ),
          ),

          // 输入栏
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildSceneChips() {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _scenes.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final s = _scenes[i];
          final isSelected = s == _scene;
          return GestureDetector(
            onTap: () => setState(() => _scene = s),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.warmSurface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                s,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMessage(CoachMessage msg) {
    final isMing = msg.role == 'ming';

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isMing
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        children: [
          if (isMing)
            const CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primary,
              child: Text(
                '明',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isMing ? Colors.white : AppColors.primary,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: isMing
                      ? const Radius.circular(4)
                      : const Radius.circular(16),
                  bottomRight: isMing
                      ? const Radius.circular(16)
                      : const Radius.circular(4),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    msg.text,
                    style: TextStyle(
                      fontSize: 15,
                      color: isMing ? AppColors.textPrimary : Colors.white,
                    ),
                  ),
                  if (msg.correction != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isMing
                            ? AppColors.warning.withValues(alpha: 0.15)
                            : Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Text('💡 ', style: TextStyle(fontSize: 13)),
                          Expanded(
                            child: Text(
                              msg.correction!,
                              style: TextStyle(
                                fontSize: 13,
                                color: isMing
                                    ? AppColors.textPrimary
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (!isMing) const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return const Padding(
      padding: EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.primary,
            child: Text(
              '明',
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
          ),
          SizedBox(width: 12),
          Text(
            '阿明正在打字...',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
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
            Expanded(
              child: TextField(
                controller: _textCtrl,
                decoration: InputDecoration(
                  hintText: '输入你想练习的粤语...',
                  hintStyle: const TextStyle(fontSize: 14),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: AppColors.warmSurface,
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _sendMessage,
              child: Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() async {
    final text = _textCtrl.text.trim();
    if (text.isEmpty || _isLoading) return;

    setState(() {
      _messages.add(CoachMessage(role: 'user', text: text));
      _isLoading = true;
    });
    _textCtrl.clear();
    _scrollToBottom();

    // 当前输入已经加入消息列表；服务层会把 userInput 作为最新一轮追加，
    // 因此历史记录要排除最后这条，避免同一句发送两次。
    final history = _messages
        .take(_messages.length - 1)
        .map((m) => {'role': m.role, 'text': m.text})
        .toList();

    final reply = await _coach.chat(
      scene: _scene,
      level: 'beginner',
      history: history,
      userInput: text,
    );

    if (!mounted) return;
    setState(() {
      _messages.add(reply);
      _isLoading = false;
    });
    _scrollToBottom();
  }

  void _reviewSession() async {
    if (_messages.length < 4) return;

    final history = _messages
        .map((m) => {'role': m.role, 'text': m.text})
        .toList();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) =>
          const Center(child: CircularProgressIndicator(color: Colors.white)),
    );

    final review = await _coach.reviewSession(history: history);

    if (!mounted) return;
    Navigator.of(context).pop(); // dismiss loading

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Text(
              '${review.overallScore}',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: review.overallScore >= 80
                    ? AppColors.success
                    : review.overallScore >= 60
                    ? AppColors.jyutping
                    : AppColors.warning,
              ),
            ),
            const Text(
              ' 分',
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (review.highlights.isNotEmpty) ...[
                const Text(
                  '👍 做得好',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                ...review.highlights.map(
                  (h) => Padding(
                    padding: const EdgeInsets.only(top: 4, left: 8),
                    child: Text('• $h', style: const TextStyle(fontSize: 13)),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              if (review.improvements.isNotEmpty) ...[
                const Text(
                  '📖 要改进',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                ...review.improvements.map(
                  (i) => Padding(
                    padding: const EdgeInsets.only(top: 4, left: 8),
                    child: Text('• $i', style: const TextStyle(fontSize: 13)),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              if (review.suggestedExercises.isNotEmpty) ...[
                const Text(
                  '🎯 推荐练习',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                ...review.suggestedExercises.map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(top: 4, left: 8),
                    child: Text('• $e', style: const TextStyle(fontSize: 13)),
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('知道了'),
          ),
        ],
      ),
    );
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}

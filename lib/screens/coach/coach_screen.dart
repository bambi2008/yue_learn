import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/ai_coach_service.dart';
import '../../services/role_play_service.dart';
import '../../data/role_play_scenarios.dart';
import '../../models/role_play.dart';
import '../../providers/speech_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/adaptive_content.dart';
import '../../widgets/audio_button.dart';

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
  final RolePlayService _rolePlay = RolePlayService();
  bool _isLoading = false;
  bool _isVoiceRecording = false;
  bool _isVoiceProcessing = false;
  late RolePlayScenario _scenario;
  int _turnIndex = 0;

  @override
  void initState() {
    super.initState();
    _scenario = rolePlayScenarios.first;
    _messages.add(
      CoachMessage(
        role: 'ming',
        text: '${_scenario.opening}\n\n${_scenario.turns.first.prompt}',
      ),
    );
  }

  @override
  void dispose() {
    _textCtrl.dispose();
    _scrollCtrl.dispose();
    _coach.dispose();
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
          _buildRolePlayBanner(),

          // 对话列表
          Expanded(
            child: ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length) {
                  return AdaptiveContent(
                    maxWidth: 760,
                    child: _buildTypingIndicator(),
                  );
                }
                return AdaptiveContent(
                  maxWidth: 760,
                  child: _buildMessage(_messages[index]),
                );
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
        itemCount: rolePlayScenarios.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final scenario = rolePlayScenarios[i];
          final isSelected = scenario.id == _scenario.id;
          return GestureDetector(
            onTap: () => _selectScenario(scenario),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.warmSurface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${scenario.icon} ${scenario.title}',
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

  Widget _buildRolePlayBanner() {
    final turn = _scenario.turns[_turnIndex];
    final configured = _coach.isConfigured;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      color: AppColors.warmSurface,
      child: Row(
        children: [
          const Icon(Icons.route_rounded, size: 18, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '第 ${_turnIndex + 1}/${_scenario.turns.length} 步 · ${_scenario.description}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  configured ? '在线 AI 已接通，阿明会按情境追问' : '离线角色扮演已开启，先练最常用回应',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      setState(() => _textCtrl.text = turn.exampleAnswer),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 24),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    '示范：${turn.exampleAnswer}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _selectScenario(RolePlayScenario scenario) {
    setState(() {
      _scenario = scenario;
      _turnIndex = 0;
      _messages
        ..clear()
        ..add(
          CoachMessage(
            role: 'ming',
            text: '${scenario.opening}\n\n${scenario.turns.first.prompt}',
          ),
        );
    });
    _scrollToBottom();
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
                  if (isMing) ...[
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: AudioButton(
                        audioPath: 'coach',
                        text: msg.text,
                        size: 32,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
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
    final speech = Provider.of<SpeechProvider?>(context);
    return SafeArea(
      child: AdaptiveContent(
        maxWidth: 760,
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
                onTap: speech == null || _isVoiceProcessing
                    ? null
                    : () => _toggleVoiceInput(speech),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: _isVoiceRecording
                        ? AppColors.error
                        : AppColors.warmSurface,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isVoiceProcessing
                        ? Icons.hourglass_top_rounded
                        : _isVoiceRecording
                        ? Icons.stop_rounded
                        : Icons.mic_none_rounded,
                    color: _isVoiceRecording ? Colors.white : AppColors.primary,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _isLoading ? null : _sendMessage,
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
      ),
    );
  }

  Future<void> _toggleVoiceInput(SpeechProvider speech) async {
    if (_isVoiceRecording) {
      setState(() {
        _isVoiceRecording = false;
        _isVoiceProcessing = true;
      });
      final text = await speech.stopAndTranscribe();
      if (!mounted) return;
      setState(() => _isVoiceProcessing = false);
      if (text == null || text.trim().isEmpty) {
        final message = speech.errorMessage.isEmpty
            ? '没有听清，请再讲一次'
            : speech.errorMessage;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
        return;
      }
      _textCtrl.text = text;
      _sendMessage();
      return;
    }

    setState(() => _isVoiceRecording = true);
    await speech.startRecording('');
    if (!mounted) return;
    if (speech.state != SpeechState.recording) {
      setState(() => _isVoiceRecording = false);
      if (speech.errorMessage.isNotEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(speech.errorMessage)));
      }
    }
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

    final turn = _scenario.turns[_turnIndex];
    final reply = _coach.isConfigured
        ? await _coach.chat(
            scene: _scenario.title,
            level: 'beginner',
            history: history,
            userInput: text,
            rolePlayInstruction:
                '当前第 ${_turnIndex + 1} 步。学习者要完成：${turn.prompt}。示范句：${turn.exampleAnswer}。请保持简短，回应后继续推进情境。',
          )
        : _offlineReply(text);

    if (!mounted) return;
    setState(() {
      _messages.add(reply);
      _isLoading = false;
      if (_coach.isConfigured && _turnIndex < _scenario.turns.length - 1) {
        _turnIndex++;
      }
    });
    _scrollToBottom();
  }

  CoachMessage _offlineReply(String text) {
    final result = _rolePlay.respond(
      scenario: _scenario,
      turnIndex: _turnIndex,
      input: text,
    );
    if (result.accepted) {
      _turnIndex = result.nextTurn;
    }
    return CoachMessage(role: 'ming', text: result.reply);
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

import 'dart:convert';
import 'package:http/http.dart' as http;

/// AI 诊断结果
class DiagnosticResult {
  final int tonePerception; // 声调感知分 (0-100)
  final int vocabularyLevel; // 词汇基础 (0-100)
  final String learningGoal; // "work" / "study" / "life"
  final List<String> weakTones; // 弱项声调 e.g. ["4", "6"]
  final String summary; // 一句话总结

  DiagnosticResult({
    required this.tonePerception,
    required this.vocabularyLevel,
    required this.learningGoal,
    required this.weakTones,
    required this.summary,
  });
}

/// AI 陪练消息
class CoachMessage {
  final String role; // "ming" | "user"
  final String text;
  final String? correction; // 纠错提示（仅阿明的消息）

  CoachMessage({required this.role, required this.text, this.correction});
}

/// AI 对话复盘
class SessionReview {
  final int overallScore;
  final List<String> highlights; // 做得好的
  final List<String> improvements; // 要改进的
  final List<String> suggestedExercises; // 推荐练习

  SessionReview({
    required this.overallScore,
    required this.highlights,
    required this.improvements,
    required this.suggestedExercises,
  });
}

/// AI 教练服务 — 诊断 + 陪练 + 复盘
class AICoachService {
  static const String _apiKey = 'YOUR_CLAUDE_API_KEY';
  static const String _baseUrl = 'https://api.anthropic.com/v1/messages';
  static const String _modelFast = 'claude-haiku-4-5-20251001';
  static const String _modelSmart = 'claude-sonnet-5-20251001';

  bool get isConfigured =>
      _apiKey.isNotEmpty && _apiKey != 'YOUR_CLAUDE_API_KEY';

  // ==========================================
  // ① 初始诊断
  // ==========================================

  /// 根据用户的声调测试结果和背景信息，AI 分析学习路径
  Future<DiagnosticResult> diagnose({
    required int toneTestScore, // 声调分辨测试得分 (0-10)
    required int vocabTestScore, // 词汇摸底得分 (0-10)
    required String goal, // "work" / "study" / "life"
  }) async {
    if (!isConfigured) {
      return DiagnosticResult(
        tonePerception: toneTestScore * 10,
        vocabularyLevel: vocabTestScore * 10,
        learningGoal: goal,
        weakTones: toneTestScore < 5 ? ['4', '5', '6'] : [],
        summary: '请配置 Claude API Key 以获得个性化诊断',
      );
    }

    final prompt = '''
你是一位粤语教学专家。根据以下测试结果，分析这位普通话母语者的粤语学习路径：

声调分辨测试：$toneTestScore/10 分
词汇摸底：$vocabTestScore/10 分
学习目标：$goal

请返回 JSON：
{
  "tonePerception": 0-100,
  "vocabularyLevel": 0-100,
  "weakTones": ["最弱的声调编号"],
  "summary": "用一句温暖鼓励的话总结，繁体中文"
}

只返回 JSON，不要其他文字。''';

    try {
      final result = await _callClaude(prompt, model: _modelFast);
      final json = jsonDecode(_extractJson(result)) as Map<String, dynamic>;
      return DiagnosticResult(
        tonePerception: (json['tonePerception'] as num).toInt(),
        vocabularyLevel: (json['vocabularyLevel'] as num).toInt(),
        learningGoal: goal,
        weakTones: (json['weakTones'] as List)
            .map((e) => e.toString())
            .toList(),
        summary: json['summary'] as String,
      );
    } catch (_) {
      return DiagnosticResult(
        tonePerception: toneTestScore * 10,
        vocabularyLevel: vocabTestScore * 10,
        learningGoal: goal,
        weakTones: ['4', '6'],
        summary: '你嘅粤语旅程啱啱开始，慢慢嚟，唔使急！',
      );
    }
  }

  // ==========================================
  // ② 场景陪练 — 阿明对话
  // ==========================================

  static const String _mingPersona = '''
你係「阿明」，一個30歲嘅香港本地朋友。你嘅任務係陪普通話母語者練習港式粵語。

角色設定：
- 性格：友善、幽默、有耐心，鍾意用港式俚語
- 說話風格：自然口語化粵語，間中加啲英文單字（例如「OK」、「deadline」）
- 教學方式：對方講錯會溫柔糾正，會鼓勵，會分享香港文化小知識

對話規則：
1. 每次回覆先正常對話，然後如果對方有錯就附加【糾正：xxx】
2. 對話要自然推進，唔好變問答機器
3. 用粵語口語書寫（例如「嘅」、「咗」、「緊」）
4. 每 3-4 輪對話後，可以分享一個相關嘅香港文化小貼士

場景：{scene}
難度：{level}
''';

  /// 生成阿明的下一句回复
  Future<CoachMessage> chat({
    required String scene, // e.g. "茶餐厅点餐"
    required String level, // "beginner" | "intermediate"
    required List<Map<String, String>> history, // [{role, text}]
    required String userInput, // 用户说的话（粤语或普通话）
  }) async {
    if (!isConfigured) {
      return CoachMessage(
        role: 'ming',
        text: '哎呀，我而家未連到線⋯⋯不如你試下跟住課程讀先？',
      );
    }

    final messages = <Map<String, dynamic>>[
      {
        'role': 'user',
        'content': _mingPersona
            .replaceAll('{scene}', scene)
            .replaceAll('{level}', level),
      },
    ];

    // 添加历史对话
    for (final h in history) {
      messages.add({
        'role': h['role'] == 'ming' ? 'assistant' : 'user',
        'content': h['text']!,
      });
    }

    // 添加用户最新输入
    messages.add({
      'role': 'user',
      'content': '對方說：' + userInput,
    });

    try {
      final response = await _callClaudeMessages(
        system: _mingPersona
            .replaceAll('{scene}', scene)
            .replaceAll('{level}', level),
        messages: messages,
        model: _modelFast,
      );

      // 解析纠错部分
      String text = response;
      String? correction;
      if (response.contains('【糾正：') || response.contains('【纠正：')) {
        final parts = response.split(RegExp(r'【糾正：|【纠正：'));
        text = parts[0].trim();
        correction = parts[1].replaceAll('】', '').trim();
      }

      return CoachMessage(role: 'ming', text: text, correction: correction);
    } catch (_) {
      return CoachMessage(
        role: 'ming',
        text: '講得好！繼續努力呀～ 💪',
      );
    }
  }

  // ==========================================
  // ③ 对话复盘
  // ==========================================

  Future<SessionReview> reviewSession({
    required List<Map<String, String>> history,
  }) async {
    if (!isConfigured || history.length < 2) {
      return SessionReview(
        overallScore: 70,
        highlights: ['敢於開口講粵語！'],
        improvements: ['多練習聲調'],
        suggestedExercises: ['第4聲和第6聲對比練習'],
      );
    }

    final transcript =
        history.map((h) => '${h['role']}: ${h['text']}').join('\n');

    final prompt = '''
分析以下粵語對話練習，給出學習者表現評估：

對話記錄：
$transcript

請返回 JSON：
{
  "overallScore": 0-100,
  "highlights": ["做得好的方面"],
  "improvements": ["需要改進的方面"],
  "suggestedExercises": ["推薦的針對性練習"]
}

繁體中文，友善鼓勵的語氣。只返回 JSON。''';

    try {
      final result = await _callClaude(prompt, model: _modelSmart);
      final json = jsonDecode(_extractJson(result)) as Map<String, dynamic>;
      return SessionReview(
        overallScore: (json['overallScore'] as num).toInt(),
        highlights: (json['highlights'] as List)
            .map((e) => e.toString())
            .toList(),
        improvements: (json['improvements'] as List)
            .map((e) => e.toString())
            .toList(),
        suggestedExercises: (json['suggestedExercises'] as List)
            .map((e) => e.toString())
            .toList(),
      );
    } catch (_) {
      return SessionReview(
        overallScore: 70,
        highlights: ['完成了對話練習'],
        improvements: ['繼續練習'],
        suggestedExercises: ['每日跟讀練習'],
      );
    }
  }

  // ==========================================
  // 底层 API 调用
  // ==========================================

  Future<String> _callClaude(String prompt, {String? model}) async {
    return _callClaudeMessages(
      system: '你是一位粤语教学专家。始终用繁体中文回复。只返回要求的JSON，不要其他文字。',
      messages: [
        {'role': 'user', 'content': prompt},
      ],
      model: model ?? _modelFast,
    );
  }

  Future<String> _callClaudeMessages({
    required String system,
    required List<Map<String, dynamic>> messages,
    String? model,
  }) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'x-api-key': _apiKey,
        'anthropic-version': '2023-06-01',
        'content-type': 'application/json',
      },
      body: jsonEncode({
        'model': model ?? _modelFast,
        'max_tokens': 1024,
        'system': system,
        'messages': messages,
      }),
    ).timeout(const Duration(seconds: 20));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final content = data['content'] as List;
      return content
          .whereType<Map<String, dynamic>>()
          .map((c) => c['text'] as String)
          .join('');
    } else {
      throw Exception('Claude API error: ${response.statusCode}');
    }
  }

  String _extractJson(String text) {
    // 尝试提取 {...} 部分
    final match = RegExp(r'\{[\s\S]*\}').firstMatch(text);
    return match?.group(0) ?? '{}';
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;

/// AI 诊断结果
class DiagnosticResult {
  final int tonePerception;
  final int vocabularyLevel;
  final String learningGoal;
  final List<String> weakTones;
  final String summary;

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
  final String? correction;

  CoachMessage({required this.role, required this.text, this.correction});
}

/// AI 对话复盘
class SessionReview {
  final int overallScore;
  final List<String> highlights;
  final List<String> improvements;
  final List<String> suggestedExercises;

  SessionReview({
    required this.overallScore,
    required this.highlights,
    required this.improvements,
    required this.suggestedExercises,
  });
}

/// AI 教练服务 — 基于通义千问 Qwen
/// 粤语能力强、国内直连、¥2-4/M tokens
class AICoachService {
  // 阿里云 DashScope API Key (从 https://dashscope.console.aliyun.com 获取)
  static const String _apiKey = String.fromEnvironment('QWEN_API_KEY');
  static const String _baseUrl =
      'https://dashscope.aliyuncs.com/compatible-mode/v1/chat/completions';

  // qwen-plus: ¥2/M 输入 ¥4/M 输出，日常对话够用
  // qwen-max: 复杂推理用，复盘/诊断时切换
  static const String _modelFast = 'qwen-plus';
  static const String _modelSmart = 'qwen-max';

  bool get isConfigured => _apiKey.isNotEmpty;

  // ==========================================
  // ① 初始诊断
  // ==========================================

  Future<DiagnosticResult> diagnose({
    required int toneTestScore,
    required int vocabTestScore,
    required String goal,
  }) async {
    if (!isConfigured) {
      return DiagnosticResult(
        tonePerception: toneTestScore * 10,
        vocabularyLevel: vocabTestScore * 10,
        learningGoal: goal,
        weakTones: toneTestScore < 5 ? ['4', '5', '6'] : [],
        summary: '请配置通义千问 API Key 以获得个性化诊断',
      );
    }

    final prompt =
        '''
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
      final result = await _call(prompt, model: _modelFast);
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
難度：{level}''';

  Future<CoachMessage> chat({
    required String scene,
    required String level,
    required List<Map<String, String>> history,
    required String userInput,
  }) async {
    if (!isConfigured) {
      return CoachMessage(role: 'ming', text: '哎呀，我而家未連到線⋯⋯不如你試下跟住課程讀先？');
    }

    final systemPrompt = _mingPersona
        .replaceAll('{scene}', scene)
        .replaceAll('{level}', level);

    final messages = <Map<String, String>>[];

    // 历史对话
    for (final h in history) {
      messages.add({
        'role': h['role'] == 'ming' ? 'assistant' : 'user',
        'content': h['text']!,
      });
    }

    // 用户最新输入
    messages.add({'role': 'user', 'content': '對方說：$userInput'});

    try {
      final response = await _callMessages(
        system: systemPrompt,
        messages: messages,
        model: _modelFast,
      );

      String text = response;
      String? correction;
      if (response.contains('【糾正：') || response.contains('【纠正：')) {
        final parts = response.split(RegExp(r'【糾正：|【纠正：'));
        text = parts[0].trim();
        correction = parts[1].replaceAll('】', '').trim();
      }

      return CoachMessage(role: 'ming', text: text, correction: correction);
    } catch (_) {
      return CoachMessage(role: 'ming', text: '講得好！繼續努力呀～ 💪');
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

    final transcript = history
        .map((h) => '${h['role']}: ${h['text']}')
        .join('\n');

    final prompt =
        '''
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
      final result = await _call(prompt, model: _modelSmart);
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
  // 底层 API 调用 — 通义千问 (OpenAI 兼容)
  // ==========================================

  /// 简单 prompt 调用
  Future<String> _call(String prompt, {String? model}) async {
    return _callMessages(
      system: '你是一位粤语教学专家。始终用繁体中文回复。只返回要求的JSON，不要其他文字。',
      messages: [
        {'role': 'user', 'content': prompt},
      ],
      model: model ?? _modelFast,
    );
  }

  /// 多轮对话调用 (OpenAI 兼容格式)
  Future<String> _callMessages({
    required String system,
    required List<Map<String, String>> messages,
    String? model,
  }) async {
    final body = {
      'model': model ?? _modelFast,
      'messages': [
        {'role': 'system', 'content': system},
        ...messages,
      ],
      'max_tokens': 1024,
      'temperature': 0.7,
    };

    final response = await http
        .post(
          Uri.parse(_baseUrl),
          headers: {
            'Authorization': 'Bearer $_apiKey',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 20));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final choices = data['choices'] as List;
      return choices.first['message']['content'] as String;
    } else {
      throw Exception(
        'Qwen API error ${response.statusCode}: ${response.body}',
      );
    }
  }

  String _extractJson(String text) {
    final match = RegExp(r'\{[\s\S]*\}').firstMatch(text);
    return match?.group(0) ?? '{}';
  }
}

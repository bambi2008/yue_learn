import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import '../utils/recording_file.dart';

/// Azure 发音评估结果
class PronunciationResult {
  final double accuracyScore;
  final double fluencyScore;
  final double completenessScore;
  final double overallScore;
  final String recognizedText;
  final List<WordResult> words;

  PronunciationResult({
    required this.accuracyScore,
    required this.fluencyScore,
    required this.completenessScore,
    required this.overallScore,
    this.recognizedText = '',
    required this.words,
  });

  factory PronunciationResult.fromJson(Map<String, dynamic> json) {
    final nBest = json['NBest'] as List?;
    final firstBest = nBest != null && nBest.isNotEmpty
        ? nBest.first as Map<String, dynamic>
        : null;
    final words = <WordResult>[];

    if (firstBest != null) {
      final wordList = firstBest['Words'] as List? ?? [];
      for (final w in wordList) {
        words.add(WordResult.fromJson(w as Map<String, dynamic>));
      }
    }

    return PronunciationResult(
      accuracyScore: (json['AccuracyScore'] as num?)?.toDouble() ?? 0.0,
      fluencyScore: (json['FluencyScore'] as num?)?.toDouble() ?? 0.0,
      completenessScore: (json['CompletenessScore'] as num?)?.toDouble() ?? 0.0,
      overallScore: (json['PronScore'] as num?)?.toDouble() ?? 0.0,
      recognizedText:
          (json['Display'] ??
                  json['NBest']?[0]?['Display'] ??
                  json['NBest']?[0]?['Lexical'] ??
                  '')
              .toString(),
      words: words,
    );
  }

  /// 简化版（仅文本对比，离线模式）
  factory PronunciationResult.simple(String expected, String actual) {
    // 简单编辑距离对比
    final score = _calculateSimpleScore(expected, actual);
    return PronunciationResult(
      accuracyScore: score,
      fluencyScore: score,
      completenessScore: actual.isNotEmpty ? 100 : 0,
      overallScore: score,
      recognizedText: actual,
      words: [],
    );
  }

  static double _calculateSimpleScore(String expected, String actual) {
    if (expected.isEmpty) return 0;
    if (actual.isEmpty) return 0;

    // 使用 Jaccard 相似度
    final expectedChars = expected.replaceAll(' ', '').split('');
    final actualChars = actual.replaceAll(' ', '').split('');

    final set1 = expectedChars.toSet();
    final set2 = actualChars.toSet();

    final intersection = set1.intersection(set2).length;
    final union = set1.union(set2).length;

    if (union == 0) return 0;
    return (intersection / union) * 100;
  }
}

/// 逐词评分
class WordResult {
  final String word;
  final double accuracyScore;
  final String errorType; // 'None', 'Mispronunciation', etc.

  WordResult({
    required this.word,
    required this.accuracyScore,
    this.errorType = 'None',
  });

  bool get isCorrect => errorType == 'None' && accuracyScore >= 80;

  factory WordResult.fromJson(Map<String, dynamic> json) {
    return WordResult(
      word: json['Word'] as String? ?? '',
      accuracyScore:
          (json['PronunciationAssessment']?['AccuracyScore'] as num?)
              ?.toDouble() ??
          0.0,
      errorType:
          json['PronunciationAssessment']?['ErrorType'] as String? ?? 'None',
    );
  }
}

/// Azure Speech Service 封装
class AzureSpeechService {
  final http.Client _client;
  final bool _ownsClient;
  final String _key;
  final String _region;
  final String _proxyUrl;

  AzureSpeechService({
    http.Client? client,
    String? key,
    String? region,
    String? proxyUrl,
  }) : _client = client ?? http.Client(),
       _ownsClient = client == null,
       _key = key ?? AppConstants.azureSpeechKey,
       _region = region ?? AppConstants.azureSpeechRegion,
       _proxyUrl = proxyUrl ?? AppConstants.azureSpeechProxyUrl;

  bool get usesProxy => _proxyUrl.isNotEmpty;

  /// 检查是否已配置 Azure Key
  bool get isConfigured => usesProxy || (!kReleaseMode && _key.isNotEmpty);

  void dispose() {
    if (_ownsClient) {
      _client.close();
    }
  }

  /// 使用 Azure Pronunciation Assessment 评分
  /// [audioFilePath] - 录音文件路径 (.wav, PCM 16kHz 16bit mono)
  /// [referenceText] - 标准粤语文本（用于对比评分）
  Future<PronunciationResult> assessPronunciation({
    required String audioFilePath,
    required String referenceText,
  }) async {
    if (!isConfigured) {
      return _fallbackAssessment(audioFilePath, referenceText);
    }

    try {
      final audioBytes = await readRecordingBytes(audioFilePath);

      // Azure Speech-to-Text REST API with Pronunciation Assessment
      final url = usesProxy
          ? _proxyUrl
          : 'https://$_region.stt.speech.microsoft.com/speech/recognition/conversation/cognitiveservices/v1?'
                'language=zh-HK'
                '&format=Detailed'
                '&profanity=raw';

      final headers = <String, String>{
        'Content-Type': 'audio/wav; codecs=audio/pcm; samplerate=16000',
        'Pronunciation-Assessment': jsonEncode({
          'ReferenceText': referenceText,
          'GradingSystem': 'HundredMark',
          'Granularity': 'Word',
          'EnableMiscue': 'true',
        }),
      };
      if (!usesProxy) {
        headers['Ocp-Apim-Subscription-Key'] = _key;
      }

      final response = await _client
          .post(Uri.parse(url), headers: headers, body: audioBytes)
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return PronunciationResult.fromJson(json);
      } else {
        return _fallbackAssessment(audioFilePath, referenceText);
      }
    } catch (e) {
      // Azure 不可用时使用离线备选
      return _fallbackAssessment(audioFilePath, referenceText);
    }
  }

  /// 使用同一个 Azure/代理链路获取粤语识别文本，供阿明语音输入使用。
  /// 代理仍接收标准 Pronunciation-Assessment 请求头，只是参考文本为空。
  Future<String?> transcribeRecording({required String audioFilePath}) async {
    if (!isConfigured) return null;

    final result = await assessPronunciation(
      audioFilePath: audioFilePath,
      referenceText: '',
    );
    final text = result.recognizedText.trim();
    return text.isEmpty ? null : text;
  }

  /// 离线备选：仅对比文本
  Future<PronunciationResult> _fallbackAssessment(
    String audioFilePath,
    String referenceText,
  ) async {
    // 离线模式下无法获取录音文本，返回提示分数
    return PronunciationResult(
      accuracyScore: 0,
      fluencyScore: 0,
      completenessScore: 0,
      overallScore: 0,
      words: [],
    );
  }
}

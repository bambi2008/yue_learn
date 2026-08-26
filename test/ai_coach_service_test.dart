import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'package:yue_learn/services/ai_coach_service.dart';

class _RecordingClient extends http.BaseClient {
  Uri? requestedUri;
  Map<String, String>? requestedHeaders;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    requestedUri = request.url;
    requestedHeaders = request.headers;

    final payload = jsonEncode({
      'choices': [
        {
          'message': {'content': '你好，继续练习呀！'},
        },
      ],
    });

    return http.StreamedResponse(
      Stream.value(utf8.encode(payload)),
      200,
      request: request,
      headers: {'content-type': 'application/json'},
    );
  }
}

void main() {
  test(
    'uses the configured proxy without exposing an Authorization header',
    () async {
      final client = _RecordingClient();
      final service = AICoachService(
        client: client,
        apiKey: 'should-not-be-used',
        proxyUrl: 'https://proxy.example.com/v1/chat/completions',
      );

      expect(service.isConfigured, isTrue);
      expect(service.usesProxy, isTrue);

      final reply = await service.chat(
        scene: '茶餐厅点餐',
        level: 'beginner',
        history: const [],
        userInput: '唔該，我要一個A餐。',
      );

      expect(reply.text, '你好，继续练习呀！');
      expect(
        client.requestedUri.toString(),
        'https://proxy.example.com/v1/chat/completions',
      );
      expect(client.requestedHeaders!.containsKey('authorization'), isFalse);

      service.dispose();
    },
  );

  test('keeps direct API mode available for local development', () async {
    final client = _RecordingClient();
    final service = AICoachService(client: client, apiKey: 'local-dev-key');

    expect(service.isConfigured, isTrue);
    expect(service.usesProxy, isFalse);

    await service.chat(
      scene: '茶餐厅点餐',
      level: 'beginner',
      history: const [],
      userInput: '唔該',
    );

    expect(client.requestedUri.toString(), contains('dashscope.aliyuncs.com'));
    expect(client.requestedHeaders!['authorization'], 'Bearer local-dev-key');

    service.dispose();
  });
}

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'package:yue_learn/services/azure_speech_service.dart';

class _RecordingClient extends http.BaseClient {
  Uri? requestedUri;
  Map<String, String>? requestedHeaders;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    requestedUri = request.url;
    requestedHeaders = request.headers;

    return http.StreamedResponse(
      Stream.value(<int>[]),
      200,
      request: request,
      headers: {'content-type': 'application/json'},
    );
  }
}

class _AudioRecordingClient extends http.BaseClient {
  Uri? requestedUri;
  Map<String, String>? requestedHeaders;
  List<int>? requestedBody;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    requestedUri = request.url;
    requestedHeaders = request.headers;
    requestedBody = await request.finalize().fold<List<int>>(
      <int>[],
      (bytes, chunk) => bytes..addAll(chunk),
    );
    return http.StreamedResponse(
      Stream.value(<int>[1, 2, 3, 4]),
      200,
      request: request,
      headers: {'content-type': 'audio/mpeg'},
    );
  }
}

void main() {
  test(
    'uses the speech proxy without sending the Azure subscription key',
    () async {
      final client = _RecordingClient();
      final service = AzureSpeechService(
        client: client,
        key: 'should-not-be-used',
        proxyUrl: 'https://proxy.example.com/ai/pronunciation',
      );
      final directory = await Directory.systemTemp.createTemp(
        'yue_learn_azure_',
      );
      final audioFile = File('${directory.path}/sample.wav');
      await audioFile.writeAsBytes(<int>[1, 2, 3]);

      try {
        expect(service.isConfigured, isTrue);
        expect(service.usesProxy, isTrue);

        await service.assessPronunciation(
          audioFilePath: audioFile.path,
          referenceText: '唔該「熱奶茶」',
        );

        expect(
          client.requestedUri.toString(),
          'https://proxy.example.com/ai/pronunciation',
        );
        expect(
          client.requestedHeaders!.containsKey('ocp-apim-subscription-key'),
          isFalse,
        );
        expect(
          client.requestedHeaders!['pronunciation-assessment'],
          contains('唔該'),
        );
      } finally {
        service.dispose();
        await directory.delete(recursive: true);
      }
    },
  );

  test('keeps direct Azure mode available for local development', () async {
    final client = _RecordingClient();
    final service = AzureSpeechService(
      client: client,
      key: 'local-dev-key',
      region: 'eastasia',
    );
    final directory = await Directory.systemTemp.createTemp('yue_learn_azure_');
    final audioFile = File('${directory.path}/sample.wav');
    await audioFile.writeAsBytes(<int>[1, 2, 3]);

    try {
      expect(service.isConfigured, isTrue);
      expect(service.usesProxy, isFalse);

      await service.assessPronunciation(
        audioFilePath: audioFile.path,
        referenceText: '唔該',
      );

      expect(client.requestedUri.toString(), contains('eastasia.stt.speech'));
      expect(
        client.requestedHeaders!['ocp-apim-subscription-key'],
        'local-dev-key',
      );
    } finally {
      service.dispose();
      await directory.delete(recursive: true);
    }
  });

  test('synthesizes Cantonese speech through the TTS proxy', () async {
    final client = _AudioRecordingClient();
    final service = AzureSpeechService(
      client: client,
      key: 'should-not-be-used',
      ttsProxyUrl: 'https://proxy.example.com/ai/tts',
    );

    try {
      expect(service.isTtsConfigured, isTrue);
      expect(service.usesTtsProxy, isTrue);

      final audio = await service.synthesizeSpeech(text: '你好，阿明！');

      expect(audio, [1, 2, 3, 4]);
      expect(
        client.requestedUri.toString(),
        'https://proxy.example.com/ai/tts',
      );
      expect(
        client.requestedHeaders!.containsKey('ocp-apim-subscription-key'),
        isFalse,
      );
      final body = utf8.decode(client.requestedBody!);
      expect(body, contains('zh-HK-WanLungNeural'));
      expect(body, contains('你好，阿明！'));
    } finally {
      service.dispose();
    }
  });
}

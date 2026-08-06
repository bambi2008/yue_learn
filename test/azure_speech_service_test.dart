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
}

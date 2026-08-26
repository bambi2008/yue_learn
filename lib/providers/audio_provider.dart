import 'dart:async';
import 'dart:io';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import '../services/azure_speech_service.dart';

class AudioProvider extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();
  final FlutterTts _tts = FlutterTts();
  final AzureSpeechService _azureSpeech = AzureSpeechService();
  late final StreamSubscription<PlayerState> _playerStateSubscription;

  bool _isPlaying = false;
  double _speed = 1.0;
  String? _currentAudio;
  bool _speechAvailable = false;
  bool _usingSpeech = false;
  late final Future<void> _audioSessionReady;
  late final Future<void> _ttsReady;

  bool get isPlaying => _isPlaying;
  double get speed => _speed;
  String? get currentAudio => _currentAudio;

  AudioPlayer get player => _player;

  String get voiceLabel => _azureSpeech.isTtsConfigured
      ? 'Azure Neural 粤语语音'
      : 'iPhone 系统粤语语音（离线兜底）';

  AudioProvider() {
    _audioSessionReady = _configureAudioSession();
    _ttsReady = _configureSpeech();
    _playerStateSubscription = _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _isPlaying = false;
        notifyListeners();
      }
    });
  }

  Future<void> _configureSpeech() async {
    try {
      await _tts.setLanguage('zh-HK');
      await _tts.setSpeechRate(0.45);
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);
      await _tts.awaitSpeakCompletion(true);
      if (Platform.isIOS) {
        await _tts.setSharedInstance(true);
        await _tts.setIosAudioCategory(
          IosTextToSpeechAudioCategory.playback,
          [IosTextToSpeechAudioCategoryOptions.defaultToSpeaker],
          IosTextToSpeechAudioMode.spokenAudio,
        );
      }
      _speechAvailable = true;

      // Prefer the installed high-quality Hong Kong Cantonese voice (often
      // shown as “Fung” in iOS settings). Voice enumeration is best effort:
      // the base zh-HK setup is still valid when iOS delays this API.
      try {
        final voices = await _tts.getVoices;
        if (voices is List) {
          final candidates = voices
              .whereType<Map>()
              .map((voice) => Map<String, dynamic>.from(voice))
              .where((voice) {
                final locale = (voice['locale'] ?? '').toString().toLowerCase();
                return locale == 'zh-hk' || locale == 'zh_hk';
              })
              .toList();
          if (candidates.isNotEmpty) {
            candidates.sort((a, b) {
              final aFung = (a['name'] ?? '').toString().toLowerCase().contains(
                'fung',
              );
              final bFung = (b['name'] ?? '').toString().toLowerCase().contains(
                'fung',
              );
              final aQuality = (a['quality'] as num?)?.toInt() ?? 0;
              final bQuality = (b['quality'] as num?)?.toInt() ?? 0;
              if (aFung != bFung) return aFung ? -1 : 1;
              return bQuality.compareTo(aQuality);
            });
            final voice = candidates.first;
            await _tts.setVoice({
              'name': (voice['name'] ?? voice['identifier']).toString(),
              'locale': 'zh-HK',
            });
          }
        }
      } catch (error) {
        debugPrint('TTS voice enumeration unavailable: $error');
      }
    } catch (error) {
      debugPrint('Speech configuration error: $error');
    }
  }

  Future<void> _configureAudioSession() async {
    try {
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration.music());
    } catch (error) {
      debugPrint('Audio session configuration error: $error');
    }
  }

  /// The bundled files are WAV/PCM data with legacy `.mp3` names. Materialise
  /// them with a `.wav` extension so AVPlayer selects the correct decoder.
  Future<String> _materializeAsset(String assetPath) async {
    final base = await getTemporaryDirectory();
    final directory = Directory('${base.path}/yue_learn_audio');
    await directory.create(recursive: true);
    final safeName = assetPath
        .replaceAll('/', '_')
        .replaceFirst(RegExp(r'\.[^.]+$'), '.wav');
    final file = File('${directory.path}/$safeName');
    if (!await file.exists()) {
      final data = await rootBundle.load(assetPath);
      await file.writeAsBytes(data.buffer.asUint8List(), flush: true);
    }
    return file.path;
  }

  Future<String?> _materializeAzureSpeech(String text) async {
    if (!_azureSpeech.isTtsConfigured) return null;
    final bytes = await _azureSpeech.synthesizeSpeech(text: text);
    if (bytes == null || bytes.isEmpty) return null;

    final base = await getTemporaryDirectory();
    final directory = Directory('${base.path}/yue_learn_azure_tts');
    await directory.create(recursive: true);
    final key = text.codeUnits.fold<int>(17, (hash, code) {
      return (hash * 31 + code) & 0x7fffffff;
    });
    final file = File('${directory.path}/$key.mp3');
    if (!await file.exists() || await file.length() != bytes.length) {
      await file.writeAsBytes(bytes, flush: true);
    }
    return file.path;
  }

  /// 播放音频。在线时优先使用 Azure Neural 粤语语音，再回退到系统语音或课程音频。
  Future<void> play(String assetPath, {String? text}) async {
    final key = text == null ? assetPath : '$assetPath::$text';
    try {
      await _audioSessionReady;
      if (_currentAudio == key && _isPlaying) {
        if (_usingSpeech) {
          await _tts.stop();
        } else {
          await _player.pause();
        }
        _isPlaying = false;
        notifyListeners();
        return;
      }

      await _player.stop();
      await _tts.stop();
      _currentAudio = key;

      if (text != null && text.trim().isNotEmpty) {
        // 在线环境优先使用 Azure Neural Voice；失败时再回退系统语音。
        final azurePath = await _materializeAzureSpeech(text.trim());
        if (azurePath != null) {
          _usingSpeech = false;
          await _player.setFilePath(azurePath);
          await _player.setSpeed(_speed);
          _isPlaying = true;
          notifyListeners();
          await _player.play();
          return;
        }
        await _ttsReady;
      }
      if (text != null && text.trim().isNotEmpty && _speechAvailable) {
        _usingSpeech = true;
        _isPlaying = true;
        notifyListeners();
        try {
          await _tts.setSpeechRate(0.45 * _speed);
          await _tts.speak(text.trim());
        } finally {
          _isPlaying = false;
          notifyListeners();
        }
        return;
      }

      _usingSpeech = false;
      final filePath = await _materializeAsset(assetPath);
      await _player.setFilePath(filePath);
      await _player.setSpeed(_speed);
      _isPlaying = true;
      notifyListeners();
      await _player.play();
    } catch (error) {
      debugPrint('Audio playback error: $error');
      _isPlaying = false;
      notifyListeners();
    }
  }

  /// 停止播放
  Future<void> stop() async {
    await _tts.stop();
    await _player.stop();
    _usingSpeech = false;
    _isPlaying = false;
    notifyListeners();
  }

  /// 切换倍速
  Future<void> toggleSpeed() async {
    if (_speed >= 1.5) {
      _speed = 0.75;
    } else if (_speed >= 1.25) {
      _speed = 1.5;
    } else if (_speed >= 1.0) {
      _speed = 1.25;
    } else {
      _speed = 1.0;
    }

    if (_usingSpeech) {
      await _tts.setSpeechRate(0.45 * _speed);
    } else {
      await _player.setSpeed(_speed);
    }
    notifyListeners();
  }

  /// 设置倍速
  Future<void> setSpeed(double speed) async {
    _speed = speed;
    if (_usingSpeech) {
      await _tts.setSpeechRate(0.45 * _speed);
    } else {
      await _player.setSpeed(_speed);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _playerStateSubscription.cancel();
    _tts.stop();
    _player.dispose();
    _azureSpeech.dispose();
    super.dispose();
  }
}

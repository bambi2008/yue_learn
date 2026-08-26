import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';

class AudioProvider extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();
  final FlutterTts _tts = FlutterTts();
  late final StreamSubscription<PlayerState> _playerStateSubscription;

  bool _isPlaying = false;
  double _speed = 1.0;
  String? _currentAudio;
  bool _ttsReady = false;
  bool _usingTts = false;
  Future<void>? _ttsSetup;

  bool get isPlaying => _isPlaying;
  double get speed => _speed;
  String? get currentAudio => _currentAudio;

  AudioPlayer get player => _player;

  AudioProvider() {
    _ttsSetup = _configureTts();
    _playerStateSubscription = _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _isPlaying = false;
        notifyListeners();
      }
    });
  }

  Future<void> _configureTts() async {
    try {
      await _tts.setLanguage('zh-HK');
      await _tts.setSpeechRate(0.45);
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);
      await _tts.awaitSpeakCompletion(true);
      await _tts.setSharedInstance(true);
      await _tts.setIosAudioCategory(
        IosTextToSpeechAudioCategory.playback,
        [IosTextToSpeechAudioCategoryOptions.defaultToSpeaker],
        IosTextToSpeechAudioMode.spokenAudio,
      );
      // The base language setup is enough to speak. Voice enumeration is a
      // best-effort enhancement because some iOS versions expose it only
      // after the first TTS request.
      _ttsReady = true;

      // Prefer the installed high-quality Hong Kong Cantonese voice (often
      // shown as “Fung” in iOS settings). Never silently choose zh-CN.
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
      } catch (e) {
        debugPrint('TTS voice enumeration unavailable: $e');
      }
    } catch (e) {
      debugPrint('TTS setup error: $e');
    }
  }

  /// 播放音频
  Future<void> play(String assetPath, {String? text}) async {
    try {
      final key = text == null ? assetPath : '$assetPath::$text';
      if (_currentAudio == key && _isPlaying) {
        if (_usingTts) {
          await _tts.stop();
        } else {
          await _player.pause();
        }
        _isPlaying = false;
        notifyListeners();
        return;
      }

      await _tts.stop();
      await _player.stop();
      _currentAudio = key;

      // The bundled files are legacy placeholders. When text is available,
      // use the device's explicit zh-HK Cantonese voice instead.
      if (text != null && text.isNotEmpty) {
        await (_ttsSetup ?? Future<void>.value());
      }
      if (text != null && text.isNotEmpty && _ttsReady) {
        _usingTts = true;
        _isPlaying = true;
        notifyListeners();
        await _tts.setSpeechRate(0.45 * _speed);
        await _tts.speak(text);
      } else {
        _usingTts = false;
        await _player.setAsset(assetPath);
        await _player.setSpeed(_speed);
        await _player.play();
        _isPlaying = true;
        notifyListeners();
      }
      _isPlaying = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Audio playback error: $e');
      _isPlaying = false;
      notifyListeners();
    }
  }

  /// 停止播放
  Future<void> stop() async {
    await _tts.stop();
    await _player.stop();
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

    await _player.setSpeed(_speed);
    if (_usingTts && _isPlaying) {
      await _tts.setSpeechRate(0.45 * _speed);
    }
    notifyListeners();
  }

  /// 设置倍速
  Future<void> setSpeed(double speed) async {
    _speed = speed;
    await _player.setSpeed(_speed);
    notifyListeners();
  }

  @override
  void dispose() {
    _playerStateSubscription.cancel();
    _tts.stop();
    _player.dispose();
    super.dispose();
  }
}

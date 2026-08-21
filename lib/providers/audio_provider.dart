import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

class AudioProvider extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();
  late final StreamSubscription<PlayerState> _playerStateSubscription;
  final FlutterTts _tts = FlutterTts();

  bool _isPlaying = false;
  double _speed = 1.0;
  String? _currentAudio;
  late final Future<void> _audioSessionReady;
  late final Future<void> _ttsReady;
  bool _usingSpeech = false;

  bool get isPlaying => _isPlaying;
  double get speed => _speed;
  String? get currentAudio => _currentAudio;

  AudioPlayer get player => _player;

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
  /// them with a `.wav` extension so AVPlayer can select the correct decoder.
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

  /// 播放音频
  Future<void> play(String assetPath, {String? text}) async {
    try {
      await _audioSessionReady;
      if (_currentAudio == assetPath && _isPlaying) {
        if (_usingSpeech) {
          await _tts.stop();
        } else {
          await _player.pause();
        }
        _isPlaying = false;
        notifyListeners();
        return;
      }

      // The repository's bundled audio is currently silent placeholder data.
      // Use the device's Cantonese voice for real playback until recordings are
      // replaced with non-silent assets.
      if (text != null && text.trim().isNotEmpty) {
        await _ttsReady;
        await _player.stop();
        await _tts.stop();
        _usingSpeech = true;
        _currentAudio = assetPath;
        _isPlaying = true;
        notifyListeners();
        try {
          await _tts.speak(text.trim());
        } finally {
          _isPlaying = false;
          notifyListeners();
        }
        return;
      }

      _usingSpeech = false;
      if (_currentAudio != assetPath) {
        final filePath = await _materializeAsset(assetPath);
        await _player.setFilePath(filePath);
        _currentAudio = assetPath;
      }

      await _player.setSpeed(_speed);
      await _player.play();
      _isPlaying = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Audio playback error: $e');
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
    super.dispose();
  }
}

import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

class AudioProvider extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();

  bool _isPlaying = false;
  double _speed = 1.0;
  String? _currentAudio;

  bool get isPlaying => _isPlaying;
  double get speed => _speed;
  String? get currentAudio => _currentAudio;

  AudioPlayer get player => _player;

  /// 播放音频
  Future<void> play(String assetPath) async {
    try {
      if (_currentAudio == assetPath && _isPlaying) {
        await _player.pause();
        _isPlaying = false;
        notifyListeners();
        return;
      }

      if (_currentAudio != assetPath) {
        await _player.setAsset(assetPath);
        _currentAudio = assetPath;
      }

      await _player.setSpeed(_speed);
      await _player.play();
      _isPlaying = true;
      notifyListeners();

      _player.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          _isPlaying = false;
          notifyListeners();
        }
      });
    } catch (e) {
      debugPrint('Audio playback error: $e');
    }
  }

  /// 停止播放
  Future<void> stop() async {
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
    _player.dispose();
    super.dispose();
  }
}

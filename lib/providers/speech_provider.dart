import 'package:flutter/foundation.dart';
import 'package:record/record.dart';
import '../services/azure_speech_service.dart';
import '../utils/recording_file.dart';
import 'user_provider.dart';

enum SpeechState { idle, recording, assessing, done }

class SpeechProvider extends ChangeNotifier {
  final AzureSpeechService _service = AzureSpeechService();
  final AudioRecorder _recorder = AudioRecorder();

  SpeechState _state = SpeechState.idle;
  PronunciationResult? _lastResult;
  String _errorMessage = '';
  String _referenceText = '';

  SpeechState get state => _state;
  PronunciationResult? get lastResult => _lastResult;
  String get errorMessage => _errorMessage;
  String get referenceText => _referenceText;
  bool get isConfigured => _service.isConfigured;

  /// 开始录音
  Future<void> startRecording(String referenceText) async {
    _referenceText = referenceText;
    _lastResult = null;
    _errorMessage = '';

    try {
      if (kIsWeb) {
        _errorMessage = '网页端暂不支持本地录音评分，请使用移动端或桌面端';
        notifyListeners();
        return;
      }

      final hasPermission = await _recorder.hasPermission();
      if (!hasPermission) {
        _errorMessage = '没有麦克风权限';
        notifyListeners();
        return;
      }

      final filePath = await createRecordingPath();

      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.wav,
          numChannels: 1,
          sampleRate: 16000,
          bitRate: 256000,
        ),
        path: filePath,
      );

      _state = SpeechState.recording;
      notifyListeners();
    } catch (e) {
      _errorMessage = '录音启动失败: $e';
      notifyListeners();
    }
  }

  /// 停止录音并评估
  Future<void> stopAndAssess(UserProvider userProvider) async {
    try {
      final path = await _recorder.stop();
      if (path == null) {
        _errorMessage = '录音文件为空';
        _state = SpeechState.idle;
        notifyListeners();
        return;
      }

      _state = SpeechState.assessing;
      notifyListeners();

      // 发送到 Azure 评估
      final result = await _service.assessPronunciation(
        audioFilePath: path,
        referenceText: _referenceText,
      );

      _lastResult = result;
      _state = SpeechState.done;

      // 保存评分
      if (result.overallScore > 0) {
        userProvider.recordPronunciationScore(result.overallScore.round());
      }

      // 清理录音文件
      await deleteRecordingFile(path);

      notifyListeners();
    } catch (e) {
      _errorMessage = '评分失败: $e';
      _state = SpeechState.idle;
      notifyListeners();
    }
  }

  /// 重置状态
  void reset() {
    _state = SpeechState.idle;
    _lastResult = null;
    _errorMessage = '';
    notifyListeners();
  }

  @override
  void dispose() {
    _recorder.dispose();
    _service.dispose();
    super.dispose();
  }
}

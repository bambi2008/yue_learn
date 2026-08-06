/// App 常量
class AppConstants {
  AppConstants._();

  static const String appName = '粤讲粤易';
  static const String appVersion = '1.0.0';

  // Hive Box 名称
  static const String coursesBox = 'courses';
  static const String reviewCardsBox = 'review_cards';
  static const String userProgressBox = 'user_progress';
  static const String settingsBox = 'settings';

  // Azure Speech (需在 Azure Portal 创建后填入)
  static const String azureSpeechKey = String.fromEnvironment(
    'AZURE_SPEECH_KEY',
  );
  static const String azureSpeechRegion = String.fromEnvironment(
    'AZURE_SPEECH_REGION',
    defaultValue: 'eastasia',
  );
  static const String azureSpeechEndpoint = String.fromEnvironment(
    'AZURE_SPEECH_ENDPOINT',
    defaultValue: 'https://eastasia.api.cognitive.microsoft.com',
  );
  static const String azureTtsVoice = String.fromEnvironment(
    'AZURE_TTS_VOICE',
    defaultValue: 'zh-HK-HiuGaaiNeural',
  );

  // 录音配置
  static const int maxRecordSeconds = 30;
  static const int sampleRate = 16000;

  // SRS 默认值
  static const double defaultEasiness = 2.5;
  static const int defaultInterval = 1;

  // 声调定义
  static const List<Map<String, dynamic>> tones = [
    {'number': 1, 'name': '阴平', 'pitch': '55', 'label': '高平'},
    {'number': 2, 'name': '阴上', 'pitch': '35', 'label': '高升'},
    {'number': 3, 'name': '阴去', 'pitch': '33', 'label': '中平'},
    {'number': 4, 'name': '阳平', 'pitch': '21', 'label': '低降'},
    {'number': 5, 'name': '阳上', 'pitch': '13', 'label': '低升'},
    {'number': 6, 'name': '阳去', 'pitch': '22', 'label': '低平'},
  ];
}

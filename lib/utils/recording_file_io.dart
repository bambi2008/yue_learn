import 'dart:io';

Future<String> createRecordingPath() async {
  return '${Directory.systemTemp.path}/yue_pronounce_${DateTime.now().millisecondsSinceEpoch}.wav';
}

Future<void> deleteRecordingFile(String path) async {
  try {
    await File(path).delete();
  } catch (_) {
    // 临时录音文件清理失败不应影响评分结果展示。
  }
}

Future<List<int>> readRecordingBytes(String path) async {
  return File(path).readAsBytes();
}

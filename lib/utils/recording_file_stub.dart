Future<String> createRecordingPath() async {
  throw UnsupportedError('录音文件路径在当前平台不可用');
}

Future<void> deleteRecordingFile(String path) async {}

Future<List<int>> readRecordingBytes(String path) async {
  throw UnsupportedError('录音文件内容在当前平台不可用');
}

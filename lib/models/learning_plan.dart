import 'dart:convert';

class LearningPlan {
  final String goalKey;
  final String goalLabel;
  final String levelKey;
  final String levelLabel;
  final int minutesPerDay;
  final List<String> sceneIds;
  final List<String> dailyFocus;
  final DateTime createdAt;

  const LearningPlan({
    required this.goalKey,
    required this.goalLabel,
    required this.levelKey,
    required this.levelLabel,
    required this.minutesPerDay,
    required this.sceneIds,
    required this.dailyFocus,
    required this.createdAt,
  });

  int get todayIndex {
    final elapsed = DateTime.now().difference(createdAt).inDays;
    return elapsed.clamp(0, sceneIds.length - 1);
  }

  String get todaySceneId => sceneIds[todayIndex];
  String get todayFocus => dailyFocus[todayIndex];

  Map<String, dynamic> toJson() => {
    'goalKey': goalKey,
    'goalLabel': goalLabel,
    'levelKey': levelKey,
    'levelLabel': levelLabel,
    'minutesPerDay': minutesPerDay,
    'sceneIds': sceneIds,
    'dailyFocus': dailyFocus,
    'createdAt': createdAt.toIso8601String(),
  };

  String encode() => jsonEncode(toJson());

  factory LearningPlan.fromJson(Map<String, dynamic> json) {
    return LearningPlan(
      goalKey: json['goalKey'] as String,
      goalLabel: json['goalLabel'] as String,
      levelKey: json['levelKey'] as String,
      levelLabel: json['levelLabel'] as String,
      minutesPerDay: (json['minutesPerDay'] as num).toInt(),
      sceneIds: (json['sceneIds'] as List).cast<String>(),
      dailyFocus: (json['dailyFocus'] as List).cast<String>(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  factory LearningPlan.decode(String value) =>
      LearningPlan.fromJson(jsonDecode(value) as Map<String, dynamic>);
}

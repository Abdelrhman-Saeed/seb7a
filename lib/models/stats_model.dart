// models/stats_model.dart
// نموذج إحصائيات التسبيح

class DailyStats {
  final DateTime date;
  final int totalCount;
  final Map<String, int> dhikrCounts; // عدد كل ذكر

  DailyStats({
    required this.date,
    required this.totalCount,
    required this.dhikrCounts,
  });

  Map<String, dynamic> toMap() => {
    'date': date.toIso8601String(),
    'totalCount': totalCount,
    'dhikrCounts': dhikrCounts,
  };

  factory DailyStats.fromMap(Map<String, dynamic> map) => DailyStats(
    date: DateTime.parse(map['date']),
    totalCount: map['totalCount'],
    dhikrCounts: Map<String, int>.from(map['dhikrCounts'] ?? {}),
  );
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final String icon;
  final int requiredCount;
  bool isUnlocked;
  DateTime? unlockedAt;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.requiredCount,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'isUnlocked': isUnlocked,
    'unlockedAt': unlockedAt?.toIso8601String(),
  };
}

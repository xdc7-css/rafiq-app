import 'package:uuid/uuid.dart';

enum RewardType {
  prayer,
  surahRecitation,
  dua,
  charity,
  quranKhatmah,
  tasbeeh,
}

class Reward {
  final String id;
  final String memorialId;
  final String? userId;
  final RewardType type;
  final int count;
  final DateTime createdAt;
  final int points;
  final String? note;

  const Reward({
    required this.id,
    required this.memorialId,
    this.userId,
    required this.type,
    this.count = 1,
    required this.createdAt,
    this.points = 1,
    this.note,
  });

  factory Reward.create({
    required String memorialId,
    String? userId,
    required RewardType type,
    int count = 1,
    String? note,
  }) {
    return Reward(
      id: const Uuid().v4(),
      memorialId: memorialId,
      userId: userId,
      type: type,
      count: count,
      createdAt: DateTime.now(),
      points: _calculatePoints(type, count),
      note: note,
    );
  }

  static int _calculatePoints(RewardType type, int count) {
    switch (type) {
      case RewardType.prayer:
        return count * 10;
      case RewardType.surahRecitation:
        return count * 50;
      case RewardType.dua:
        return count * 15;
      case RewardType.charity:
        return count * 100;
      case RewardType.quranKhatmah:
        return count * 500;
      case RewardType.tasbeeh:
        return count * 10;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'memorialId': memorialId,
      'userId': userId,
      'type': type.name,
      'count': count,
      'createdAt': createdAt.toIso8601String(),
      'points': points,
      'note': note,
    };
  }

  factory Reward.fromJson(Map<String, dynamic> json) {
    return Reward(
      id: json['id'] as String,
      memorialId: json['memorialId'] as String,
      userId: json['userId'] as String?,
      type: RewardType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => RewardType.prayer,
      ),
      count: (json['count'] as num?)?.toInt() ?? 1,
      createdAt: DateTime.parse(json['createdAt'] as String),
      points: (json['points'] as num?)?.toInt() ?? 1,
      note: json['note'] as String?,
    );
  }

  Reward copyWith({
    String? id,
    String? memorialId,
    String? userId,
    RewardType? type,
    int? count,
    DateTime? createdAt,
    int? points,
    String? note,
  }) {
    return Reward(
      id: id ?? this.id,
      memorialId: memorialId ?? this.memorialId,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      count: count ?? this.count,
      createdAt: createdAt ?? this.createdAt,
      points: points ?? this.points,
      note: note ?? this.note,
    );
  }

  String get typeNameArabic {
    switch (type) {
      case RewardType.prayer:
        return 'صلاة';
      case RewardType.surahRecitation:
        return 'قراءة سورة';
      case RewardType.dua:
        return 'دعاء';
      case RewardType.charity:
        return 'صدقة';
      case RewardType.quranKhatmah:
        return 'ختمة القرآن';
      case RewardType.tasbeeh:
        return 'تسبيح';
    }
  }
}

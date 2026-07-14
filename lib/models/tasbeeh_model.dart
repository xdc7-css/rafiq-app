import 'package:uuid/uuid.dart';

class TasbeehModel {
  final String id;
  final String name;
  final String nameArabic;
  final int count;
  final int target;
  final DateTime lastUsed;

  TasbeehModel({
    String? id,
    required this.name,
    this.nameArabic = '',
    this.count = 0,
    this.target = 33,
    DateTime? lastUsed,
  })  : id = id ?? const Uuid().v4(),
        lastUsed = lastUsed ?? DateTime.now();

  int get remaining => target - count;

  double get progress => target > 0 ? count / target : 0;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nameArabic': nameArabic,
      'count': count,
      'target': target,
      'lastUsed': lastUsed.toIso8601String(),
    };
  }

  factory TasbeehModel.fromJson(Map<String, dynamic> json) {
    return TasbeehModel(
      id: json['id'],
      name: json['name'],
      nameArabic: json['nameArabic'] ?? '',
      count: json['count'] ?? 0,
      target: json['target'] ?? 33,
      lastUsed: json['lastUsed'] != null
          ? DateTime.parse(json['lastUsed'])
          : DateTime.now(),
    );
  }

  TasbeehModel copyWith({
    String? id,
    String? name,
    String? nameArabic,
    int? count,
    int? target,
    DateTime? lastUsed,
  }) {
    return TasbeehModel(
      id: id ?? this.id,
      name: name ?? this.name,
      nameArabic: nameArabic ?? this.nameArabic,
      count: count ?? this.count,
      target: target ?? this.target,
      lastUsed: lastUsed ?? this.lastUsed,
    );
  }
}

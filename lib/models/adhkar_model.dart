class AdhkarCategory {
  final String id;
  final String name;
  final String nameArabic;
  final String description;
  final List<AdhkarModel> adhkar;

  AdhkarCategory({
    required this.id,
    required this.name,
    this.nameArabic = '',
    this.description = '',
    List<AdhkarModel>? adhkar,
  }) : adhkar = adhkar ?? [];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nameArabic': nameArabic,
      'description': description,
      'adhkar': adhkar.map((a) => a.toJson()).toList(),
    };
  }

  factory AdhkarCategory.fromJson(Map<String, dynamic> json) {
    return AdhkarCategory(
      id: json['id'],
      name: json['name'],
      nameArabic: json['nameArabic'] ?? '',
      description: json['description'] ?? '',
      adhkar: (json['adhkar'] as List? ?? [])
          .map((a) => AdhkarModel.fromJson(a))
          .toList(),
    );
  }

  AdhkarCategory copyWith({
    String? id,
    String? name,
    String? nameArabic,
    String? description,
    List<AdhkarModel>? adhkar,
  }) {
    return AdhkarCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      nameArabic: nameArabic ?? this.nameArabic,
      description: description ?? this.description,
      adhkar: adhkar ?? this.adhkar,
    );
  }
}

class AdhkarModel {
  final String id;
  final String textArabic;
  final int targetCount;
  final int currentCount;
  final String? source;
  final bool isFavorite;

  AdhkarModel({
    required this.id,
    required this.textArabic,
    this.targetCount = 1,
    this.currentCount = 0,
    this.source,
    this.isFavorite = false,
  });

  factory AdhkarModel.fromJson(Map<String, dynamic> json) {
    return AdhkarModel(
      id: json['id'] ?? '',
      textArabic: json['text_arabic'] ?? json['textArabic'] ?? '',
      targetCount: json['target_count'] ?? json['targetCount'] ?? 1,
      currentCount: json['current_count'] ?? json['currentCount'] ?? 0,
      source: json['source'],
      isFavorite: json['is_favorite'] ?? json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text_arabic': textArabic,
      'target_count': targetCount,
      'current_count': currentCount,
      'source': source,
      'is_favorite': isFavorite,
    };
  }

  bool get isCompleted => currentCount >= targetCount;

  double get progress => targetCount > 0 ? currentCount / targetCount : 0.0;

  AdhkarModel copyWith({
    String? id,
    String? textArabic,
    int? targetCount,
    int? currentCount,
    String? source,
    bool? isFavorite,
  }) {
    return AdhkarModel(
      id: id ?? this.id,
      textArabic: textArabic ?? this.textArabic,
      targetCount: targetCount ?? this.targetCount,
      currentCount: currentCount ?? this.currentCount,
      source: source ?? this.source,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

class AdhkarCategoryModel {
  final String id;
  final String name;
  final String? icon;
  final String? description;
  final List<DhikrModel> adhkar;

  const AdhkarCategoryModel({
    required this.id,
    required this.name,
    this.icon,
    this.description,
    required this.adhkar,
  });

  factory AdhkarCategoryModel.fromJson(Map<String, dynamic> json) {
    return AdhkarCategoryModel(
      id: json['category']?.toString().replaceAll(' ', '_').toLowerCase() ??
          json['id']?.toString() ??
          '',
      name: json['category'] ?? json['name'] ?? '',
      icon: json['icon'],
      description: json['description'],
      adhkar: (json['adhkar'] as List<dynamic>? ?? [json])
          .map((e) => DhikrModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class DhikrModel {
  final int id;
  final String text;
  final String? textWithoutDiacritical;
  final String? description;
  final int count;
  final String? reference;
  final String? category;

  const DhikrModel({
    required this.id,
    required this.text,
    this.textWithoutDiacritical,
    this.description,
    required this.count,
    this.reference,
    this.category,
  });

  factory DhikrModel.fromJson(Map<String, dynamic> json) {
    return DhikrModel(
      id: json['id'] ?? 0,
      text: json['text'] ?? '',
      textWithoutDiacritical: json['text_without_diacritical'],
      description: json['description'] ?? json['fadl'],
      count: json['count'] ?? 1,
      reference: json['reference'] ?? json['dalil'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'textWithoutDiacritical': textWithoutDiacritical,
        'description': description,
        'count': count,
        'reference': reference,
        'category': category,
      };
}

class DuaModel {
  final int id;
  final String title;
  final String text;
  final String? source;
  final String? category;

  const DuaModel({
    required this.id,
    required this.title,
    required this.text,
    this.source,
    this.category,
  });

  factory DuaModel.fromJson(Map<String, dynamic> json) {
    return DuaModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? json['name'] ?? '',
      text: json['text'] ?? json['dua'] ?? '',
      source: json['source'] ?? json['reference'],
      category: json['category'],
    );
  }
}

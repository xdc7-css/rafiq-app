class HadithModel {
  final int id;
  final String textArabic;
  final String source;
  final String narrator;
  final int bookNumber;
  final int hadithNumber;
  final String grade;
  final String category;
  final String categoryId;
  final String _ref;

  HadithModel({
    required this.id,
    required this.textArabic,
    this.source = '',
    this.narrator = '',
    this.bookNumber = 0,
    this.hadithNumber = 0,
    this.grade = '',
    this.category = '',
    this.categoryId = '',
    String reference = '',
  }) : _ref = reference;

  factory HadithModel.fromJson(Map<String, dynamic> json) {
    return HadithModel(
      id: json['id'] ?? 0,
      textArabic: json['text'] ?? json['text_arabic'] ?? '',
      source: json['source'] ?? '',
      narrator: json['narrator'] ?? '',
      bookNumber: json['book_number'] ?? json['bookNumber'] ?? 0,
      hadithNumber: json['hadith_number'] ?? json['hadithNumber'] ?? 0,
      grade: json['grade'] ?? '',
      category: json['category'] ?? '',
      categoryId: json['categoryId'] ?? '',
      reference: json['reference'] ?? '',
    );
  }

  String get reference {
    if (_ref.isNotEmpty) return _ref;
    final parts = <String>[];
    if (source.isNotEmpty) parts.add(source);
    if (narrator.isNotEmpty) parts.add(narrator);
    if (category.isNotEmpty) parts.add(category);
    if (parts.isEmpty && bookNumber > 0) {
      parts.add('كتاب $bookNumber، حديث $hadithNumber');
    }
    return parts.join(' • ');
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'text_arabic': textArabic,
        'source': source,
        'narrator': narrator,
        'book_number': bookNumber,
        'hadith_number': hadithNumber,
        'grade': grade,
      };

  HadithModel copyWith({
    int? id,
    String? textArabic,
    String? source,
    String? narrator,
    int? bookNumber,
    int? hadithNumber,
    String? grade,
  }) {
    return HadithModel(
      id: id ?? this.id,
      textArabic: textArabic ?? this.textArabic,
      source: source ?? this.source,
      narrator: narrator ?? this.narrator,
      bookNumber: bookNumber ?? this.bookNumber,
      hadithNumber: hadithNumber ?? this.hadithNumber,
      grade: grade ?? this.grade,
    );
  }
}

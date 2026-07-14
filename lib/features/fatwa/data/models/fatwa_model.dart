import '../../domain/entities/fatwa_entity.dart';

class FatwaModel {
  final String id;
  final String categoryId;
  final String categoryName;
  final String question;
  final String answer;
  final List<String> keywords;
  final String sourceUrl;
  final String date;
  bool isBookmarked;

  FatwaModel({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    required this.question,
    required this.answer,
    required this.keywords,
    required this.sourceUrl,
    this.date = '',
    this.isBookmarked = false,
  });

  String get title => question.length > 60
      ? '${question.substring(0, 60)}...'
      : question;

  factory FatwaModel.fromEntity(FatwaEntity entity) {
    return FatwaModel(
      id: entity.id,
      categoryId: entity.categoryId,
      categoryName: entity.categoryName,
      question: entity.question,
      answer: entity.answer,
      keywords: entity.keywords,
      sourceUrl: entity.sourceUrl,
      date: entity.date,
      isBookmarked: entity.isBookmarked,
    );
  }

  FatwaEntity toEntity() {
    return FatwaEntity(
      id: id,
      categoryId: categoryId,
      categoryName: categoryName,
      question: question,
      answer: answer,
      keywords: keywords,
      sourceUrl: sourceUrl,
      date: date,
      isBookmarked: isBookmarked,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'question': question,
      'answer': answer,
      'keywords': keywords,
      'sourceUrl': sourceUrl,
      'date': date,
      'isBookmarked': isBookmarked,
    };
  }

  factory FatwaModel.fromJson(
      Map<String, dynamic> json, Map<String, String> categoryMap) {
    final categoryId = json['categoryId'] as String? ?? '';
    return FatwaModel(
      id: json['id'] as String? ?? '',
      categoryId: categoryId,
      categoryName: categoryMap[categoryId] ?? categoryId,
      question: json['question'] as String? ?? '',
      answer: json['answer'] as String? ?? '',
      keywords: (json['keywords'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      sourceUrl: json['sourceUrl'] as String? ?? '',
      date: json['date'] as String? ?? '',
      isBookmarked: json['is_bookmarked'] as bool? ?? false,
    );
  }
}

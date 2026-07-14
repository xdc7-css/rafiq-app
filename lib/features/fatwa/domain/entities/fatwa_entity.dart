class FatwaEntity {
  final String id;
  final String categoryId;
  final String categoryName;
  final String question;
  final String answer;
  final List<String> keywords;
  final String sourceUrl;
  final String date;
  final bool isBookmarked;

  const FatwaEntity({
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

  FatwaEntity copyWith({
    String? id,
    String? categoryId,
    String? categoryName,
    String? question,
    String? answer,
    List<String>? keywords,
    String? sourceUrl,
    String? date,
    bool? isBookmarked,
  }) {
    return FatwaEntity(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      keywords: keywords ?? this.keywords,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      date: date ?? this.date,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }
}

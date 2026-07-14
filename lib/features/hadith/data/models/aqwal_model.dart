class AqwalModel {
  final int id;
  final int imamId;
  final String text;
  final String textNormalized;
  final String topic;
  final String subtopic;
  final String source;
  final String book;
  final String chapter;
  final String volume;
  final String page;
  final String number;
  final String reference;
  final String authenticity;
  final List<String> keywords;
  final List<String> tags;
  final bool isFeatured;

  const AqwalModel({
    required this.id,
    required this.imamId,
    required this.text,
    this.textNormalized = '',
    this.topic = '',
    this.subtopic = '',
    this.source = '',
    this.book = '',
    this.chapter = '',
    this.volume = '',
    this.page = '',
    this.number = '',
    this.reference = '',
    this.authenticity = '',
    this.keywords = const [],
    this.tags = const [],
    this.isFeatured = false,
  });

  factory AqwalModel.fromJson(Map<String, dynamic> json) {
    return AqwalModel(
      id: json['id'] ?? 0,
      imamId: json['imamId'] ?? 0,
      text: json['text'] ?? '',
      textNormalized: json['textNormalized'] ?? '',
      topic: json['topic'] ?? '',
      subtopic: json['subtopic'] ?? '',
      source: json['source'] ?? '',
      book: json['book'] ?? '',
      chapter: json['chapter'] ?? '',
      volume: json['volume'] ?? '',
      page: json['page'] ?? '',
      number: json['number'] ?? '',
      reference: json['reference'] ?? '',
      authenticity: json['authenticity'] ?? '',
      keywords: (json['keywords'] as List<dynamic>?)?.cast<String>() ?? [],
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      isFeatured: json['isFeatured'] ?? false,
    );
  }
}

class AqwalCategory {
  final String id;
  final String name;
  final String shortName;
  final int imamId;

  const AqwalCategory({
    required this.id,
    required this.name,
    required this.shortName,
    required this.imamId,
  });
}

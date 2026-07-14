class ZiyaratModel {
  final String id;
  final String title;
  final String fullText;
  final String source;
  final int sectionCount;
  final int estimatedMinutes;
  final String? audioUrl;
  final String? occasionId;
  final List<String> tags;

  const ZiyaratModel({
    required this.id,
    required this.title,
    required this.fullText,
    required this.source,
    this.sectionCount = 1,
    this.estimatedMinutes = 5,
    this.audioUrl,
    this.occasionId,
    this.tags = const [],
  });

  factory ZiyaratModel.fromJson(Map<String, dynamic> json) => ZiyaratModel(
        id: json['id'] as String,
        title: json['title'] as String,
        fullText: json['fullText'] as String,
        source: json['source'] as String,
        sectionCount: json['sectionCount'] as int? ?? 1,
        estimatedMinutes: json['estimatedMinutes'] as int? ?? 5,
        audioUrl: json['audioUrl'] as String?,
        occasionId: json['occasionId'] as String?,
        tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'fullText': fullText,
        'source': source,
        'sectionCount': sectionCount,
        'estimatedMinutes': estimatedMinutes,
        'audioUrl': audioUrl,
        'occasionId': occasionId,
        'tags': tags,
      };
}

class DuaModel {
  final String id;
  final String title;
  final String fullText;
  final String source;
  final int sectionCount;
  final int estimatedMinutes;
  final String? audioUrl;
  final String? occasionId;
  final List<String> tags;
  final String? category;

  const DuaModel({
    required this.id,
    required this.title,
    required this.fullText,
    required this.source,
    this.sectionCount = 1,
    this.estimatedMinutes = 5,
    this.audioUrl,
    this.occasionId,
    this.tags = const [],
    this.category,
  });

  factory DuaModel.fromJson(Map<String, dynamic> json) => DuaModel(
        id: json['id'] as String,
        title: json['title'] as String,
        fullText: json['fullText'] as String,
        source: json['source'] as String,
        sectionCount: json['sectionCount'] as int? ?? 1,
        estimatedMinutes: json['estimatedMinutes'] as int? ?? 5,
        audioUrl: json['audioUrl'] as String?,
        occasionId: json['occasionId'] as String?,
        tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
        category: json['category'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'fullText': fullText,
        'source': source,
        'sectionCount': sectionCount,
        'estimatedMinutes': estimatedMinutes,
        'audioUrl': audioUrl,
        'occasionId': occasionId,
        'tags': tags,
        'category': category,
      };
}

class SahifaModel {
  final int number;
  final String title;
  final String fullText;
  final int estimatedMinutes;
  final String? audioUrl;
  final List<String> tags;

  const SahifaModel({
    required this.number,
    required this.title,
    required this.fullText,
    this.estimatedMinutes = 3,
    this.audioUrl,
    this.tags = const [],
  });

  factory SahifaModel.fromJson(Map<String, dynamic> json) => SahifaModel(
        number: json['number'] as int,
        title: json['title'] as String,
        fullText: json['fullText'] as String,
        estimatedMinutes: json['estimatedMinutes'] as int? ?? 3,
        audioUrl: json['audioUrl'] as String?,
        tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      );

  Map<String, dynamic> toJson() => {
        'number': number,
        'title': title,
        'fullText': fullText,
        'estimatedMinutes': estimatedMinutes,
        'audioUrl': audioUrl,
        'tags': tags,
      };
}

class MafatihSection {
  final String id;
  final String title;
  final String type;
  final List<MafatihItem> items;

  const MafatihSection({
    required this.id,
    required this.title,
    required this.type,
    this.items = const [],
  });

  factory MafatihSection.fromJson(Map<String, dynamic> json) => MafatihSection(
        id: json['id'] as String,
        title: json['title'] as String,
        type: json['type'] as String,
        items: (json['items'] as List<dynamic>?)
                ?.map((e) => MafatihItem.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
      );
}

class MafatihItem {
  final String id;
  final String title;
  final String fullText;
  final String? source;

  const MafatihItem({
    required this.id,
    required this.title,
    required this.fullText,
    this.source,
  });

  factory MafatihItem.fromJson(Map<String, dynamic> json) => MafatihItem(
        id: json['id'] as String,
        title: json['title'] as String,
        fullText: json['fullText'] as String,
        source: json['source'] as String?,
      );
}

class IslamicOccasion {
  final String id;
  final String title;
  final String dateHijri;
  final String description;
  final List<String> relatedZiyaratIds;
  final List<String> relatedDuaIds;
  final List<String> recommendedDeeds;
  final List<String> relatedTexts;

  const IslamicOccasion({
    required this.id,
    required this.title,
    required this.dateHijri,
    required this.description,
    this.relatedZiyaratIds = const [],
    this.relatedDuaIds = const [],
    this.recommendedDeeds = const [],
    this.relatedTexts = const [],
  });

  factory IslamicOccasion.fromJson(Map<String, dynamic> json) =>
      IslamicOccasion(
        id: json['id'] as String,
        title: json['title'] as String,
        dateHijri: json['dateHijri'] as String,
        description: json['description'] as String,
        relatedZiyaratIds:
            (json['relatedZiyaratIds'] as List<dynamic>?)?.cast<String>() ?? [],
        relatedDuaIds:
            (json['relatedDuaIds'] as List<dynamic>?)?.cast<String>() ?? [],
        recommendedDeeds:
            (json['recommendedDeeds'] as List<dynamic>?)?.cast<String>() ?? [],
        relatedTexts:
            (json['relatedTexts'] as List<dynamic>?)?.cast<String>() ?? [],
      );
}

class ReadingBookmark {
  final String id;
  final String contentId;
  final String contentType;
  final String contentTitle;
  final int position;
  final DateTime savedAt;

  const ReadingBookmark({
    required this.id,
    required this.contentId,
    required this.contentType,
    required this.contentTitle,
    this.position = 0,
    required this.savedAt,
  });

  factory ReadingBookmark.fromJson(Map<String, dynamic> json) =>
      ReadingBookmark(
        id: json['id'] as String,
        contentId: json['contentId'] as String,
        contentType: json['contentType'] as String,
        contentTitle: json['contentTitle'] as String,
        position: json['position'] as int? ?? 0,
        savedAt: DateTime.parse(json['savedAt'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'contentId': contentId,
        'contentType': contentType,
        'contentTitle': contentTitle,
        'position': position,
        'savedAt': savedAt.toIso8601String(),
      };
}

class ContentSearchResult {
  final String id;
  final String title;
  final String type;
  final String matchPreview;
  final double relevance;

  const ContentSearchResult({
    required this.id,
    required this.title,
    required this.type,
    required this.matchPreview,
    this.relevance = 1.0,
  });
}

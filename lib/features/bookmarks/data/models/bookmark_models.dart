enum BookmarkType { ayah, surah, hadith, dhikr, dua, tafsir, page }

class BookmarkModel {
  final String id;
  final BookmarkType type;
  final String title;
  final String? subtitle;
  final Map<String, dynamic> data;
  final DateTime createdAt;

  const BookmarkModel({
    required this.id,
    required this.type,
    required this.title,
    this.subtitle,
    required this.data,
    required this.createdAt,
  });

  factory BookmarkModel.ayah({
    required int ayahNumber,
    required int surahNumber,
    required String surahName,
    required String text,
    required int juz,
    required int page,
  }) {
    return BookmarkModel(
      id: 'ayah_$ayahNumber',
      type: BookmarkType.ayah,
      title: '$surahName : $ayahNumber',
      subtitle: text.length > 100 ? '${text.substring(0, 100)}...' : text,
      data: {
        'ayahNumber': ayahNumber,
        'surahNumber': surahNumber,
        'surahName': surahName,
        'text': text,
        'juz': juz,
        'page': page,
      },
      createdAt: DateTime.now(),
    );
  }

  factory BookmarkModel.surah({
    required int surahNumber,
    required String surahName,
    required int page,
  }) {
    return BookmarkModel(
      id: 'surah_$surahNumber',
      type: BookmarkType.surah,
      title: surahName,
      subtitle: 'السورة $surahNumber',
      data: {'surahNumber': surahNumber, 'surahName': surahName, 'page': page},
      createdAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.index,
    'title': title,
    'subtitle': subtitle,
    'data': data,
    'createdAt': createdAt.toIso8601String(),
  };

  factory BookmarkModel.fromJson(Map<String, dynamic> json) {
    return BookmarkModel(
      id: json['id'] ?? '',
      type: BookmarkType.values[json['type'] ?? 0],
      title: json['title'] ?? '',
      subtitle: json['subtitle'],
      data: (json['data'] as Map<String, dynamic>?) ?? {},
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }
}

class ReadingProgress {
  final int surahNumber;
  final int ayahNumber;
  final int page;
  final int juz;
  final DateTime lastRead;

  const ReadingProgress({
    required this.surahNumber,
    required this.ayahNumber,
    required this.page,
    required this.juz,
    required this.lastRead,
  });

  Map<String, dynamic> toJson() => {
    'surahNumber': surahNumber,
    'ayahNumber': ayahNumber,
    'page': page,
    'juz': juz,
    'lastRead': lastRead.toIso8601String(),
  };

  factory ReadingProgress.fromJson(Map<String, dynamic> json) {
    return ReadingProgress(
      surahNumber: json['surahNumber'] ?? 1,
      ayahNumber: json['ayahNumber'] ?? 1,
      page: json['page'] ?? 1,
      juz: json['juz'] ?? 1,
      lastRead: json['lastRead'] != null
          ? DateTime.parse(json['lastRead'])
          : DateTime.now(),
    );
  }
}

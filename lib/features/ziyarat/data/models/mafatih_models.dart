class MafatihChapter {
  final String title;
  final List<MafatihSection> sections;

  const MafatihChapter({required this.title, required this.sections});

  factory MafatihChapter.fromJson(Map<String, dynamic> json) {
    final rawSections = json['sections'] as List<dynamic>? ?? [];
    return MafatihChapter(
      title: (json['title'] as String? ?? '').trim(),
      sections: rawSections
          .map((s) => MafatihSection.fromJson(s as Map<String, dynamic>))
          .toList(),
    );
  }

  int get totalArticles =>
      sections.fold(0, (sum, s) => sum + s.articles.length);

  String get titleClean => title.replaceAll(RegExp(r'[\n\r\t]'), ' ').trim();
}

class MafatihSection {
  final String? title;
  final List<MafatihArticle> articles;

  const MafatihSection({this.title, required this.articles});

  factory MafatihSection.fromJson(Map<String, dynamic> json) {
    final rawArticles = json['articles'] as List<dynamic>? ?? [];
    final rawTitle = json['title'] as String?;
    return MafatihSection(
      title: rawTitle?.trim().replaceAll(RegExp(r'[\n\r\t]'), ' '),
      articles: rawArticles
          .map((a) => MafatihArticle.fromJson(a as Map<String, dynamic>))
          .toList(),
    );
  }

  String get titleSafe => title ?? '';
  bool get hasTitle => title != null && title!.trim().isNotEmpty;
}

class MafatihArticle {
  final String href;
  final String title;
  final String arabicText;
  final String translation;
  final String aboutText;
  final int totalItems;
  final int arabicCharCount;

  const MafatihArticle({
    required this.href,
    required this.title,
    required this.arabicText,
    required this.translation,
    required this.aboutText,
    required this.totalItems,
    required this.arabicCharCount,
  });

  factory MafatihArticle.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>? ?? [];
    final href = (json['href'] as String? ?? '').trim();
    final title = (json['title'] as String? ?? '')
        .trim()
        .replaceAll(RegExp(r'[\n\r\t]'), ' ')
        .trim();

    final textParts = <String>[];
    final translateParts = <String>[];
    final aboutParts = <String>[];

    for (final item in rawItems) {
      final map = item as Map<String, dynamic>;
      final content = (map['content'] as String? ?? '').trim();
      final type = (map['type'] as String? ?? '').trim();
      if (content.isEmpty) continue;
      switch (type) {
        case 'Text':
          textParts.add(content);
        case 'Translate':
          translateParts.add(content);
        case 'AboutText':
          aboutParts.add(content);
      }
    }

    final arabicText = textParts.join('\n\n').trim();
    final translation = translateParts.join('\n\n').trim();
    final aboutText = aboutParts.join('\n\n').trim();

    return MafatihArticle(
      href: href,
      title: title,
      arabicText: arabicText,
      translation: translation,
      aboutText: aboutText,
      totalItems: rawItems.length,
      arabicCharCount: arabicText.length,
    );
  }

  String get titleClean => title.replaceAll(RegExp(r'[\n\r\t]'), ' ').trim();

  bool get hasArabic => arabicText.isNotEmpty;
  bool get hasTranslation => translation.isNotEmpty;
  bool get hasAbout => aboutText.isNotEmpty;
}

class MafatihSearchResult {
  final MafatihArticle article;
  final String chapterTitle;
  final String? sectionTitle;

  const MafatihSearchResult({
    required this.article,
    required this.chapterTitle,
    this.sectionTitle,
  });
}

class MafatihBookmarkEntry {
  final String articleHref;
  final String articleTitle;
  final String chapterTitle;
  final String? sectionTitle;
  final int scrollPosition;
  final DateTime bookmarkedAt;

  const MafatihBookmarkEntry({
    required this.articleHref,
    required this.articleTitle,
    required this.chapterTitle,
    this.sectionTitle,
    this.scrollPosition = 0,
    required this.bookmarkedAt,
  });

  Map<String, dynamic> toJson() => {
    'href': articleHref,
    'title': articleTitle,
    'chapter': chapterTitle,
    'section': sectionTitle ?? '',
    'scroll': scrollPosition,
    'time': bookmarkedAt.toIso8601String(),
  };

  factory MafatihBookmarkEntry.fromJson(Map<String, dynamic> json) =>
      MafatihBookmarkEntry(
        articleHref: json['href'] as String? ?? '',
        articleTitle: json['title'] as String? ?? '',
        chapterTitle: json['chapter'] as String? ?? '',
        sectionTitle: (json['section'] as String? ?? '').isNotEmpty
            ? json['section'] as String?
            : null,
        scrollPosition: json['scroll'] as int? ?? 0,
        bookmarkedAt: json['time'] != null
            ? DateTime.parse(json['time'] as String)
            : DateTime.now(),
      );
}

class AyahData {
  final int number;
  final String text;
  final int numberInSurah;
  final int juz;
  final int manzil;
  final int page;
  final int ruku;
  final int hizbQuarter;
  final dynamic sajda;
  final SurahInfo? surah;
  final EditionInfo? edition;

  AyahData({
    required this.number,
    required this.text,
    required this.numberInSurah,
    required this.juz,
    required this.manzil,
    required this.page,
    required this.ruku,
    required this.hizbQuarter,
    this.sajda,
    this.surah,
    this.edition,
  });

  factory AyahData.fromJson(Map<String, dynamic> json) {
    return AyahData(
      number: json['number'] ?? 0,
      text: json['text'] ?? '',
      numberInSurah: json['numberInSurah'] ?? 0,
      juz: json['juz'] ?? 0,
      manzil: json['manzil'] ?? 0,
      page: json['page'] ?? 0,
      ruku: json['ruku'] ?? 0,
      hizbQuarter: json['hizbQuarter'] ?? 0,
      sajda: json['sajda'],
      surah: json['surah'] != null ? SurahInfo.fromJson(json['surah']) : null,
      edition: json['edition'] != null ? EditionInfo.fromJson(json['edition']) : null,
    );
  }

  bool get hasSajda => sajda == true;
}

class SurahInfo {
  final int number;
  final String name;
  final String englishName;
  final String englishNameTranslation;
  final int numberOfAyahs;
  final String revelationType;

  SurahInfo({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.numberOfAyahs,
    required this.revelationType,
  });

  factory SurahInfo.fromJson(Map<String, dynamic> json) {
    return SurahInfo(
      number: json['number'] ?? 0,
      name: json['name'] ?? '',
      englishName: json['englishName'] ?? '',
      englishNameTranslation: json['englishNameTranslation'] ?? '',
      numberOfAyahs: json['numberOfAyahs'] ?? 0,
      revelationType: json['revelationType'] ?? '',
    );
  }
}

class EditionInfo {
  final String identifier;
  final String language;
  final String name;
  final String englishName;
  final String format;
  final String type;
  final String? direction;

  EditionInfo({
    required this.identifier,
    required this.language,
    required this.name,
    required this.englishName,
    required this.format,
    required this.type,
    this.direction,
  });

  factory EditionInfo.fromJson(Map<String, dynamic> json) {
    return EditionInfo(
      identifier: json['identifier'] ?? '',
      language: json['language'] ?? '',
      name: json['name'] ?? '',
      englishName: json['englishName'] ?? '',
      format: json['format'] ?? '',
      type: json['type'] ?? '',
      direction: json['direction'],
    );
  }
}

class RandomAyahResponse {
  final int code;
  final String status;
  final AyahData data;

  RandomAyahResponse({
    required this.code,
    required this.status,
    required this.data,
  });

  factory RandomAyahResponse.fromJson(Map<String, dynamic> json) {
    return RandomAyahResponse(
      code: json['code'] ?? 0,
      status: json['status'] ?? '',
      data: AyahData.fromJson(json['data'] ?? {}),
    );
  }
}

class AyahEditionsResponse {
  final int code;
  final String status;
  final List<AyahData> data;

  AyahEditionsResponse({
    required this.code,
    required this.status,
    required this.data,
  });

  factory AyahEditionsResponse.fromJson(Map<String, dynamic> json) {
    return AyahEditionsResponse(
      code: json['code'] ?? 0,
      status: json['status'] ?? '',
      data: (json['data'] as List? ?? [])
          .map((e) => AyahData.fromJson(e))
          .toList(),
    );
  }
}

class AyahEdition {
  final AyahData ayahData;
  final EditionInfo edition;

  AyahEdition({
    required this.ayahData,
    required this.edition,
  });
}

class SurahResponse {
  final int code;
  final String status;
  final SurahFullData data;

  SurahResponse({
    required this.code,
    required this.status,
    required this.data,
  });

  factory SurahResponse.fromJson(Map<String, dynamic> json) {
    return SurahResponse(
      code: json['code'] ?? 0,
      status: json['status'] ?? '',
      data: SurahFullData.fromJson(json['data'] ?? {}),
    );
  }
}

class SurahFullData {
  final int number;
  final String name;
  final String englishName;
  final String englishNameTranslation;
  final String revelationType;
  final int numberOfAyahs;
  final List<AyahData> ayahs;
  final EditionInfo edition;

  SurahFullData({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.revelationType,
    required this.numberOfAyahs,
    required this.ayahs,
    required this.edition,
  });

  factory SurahFullData.fromJson(Map<String, dynamic> json) {
    return SurahFullData(
      number: json['number'] ?? 0,
      name: json['name'] ?? '',
      englishName: json['englishName'] ?? '',
      englishNameTranslation: json['englishNameTranslation'] ?? '',
      revelationType: json['revelationType'] ?? '',
      numberOfAyahs: json['numberOfAyahs'] ?? 0,
      ayahs: (json['ayahs'] as List? ?? [])
          .map((e) => AyahData.fromJson(e))
          .toList(),
      edition: json['edition'] != null
          ? EditionInfo.fromJson(json['edition'])
          : EditionInfo(
              identifier: '',
              language: '',
              name: '',
              englishName: '',
              format: '',
              type: '',
            ),
    );
  }
}

class SurahsListResponse {
  final int code;
  final String status;
  final List<SurahInfo> data;

  SurahsListResponse({
    required this.code,
    required this.status,
    required this.data,
  });

  factory SurahsListResponse.fromJson(Map<String, dynamic> json) {
    return SurahsListResponse(
      code: json['code'] ?? 0,
      status: json['status'] ?? '',
      data: (json['data'] as List? ?? [])
          .map((e) => SurahInfo.fromJson(e))
          .toList(),
    );
  }
}

class SearchMatch {
  final int number;
  final String text;
  final EditionInfo edition;
  final SurahInfo surah;
  final int numberInSurah;

  SearchMatch({
    required this.number,
    required this.text,
    required this.edition,
    required this.surah,
    required this.numberInSurah,
  });

  factory SearchMatch.fromJson(Map<String, dynamic> json) {
    return SearchMatch(
      number: json['number'] ?? 0,
      text: json['text'] ?? '',
      edition: EditionInfo.fromJson(json['edition'] ?? {}),
      surah: SurahInfo.fromJson(json['surah'] ?? {}),
      numberInSurah: json['numberInSurah'] ?? 0,
    );
  }
}

class SearchResponse {
  final int code;
  final String status;
  final int count;
  final List<SearchMatch> matches;

  SearchResponse({
    required this.code,
    required this.status,
    required this.count,
    required this.matches,
  });

  factory SearchResponse.fromJson(Map<String, dynamic> json) {
    return SearchResponse(
      code: json['code'] ?? 0,
      status: json['status'] ?? '',
      count: json['data'] != null ? (json['data']['count'] ?? 0) : 0,
      matches: json['data'] != null
          ? (json['data']['matches'] as List? ?? [])
              .map((e) => SearchMatch.fromJson(e))
              .toList()
          : [],
    );
  }
}

class JuzData {
  final int number;
  final List<AyahData> ayahs;
  final Map<String, SurahInfo> surahs;
  final EditionInfo edition;

  JuzData({
    required this.number,
    required this.ayahs,
    required this.surahs,
    required this.edition,
  });

  factory JuzData.fromJson(Map<String, dynamic> json) {
    return JuzData(
      number: json['number'] ?? 0,
      ayahs: (json['ayahs'] as List? ?? [])
          .map((e) => AyahData.fromJson(e))
          .toList(),
      surahs: (json['surahs'] as Map<String, dynamic>? ?? {})
          .map((key, value) => MapEntry(key, SurahInfo.fromJson(value))),
      edition: json['edition'] != null
          ? EditionInfo.fromJson(json['edition'])
          : EditionInfo(
              identifier: '',
              language: '',
              name: '',
              englishName: '',
              format: '',
              type: '',
            ),
    );
  }
}

class JuzResponse {
  final int code;
  final String status;
  final JuzData data;

  JuzResponse({
    required this.code,
    required this.status,
    required this.data,
  });

  factory JuzResponse.fromJson(Map<String, dynamic> json) {
    return JuzResponse(
      code: json['code'] ?? 0,
      status: json['status'] ?? '',
      data: JuzData.fromJson(json['data'] ?? {}),
    );
  }
}

class MetaData {
  final int ayahsCount;
  final int surahsCount;
  final List<SurahInfo> surahReferences;
  final int pagesCount;

  MetaData({
    required this.ayahsCount,
    required this.surahsCount,
    required this.surahReferences,
    required this.pagesCount,
  });

  factory MetaData.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    final ayahs = data['ayahs'] ?? {};
    final surahs = data['surahs'] ?? {};
    final pages = data['pages'] ?? {};

    return MetaData(
      ayahsCount: ayahs['count'] ?? 6236,
      surahsCount: surahs['count'] ?? 114,
      surahReferences: (surahs['references'] as List? ?? [])
          .map((e) => SurahInfo.fromJson(e))
          .toList(),
      pagesCount: pages['count'] ?? 604,
    );
  }
}

class MetaResponse {
  final int code;
  final String status;
  final MetaData data;

  MetaResponse({
    required this.code,
    required this.status,
    required this.data,
  });

  factory MetaResponse.fromJson(Map<String, dynamic> json) {
    return MetaResponse(
      code: json['code'] ?? 0,
      status: json['status'] ?? '',
      data: MetaData.fromJson(json),
    );
  }
}

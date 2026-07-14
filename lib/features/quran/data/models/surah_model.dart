class SurahModel {
  final int number;
  final String name;
  final int numberOfAyahs;
  final String revelationType;

  const SurahModel({
    required this.number,
    required this.name,
    required this.numberOfAyahs,
    required this.revelationType,
  });

  factory SurahModel.fromJson(Map<String, dynamic> json) {
    return SurahModel(
      number: _parseInt(json['number'] ?? json['number']),
      name: json['name'] ?? '',
      numberOfAyahs: _parseInt(json['numberOfAyahs'] ?? json['ayat'] ?? 0),
      revelationType: json['revelationType'] ?? json['type'] ?? '',
    );
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Map<String, dynamic> toJson() => {
        'number': number,
        'name': name,
        'numberOfAyahs': numberOfAyahs,
        'revelationType': revelationType,
      };
}

class AyahModel {
  final int number;
  final int numberInSurah;
  final int surahNumber;
  final String text;
  final int juz;
  final int page;
  final int hizbQuarter;
  final int ruku;
  final int manzil;
  final bool hasSajda;
  final int? sajdaId;

  const AyahModel({
    required this.number,
    required this.numberInSurah,
    required this.surahNumber,
    required this.text,
    required this.juz,
    required this.page,
    required this.hizbQuarter,
    required this.ruku,
    required this.manzil,
    this.hasSajda = false,
    this.sajdaId,
  });

  factory AyahModel.fromJson(Map<String, dynamic> json) {
    return AyahModel(
      number: json['number'] ?? _parseInt(json['id']),
      numberInSurah: json['numberInSurah'] ?? json['verse'] ?? 0,
      surahNumber: json['surah'] is Map
          ? (json['surah']['number'] ?? 0)
          : (json['surahNumber'] ?? 0),
      text: json['text'] ?? '',
      juz: json['juz'] ?? 1,
      page: json['page'] ?? 1,
      hizbQuarter: json['hizbQuarter'] ?? 1,
      ruku: json['ruku'] ?? 1,
      manzil: json['manzil'] ?? 1,
      hasSajda: json['sajda'] != null,
      sajdaId: json['sajda'] is Map ? json['sajda']['id'] : json['sajda'],
    );
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Map<String, dynamic> toJson() => {
        'number': number,
        'numberInSurah': numberInSurah,
        'surahNumber': surahNumber,
        'text': text,
        'juz': juz,
        'page': page,
        'hizbQuarter': hizbQuarter,
        'ruku': ruku,
        'manzil': manzil,
        'hasSajda': hasSajda,
        'sajdaId': sajdaId,
      };
}

class SajdaModel {
  final int id;
  final int ayahNumber;
  final int surahNumber;
  final String surahName;
  final int numberInSurah;
  final int juz;
  final int page;
  final bool recommended;
  final bool obligatory;

  const SajdaModel({
    required this.id,
    required this.ayahNumber,
    required this.surahNumber,
    required this.surahName,
    required this.numberInSurah,
    required this.juz,
    required this.page,
    required this.recommended,
    required this.obligatory,
  });

  factory SajdaModel.fromJson(Map<String, dynamic> json) {
    final sajda = json['sajda'] as Map<String, dynamic>? ?? {};
    final surah = json['surah'] as Map<String, dynamic>? ?? {};
    return SajdaModel(
      id: sajda['id'] ?? 0,
      ayahNumber: json['number'] ?? 0,
      surahNumber: surah['number'] ?? 0,
      surahName: surah['name'] ?? '',
      numberInSurah: json['numberInSurah'] ?? 0,
      juz: json['juz'] ?? 1,
      page: json['page'] ?? 1,
      recommended: sajda['recommended'] ?? false,
      obligatory: sajda['obligatory'] ?? false,
    );
  }
}

class JuzModel {
  final int number;
  final List<AyahModel> ayahs;
  final Map<int, String> surahNames;

  const JuzModel({
    required this.number,
    required this.ayahs,
    required this.surahNames,
  });
}

class HizbModel {
  final int number;
  final int quarter;
  final List<AyahModel> ayahs;

  const HizbModel({
    required this.number,
    required this.quarter,
    required this.ayahs,
  });
}

class QuranPageModel {
  final int pageNumber;
  final List<AyahModel> ayahs;

  const QuranPageModel({
    required this.pageNumber,
    required this.ayahs,
  });
}

class ReciterModel {
  final String id;
  final String name;
  final String? arabicName;
  final String? style;
  final String baseUrl;
  final List<int> availableSurahs;

  const ReciterModel({
    required this.id,
    required this.name,
    this.arabicName,
    this.style,
    required this.baseUrl,
    required this.availableSurahs,
  });

  factory ReciterModel.fromJson(Map<String, dynamic> json) {
    return ReciterModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      arabicName: json['arabicName'],
      style: json['style'],
      baseUrl: json['baseUrl'] ?? '',
      availableSurahs: (json['availableSurahs'] as List<dynamic>?)
              ?.map((e) => e is int ? e : int.tryParse(e.toString()) ?? 0)
              .toList() ??
          List.generate(114, (i) => i + 1),
    );
  }
}

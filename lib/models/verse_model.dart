class VerseModel {
  final int id;
  final int surahNumber;
  final String surahName;
  final String surahNameArabic;
  final int verseNumber;
  final String textArabic;
  final int juz;

  VerseModel({
    required this.id,
    required this.surahNumber,
    required this.surahName,
    required this.surahNameArabic,
    required this.verseNumber,
    required this.textArabic,
    required this.juz,
  });

  factory VerseModel.fromJson(Map<String, dynamic> json) {
    return VerseModel(
      id: json['id'] ?? 0,
      surahNumber: json['surah_number'] ?? 0,
      surahName: json['surah_name'] ?? '',
      surahNameArabic: json['surah_name_arabic'] ?? '',
      verseNumber: json['verse_number'] ?? 0,
      textArabic: json['text_arabic'] ?? '',
      juz: json['juz'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'surah_number': surahNumber,
      'surah_name': surahName,
      'surah_name_arabic': surahNameArabic,
      'verse_number': verseNumber,
      'text_arabic': textArabic,
      'juz': juz,
    };
  }

  String get reference => '$surahNameArabic $verseNumber';

  VerseModel copyWith({
    int? id,
    int? surahNumber,
    String? surahName,
    String? surahNameArabic,
    int? verseNumber,
    String? textArabic,
    int? juz,
  }) {
    return VerseModel(
      id: id ?? this.id,
      surahNumber: surahNumber ?? this.surahNumber,
      surahName: surahName ?? this.surahName,
      surahNameArabic: surahNameArabic ?? this.surahNameArabic,
      verseNumber: verseNumber ?? this.verseNumber,
      textArabic: textArabic ?? this.textArabic,
      juz: juz ?? this.juz,
    );
  }
}

import 'package:uuid/uuid.dart';

class SurahMeta {
  final String nameArabic;
  final int ayahCount;
  final int startPage;

  const SurahMeta(this.nameArabic, this.ayahCount, this.startPage);
}

class KhatmahModel {
  final String id;
  final int currentPage;
  final int currentSurah;
  final int currentAyah;
  final int totalAyahsRead;
  final DateTime startDate;
  final DateTime? lastReadDate;
  final String name;
  final List<int> readingStreak;

  static const List<SurahMeta> surahs = [
    SurahMeta('الفاتحة', 7, 1),
    SurahMeta('البقرة', 286, 2),
    SurahMeta('آل عمران', 200, 50),
    SurahMeta('النساء', 176, 77),
    SurahMeta('المائدة', 120, 106),
    SurahMeta('الأنعام', 165, 128),
    SurahMeta('الأعراف', 206, 151),
    SurahMeta('الأنفال', 75, 177),
    SurahMeta('التوبة', 129, 187),
    SurahMeta('يونس', 109, 208),
    SurahMeta('هود', 123, 221),
    SurahMeta('يوسف', 111, 235),
    SurahMeta('الرعد', 43, 249),
    SurahMeta('إبراهيم', 52, 255),
    SurahMeta('الحجر', 99, 262),
    SurahMeta('النحل', 128, 267),
    SurahMeta('الإسراء', 111, 282),
    SurahMeta('الكهف', 110, 293),
    SurahMeta('مريم', 98, 305),
    SurahMeta('طه', 135, 312),
    SurahMeta('الأنبياء', 112, 322),
    SurahMeta('الحج', 78, 332),
    SurahMeta('المؤمنون', 118, 342),
    SurahMeta('النور', 64, 350),
    SurahMeta('الفرقان', 77, 359),
    SurahMeta('الشعراء', 227, 367),
    SurahMeta('النمل', 93, 377),
    SurahMeta('القصص', 88, 385),
    SurahMeta('العنكبوت', 69, 396),
    SurahMeta('الروم', 60, 404),
    SurahMeta('لقمان', 34, 410),
    SurahMeta('السجدة', 30, 415),
    SurahMeta('الأحزاب', 73, 418),
    SurahMeta('سبأ', 54, 428),
    SurahMeta('فاطر', 45, 434),
    SurahMeta('يس', 83, 440),
    SurahMeta('الصافات', 182, 446),
    SurahMeta('ص', 88, 454),
    SurahMeta('الزمر', 75, 458),
    SurahMeta('غافر', 85, 467),
    SurahMeta('فصلت', 54, 477),
    SurahMeta('الشورى', 53, 483),
    SurahMeta('الزخرف', 89, 489),
    SurahMeta('الدخان', 59, 496),
    SurahMeta('الجاثية', 37, 500),
    SurahMeta('الأحقاف', 35, 504),
    SurahMeta('محمد', 38, 508),
    SurahMeta('الفتح', 29, 512),
    SurahMeta('الحجرات', 18, 516),
    SurahMeta('ق', 45, 518),
    SurahMeta('الذاريات', 60, 520),
    SurahMeta('الطور', 49, 523),
    SurahMeta('النجم', 62, 526),
    SurahMeta('القمر', 55, 529),
    SurahMeta('الرحمن', 78, 532),
    SurahMeta('الواقعة', 96, 535),
    SurahMeta('الحديد', 29, 539),
    SurahMeta('المجادلة', 22, 542),
    SurahMeta('الحشر', 24, 545),
    SurahMeta('الممتحنة', 13, 549),
    SurahMeta('الصف', 14, 551),
    SurahMeta('الجمعة', 11, 553),
    SurahMeta('المنافقون', 11, 554),
    SurahMeta('التغابن', 18, 556),
    SurahMeta('الطلاق', 12, 558),
    SurahMeta('التحريم', 12, 560),
    SurahMeta('الملك', 30, 562),
    SurahMeta('القلم', 52, 564),
    SurahMeta('الحاقة', 52, 567),
    SurahMeta('المعارج', 44, 569),
    SurahMeta('نوح', 28, 571),
    SurahMeta('الجن', 28, 573),
    SurahMeta('المزمل', 20, 575),
    SurahMeta('المدثر', 56, 577),
    SurahMeta('القيامة', 40, 579),
    SurahMeta('الإنسان', 31, 581),
    SurahMeta('المرسلات', 50, 583),
    SurahMeta('النبأ', 40, 585),
    SurahMeta('النازعات', 46, 587),
    SurahMeta('عبس', 42, 589),
    SurahMeta('التكوير', 29, 591),
    SurahMeta('الإنفطار', 19, 592),
    SurahMeta('المطففين', 36, 593),
    SurahMeta('الإنشقاق', 25, 595),
    SurahMeta('البروج', 22, 596),
    SurahMeta('الطارق', 17, 597),
    SurahMeta('الأعلى', 19, 598),
    SurahMeta('الغاشية', 26, 599),
    SurahMeta('الفجر', 30, 600),
    SurahMeta('البلد', 20, 601),
    SurahMeta('الشمس', 15, 601),
    SurahMeta('الليل', 21, 602),
    SurahMeta('الضحى', 11, 602),
    SurahMeta('الشرح', 8, 603),
    SurahMeta('التين', 8, 603),
    SurahMeta('العلق', 19, 604),
    SurahMeta('القدر', 5, 604),
    SurahMeta('البينة', 8, 604),
    SurahMeta('الزلزلة', 8, 604),
    SurahMeta('العاديات', 11, 604),
    SurahMeta('القارعة', 11, 604),
    SurahMeta('التكاثر', 8, 604),
    SurahMeta('العصر', 3, 604),
    SurahMeta('الهمزة', 9, 604),
    SurahMeta('الفيل', 5, 604),
    SurahMeta('قريش', 4, 604),
    SurahMeta('الماعون', 7, 604),
    SurahMeta('الكوثر', 3, 604),
    SurahMeta('الكافرون', 6, 604),
    SurahMeta('النصر', 3, 604),
    SurahMeta('المسد', 5, 604),
    SurahMeta('الإخلاص', 4, 604),
    SurahMeta('الفلق', 5, 604),
    SurahMeta('الناس', 6, 604),
  ];

  static int totalQuranAyahs() {
    return surahs.fold(0, (sum, s) => sum + s.ayahCount);
  }

  static int pageForPosition(int surah, int ayah) {
    final s = surahs[surah - 1];
    if (surah < 114) {
      final next = surahs[surah];
      if (ayah <= 1) return s.startPage;
      return s.startPage + ((ayah * (next.startPage - s.startPage)) ~/ (s.ayahCount + 1));
    }
    return s.startPage;
  }

  static String surahName(int surah) => surahs[surah - 1].nameArabic;

  static int surahAyahCount(int surah) => surahs[surah - 1].ayahCount;

  static int juzForPosition(int surah, int ayah) {
    final globalAyahIdx = globalAyahIndex(surah, ayah);
    if (globalAyahIdx <= 0) return 1;
    if (globalAyahIdx <= 1483) return 1;
    if (globalAyahIdx <= 2529) return 2;
    if (globalAyahIdx <= 3783) return 3;
    if (globalAyahIdx <= 5219) return 4;
    if (globalAyahIdx <= 6322) return 5;
    if (globalAyahIdx <= 7438) return 6;
    if (globalAyahIdx <= 8849) return 7;
    if (globalAyahIdx <= 9907) return 8;
    if (globalAyahIdx <= 11025) return 9;
    if (globalAyahIdx <= 12274) return 10;
    if (globalAyahIdx <= 13545) return 11;
    if (globalAyahIdx <= 14814) return 12;
    if (globalAyahIdx <= 16044) return 13;
    if (globalAyahIdx <= 17476) return 14;
    if (globalAyahIdx <= 18660) return 15;
    if (globalAyahIdx <= 19997) return 16;
    if (globalAyahIdx <= 21329) return 17;
    if (globalAyahIdx <= 22561) return 18;
    if (globalAyahIdx <= 23649) return 19;
    if (globalAyahIdx <= 24835) return 20;
    if (globalAyahIdx <= 25963) return 21;
    if (globalAyahIdx <= 26877) return 22;
    if (globalAyahIdx <= 27892) return 23;
    if (globalAyahIdx <= 28969) return 24;
    if (globalAyahIdx <= 29913) return 25;
    if (globalAyahIdx <= 30778) return 26;
    if (globalAyahIdx <= 31526) return 27;
    if (globalAyahIdx <= 32255) return 28;
    if (globalAyahIdx <= 32983) return 29;
    return 30;
  }

  static int globalAyahIndex(int surah, int ayah) {
    int idx = 0;
    for (int i = 0; i < surah - 1; i++) {
      idx += surahs[i].ayahCount;
    }
    return idx + ayah;
  }

  static const int totalPages = 604;

  KhatmahModel({
    String? id,
    this.currentPage = 0,
    int? currentSurah,
    int? currentAyah,
    this.totalAyahsRead = 0,
    DateTime? startDate,
    this.lastReadDate,
    this.name = 'ختمتي',
    List<int>? readingStreak,
  })  : id = id ?? const Uuid().v4(),
        currentSurah = currentSurah ?? 1,
        currentAyah = currentAyah ?? 1,
        startDate = startDate ?? DateTime.now(),
        readingStreak = readingStreak ?? [];

  int get remainingPages => totalPages - currentPage;

  double get progress => totalPages > 0 ? currentPage / totalPages : 0;

  int get progressPercentage => (progress * 100).round();

  int get daysActive => readingStreak.length;

  int get currentStreak {
    if (readingStreak.isEmpty) return 0;
    final sorted = List<int>.from(readingStreak)..sort();
    int streak = 1;
    for (int i = sorted.length - 1; i > 0; i--) {
      if (sorted[i] - sorted[i - 1] == 1) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }

  DateTime? get estimatedCompletionDate {
    if (remainingPages <= 0 || daysActive == 0) return null;
    final daysSoFar = DateTime.now().difference(startDate).inDays;
    if (daysSoFar <= 0) return null;
    final pagesPerDay = currentPage / daysSoFar;
    if (pagesPerDay <= 0) return null;
    final remainingDays = (remainingPages / pagesPerDay).ceil();
    return DateTime.now().add(Duration(days: remainingDays));
  }

  int get currentJuz => juzForPosition(currentSurah, currentAyah);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'totalPages': totalPages,
      'currentPage': currentPage,
      'currentSurah': currentSurah,
      'currentAyah': currentAyah,
      'totalAyahsRead': totalAyahsRead,
      'startDate': startDate.toIso8601String(),
      'lastReadDate': lastReadDate?.toIso8601String(),
      'name': name,
      'readingStreak': readingStreak,
    };
  }

  factory KhatmahModel.fromJson(Map<String, dynamic> json) {
    return KhatmahModel(
      id: json['id'],
      currentPage: json['currentPage'] ?? 0,
      currentSurah: json['currentSurah'] ?? 1,
      currentAyah: json['currentAyah'] ?? 1,
      totalAyahsRead: json['totalAyahsRead'] ?? 0,
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : DateTime.now(),
      lastReadDate: json['lastReadDate'] != null
          ? DateTime.parse(json['lastReadDate'])
          : null,
      name: json['name'] ?? 'ختمتي',
      readingStreak: List<int>.from(json['readingStreak'] ?? []),
    );
  }

  KhatmahModel copyWith({
    String? id,
    int? totalPages,
    int? currentPage,
    int? currentSurah,
    int? currentAyah,
    int? totalAyahsRead,
    DateTime? startDate,
    DateTime? lastReadDate,
    String? name,
    List<int>? readingStreak,
  }) {
    return KhatmahModel(
      id: id ?? this.id,
      currentPage: currentPage ?? this.currentPage,
      currentSurah: currentSurah ?? this.currentSurah,
      currentAyah: currentAyah ?? this.currentAyah,
      totalAyahsRead: totalAyahsRead ?? this.totalAyahsRead,
      startDate: startDate ?? this.startDate,
      lastReadDate: lastReadDate ?? this.lastReadDate,
      name: name ?? this.name,
      readingStreak: readingStreak ?? this.readingStreak,
    );
  }
}

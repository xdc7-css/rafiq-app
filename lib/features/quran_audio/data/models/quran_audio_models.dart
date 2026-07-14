class Moshaf {
  final int id;
  final String name;
  final String server;
  final String surahList;
  final int count;

  const Moshaf({
    required this.id,
    required this.name,
    required this.server,
    required this.surahList,
    required this.count,
  });

  factory Moshaf.fromJson(Map<String, dynamic> json) {
    return Moshaf(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name'] as String? ?? '',
      server: json['server'] as String? ?? '',
      surahList: json['surahList'] as String? ?? '1-114',
      count: json['count'] is int ? json['count'] : int.tryParse(json['count']?.toString() ?? '0') ?? 0,
    );
  }

  List<int> parsedSurahNumbers() {
    final list = <int>[];
    final parts = surahList.split(',');
    for (final part in parts) {
      final trimmed = part.trim();
      if (trimmed.contains('-')) {
        final range = trimmed.split('-');
        final start = int.tryParse(range[0].trim());
        final end = int.tryParse(range[1].trim());
        if (start != null && end != null) {
          for (int i = start; i <= end; i++) {
            list.add(i);
          }
        }
      } else {
        final num = int.tryParse(trimmed);
        if (num != null) list.add(num);
      }
    }
    return list;
  }

  String audioUrl(int surahNumber) {
    final padded = surahNumber.toString().padLeft(3, '0');
    final base = server.endsWith('/') ? server : '$server/';
    return '$base$padded.mp3';
  }
}

class QuranReciter {
  final int id;
  final String name;
  final String server;
  final String riwayah;
  final int count;
  final String letter;
  final List<Moshaf> moshaf;

  const QuranReciter({
    required this.id,
    required this.name,
    required this.server,
    required this.riwayah,
    required this.count,
    required this.letter,
    required this.moshaf,
  });

  factory QuranReciter.fromJson(Map<String, dynamic> json) {
    final moshafList = (json['moshaf'] as List<dynamic>?)
            ?.map((e) => Moshaf.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    return QuranReciter(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name'] as String? ?? '',
      server: json['Server'] as String? ?? '',
      riwayah: json['Rewaya'] as String? ?? '',
      count: json['count'] is int ? json['count'] : int.tryParse(json['count']?.toString() ?? '0') ?? 0,
      letter: json['letter'] as String? ?? '',
      moshaf: moshafList,
    );
  }

  Moshaf? get primaryMoshaf => moshaf.isNotEmpty ? moshaf.first : null;
}

class RecentlyPlayedEntry {
  final int reciterId;
  final String reciterName;
  final String moshafName;
  final String server;
  final int surahNumber;
  final String surahName;
  final Duration position;
  final DateTime playedAt;
  final String moshafId;

  const RecentlyPlayedEntry({
    required this.reciterId,
    required this.reciterName,
    required this.moshafName,
    required this.server,
    required this.surahNumber,
    required this.surahName,
    required this.position,
    required this.playedAt,
    required this.moshafId,
  });

  Map<String, dynamic> toJson() => {
        'reciterId': reciterId,
        'reciterName': reciterName,
        'moshafName': moshafName,
        'server': server,
        'surahNumber': surahNumber,
        'surahName': surahName,
        'positionMs': position.inMilliseconds,
        'playedAt': playedAt.toIso8601String(),
        'moshafId': moshafId,
      };

  factory RecentlyPlayedEntry.fromJson(Map<String, dynamic> json) {
    return RecentlyPlayedEntry(
      reciterId: json['reciterId'] as int? ?? 0,
      reciterName: json['reciterName'] as String? ?? '',
      moshafName: json['moshafName'] as String? ?? '',
      server: json['server'] as String? ?? '',
      surahNumber: json['surahNumber'] as int? ?? 1,
      surahName: json['surahName'] as String? ?? '',
      position: Duration(milliseconds: json['positionMs'] as int? ?? 0),
      playedAt: DateTime.tryParse(json['playedAt'] as String? ?? '') ?? DateTime.now(),
      moshafId: json['moshafId'] as String? ?? '',
    );
  }
}

const List<Map<String, dynamic>> defaultSurahs = [
  {'number': 1, 'name': 'الفاتحة', 'revelationType': 'Meccan', 'ayahCount': 7},
  {'number': 2, 'name': 'البقرة', 'revelationType': 'Madinan', 'ayahCount': 286},
  {'number': 3, 'name': 'آل عمران', 'revelationType': 'Madinan', 'ayahCount': 200},
  {'number': 4, 'name': 'النساء', 'revelationType': 'Madinan', 'ayahCount': 176},
  {'number': 5, 'name': 'المائدة', 'revelationType': 'Madinan', 'ayahCount': 120},
  {'number': 6, 'name': 'الأنعام', 'revelationType': 'Meccan', 'ayahCount': 165},
  {'number': 7, 'name': 'الأعراف', 'revelationType': 'Meccan', 'ayahCount': 206},
  {'number': 8, 'name': 'الأنفال', 'revelationType': 'Madinan', 'ayahCount': 75},
  {'number': 9, 'name': 'التوبة', 'revelationType': 'Madinan', 'ayahCount': 129},
  {'number': 10, 'name': 'يونس', 'revelationType': 'Meccan', 'ayahCount': 109},
  {'number': 11, 'name': 'هود', 'revelationType': 'Meccan', 'ayahCount': 123},
  {'number': 12, 'name': 'يوسف', 'revelationType': 'Meccan', 'ayahCount': 111},
  {'number': 13, 'name': 'الرعد', 'revelationType': 'Madinan', 'ayahCount': 43},
  {'number': 14, 'name': 'إبراهيم', 'revelationType': 'Meccan', 'ayahCount': 52},
  {'number': 15, 'name': 'الحجر', 'revelationType': 'Meccan', 'ayahCount': 99},
  {'number': 16, 'name': 'النحل', 'revelationType': 'Meccan', 'ayahCount': 128},
  {'number': 17, 'name': 'الإسراء', 'revelationType': 'Meccan', 'ayahCount': 111},
  {'number': 18, 'name': 'الكهف', 'revelationType': 'Meccan', 'ayahCount': 110},
  {'number': 19, 'name': 'مريم', 'revelationType': 'Meccan', 'ayahCount': 98},
  {'number': 20, 'name': 'طه', 'revelationType': 'Meccan', 'ayahCount': 135},
  {'number': 21, 'name': 'الأنبياء', 'revelationType': 'Meccan', 'ayahCount': 112},
  {'number': 22, 'name': 'الحج', 'revelationType': 'Madinan', 'ayahCount': 78},
  {'number': 23, 'name': 'المؤمنون', 'revelationType': 'Meccan', 'ayahCount': 118},
  {'number': 24, 'name': 'النور', 'revelationType': 'Madinan', 'ayahCount': 64},
  {'number': 25, 'name': 'الفرقان', 'revelationType': 'Meccan', 'ayahCount': 77},
  {'number': 26, 'name': 'الشعراء', 'revelationType': 'Meccan', 'ayahCount': 227},
  {'number': 27, 'name': 'النمل', 'revelationType': 'Meccan', 'ayahCount': 93},
  {'number': 28, 'name': 'القصص', 'revelationType': 'Meccan', 'ayahCount': 88},
  {'number': 29, 'name': 'العنكبوت', 'revelationType': 'Meccan', 'ayahCount': 69},
  {'number': 30, 'name': 'الروم', 'revelationType': 'Meccan', 'ayahCount': 60},
  {'number': 31, 'name': 'لقمان', 'revelationType': 'Meccan', 'ayahCount': 34},
  {'number': 32, 'name': 'السجدة', 'revelationType': 'Meccan', 'ayahCount': 30},
  {'number': 33, 'name': 'الأحزاب', 'revelationType': 'Madinan', 'ayahCount': 73},
  {'number': 34, 'name': 'سبأ', 'revelationType': 'Meccan', 'ayahCount': 54},
  {'number': 35, 'name': 'فاطر', 'revelationType': 'Meccan', 'ayahCount': 45},
  {'number': 36, 'name': 'يس', 'revelationType': 'Meccan', 'ayahCount': 83},
  {'number': 37, 'name': 'الصافات', 'revelationType': 'Meccan', 'ayahCount': 182},
  {'number': 38, 'name': 'ص', 'revelationType': 'Meccan', 'ayahCount': 88},
  {'number': 39, 'name': 'الزمر', 'revelationType': 'Meccan', 'ayahCount': 75},
  {'number': 40, 'name': 'غافر', 'revelationType': 'Meccan', 'ayahCount': 85},
  {'number': 41, 'name': 'فصلت', 'revelationType': 'Meccan', 'ayahCount': 54},
  {'number': 42, 'name': 'الشورى', 'revelationType': 'Meccan', 'ayahCount': 53},
  {'number': 43, 'name': 'الزخرف', 'revelationType': 'Meccan', 'ayahCount': 89},
  {'number': 44, 'name': 'الدخان', 'revelationType': 'Meccan', 'ayahCount': 59},
  {'number': 45, 'name': 'الجاثية', 'revelationType': 'Meccan', 'ayahCount': 37},
  {'number': 46, 'name': 'الأحقاف', 'revelationType': 'Meccan', 'ayahCount': 35},
  {'number': 47, 'name': 'محمد', 'revelationType': 'Madinan', 'ayahCount': 38},
  {'number': 48, 'name': 'الفتح', 'revelationType': 'Madinan', 'ayahCount': 29},
  {'number': 49, 'name': 'الحجرات', 'revelationType': 'Madinan', 'ayahCount': 18},
  {'number': 50, 'name': 'ق', 'revelationType': 'Meccan', 'ayahCount': 45},
  {'number': 51, 'name': 'الذاريات', 'revelationType': 'Meccan', 'ayahCount': 60},
  {'number': 52, 'name': 'الطور', 'revelationType': 'Meccan', 'ayahCount': 49},
  {'number': 53, 'name': 'النجم', 'revelationType': 'Meccan', 'ayahCount': 62},
  {'number': 54, 'name': 'القمر', 'revelationType': 'Meccan', 'ayahCount': 55},
  {'number': 55, 'name': 'الرحمن', 'revelationType': 'Madinan', 'ayahCount': 78},
  {'number': 56, 'name': 'الواقعة', 'revelationType': 'Meccan', 'ayahCount': 96},
  {'number': 57, 'name': 'الحديد', 'revelationType': 'Madinan', 'ayahCount': 29},
  {'number': 58, 'name': 'المجادلة', 'revelationType': 'Madinan', 'ayahCount': 22},
  {'number': 59, 'name': 'الحشر', 'revelationType': 'Madinan', 'ayahCount': 24},
  {'number': 60, 'name': 'الممتحنة', 'revelationType': 'Madinan', 'ayahCount': 13},
  {'number': 61, 'name': 'الصف', 'revelationType': 'Madinan', 'ayahCount': 14},
  {'number': 62, 'name': 'الجمعة', 'revelationType': 'Madinan', 'ayahCount': 11},
  {'number': 63, 'name': 'المنافقون', 'revelationType': 'Madinan', 'ayahCount': 11},
  {'number': 64, 'name': 'التغابن', 'revelationType': 'Madinan', 'ayahCount': 18},
  {'number': 65, 'name': 'الطلاق', 'revelationType': 'Madinan', 'ayahCount': 12},
  {'number': 66, 'name': 'التحريم', 'revelationType': 'Madinan', 'ayahCount': 12},
  {'number': 67, 'name': 'الملك', 'revelationType': 'Meccan', 'ayahCount': 30},
  {'number': 68, 'name': 'القلم', 'revelationType': 'Meccan', 'ayahCount': 52},
  {'number': 69, 'name': 'الحاقة', 'revelationType': 'Meccan', 'ayahCount': 52},
  {'number': 70, 'name': 'المعارج', 'revelationType': 'Meccan', 'ayahCount': 44},
  {'number': 71, 'name': 'نوح', 'revelationType': 'Meccan', 'ayahCount': 28},
  {'number': 72, 'name': 'الجن', 'revelationType': 'Meccan', 'ayahCount': 28},
  {'number': 73, 'name': 'المزمل', 'revelationType': 'Meccan', 'ayahCount': 20},
  {'number': 74, 'name': 'المدثر', 'revelationType': 'Meccan', 'ayahCount': 56},
  {'number': 75, 'name': 'القيامة', 'revelationType': 'Meccan', 'ayahCount': 40},
  {'number': 76, 'name': 'الإنسان', 'revelationType': 'Madinan', 'ayahCount': 31},
  {'number': 77, 'name': 'المرسلات', 'revelationType': 'Meccan', 'ayahCount': 50},
  {'number': 78, 'name': 'النبأ', 'revelationType': 'Meccan', 'ayahCount': 40},
  {'number': 79, 'name': 'النازعات', 'revelationType': 'Meccan', 'ayahCount': 46},
  {'number': 80, 'name': 'عبس', 'revelationType': 'Meccan', 'ayahCount': 42},
  {'number': 81, 'name': 'التكوير', 'revelationType': 'Meccan', 'ayahCount': 29},
  {'number': 82, 'name': 'الإنفطار', 'revelationType': 'Meccan', 'ayahCount': 19},
  {'number': 83, 'name': 'المطففين', 'revelationType': 'Meccan', 'ayahCount': 36},
  {'number': 84, 'name': 'الإنشقاق', 'revelationType': 'Meccan', 'ayahCount': 25},
  {'number': 85, 'name': 'البروج', 'revelationType': 'Meccan', 'ayahCount': 22},
  {'number': 86, 'name': 'الطارق', 'revelationType': 'Meccan', 'ayahCount': 17},
  {'number': 87, 'name': 'الأعلى', 'revelationType': 'Meccan', 'ayahCount': 19},
  {'number': 88, 'name': 'الغاشية', 'revelationType': 'Meccan', 'ayahCount': 26},
  {'number': 89, 'name': 'الفجر', 'revelationType': 'Meccan', 'ayahCount': 30},
  {'number': 90, 'name': 'البلد', 'revelationType': 'Meccan', 'ayahCount': 20},
  {'number': 91, 'name': 'الشمس', 'revelationType': 'Meccan', 'ayahCount': 15},
  {'number': 92, 'name': 'الليل', 'revelationType': 'Meccan', 'ayahCount': 21},
  {'number': 93, 'name': 'الضحى', 'revelationType': 'Meccan', 'ayahCount': 11},
  {'number': 94, 'name': 'الشرح', 'revelationType': 'Meccan', 'ayahCount': 8},
  {'number': 95, 'name': 'التين', 'revelationType': 'Meccan', 'ayahCount': 8},
  {'number': 96, 'name': 'العلق', 'revelationType': 'Meccan', 'ayahCount': 19},
  {'number': 97, 'name': 'القدر', 'revelationType': 'Meccan', 'ayahCount': 5},
  {'number': 98, 'name': 'البينة', 'revelationType': 'Madinan', 'ayahCount': 8},
  {'number': 99, 'name': 'الزلزلة', 'revelationType': 'Madinan', 'ayahCount': 8},
  {'number': 100, 'name': 'العاديات', 'revelationType': 'Meccan', 'ayahCount': 11},
  {'number': 101, 'name': 'القارعة', 'revelationType': 'Meccan', 'ayahCount': 11},
  {'number': 102, 'name': 'التكاثر', 'revelationType': 'Meccan', 'ayahCount': 8},
  {'number': 103, 'name': 'العصر', 'revelationType': 'Meccan', 'ayahCount': 3},
  {'number': 104, 'name': 'الهمزة', 'revelationType': 'Meccan', 'ayahCount': 9},
  {'number': 105, 'name': 'الفيل', 'revelationType': 'Meccan', 'ayahCount': 5},
  {'number': 106, 'name': 'قريش', 'revelationType': 'Meccan', 'ayahCount': 4},
  {'number': 107, 'name': 'الماعون', 'revelationType': 'Meccan', 'ayahCount': 7},
  {'number': 108, 'name': 'الكوثر', 'revelationType': 'Meccan', 'ayahCount': 3},
  {'number': 109, 'name': 'الكافرون', 'revelationType': 'Meccan', 'ayahCount': 6},
  {'number': 110, 'name': 'النصر', 'revelationType': 'Madinan', 'ayahCount': 3},
  {'number': 111, 'name': 'المسد', 'revelationType': 'Meccan', 'ayahCount': 5},
  {'number': 112, 'name': 'الإخلاص', 'revelationType': 'Meccan', 'ayahCount': 4},
  {'number': 113, 'name': 'الفلق', 'revelationType': 'Meccan', 'ayahCount': 5},
  {'number': 114, 'name': 'الناس', 'revelationType': 'Meccan', 'ayahCount': 6},
];

String surahName(int number) {
  final found = defaultSurahs.firstWhere(
    (s) => s['number'] == number,
    orElse: () => {'name': 'سورة $number'},
  );
  return found['name'] as String;
}

String revelationType(int number) {
  final found = defaultSurahs.firstWhere(
    (s) => s['number'] == number,
    orElse: () => {'revelationType': 'Meccan'},
  );
  return found['revelationType'] as String;
}

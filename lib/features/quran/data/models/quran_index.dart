import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class SurahIndex {
  final int number;
  final String name;
  final String englishName;
  final String englishNameTranslation;
  final int numberOfAyahs;
  final String revelationType;
  final int startPage;
  final int endPage;
  final int juz;

  const SurahIndex({
    required this.number,
    required this.name,
    this.englishName = '',
    this.englishNameTranslation = '',
    this.numberOfAyahs = 0,
    this.revelationType = '',
    required this.startPage,
    required this.endPage,
    this.juz = 1,
  });
}

class JuzIndex {
  final int number;
  final String nameArabic;
  final String nameEnglish;
  final int startPage;
  final int endPage;
  final List<int> surahNumbers;

  const JuzIndex({
    required this.number,
    required this.nameArabic,
    this.nameEnglish = '',
    required this.startPage,
    required this.endPage,
    required this.surahNumbers,
  });
}

class HizbIndex {
  final int number;
  final int startPage;
  final int quarter;

  const HizbIndex({
    required this.number,
    required this.startPage,
    this.quarter = 0,
  });
}

class PageInfo {
  final int pageNumber;
  final int juz;
  final int hizb;
  final List<int> surahNumbers;
  final bool isSajdaPage;

  const PageInfo({
    required this.pageNumber,
    required this.juz,
    this.hizb = 1,
    required this.surahNumbers,
    this.isSajdaPage = false,
  });
}

class QuranIndex {
  static QuranIndex? _instance;
  static QuranIndex get instance => _instance ??= QuranIndex._();

  QuranIndex._();

  List<SurahIndex> surahs = [];
  List<JuzIndex> juzList = [];
  List<HizbIndex> hizbList = [];
  List<PageInfo> pages = [];
  List<Map<String, dynamic>> allAyahs = [];

  bool _initialized = false;
  bool get isInitialized => _initialized;

  Future<void> initialize() async {
    if (_initialized) return;
    try {
      await _loadHafsData();
      _buildIndexes();
      _initialized = true;
      debugPrint('[QuranIndex] Initialized: ${surahs.length} surahs, ${allAyahs.length} ayahs, ${pages.length} pages');
    } catch (e, st) {
      debugPrint('[QuranIndex] Error in initialize: $e');
      debugPrint('[QuranIndex] Stack: $st');
      try {
        if (surahs.isEmpty) _buildIndexes();
      } catch (_) {}
      _initialized = true;
    }
  }

  Future<void> _loadHafsData() async {
    try {
      debugPrint('[QuranIndex] Loading hafs data from assets/data/quran/hafs.json');
      final data = await rootBundle
          .loadString('assets/data/quran/hafs.json')
          .timeout(const Duration(seconds: 15), onTimeout: () {
        debugPrint('[QuranIndex] Timeout loading hafs.json');
        return '';
      });
      if (data.isEmpty) {
        debugPrint('[QuranIndex] hafs.json data is empty');
        allAyahs = [];
        return;
      }
      debugPrint('[QuranIndex] Parsing hafs data (${data.length} chars)');
      final List<dynamic> jsonList = json.decode(data);
      allAyahs = jsonList.cast<Map<String, dynamic>>().toList();
      debugPrint('[QuranIndex] Loaded ${allAyahs.length} ayahs from hafs.json');
    } catch (e, st) {
      debugPrint('[QuranIndex] Error loading hafs data: $e');
      debugPrint('[QuranIndex] Stack: $st');
      allAyahs = [];
    }
  }

  void _buildIndexes() {
    _buildSurahIndex();
    _buildJuzIndex();
    _buildHizbIndex();
    _buildPageIndex();
  }

  void _buildSurahIndex() {
    final surahMap = <int, Map<String, dynamic>>{};
    for (final ayah in allAyahs) {
      final surahNo = ayah['sura_no'] as int? ?? 0;
      if (surahNo < 1 || surahNo > 114) continue;
      if (!surahMap.containsKey(surahNo)) {
        surahMap[surahNo] = {
          'number': surahNo,
          'name': ayah['sura_name_ar'] as String? ?? '',
          'englishName': ayah['sura_name_en'] as String? ?? '',
          'firstPage': ayah['page'] as int? ?? 1,
          'lastPage': ayah['page'] as int? ?? 1,
          'ayahCount': 0,
          'juz': ayah['jozz'] as int? ?? 1,
        };
      }
      final entry = surahMap[surahNo]!;
      entry['lastPage'] = ayah['page'] as int? ?? 1;
      entry['ayahCount'] = (entry['ayahCount'] as int) + 1;
    }

    surahs = [];
    for (int num = 1; num <= 114; num++) {
      final entry = surahMap[num];
      if (entry != null) {
        surahs.add(SurahIndex(
          number: num,
          name: (entry['name'] as String?)?.isNotEmpty == true
              ? entry['name'] as String
              : 'سورة $num',
          englishName: (entry['englishName'] as String?)?.isNotEmpty == true
              ? entry['englishName'] as String
              : 'Surah $num',
          englishNameTranslation: '',
          numberOfAyahs: entry['ayahCount'] as int,
          revelationType: '',
          startPage: entry['firstPage'] as int,
          endPage: entry['lastPage'] as int,
          juz: entry['juz'] as int,
        ));
      } else {
        surahs.add(SurahIndex(
          number: num,
          name: 'سورة $num',
          englishName: 'Surah $num',
          englishNameTranslation: '',
          numberOfAyahs: 0,
          revelationType: '',
          startPage: 1,
          endPage: 1,
          juz: 1,
        ));
      }
    }
  }

  void _buildJuzIndex() {
    final juzData = [
      (1, 'الجزء الأول', 'Juz 1', 1, 22),
      (2, 'الجزء الثاني', 'Juz 2', 22, 42),
      (3, 'الجزء الثالث', 'Juz 3', 42, 62),
      (4, 'الجزء الرابع', 'Juz 4', 62, 82),
      (5, 'الجزء الخامس', 'Juz 5', 82, 102),
      (6, 'الجزء السادس', 'Juz 6', 102, 122),
      (7, 'الجزء السابع', 'Juz 7', 122, 142),
      (8, 'الجزء الثامن', 'Juz 8', 142, 162),
      (9, 'الجزء التاسع', 'Juz 9', 162, 182),
      (10, 'الجزء العاشر', 'Juz 10', 182, 202),
      (11, 'الجزء الحادي عشر', 'Juz 11', 202, 222),
      (12, 'الجزء الثاني عشر', 'Juz 12', 222, 242),
      (13, 'الجزء الثالث عشر', 'Juz 13', 242, 262),
      (14, 'الجزء الرابع عشر', 'Juz 14', 262, 282),
      (15, 'الجزء الخامس عشر', 'Juz 15', 282, 302),
      (16, 'الجزء السادس عشر', 'Juz 16', 302, 322),
      (17, 'الجزء السابع عشر', 'Juz 17', 322, 342),
      (18, 'الجزء الثامن عشر', 'Juz 18', 342, 362),
      (19, 'الجزء التاسع عشر', 'Juz 19', 362, 382),
      (20, 'الجزء العشرون', 'Juz 20', 382, 402),
      (21, 'الجزء الحادي والعشرون', 'Juz 21', 402, 422),
      (22, 'الجزء الثاني والعشرون', 'Juz 22', 422, 442),
      (23, 'الجزء الثالث والعشرون', 'Juz 23', 442, 462),
      (24, 'الجزء الرابع والعشرون', 'Juz 24', 462, 482),
      (25, 'الجزء الخامس والعشرون', 'Juz 25', 482, 502),
      (26, 'الجزء السادس والعشرون', 'Juz 26', 502, 522),
      (27, 'الجزء السابع والعشرون', 'Juz 27', 522, 542),
      (28, 'الجزء الثامن والعشرون', 'Juz 28', 542, 562),
      (29, 'الجزء التاسع والعشرون', 'Juz 29', 562, 582),
      (30, 'الجزء الثلاثون', 'Juz 30', 582, 604),
    ];

    final Map<int, Set<int>> juzSurahs = {};
    for (final ayah in allAyahs) {
      final juz = ayah['jozz'] as int? ?? 1;
      final surahNo = ayah['sura_no'] as int? ?? 0;
      if (juz >= 1 && juz <= 30 && surahNo >= 1 && surahNo <= 114) {
        juzSurahs.putIfAbsent(juz, () => <int>{}).add(surahNo);
      }
    }

    juzList = juzData.map((d) {
      final surahNums = (juzSurahs[d.$1]?.toList() ?? [])..sort();
      return JuzIndex(
        number: d.$1,
        nameArabic: d.$2,
        nameEnglish: d.$3,
        startPage: d.$4,
        endPage: d.$5,
        surahNumbers: surahNums,
      );
    }).toList();
  }

  void _buildHizbIndex() {
    hizbList = [];
    for (int i = 0; i < 60; i++) {
      final hizbNum = i + 1;
      final startPage = (i * 10) + 1;
      hizbList.add(HizbIndex(
        number: hizbNum,
        startPage: startPage.clamp(1, 604),
      ));
    }
  }

  void _buildPageIndex() {
    final Map<int, List<int>> pageSurahs = {};
    final Map<int, int> pageJuz = {};
    for (final ayah in allAyahs) {
      final pageNum = ayah['page'] as int? ?? 0;
      if (pageNum < 1 || pageNum > 604) continue;
      final surahNo = ayah['sura_no'] as int? ?? 0;
      final juz = ayah['jozz'] as int? ?? 1;
      pageSurahs.putIfAbsent(pageNum, () => []).add(surahNo);
      pageJuz[pageNum] = juz;
    }
    pages = List.generate(604, (i) {
      final pageNum = i + 1;
      final surahNums = pageSurahs[pageNum];
      return PageInfo(
        pageNumber: pageNum,
        juz: pageJuz[pageNum] ?? 1,
        hizb: ((pageNum - 1) ~/ 10) + 1,
        surahNumbers: surahNums != null ? (surahNums.toList()..sort()) : const [],
      );
    });
  }

  SurahIndex? getSurah(int number) {
    if (number < 1 || number > surahs.length) return null;
    return surahs[number - 1];
  }

  int? getPageForSurahAyah(int surahNumber, int ayahNumber) {
    for (final ayah in allAyahs) {
      if ((ayah['sura_no'] as int? ?? 0) == surahNumber &&
          (ayah['aya_no'] as int? ?? 0) == ayahNumber) {
        return ayah['page'] as int?;
      }
    }
    return null;
  }

  PageInfo? getPageInfo(int pageNumber) {
    if (pageNumber < 1 || pageNumber > pages.length) return null;
    return pages[pageNumber - 1];
  }

  List<Map<String, dynamic>> searchAyahs(String query) {
    if (query.trim().isEmpty) return [];
    final q = query.trim();
    return allAyahs
        .where((a) => (a['aya_text'] as String? ?? '').contains(q))
        .take(100)
        .toList();
  }

  List<Map<String, dynamic>> getAyahsForPage(int page) {
    return allAyahs
        .where((a) => (a['page'] as int? ?? 0) == page)
        .toList();
  }
}

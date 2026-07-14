import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../core/arabic_strings.dart';
import '../models/models.dart';
import '../models/api_models.dart';
import 'storage_service.dart';
import 'api_service.dart';

class DataService {
  static List<VerseModel> _verses = [];
  static List<HadithModel> _hadiths = [];
  static List<SurahInfo> _surahList = [];

  static bool _versesLoaded = false;
  static bool _hadithsLoaded = false;
  static bool _surahListLoaded = false;

  static Completer<void>? _versesCompleter;
  static Completer<void>? _hadithsCompleter;

  /// Ensure verses are loaded. Called lazily on first access.
  /// MUST NEVER throw or deadlock.
  static Future<void> _ensureVersesLoaded() async {
    if (_versesLoaded) return;
    if (_versesCompleter != null) return _versesCompleter!.future;
    _versesCompleter = Completer<void>();
    try {
      await _loadVerses().timeout(
        const Duration(seconds: 5),
        onTimeout: () => debugPrint('[DataService] _ensureVersesLoaded timed out'),
      );
    } catch (e) {
      debugPrint('[DataService] _ensureVersesLoaded error: $e');
    } finally {
      _versesLoaded = true;
      if (_versesCompleter != null && !_versesCompleter!.isCompleted) {
        _versesCompleter!.complete();
      }
      _versesCompleter = null;
    }
  }

  /// Ensure hadiths are loaded. Called lazily on first access.
  /// MUST NEVER throw or deadlock.
  static Future<void> _ensureHadithsLoaded() async {
    if (_hadithsLoaded) return;
    if (_hadithsCompleter != null) return _hadithsCompleter!.future;
    _hadithsCompleter = Completer<void>();
    try {
      await _loadHadiths().timeout(
        const Duration(seconds: 5),
        onTimeout: () => debugPrint('[DataService] _ensureHadithsLoaded timed out'),
      );
    } catch (e) {
      debugPrint('[DataService] _ensureHadithsLoaded error: $e');
    } finally {
      _hadithsLoaded = true;
      if (_hadithsCompleter != null && !_hadithsCompleter!.isCompleted) {
        _hadithsCompleter!.complete();
      }
      _hadithsCompleter = null;
    }
  }

  /// Initialize only local data needed at startup (no network).
  /// This is optional now — data loads lazily on first access.
  static Future<void> init() async {
    debugPrint('[DataService] init() started');
    final sw = Stopwatch()..start();
    try {
      await Future.wait([
        _ensureVersesLoaded(),
        _ensureHadithsLoaded(),
      ]);
    } catch (e) {
      debugPrint('[DataService] init() error: $e');
    }
    sw.stop();
    debugPrint('[DataService] init() done: ${sw.elapsedMilliseconds} ms');
  }

  static Future<void> _loadVerses() async {
    try {
      final data = await rootBundle.loadString('assets/data/verses.json').timeout(
        const Duration(seconds: 3),
        onTimeout: () {
          debugPrint('[DataService] verses.json load timed out');
          return '{"verses":[]}';
        },
      );
      final List<dynamic> jsonList = json.decode(data);
      _verses = jsonList.map((json) => VerseModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint('[DataService] _loadVerses failed: $e');
      _verses = _getDefaultVerses();
    }
  }

  static Future<void> _loadHadiths() async {
    try {
      final data = await rootBundle.loadString('assets/data/hadiths.json').timeout(
        const Duration(seconds: 3),
        onTimeout: () {
          debugPrint('[DataService] hadiths.json load timed out');
          return '{"hadiths":[]}';
        },
      );
      final List<dynamic> jsonList = json.decode(data);
      _hadiths = jsonList.map((json) => HadithModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint('[DataService] _loadHadiths failed: $e');
      _hadiths = _getDefaultHadiths();
    }
  }

  static Future<void> loadSurahList() async {
    if (_surahListLoaded) return;
    try {
      final result = await AlQuranApiService.getAllSurahs();
      if (result != null) {
        _surahList = result;
      }
      _surahListLoaded = true;
    } catch (_) {
      _surahListLoaded = true;
    }
  }

  static List<VerseModel> get allVerses {
    if (!_versesLoaded && _verses.isEmpty) {
      // Return defaults synchronously if not loaded yet
      _verses = _getDefaultVerses();
    }
    return _verses;
  }

  static List<HadithModel> get allHadiths {
    if (!_hadithsLoaded && _hadiths.isEmpty) {
      _hadiths = _getDefaultHadiths();
    }
    return _hadiths;
  }

  static List<SurahInfo> get surahList => _surahList;

  static Future<Map<String, String>> getDailyVerseFromApi() async {
    try {
      final editions = await AlQuranApiService.getRandomAyahEditions();
      if (editions != null && editions.isNotEmpty) {
        final ayah = editions.firstWhere(
          (e) => e.edition?.identifier == 'quran-uthmani',
          orElse: () => editions.first,
        );
        return {
          'arabic': ayah.text,
          'surahArabic': ayah.surah?.name ?? '',
          'verseNumber': ayah.numberInSurah.toString(),
          'surahNumber': (ayah.surah?.number ?? 0).toString(),
          'juz': ayah.juz.toString(),
        };
      }
    } catch (_) {}
    return {};
  }

  static VerseModel getDailyVerse() {
    final verses = allVerses;
    final lastIndex = StorageService.getLastVerseIndex() ?? -1;
    int nextIndex;
    if (verses.isEmpty) {
      return _getDefaultVerses().first;
    }
    if (lastIndex < 0 || lastIndex >= verses.length - 1) {
      nextIndex = Random().nextInt(verses.length);
    } else {
      nextIndex = lastIndex + 1;
    }
    StorageService.setLastVerseIndex(nextIndex);
    return verses[nextIndex];
  }

  static HadithModel getDailyHadith() {
    final hadiths = allHadiths;
    final lastIndex = StorageService.getLastHadithIndex() ?? -1;
    int nextIndex;
    if (hadiths.isEmpty) {
      return _getDefaultHadiths().first;
    }
    if (lastIndex < 0 || lastIndex >= hadiths.length - 1) {
      nextIndex = Random().nextInt(hadiths.length);
    } else {
      nextIndex = lastIndex + 1;
    }
    StorageService.setLastHadithIndex(nextIndex);
    return hadiths[nextIndex];
  }

  static Future<List<SearchMatch>> searchQuran(String query) async {
    try {
      final result = await AlQuranApiService.searchQuran(query);
      if (result != null && result.matches.isNotEmpty) {
        return result.matches;
      }
    } catch (_) {}
    return [];
  }

  static Future<SurahFullData?> getSurahFromApi(int number) async {
    try {
      final result = await AlQuranApiService.getSurah(number);
      if (result != null) {
        return result.data;
      }
    } catch (_) {}
    return null;
  }

  static Future<JuzData?> getJuzFromApi(int number) async {
    try {
      final result = await AlQuranApiService.getJuz(number);
      if (result != null) {
        return result.data;
      }
    } catch (_) {}
    return null;
  }

  static List<VerseModel> searchVerses(String query) {
    return allVerses
        .where((v) =>
            v.textArabic.contains(query) ||
            v.surahNameArabic.contains(query))
        .toList();
  }

  static List<HadithModel> searchHadiths(String query) {
    return allHadiths
        .where((h) =>
            h.textArabic.contains(query) ||
            h.source.contains(query))
        .toList();
  }

  static List<VerseModel> _getDefaultVerses() {
    return [
      VerseModel(
        id: 1, surahNumber: 2, surahName: 'البقرة', surahNameArabic: 'البقرة',
        verseNumber: 255,
        textArabic: 'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ',
        juz: 3,
      ),
      VerseModel(
        id: 2, surahNumber: 36, surahName: 'يس', surahNameArabic: 'يس',
        verseNumber: 82,
        textArabic: 'إِنَّمَا أَمْرُهُ إِذَا أَرَادَ شَيْئًا أَن يَقُولَ لَهُ كُن فَيَكُونُ',
        juz: 22,
      ),
      VerseModel(
        id: 3, surahNumber: 94, surahName: 'الشرح', surahNameArabic: 'الشرح',
        verseNumber: 5,
        textArabic: 'فَإِنَّ مَعَ الْعُسْرِ يُسْرًا',
        juz: 30,
      ),
      VerseModel(
        id: 4, surahNumber: 2, surahName: 'البقرة', surahNameArabic: 'البقرة',
        verseNumber: 286,
        textArabic: 'لَا يُكَلِّفُ اللَّهُ نَفْسًا إِلَّا وُسْعَهَا',
        juz: 3,
      ),
      VerseModel(
        id: 5, surahNumber: 93, surahName: 'الضحى', surahNameArabic: 'الضحى',
        verseNumber: 3,
        textArabic: 'مَا وَدَّعَكَ رَبُّكَ وَمَا قَلَىٰ',
        juz: 30,
      ),
      VerseModel(
        id: 6, surahNumber: 112, surahName: 'الإخلاص', surahNameArabic: 'الإخلاص',
        verseNumber: 1,
        textArabic: 'قُلْ هُوَ اللَّهُ أَحَدٌ',
        juz: 30,
      ),
      VerseModel(
        id: 7, surahNumber: 1, surahName: 'الفاتحة', surahNameArabic: 'الفاتحة',
        verseNumber: 2,
        textArabic: 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
        juz: 1,
      ),
      VerseModel(
        id: 8, surahNumber: 55, surahName: 'الرحمن', surahNameArabic: 'الرحمن',
        verseNumber: 13,
        textArabic: 'فَبِأَيِّ آلَاءِ رَبِّكُمَا تُكَذِّبَانِ',
        juz: 27,
      ),
    ];
  }

  static List<HadithModel> _getDefaultHadiths() {
    return [
      HadithModel(
        id: 1, textArabic: 'إنما الأعمال بالنيات وإنما لكل امرئ ما نوى',
        source: Ar.sourceSahihBukhari, narrator: Ar.narratorUthman,
        bookNumber: 1, hadithNumber: 1, grade: Ar.sourceSahih,
      ),
      HadithModel(
        id: 2, textArabic: 'خيركم من تعلم القرآن وعلمه',
        source: Ar.sourceSahihBukhari, narrator: Ar.narratorUthman,
        bookNumber: 6, hadithNumber: 545, grade: Ar.sourceSahih,
      ),
      HadithModel(
        id: 3, textArabic: 'لا يؤمن أحدكم حتى يحب لأخيه ما يحب لنفسه',
        source: Ar.sourceSahihBukhari, narrator: Ar.narratorAnas,
        bookNumber: 2, hadithNumber: 13, grade: Ar.sourceSahih,
      ),
      HadithModel(
        id: 4, textArabic: 'إن الله جميل يحب الجمال',
        source: Ar.sourceSahihMuslim, narrator: Ar.narratorAbuHurairah,
        bookNumber: 1, hadithNumber: 91, grade: Ar.sourceSahih,
      ),
      HadithModel(
        id: 5, textArabic: 'أحب الأعمال إلى الله أدومها وإن قل',
        source: Ar.sourceSahihBukhari, narrator: Ar.narratorAisha,
        bookNumber: 81, hadithNumber: 471, grade: Ar.sourceSahih,
      ),
    ];
  }
}

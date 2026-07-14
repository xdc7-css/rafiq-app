import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../features/hadith/data/models/aqwal_model.dart';
import '../features/hadith/data/datasources/hadith_local_source.dart';
import '../database/local_database.dart';
import '../services/data_service.dart';
import '../services/storage_service.dart';

const _imamNarrators = {
  1: 'الإمام علي بن أبي طالب (ع)',
  2: 'الإمام الحسن المجتبى (ع)',
  3: 'الإمام الحسين سيد الشهداء (ع)',
  4: 'الإمام زين العابدين (ع)',
  5: 'الإمام محمد الباقر (ع)',
  6: 'الإمام جعفر الصادق (ع)',
  7: 'الإمام موسى الكاظم (ع)',
  8: 'الإمام علي الرضا (ع)',
  9: 'الإمام محمد الجواد (ع)',
  10: 'الإمام علي الهادي (ع)',
  11: 'الإمام الحسن العسكري (ع)',
  12: 'الإمام المهدي (عج)',
};

HadithModel _aqwalToHadith(AqwalModel a) {
  return HadithModel(
    id: a.id,
    textArabic: a.text,
    narrator: _imamNarrators[a.imamId] ?? '',
    source: a.source,
    category: a.topic,
    categoryId: 'imam_${a.imamId}',
  );
}

class DailyVerseNotifier extends StateNotifier<VerseModel> {
  bool _loaded = false;

  DailyVerseNotifier() : super(DataService.getDailyVerse()) {
    _loadAsync();
  }

  Future<void> _loadAsync() async {
    if (_loaded) return;
    await DataService.init();
    _loaded = true;
    state = DataService.getDailyVerse();
  }

  void refresh() {
    state = DataService.getDailyVerse();
  }

  VerseModel getRandomVerse() {
    final verses = DataService.allVerses;
    if (verses.isEmpty) return state;
    return verses[Random().nextInt(verses.length)];
  }
}

final dailyVerseNotifierProvider =
    StateNotifierProvider<DailyVerseNotifier, VerseModel>((ref) {
  return DailyVerseNotifier();
});

class DailyHadithNotifier extends StateNotifier<HadithModel> {
  final HadithLocalSource _source = HadithLocalSource();
  int _lastIndex = -1;
  bool _disposed = false;
  bool _loaded = false;

  DailyHadithNotifier() : super(_defaultHadith()) {
    _loadAsync();
  }

  static HadithModel _defaultHadith() {
    final src = HadithLocalSource();
    final daily = src.getDailyHadith();
    if (daily != null) return _aqwalToHadith(daily);
    return HadithModel(id: 1, textArabic: 'خير ما نبدأ به هو ذكر الله');
  }

  Future<void> _loadAsync() async {
    if (_loaded || _disposed) return;
    _loaded = true;
    try {
      await _source.loadAllAhadith();
    } catch (_) {}
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void refresh() async {
    int fromStorage = StorageService.getLastHadithIndex() ?? -1;
    final db = LocalDatabaseService.instance;
    if (db.isInitialized) {
      final dc = await db.getDailyContent();
      if (dc != null && dc.lastHadithIndex >= 0) {
        fromStorage = dc.lastHadithIndex;
      }
    }
    if (fromStorage >= 0) _lastIndex = fromStorage;
    _source.loadAllAhadith().then((list) async {
      if (_disposed || list.isEmpty) return;
      int next;
      if (_lastIndex < 0 || _lastIndex >= list.length - 1) {
        next = Random().nextInt(list.length);
      } else {
        next = _lastIndex + 1;
      }
      _lastIndex = next;
      StorageService.setLastHadithIndex(next);
      if (db.isInitialized) {
        final existing = await db.getDailyContent();
        final dc = existing ?? DailyContentEntry(
          lastVerseIndex: 0,
          lastHadithIndex: 0,
          lastVerseDate: '',
          lastHadithDate: '',
        );
        dc.lastHadithIndex = next;
        await db.saveDailyContent(dc);
      }
      state = _aqwalToHadith(list[next]);
    });
  }

  HadithModel getRandomHadith() {
    final all = DataService.allHadiths;
    if (all.isEmpty) return state;
    return all[Random().nextInt(all.length)];
  }
}

final dailyHadithNotifierProvider =
    StateNotifierProvider<DailyHadithNotifier, HadithModel>((ref) {
  return DailyHadithNotifier();
});

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchVersesProvider = Provider<List<VerseModel>>((ref) {
  final query = ref.watch(searchQueryProvider);
  if (query.isEmpty) return [];
  return DataService.searchVerses(query);
});

final searchHadithsProvider = Provider<List<HadithModel>>((ref) {
  final query = ref.watch(searchQueryProvider);
  if (query.isEmpty) return [];
  return DataService.searchHadiths(query);
});

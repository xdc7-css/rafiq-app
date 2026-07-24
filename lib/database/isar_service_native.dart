import 'package:flutter/foundation.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'collections.dart';

class IsarService {
  static Isar? _instance;
  static bool _initialized = false;

  static Future<Isar> getInstance() async {
    if (_instance != null && _instance!.isOpen) {
      debugPrint('[IsarService] getInstance: returning existing open instance');
      return _instance!;
    }
    debugPrint('[IsarService] getInstance: opening new Isar instance...');
    try {
      final dir = await getApplicationDocumentsDirectory();
      debugPrint('[IsarService] Application documents dir: ${dir.path}');
      _instance = await Isar.open(
        [
          SettingsIsarSchema,
          FavoriteIsarSchema,
          BookmarkIsarSchema,
          ReadingProgressIsarSchema,
          KhatmahIsarSchema,
          TasbeehIsarSchema,
          AdhkarStateIsarSchema,
          PrayerTimesCacheIsarSchema,
          CacheEntryIsarSchema,
          AudioStateIsarSchema,
          RecentlyPlayedIsarSchema,
          TasbihStatsIsarSchema,
          TasbihHistoryIsarSchema,
          CustomTasbihIsarSchema,
          DailyContentIsarSchema,
          SearchHistoryIsarSchema,
          MemorialIsarSchema,
          RewardIsarSchema,
          QuranSvgPageIsarSchema,
          DownloadStateIsarSchema,
        ],
        directory: dir.path,
      );
      _initialized = true;
      debugPrint('[IsarService] Database opened successfully at ${dir.path}');
      return _instance!;
    } catch (e, st) {
      debugPrint('[IsarService] FAILED to open Isar database: $e');
      debugPrint('[IsarService] Stack trace: $st');
      rethrow;
    }
  }

  static bool get isInitialized => _initialized && _instance?.isOpen == true;

  static Future<void> close() async {
    await _instance?.close();
    _instance = null;
    _initialized = false;
  }

  static Future<Isar> _getDb() async {
    if (_instance != null && _instance!.isOpen) return _instance!;
    return getInstance();
  }

  static IsarCollection<FavoriteIsar> get favorites => _instance!.collection<FavoriteIsar>();
  static IsarCollection<BookmarkIsar> get bookmarks => _instance!.collection<BookmarkIsar>();
  static IsarCollection<TasbeehIsar> get tasbeeh => _instance!.collection<TasbeehIsar>();
  static IsarCollection<AdhkarStateIsar> get adhkarState => _instance!.collection<AdhkarStateIsar>();
  static IsarCollection<TasbihHistoryIsar> get tasbihHistory => _instance!.collection<TasbihHistoryIsar>();
  static IsarCollection<CustomTasbihIsar> get customTasbih => _instance!.collection<CustomTasbihIsar>();

  // ── Settings ──────────────────────────────────────────────────────────────
  static Future<IsarCollection<SettingsIsar>> _settings() async =>
      (await _getDb()).collection<SettingsIsar>();

  static Future<SettingsIsar?> getSettings() async {
    final col = await _settings();
    return col.where().findFirst();
  }

  static Future<void> saveSettings(String jsonString) async {
    final db = await _getDb();
    final col = db.collection<SettingsIsar>();
    final existing = await col.where().findFirst();
    await db.writeTxn(() async {
      if (existing != null) {
        existing.data = jsonString;
        existing.updatedAt = DateTime.now();
        await col.put(existing);
      } else {
        final entry = SettingsIsar()
          ..data = jsonString
          ..updatedAt = DateTime.now();
        await col.put(entry);
      }
    });
  }

  // ── Favorites ─────────────────────────────────────────────────────────────
  static Future<IsarCollection<FavoriteIsar>> _favorites() async =>
      (await _getDb()).collection<FavoriteIsar>();

  static Future<List<FavoriteIsar>> getAllFavorites() async {
    final col = await _favorites();
    return col.where().findAll();
  }

  static Future<FavoriteIsar?> getFavoriteByKey(String uniqueKey) async {
    final col = await _favorites();
    return col.where().uniqueKeyEqualTo(uniqueKey).findFirst();
  }

  static Future<void> putFavorite(FavoriteIsar fav) async {
    final db = await _getDb();
    final col = db.collection<FavoriteIsar>();
    await db.writeTxn(() async {
      await col.put(fav);
    });
  }

  static Future<void> deleteFavoriteByKey(String uniqueKey) async {
    final db = await _getDb();
    final col = db.collection<FavoriteIsar>();
    await db.writeTxn(() async {
      final fav = await col.where().uniqueKeyEqualTo(uniqueKey).findFirst();
      if (fav != null) {
        await col.delete(fav.id);
      }
    });
  }

  // ── Bookmarks ─────────────────────────────────────────────────────────────
  static Future<IsarCollection<BookmarkIsar>> _bookmarks() async =>
      (await _getDb()).collection<BookmarkIsar>();

  static Future<List<BookmarkIsar>> getAllBookmarks() async {
    final col = await _bookmarks();
    return col.where().findAll();
  }

  static Future<void> putBookmark(BookmarkIsar bm) async {
    final db = await _getDb();
    final col = db.collection<BookmarkIsar>();
    await db.writeTxn(() async {
      await col.put(bm);
    });
  }

  static Future<void> deleteBookmarkByKey(String uniqueKey) async {
    final db = await _getDb();
    final col = db.collection<BookmarkIsar>();
    await db.writeTxn(() async {
      final bm = await col.where().uniqueKeyEqualTo(uniqueKey).findFirst();
      if (bm != null) {
        await col.delete(bm.id);
      }
    });
  }

  // ── Reading Progress ──────────────────────────────────────────────────────
  static Future<IsarCollection<ReadingProgressIsar>> _readingProgress() async =>
      (await _getDb()).collection<ReadingProgressIsar>();

  static Future<ReadingProgressIsar?> getReadingProgress(String bookId) async {
    final col = await _readingProgress();
    return col.where().bookIdEqualTo(bookId).findFirst();
  }

  static Future<void> putReadingProgress(ReadingProgressIsar rp) async {
    final db = await _getDb();
    final col = db.collection<ReadingProgressIsar>();
    await db.writeTxn(() async {
      await col.put(rp);
    });
  }

  // ── Khatmah ───────────────────────────────────────────────────────────────
  static Future<IsarCollection<KhatmahIsar>> _khatmah() async =>
      (await _getDb()).collection<KhatmahIsar>();

  static Future<KhatmahIsar?> getCurrentKhatmah() async {
    final col = await _khatmah();
    return col.get(1);
  }

  static Future<void> saveKhatmah(KhatmahIsar k) async {
    k.id = 1;
    final db = await _getDb();
    final col = db.collection<KhatmahIsar>();
    await db.writeTxn(() async {
      await col.put(k);
    });
  }

  static Future<void> deleteKhatmah() async {
    final db = await _getDb();
    final col = db.collection<KhatmahIsar>();
    await db.writeTxn(() async {
      await col.delete(1);
    });
  }

  // ── Tasbeeh ───────────────────────────────────────────────────────────────
  static Future<IsarCollection<TasbeehIsar>> _tasbeeh() async =>
      (await _getDb()).collection<TasbeehIsar>();

  static Future<List<TasbeehIsar>> getAllTasbeeh() async {
    final col = await _tasbeeh();
    return col.where().findAll();
  }

  static Future<void> putTasbeeh(TasbeehIsar t) async {
    final db = await _getDb();
    final col = db.collection<TasbeehIsar>();
    await db.writeTxn(() async {
      await col.put(t);
    });
  }

  static Future<void> deleteTasbeehByKey(String uniqueKey) async {
    final db = await _getDb();
    final col = db.collection<TasbeehIsar>();
    await db.writeTxn(() async {
      final t = await col.where().uniqueKeyEqualTo(uniqueKey).findFirst();
      if (t != null) {
        await col.delete(t.id);
      }
    });
  }

  // ── Adhkar State ──────────────────────────────────────────────────────────
  static Future<IsarCollection<AdhkarStateIsar>> _adhkarState() async =>
      (await _getDb()).collection<AdhkarStateIsar>();

  static Future<List<AdhkarStateIsar>> getAllAdhkarState() async {
    final col = await _adhkarState();
    return col.where().findAll();
  }

  static Future<AdhkarStateIsar?> getAdhkarState(String uniqueKey) async {
    final col = await _adhkarState();
    return col.where().uniqueKeyEqualTo(uniqueKey).findFirst();
  }

  static Future<void> putAdhkarState(AdhkarStateIsar a) async {
    final db = await _getDb();
    final col = db.collection<AdhkarStateIsar>();
    await db.writeTxn(() async {
      await col.put(a);
    });
  }

  static Future<void> putAllAdhkarState(List<AdhkarStateIsar> list) async {
    final db = await _getDb();
    final col = db.collection<AdhkarStateIsar>();
    await db.writeTxn(() async {
      await col.putAll(list);
    });
  }

  // ── Prayer Times Cache ────────────────────────────────────────────────────
  static Future<IsarCollection<PrayerTimesCacheIsar>> _prayerTimesCache() async =>
      (await _getDb()).collection<PrayerTimesCacheIsar>();

  static Future<PrayerTimesCacheIsar?> getCachedPrayerTimes(String key) async {
    final col = await _prayerTimesCache();
    return col.where().dateLocationKeyEqualTo(key).findFirst();
  }

  static Future<void> cachePrayerTimes(PrayerTimesCacheIsar pt) async {
    final db = await _getDb();
    final col = db.collection<PrayerTimesCacheIsar>();
    await db.writeTxn(() async {
      await col.put(pt);
    });
  }

  // ── Generic Cache ─────────────────────────────────────────────────────────
  static Future<IsarCollection<CacheEntryIsar>> _cacheEntries() async =>
      (await _getDb()).collection<CacheEntryIsar>();

  static Future<CacheEntryIsar?> getCacheEntry(String key) async {
    final col = await _cacheEntries();
    final entry = await col.where().cacheKeyEqualTo(key).findFirst();
    if (entry == null) return null;
    if (entry.expiresAt.isBefore(DateTime.now())) {
      final db = await _getDb();
      await db.writeTxn(() async {
        await col.delete(entry.id);
      });
      return null;
    }
    return entry;
  }

  static Future<void> putCacheEntry(CacheEntryIsar entry) async {
    final db = await _getDb();
    final col = db.collection<CacheEntryIsar>();
    await db.writeTxn(() async {
      await col.put(entry);
    });
  }

  static Future<void> clearExpiredCache() async {
    final col = await _cacheEntries();
    final now = DateTime.now();
    final expired = await col
        .where()
        .filter()
        .expiresAtLessThan(now)
        .findAll();
    if (expired.isEmpty) return;
    final db = await _getDb();
    await db.writeTxn(() async {
      final ids = expired.map((e) => e.id).toList();
      await col.deleteAll(ids);
    });
  }

  // ── Audio State ───────────────────────────────────────────────────────────
  static Future<IsarCollection<AudioStateIsar>> _audioState() async =>
      (await _getDb()).collection<AudioStateIsar>();

  static Future<AudioStateIsar?> getAudioState() async {
    final col = await _audioState();
    return col.get(1);
  }

  static Future<void> saveAudioState(AudioStateIsar s) async {
    s.id = 1;
    final db = await _getDb();
    final col = db.collection<AudioStateIsar>();
    await db.writeTxn(() async {
      await col.put(s);
    });
  }

  // ── Recently Played ───────────────────────────────────────────────────────
  static Future<IsarCollection<RecentlyPlayedIsar>> _recentlyPlayed() async =>
      (await _getDb()).collection<RecentlyPlayedIsar>();

  static Future<List<RecentlyPlayedIsar>> getAllRecentlyPlayed() async {
    final col = await _recentlyPlayed();
    return col.where().findAll();
  }

  static Future<void> putRecentlyPlayed(RecentlyPlayedIsar rp) async {
    final db = await _getDb();
    final col = db.collection<RecentlyPlayedIsar>();
    await db.writeTxn(() async {
      await col.put(rp);
    });
  }

  // ── Tasbih Stats ──────────────────────────────────────────────────────────
  static Future<IsarCollection<TasbihStatsIsar>> _tasbihStats() async =>
      (await _getDb()).collection<TasbihStatsIsar>();

  static Future<TasbihStatsIsar?> getTasbihStats() async {
    final col = await _tasbihStats();
    return col.get(1);
  }

  static Future<void> saveTasbihStats(TasbihStatsIsar s) async {
    s.id = 1;
    final db = await _getDb();
    final col = db.collection<TasbihStatsIsar>();
    await db.writeTxn(() async {
      await col.put(s);
    });
  }

  // ── Tasbih History ────────────────────────────────────────────────────────
  static Future<IsarCollection<TasbihHistoryIsar>> _tasbihHistory() async =>
      (await _getDb()).collection<TasbihHistoryIsar>();

  static Future<List<TasbihHistoryIsar>> getAllTasbihHistory() async {
    final col = await _tasbihHistory();
    return col.where().findAll();
  }

  static Future<void> putTasbihHistory(TasbihHistoryIsar h) async {
    final db = await _getDb();
    final col = db.collection<TasbihHistoryIsar>();
    await db.writeTxn(() async {
      await col.put(h);
    });
  }

  static Future<void> clearTasbihHistory() async {
    final db = await _getDb();
    final col = db.collection<TasbihHistoryIsar>();
    await db.writeTxn(() async {
      await col.clear();
    });
  }

  // ── Custom Tasbih ─────────────────────────────────────────────────────────
  static Future<IsarCollection<CustomTasbihIsar>> _customTasbih() async =>
      (await _getDb()).collection<CustomTasbihIsar>();

  static Future<List<CustomTasbihIsar>> getAllCustomTasbih() async {
    final col = await _customTasbih();
    return col.where().findAll();
  }

  static Future<void> putCustomTasbih(CustomTasbihIsar c) async {
    final db = await _getDb();
    final col = db.collection<CustomTasbihIsar>();
    await db.writeTxn(() async {
      await col.put(c);
    });
  }

  static Future<void> deleteCustomTasbihByKey(String uniqueKey) async {
    final db = await _getDb();
    final col = db.collection<CustomTasbihIsar>();
    await db.writeTxn(() async {
      final c = await col.where().uniqueKeyEqualTo(uniqueKey).findFirst();
      if (c != null) {
        await col.delete(c.id);
      }
    });
  }

  // ── Daily Content ─────────────────────────────────────────────────────────
  static Future<IsarCollection<DailyContentIsar>> _dailyContent() async =>
      (await _getDb()).collection<DailyContentIsar>();

  static Future<DailyContentIsar?> getDailyContent() async {
    final col = await _dailyContent();
    return col.get(1);
  }

  static Future<void> saveDailyContent(DailyContentIsar d) async {
    d.id = 1;
    final db = await _getDb();
    final col = db.collection<DailyContentIsar>();
    await db.writeTxn(() async {
      await col.put(d);
    });
  }

  // ── Search History ────────────────────────────────────────────────────────
  static Future<IsarCollection<SearchHistoryIsar>> _searchHistory() async =>
      (await _getDb()).collection<SearchHistoryIsar>();

  static Future<List<SearchHistoryIsar>> getRecentSearches({int limit = 20}) async {
    final col = await _searchHistory();
    return col.where().sortBySearchedAtDesc().limit(limit).findAll();
  }

  static Future<void> addSearchHistory(String query, {int resultCount = 0}) async {
    final db = await _getDb();
    final col = db.collection<SearchHistoryIsar>();
    await db.writeTxn(() async {
      await col.put(SearchHistoryIsar()
        ..query = query
        ..searchedAt = DateTime.now()
        ..resultCount = resultCount);
    });
  }

  static Future<void> clearSearchHistory() async {
    final db = await _getDb();
    final col = db.collection<SearchHistoryIsar>();
    await db.writeTxn(() async {
      await col.clear();
    });
  }

  // ── Memorials (Mercy Register) ──────────────────────────────────────
  static Future<IsarCollection<MemorialIsar>> _memorials() async =>
      (await _getDb()).collection<MemorialIsar>();

  static Future<List<MemorialIsar>> getMemorials({
    String? userId,
    int limit = 20,
    int offset = 0,
  }) async {
    final col = await _memorials();
    final base = col.where();
    if (userId != null) {
      return base.filter().userIdEqualTo(userId)
          .sortByUpdatedAtMsDesc()
          .offset(offset)
          .limit(limit)
          .findAll();
    }
    return base.sortByUpdatedAtMsDesc()
        .offset(offset)
        .limit(limit)
        .findAll();
  }

  static Stream<List<MemorialIsar>> watchMemorials({String? userId}) async* {
    final col = await _memorials();
    final base = col.where();
    if (userId != null) {
      yield* base.filter().userIdEqualTo(userId)
          .sortByUpdatedAtMsDesc()
          .watch(fireImmediately: true);
    }
    yield* base.sortByUpdatedAtMsDesc()
        .watch(fireImmediately: true);
  }

  static Future<MemorialIsar?> getMemorialByMemorialId(String memorialId) async {
    final col = await _memorials();
    return col.where().memorialIdEqualTo(memorialId).findFirst();
  }

  static Future<void> putMemorial(MemorialIsar m) async {
    debugPrint('[IsarService.putMemorial] STEP 1: Starting putMemorial for memorialId="${m.memorialId}"');
    debugPrint('[IsarService.putMemorial] STEP 2: Verifying object fields: '
        'id=${m.id}, deceasedName="${m.deceasedName}", deceasedNameArabic="${m.deceasedNameArabic}", '
        'dateOfDeathMs=${m.dateOfDeathMs}, prayerCount=${m.prayerCount}, duaCount=${m.duaCount}, '
        'khatmahCount=${m.khatmahCount}, tasbeehCount=${m.tasbeehCount}, createdAtMs=${m.createdAtMs}, '
        'updatedAtMs=${m.updatedAtMs}, userId="${m.userId}", isPublic=${m.isPublic}, '
        'typeIndex=${m.typeIndex}, surahNumber=${m.surahNumber}, duaText="${m.duaText}", '
        'photoUrl="${m.photoUrl}", searchName="${m.searchName}", searchNameArabic="${m.searchNameArabic}"');

    try {
      debugPrint('[IsarService.putMemorial] STEP 3: Getting database via _getDb()...');
      final db = await _getDb();
      debugPrint('[IsarService.putMemorial] STEP 4: _getDb() returned db. isOpen=${db.isOpen}');

      debugPrint('[IsarService.putMemorial] STEP 5: Getting collection<MemorialIsar>()...');
      final col = db.collection<MemorialIsar>();
      debugPrint('[IsarService.putMemorial] STEP 6: collection obtained: name=${col.name}');

      debugPrint('[IsarService.putMemorial] STEP 7: Starting db.writeTxn...');
      await db.writeTxn(() async {
        debugPrint('[IsarService.putMemorial] STEP 8: Executing col.put(m)...');
        final generatedId = await col.put(m);
        debugPrint('[IsarService.putMemorial] STEP 9: col.put(m) completed successfully. Assigned ID=$generatedId');
      });
      debugPrint('[IsarService.putMemorial] STEP 10: writeTxn completed successfully.');
    } catch (e, st) {
      debugPrint('[IsarService.putMemorial] EXCEPTION ENCOUNTERED: $e');
      debugPrint('[IsarService.putMemorial] Stack trace:\n$st');
      rethrow;
    }
  }

  static Future<void> deleteMemorialByMemorialId(String memorialId) async {
    final db = await _getDb();
    final memCol = db.collection<MemorialIsar>();
    final rewCol = db.collection<RewardIsar>();
    await db.writeTxn(() async {
      final m = await memCol.where().memorialIdEqualTo(memorialId).findFirst();
      if (m != null) {
        await memCol.delete(m.id);
        final relatedRewards = await rewCol
            .where()
            .filter()
            .memorialIdEqualTo(memorialId)
            .findAll();
        if (relatedRewards.isNotEmpty) {
          await rewCol.deleteAll(relatedRewards.map((r) => r.id).toList());
        }
      }
    });
  }

  // ── Rewards (Mercy Register) ────────────────────────────────────────
  static Future<IsarCollection<RewardIsar>> _rewards() async =>
      (await _getDb()).collection<RewardIsar>();

  static Future<List<RewardIsar>> getRewardsByMemorialId(
    String memorialId, {
    int limit = 50,
  }) async {
    final col = await _rewards();
    return col
        .where()
        .filter()
        .memorialIdEqualTo(memorialId)
        .sortByCreatedAtMsDesc()
        .limit(limit)
        .findAll();
  }

  static Future<void> putReward(RewardIsar r) async {
    final db = await _getDb();
    final col = db.collection<RewardIsar>();
    await db.writeTxn(() async {
      await col.put(r);
    });
  }

  static Future<int> getTotalPrayerCount(String memorialId) async {
    final m = await getMemorialByMemorialId(memorialId);
    return m?.prayerCount ?? 0;
  }

  // ── Quran SVG Pages ─────────────────────────────────────────────────────
  static Future<IsarCollection<QuranSvgPageIsar>> _quranSvgPages() async =>
      (await _getDb()).collection<QuranSvgPageIsar>();

  static Future<QuranSvgPageIsar?> getQuranSvgPage(int pageNumber) async {
    final col = await _quranSvgPages();
    return col.where().pageNumberEqualTo(pageNumber).findFirst();
  }

  static Future<void> putQuranSvgPage(int pageNumber, String svgContent) async {
    final db = await _getDb();
    final col = db.collection<QuranSvgPageIsar>();
    await db.writeTxn(() async {
      final existing = await col.where().pageNumberEqualTo(pageNumber).findFirst();
      if (existing != null) {
        existing.svgContent = svgContent;
        existing.cachedAt = DateTime.now();
        await col.put(existing);
      } else {
        await col.put(QuranSvgPageIsar()
          ..pageNumber = pageNumber
          ..svgContent = svgContent
          ..cachedAt = DateTime.now());
      }
    });
  }

  static Future<List<int>> getAllCachedPageNumbers() async {
    final col = await _quranSvgPages();
    final all = await col.where().findAll();
    return all.map((e) => e.pageNumber).toList();
  }

  static Future<int> getCachedPageCount() async {
    final col = await _quranSvgPages();
    return col.where().count();
  }

  static Future<void> deleteQuranSvgPage(int pageNumber) async {
    final db = await _getDb();
    final col = db.collection<QuranSvgPageIsar>();
    await db.writeTxn(() async {
      final p = await col.where().pageNumberEqualTo(pageNumber).findFirst();
      if (p != null) await col.delete(p.id);
    });
  }

  // ── Download State ──────────────────────────────────────────────────────
  static Future<IsarCollection<DownloadStateIsar>> _downloadState() async =>
      (await _getDb()).collection<DownloadStateIsar>();

  static Future<String?> getDownloadStateValue(String key) async {
    final col = await _downloadState();
    final entry = await col.where().keyEqualTo(key).findFirst();
    return entry?.value;
  }

  static Future<void> putDownloadStateValue(String key, String value) async {
    final db = await _getDb();
    final col = db.collection<DownloadStateIsar>();
    await db.writeTxn(() async {
      final existing = await col.where().keyEqualTo(key).findFirst();
      if (existing != null) {
        existing.value = value;
        await col.put(existing);
      } else {
        await col.put(DownloadStateIsar()
          ..key = key
          ..value = value);
      }
    });
  }

  static Future<void> deleteDownloadStateKeys(List<String> keys) async {
    final db = await _getDb();
    final col = db.collection<DownloadStateIsar>();
    await db.writeTxn(() async {
      final entries = await col.where().findAll();
      final toDelete = entries
          .where((e) => keys.contains(e.key))
          .map((e) => e.id)
          .toList();
      if (toDelete.isNotEmpty) await col.deleteAll(toDelete);
    });
  }
}

import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'collections.dart';

class IsarService {
  static Isar? _instance;
  static bool _initialized = false;

  static Future<Isar> getInstance() async {
    if (_instance != null && _instance!.isOpen) return _instance!;
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
      ],
      directory: 'isar_data',
    );
    _initialized = true;
    debugPrint('[IsarService] Database opened successfully');
    return _instance!;
  }

  static bool get isInitialized => _initialized && _instance?.isOpen == true;

  static Future<void> close() async {
    await _instance?.close();
    _instance = null;
    _initialized = false;
  }

  // ── Settings ──────────────────────────────────────────────────────────────
  static IsarCollection<SettingsIsar> get settings =>
      _instance!.collection<SettingsIsar>();

  static Future<SettingsIsar?> getSettings() async {
    return settings.where().findFirst();
  }

  static Future<void> saveSettings(String jsonString) async {
    final existing = await getSettings();
    await _instance!.writeTxn(() async {
      if (existing != null) {
        existing.data = jsonString;
        existing.updatedAt = DateTime.now();
        await settings.put(existing);
      } else {
        final entry = SettingsIsar()
          ..data = jsonString
          ..updatedAt = DateTime.now();
        await settings.put(entry);
      }
    });
  }

  // ── Favorites ─────────────────────────────────────────────────────────────
  static IsarCollection<FavoriteIsar> get favorites =>
      _instance!.collection<FavoriteIsar>();

  static Future<List<FavoriteIsar>> getAllFavorites() async {
    return favorites.where().findAll();
  }

  static Future<FavoriteIsar?> getFavoriteByKey(String uniqueKey) async {
    return favorites.where().uniqueKeyEqualTo(uniqueKey).findFirst();
  }

  static Future<void> putFavorite(FavoriteIsar fav) async {
    await _instance!.writeTxn(() async {
      await favorites.put(fav);
    });
  }

  static Future<void> deleteFavoriteByKey(String uniqueKey) async {
    await _instance!.writeTxn(() async {
      final fav = await getFavoriteByKey(uniqueKey);
      if (fav != null) {
        await favorites.delete(fav.id);
      }
    });
  }

  // ── Bookmarks ─────────────────────────────────────────────────────────────
  static IsarCollection<BookmarkIsar> get bookmarks =>
      _instance!.collection<BookmarkIsar>();

  static Future<List<BookmarkIsar>> getAllBookmarks() async {
    return bookmarks.where().findAll();
  }

  static Future<void> putBookmark(BookmarkIsar bm) async {
    await _instance!.writeTxn(() async {
      await bookmarks.put(bm);
    });
  }

  static Future<void> deleteBookmarkByKey(String uniqueKey) async {
    await _instance!.writeTxn(() async {
      final bm = await bookmarks.where().uniqueKeyEqualTo(uniqueKey).findFirst();
      if (bm != null) {
        await bookmarks.delete(bm.id);
      }
    });
  }

  // ── Reading Progress ──────────────────────────────────────────────────────
  static IsarCollection<ReadingProgressIsar> get readingProgress =>
      _instance!.collection<ReadingProgressIsar>();

  static Future<ReadingProgressIsar?> getReadingProgress(String bookId) async {
    return readingProgress.where().bookIdEqualTo(bookId).findFirst();
  }

  static Future<void> putReadingProgress(ReadingProgressIsar rp) async {
    await _instance!.writeTxn(() async {
      await readingProgress.put(rp);
    });
  }

  // ── Khatmah ───────────────────────────────────────────────────────────────
  static IsarCollection<KhatmahIsar> get khatmah =>
      _instance!.collection<KhatmahIsar>();

  static Future<KhatmahIsar?> getCurrentKhatmah() async {
    return khatmah.get(1);
  }

  static Future<void> saveKhatmah(KhatmahIsar k) async {
    k.id = 1;
    await _instance!.writeTxn(() async {
      await khatmah.put(k);
    });
  }

  static Future<void> deleteKhatmah() async {
    await _instance!.writeTxn(() async {
      await khatmah.delete(1);
    });
  }

  // ── Tasbeeh ───────────────────────────────────────────────────────────────
  static IsarCollection<TasbeehIsar> get tasbeeh =>
      _instance!.collection<TasbeehIsar>();

  static Future<List<TasbeehIsar>> getAllTasbeeh() async {
    return tasbeeh.where().findAll();
  }

  static Future<void> putTasbeeh(TasbeehIsar t) async {
    await _instance!.writeTxn(() async {
      await tasbeeh.put(t);
    });
  }

  static Future<void> deleteTasbeehByKey(String uniqueKey) async {
    await _instance!.writeTxn(() async {
      final t = await tasbeeh.where().uniqueKeyEqualTo(uniqueKey).findFirst();
      if (t != null) {
        await tasbeeh.delete(t.id);
      }
    });
  }

  // ── Adhkar State ──────────────────────────────────────────────────────────
  static IsarCollection<AdhkarStateIsar> get adhkarState =>
      _instance!.collection<AdhkarStateIsar>();

  static Future<List<AdhkarStateIsar>> getAllAdhkarState() async {
    return adhkarState.where().findAll();
  }

  static Future<AdhkarStateIsar?> getAdhkarState(String uniqueKey) async {
    return adhkarState.where().uniqueKeyEqualTo(uniqueKey).findFirst();
  }

  static Future<void> putAdhkarState(AdhkarStateIsar a) async {
    await _instance!.writeTxn(() async {
      await adhkarState.put(a);
    });
  }

  static Future<void> putAllAdhkarState(List<AdhkarStateIsar> list) async {
    await _instance!.writeTxn(() async {
      await adhkarState.putAll(list);
    });
  }

  // ── Prayer Times Cache ────────────────────────────────────────────────────
  static IsarCollection<PrayerTimesCacheIsar> get prayerTimesCache =>
      _instance!.collection<PrayerTimesCacheIsar>();

  static Future<PrayerTimesCacheIsar?> getCachedPrayerTimes(String key) async {
    return prayerTimesCache.where().dateLocationKeyEqualTo(key).findFirst();
  }

  static Future<void> cachePrayerTimes(PrayerTimesCacheIsar pt) async {
    await _instance!.writeTxn(() async {
      await prayerTimesCache.put(pt);
    });
  }

  // ── Generic Cache ─────────────────────────────────────────────────────────
  static IsarCollection<CacheEntryIsar> get cacheEntries =>
      _instance!.collection<CacheEntryIsar>();

  static Future<CacheEntryIsar?> getCacheEntry(String key) async {
    final entry = await cacheEntries.where().cacheKeyEqualTo(key).findFirst();
    if (entry == null) return null;
    if (entry.expiresAt.isBefore(DateTime.now())) {
      await _instance!.writeTxn(() async {
        await cacheEntries.delete(entry.id);
      });
      return null;
    }
    return entry;
  }

  static Future<void> putCacheEntry(CacheEntryIsar entry) async {
    await _instance!.writeTxn(() async {
      await cacheEntries.put(entry);
    });
  }

  static Future<void> clearExpiredCache() async {
    final now = DateTime.now();
    final expired = await cacheEntries
        .where()
        .filter()
        .expiresAtLessThan(now)
        .findAll();
    if (expired.isEmpty) return;
    await _instance!.writeTxn(() async {
      final ids = expired.map((e) => e.id).toList();
      await cacheEntries.deleteAll(ids);
    });
  }

  // ── Audio State ───────────────────────────────────────────────────────────
  static IsarCollection<AudioStateIsar> get audioState =>
      _instance!.collection<AudioStateIsar>();

  static Future<AudioStateIsar?> getAudioState() async {
    return audioState.get(1);
  }

  static Future<void> saveAudioState(AudioStateIsar s) async {
    s.id = 1;
    await _instance!.writeTxn(() async {
      await audioState.put(s);
    });
  }

  // ── Recently Played ───────────────────────────────────────────────────────
  static IsarCollection<RecentlyPlayedIsar> get recentlyPlayed =>
      _instance!.collection<RecentlyPlayedIsar>();

  static Future<List<RecentlyPlayedIsar>> getAllRecentlyPlayed() async {
    return recentlyPlayed.where().findAll();
  }

  static Future<void> putRecentlyPlayed(RecentlyPlayedIsar rp) async {
    await _instance!.writeTxn(() async {
      await recentlyPlayed.put(rp);
    });
  }

  // ── Tasbih Stats ──────────────────────────────────────────────────────────
  static IsarCollection<TasbihStatsIsar> get tasbihStats =>
      _instance!.collection<TasbihStatsIsar>();

  static Future<TasbihStatsIsar?> getTasbihStats() async {
    return tasbihStats.get(1);
  }

  static Future<void> saveTasbihStats(TasbihStatsIsar s) async {
    s.id = 1;
    await _instance!.writeTxn(() async {
      await tasbihStats.put(s);
    });
  }

  // ── Tasbih History ────────────────────────────────────────────────────────
  static IsarCollection<TasbihHistoryIsar> get tasbihHistory =>
      _instance!.collection<TasbihHistoryIsar>();

  static Future<List<TasbihHistoryIsar>> getAllTasbihHistory() async {
    return tasbihHistory.where().findAll();
  }

  static Future<void> putTasbihHistory(TasbihHistoryIsar h) async {
    await _instance!.writeTxn(() async {
      await tasbihHistory.put(h);
    });
  }

  static Future<void> clearTasbihHistory() async {
    await _instance!.writeTxn(() async {
      await tasbihHistory.clear();
    });
  }

  // ── Custom Tasbih ─────────────────────────────────────────────────────────
  static IsarCollection<CustomTasbihIsar> get customTasbih =>
      _instance!.collection<CustomTasbihIsar>();

  static Future<List<CustomTasbihIsar>> getAllCustomTasbih() async {
    return customTasbih.where().findAll();
  }

  static Future<void> putCustomTasbih(CustomTasbihIsar c) async {
    await _instance!.writeTxn(() async {
      await customTasbih.put(c);
    });
  }

  static Future<void> deleteCustomTasbihByKey(String uniqueKey) async {
    await _instance!.writeTxn(() async {
      final c = await customTasbih.where().uniqueKeyEqualTo(uniqueKey).findFirst();
      if (c != null) {
        await customTasbih.delete(c.id);
      }
    });
  }

  // ── Daily Content ─────────────────────────────────────────────────────────
  static IsarCollection<DailyContentIsar> get dailyContent =>
      _instance!.collection<DailyContentIsar>();

  static Future<DailyContentIsar?> getDailyContent() async {
    return dailyContent.get(1);
  }

  static Future<void> saveDailyContent(DailyContentIsar d) async {
    d.id = 1;
    await _instance!.writeTxn(() async {
      await dailyContent.put(d);
    });
  }

  // ── Search History ────────────────────────────────────────────────────────
  static IsarCollection<SearchHistoryIsar> get searchHistory =>
      _instance!.collection<SearchHistoryIsar>();

  static Future<List<SearchHistoryIsar>> getRecentSearches({int limit = 20}) async {
    return searchHistory.where().sortBySearchedAtDesc().limit(limit).findAll();
  }

  static Future<void> addSearchHistory(String query, {int resultCount = 0}) async {
    await _instance!.writeTxn(() async {
      await searchHistory.put(SearchHistoryIsar()
        ..query = query
        ..searchedAt = DateTime.now()
        ..resultCount = resultCount);
    });
  }

  static Future<void> clearSearchHistory() async {
    await _instance!.writeTxn(() async {
      await searchHistory.clear();
    });
  }
}

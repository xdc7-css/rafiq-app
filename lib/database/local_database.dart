import 'local_database_stub.dart'
    if (dart.library.io) 'local_database_android.dart'
    if (dart.library.html) 'local_database_web.dart';
import 'models/database_models.dart';

export 'models/database_models.dart';

abstract class LocalDatabaseService {
  static LocalDatabaseService? _instance;
  static LocalDatabaseService get instance => _instance ??= createLocalDatabaseService();

  bool get isInitialized;
  Future<void> initialize();
  Future<void> close();

  Future<SettingsEntry?> getSettings();
  Future<void> saveSettings(String jsonString);

  Future<List<FavoriteEntry>> getAllFavorites();
  Future<void> putFavorite(FavoriteEntry fav);
  Future<void> deleteFavoriteByKey(String uniqueKey);

  Future<List<BookmarkEntry>> getAllBookmarks();
  Future<void> putBookmark(BookmarkEntry bm);
  Future<void> deleteBookmarkByKey(String uniqueKey);

  Future<ReadingProgressEntry?> getReadingProgress(String bookId);
  Future<void> putReadingProgress(ReadingProgressEntry rp);

  Future<KhatmahEntry?> getCurrentKhatmah();
  Future<void> saveKhatmah(KhatmahEntry k);
  Future<void> deleteKhatmah();

  Future<List<TasbeehEntry>> getAllTasbeeh();
  Future<void> putTasbeeh(TasbeehEntry t);
  Future<void> deleteTasbeehByKey(String uniqueKey);

  Future<List<AdhkarStateEntry>> getAllAdhkarState();
  Future<void> putAllAdhkarState(List<AdhkarStateEntry> entries);

  Future<PrayerTimesCacheEntry?> getCachedPrayerTimes(String key);
  Future<void> cachePrayerTimes(PrayerTimesCacheEntry pt);

  Future<CacheEntry?> getCacheEntry(String key);
  Future<void> putCacheEntry(CacheEntry entry);
  Future<void> clearExpiredCache();

  Future<AudioStateEntry?> getAudioState();
  Future<void> saveAudioState(AudioStateEntry s);

  Future<List<RecentlyPlayedEntry>> getAllRecentlyPlayed();
  Future<void> putRecentlyPlayed(RecentlyPlayedEntry rp);

  Future<TasbihStatsEntry?> getTasbihStats();
  Future<void> saveTasbihStats(TasbihStatsEntry s);

  Future<List<TasbihHistoryEntry>> getAllTasbihHistory();
  Future<void> putTasbihHistory(TasbihHistoryEntry h);
  Future<void> clearTasbihHistory();

  Future<List<CustomTasbihEntry>> getAllCustomTasbih();
  Future<void> putCustomTasbih(CustomTasbihEntry c);
  Future<void> deleteCustomTasbihByKey(String uniqueKey);

  Future<DailyContentEntry?> getDailyContent();
  Future<void> saveDailyContent(DailyContentEntry d);

  Future<List<SearchHistoryEntry>> getRecentSearches({int limit = 20});
  Future<void> addSearchHistory(String query, {int resultCount = 0});
  Future<void> clearSearchHistory();

  // ── Memorials (Mercy Register) ──────────────────────────────────────
  Future<List<MemorialEntry>> getMemorials({String? userId, int limit = 20, int offset = 0});
  Stream<List<MemorialEntry>> watchMemorials({String? userId});
  Future<MemorialEntry?> getMemorialById(String memorialId);
  Future<void> putMemorial(MemorialEntry m);
  Future<void> deleteMemorialById(String memorialId);

  // ── Rewards (Mercy Register) ────────────────────────────────────────
  Future<List<RewardEntry>> getRewardsByMemorialId(String memorialId, {int limit = 50});
  Future<void> putReward(RewardEntry r);
}

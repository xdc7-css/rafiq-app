import 'package:flutter/foundation.dart';
import 'isar_service.dart';
import 'collections.dart';
import 'local_database.dart';
import 'models/database_models.dart';

class IsarDatabaseService implements LocalDatabaseService {
  bool _initialized = false;

  @override
  bool get isInitialized => _initialized && IsarService.isInitialized;

  @override
  Future<void> initialize() async {
    await IsarService.getInstance();
    _initialized = true;
    debugPrint('[IsarDatabaseService] Initialized');
  }

  @override
  Future<void> close() async {
    await IsarService.close();
    _initialized = false;
  }

  // ── Settings ─────────────────────────────────────────────────────────

  @override
  Future<SettingsEntry?> getSettings() async {
    final e = await IsarService.getSettings();
    if (e == null) return null;
    return SettingsEntry(data: e.data, updatedAt: e.updatedAt);
  }

  @override
  Future<void> saveSettings(String jsonString) async {
    await IsarService.saveSettings(jsonString);
  }

  // ── Favorites ────────────────────────────────────────────────────────

  @override
  Future<List<FavoriteEntry>> getAllFavorites() async {
    final entries = await IsarService.getAllFavorites();
    return entries.map((e) => FavoriteEntry(
      uniqueKey: e.uniqueKey,
      typeIndex: e.typeIndex,
      textArabic: e.textArabic,
      reference: e.reference,
      dateAdded: e.dateAdded,
      metadata: e.metadata,
    )).toList();
  }

  @override
  Future<void> putFavorite(FavoriteEntry fav) async {
    await IsarService.putFavorite(FavoriteIsar()
      ..uniqueKey = fav.uniqueKey
      ..typeIndex = fav.typeIndex
      ..textArabic = fav.textArabic
      ..reference = fav.reference
      ..dateAdded = fav.dateAdded
      ..metadata = fav.metadata);
  }

  @override
  Future<void> deleteFavoriteByKey(String uniqueKey) async {
    await IsarService.deleteFavoriteByKey(uniqueKey);
  }

  // ── Bookmarks ────────────────────────────────────────────────────────

  @override
  Future<List<BookmarkEntry>> getAllBookmarks() async {
    final entries = await IsarService.getAllBookmarks();
    return entries.map((e) => BookmarkEntry(
      uniqueKey: e.uniqueKey,
      typeIndex: e.typeIndex,
      title: e.title,
      subtitle: e.subtitle,
      data: e.data,
      createdAt: e.createdAt,
    )).toList();
  }

  @override
  Future<void> putBookmark(BookmarkEntry bm) async {
    await IsarService.putBookmark(BookmarkIsar()
      ..uniqueKey = bm.uniqueKey
      ..typeIndex = bm.typeIndex
      ..title = bm.title
      ..subtitle = bm.subtitle
      ..data = bm.data
      ..createdAt = bm.createdAt);
  }

  @override
  Future<void> deleteBookmarkByKey(String uniqueKey) async {
    await IsarService.deleteBookmarkByKey(uniqueKey);
  }

  // ── Reading Progress ─────────────────────────────────────────────────

  @override
  Future<ReadingProgressEntry?> getReadingProgress(String bookId) async {
    final e = await IsarService.getReadingProgress(bookId);
    if (e == null) return null;
    return ReadingProgressEntry(
      bookId: e.bookId,
      surahNumber: e.surahNumber,
      ayahNumber: e.ayahNumber,
      page: e.page,
      juz: e.juz,
      updatedAt: e.updatedAt,
    );
  }

  @override
  Future<void> putReadingProgress(ReadingProgressEntry rp) async {
    await IsarService.putReadingProgress(ReadingProgressIsar()
      ..bookId = rp.bookId
      ..surahNumber = rp.surahNumber
      ..ayahNumber = rp.ayahNumber
      ..page = rp.page
      ..juz = rp.juz
      ..updatedAt = rp.updatedAt);
  }

  // ── Khatmah ──────────────────────────────────────────────────────────

  @override
  Future<KhatmahEntry?> getCurrentKhatmah() async {
    final e = await IsarService.getCurrentKhatmah();
    if (e == null) return null;
    return KhatmahEntry(
      currentPage: e.currentPage,
      currentSurah: e.currentSurah,
      currentAyah: e.currentAyah,
      totalAyahsRead: e.totalAyahsRead,
      startDate: e.startDate,
      lastReadDate: e.lastReadDate,
      name: e.name,
      readingStreakJson: e.readingStreakJson,
    );
  }

  @override
  Future<void> saveKhatmah(KhatmahEntry k) async {
    await IsarService.saveKhatmah(KhatmahIsar()
      ..currentPage = k.currentPage
      ..currentSurah = k.currentSurah
      ..currentAyah = k.currentAyah
      ..totalAyahsRead = k.totalAyahsRead
      ..startDate = k.startDate
      ..lastReadDate = k.lastReadDate
      ..name = k.name
      ..readingStreakJson = k.readingStreakJson);
  }

  @override
  Future<void> deleteKhatmah() async {
    await IsarService.deleteKhatmah();
  }

  // ── Tasbeeh ──────────────────────────────────────────────────────────

  @override
  Future<List<TasbeehEntry>> getAllTasbeeh() async {
    final entries = await IsarService.getAllTasbeeh();
    return entries.map((e) => TasbeehEntry(
      uniqueKey: e.uniqueKey,
      name: e.name,
      nameArabic: e.nameArabic,
      count: e.count,
      target: e.target,
      lastUsed: e.lastUsed,
    )).toList();
  }

  @override
  Future<void> putTasbeeh(TasbeehEntry t) async {
    await IsarService.putTasbeeh(TasbeehIsar()
      ..uniqueKey = t.uniqueKey
      ..name = t.name
      ..nameArabic = t.nameArabic
      ..count = t.count
      ..target = t.target
      ..lastUsed = t.lastUsed);
  }

  @override
  Future<void> deleteTasbeehByKey(String uniqueKey) async {
    await IsarService.deleteTasbeehByKey(uniqueKey);
  }

  // ── Adhkar State ─────────────────────────────────────────────────────

  @override
  Future<List<AdhkarStateEntry>> getAllAdhkarState() async {
    final entries = await IsarService.getAllAdhkarState();
    return entries.map((e) => AdhkarStateEntry(
      uniqueKey: e.uniqueKey,
      categoryId: e.categoryId,
      dhikrId: e.dhikrId,
      currentCount: e.currentCount,
      isFavorite: e.isFavorite,
    )).toList();
  }

  @override
  Future<void> putAllAdhkarState(List<AdhkarStateEntry> entries) async {
    final isarEntries = entries.map((e) => AdhkarStateIsar()
      ..uniqueKey = e.uniqueKey
      ..categoryId = e.categoryId
      ..dhikrId = e.dhikrId
      ..currentCount = e.currentCount
      ..isFavorite = e.isFavorite).toList();
    await IsarService.putAllAdhkarState(isarEntries);
  }

  // ── Prayer Times Cache ───────────────────────────────────────────────

  @override
  Future<PrayerTimesCacheEntry?> getCachedPrayerTimes(String key) async {
    final e = await IsarService.getCachedPrayerTimes(key);
    if (e == null) return null;
    return PrayerTimesCacheEntry(
      dateLocationKey: e.dateLocationKey,
      fullJson: e.fullJson,
      fetchedAt: e.fetchedAt,
    );
  }

  @override
  Future<void> cachePrayerTimes(PrayerTimesCacheEntry pt) async {
    await IsarService.cachePrayerTimes(PrayerTimesCacheIsar()
      ..dateLocationKey = pt.dateLocationKey
      ..fullJson = pt.fullJson
      ..fetchedAt = pt.fetchedAt);
  }

  // ── Generic Cache ────────────────────────────────────────────────────

  @override
  Future<CacheEntry?> getCacheEntry(String key) async {
    final e = await IsarService.getCacheEntry(key);
    if (e == null) return null;
    return CacheEntry(
      cacheKey: e.cacheKey,
      data: e.data,
      expiresAt: e.expiresAt,
      category: e.category,
    );
  }

  @override
  Future<void> putCacheEntry(CacheEntry entry) async {
    await IsarService.putCacheEntry(CacheEntryIsar()
      ..cacheKey = entry.cacheKey
      ..data = entry.data
      ..expiresAt = entry.expiresAt
      ..category = entry.category);
  }

  @override
  Future<void> clearExpiredCache() async {
    await IsarService.clearExpiredCache();
  }

  // ── Audio State ──────────────────────────────────────────────────────

  @override
  Future<AudioStateEntry?> getAudioState() async {
    final e = await IsarService.getAudioState();
    if (e == null) return null;
    return AudioStateEntry(
      currentSurahNumber: e.currentSurahNumber,
      reciterId: e.reciterId,
      reciterName: e.reciterName,
      moshafId: e.moshafId,
      server: e.server,
      positionMs: e.positionMs,
      speed: e.speed,
      queueJson: e.queueJson,
      updatedAt: e.updatedAt,
    );
  }

  @override
  Future<void> saveAudioState(AudioStateEntry s) async {
    await IsarService.saveAudioState(AudioStateIsar()
      ..currentSurahNumber = s.currentSurahNumber
      ..reciterId = s.reciterId
      ..reciterName = s.reciterName
      ..moshafId = s.moshafId
      ..server = s.server
      ..positionMs = s.positionMs
      ..speed = s.speed
      ..queueJson = s.queueJson
      ..updatedAt = s.updatedAt);
  }

  // ── Recently Played ──────────────────────────────────────────────────

  @override
  Future<List<RecentlyPlayedEntry>> getAllRecentlyPlayed() async {
    final entries = await IsarService.getAllRecentlyPlayed();
    return entries.map((e) => RecentlyPlayedEntry(
      reciterId: e.reciterId,
      data: e.data,
      lastPlayed: e.lastPlayed,
    )).toList();
  }

  @override
  Future<void> putRecentlyPlayed(RecentlyPlayedEntry rp) async {
    await IsarService.putRecentlyPlayed(RecentlyPlayedIsar()
      ..reciterId = rp.reciterId
      ..data = rp.data
      ..lastPlayed = rp.lastPlayed);
  }

  // ── Tasbih Stats ─────────────────────────────────────────────────────

  @override
  Future<TasbihStatsEntry?> getTasbihStats() async {
    final e = await IsarService.getTasbihStats();
    if (e == null) return null;
    return TasbihStatsEntry(
      todayCount: e.todayCount,
      totalCount: e.totalCount,
      date: e.date,
      weeklyCountsJson: e.weeklyCountsJson,
      monthlyCountsJson: e.monthlyCountsJson,
      dailyGoal: e.dailyGoal,
    );
  }

  @override
  Future<void> saveTasbihStats(TasbihStatsEntry s) async {
    await IsarService.saveTasbihStats(TasbihStatsIsar()
      ..todayCount = s.todayCount
      ..totalCount = s.totalCount
      ..date = s.date
      ..weeklyCountsJson = s.weeklyCountsJson
      ..monthlyCountsJson = s.monthlyCountsJson
      ..dailyGoal = s.dailyGoal);
  }

  // ── Tasbih History ───────────────────────────────────────────────────

  @override
  Future<List<TasbihHistoryEntry>> getAllTasbihHistory() async {
    final entries = await IsarService.getAllTasbihHistory();
    return entries.map((e) => TasbihHistoryEntry(
      sessionId: e.sessionId,
      type: e.type,
      label: e.label,
      count: e.count,
      startedAt: e.startedAt,
      durationSeconds: e.durationSeconds,
    )).toList();
  }

  @override
  Future<void> putTasbihHistory(TasbihHistoryEntry h) async {
    await IsarService.putTasbihHistory(TasbihHistoryIsar()
      ..sessionId = h.sessionId
      ..type = h.type
      ..label = h.label
      ..count = h.count
      ..startedAt = h.startedAt
      ..durationSeconds = h.durationSeconds);
  }

  @override
  Future<void> clearTasbihHistory() async {
    await IsarService.clearTasbihHistory();
  }

  // ── Custom Tasbih ────────────────────────────────────────────────────

  @override
  Future<List<CustomTasbihEntry>> getAllCustomTasbih() async {
    final entries = await IsarService.getAllCustomTasbih();
    return entries.map((e) => CustomTasbihEntry(
      uniqueKey: e.uniqueKey,
      name: e.name,
      nameArabic: e.nameArabic,
      target: e.target,
      isFavorite: e.isFavorite,
      createdAt: e.createdAt,
    )).toList();
  }

  @override
  Future<void> putCustomTasbih(CustomTasbihEntry c) async {
    await IsarService.putCustomTasbih(CustomTasbihIsar()
      ..uniqueKey = c.uniqueKey
      ..name = c.name
      ..nameArabic = c.nameArabic
      ..target = c.target
      ..isFavorite = c.isFavorite
      ..createdAt = c.createdAt);
  }

  @override
  Future<void> deleteCustomTasbihByKey(String uniqueKey) async {
    await IsarService.deleteCustomTasbihByKey(uniqueKey);
  }

  // ── Daily Content ────────────────────────────────────────────────────

  @override
  Future<DailyContentEntry?> getDailyContent() async {
    final e = await IsarService.getDailyContent();
    if (e == null) return null;
    return DailyContentEntry(
      lastVerseIndex: e.lastVerseIndex,
      lastHadithIndex: e.lastHadithIndex,
      lastVerseDate: e.lastVerseDate,
      lastHadithDate: e.lastHadithDate,
    );
  }

  @override
  Future<void> saveDailyContent(DailyContentEntry d) async {
    await IsarService.saveDailyContent(DailyContentIsar()
      ..lastVerseIndex = d.lastVerseIndex
      ..lastHadithIndex = d.lastHadithIndex
      ..lastVerseDate = d.lastVerseDate
      ..lastHadithDate = d.lastHadithDate);
  }

  // ── Search History ───────────────────────────────────────────────────

  @override
  Future<List<SearchHistoryEntry>> getRecentSearches({int limit = 20}) async {
    final entries = await IsarService.getRecentSearches(limit: limit);
    return entries.map((e) => SearchHistoryEntry(
      query: e.query,
      searchedAt: e.searchedAt,
      resultCount: e.resultCount,
    )).toList();
  }

  @override
  Future<void> addSearchHistory(String query, {int resultCount = 0}) async {
    await IsarService.addSearchHistory(query, resultCount: resultCount);
  }

  @override
  Future<void> clearSearchHistory() async {
    await IsarService.clearSearchHistory();
  }
}

LocalDatabaseService createLocalDatabaseService() => IsarDatabaseService();

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'local_database.dart';
import 'models/database_models.dart';

class WebDatabaseService implements LocalDatabaseService {
  SharedPreferences? _prefs;
  bool _initialized = false;

  static const _prefix = 'ldb_';
  static const _settingsKey = '${_prefix}settings';
  static const _favoritesKey = '${_prefix}favorites';
  static const _bookmarksKey = '${_prefix}bookmarks';
  static const _readingProgressKey = '${_prefix}reading_progress';
  static const _khatmahKey = '${_prefix}khatmah';
  static const _tasbeehKey = '${_prefix}tasbeeh';
  static const _adhkarStateKey = '${_prefix}adhkar_state';
  static const _prayerTimesKey = '${_prefix}prayer_times';
  static const _cacheKey = '${_prefix}cache';
  static const _audioStateKey = '${_prefix}audio_state';
  static const _recentlyPlayedKey = '${_prefix}recently_played';
  static const _tasbihStatsKey = '${_prefix}tasbih_stats';
  static const _tasbihHistoryKey = '${_prefix}tasbih_history';
  static const _customTasbihKey = '${_prefix}custom_tasbih';
  static const _dailyContentKey = '${_prefix}daily_content';
  static const _searchHistoryKey = '${_prefix}search_history';

  @override
  bool get isInitialized => _initialized;

  @override
  Future<void> initialize() async {
    if (_initialized) return;
    _prefs = await SharedPreferences.getInstance();
    _initialized = true;
    debugPrint('[WebDatabaseService] Initialized');
  }

  @override
  Future<void> close() async {
    _initialized = false;
    _prefs = null;
  }

  SharedPreferences get _p {
    if (_prefs == null) throw StateError('WebDatabaseService not initialized');
    return _prefs!;
  }

  // ── Generic helpers ──────────────────────────────────────────────────

  List<Map<String, dynamic>> _loadList(String key) {
    final raw = _p.getString(key);
    if (raw == null) return [];
    try {
      final decoded = json.decode(raw);
      return (decoded as List).cast<Map<String, dynamic>>();
    } catch (_) {
      return [];
    }
  }

  Future<void> _saveList(String key, List<Map<String, dynamic>> list) async {
    await _p.setString(key, json.encode(list));
  }

  Map<String, dynamic>? _loadMap(String key) {
    final raw = _p.getString(key);
    if (raw == null) return null;
    try {
      return json.decode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  Future<void> _saveMap(String key, Map<String, dynamic> map) async {
    await _p.setString(key, json.encode(map));
  }

  // ── Settings ─────────────────────────────────────────────────────────

  @override
  Future<SettingsEntry?> getSettings() async {
    final map = _loadMap(_settingsKey);
    return map != null ? SettingsEntry.fromJson(map) : null;
  }

  @override
  Future<void> saveSettings(String jsonString) async {
    await _saveMap(_settingsKey, {'data': jsonString, 'updatedAt': DateTime.now().toIso8601String()});
  }

  // ── Favorites ────────────────────────────────────────────────────────

  @override
  Future<List<FavoriteEntry>> getAllFavorites() async {
    return _loadList(_favoritesKey).map(FavoriteEntry.fromJson).toList();
  }

  @override
  Future<void> putFavorite(FavoriteEntry fav) async {
    final list = _loadList(_favoritesKey);
    list.removeWhere((e) => e['uniqueKey'] == fav.uniqueKey);
    list.insert(0, fav.toJson());
    await _saveList(_favoritesKey, list);
  }

  @override
  Future<void> deleteFavoriteByKey(String uniqueKey) async {
    final list = _loadList(_favoritesKey);
    list.removeWhere((e) => e['uniqueKey'] == uniqueKey);
    await _saveList(_favoritesKey, list);
  }

  // ── Bookmarks ────────────────────────────────────────────────────────

  @override
  Future<List<BookmarkEntry>> getAllBookmarks() async {
    return _loadList(_bookmarksKey).map(BookmarkEntry.fromJson).toList();
  }

  @override
  Future<void> putBookmark(BookmarkEntry bm) async {
    final list = _loadList(_bookmarksKey);
    list.removeWhere((e) => e['uniqueKey'] == bm.uniqueKey);
    list.insert(0, bm.toJson());
    await _saveList(_bookmarksKey, list);
  }

  @override
  Future<void> deleteBookmarkByKey(String uniqueKey) async {
    final list = _loadList(_bookmarksKey);
    list.removeWhere((e) => e['uniqueKey'] == uniqueKey);
    await _saveList(_bookmarksKey, list);
  }

  // ── Reading Progress ─────────────────────────────────────────────────

  @override
  Future<ReadingProgressEntry?> getReadingProgress(String bookId) async {
    final list = _loadList(_readingProgressKey);
    for (final e in list) {
      final entry = ReadingProgressEntry.fromJson(e);
      if (entry.bookId == bookId) return entry;
    }
    return null;
  }

  @override
  Future<void> putReadingProgress(ReadingProgressEntry rp) async {
    final list = _loadList(_readingProgressKey);
    list.removeWhere((e) => e['bookId'] == rp.bookId);
    list.add(rp.toJson());
    await _saveList(_readingProgressKey, list);
  }

  // ── Khatmah ──────────────────────────────────────────────────────────

  @override
  Future<KhatmahEntry?> getCurrentKhatmah() async {
    final map = _loadMap(_khatmahKey);
    return map != null ? KhatmahEntry.fromJson(map) : null;
  }

  @override
  Future<void> saveKhatmah(KhatmahEntry k) async {
    await _saveMap(_khatmahKey, k.toJson());
  }

  @override
  Future<void> deleteKhatmah() async {
    await _p.remove(_khatmahKey);
  }

  // ── Tasbeeh ──────────────────────────────────────────────────────────

  @override
  Future<List<TasbeehEntry>> getAllTasbeeh() async {
    return _loadList(_tasbeehKey).map(TasbeehEntry.fromJson).toList();
  }

  @override
  Future<void> putTasbeeh(TasbeehEntry t) async {
    final list = _loadList(_tasbeehKey);
    list.removeWhere((e) => e['uniqueKey'] == t.uniqueKey);
    list.add(t.toJson());
    await _saveList(_tasbeehKey, list);
  }

  @override
  Future<void> deleteTasbeehByKey(String uniqueKey) async {
    final list = _loadList(_tasbeehKey);
    list.removeWhere((e) => e['uniqueKey'] == uniqueKey);
    await _saveList(_tasbeehKey, list);
  }

  // ── Adhkar State ─────────────────────────────────────────────────────

  @override
  Future<List<AdhkarStateEntry>> getAllAdhkarState() async {
    return _loadList(_adhkarStateKey).map(AdhkarStateEntry.fromJson).toList();
  }

  @override
  Future<void> putAllAdhkarState(List<AdhkarStateEntry> entries) async {
    final list = _loadList(_adhkarStateKey);
    for (final entry in entries) {
      list.removeWhere((e) => e['uniqueKey'] == entry.uniqueKey);
      list.add(entry.toJson());
    }
    await _saveList(_adhkarStateKey, list);
  }

  // ── Prayer Times Cache ───────────────────────────────────────────────

  @override
  Future<PrayerTimesCacheEntry?> getCachedPrayerTimes(String key) async {
    final list = _loadList(_prayerTimesKey);
    for (final e in list) {
      final entry = PrayerTimesCacheEntry.fromJson(e);
      if (entry.dateLocationKey == key) return entry;
    }
    return null;
  }

  @override
  Future<void> cachePrayerTimes(PrayerTimesCacheEntry pt) async {
    final list = _loadList(_prayerTimesKey);
    list.removeWhere((e) => e['dateLocationKey'] == pt.dateLocationKey);
    list.add(pt.toJson());
    await _saveList(_prayerTimesKey, list);
  }

  // ── Generic Cache ────────────────────────────────────────────────────

  @override
  Future<CacheEntry?> getCacheEntry(String key) async {
    final list = _loadList(_cacheKey);
    for (final e in list) {
      final entry = CacheEntry.fromJson(e);
      if (entry.cacheKey == key) {
        if (entry.expiresAt.isBefore(DateTime.now())) {
          list.removeWhere((el) => el['cacheKey'] == key);
          await _saveList(_cacheKey, list);
          return null;
        }
        return entry;
      }
    }
    return null;
  }

  @override
  Future<void> putCacheEntry(CacheEntry entry) async {
    final list = _loadList(_cacheKey);
    list.removeWhere((e) => e['cacheKey'] == entry.cacheKey);
    list.add(entry.toJson());
    await _saveList(_cacheKey, list);
  }

  @override
  Future<void> clearExpiredCache() async {
    final now = DateTime.now();
    final list = _loadList(_cacheKey);
    final filtered = list.where((e) {
      final expiresAt = DateTime.tryParse(e['expiresAt'] as String? ?? '');
      return expiresAt != null && expiresAt.isAfter(now);
    }).toList();
    if (filtered.length != list.length) {
      await _saveList(_cacheKey, filtered);
    }
  }

  // ── Audio State ──────────────────────────────────────────────────────

  @override
  Future<AudioStateEntry?> getAudioState() async {
    final map = _loadMap(_audioStateKey);
    return map != null ? AudioStateEntry.fromJson(map) : null;
  }

  @override
  Future<void> saveAudioState(AudioStateEntry s) async {
    await _saveMap(_audioStateKey, s.toJson());
  }

  // ── Recently Played ──────────────────────────────────────────────────

  @override
  Future<List<RecentlyPlayedEntry>> getAllRecentlyPlayed() async {
    return _loadList(_recentlyPlayedKey).map(RecentlyPlayedEntry.fromJson).toList();
  }

  @override
  Future<void> putRecentlyPlayed(RecentlyPlayedEntry rp) async {
    final list = _loadList(_recentlyPlayedKey);
    list.removeWhere((e) => e['reciterId'] == rp.reciterId);
    list.insert(0, rp.toJson());
    await _saveList(_recentlyPlayedKey, list);
  }

  // ── Tasbih Stats ─────────────────────────────────────────────────────

  @override
  Future<TasbihStatsEntry?> getTasbihStats() async {
    final map = _loadMap(_tasbihStatsKey);
    return map != null ? TasbihStatsEntry.fromJson(map) : null;
  }

  @override
  Future<void> saveTasbihStats(TasbihStatsEntry s) async {
    await _saveMap(_tasbihStatsKey, s.toJson());
  }

  // ── Tasbih History ───────────────────────────────────────────────────

  @override
  Future<List<TasbihHistoryEntry>> getAllTasbihHistory() async {
    return _loadList(_tasbihHistoryKey).map(TasbihHistoryEntry.fromJson).toList();
  }

  @override
  Future<void> putTasbihHistory(TasbihHistoryEntry h) async {
    final list = _loadList(_tasbihHistoryKey);
    list.removeWhere((e) => e['sessionId'] == h.sessionId);
    list.add(h.toJson());
    await _saveList(_tasbihHistoryKey, list);
  }

  @override
  Future<void> clearTasbihHistory() async {
    await _p.remove(_tasbihHistoryKey);
  }

  // ── Custom Tasbih ────────────────────────────────────────────────────

  @override
  Future<List<CustomTasbihEntry>> getAllCustomTasbih() async {
    return _loadList(_customTasbihKey).map(CustomTasbihEntry.fromJson).toList();
  }

  @override
  Future<void> putCustomTasbih(CustomTasbihEntry c) async {
    final list = _loadList(_customTasbihKey);
    list.removeWhere((e) => e['uniqueKey'] == c.uniqueKey);
    list.add(c.toJson());
    await _saveList(_customTasbihKey, list);
  }

  @override
  Future<void> deleteCustomTasbihByKey(String uniqueKey) async {
    final list = _loadList(_customTasbihKey);
    list.removeWhere((e) => e['uniqueKey'] == uniqueKey);
    await _saveList(_customTasbihKey, list);
  }

  // ── Daily Content ────────────────────────────────────────────────────

  @override
  Future<DailyContentEntry?> getDailyContent() async {
    final map = _loadMap(_dailyContentKey);
    return map != null ? DailyContentEntry.fromJson(map) : null;
  }

  @override
  Future<void> saveDailyContent(DailyContentEntry d) async {
    await _saveMap(_dailyContentKey, d.toJson());
  }

  // ── Search History ───────────────────────────────────────────────────

  @override
  Future<List<SearchHistoryEntry>> getRecentSearches({int limit = 20}) async {
    final list = _loadList(_searchHistoryKey);
    final entries = list.map(SearchHistoryEntry.fromJson).toList();
    entries.sort((a, b) => b.searchedAt.compareTo(a.searchedAt));
    if (entries.length > limit) return entries.sublist(0, limit);
    return entries;
  }

  @override
  Future<void> addSearchHistory(String query, {int resultCount = 0}) async {
    final list = _loadList(_searchHistoryKey);
    list.add(SearchHistoryEntry(query: query, resultCount: resultCount).toJson());
    await _saveList(_searchHistoryKey, list);
  }

  @override
  Future<void> clearSearchHistory() async {
    await _p.remove(_searchHistoryKey);
  }

  // ── Memorials (Mercy Register) ──────────────────────────────────────
  static const _memorialsKey = '${_prefix}memorials_mercy';
  static const _rewardsKey = '${_prefix}rewards_mercy';

  @override
  Future<List<MemorialEntry>> getMemorials({
    String? userId,
    int limit = 20,
    int offset = 0,
  }) async {
    var list = _loadList(_memorialsKey).map(MemorialEntry.fromJson).toList();
    if (userId != null) {
      list = list.where((e) => e.userId == userId).toList();
    }
    list.sort((a, b) => b.updatedAtMs.compareTo(a.updatedAtMs));
    if (offset >= list.length) return [];
    return list.sublist(offset, (offset + limit).clamp(0, list.length));
  }

  @override
  Stream<List<MemorialEntry>> watchMemorials({String? userId}) async* {
    yield await getMemorials(userId: userId);
  }

  @override
  Future<MemorialEntry?> getMemorialById(String memorialId) async {
    final list = _loadList(_memorialsKey).map(MemorialEntry.fromJson).toList();
    try {
      return list.firstWhere((e) => e.memorialId == memorialId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> putMemorial(MemorialEntry m) async {
    final list = _loadList(_memorialsKey);
    list.removeWhere((e) => e['memorialId'] == m.memorialId);
    list.insert(0, m.toJson());
    await _saveList(_memorialsKey, list);
  }

  @override
  Future<void> deleteMemorialById(String memorialId) async {
    final list = _loadList(_memorialsKey);
    list.removeWhere((e) => e['memorialId'] == memorialId);
    await _saveList(_memorialsKey, list);
    final rewards = _loadList(_rewardsKey);
    rewards.removeWhere((e) => e['memorialId'] == memorialId);
    await _saveList(_rewardsKey, rewards);
  }

  // ── Rewards (Mercy Register) ────────────────────────────────────────

  @override
  Future<List<RewardEntry>> getRewardsByMemorialId(
    String memorialId, {
    int limit = 50,
  }) async {
    var list = _loadList(_rewardsKey).map(RewardEntry.fromJson).toList();
    list = list.where((e) => e.memorialId == memorialId).toList();
    list.sort((a, b) => b.createdAtMs.compareTo(a.createdAtMs));
    if (list.length > limit) return list.sublist(0, limit);
    return list;
  }

  @override
  Future<void> putReward(RewardEntry r) async {
    final list = _loadList(_rewardsKey);
    list.removeWhere((e) => e['rewardId'] == r.rewardId);
    list.insert(0, r.toJson());
    await _saveList(_rewardsKey, list);
  }
}

LocalDatabaseService createLocalDatabaseService() => WebDatabaseService();

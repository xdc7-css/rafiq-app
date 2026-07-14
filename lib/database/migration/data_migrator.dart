import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../collections.dart';
import '../isar_service.dart';

class DataMigrator {
  static const String _migrationKey = 'isar_migration_v1_complete';
  static bool _migrationDone = false;

  static Future<void> migrateIfNeeded() async {
    if (_migrationDone) return;
    final prefs = await SharedPreferences.getInstance();
    final alreadyDone = prefs.getBool(_migrationKey) ?? false;
    if (alreadyDone) {
      _migrationDone = true;
      return;
    }

    debugPrint('[DataMigrator] Starting SharedPreferences → Isar migration...');
    final sw = Stopwatch()..start();

    try {
      await _migrateSettings(prefs);
      await _migrateFavorites(prefs);
      await _migrateBookmarks(prefs);
      await _migrateReadingProgress(prefs);
      await _migrateKhatmah(prefs);
      await _migrateTasbeeh(prefs);
      await _migrateAdhkarState(prefs);
      await _migratePrayerTimesCache(prefs);
      await _migrateTasbihStats(prefs);
      await _migrateTasbihHistory(prefs);
      await _migrateCustomTasbih(prefs);
      await _migrateDailyContent(prefs);

      await prefs.setBool(_migrationKey, true);
      _migrationDone = true;
      debugPrint('[DataMigrator] Migration complete in ${sw.elapsedMilliseconds} ms');
    } catch (e) {
      debugPrint('[DataMigrator] Migration failed: $e');
    }
  }

  static Future<void> _migrateSettings(SharedPreferences prefs) async {
    final jsonStr = prefs.getString('settings');
    if (jsonStr == null) return;
    await IsarService.saveSettings(jsonStr);
    debugPrint('[DataMigrator] Settings migrated');
  }

  static Future<void> _migrateFavorites(SharedPreferences prefs) async {
    final jsonStr = prefs.getString('favorites');
    if (jsonStr == null) return;
    try {
      final list = json.decode(jsonStr) as List<dynamic>;
      final entries = <FavoriteIsar>[];
      for (final item in list) {
        final map = item as Map<String, dynamic>;
        final id = map['id'] ?? '';
        final typeIndex = map['type'] ?? 0;
        entries.add(FavoriteIsar()
          ..uniqueKey = '${typeIndex}_$id'
          ..typeIndex = typeIndex
          ..textArabic = map['textArabic'] ?? ''
          ..reference = map['reference'] ?? ''
          ..dateAdded = map['dateAdded'] != null
              ? DateTime.parse(map['dateAdded'])
              : DateTime.now()
          ..metadata = json.encode(map['metadata'] ?? {}));
      }
      final isar = await IsarService.getInstance();
      await isar.writeTxn(() async {
        await IsarService.favorites.putAll(entries);
      });
      debugPrint('[DataMigrator] Favorites migrated: ${entries.length} items');
    } catch (e) {
      debugPrint('[DataMigrator] Favorites migration error: $e');
    }
  }

  static Future<void> _migrateBookmarks(SharedPreferences prefs) async {
    final jsonStr = prefs.getString('bookmarks_v2');
    if (jsonStr == null) return;
    try {
      final list = json.decode(jsonStr) as List<dynamic>;
      final entries = <BookmarkIsar>[];
      for (final item in list) {
        final map = item as Map<String, dynamic>;
        final id = map['id'] ?? '';
        final typeIndex = map['type'] ?? 0;
        entries.add(BookmarkIsar()
          ..uniqueKey = '${typeIndex}_$id'
          ..typeIndex = typeIndex
          ..title = map['title'] ?? ''
          ..subtitle = map['subtitle'] ?? ''
          ..data = json.encode(map['data'] ?? {})
          ..createdAt = map['createdAt'] != null
              ? DateTime.parse(map['createdAt'])
              : DateTime.now());
      }
      final isar = await IsarService.getInstance();
      await isar.writeTxn(() async {
        await IsarService.bookmarks.putAll(entries);
      });
      debugPrint('[DataMigrator] Bookmarks migrated: ${entries.length} items');
    } catch (e) {
      debugPrint('[DataMigrator] Bookmarks migration error: $e');
    }
  }

  static Future<void> _migrateReadingProgress(SharedPreferences prefs) async {
    final jsonStr = prefs.getString('last_read');
    if (jsonStr == null) return;
    try {
      final map = json.decode(jsonStr) as Map<String, dynamic>;
      final rp = ReadingProgressIsar()
        ..bookId = map['bookId'] ?? 'default'
        ..surahNumber = map['surahNumber'] ?? 1
        ..ayahNumber = map['ayahNumber'] ?? 1
        ..page = map['page'] ?? 1
        ..juz = map['juz'] ?? 1
        ..updatedAt = DateTime.now();
      await IsarService.putReadingProgress(rp);
      debugPrint('[DataMigrator] Reading progress migrated');
    } catch (e) {
      debugPrint('[DataMigrator] Reading progress migration error: $e');
    }
  }

  static Future<void> _migrateKhatmah(SharedPreferences prefs) async {
    final jsonStr = prefs.getString('khatmah');
    if (jsonStr == null) return;
    try {
      final map = json.decode(jsonStr) as Map<String, dynamic>;
      final streak = List<int>.from(map['readingStreak'] ?? []);
      final k = KhatmahIsar()
        ..currentPage = map['currentPage'] ?? 0
        ..currentSurah = map['currentSurah'] ?? 1
        ..currentAyah = map['currentAyah'] ?? 1
        ..totalAyahsRead = map['totalAyahsRead'] ?? 0
        ..startDate = map['startDate'] != null
            ? DateTime.parse(map['startDate'])
            : DateTime.now()
        ..lastReadDate = map['lastReadDate'] != null
            ? DateTime.parse(map['lastReadDate'])
            : DateTime.now()
        ..name = map['name'] ?? 'ختمتي'
        ..readingStreakJson = json.encode(streak);
      await IsarService.saveKhatmah(k);
      debugPrint('[DataMigrator] Khatmah migrated');
    } catch (e) {
      debugPrint('[DataMigrator] Khatmah migration error: $e');
    }
  }

  static Future<void> _migrateTasbeeh(SharedPreferences prefs) async {
    final jsonStr = prefs.getString('tasbeeh');
    if (jsonStr == null) return;
    try {
      final list = json.decode(jsonStr) as List<dynamic>;
      final entries = <TasbeehIsar>[];
      for (final item in list) {
        final map = item as Map<String, dynamic>;
        final id = map['id'] ?? '';
        entries.add(TasbeehIsar()
          ..uniqueKey = id
          ..name = map['name'] ?? ''
          ..nameArabic = map['nameArabic'] ?? ''
          ..count = map['count'] ?? 0
          ..target = map['target'] ?? 33
          ..lastUsed = map['lastUsed'] != null
              ? DateTime.parse(map['lastUsed'])
              : DateTime.now());
      }
      final isar = await IsarService.getInstance();
      await isar.writeTxn(() async {
        await IsarService.tasbeeh.putAll(entries);
      });
      debugPrint('[DataMigrator] Tasbeeh migrated: ${entries.length} items');
    } catch (e) {
      debugPrint('[DataMigrator] Tasbeeh migration error: $e');
    }
  }

  static Future<void> _migrateAdhkarState(SharedPreferences prefs) async {
    final jsonStr = prefs.getString('adhkar');
    if (jsonStr == null) return;
    try {
      final list = json.decode(jsonStr) as List<dynamic>;
      final entries = <AdhkarStateIsar>[];
      for (final catItem in list) {
        final catMap = catItem as Map<String, dynamic>;
        final catId = catMap['id'] ?? '';
        final adhkarList = catMap['adhkar'] as List<dynamic>? ?? [];
        for (final dhikrItem in adhkarList) {
          final dhikrMap = dhikrItem as Map<String, dynamic>;
          final dhikrId = dhikrMap['id'] ?? '';
          entries.add(AdhkarStateIsar()
            ..uniqueKey = '${catId}_$dhikrId'
            ..categoryId = catId
            ..dhikrId = dhikrId
            ..currentCount = dhikrMap['current_count'] ?? dhikrMap['currentCount'] ?? 0
            ..isFavorite = dhikrMap['is_favorite'] ?? dhikrMap['isFavorite'] ?? false);
        }
      }
      final isar = await IsarService.getInstance();
      await isar.writeTxn(() async {
        await IsarService.adhkarState.putAll(entries);
      });
      debugPrint('[DataMigrator] Adhkar state migrated: ${entries.length} entries');
    } catch (e) {
      debugPrint('[DataMigrator] Adhkar state migration error: $e');
    }
  }

  static Future<void> _migratePrayerTimesCache(SharedPreferences prefs) async {
    final allKeys = prefs.getKeys();
    final cachePrefix = 'prayer_times_cache_';
    int count = 0;
    for (final key in allKeys) {
      if (!key.startsWith(cachePrefix)) continue;
      final jsonStr = prefs.getString(key);
      if (jsonStr == null) continue;
      final cacheKey = key.replaceFirst(cachePrefix, '');
      await IsarService.cachePrayerTimes(PrayerTimesCacheIsar()
        ..dateLocationKey = cacheKey
        ..fullJson = jsonStr
        ..fetchedAt = DateTime.now());
      count++;
    }
    if (count > 0) {
      debugPrint('[DataMigrator] Prayer times cache migrated: $count entries');
    }
  }

  static Future<void> _migrateTasbihStats(SharedPreferences prefs) async {
    final jsonStr = prefs.getString('tasbeeh_stats_v2');
    if (jsonStr == null) return;
    try {
      final map = json.decode(jsonStr) as Map<String, dynamic>;
      await IsarService.saveTasbihStats(TasbihStatsIsar()
        ..todayCount = map['today'] ?? 0
        ..totalCount = map['lifetime'] ?? 0
        ..date = prefs.getString('tasbih_stats_date') ?? ''
        ..weeklyCountsJson = '[]'
        ..monthlyCountsJson = '[]'
        ..dailyGoal = 1000);
      debugPrint('[DataMigrator] Tasbih stats migrated');
    } catch (e) {
      debugPrint('[DataMigrator] Tasbih stats migration error: $e');
    }
  }

  static Future<void> _migrateTasbihHistory(SharedPreferences prefs) async {
    final jsonStr = prefs.getString('tasbeeh_history');
    if (jsonStr == null) return;
    try {
      final list = json.decode(jsonStr) as List<dynamic>;
      final entries = <TasbihHistoryIsar>[];
      for (final item in list) {
        final map = item as Map<String, dynamic>;
        entries.add(TasbihHistoryIsar()
          ..sessionId = map['id'] ?? ''
          ..type = map['type'] ?? ''
          ..label = map['label'] ?? ''
          ..count = map['count'] ?? 0
          ..startedAt = map['startedAt'] != null
              ? DateTime.parse(map['startedAt'])
              : DateTime.now()
          ..durationSeconds = map['duration'] ?? 0);
      }
      final isar = await IsarService.getInstance();
      await isar.writeTxn(() async {
        await IsarService.tasbihHistory.putAll(entries);
      });
      debugPrint('[DataMigrator] Tasbih history migrated: ${entries.length} items');
    } catch (e) {
      debugPrint('[DataMigrator] Tasbih history migration error: $e');
    }
  }

  static Future<void> _migrateCustomTasbih(SharedPreferences prefs) async {
    final jsonStr = prefs.getString('tasbeeh_custom');
    if (jsonStr == null) return;
    try {
      final list = json.decode(jsonStr) as List<dynamic>;
      final entries = <CustomTasbihIsar>[];
      for (final item in list) {
        final map = item as Map<String, dynamic>;
        final id = map['id'] ?? '';
        entries.add(CustomTasbihIsar()
          ..uniqueKey = id
          ..name = map['name'] ?? ''
          ..nameArabic = map['nameArabic'] ?? ''
          ..target = map['target'] ?? 33
          ..isFavorite = map['favorite'] ?? false
          ..createdAt = map['createdAt'] != null
              ? DateTime.parse(map['createdAt'])
              : DateTime.now());
      }
      final isar = await IsarService.getInstance();
      await isar.writeTxn(() async {
        await IsarService.customTasbih.putAll(entries);
      });
      debugPrint('[DataMigrator] Custom tasbih migrated: ${entries.length} items');
    } catch (e) {
      debugPrint('[DataMigrator] Custom tasbih migration error: $e');
    }
  }

  static Future<void> _migrateDailyContent(SharedPreferences prefs) async {
    final verseIdx = prefs.getInt('last_verse_index') ?? 0;
    final hadithIdx = prefs.getInt('last_hadith_index') ?? 0;
    await IsarService.saveDailyContent(DailyContentIsar()
      ..lastVerseIndex = verseIdx
      ..lastHadithIndex = hadithIdx
      ..lastVerseDate = ''
      ..lastHadithDate = '');
    debugPrint('[DataMigrator] Daily content migrated');
  }
}

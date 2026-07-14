import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import '../data/models/quran_audio_models.dart';
import '../data/models/persisted_playback_state.dart';

class AudioStorageService {
  static const _favRecitersKey = 'quran_audio_fav_reciters';
  static const _favSurahsKey = 'quran_audio_fav_surahs';
  static const _recentlyPlayedKey = 'quran_audio_recently_played';
  static const _playbackStateKey = 'quran_audio_playback_state';
  static const _maxRecentEntries = 20;

  // ─── Favorites ───

  Future<Set<String>> getFavoriteReciterIds() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_favRecitersKey);
    return (list ?? []).toSet();
  }

  Future<void> toggleFavoriteReciter(String reciterId) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_favRecitersKey) ?? [];
    if (list.contains(reciterId)) {
      list.remove(reciterId);
    } else {
      list.add(reciterId);
    }
    await prefs.setStringList(_favRecitersKey, list);
  }

  Future<bool> isFavoriteReciter(String reciterId) async {
    final ids = await getFavoriteReciterIds();
    return ids.contains(reciterId);
  }

  Future<Set<String>> getFavoriteSurahKeys() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_favSurahsKey);
    return (list ?? []).toSet();
  }

  Future<void> toggleFavoriteSurah(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_favSurahsKey) ?? [];
    if (list.contains(key)) {
      list.remove(key);
    } else {
      list.add(key);
    }
    await prefs.setStringList(_favSurahsKey, list);
  }

  Future<bool> isFavoriteSurah(String key) async {
    final keys = await getFavoriteSurahKeys();
    return keys.contains(key);
  }

  // ─── Recently Played ───

  Future<List<RecentlyPlayedEntry>> getRecentlyPlayed() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_recentlyPlayedKey) ?? [];
    return jsonList
        .map((s) {
          try {
            return RecentlyPlayedEntry.fromJson(
                json.decode(s) as Map<String, dynamic>);
          } catch (_) {
            return null;
          }
        })
        .whereType<RecentlyPlayedEntry>()
        .toList();
  }

  Future<void> addRecentlyPlayed(RecentlyPlayedEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_recentlyPlayedKey) ?? [];

    jsonList.removeWhere((s) {
      try {
        final existing =
            RecentlyPlayedEntry.fromJson(json.decode(s) as Map<String, dynamic>);
        return existing.reciterId == entry.reciterId &&
            existing.surahNumber == entry.surahNumber &&
            existing.moshafId == entry.moshafId;
      } catch (_) {
        return false;
      }
    });

    jsonList.insert(0, json.encode(entry.toJson()));

    while (jsonList.length > _maxRecentEntries) {
      jsonList.removeLast();
    }

    await prefs.setStringList(_recentlyPlayedKey, jsonList);
  }

  // ─── Playback State Persistence ───

  Future<void> savePlaybackState(PersistedPlaybackState state) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_playbackStateKey, state.encode());
  }

  Future<PersistedPlaybackState?> loadPlaybackState() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_playbackStateKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      return PersistedPlaybackState.decode(raw);
    } catch (_) {
      return null;
    }
  }

  Future<void> clearPlaybackState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_playbackStateKey);
  }

  // ─── Storage Stats ───

  Future<int> getDownloadedSize() async {
    try {
      final dir = await _getDownloadDir();
      if (!await dir.exists()) return 0;
      int total = 0;
      await for (final entity in dir.list(recursive: true)) {
        if (entity is File) {
          total += await entity.length();
        }
      }
      return total;
    } catch (_) {
      return 0;
    }
  }

  Future<int> getDownloadedFileCount() async {
    try {
      final dir = await _getDownloadDir();
      if (!await dir.exists()) return 0;
      int count = 0;
      await for (final entity in dir.list()) {
        if (entity is File) count++;
      }
      return count;
    } catch (_) {
      return 0;
    }
  }

  Future<void> clearAllDownloads() async {
    try {
      final dir = await _getDownloadDir();
      if (await dir.exists()) {
        await dir.delete(recursive: true);
      }
    } catch (_) {}
  }

  Future<void> clearCache() async {
    try {
      final tempDir = await getTemporaryDirectory();
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    } catch (_) {}
  }

  Future<int> getCacheSize() async {
    try {
      final tempDir = await getTemporaryDirectory();
      if (!await tempDir.exists()) return 0;
      int total = 0;
      await for (final entity in tempDir.list(recursive: true)) {
        if (entity is File) {
          total += await entity.length();
        }
      }
      return total;
    } catch (_) {
      return 0;
    }
  }

  Future<Directory> _getDownloadDir() async {
    final dir = await getApplicationDocumentsDirectory();
    return Directory('${dir.path}/quran_audio');
  }
}

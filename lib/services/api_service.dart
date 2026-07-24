import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../core/cache/hive_cache_manager.dart';
import '../models/api_models.dart';

class AlQuranApiService {
  static const String _baseUrl = 'https://api.alquran.cloud/v1';
  static const Duration _defaultCacheTtl = Duration(hours: 24);
  static const int _maxRetries = 3;

  static Future<RandomAyahResponse?> getRandomAyah() async {
    try {
      final cacheKey = 'quran_random_ayah';
      final cached = _getCached(cacheKey);
      if (cached != null) {
        debugPrint('[QuranApi] HIT $cacheKey');
        return RandomAyahResponse.fromJson(cached);
      }

      final data = await _fetchWithRetry('$_baseUrl/ayah/random/en.sahih');
      if (data != null) {
        _setCached(cacheKey, data);
        return RandomAyahResponse.fromJson(data);
      }
      return null;
    } catch (e) {
      debugPrint('[QuranApi] getRandomAyah error: $e');
      return null;
    }
  }

  static Future<List<AyahData>?> getRandomAyahEditions() async {
    try {
      final cacheKey = 'quran_random_editions';
      final cached = _getCached(cacheKey);
      if (cached != null) {
        debugPrint('[QuranApi] HIT $cacheKey');
        final response = AyahEditionsResponse.fromJson(cached);
        return response.data;
      }

      final data = await _fetchWithRetry(
          '$_baseUrl/ayah/random/editions/quran-uthmani,en.sahih');
      if (data != null) {
        _setCached(cacheKey, data);
        final response = AyahEditionsResponse.fromJson(data);
        return response.data;
      }
      return null;
    } catch (e) {
      debugPrint('[QuranApi] getRandomAyahEditions error: $e');
      return null;
    }
  }

  static Future<SurahResponse?> getSurah(int number) async {
    try {
      final cacheKey = 'quran_surah_$number';
      final cached = _getCached(cacheKey);
      if (cached != null) {
        debugPrint('[QuranApi] HIT $cacheKey');
        return SurahResponse.fromJson(cached);
      }

      final data = await _fetchWithRetry('$_baseUrl/surah/$number');
      if (data != null) {
        _setCached(cacheKey, data);
        return SurahResponse.fromJson(data);
      }
      return null;
    } catch (e) {
      debugPrint('[QuranApi] getSurah($number) error: $e');
      return null;
    }
  }

  static Future<List<SurahInfo>?> getAllSurahs() async {
    try {
      final cacheKey = 'quran_all_surahs';
      final cached = _getCached(cacheKey);
      if (cached != null) {
        debugPrint('[QuranApi] HIT $cacheKey');
        final response = SurahsListResponse.fromJson(cached);
        return response.data;
      }

      final data = await _fetchWithRetry('$_baseUrl/surah');
      if (data != null) {
        _setCached(cacheKey, data);
        final response = SurahsListResponse.fromJson(data);
        return response.data;
      }
      return null;
    } catch (e) {
      debugPrint('[QuranApi] getAllSurahs error: $e');
      return null;
    }
  }

  static Future<AyahEditionsResponse?> getAyahEditions(int number) async {
    try {
      final cacheKey = 'quran_editions_$number';
      final cached = _getCached(cacheKey);
      if (cached != null) {
        debugPrint('[QuranApi] HIT $cacheKey');
        return AyahEditionsResponse.fromJson(cached);
      }

      final data = await _fetchWithRetry(
          '$_baseUrl/ayah/$number/editions/quran-uthmani,en.sahih');
      if (data != null) {
        _setCached(cacheKey, data);
        return AyahEditionsResponse.fromJson(data);
      }
      return null;
    } catch (e) {
      debugPrint('[QuranApi] getAyahEditions($number) error: $e');
      return null;
    }
  }

  static Future<SearchResponse?> searchQuran(String word) async {
    try {
      final result = await _fetchWithRetry('$_baseUrl/search/$word/all/en');
      if (result != null) {
        return SearchResponse.fromJson(result);
      }
      return null;
    } catch (e) {
      debugPrint('[QuranApi] searchQuran($word) error: $e');
      return null;
    }
  }

  static Future<JuzResponse?> getJuz(int number) async {
    try {
      final cacheKey = 'quran_juz_$number';
      final cached = _getCached(cacheKey);
      if (cached != null) {
        debugPrint('[QuranApi] HIT $cacheKey');
        return JuzResponse.fromJson(cached);
      }

      final data = await _fetchWithRetry('$_baseUrl/juz/$number');
      if (data != null) {
        _setCached(cacheKey, data);
        return JuzResponse.fromJson(data);
      }
      return null;
    } catch (e) {
      debugPrint('[QuranApi] getJuz($number) error: $e');
      return null;
    }
  }

  // ─── Retry + Cache Helpers ──────────────────────────────────────────────

  static Future<Map<String, dynamic>?> _fetchWithRetry(String url) async {
    for (int attempt = 0; attempt < _maxRetries; attempt++) {
      try {
        final response =
            await http.get(Uri.parse(url)).timeout(const Duration(seconds: 15));
        if (response.statusCode == 200) {
          return json.decode(response.body) as Map<String, dynamic>;
        }
        if (response.statusCode == 429 || response.statusCode >= 500) {
          final retryAfter = response.headers['retry-after'];
          final delay = retryAfter != null
              ? (int.tryParse(retryAfter) ?? (1 << attempt))
              : (1 << attempt);
          debugPrint(
              '[QuranApi] ${response.statusCode} on attempt ${attempt + 1}, retrying in ${delay}s');
          await Future.delayed(Duration(seconds: delay));
          continue;
        }
        debugPrint('[QuranApi] ${response.statusCode} for $url');
        return null;
      } catch (e) {
        if (attempt < _maxRetries - 1) {
          final delay = 1 << attempt;
          debugPrint(
              '[QuranApi] error on attempt ${attempt + 1}: $e, retrying in ${delay}s');
          await Future.delayed(Duration(seconds: delay));
          continue;
        }
        rethrow;
      }
    }
    return null;
  }

  static Map<String, dynamic>? _getCached(String key) {
    final raw = HiveCacheManager.getCachedString('api_cache_$key');
    if (raw == null) return null;
    try {
      final decoded = json.decode(raw) as Map<String, dynamic>;
      final expiryMs = decoded['expiry'] as int?;
      if (expiryMs != null &&
          DateTime.now().millisecondsSinceEpoch < expiryMs) {
        return decoded['data'] as Map<String, dynamic>?;
      }
      HiveCacheManager.remove('api_cache_$key');
    } catch (_) {
      HiveCacheManager.remove('api_cache_$key');
    }
    return null;
  }

  static Future<void> _setCached(
      String key, Map<String, dynamic> data) async {
    final encoded = {
      'data': data,
      'expiry':
          DateTime.now().add(_defaultCacheTtl).millisecondsSinceEpoch,
    };
    await HiveCacheManager.cacheString(
      'api_cache_$key',
      json.encode(encoded),
      ttl: _defaultCacheTtl,
    );
  }
}

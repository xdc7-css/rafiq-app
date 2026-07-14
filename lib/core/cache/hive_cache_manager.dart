import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';

class HiveCacheManager {
  static const String _boxName = 'shia_hadith_cache';
  static const String _metaBoxName = 'shia_cache_meta';
  static const Duration _defaultTtl = Duration(hours: 24);

  static Box? _cacheBox;
  static Box? _metaBox;

  static Future<void> init() async {
    _cacheBox ??= await Hive.openBox(_boxName);
    _metaBox ??= await Hive.openBox(_metaBoxName);
  }

  static Future<void> _ensureInit() async {
    if (_cacheBox == null || !_cacheBox!.isOpen) await init();
  }

  static Future<void> cacheList(
    String key,
    List<Map<String, dynamic>> data, {
    Duration? ttl,
  }) async {
    await _ensureInit();
    final expiry = DateTime.now().add(ttl ?? _defaultTtl);
    await _cacheBox!.put(key, json.encode(data));
    await _metaBox!.put('${key}_expiry', expiry.millisecondsSinceEpoch);
  }

  static List<Map<String, dynamic>>? getCachedList(String key) {
    if (_cacheBox == null) return null;
    final expiryMs = _metaBox?.get('${key}_expiry') as int?;
    if (expiryMs == null) return null;
    if (DateTime.now().millisecondsSinceEpoch > expiryMs) {
      _cacheBox!.delete(key);
      _metaBox!.delete('${key}_expiry');
      return null;
    }
    final raw = _cacheBox!.get(key) as String?;
    if (raw == null) return null;
    try {
      final decoded = json.decode(raw) as List;
      return decoded.cast<Map<String, dynamic>>();
    } catch (_) {
      return null;
    }
  }

  static Future<void> cacheMap(String key, Map<String, dynamic> data,
      {Duration? ttl}) async {
    await _ensureInit();
    final expiry = DateTime.now().add(ttl ?? _defaultTtl);
    await _cacheBox!.put(key, json.encode(data));
    await _metaBox!.put('${key}_expiry', expiry.millisecondsSinceEpoch);
  }

  static Map<String, dynamic>? getCachedMap(String key) {
    if (_cacheBox == null) return null;
    final expiryMs = _metaBox?.get('${key}_expiry') as int?;
    if (expiryMs == null) return null;
    if (DateTime.now().millisecondsSinceEpoch > expiryMs) {
      _cacheBox!.delete(key);
      _metaBox!.delete('${key}_expiry');
      return null;
    }
    final raw = _cacheBox!.get(key) as String?;
    if (raw == null) return null;
    try {
      return json.decode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  static Future<void> cacheString(String key, String value,
      {Duration? ttl}) async {
    await _ensureInit();
    final expiry = DateTime.now().add(ttl ?? _defaultTtl);
    await _cacheBox!.put(key, value);
    await _metaBox!.put('${key}_expiry', expiry.millisecondsSinceEpoch);
  }

  static String? getCachedString(String key) {
    if (_cacheBox == null) return null;
    final expiryMs = _metaBox?.get('${key}_expiry') as int?;
    if (expiryMs == null) return null;
    if (DateTime.now().millisecondsSinceEpoch > expiryMs) {
      _cacheBox!.delete(key);
      _metaBox!.delete('${key}_expiry');
      return null;
    }
    return _cacheBox!.get(key) as String?;
  }

  static bool isCached(String key) {
    if (_cacheBox == null) return false;
    if (!_cacheBox!.containsKey(key)) return false;
    final expiryMs = _metaBox?.get('${key}_expiry') as int?;
    if (expiryMs == null) return false;
    return DateTime.now().millisecondsSinceEpoch <= expiryMs;
  }

  static Future<void> remove(String key) async {
    await _ensureInit();
    await _cacheBox!.delete(key);
    await _metaBox!.delete('${key}_expiry');
  }

  static Future<void> clearAll() async {
    await _ensureInit();
    await _cacheBox!.clear();
    await _metaBox!.clear();
  }

  static int get cacheSize => _cacheBox?.length ?? 0;

  static Future<void> cleanupExpired() async {
    await _ensureInit();
    final now = DateTime.now().millisecondsSinceEpoch;
    final keysToDelete = <String>[];
    for (final key in _metaBox!.keys) {
      if (key.toString().endsWith('_expiry')) {
        final expiryMs = _metaBox!.get(key) as int?;
        if (expiryMs != null && now > expiryMs) {
          final cacheKey = key.toString().replaceAll('_expiry', '');
          keysToDelete.add(cacheKey);
          keysToDelete.add(key.toString());
        }
      }
    }
    for (final key in keysToDelete) {
      await _cacheBox!.delete(key);
      await _metaBox!.delete(key);
    }
  }
}

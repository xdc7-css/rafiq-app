import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CacheManager {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static Future<void> _ensureInit() async {
    if (_prefs == null) {
      await init();
    }
  }

  static Future<void> cacheString(String key, String value) async {
    await _ensureInit();
    await _prefs!.setString(key, value);
  }

  static String? getString(String key) {
    if (_prefs == null) return null;
    return _prefs!.getString(key);
  }

  static Future<void> cacheJson(String key, Map<String, dynamic> value) async {
    await _ensureInit();
    await _prefs!.setString(key, json.encode(value));
  }

  static Map<String, dynamic>? getJson(String key) {
    if (_prefs == null) return null;
    final data = _prefs!.getString(key);
    if (data == null) return null;
    try {
      return json.decode(data) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  static Future<void> cacheJsonList(String key, List<dynamic> value) async {
    await _ensureInit();
    await _prefs!.setString(key, json.encode(value));
  }

  static List<dynamic>? getJsonList(String key) {
    if (_prefs == null) return null;
    final data = _prefs!.getString(key);
    if (data == null) return null;
    try {
      return json.decode(data) as List<dynamic>;
    } catch (_) {
      return null;
    }
  }

  static Future<void> cacheInt(String key, int value) async {
    await _ensureInit();
    await _prefs!.setInt(key, value);
  }

  static int? getInt(String key) {
    if (_prefs == null) return null;
    return _prefs!.getInt(key);
  }

  static Future<void> cacheBool(String key, bool value) async {
    await _ensureInit();
    await _prefs!.setBool(key, value);
  }

  static bool? getBool(String key) {
    if (_prefs == null) return null;
    return _prefs!.getBool(key);
  }

  static Future<void> remove(String key) async {
    await _ensureInit();
    await _prefs!.remove(key);
  }

  static Future<void> clearAll() async {
    await _ensureInit();
    await _prefs!.clear();
  }
}
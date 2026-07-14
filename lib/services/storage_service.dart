import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';
import '../core/constants.dart';

class StorageService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static Future<void> _ensureInit() async {
    if (_prefs == null) {
      await init();
    }
  }

  // Onboarding
  static bool getOnboardingComplete() {
    if (_prefs == null) return false;
    return _prefs!.getBool(AppConstants.keyOnboardingComplete) ?? false;
  }

  static Future<void> setOnboardingComplete(bool value) async {
    await _ensureInit();
    await _prefs!.setBool(AppConstants.keyOnboardingComplete, value);
  }

  // Verse/Hadith Index
  static int? getLastVerseIndex() {
    if (_prefs == null) return null;
    return _prefs!.getInt(AppConstants.keyLastVerseIndex);
  }

  static Future<void> setLastVerseIndex(int index) async {
    await _ensureInit();
    await _prefs!.setInt(AppConstants.keyLastVerseIndex, index);
  }

  static int? getLastHadithIndex() {
    if (_prefs == null) return null;
    return _prefs!.getInt(AppConstants.keyLastHadithIndex);
  }

  static Future<void> setLastHadithIndex(int index) async {
    await _ensureInit();
    await _prefs!.setInt(AppConstants.keyLastHadithIndex, index);
  }

  // Settings
  static AppSettings getSettings() {
    if (_prefs == null) return AppSettings();
    final jsonString = _prefs!.getString('settings');
    if (jsonString == null) {
      final settings = AppSettings();
      saveSettings(settings);
      return settings;
    }
    try {
      return AppSettings.fromJson(json.decode(jsonString));
    } catch (_) {
      return AppSettings();
    }
  }

  static Future<void> saveSettings(AppSettings settings) async {
    await _ensureInit();
    await _prefs!.setString('settings', json.encode(settings.toJson()));
  }

  // Favorites
  static List<FavoriteModel> getFavorites() {
    if (_prefs == null) return [];
    final jsonString = _prefs!.getString('favorites');
    if (jsonString == null) return [];
    try {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((j) => FavoriteModel.fromJson(j)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> saveFavorites(List<FavoriteModel> favorites) async {
    await _ensureInit();
    final jsonList = favorites.map((f) => f.toJson()).toList();
    await _prefs!.setString('favorites', json.encode(jsonList));
  }

  static Future<void> addFavorite(FavoriteModel favorite) async {
    final favorites = getFavorites();
    favorites.add(favorite);
    await saveFavorites(favorites);
  }

  static Future<void> removeFavorite(String id) async {
    final favorites = getFavorites();
    favorites.removeWhere((f) => f.id == id);
    await saveFavorites(favorites);
  }

  // Khatmah
  static KhatmahModel? getCurrentKhatmah() {
    if (_prefs == null) return null;
    final jsonString = _prefs!.getString('khatmah');
    if (jsonString == null) return null;
    try {
      return KhatmahModel.fromJson(json.decode(jsonString));
    } catch (_) {
      return null;
    }
  }

  static Future<void> saveKhatmah(KhatmahModel khatmah) async {
    await _ensureInit();
    await _prefs!.setString('khatmah', json.encode(khatmah.toJson()));
  }

  static Future<void> deleteKhatmah() async {
    await _ensureInit();
    await _prefs!.remove('khatmah');
  }

  // Tasbeeh
  static List<TasbeehModel> getTasbeehList() {
    if (_prefs == null) return [];
    final jsonString = _prefs!.getString('tasbeeh');
    if (jsonString == null) return [];
    try {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((j) => TasbeehModel.fromJson(j)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> saveTasbeehList(List<TasbeehModel> list) async {
    await _ensureInit();
    final jsonList = list.map((t) => t.toJson()).toList();
    await _prefs!.setString('tasbeeh', json.encode(jsonList));
  }

  static Future<void> saveTasbeeh(TasbeehModel tasbeeh) async {
    final list = getTasbeehList();
    final index = list.indexWhere((t) => t.id == tasbeeh.id);
    if (index >= 0) {
      list[index] = tasbeeh;
    } else {
      list.add(tasbeeh);
    }
    await saveTasbeehList(list);
  }

  static Future<void> deleteTasbeeh(String id) async {
    final list = getTasbeehList();
    list.removeWhere((t) => t.id == id);
    await saveTasbeehList(list);
  }

  // Adhkar
  static Future<void> saveAdhkarCategory(AdhkarCategory category) async {
    final categories = getAdhkarCategories();
    final index = categories.indexWhere((c) => c.id == category.id);
    if (index >= 0) {
      categories[index] = category;
    } else {
      categories.add(category);
    }
    final jsonList = categories.map((c) => c.toJson()).toList();
    await _ensureInit();
    await _prefs!.setString('adhkar', json.encode(jsonList));
  }

  static List<AdhkarCategory> getAdhkarCategories() {
    if (_prefs == null) return [];
    final jsonString = _prefs!.getString('adhkar');
    if (jsonString == null) return [];
    try {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((j) => AdhkarCategory.fromJson(j)).toList();
    } catch (_) {
      return [];
    }
  }

  // Tasbeeh Al Zahra
  static String? getTasbeehAlZahraState() {
    if (_prefs == null) return null;
    return _prefs!.getString('tasbeeh_al_zahra');
  }

  static Future<void> saveTasbeehAlZahraState(String jsonString) async {
    await _ensureInit();
    await _prefs!.setString('tasbeeh_al_zahra', jsonString);
  }

  // ── Prayer Scheduler ──────────────────────────────────────────────────────

  /// Persist the day key (YYYYMMDD-like int) of the last scheduled day.
  /// Used by PrayerScheduler to skip redundant reschedules.
  static Future<void> saveLastScheduledDay(int dayKey) async {
    await _ensureInit();
    await _prefs!.setInt('last_scheduled_prayer_day', dayKey);
  }

  static int getLastScheduledDay() {
    if (_prefs == null) return -1;
    return _prefs!.getInt('last_scheduled_prayer_day') ?? -1;
  }
}
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';
import 'time_formatter.dart';

bool get _isSupported =>
    !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

class HomeWidgetService {
  HomeWidgetService._();

  static Timer? _timer;

  // ─── SharedPreferences Keys (must match Android Kotlin) ───
  static const String kNextPrayerName = 'widget_next_prayer';
  static const String kNextPrayerTime = 'widget_next_time';
  static const String kCountdown = 'widget_countdown';

  static const String kFajrTime = 'widget_fajr_time';
  static const String kDhuhrTime = 'widget_dhuhr_time';
  static const String kAsrTime = 'widget_asr_time';
  static const String kMaghribTime = 'widget_maghrib_time';
  static const String kIshaTime = 'widget_isha_time';

  static const String kSunriseTime = 'widget_sunrise_time';

  static const String kQuranSurahName = 'widget_quran_surah_name';
  static const String kQuranSurahNumber = 'widget_quran_surah_number';
  static const String kQuranAyah = 'widget_quran_ayah';
  static const String kQuranPage = 'widget_quran_page';
  static const String kQuranTotalPages = 'widget_quran_total_pages';
  static const String kQuranProgress = 'widget_quran_progress';
  static const String kQuranHasKhatmah = 'widget_quran_has_khatmah';

  static const String kTasbihName = 'widget_tasbih_name';
  static const String kTasbihCount = 'widget_tasbih_count';
  static const String kTasbihTarget = 'widget_tasbih_target';
  static const String kTasbihId = 'widget_tasbih_id';
  static const String kTasbihIndex = 'widget_tasbih_index';
  static const String kTasbihTotalItems = 'widget_tasbih_total_items';

  static const String kHijriDate = 'widget_hijri_date';
  static const String kGregorianDate = 'widget_gregorian_date';
  static const String kDayOfWeek = 'widget_day_of_week';

  static const String kBgColor = 'widget_bg_color';
  static const String kTextColor = 'widget_text_color';
  static const String kFontSize = 'widget_font_size';

  // ─── Init ───
  static Future<void> init() async {
    if (!_isSupported) return;

    try {
      HomeWidget.registerInteractivityCallback(_onInteraction);
    } catch (e) {
      debugPrint('[HomeWidget] registerInteractivityCallback error: $e');
    }

    _startPeriodicUpdate();
  }

  static void _startPeriodicUpdate() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(minutes: 5), (_) {
      updatePrayerCountdown();
    });
  }

  static void dispose() {
    _timer?.cancel();
  }

  // ─── Widget Interaction Callback ───
  static Future<void> _onInteraction(Uri? uri) async {
    if (uri == null) return;
    debugPrint('[HomeWidget] Interaction: $uri');
  }

  // ─── Helpers ───
  static String _calculateCountdown(DateTime nextPrayerTime) {
    final now = DateTime.now();
    final diff = nextPrayerTime.difference(now);
    if (diff.isNegative) return '';
    final hours = diff.inHours;
    final minutes = diff.inMinutes % 60;
    if (hours > 0) {
      return TimeFormatter.formatRemaining(diff);
    }
    return '${TimeFormatter.convertDigits(minutes.toString(), NumeralSystem.arabic)} د';
  }

  static DateTime? _parsePrayerTime(String? timeStr) {
    if (timeStr == null || timeStr.isEmpty) return null;
    try {
      final parts = timeStr.split(':');
      if (parts.length != 2) return null;
      final h = int.tryParse(parts[0]);
      final m = int.tryParse(parts[1]);
      if (h == null || m == null) return null;
      final now = DateTime.now();
      return DateTime(now.year, now.month, now.day, h, m);
    } catch (_) {
      return null;
    }
  }

  // ─── Prayer Times ───
  static Future<void> updatePrayerWidget({
    required String nextPrayerName,
    required String nextPrayerTime,
    required String fajrTime,
    required String dhuhrTime,
    required String asrTime,
    required String maghribTime,
    required String ishaTime,
    String? sunriseTime,
    int? bgColor,
    int? textColor,
    double? fontSize,
  }) async {
    if (!_isSupported) return;

    final nextTime = _parsePrayerTime(nextPrayerTime);
    final countdown = nextTime != null ? _calculateCountdown(nextTime) : '';

    await HomeWidget.saveWidgetData(kNextPrayerName, nextPrayerName);
    await HomeWidget.saveWidgetData(kNextPrayerTime, nextPrayerTime);
    await HomeWidget.saveWidgetData(kCountdown, countdown);
    await HomeWidget.saveWidgetData(kFajrTime, fajrTime);
    await HomeWidget.saveWidgetData(kDhuhrTime, dhuhrTime);
    await HomeWidget.saveWidgetData(kAsrTime, asrTime);
    await HomeWidget.saveWidgetData(kMaghribTime, maghribTime);
    await HomeWidget.saveWidgetData(kIshaTime, ishaTime);
    if (sunriseTime != null) {
      await HomeWidget.saveWidgetData(kSunriseTime, sunriseTime);
    }
    if (bgColor != null) await HomeWidget.saveWidgetData(kBgColor, bgColor);
    if (textColor != null) await HomeWidget.saveWidgetData(kTextColor, textColor);
    if (fontSize != null) {
      await HomeWidget.saveWidgetData(kFontSize, fontSize.toInt());
    }

    await updateAllWidgets();
  }

  static Future<void> updatePrayerCountdown() async {
    if (!_isSupported) return;
    try {
      final fajr = await HomeWidget.getWidgetData<String>(kFajrTime);
      final dhuhr = await HomeWidget.getWidgetData<String>(kDhuhrTime);
      final asr = await HomeWidget.getWidgetData<String>(kAsrTime);
      final maghrib = await HomeWidget.getWidgetData<String>(kMaghribTime);
      final isha = await HomeWidget.getWidgetData<String>(kIshaTime);

      final now = DateTime.now();
      final prayers = <String, String>{
        'widget_fajr_raw': fajr ?? '',
        'widget_dhuhr_raw': dhuhr ?? '',
        'widget_asr_raw': asr ?? '',
        'widget_maghrib_raw': maghrib ?? '',
        'widget_isha_raw': isha ?? '',
      };

      final names = ['widget_fajr_raw', 'widget_dhuhr_raw', 'widget_asr_raw', 'widget_maghrib_raw', 'widget_isha_raw'];
      final displayNames = ['الفجر', 'الظهر', 'العصر', 'المغرب', 'العشاء'];

      String nextName = '';
      String nextTime = '';
      DateTime? nextDateTime;

      for (int i = 0; i < names.length; i++) {
        final time = _parsePrayerTime(prayers[names[i]]);
        if (time != null && time.isAfter(now)) {
          nextName = displayNames[i];
          nextTime = prayers[names[i]]!;
          nextDateTime = time;
          break;
        }
      }

      if (nextName.isEmpty && names.isNotEmpty) {
        nextName = displayNames[0];
        nextTime = prayers[names[0]] ?? '--:--';
        nextDateTime = _parsePrayerTime(nextTime);
      }

      final countdown = nextDateTime != null ? _calculateCountdown(nextDateTime) : '';

      await HomeWidget.saveWidgetData(kNextPrayerName, nextName);
      await HomeWidget.saveWidgetData(kNextPrayerTime, nextTime);
      await HomeWidget.saveWidgetData(kCountdown, countdown);

      await updateAllWidgets();
    } catch (e) {
      debugPrint('[HomeWidget] updatePrayerCountdown error: $e');
    }
  }

  // ─── Quran ───
  static Future<void> updateQuranWidget({
    required String surahName,
    required int surahNumber,
    required int ayah,
    required int page,
    int totalPages = 604,
    bool hasKhatmah = false,
  }) async {
    if (!_isSupported) return;

    final progress = (page / totalPages * 100).round();

    await HomeWidget.saveWidgetData(kQuranSurahName, surahName);
    await HomeWidget.saveWidgetData(kQuranSurahNumber, surahNumber);
    await HomeWidget.saveWidgetData(kQuranAyah, ayah);
    await HomeWidget.saveWidgetData(kQuranPage, page);
    await HomeWidget.saveWidgetData(kQuranTotalPages, totalPages);
    await HomeWidget.saveWidgetData(kQuranProgress, progress);
    await HomeWidget.saveWidgetData(kQuranHasKhatmah, hasKhatmah);

    await updateAllWidgets();
  }

  // ─── Tasbih ───
  static Future<void> updateTasbihWidget({
    required String name,
    required int count,
    required int target,
    required String id,
    int index = 0,
    int totalItems = 1,
  }) async {
    if (!_isSupported) return;

    await HomeWidget.saveWidgetData(kTasbihName, name);
    await HomeWidget.saveWidgetData(kTasbihCount, count);
    await HomeWidget.saveWidgetData(kTasbihTarget, target);
    await HomeWidget.saveWidgetData(kTasbihId, id);
    await HomeWidget.saveWidgetData(kTasbihIndex, index);
    await HomeWidget.saveWidgetData(kTasbihTotalItems, totalItems);

    await updateAllWidgets();
  }

  // ─── Dashboard / Date ───
  static Future<void> updateDashboardDate({
    required String hijriDate,
    required String gregorianDate,
    required String dayOfWeek,
  }) async {
    if (!_isSupported) return;

    await HomeWidget.saveWidgetData(kHijriDate, hijriDate);
    await HomeWidget.saveWidgetData(kGregorianDate, gregorianDate);
    await HomeWidget.saveWidgetData(kDayOfWeek, dayOfWeek);

    await updateAllWidgets();
  }

  // ─── Widget Appearance ───
  static Future<void> updateWidgetAppearance({
    required int bgColor,
    required int textColor,
    required double fontSize,
  }) async {
    if (!_isSupported) return;

    await HomeWidget.saveWidgetData(kBgColor, bgColor);
    await HomeWidget.saveWidgetData(kTextColor, textColor);
    await HomeWidget.saveWidgetData(kFontSize, fontSize.toInt());

    await updateAllWidgets();
  }

  // ─── Trigger Update for All Widgets ───
  static Future<void> updateAllWidgets() async {
    if (!_isSupported) return;
    try {
      const providers = [
        'PrayerTimesWidgetProvider',
        'QuranWidgetProvider',
        'TasbihWidgetProvider',
        'DashboardWidgetProvider',
      ];
      for (final provider in providers) {
        await HomeWidget.updateWidget(androidName: provider);
      }
    } catch (e) {
      debugPrint('[HomeWidget] updateWidget error: $e');
    }
  }

  // ─── Full Sync: Push all current data to widgets ───
  static Future<void> syncAllData({
    required String nextPrayerName,
    required String nextPrayerTime,
    required String fajrTime,
    required String dhuhrTime,
    required String asrTime,
    required String maghribTime,
    required String ishaTime,
    String? sunriseTime,
    String quranSurahName = '',
    int quranSurahNumber = 1,
    int quranAyah = 1,
    int quranPage = 1,
    bool quranHasKhatmah = false,
    String tasbihName = 'سبحان الله',
    int tasbihCount = 0,
    int tasbihTarget = 33,
    String tasbihId = '',
    int tasbihIndex = 0,
    int tasbihTotalItems = 1,
    String hijriDate = '',
    String gregorianDate = '',
    String dayOfWeek = '',
    int bgColor = 0xFF0A1946,
    int textColor = 0xFFD8B56A,
    double fontSize = 14.0,
  }) async {
    if (!_isSupported) return;

    await updatePrayerWidget(
      nextPrayerName: nextPrayerName,
      nextPrayerTime: nextPrayerTime,
      fajrTime: fajrTime,
      dhuhrTime: dhuhrTime,
      asrTime: asrTime,
      maghribTime: maghribTime,
      ishaTime: ishaTime,
      sunriseTime: sunriseTime,
      bgColor: bgColor,
      textColor: textColor,
      fontSize: fontSize,
    );

    await updateQuranWidget(
      surahName: quranSurahName,
      surahNumber: quranSurahNumber,
      ayah: quranAyah,
      page: quranPage,
      hasKhatmah: quranHasKhatmah,
    );

    await updateTasbihWidget(
      name: tasbihName,
      count: tasbihCount,
      target: tasbihTarget,
      id: tasbihId,
      index: tasbihIndex,
      totalItems: tasbihTotalItems,
    );

    await updateDashboardDate(
      hijriDate: hijriDate,
      gregorianDate: gregorianDate,
      dayOfWeek: dayOfWeek,
    );
  }
}

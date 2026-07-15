import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';
import 'time_formatter.dart';
import 'widget_keys.dart';

bool get _isSupported =>
    !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

class HomeWidgetService {
  HomeWidgetService._();

  static Timer? _timer;

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

    await HomeWidget.saveWidgetData(kKeyNextPrayerName, nextPrayerName);
    await HomeWidget.saveWidgetData(kKeyNextPrayerTime, nextPrayerTime);
    await HomeWidget.saveWidgetData(kKeyCountdown, countdown);
    await HomeWidget.saveWidgetData(kKeyFajrTime, fajrTime);
    await HomeWidget.saveWidgetData(kKeyDhuhrTime, dhuhrTime);
    await HomeWidget.saveWidgetData(kKeyAsrTime, asrTime);
    await HomeWidget.saveWidgetData(kKeyMaghribTime, maghribTime);
    await HomeWidget.saveWidgetData(kKeyIshaTime, ishaTime);
    if (sunriseTime != null) {
      await HomeWidget.saveWidgetData(kKeySunriseTime, sunriseTime);
    }
    if (bgColor != null) await HomeWidget.saveWidgetData(kKeyBgColor, bgColor);
    if (textColor != null) {
      await HomeWidget.saveWidgetData(kKeyTextColor, textColor);
    }
    if (fontSize != null) {
      await HomeWidget.saveWidgetData(kKeyFontSize, fontSize.toInt());
    }

    await updateAllWidgets();
  }

  static Future<void> updatePrayerCountdown() async {
    if (!_isSupported) return;
    try {
      final fajr = await HomeWidget.getWidgetData<String>(kKeyFajrTime);
      final dhuhr = await HomeWidget.getWidgetData<String>(kKeyDhuhrTime);
      final asr = await HomeWidget.getWidgetData<String>(kKeyAsrTime);
      final maghrib = await HomeWidget.getWidgetData<String>(kKeyMaghribTime);
      final isha = await HomeWidget.getWidgetData<String>(kKeyIshaTime);

      final now = DateTime.now();
      final prayers = <String, String>{
        'widget_fajr_raw': fajr ?? '',
        'widget_dhuhr_raw': dhuhr ?? '',
        'widget_asr_raw': asr ?? '',
        'widget_maghrib_raw': maghrib ?? '',
        'widget_isha_raw': isha ?? '',
      };

      final names = [
        'widget_fajr_raw',
        'widget_dhuhr_raw',
        'widget_asr_raw',
        'widget_maghrib_raw',
        'widget_isha_raw'
      ];
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

      final countdown =
          nextDateTime != null ? _calculateCountdown(nextDateTime) : '';

      await HomeWidget.saveWidgetData(kKeyNextPrayerName, nextName);
      await HomeWidget.saveWidgetData(kKeyNextPrayerTime, nextTime);
      await HomeWidget.saveWidgetData(kKeyCountdown, countdown);

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

    await HomeWidget.saveWidgetData(kKeyQuranSurahName, surahName);
    await HomeWidget.saveWidgetData(kKeyQuranSurahNumber, surahNumber);
    await HomeWidget.saveWidgetData(kKeyQuranAyah, ayah);
    await HomeWidget.saveWidgetData(kKeyQuranPage, page);
    await HomeWidget.saveWidgetData(kKeyQuranTotalPages, totalPages);
    await HomeWidget.saveWidgetData(kKeyQuranProgress, progress);
    await HomeWidget.saveWidgetData(kKeyQuranHasKhatmah, hasKhatmah);

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

    await HomeWidget.saveWidgetData(kKeyTasbihName, name);
    await HomeWidget.saveWidgetData(kKeyTasbihCount, count);
    await HomeWidget.saveWidgetData(kKeyTasbihTarget, target);
    await HomeWidget.saveWidgetData(kKeyTasbihId, id);
    await HomeWidget.saveWidgetData(kKeyTasbihIndex, index);
    await HomeWidget.saveWidgetData(kKeyTasbihTotalItems, totalItems);

    await updateAllWidgets();
  }

  // ─── Dashboard / Date ───
  static Future<void> updateDashboardDate({
    required String hijriDate,
    required String gregorianDate,
    required String dayOfWeek,
  }) async {
    if (!_isSupported) return;

    await HomeWidget.saveWidgetData(kKeyHijriDate, hijriDate);
    await HomeWidget.saveWidgetData(kKeyGregorianDate, gregorianDate);
    await HomeWidget.saveWidgetData(kKeyDayOfWeek, dayOfWeek);

    await updateAllWidgets();
  }

  // ─── Widget Appearance ───
  static Future<void> updateWidgetAppearance({
    required int bgColor,
    required int textColor,
    required double fontSize,
  }) async {
    if (!_isSupported) return;

    await HomeWidget.saveWidgetData(kKeyBgColor, bgColor);
    await HomeWidget.saveWidgetData(kKeyTextColor, textColor);
    await HomeWidget.saveWidgetData(kKeyFontSize, fontSize.toInt());

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

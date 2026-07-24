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
  static bool _initialized = false;

  static const String _tag = 'WIDGET_FORENSICS';

  // ─── Init ───
  static Future<void> init() async {
    debugPrint('[$_tag][DART] init: START, isSupported=$_isSupported, alreadyInitialized=$_initialized');
    if (!_isSupported) return;
    if (_initialized) return;

    try {
      HomeWidget.registerInteractivityCallback(_onInteraction);
      debugPrint('[$_tag][DART] init: registerInteractivityCallback OK');
    } catch (e) {
      debugPrint('[$_tag][DART] init: registerInteractivityCallback ERROR: $e');
    }

    _initialized = true;
    debugPrint('[$_tag][DART] init: _initialized=true, calling _pushDefaultData');

    await _pushDefaultData();
    _startPeriodicUpdate();
    debugPrint('[$_tag][DART] init: END — periodic update started (5 min interval)');
  }

  static Future<void> _pushDefaultData() async {
    debugPrint('[$_tag][DART] _pushDefaultData: START');
    try {
      final hasData = await HomeWidget.getWidgetData<String>(kKeyFajrTime);
      final needsDefaults = hasData == null || hasData.isEmpty || hasData == '--:--';
      debugPrint('[$_tag][DART] _pushDefaultData: hasData=$hasData, needsDefaults=$needsDefaults');

      if (needsDefaults) {
        debugPrint('[$_tag][DART] _pushDefaultData: Writing default SharedPreferences values...');
        await HomeWidget.saveWidgetData(kKeyNextPrayerName, 'الصلاة');
        await HomeWidget.saveWidgetData(kKeyNextPrayerTime, '--:--');
        await HomeWidget.saveWidgetData(kKeyCountdown, '');
        await HomeWidget.saveWidgetData(kKeyFajrTime, '--:--');
        await HomeWidget.saveWidgetData(kKeyDhuhrTime, '--:--');
        await HomeWidget.saveWidgetData(kKeyAsrTime, '--:--');
        await HomeWidget.saveWidgetData(kKeyMaghribTime, '--:--');
        await HomeWidget.saveWidgetData(kKeyIshaTime, '--:--');
        await HomeWidget.saveWidgetData(kKeySunriseTime, '--:--');
        await HomeWidget.saveWidgetData(kKeyBgColor, 0xFF0A1946);
        await HomeWidget.saveWidgetData(kKeyTextColor, 0xFFF8F8F8);
        await HomeWidget.saveWidgetData(kKeyFontSize, 14);
        await HomeWidget.saveWidgetData(kKeyQuranSurahName, '');
        await HomeWidget.saveWidgetData(kKeyQuranAyah, 1);
        await HomeWidget.saveWidgetData(kKeyQuranPage, 1);
        await HomeWidget.saveWidgetData(kKeyQuranProgress, 0);
        await HomeWidget.saveWidgetData(kKeyTasbihName, 'سبحان الله');
        await HomeWidget.saveWidgetData(kKeyTasbihCount, 0);
        await HomeWidget.saveWidgetData(kKeyTasbihTarget, 33);
        await HomeWidget.saveWidgetData(kKeyHijriDate, '');
        await HomeWidget.saveWidgetData(kKeyGregorianDate, '');
        await HomeWidget.saveWidgetData(kKeyDayOfWeek, '');
        debugPrint('[$_tag][DART] _pushDefaultData: All default values written');
      }

      debugPrint('[$_tag][DART] _pushDefaultData: Calling updateAllWidgets...');
      await updateAllWidgets();
      debugPrint('[$_tag][DART] _pushDefaultData: END');
    } catch (e, st) {
      debugPrint('[$_tag][DART] _pushDefaultData: EXCEPTION: $e');
      debugPrint('[$_tag][DART] _pushDefaultData: STACKTRACE: $st');
    }
  }

  static void _startPeriodicUpdate() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(minutes: 5), (_) {
      debugPrint('[$_tag][DART] _periodicTick: triggered, calling updatePrayerCountdown');
      updatePrayerCountdown();
    });
    debugPrint('[$_tag][DART] _startPeriodicUpdate: timer set (5 min interval)');
  }

  static void dispose() {
    _timer?.cancel();
    _timer = null;
    debugPrint('[$_tag][DART] dispose: timer cancelled');
  }

  // ─── Widget Interaction Callback ───
  static Future<void> _onInteraction(Uri? uri) async {
    debugPrint('[$_tag][DART] _onInteraction: uri=$uri');
    if (uri == null) return;
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

  static int _safeArgb(int fullArgb) => fullArgb | 0xFF000000;

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
    debugPrint('[$_tag][DART] updatePrayerWidget: START next=$nextPrayerName/$nextPrayerTime');
    if (!_isSupported) {
      debugPrint('[$_tag][DART] updatePrayerWidget: SKIP — not supported platform');
      return;
    }

    final nextTime = _parsePrayerTime(nextPrayerTime);
    final countdown = nextTime != null ? _calculateCountdown(nextTime) : '';

    debugPrint('[$_tag][DART] updatePrayerWidget: writing data → saveWidgetData calls...');
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
    if (bgColor != null) await HomeWidget.saveWidgetData(kKeyBgColor, _safeArgb(bgColor));
    if (textColor != null) {
      await HomeWidget.saveWidgetData(kKeyTextColor, _safeArgb(textColor));
    }
    if (fontSize != null) {
      await HomeWidget.saveWidgetData(kKeyFontSize, fontSize.toInt());
    }

    debugPrint('[$_tag][DART] updatePrayerWidget: calling updateAllWidgets...');
    await updateAllWidgets();
    debugPrint('[$_tag][DART] updatePrayerWidget: END');
  }

  static Future<void> updatePrayerCountdown() async {
    debugPrint('[$_tag][DART] updatePrayerCountdown: START');
    if (!_isSupported) return;
    try {
      final fajr = await HomeWidget.getWidgetData<String>(kKeyFajrTime);
      final dhuhr = await HomeWidget.getWidgetData<String>(kKeyDhuhrTime);
      final asr = await HomeWidget.getWidgetData<String>(kKeyAsrTime);
      final maghrib = await HomeWidget.getWidgetData<String>(kKeyMaghribTime);
      final isha = await HomeWidget.getWidgetData<String>(kKeyIshaTime);
      debugPrint('[$_tag][DART] updatePrayerCountdown: read fajr=$fajr, dhuhr=$dhuhr, asr=$asr, maghrib=$maghrib, isha=$isha');

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

      debugPrint('[$_tag][DART] updatePrayerCountdown: next=$nextName/$nextTime, countdown=$countdown');
      await HomeWidget.saveWidgetData(kKeyNextPrayerName, nextName);
      await HomeWidget.saveWidgetData(kKeyNextPrayerTime, nextTime);
      await HomeWidget.saveWidgetData(kKeyCountdown, countdown);

      debugPrint('[$_tag][DART] updatePrayerCountdown: calling updateAllWidgets...');
      await updateAllWidgets();
      debugPrint('[$_tag][DART] updatePrayerCountdown: END');
    } catch (e, st) {
      debugPrint('[$_tag][DART] updatePrayerCountdown: EXCEPTION: $e');
      debugPrint('[$_tag][DART] updatePrayerCountdown: STACKTRACE: $st');
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
    debugPrint('[$_tag][DART] updateQuranWidget: START surah=$surahName, ayah=$ayah, page=$page');
    if (!_isSupported) return;

    final progress = (page / totalPages * 100).round();

    await HomeWidget.saveWidgetData(kKeyQuranSurahName, surahName);
    await HomeWidget.saveWidgetData(kKeyQuranSurahNumber, surahNumber);
    await HomeWidget.saveWidgetData(kKeyQuranAyah, ayah);
    await HomeWidget.saveWidgetData(kKeyQuranPage, page);
    await HomeWidget.saveWidgetData(kKeyQuranTotalPages, totalPages);
    await HomeWidget.saveWidgetData(kKeyQuranProgress, progress);
    await HomeWidget.saveWidgetData(kKeyQuranHasKhatmah, hasKhatmah);
    debugPrint('[$_tag][DART] updateQuranWidget: data written, progress=$progress%');

    await updateAllWidgets();
    debugPrint('[$_tag][DART] updateQuranWidget: END');
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
    debugPrint('[$_tag][DART] updateTasbihWidget: START name=$name, count=$count, target=$target, id=$id');
    if (!_isSupported) return;

    await HomeWidget.saveWidgetData(kKeyTasbihName, name);
    await HomeWidget.saveWidgetData(kKeyTasbihCount, count);
    await HomeWidget.saveWidgetData(kKeyTasbihTarget, target);
    await HomeWidget.saveWidgetData(kKeyTasbihId, id);
    await HomeWidget.saveWidgetData(kKeyTasbihIndex, index);
    await HomeWidget.saveWidgetData(kKeyTasbihTotalItems, totalItems);

    await updateAllWidgets();
    debugPrint('[$_tag][DART] updateTasbihWidget: END');
  }

  // ─── Dashboard / Date ───
  static Future<void> updateDashboardDate({
    required String hijriDate,
    required String gregorianDate,
    required String dayOfWeek,
  }) async {
    debugPrint('[$_tag][DART] updateDashboardDate: START hijri=$hijriDate, greg=$gregorianDate, dow=$dayOfWeek');
    if (!_isSupported) return;

    await HomeWidget.saveWidgetData(kKeyHijriDate, hijriDate);
    await HomeWidget.saveWidgetData(kKeyGregorianDate, gregorianDate);
    await HomeWidget.saveWidgetData(kKeyDayOfWeek, dayOfWeek);

    await updateAllWidgets();
    debugPrint('[$_tag][DART] updateDashboardDate: END');
  }

  // ─── Widget Appearance ───
  static Future<void> updateWidgetAppearance({
    required int bgColor,
    required int textColor,
    required double fontSize,
  }) async {
    debugPrint('[$_tag][DART] updateWidgetAppearance: START bg=0x${bgColor.toRadixString(16)}, text=0x${textColor.toRadixString(16)}, size=$fontSize');
    if (!_isSupported) return;

    await HomeWidget.saveWidgetData(kKeyBgColor, _safeArgb(bgColor));
    await HomeWidget.saveWidgetData(kKeyTextColor, _safeArgb(textColor));
    await HomeWidget.saveWidgetData(kKeyFontSize, fontSize.toInt());

    await updateAllWidgets();
    debugPrint('[$_tag][DART] updateWidgetAppearance: END');
  }

  // ─── Trigger Update for All Widgets ───
  static Future<void> updateAllWidgets() async {
    debugPrint('[$_tag][DART] updateAllWidgets: START, isSupported=$_isSupported');
    if (!_isSupported) return;
    try {
      const providers = [
        'PrayerTimesWidgetProvider',
        'QuranWidgetProvider',
        'TasbihWidgetProvider',
        'DashboardWidgetProvider',
      ];
      for (final provider in providers) {
        debugPrint('[$_tag][DART] updateAllWidgets: calling HomeWidget.updateWidget(androidName=$provider)...');
        try {
          await HomeWidget.updateWidget(androidName: provider);
          debugPrint('[$_tag][DART] updateAllWidgets: $provider → OK');
        } catch (e) {
          debugPrint('[$_tag][DART] updateAllWidgets: $provider → ERROR: $e');
        }
      }
      debugPrint('[$_tag][DART] updateAllWidgets: END — all 4 providers called');
    } catch (e, st) {
      debugPrint('[$_tag][DART] updateAllWidgets: EXCEPTION: $e');
      debugPrint('[$_tag][DART] updateAllWidgets: STACKTRACE: $st');
    }
  }
}

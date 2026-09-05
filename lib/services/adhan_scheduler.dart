import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import '../models/prayer_times.dart';
import 'storage_service.dart';
import 'time_formatter.dart';

/// AdhanScheduler — Authoritative Flutter ↔ Android bridge for prayer alarms.
///
/// Features:
///   • 48-Hour Rolling Window: Schedules remaining prayers for today AND full prayers for tomorrow.
///   • Real Verification: Queries native PendingIntent existence via FLAG_NO_CREATE.
///   • Exact Alarm Permission: Handles Android 12+ canScheduleExactAlarms() and settings intent.
///   • Diagnostics & OEM Integration: Surfaces battery optimization and health reports.
class AdhanScheduler {
  static const _channel = MethodChannel('com.dailyislamicwidget/adhan');

  AdhanScheduler._();
  static final AdhanScheduler instance = AdhanScheduler._();

  /// Schedules a 48-hour rolling window of prayer alarms in Android AlarmManager.
  ///
  /// Combines today's remaining prayers and tomorrow's prayers with deterministic IDs.
  Future<Map<String, dynamic>> schedulePrayers(
    PrayerTimes todayTimes, {
    PrayerTimes? tomorrowTimes,
  }) async {
    if (kIsWeb) {
      return {'success': true, 'scheduled': 0, 'verified': 0};
    }

    final settings = StorageService.getSettings();
    if (!settings.adhanEnabled) {
      debugPrint('[AdhanScheduler] Adhan disabled globally, skipping schedule');
      await cancelAll();
      return {'success': true, 'scheduled': 0, 'verified': 0};
    }

    final enabledMap = {
      'Fajr': settings.adhanFajrEnabled,
      'Dhuhr': settings.adhanDhuhrEnabled,
      'Maghrib': settings.adhanMaghribEnabled,
    };

    final prayers = <Map<String, dynamic>>[];
    final now = DateTime.now();

    // 1. Add Today's Prayers (if upcoming or within 15 min buffer)
    for (final name in ['Fajr', 'Dhuhr', 'Maghrib']) {
      final time = todayTimes.timings[name];
      if (time == null || enabledMap[name] != true) continue;

      // Keep if in future or within 15 min grace period
      if (time.isAfter(now.subtract(const Duration(minutes: 15)))) {
        prayers.add({
          'name': name,
          'timestampMillis': time.millisecondsSinceEpoch,
          'time': TimeFormatter.formatTime(time),
          'volume': settings.adhanVolume,
          'day': 'today',
        });
      }
    }

    // 2. Add Tomorrow's Prayers (Rolling 48-hour safety window)
    for (final name in ['Fajr', 'Dhuhr', 'Maghrib']) {
      if (enabledMap[name] != true) continue;

      DateTime? tomorrowTime;
      if (tomorrowTimes != null && tomorrowTimes.timings.containsKey(name)) {
        tomorrowTime = tomorrowTimes.timings[name];
      } else if (todayTimes.timings.containsKey(name)) {
        // Synthesize tomorrow's time by advancing 24 hours
        tomorrowTime = todayTimes.timings[name]!.add(const Duration(days: 1));
      }

      if (tomorrowTime != null) {
        prayers.add({
          'name': name,
          'timestampMillis': tomorrowTime.millisecondsSinceEpoch,
          'time': TimeFormatter.formatTime(tomorrowTime),
          'volume': settings.adhanVolume,
          'day': 'tomorrow',
        });
      }
    }

    if (prayers.isEmpty) {
      debugPrint('[AdhanScheduler] No prayers to schedule');
      return {'success': true, 'scheduled': 0, 'verified': 0};
    }

    final jsonPayload = <String, dynamic>{
      'enabled': enabledMap,
      'volume': settings.adhanVolume,
      'selectedSound': settings.adhanSound,
      'city': todayTimes.city,
      'latitude': todayTimes.latitude,
      'longitude': todayTimes.longitude,
      'timezone': todayTimes.timezone,
      'prayers': prayers,
    };

    try {
      final rawResult = await _channel.invokeMethod<dynamic>('schedulePrayers', {
        'prayers': prayers,
        'enabled': enabledMap,
        'volume': settings.adhanVolume,
        'selectedSound': settings.adhanSound,
        'adhanEnabled': settings.adhanEnabled,
        'adhanFajrEnabled': settings.adhanFajrEnabled,
        'adhanDhuhrEnabled': settings.adhanDhuhrEnabled,
        'adhanMaghribEnabled': settings.adhanMaghribEnabled,
        'bootStart': settings.adhanBootStart,
        'prayerTimesJson': jsonEncode(jsonPayload),
      });

      final result = rawResult is Map ? Map<String, dynamic>.from(rawResult) : <String, dynamic>{};
      debugPrint('[AdhanScheduler] Alarms scheduled: ${result['scheduled']} (verified: ${result['verified']})');
      return result;
    } catch (e, st) {
      debugPrint('[AdhanScheduler] Failed to schedule prayers: $e\n$st');
      return {'success': false, 'error': e.toString()};
    }
  }

  /// Cancels all scheduled prayer alarms and releases resources.
  Future<void> cancelAll() async {
    if (kIsWeb) return;
    try {
      await _channel.invokeMethod('cancelAll');
      debugPrint('[AdhanScheduler] All alarms cancelled');
    } catch (e, st) {
      debugPrint('[AdhanScheduler] Failed to cancel alarms: $e\n$st');
    }
  }

  /// Verifies whether registered PendingIntents actually exist in AlarmManager.
  Future<Map<String, dynamic>> verifyScheduledAlarms() async {
    if (kIsWeb) return {'isHealthy': true, 'verifiedCount': 0};
    try {
      final result = await _channel.invokeMethod<dynamic>('verifyAlarms');
      if (result is Map) {
        return Map<String, dynamic>.from(result);
      }
      return {'isHealthy': false, 'verifiedCount': 0};
    } catch (e) {
      debugPrint('[AdhanScheduler] verifyAlarms failed: $e');
      return {'isHealthy': false, 'verifiedCount': 0};
    }
  }

  /// Checks whether exact alarm permission is granted on Android 12+ (API 31+).
  Future<bool> canScheduleExactAlarms() async {
    if (kIsWeb) return true;
    try {
      final result = await _channel.invokeMethod<bool>('canScheduleExactAlarms');
      return result ?? true;
    } catch (_) {
      return true;
    }
  }

  /// Opens the system Settings screen for SCHEDULE_EXACT_ALARM.
  Future<bool> requestExactAlarmPermission() async {
    if (kIsWeb) return false;
    try {
      final result = await _channel.invokeMethod<bool>('requestExactAlarmPermission');
      return result ?? false;
    } catch (e) {
      debugPrint('[AdhanScheduler] requestExactAlarmPermission failed: $e');
      return false;
    }
  }

  /// Checks whether battery optimization is ignored for Rafeeq.
  Future<bool> checkBatteryOptimization() async {
    if (kIsWeb) return true;
    try {
      final result = await _channel.invokeMethod<bool>('checkBatteryOptimization');
      return result ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Requests battery optimization exemption.
  Future<bool> requestBatteryOptimization() async {
    if (kIsWeb) return false;
    try {
      final result = await _channel.invokeMethod<bool>('requestBatteryOptimization');
      return result ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Gets the next alarm timestamp in milliseconds from AlarmManager.
  Future<int> getNextAlarm() async {
    if (kIsWeb) return -1;
    try {
      final result = await _channel.invokeMethod<int>('getNextAlarm');
      return result ?? -1;
    } catch (_) {
      return -1;
    }
  }

  /// Returns the device manufacturer string (lowercase), or empty on failure.
  Future<String> getManufacturer() async {
    if (kIsWeb) return '';
    try {
      final result = await _channel.invokeMethod<String>('getManufacturer');
      return result ?? '';
    } catch (_) {
      return '';
    }
  }

  /// Fetches the full native diagnostics health report.
  Future<Map<String, dynamic>> getAdhanHealthReport() async {
    if (kIsWeb) return {};
    try {
      final result = await _channel.invokeMethod<dynamic>('getAdhanHealthReport');
      if (result is Map) {
        return Map<String, dynamic>.from(result);
      }
      return {};
    } catch (e) {
      debugPrint('[AdhanScheduler] getAdhanHealthReport failed: $e');
      return {};
    }
  }

  /// Fetches device and OEM specific background diagnostics.
  Future<Map<String, dynamic>> getDeviceDiagnostics() async {
    if (kIsWeb) return {};
    try {
      final result = await _channel.invokeMethod<dynamic>('getDeviceDiagnostics');
      if (result is Map) {
        return Map<String, dynamic>.from(result);
      }
      return {};
    } catch (_) {
      return {};
    }
  }

  /// Opens OEM specific auto-start / battery management screen.
  Future<Map<String, dynamic>> openOemBatterySettings() async {
    if (kIsWeb) return {};
    try {
      final result = await _channel.invokeMethod<dynamic>('openOemBatterySettings');
      if (result is Map) {
        return Map<String, dynamic>.from(result);
      }
      return {};
    } catch (_) {
      return {};
    }
  }

  /// Opens standard Android battery optimization settings.
  Future<bool> openBatterySettings() async {
    if (kIsWeb) return false;
    try {
      final result = await _channel.invokeMethod<bool>('openBatterySettings');
      return result ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Plays a test adhan immediately.
  Future<void> playTestAdhan() async {
    if (kIsWeb) return;
    final settings = StorageService.getSettings();
    try {
      await _channel.invokeMethod('playTestAdhan', {
        'volume': settings.adhanVolume,
        'sound_name': settings.adhanSound,
      });
    } catch (e, st) {
      debugPrint('[AdhanScheduler] Failed to play test adhan: $e\n$st');
    }
  }

  /// Stops any currently playing adhan.
  Future<void> stopAdhan() async {
    if (kIsWeb) return;
    try {
      await _channel.invokeMethod('stopAdhan');
    } catch (e, st) {
      debugPrint('[AdhanScheduler] Failed to stop adhan: $e\n$st');
    }
  }

  /// Schedules a test alarm to trigger in [delaySeconds].
  Future<void> scheduleTestAlarm(int delaySeconds) async {
    if (kIsWeb) return;
    try {
      await _channel.invokeMethod('scheduleTestAlarm', {
        'delaySeconds': delaySeconds,
      });
      debugPrint('[AdhanScheduler] Test alarm scheduled in ${delaySeconds}s');
    } catch (e, st) {
      debugPrint('[AdhanScheduler] Failed to schedule test alarm: $e\n$st');
    }
  }

  /// Syncs updated settings to native SharedPreferences.
  Future<void> updateSettings() async {
    if (kIsWeb) return;
    final settings = StorageService.getSettings();
    try {
      await _channel.invokeMethod('updateSettings', {
        'adhanEnabled': settings.adhanEnabled,
        'volume': settings.adhanVolume,
        'selectedSound': settings.adhanSound,
        'adhanFajrEnabled': settings.adhanFajrEnabled,
        'adhanDhuhrEnabled': settings.adhanDhuhrEnabled,
        'adhanMaghribEnabled': settings.adhanMaghribEnabled,
        'bootStart': settings.adhanBootStart,
      });
    } catch (e, st) {
      debugPrint('[AdhanScheduler] Failed to update settings: $e\n$st');
    }
  }
}

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import '../models/prayer_times.dart';
import 'storage_service.dart';
import 'time_formatter.dart';

/// AdhanScheduler — bridges Flutter to native Android AlarmManager via MethodChannel.
///
/// This is the ONLY Dart → native bridge for adhan scheduling and playback.
/// All adhan audio is played by the native AdhanForegroundService via MediaPlayer.
class AdhanScheduler {
  static const _channel = MethodChannel('com.dailyislamicwidget/adhan');

  AdhanScheduler._();
  static final AdhanScheduler instance = AdhanScheduler._();

  Future<void> schedulePrayers(PrayerTimes prayerTimes) async {
    if (kIsWeb) return;
    final settings = StorageService.getSettings();

    if (!settings.adhanEnabled) {
      debugPrint('[AdhanScheduler] Adhan disabled globally, skipping');
      return;
    }

    final enabledMap = {
      'Fajr': settings.adhanFajrEnabled,
      'Dhuhr': settings.adhanDhuhrEnabled,
      'Maghrib': settings.adhanMaghribEnabled,
    };

    final prayers = <Map<String, dynamic>>[];
    for (final name in ['Fajr', 'Dhuhr', 'Maghrib']) {
      final time = prayerTimes.timings[name];
      if (time == null) {
        debugPrint('[AdhanScheduler] No timing for $name, skipping');
        continue;
      }
      if (enabledMap[name] != true) continue;

      prayers.add({
        'name': name,
        'timestampMillis': time.millisecondsSinceEpoch,
        'volume': settings.adhanVolume,
      });
    }

    if (prayers.isEmpty) {
      debugPrint('[AdhanScheduler] No enabled prayers to schedule');
      return;
    }

    final jsonPayload = <String, dynamic>{
      'enabled': {
        'Fajr': settings.adhanFajrEnabled,
        'Dhuhr': settings.adhanDhuhrEnabled,
        'Maghrib': settings.adhanMaghribEnabled,
      },
      'volume': settings.adhanVolume,
      'selectedSound': settings.adhanSound,
      'prayers': prayerTimes.timings.entries
          .where((e) => ['Fajr', 'Dhuhr', 'Maghrib'].contains(e.key))
          .map((e) => {
                'name': e.key,
                'timestampMillis': e.value.millisecondsSinceEpoch,
                'time': TimeFormatter.formatTime(e.value),
              })
          .toList(),
    };

    try {
      await _channel.invokeMethod('schedulePrayers', {
        'prayers': prayers,
        'enabled': enabledMap,
        'volume': settings.adhanVolume,
        'selectedSound': settings.adhanSound,
        'adhanEnabled': settings.adhanEnabled,
        'adhanFajrEnabled': settings.adhanFajrEnabled,
        'adhanDhuhrEnabled': settings.adhanDhuhrEnabled,
        'adhanMaghribEnabled': settings.adhanMaghribEnabled,
        'snoozeMinutes': settings.adhanSnoozeMinutes,
        'bootStart': settings.adhanBootStart,
        'prayerTimesJson': jsonEncode(jsonPayload),
      });
      debugPrint('[AdhanScheduler] Alarms scheduled for ${prayers.map((p) => p['name']).join(', ')}');
    } catch (e, st) {
      debugPrint('[AdhanScheduler] Failed to schedule prayers: $e\n$st');
    }
  }

  Future<void> cancelAll() async {
    if (kIsWeb) return;
    try {
      await _channel.invokeMethod('cancelAll');
      debugPrint('[AdhanScheduler] All alarms cancelled');
    } catch (e, st) {
      debugPrint('[AdhanScheduler] Failed to cancel alarms: $e\n$st');
    }
  }

  Future<void> playTestAdhan() async {
    if (kIsWeb) return;
    final settings = StorageService.getSettings();
    try {
      await _channel.invokeMethod('playTestAdhan', {
        'volume': settings.adhanVolume,
        'sound_name': settings.adhanSound,
      });
      debugPrint('[AdhanScheduler] Test adhan requested');
    } catch (e, st) {
      debugPrint('[AdhanScheduler] Failed to play test adhan: $e\n$st');
    }
  }

  Future<void> stopAdhan() async {
    if (kIsWeb) return;
    try {
      await _channel.invokeMethod('stopAdhan');
      debugPrint('[AdhanScheduler] Stop adhan requested');
    } catch (e, st) {
      debugPrint('[AdhanScheduler] Failed to stop adhan: $e\n$st');
    }
  }

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
        'snoozeMinutes': settings.adhanSnoozeMinutes,
        'bootStart': settings.adhanBootStart,
      });
    } catch (e, st) {
      debugPrint('[AdhanScheduler] Failed to update settings: $e\n$st');
    }
  }

  Future<void> requestExactAlarmPermission() async {
    if (kIsWeb) return;
    try {
      await _channel.invokeMethod('requestExactAlarmPermission');
    } catch (e, st) {
      debugPrint('[AdhanScheduler] Failed to request exact alarm permission: $e\n$st');
    }
  }
}

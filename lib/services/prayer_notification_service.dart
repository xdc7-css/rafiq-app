import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../core/constants.dart';
import '../models/prayer_times.dart';
import 'storage_service.dart';
import 'notification_helper.dart';

/// Manages prayer-time banner notifications.
///
/// Shi'a schedule: only Fajr, Dhuhr, and Maghrib get notifications.
///
/// Adhan audio playback is handled exclusively by the native
/// AlarmManager → AdhanAlarmReceiver → AdhanForegroundService path.
/// This service only shows silent prayer-time banners.
///
/// Notification ID range:
///   1005, 1007, 1009  → banner-only prayer notifications (Fajr, Dhuhr, Maghrib)
class PrayerNotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const Map<String, int> _bannerNotificationIds = {
    'Fajr': AppConstants.prayerFajrNotificationId,
    'Dhuhr': AppConstants.prayerDhuhrNotificationId,
    'Maghrib': AppConstants.prayerMaghribNotificationId,
  };

  static const Map<String, String> _arabicNames = {
    'Fajr': 'الفجر',
    'Dhuhr': 'الظهر',
    'Maghrib': 'المغرب',
  };

  static Future<void> scheduleForToday(PrayerTimes prayerTimes) async {
    if (kIsWeb) return;
    final settings = StorageService.getSettings();

    await cancelAll();

    if (settings.prayerNotifications) {
      await _scheduleBannerNotifications(prayerTimes);
    }
  }

  static Future<void> cancelAll() async {
    if (kIsWeb) return;
    for (final id in _bannerNotificationIds.values) {
      await _plugin.cancel(id);
    }
  }

  static Future<void> _scheduleBannerNotifications(
    PrayerTimes prayerTimes,
  ) async {
    if (kIsWeb) return;
    final now = tz.TZDateTime.now(tz.local);

    for (final entry in _bannerNotificationIds.entries) {
      final name = entry.key;
      final id = entry.value;
      final time = prayerTimes.timings[name];
      if (time == null) continue;

      final scheduledDate = tz.TZDateTime(
        tz.local,
        time.year,
        time.month,
        time.day,
        time.hour,
        time.minute,
      );
      if (scheduledDate.isBefore(now)) continue;

      final arabic = _arabicNames[name] ?? name;

      await _plugin.zonedSchedule(
        id,
        '🕌 وقت صلاة $arabic',
        'حان الآن موعد صلاة $arabic',
        scheduledDate,
        NotificationHelper.getPrayerNotificationDetails(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }
}

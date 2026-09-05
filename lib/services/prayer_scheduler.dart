import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:timezone/timezone.dart' as tz;
import '../models/prayer_times.dart';
import 'adhan_scheduler.dart';
import 'prayer_notification_service.dart';
import 'storage_service.dart';

/// PrayerScheduler — Coordinates automatic daily rescheduling and 48-hour alarm arming.
///
/// Strategy:
///   • Schedules today's remaining prayers AND tomorrow's full prayers (48h rolling window)
///     directly in the OS AlarmManager.
///   • OS AlarmManager owns the wakeup schedule completely — zero reliance on keeping Dart isolates alive.
///   • Reschedules immediately upon location change, settings change, or app resume.
class PrayerScheduler {
  PrayerScheduler._();
  static final PrayerScheduler instance = PrayerScheduler._();

  Timer? _midnightTimer;
  PrayerTimes? _lastScheduledTimes;
  int _lastScheduledDay = -1;

  /// Schedule notifications and exact alarms for [prayerTimes].
  Future<void> scheduleForToday(PrayerTimes prayerTimes, {bool force = false}) async {
    final now = DateTime.now();
    final todayKey = now.day + now.month * 100 + now.year * 10000;

    // Skip if already scheduled for today with the same coordinates unless forced
    if (!force &&
        _lastScheduledDay == todayKey &&
        _lastScheduledTimes != null &&
        _isSameLocation(_lastScheduledTimes!, prayerTimes)) {
      debugPrint('[PrayerScheduler] Already scheduled for today (day=$todayKey), skipping');
      return;
    }

    debugPrint('[PrayerScheduler] Scheduling 48-hour rolling window for day=$todayKey (force=$force)');

    await PrayerNotificationService.scheduleForToday(prayerTimes);

    // Route adhan alarms through native Android AlarmManager with 48h rolling window
    final result = await AdhanScheduler.instance.schedulePrayers(prayerTimes);
    debugPrint('[PrayerScheduler] Adhan scheduling result: $result');

    _lastScheduledDay = todayKey;
    _lastScheduledTimes = prayerTimes;

    // Persist the last scheduled day for boot-receiver recovery
    await StorageService.saveLastScheduledDay(todayKey);

    // Arm midnight maintenance
    _armMidnightTimer(prayerTimes);
  }

  /// Call this whenever the user changes city or GPS location.
  Future<void> onLocationChanged(PrayerTimes newPrayerTimes) async {
    debugPrint('[PrayerScheduler] Location changed, forcing reschedule');
    _lastScheduledDay = -1;
    _midnightTimer?.cancel();
    _midnightTimer = null;
    await scheduleForToday(newPrayerTimes, force: true);
  }

  /// Call this whenever adhan audio, volume, or enabled states change.
  Future<void> onSettingsChanged(PrayerTimes prayerTimes) async {
    debugPrint('[PrayerScheduler] Settings changed, forcing reschedule');
    await AdhanScheduler.instance.updateSettings();
    await scheduleForToday(prayerTimes, force: true);
  }

  /// Cancel all scheduled notifications and alarms.
  Future<void> cancelAll() async {
    debugPrint('[PrayerScheduler] Cancelling all scheduled alarms');
    _midnightTimer?.cancel();
    _midnightTimer = null;
    _lastScheduledDay = -1;
    _lastScheduledTimes = null;
    await PrayerNotificationService.cancelAll();
    await AdhanScheduler.instance.cancelAll();
  }

  void dispose() {
    _midnightTimer?.cancel();
    _midnightTimer = null;
  }

  // ── Internal helpers ──────────────────────────────────────────────────────

  void _armMidnightTimer(PrayerTimes prayerTimes) {
    _midnightTimer?.cancel();

    final now = tz.TZDateTime.now(tz.local);
    final midnight = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day + 1, // tomorrow midnight
    );
    final delay = midnight.difference(now);

    debugPrint('[PrayerScheduler] In-app midnight timer armed (${delay.inMinutes} min)');

    _midnightTimer = Timer(delay, () {
      debugPrint('[PrayerScheduler] Midnight reached, refreshing active notifications');
      PrayerNotificationService.cancelAll();
    });
  }

  bool _isSameLocation(PrayerTimes a, PrayerTimes b) {
    final latSame = (a.latitude - b.latitude).abs() < 0.001;
    final lngSame = (a.longitude - b.longitude).abs() < 0.001;
    return latSame && lngSame;
  }
}

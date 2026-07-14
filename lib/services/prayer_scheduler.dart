import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:timezone/timezone.dart' as tz;
import '../models/prayer_times.dart';
import 'adhan_scheduler.dart';
import 'prayer_notification_service.dart';
import 'storage_service.dart';

/// PrayerScheduler — coordinates automatic daily rescheduling.
///
/// Strategy (battery-friendly):
///   • Does NOT run a continuous background service or timer.
///   • Reschedules once per day at startup and whenever location changes.
///   • A single midnight Timer fires inside the app to trigger the next
///     day's schedule; if the app is closed, the OS boots the app at the
///     first notification alarm (via BOOT_COMPLETED receiver), then
///     scheduleForToday() is called again from main().
///
/// Usage:
///   1. Call [PrayerScheduler.scheduleForToday] whenever prayer times are loaded.
///   2. Call [PrayerScheduler.onLocationChanged] after city/GPS changes.
///   3. Call [PrayerScheduler.dispose] on app shutdown.
class PrayerScheduler {
  PrayerScheduler._();
  static final PrayerScheduler instance = PrayerScheduler._();

  Timer? _midnightTimer;
  PrayerTimes? _lastScheduledTimes;
  int _lastScheduledDay = -1;

  /// Schedule notifications for [prayerTimes].
  ///
  /// No-op if already scheduled for the same day and same location,
  /// preventing duplicate reschedules.
  Future<void> scheduleForToday(PrayerTimes prayerTimes, {bool force = false}) async {
    final now = DateTime.now();
    final todayKey = now.day + now.month * 100 + now.year * 10000;

    // Skip if already scheduled for today with the same coordinates.
    if (!force &&
        _lastScheduledDay == todayKey &&
        _lastScheduledTimes != null &&
        _isSameLocation(_lastScheduledTimes!, prayerTimes)) {
      debugPrint('[PrayerScheduler] Already scheduled for today (day=$todayKey), skipping');
      return;
    }

    debugPrint('[PrayerScheduler] Scheduling for day=$todayKey (force=$force)');

    await PrayerNotificationService.scheduleForToday(prayerTimes);

    // Route adhan alarms through native Android AlarmManager/ForegroundService
    // so they play even when the Flutter engine is not running.
    await AdhanScheduler.instance.schedulePrayers(prayerTimes);

    _lastScheduledDay = todayKey;
    _lastScheduledTimes = prayerTimes;

    // Persist the last scheduled day for boot-receiver recovery.
    await StorageService.saveLastScheduledDay(todayKey);

    // Arm a midnight timer to auto-reschedule for tomorrow.
    _armMidnightTimer(prayerTimes);
  }

  /// Call this whenever the user changes city or GPS location.
  ///
  /// Cancels all existing notifications and reschedules with new times.
  Future<void> onLocationChanged(PrayerTimes newPrayerTimes) async {
    debugPrint('[PrayerScheduler] Location changed, forcing reschedule');
    _lastScheduledDay = -1; // Force reschedule even on same day.
    _midnightTimer?.cancel();
    _midnightTimer = null;
    await scheduleForToday(newPrayerTimes);
  }

  /// Cancel all scheduled notifications.
  Future<void> cancelAll() async {
    debugPrint('[PrayerScheduler] Cancelling all');
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

    debugPrint('[PrayerScheduler] Midnight timer armed (${delay.inMinutes} min)');

    _midnightTimer = Timer(delay, () {
      debugPrint('[PrayerScheduler] Midnight crossed, cancelling stale notifications');
      // Tomorrow has begun — cancel stale banner notifications.
      // Adhan alarms were already set by AlarmManager and will fire at the
      // correct times. New alarms for tomorrow will be set when the user
      // opens the app (PrayerTimesNotifier._checkDayChange detects this).
      PrayerNotificationService.cancelAll();
    });
  }

  bool _isSameLocation(PrayerTimes a, PrayerTimes b) {
    // Compare lat/lng rounded to 3 decimal places (~111m precision).
    final latSame =
        (a.latitude - b.latitude).abs() < 0.001;
    final lngSame =
        (a.longitude - b.longitude).abs() < 0.001;
    return latSame && lngSame;
  }
}

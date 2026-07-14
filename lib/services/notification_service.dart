import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../core/constants.dart';
import '../models/models.dart';
import '../models/prayer_times.dart';
import 'storage_service.dart';

typedef NotificationTapCallback = void Function(String? payload);

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;
  static NotificationTapCallback? _onTapCallback;
  static bool _initializing = false;

  static Future<void> init({NotificationTapCallback? onTap}) async {
    // Notifications are not supported on Web — skip entirely.
    if (kIsWeb) return;
    if (_initialized) return;
    if (_initializing) return;
    _initializing = true;

    _onTapCallback = onTap;

    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );

    await _createNotificationChannels();
    _initialized = true;
    _initializing = false;
  }

  static void _onNotificationResponse(NotificationResponse response) {
    final payload = response.payload;
    _onTapCallback?.call(payload);
  }

  static Future<void> _createNotificationChannels() async {
    // This method is only called from init(), which already guards against Web.
    const verseChannel = AndroidNotificationChannel(
      AppConstants.verseChannelId,
      AppConstants.verseChannelName,
      description: 'إشعارات آية القرآن اليومية',
      importance: Importance.high,
    );

    const hadithChannel = AndroidNotificationChannel(
      AppConstants.hadithChannelId,
      AppConstants.hadithChannelName,
      description: 'إشعارات الحديث اليومي',
      importance: Importance.high,
    );

    const adhkarChannel = AndroidNotificationChannel(
      AppConstants.adhkarChannelId,
      AppConstants.adhkarChannelName,
      description: 'تذكير الأذكار',
      importance: Importance.high,
    );

    const prayerChannel = AndroidNotificationChannel(
      AppConstants.prayerChannelId,
      AppConstants.prayerChannelName,
      description: 'إشعارات أوقات الصلاة',
      importance: Importance.high,
    );

    // Adhan channel with MAX importance for full-screen intent support
    final adhanChannel = AndroidNotificationChannel(
      AppConstants.adhanChannelId,
      AppConstants.adhanChannelName,
      description: 'أذان الصلاة عند دخول وقت الفجر والظهر والمغرب',
      importance: Importance.max,
      playSound: true,
      sound: const RawResourceAndroidNotificationSound('adhan'),
      enableVibration: true,
      vibrationPattern: Int64List.fromList([
        0,
        500,
        200,
        500,
      ]), // Android-only, safe here
    );

    // Foreground service channel (low importance, ongoing)
    const foregroundServiceChannel = AndroidNotificationChannel(
      'adhan_foreground_service',
      'خدمة الأذان في المقدمة',
      description: 'إشعار خدمة الأذان المستمرة',
      importance: Importance.low,
      enableVibration: false,
      showBadge: false,
    );

    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (androidPlugin != null) {
      // Create all channels in parallel instead of sequentially
      await Future.wait([
        androidPlugin.createNotificationChannel(verseChannel),
        androidPlugin.createNotificationChannel(hadithChannel),
        androidPlugin.createNotificationChannel(adhkarChannel),
        androidPlugin.createNotificationChannel(prayerChannel),
        androidPlugin.createNotificationChannel(adhanChannel),
        androidPlugin.createNotificationChannel(foregroundServiceChannel),
      ]);
    }
  }

  static bool get isInitialized => _initialized;

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    if (kIsWeb || !_initialized) return;
    final androidDetails = AndroidNotificationDetails(
      AppConstants.verseChannelId,
      AppConstants.verseChannelName,
      channelDescription: 'إشعارات التطبيق',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    final iosDetails = DarwinNotificationDetails();

    await _plugin.show(
      id,
      title,
      body,
      NotificationDetails(android: androidDetails, iOS: iosDetails),
      payload: payload,
    );
  }

  static Future<void> scheduleDailyVerseNotification(VerseModel verse) async {
    if (kIsWeb || !_initialized) return;
    final settings = StorageService.getSettings();
    if (!settings.dailyVerseNotification) return;

    await _plugin.zonedSchedule(
      AppConstants.dailyVerseNotificationId,
      'آية القرآن اليومية',
      verse.textArabic,
      _nextScheduledTime(hour: 7),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          AppConstants.verseChannelId,
          AppConstants.verseChannelName,
          channelDescription: 'إشعارات آية القرآن اليومية',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> scheduleDailyHadithNotification(
    HadithModel hadith,
  ) async {
    if (kIsWeb || !_initialized) return;
    final settings = StorageService.getSettings();
    if (!settings.dailyHadithNotification) return;

    await _plugin.zonedSchedule(
      AppConstants.dailyHadithNotificationId,
      'حديث اليوم',
      hadith.textArabic,
      _nextScheduledTime(hour: 8),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          AppConstants.hadithChannelId,
          AppConstants.hadithChannelName,
          channelDescription: 'إشعارات الحديث اليومي',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> scheduleMorningAdhkarReminder() async {
    // Deprecated — adhkar-specific scheduling removed in Shia redesign.
  }

  static Future<void> scheduleEveningAdhkarReminder() async {
    // Deprecated — adhkar-specific scheduling removed in Shia redesign.
  }

  static Future<void> schedulePrayerTimeNotifications({
    required PrayerTimes prayerTimes,
    required bool enabled,
  }) async {
    if (kIsWeb || !_initialized) return;
    await _cancelPrayerNotifications();

    if (!enabled) return;

    final arabicNames = {
      'Fajr': 'الفجر',
      'Sunrise': 'الشروق',
      'Dhuhr': 'الظهر',
      'Asr': 'العصر',
      'Maghrib': 'المغرب',
      'Isha': 'العشاء',
    };

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    int notificationId = AppConstants.prayerFajrNotificationId;

    for (final entry in prayerTimes.timings.entries) {
      final name = entry.key;
      if (!arabicNames.containsKey(name)) continue;

      final prayerTime = entry.value;
      if (prayerTime.isBefore(today)) continue;

      final arabicName = arabicNames[name]!;
      final scheduledDate = tz.TZDateTime(
        tz.local,
        prayerTime.year,
        prayerTime.month,
        prayerTime.day,
        prayerTime.hour,
        prayerTime.minute,
      );

      if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) continue;

      await _plugin.zonedSchedule(
        notificationId,
        'حان وقت صلاة $arabicName',
        'الله أكبر، حان وقت صلاة $arabicName',
        scheduledDate,
        NotificationDetails(
          android: AndroidNotificationDetails(
            AppConstants.prayerChannelId,
            AppConstants.prayerChannelName,
            channelDescription: 'إشعارات أوقات الصلاة',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: const DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );

      notificationId++;
    }
  }

  static Future<void> _cancelPrayerNotifications() async {
    if (kIsWeb || !_initialized) return;
    for (
      int id = AppConstants.prayerFajrNotificationId;
      id <= AppConstants.prayerIshaNotificationId;
      id++
    ) {
      await _plugin.cancel(id);
    }
  }

  static Future<void> cancelAllNotifications() async {
    if (kIsWeb || !_initialized) return;
    await _plugin.cancelAll();
  }

  static Future<void> cancelNotification(int id) async {
    if (kIsWeb || !_initialized) return;
    await _plugin.cancel(id);
  }

  static tz.TZDateTime _nextScheduledTime({required int hour}) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}

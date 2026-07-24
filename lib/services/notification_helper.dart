import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../core/constants.dart';

/// Helper to configure platform-specific notification configurations.
class NotificationHelper {
  /// Build Android notification details for standard prayer notifications.
  static AndroidNotificationDetails getPrayerAndroidDetails() {
    return const AndroidNotificationDetails(
      AppConstants.prayerChannelId,
      AppConstants.prayerChannelName,
      channelDescription: 'إشعارات أوقات الصلاة',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      styleInformation: BigTextStyleInformation(''),
    );
  }

  /// Build Android notification details for Adhan notifications (uses custom sound).
  static AndroidNotificationDetails getAdhanAndroidDetails() {
    // Int64List is Android-only and must not be constructed on Web.
    // This method is only called from non-Web paths (guarded by kIsWeb checks
    // in NotificationService and PrayerNotificationService).
    final vibrationPattern = kIsWeb
        ? null
        : Int64List.fromList([0, 500, 200, 500]);
    return AndroidNotificationDetails(
      AppConstants.adhanChannelId,
      AppConstants.adhanChannelName,
      channelDescription: 'أذان الصلاة عند دخول وقت الفجر والظهر والمغرب',
      importance: Importance.max,
      priority: Priority.max,
      icon: '@mipmap/ic_launcher',
      playSound: true,
      sound: const RawResourceAndroidNotificationSound('adhan'),
      enableVibration: vibrationPattern != null,
      vibrationPattern: vibrationPattern,
      styleInformation: const BigTextStyleInformation(''),
      category: AndroidNotificationCategory.alarm,
      fullScreenIntent: true,
      visibility: NotificationVisibility.public,
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          'open_app',
          'فتح التطبيق',
          showsUserInterface: true,
          cancelNotification: true,
        ),
        AndroidNotificationAction(
          'stop_adhan',
          'إيقاف الأذان',
          showsUserInterface: false,
          cancelNotification: true,
        ),
      ],
    );
  }

  /// Build iOS notification details for standard prayer notifications.
  static DarwinNotificationDetails getPrayerIOSDetails() {
    return const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
  }

  /// Build iOS notification details for Adhan notifications (uses custom sound).
  static DarwinNotificationDetails getAdhanIOSDetails() {
    return const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'adhan.mp3',
      categoryIdentifier: 'adhan_category',
    );
  }

  /// Build full NotificationDetails for standard prayer notifications.
  static NotificationDetails getPrayerNotificationDetails() {
    return NotificationDetails(
      android: getPrayerAndroidDetails(),
      iOS: getPrayerIOSDetails(),
    );
  }

  /// Build full NotificationDetails for Adhan notifications.
  static NotificationDetails getAdhanNotificationDetails() {
    return NotificationDetails(
      android: getAdhanAndroidDetails(),
      iOS: getAdhanIOSDetails(),
    );
  }
}

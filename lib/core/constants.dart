class AppConstants {
  // Brand
  static const String appName = 'رَفِيقْ';
  static const String appNameArabic = 'رَفِيقْ';
  static const String appVersion = '1.0.0';

  // Premium Brand Colors
  static const int midnightNavy = 0xFF050B24;
  static const int royalBlue = 0xFF0B2C6B;
  static const int luxuryGold = 0xFFD8B56A;
  static const int warmWhite = 0xFFF8F8F8;
  static const int darkGlassBlue = 0xFF0A1946;
  static const int emeraldGreen = 0xFF2ECC71;

  // Hive Boxes
  static const String settingsBox = 'settings';
  static const String favoritesBox = 'favorites';
  static const String khatmahBox = 'khatmah';
  static const String tasbeehBox = 'tasbeeh';
  static const String adhkarBox = 'adhkar';
  static const String widgetBox = 'widget';

  // Notification IDs — general
  static const int dailyVerseNotificationId = 1001;
  static const int dailyHadithNotificationId = 1002;
  static const int morningAdhkarNotificationId = 1003;
  static const int eveningAdhkarNotificationId = 1004;

  // Prayer Notification IDs (1005-1012) — silent/banner only
  static const int prayerFajrNotificationId = 1005;
  static const int prayerSunriseNotificationId = 1006;
  static const int prayerDhuhrNotificationId = 1007;
  static const int prayerAsrNotificationId = 1008;
  static const int prayerMaghribNotificationId = 1009;
  static const int prayerIshaNotificationId = 1010;

  // Adhan Notification IDs (2001-2003) — with adhan sound
  // Shi'a schedule: Fajr, Dhuhr, Maghrib only
  static const int adhanFajrNotificationId = 2001;
  static const int adhanDhuhrNotificationId = 2002;
  static const int adhanMaghribNotificationId = 2003;

  // Quran Download
  static const String keyQuranDownloadCompleted = 'quran_download_completed';
  static const String keyQuranDownloadVersion = 'quran_download_version';

  // SharedPreferences Keys
  static const String keyOnboardingComplete = 'onboarding_complete';
  static const String keyThemeMode = 'theme_mode';
  static const String keyLanguage = 'language';
  static const String keyLastVerseIndex = 'last_verse_index';
  static const String keyLastHadithIndex = 'last_hadith_index';
  static const String keyDailyVerseNotification = 'daily_verse_notification';
  static const String keyDailyHadithNotification = 'daily_hadith_notification';
  static const String keyMorningAdhkarNotification = 'morning_adhkar_notification';
  static const String keyEveningAdhkarNotification = 'evening_adhkar_notification';
  static const String keyPrayerNotifications = 'prayer_notifications';

  // Adhan Settings Keys
  static const String keyAdhanEnabled = 'adhan_enabled';
  static const String keyAdhanFajrEnabled = 'adhan_fajr_enabled';
  static const String keyAdhanDhuhrEnabled = 'adhan_dhuhr_enabled';
  static const String keyAdhanMaghribEnabled = 'adhan_maghrib_enabled';
  static const String keyAdhanVolume = 'adhan_volume';

  // Permission Keys
  static const String keyNotificationPermissionRequested = 'notification_permission_requested';
  static const String keyExactAlarmRequested = 'exact_alarm_requested';

  // Widget Keys
  static const String keyWidgetBgColor = 'widget_bg_color';
  static const String keyWidgetTextColor = 'widget_text_color';
  static const String keyWidgetTransparency = 'widget_transparency';
  static const String keyWidgetFontSize = 'widget_font_size';

  // Notification Channels
  static const String verseChannelId = 'daily_verse';
  static const String verseChannelName = 'آية اليوم';
  static const String hadithChannelId = 'daily_hadith';
  static const String hadithChannelName = 'حديث اليوم';
  static const String adhkarChannelId = 'adhkar_reminder';
  static const String adhkarChannelName = 'تذكير الأذكار';
  static const String prayerChannelId = 'prayer_times';
  static const String prayerChannelName = 'أوقات الصلاة';

  // Adhan Notification Channel (uses audio file)
  static const String adhanChannelId = 'adhan_channel';
  static const String adhanChannelName = 'أذان الصلاة';

  // Adhan Audio — centralized mapping (Android raw resources)
  // Keys match the values stored in AppSettings.adhanSound.
  static const String defaultMuadhin = 'adhan_maitham';

  static const Map<String, String> muadhinDisplayNames = {
    'adhan_maitham': 'الحاج ميثم التمار',
    'adhan_mustafa': 'الحاج مصطفى الصراف',
    'adhan_ausama': 'الحاج أسامة الكربلائي',
  };

  static const List<String> muadhinKeys = [
    'adhan_maitham',
    'adhan_mustafa',
    'adhan_ausama',
  ];

  static String getAdhanDisplayName(String soundKey) {
    return muadhinDisplayNames[soundKey] ?? muadhinDisplayNames[defaultMuadhin]!;
  }
}

import '../services/time_formatter.dart';

export '../services/time_formatter.dart' show TimeFormat, NumeralSystem;

class AppSettings {

  // Notifications
  final bool prayerNotifications;
  final bool dailyVerseNotification;
  final bool dailyHadithNotification;

  // Widget Settings
  final int widgetBgColor;
  final int widgetTextColor;
  final double widgetTransparency;
  final double widgetFontSize;

  // Appearance
  final double appFontSize;
  final bool dynamicColors;

  // Prayer Settings
  final int calculationMethod;
  final int madhab;
  final bool autoLocation;
  final String? manualLocation;

  // Quran Settings
  final String quranFont;
  final String audioQuality;
  final String quranTranslation;
  final String quranFontFamily;
  final bool quranShowWaqf;
  final double quranFontSize;
  final String quranTashkeelColor;
  final String quranBackground;
  final bool quranAutoAudio;

  // Tasbeeh Settings
  final bool autoNextDhikr;
  final bool tasbeehVibration;
  final bool tasbeehSound;
  final int tasbeehDailyGoal;
  final bool tasbeehResetConfirmation;

  // Shia Worship Reminders
  final bool reminderTasbeehZahra;
  final bool reminderAshuraZiyarat;
  final bool reminderAhdDua;
  final bool reminderKumaylDua;
  final bool reminderTawassulDua;
  final bool reminderNahjulBalagha;
  final bool reminderSabahDua;
  final bool reminderZiyaratAalYasin;
  final bool reminderLaylPrayer;
  final bool reminderJumaaActs;

  // Occasions
  final bool occasionAhlulbaytBirth;
  final bool occasionWafaat;
  final bool occasionHijriMonths;
  final bool occasionBlessedNights;

  // Visit
  final bool visitLastRead;
  final bool visitResumePosition;
  final bool visitAutoSave;

  // App
  final bool appVibration;
  final bool appMotionEffects;

  // Language
  final String language;

  // Time & Date
  final TimeFormat timeFormat;
  final NumeralSystem numeralSystem;

  final bool onboarded;

  // Adhan Settings
  final bool adhanEnabled;
  final bool adhanFajrEnabled;
  final bool adhanDhuhrEnabled;
  final bool adhanMaghribEnabled;
  final double adhanVolume;
  final String adhanSound;
  final bool adhanVibration;
  final bool adhanBootStart;
  final int adhanSnoozeMinutes;

  AppSettings({
    this.prayerNotifications = true,
    this.dailyVerseNotification = true,
    this.dailyHadithNotification = true,
    this.widgetBgColor = 0xFF0A1946,
    this.widgetTextColor = 0xFFD8B56A,
    this.widgetTransparency = 0.85,
    this.widgetFontSize = 14.0,
    this.appFontSize = 0.8,
    this.dynamicColors = true,
    this.calculationMethod = 0,
    this.madhab = 0,
    this.autoLocation = true,
    this.manualLocation,
    this.quranFont = 'Uthmani',
    this.audioQuality = 'High',
    this.quranTranslation = 'ar_maaref',
    this.quranFontFamily = 'Amiri',
    this.quranShowWaqf = true,
    this.quranFontSize = 28.0,
    this.quranTashkeelColor = 'gold',
    this.quranBackground = 'dark',
    this.quranAutoAudio = false,
    this.autoNextDhikr = true,
    this.tasbeehVibration = true,
    this.tasbeehSound = false,
    this.tasbeehDailyGoal = 1000,
    this.tasbeehResetConfirmation = true,
    this.reminderTasbeehZahra = true,
    this.reminderAshuraZiyarat = true,
    this.reminderAhdDua = true,
    this.reminderKumaylDua = true,
    this.reminderTawassulDua = true,
    this.reminderNahjulBalagha = true,
    this.reminderSabahDua = true,
    this.reminderZiyaratAalYasin = true,
    this.reminderLaylPrayer = true,
    this.reminderJumaaActs = true,
    this.occasionAhlulbaytBirth = true,
    this.occasionWafaat = true,
    this.occasionHijriMonths = true,
    this.occasionBlessedNights = true,
    this.visitLastRead = true,
    this.visitResumePosition = true,
    this.visitAutoSave = true,
    this.appVibration = true,
    this.appMotionEffects = true,
    this.language = 'ar',
    this.timeFormat = TimeFormat.hour24,
    this.numeralSystem = NumeralSystem.arabic,
    this.onboarded = false,
    this.adhanEnabled = true,
    this.adhanFajrEnabled = true,
    this.adhanDhuhrEnabled = true,
    this.adhanMaghribEnabled = true,
    this.adhanVolume = 1.0,
    this.adhanSound = 'adhan_maitham',
    this.adhanVibration = true,
    this.adhanBootStart = true,
    this.adhanSnoozeMinutes = 5,
  });

  Map<String, dynamic> toJson() {
    return {
      'prayerNotifications': prayerNotifications,
      'dailyVerseNotification': dailyVerseNotification,
      'dailyHadithNotification': dailyHadithNotification,
      'widgetBgColor': widgetBgColor,
      'widgetTextColor': widgetTextColor,
      'widgetTransparency': widgetTransparency,
      'widgetFontSize': widgetFontSize,
      'appFontSize': appFontSize,
      'dynamicColors': dynamicColors,
      'calculationMethod': calculationMethod,
      'madhab': madhab,
      'autoLocation': autoLocation,
      'manualLocation': manualLocation,
      'quranFont': quranFont,
      'audioQuality': audioQuality,
      'quranTranslation': quranTranslation,
      'quranFontFamily': quranFontFamily,
      'quranShowWaqf': quranShowWaqf,
      'quranFontSize': quranFontSize,
      'quranTashkeelColor': quranTashkeelColor,
      'quranBackground': quranBackground,
      'quranAutoAudio': quranAutoAudio,
      'autoNextDhikr': autoNextDhikr,
      'tasbeehVibration': tasbeehVibration,
      'tasbeehSound': tasbeehSound,
      'tasbeehDailyGoal': tasbeehDailyGoal,
      'tasbeehResetConfirmation': tasbeehResetConfirmation,
      'reminderTasbeehZahra': reminderTasbeehZahra,
      'reminderAshuraZiyarat': reminderAshuraZiyarat,
      'reminderAhdDua': reminderAhdDua,
      'reminderKumaylDua': reminderKumaylDua,
      'reminderTawassulDua': reminderTawassulDua,
      'reminderNahjulBalagha': reminderNahjulBalagha,
      'reminderSabahDua': reminderSabahDua,
      'reminderZiyaratAalYasin': reminderZiyaratAalYasin,
      'reminderLaylPrayer': reminderLaylPrayer,
      'reminderJumaaActs': reminderJumaaActs,
      'occasionAhlulbaytBirth': occasionAhlulbaytBirth,
      'occasionWafaat': occasionWafaat,
      'occasionHijriMonths': occasionHijriMonths,
      'occasionBlessedNights': occasionBlessedNights,
      'visitLastRead': visitLastRead,
      'visitResumePosition': visitResumePosition,
      'visitAutoSave': visitAutoSave,
      'appVibration': appVibration,
      'appMotionEffects': appMotionEffects,
      'language': language,
      'timeFormat': timeFormat.index,
      'numeralSystem': numeralSystem.index,
      'onboarded': onboarded,
      'adhanEnabled': adhanEnabled,
      'adhanFajrEnabled': adhanFajrEnabled,
      'adhanDhuhrEnabled': adhanDhuhrEnabled,
      'adhanMaghribEnabled': adhanMaghribEnabled,
      'adhanVolume': adhanVolume,
      'adhanSound': adhanSound,
      'adhanVibration': adhanVibration,
      'adhanBootStart': adhanBootStart,
      'adhanSnoozeMinutes': adhanSnoozeMinutes,
    };
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      prayerNotifications: json['prayerNotifications'] ?? true,
      dailyVerseNotification: json['dailyVerseNotification'] ?? true,
      dailyHadithNotification: json['dailyHadithNotification'] ?? true,
      widgetBgColor: json['widgetBgColor'] ?? 0xFF0A1946,
      widgetTextColor: json['widgetTextColor'] ?? 0xFFD8B56A,
      widgetTransparency: (json['widgetTransparency'] ?? 0.85).toDouble(),
      widgetFontSize: (json['widgetFontSize'] ?? 14.0).toDouble(),
      appFontSize: (json['appFontSize'] ?? 0.8).toDouble(),
      dynamicColors: json['dynamicColors'] ?? true,
      calculationMethod: json['calculationMethod'] ?? 0,
      madhab: json['madhab'] ?? 0,
      autoLocation: json['autoLocation'] ?? true,
      manualLocation: json['manualLocation'],
      quranFont: json['quranFont'] ?? 'Uthmani',
      audioQuality: json['audioQuality'] ?? 'High',
      quranTranslation: json['quranTranslation'] ?? 'ar_maaref',
      quranFontFamily: json['quranFontFamily'] ?? 'Amiri',
      quranShowWaqf: json['quranShowWaqf'] ?? true,
      quranFontSize: (json['quranFontSize'] ?? 28.0).toDouble(),
      quranTashkeelColor: json['quranTashkeelColor'] ?? 'gold',
      quranBackground: json['quranBackground'] ?? 'dark',
      quranAutoAudio: json['quranAutoAudio'] ?? false,
      autoNextDhikr: json['autoNextDhikr'] ?? true,
      tasbeehVibration: json['tasbeehVibration'] ?? true,
      tasbeehSound: json['tasbeehSound'] ?? false,
      tasbeehDailyGoal: json['tasbeehDailyGoal'] ?? 1000,
      tasbeehResetConfirmation: json['tasbeehResetConfirmation'] ?? true,
      reminderTasbeehZahra: json['reminderTasbeehZahra'] ?? true,
      reminderAshuraZiyarat: json['reminderAshuraZiyarat'] ?? true,
      reminderAhdDua: json['reminderAhdDua'] ?? true,
      reminderKumaylDua: json['reminderKumaylDua'] ?? true,
      reminderTawassulDua: json['reminderTawassulDua'] ?? true,
      reminderNahjulBalagha: json['reminderNahjulBalagha'] ?? true,
      reminderSabahDua: json['reminderSabahDua'] ?? true,
      reminderZiyaratAalYasin: json['reminderZiyaratAalYasin'] ?? true,
      reminderLaylPrayer: json['reminderLaylPrayer'] ?? true,
      reminderJumaaActs: json['reminderJumaaActs'] ?? true,
      occasionAhlulbaytBirth: json['occasionAhlulbaytBirth'] ?? true,
      occasionWafaat: json['occasionWafaat'] ?? true,
      occasionHijriMonths: json['occasionHijriMonths'] ?? true,
      occasionBlessedNights: json['occasionBlessedNights'] ?? true,
      visitLastRead: json['visitLastRead'] ?? true,
      visitResumePosition: json['visitResumePosition'] ?? true,
      visitAutoSave: json['visitAutoSave'] ?? true,
      appVibration: json['appVibration'] ?? true,
      appMotionEffects: json['appMotionEffects'] ?? true,
      language: json['language'] ?? 'ar',
      timeFormat: TimeFormat.values[json['timeFormat'] ?? 0],
      numeralSystem: NumeralSystem.values[json['numeralSystem'] ?? 1],
      onboarded: json['onboarded'] ?? false,
      adhanEnabled: json['adhanEnabled'] ?? true,
      adhanFajrEnabled: json['adhanFajrEnabled'] ?? true,
      adhanDhuhrEnabled: json['adhanDhuhrEnabled'] ?? true,
      adhanMaghribEnabled: json['adhanMaghribEnabled'] ?? true,
      adhanVolume: (json['adhanVolume'] ?? 1.0).toDouble(),
      adhanSound: _migrateAdhanSound(json['adhanSound']),
      adhanVibration: json['adhanVibration'] ?? true,
      adhanBootStart: json['adhanBootStart'] ?? true,
      adhanSnoozeMinutes: json['adhanSnoozeMinutes'] ?? 5,
    );
  }

  static const _validMuadhinKeys = {'adhan_maitham', 'adhan_mustafa', 'adhan_ausama'};

  static String _migrateAdhanSound(dynamic value) {
    if (value is String && _validMuadhinKeys.contains(value)) return value;
    return 'adhan_maitham';
  }

  AppSettings copyWith({
    bool? prayerNotifications,
    bool? dailyVerseNotification,
    bool? dailyHadithNotification,
    int? widgetBgColor,
    int? widgetTextColor,
    double? widgetTransparency,
    double? widgetFontSize,
    double? appFontSize,
    bool? dynamicColors,
    int? calculationMethod,
    int? madhab,
    bool? autoLocation,
    String? manualLocation,
    String? quranFont,
    String? audioQuality,
    String? quranTranslation,
    String? quranFontFamily,
    bool? quranShowWaqf,
    double? quranFontSize,
    String? quranTashkeelColor,
    String? quranBackground,
    bool? quranAutoAudio,
    bool? autoNextDhikr,
    bool? tasbeehVibration,
    bool? tasbeehSound,
    int? tasbeehDailyGoal,
    bool? tasbeehResetConfirmation,
    bool? reminderTasbeehZahra,
    bool? reminderAshuraZiyarat,
    bool? reminderAhdDua,
    bool? reminderKumaylDua,
    bool? reminderTawassulDua,
    bool? reminderNahjulBalagha,
    bool? reminderSabahDua,
    bool? reminderZiyaratAalYasin,
    bool? reminderLaylPrayer,
    bool? reminderJumaaActs,
    bool? occasionAhlulbaytBirth,
    bool? occasionWafaat,
    bool? occasionHijriMonths,
    bool? occasionBlessedNights,
    bool? visitLastRead,
    bool? visitResumePosition,
    bool? visitAutoSave,
    bool? appVibration,
    bool? appMotionEffects,
    String? language,
    TimeFormat? timeFormat,
    NumeralSystem? numeralSystem,
    bool? onboarded,
    bool? adhanEnabled,
    bool? adhanFajrEnabled,
    bool? adhanDhuhrEnabled,
    bool? adhanMaghribEnabled,
    double? adhanVolume,
    String? adhanSound,
    bool? adhanVibration,
    bool? adhanBootStart,
    int? adhanSnoozeMinutes,
  }) {
    return AppSettings(
      prayerNotifications: prayerNotifications ?? this.prayerNotifications,
      dailyVerseNotification: dailyVerseNotification ?? this.dailyVerseNotification,
      dailyHadithNotification: dailyHadithNotification ?? this.dailyHadithNotification,
      widgetBgColor: widgetBgColor ?? this.widgetBgColor,
      widgetTextColor: widgetTextColor ?? this.widgetTextColor,
      widgetTransparency: widgetTransparency ?? this.widgetTransparency,
      widgetFontSize: widgetFontSize ?? this.widgetFontSize,
      appFontSize: appFontSize ?? this.appFontSize,
      dynamicColors: dynamicColors ?? this.dynamicColors,
      calculationMethod: calculationMethod ?? this.calculationMethod,
      madhab: madhab ?? this.madhab,
      autoLocation: autoLocation ?? this.autoLocation,
      manualLocation: manualLocation ?? this.manualLocation,
      quranFont: quranFont ?? this.quranFont,
      audioQuality: audioQuality ?? this.audioQuality,
      quranTranslation: quranTranslation ?? this.quranTranslation,
      quranFontFamily: quranFontFamily ?? this.quranFontFamily,
      quranShowWaqf: quranShowWaqf ?? this.quranShowWaqf,
      quranFontSize: quranFontSize ?? this.quranFontSize,
      quranTashkeelColor: quranTashkeelColor ?? this.quranTashkeelColor,
      quranBackground: quranBackground ?? this.quranBackground,
      quranAutoAudio: quranAutoAudio ?? this.quranAutoAudio,
      autoNextDhikr: autoNextDhikr ?? this.autoNextDhikr,
      tasbeehVibration: tasbeehVibration ?? this.tasbeehVibration,
      tasbeehSound: tasbeehSound ?? this.tasbeehSound,
      tasbeehDailyGoal: tasbeehDailyGoal ?? this.tasbeehDailyGoal,
      tasbeehResetConfirmation: tasbeehResetConfirmation ?? this.tasbeehResetConfirmation,
      reminderTasbeehZahra: reminderTasbeehZahra ?? this.reminderTasbeehZahra,
      reminderAshuraZiyarat: reminderAshuraZiyarat ?? this.reminderAshuraZiyarat,
      reminderAhdDua: reminderAhdDua ?? this.reminderAhdDua,
      reminderKumaylDua: reminderKumaylDua ?? this.reminderKumaylDua,
      reminderTawassulDua: reminderTawassulDua ?? this.reminderTawassulDua,
      reminderNahjulBalagha: reminderNahjulBalagha ?? this.reminderNahjulBalagha,
      reminderSabahDua: reminderSabahDua ?? this.reminderSabahDua,
      reminderZiyaratAalYasin: reminderZiyaratAalYasin ?? this.reminderZiyaratAalYasin,
      reminderLaylPrayer: reminderLaylPrayer ?? this.reminderLaylPrayer,
      reminderJumaaActs: reminderJumaaActs ?? this.reminderJumaaActs,
      occasionAhlulbaytBirth: occasionAhlulbaytBirth ?? this.occasionAhlulbaytBirth,
      occasionWafaat: occasionWafaat ?? this.occasionWafaat,
      occasionHijriMonths: occasionHijriMonths ?? this.occasionHijriMonths,
      occasionBlessedNights: occasionBlessedNights ?? this.occasionBlessedNights,
      visitLastRead: visitLastRead ?? this.visitLastRead,
      visitResumePosition: visitResumePosition ?? this.visitResumePosition,
      visitAutoSave: visitAutoSave ?? this.visitAutoSave,
      appVibration: appVibration ?? this.appVibration,
      appMotionEffects: appMotionEffects ?? this.appMotionEffects,
      language: language ?? this.language,
      timeFormat: timeFormat ?? this.timeFormat,
      numeralSystem: numeralSystem ?? this.numeralSystem,
      onboarded: onboarded ?? this.onboarded,
      adhanEnabled: adhanEnabled ?? this.adhanEnabled,
      adhanFajrEnabled: adhanFajrEnabled ?? this.adhanFajrEnabled,
      adhanDhuhrEnabled: adhanDhuhrEnabled ?? this.adhanDhuhrEnabled,
      adhanMaghribEnabled: adhanMaghribEnabled ?? this.adhanMaghribEnabled,
      adhanVolume: adhanVolume ?? this.adhanVolume,
      adhanSound: adhanSound ?? this.adhanSound,
      adhanVibration: adhanVibration ?? this.adhanVibration,
      adhanBootStart: adhanBootStart ?? this.adhanBootStart,
      adhanSnoozeMinutes: adhanSnoozeMinutes ?? this.adhanSnoozeMinutes,
    );
  }
}

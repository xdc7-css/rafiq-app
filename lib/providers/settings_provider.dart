import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../database/local_database.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';
import '../services/data_service.dart';
import '../services/prayer_notification_service.dart';
import '../services/adhan_scheduler.dart';
import '../services/prayer_scheduler.dart';
import 'prayer_time_providers.dart';

class SettingsNotifier extends StateNotifier<AppSettings> {
  final Ref _ref;

  SettingsNotifier(this._ref) : super(StorageService.getSettings()) {
    _loadFromDb();
  }

  Future<void> _loadFromDb() async {
    final db = LocalDatabaseService.instance;
    if (!db.isInitialized) return;
    final entry = await db.getSettings();
    if (entry != null) {
      try {
        final parsed = AppSettings.fromJson(json.decode(entry.data));
        if (mounted) state = parsed;
      } catch (_) {}
    }
  }

  Future<void> _saveSettings() async {
    StorageService.saveSettings(state);
    final db = LocalDatabaseService.instance;
    if (db.isInitialized) {
      await db.saveSettings(json.encode(state.toJson()));
    }
  }

  // ── Appearance ──

  void updateAppFontSize(double value) {
    state = state.copyWith(appFontSize: value.clamp(AppSettings.kMinAppFontSize, AppSettings.kMaxAppFontSize));
    _saveSettings();
  }

  void toggleDynamicColors() {
    state = state.copyWith(dynamicColors: !state.dynamicColors);
    _saveSettings();
  }

  // ── Notifications ──

  void togglePrayerNotifications() {
    state = state.copyWith(prayerNotifications: !state.prayerNotifications);
    _saveSettings();
    _ref
        .read(prayerTimesProvider.notifier)
        .setNotificationsEnabled(state.prayerNotifications);
    _reschedulePrayerNotifications();
  }

  void toggleDailyVerseNotification() {
    state = state.copyWith(dailyVerseNotification: !state.dailyVerseNotification);
    _saveSettings();
    _rescheduleVerseNotification();
  }

  void toggleDailyHadithNotification() {
    state = state.copyWith(dailyHadithNotification: !state.dailyHadithNotification);
    _saveSettings();
    _rescheduleHadithNotification();
  }

  Future<void> _rescheduleVerseNotification() async {
    if (state.dailyVerseNotification) {
      final verses = DataService.allVerses;
      if (verses.isNotEmpty) {
        await NotificationService.scheduleDailyVerseNotification(verses.first);
      }
    }
  }

  Future<void> _rescheduleHadithNotification() async {
    if (state.dailyHadithNotification) {
      final hadiths = DataService.allHadiths;
      if (hadiths.isNotEmpty) {
        await NotificationService.scheduleDailyHadithNotification(hadiths.first);
      }
    }
  }

  Future<void> _reschedulePrayerNotifications() async {
    final times = _ref.read(prayerTimesProvider).prayerTimes;
    if (times != null) {
      if (state.prayerNotifications || state.adhanEnabled) {
        await PrayerScheduler.instance.scheduleForToday(times, force: true);
      } else {
        await PrayerScheduler.instance.cancelAll();
      }
    }
  }

  // ── Prayer ──

  void updateCalculationMethod(int method) {
    state = state.copyWith(calculationMethod: method);
    _saveSettings();
    _ref.read(prayerTimesProvider.notifier).setCalculationMethod(method);
  }

  void updateMadhab(int madhab) {
    state = state.copyWith(madhab: madhab);
    _saveSettings();
    _ref.read(prayerTimesProvider.notifier).refresh();
  }

  void toggleAutoLocation() {
    state = state.copyWith(autoLocation: !state.autoLocation);
    _saveSettings();
    _ref.read(prayerTimesProvider.notifier).refresh();
  }

  void updateManualLocation(String location) {
    state = state.copyWith(manualLocation: location);
    _saveSettings();
    _ref.read(prayerTimesProvider.notifier).refresh();
  }

  // ── Quran ──

  void updateQuranFont(String font) {
    state = state.copyWith(quranFont: font);
    _saveSettings();
  }

  void updateAudioQuality(String quality) {
    state = state.copyWith(audioQuality: quality);
    _saveSettings();
  }

  void updateQuranTranslation(String translation) {
    state = state.copyWith(quranTranslation: translation);
    _saveSettings();
  }

  void updateQuranFontFamily(String fontFamily) {
    state = state.copyWith(quranFontFamily: fontFamily);
    _saveSettings();
  }

  void toggleQuranShowWaqf() {
    state = state.copyWith(quranShowWaqf: !state.quranShowWaqf);
    _saveSettings();
  }

  void updateQuranFontSize(double size) {
    state = state.copyWith(quranFontSize: size);
    _saveSettings();
  }

  void updateQuranTashkeelColor(String color) {
    state = state.copyWith(quranTashkeelColor: color);
    _saveSettings();
  }

  void updateQuranBackground(String bg) {
    state = state.copyWith(quranBackground: bg);
    _saveSettings();
  }

  void toggleQuranAutoAudio() {
    state = state.copyWith(quranAutoAudio: !state.quranAutoAudio);
    _saveSettings();
  }

  // ── Tasbeeh ──

  void toggleAutoNextDhikr() {
    state = state.copyWith(autoNextDhikr: !state.autoNextDhikr);
    _saveSettings();
  }

  void toggleTasbeehVibration() {
    state = state.copyWith(tasbeehVibration: !state.tasbeehVibration);
    _saveSettings();
  }

  void toggleTasbeehSound() {
    state = state.copyWith(tasbeehSound: !state.tasbeehSound);
    _saveSettings();
  }

  void updateTasbeehDailyGoal(int goal) {
    state = state.copyWith(tasbeehDailyGoal: goal);
    _saveSettings();
  }

  void toggleTasbeehResetConfirmation() {
    state = state.copyWith(tasbeehResetConfirmation: !state.tasbeehResetConfirmation);
    _saveSettings();
  }

  // ── Shia Worship Reminders ──

  void toggleReminderTasbeehZahra() {
    state = state.copyWith(reminderTasbeehZahra: !state.reminderTasbeehZahra);
    _saveSettings();
  }

  void toggleReminderAshuraZiyarat() {
    state = state.copyWith(reminderAshuraZiyarat: !state.reminderAshuraZiyarat);
    _saveSettings();
  }

  void toggleReminderAhdDua() {
    state = state.copyWith(reminderAhdDua: !state.reminderAhdDua);
    _saveSettings();
  }

  void toggleReminderKumaylDua() {
    state = state.copyWith(reminderKumaylDua: !state.reminderKumaylDua);
    _saveSettings();
  }

  void toggleReminderTawassulDua() {
    state = state.copyWith(reminderTawassulDua: !state.reminderTawassulDua);
    _saveSettings();
  }

  void toggleReminderNahjulBalagha() {
    state = state.copyWith(reminderNahjulBalagha: !state.reminderNahjulBalagha);
    _saveSettings();
  }

  void toggleReminderSabahDua() {
    state = state.copyWith(reminderSabahDua: !state.reminderSabahDua);
    _saveSettings();
  }

  void toggleReminderZiyaratAalYasin() {
    state = state.copyWith(reminderZiyaratAalYasin: !state.reminderZiyaratAalYasin);
    _saveSettings();
  }

  void toggleReminderLaylPrayer() {
    state = state.copyWith(reminderLaylPrayer: !state.reminderLaylPrayer);
    _saveSettings();
  }

  void toggleReminderJumaaActs() {
    state = state.copyWith(reminderJumaaActs: !state.reminderJumaaActs);
    _saveSettings();
  }

  // ── Occasions ──

  void toggleOccasionAhlulbaytBirth() {
    state = state.copyWith(occasionAhlulbaytBirth: !state.occasionAhlulbaytBirth);
    _saveSettings();
  }

  void toggleOccasionWafaat() {
    state = state.copyWith(occasionWafaat: !state.occasionWafaat);
    _saveSettings();
  }

  void toggleOccasionHijriMonths() {
    state = state.copyWith(occasionHijriMonths: !state.occasionHijriMonths);
    _saveSettings();
  }

  void toggleOccasionBlessedNights() {
    state = state.copyWith(occasionBlessedNights: !state.occasionBlessedNights);
    _saveSettings();
  }

  // ── Visit ──

  void toggleVisitLastRead() {
    state = state.copyWith(visitLastRead: !state.visitLastRead);
    _saveSettings();
  }

  void toggleVisitResumePosition() {
    state = state.copyWith(visitResumePosition: !state.visitResumePosition);
    _saveSettings();
  }

  void toggleVisitAutoSave() {
    state = state.copyWith(visitAutoSave: !state.visitAutoSave);
    _saveSettings();
  }

  // ── App ──

  void toggleAppVibration() {
    state = state.copyWith(appVibration: !state.appVibration);
    _saveSettings();
  }

  void toggleAppMotionEffects() {
    state = state.copyWith(appMotionEffects: !state.appMotionEffects);
    _saveSettings();
  }

  // ── Language ──

  void updateLanguage(String lang) {
    state = state.copyWith(language: lang);
    _saveSettings();
  }

  // ── Time & Date ──

  void updateTimeFormat(TimeFormat format) {
    state = state.copyWith(timeFormat: format);
    _saveSettings();
  }

  void updateNumeralSystem(NumeralSystem system) {
    state = state.copyWith(numeralSystem: system);
    _saveSettings();
  }

  // ── Widget ──

  void updateWidgetColors(int bgColor, int textColor) {
    state = state.copyWith(widgetBgColor: bgColor, widgetTextColor: textColor);
    _saveSettings();
  }

  void updateWidgetTransparency(double value) {
    state = state.copyWith(widgetTransparency: value);
    _saveSettings();
  }

  void updateWidgetFontSize(double value) {
    state = state.copyWith(widgetFontSize: value);
    _saveSettings();
  }

  // ── Onboard ──

  Future<void> markOnboarded() async {
    state = state.copyWith(onboarded: true);
    await _saveSettings();
  }

  // ── Reset ──

  void resetAllSettings() {
    state = AppSettings();
    _saveSettings();
  }

  // ── Adhan Settings ──

  void toggleAdhanEnabled() {
    state = state.copyWith(adhanEnabled: !state.adhanEnabled);
    _saveSettings();
    if (!state.adhanEnabled) {
      AdhanScheduler.instance.stopAdhan();
    } else {
      _reschedulePrayerNotifications();
    }
  }

  void toggleAdhanFajr() {
    state = state.copyWith(adhanFajrEnabled: !state.adhanFajrEnabled);
    _saveSettings();
    _reschedulePrayerNotifications();
  }

  void toggleAdhanDhuhr() {
    state = state.copyWith(adhanDhuhrEnabled: !state.adhanDhuhrEnabled);
    _saveSettings();
    _reschedulePrayerNotifications();
  }

  void toggleAdhanMaghrib() {
    state = state.copyWith(adhanMaghribEnabled: !state.adhanMaghribEnabled);
    _saveSettings();
    _reschedulePrayerNotifications();
  }

  void updateAdhanVolume(double volume) {
    state = state.copyWith(adhanVolume: volume.clamp(0.0, 1.0));
    _saveSettings();
    _reschedulePrayerNotifications();
  }

  void updateAdhanSound(String sound) {
    state = state.copyWith(adhanSound: sound);
    _saveSettings();
    AdhanScheduler.instance.updateSettings();
  }

  void toggleAdhanVibration() {
    state = state.copyWith(adhanVibration: !state.adhanVibration);
    _saveSettings();
  }

  void toggleAdhanBootStart() {
    state = state.copyWith(adhanBootStart: !state.adhanBootStart);
    _saveSettings();
  }

  void updateAdhanSnoozeMinutes(int minutes) {
    state = state.copyWith(adhanSnoozeMinutes: minutes.clamp(1, 30));
    _saveSettings();
    AdhanScheduler.instance.updateSettings();
  }

  Future<void> testAdhan() async {
    await AdhanScheduler.instance.playTestAdhan();
  }

  Future<void> stopAdhan() async {
    await AdhanScheduler.instance.stopAdhan();
    await PrayerNotificationService.cancelAll();
    final times = _ref.read(prayerTimesProvider).prayerTimes;
    if (times != null) {
      await PrayerScheduler.instance.scheduleForToday(times, force: true);
    }
  }

}

final settingsNotifierProvider =
    StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
      return SettingsNotifier(ref);
    });

final localeProvider = Provider<Locale>((ref) {
  final settings = ref.watch(settingsNotifierProvider);
  return Locale(settings.language);
});

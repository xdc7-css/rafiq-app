import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/khatmah_model.dart';
import '../database/local_database.dart';
import '../services/storage_service.dart';
import '../services/home_widget_service.dart';

class KhatmahNotifier extends StateNotifier<KhatmahModel?> {
  KhatmahNotifier() : super(StorageService.getCurrentKhatmah()) {
    _loadFromDb();
  }

  Future<void> _loadFromDb() async {
    final db = LocalDatabaseService.instance;
    if (!db.isInitialized) return;
    final k = await db.getCurrentKhatmah();
    if (k != null && mounted) {
      state = KhatmahModel(
        currentPage: k.currentPage,
        currentSurah: k.currentSurah,
        currentAyah: k.currentAyah,
        totalAyahsRead: k.totalAyahsRead,
        startDate: k.startDate,
        lastReadDate: k.lastReadDate,
        name: k.name,
        readingStreak: List<int>.from(json.decode(k.readingStreakJson)),
      );
    }
  }

  Future<void> _saveToDb() async {
    final db = LocalDatabaseService.instance;
    if (!db.isInitialized || state == null) return;
    final s = state!;
    await db.saveKhatmah(KhatmahEntry(
      currentPage: s.currentPage,
      currentSurah: s.currentSurah,
      currentAyah: s.currentAyah,
      totalAyahsRead: s.totalAyahsRead,
      startDate: s.startDate,
      lastReadDate: s.lastReadDate ?? DateTime.now(),
      name: s.name,
      readingStreakJson: json.encode(s.readingStreak),
    ));
  }

  void startNewKhatmah({String name = 'ختمتي'}) {
    final khatmah = KhatmahModel(
      id: const Uuid().v4(),
      name: name,
      currentSurah: 1,
      currentAyah: 1,
      currentPage: 1,
    );
    state = khatmah;
    StorageService.saveKhatmah(khatmah);
    _saveToDb();
  }

  void advanceAyah() {
    if (state == null) return;
    final s = state!;
    final surahAyahCount = KhatmahModel.surahAyahCount(s.currentSurah);

    int nextSurah = s.currentSurah;
    int nextAyah = s.currentAyah + 1;

    if (nextAyah > surahAyahCount) {
      if (nextSurah >= 114) return;
      nextSurah++;
      nextAyah = 1;
    }

    final page = KhatmahModel.pageForPosition(nextSurah, nextAyah);
    final today = DateTime.now();
    final todayDay = today.year * 10000 + today.month * 100 + today.day;
    final streak = List<int>.from(s.readingStreak);
    if (!streak.contains(todayDay)) {
      streak.add(todayDay);
    }

    state = s.copyWith(
      currentSurah: nextSurah,
      currentAyah: nextAyah,
      currentPage: page,
      totalAyahsRead: s.totalAyahsRead + 1,
      lastReadDate: today,
      readingStreak: streak,
    );
    StorageService.saveKhatmah(state!);
    _saveToDb();
    _syncQuranWidget();
  }

  void jumpTo(int surah, int ayah) {
    if (state == null) return;
    if (surah < 1 || surah > 114) return;
    final maxAyah = KhatmahModel.surahAyahCount(surah);
    if (ayah < 1 || ayah > maxAyah) return;

    final page = KhatmahModel.pageForPosition(surah, ayah);
    final today = DateTime.now();
    final todayDay = today.year * 10000 + today.month * 100 + today.day;
    final streak = List<int>.from(state!.readingStreak);
    if (!streak.contains(todayDay)) {
      streak.add(todayDay);
    }

    state = state!.copyWith(
      currentSurah: surah,
      currentAyah: ayah,
      currentPage: page,
      lastReadDate: today,
      readingStreak: streak,
    );
    StorageService.saveKhatmah(state!);
    _saveToDb();
    _syncQuranWidget();
  }

  void reset() {
    if (state == null) return;
    state = state!.copyWith(
      currentSurah: 1,
      currentAyah: 1,
      currentPage: 1,
      totalAyahsRead: 0,
      readingStreak: <int>[],
    );
    StorageService.saveKhatmah(state!);
    _saveToDb();
    _syncQuranWidget();
  }

  void delete() {
    state = null;
    StorageService.deleteKhatmah();
    final db = LocalDatabaseService.instance;
    if (db.isInitialized) db.deleteKhatmah();
  }

  static const _surahNames = [
    '', 'الفاتحة', 'البقرة', 'آل عمران', 'النساء', 'المائدة', 'الأنعام',
    'الأعراف', 'الأنفال', 'التوبة', 'يونس', 'هود', 'يوسف', 'الرعد',
    'إبراهيم', 'الحجر', 'النحل', 'الإسراء', 'الكهف', 'مريم', 'طه',
    'الأنبياء', 'الحج', 'المؤمنون', 'النور', 'الفرقان', 'الشعراء',
    'النمل', 'القصص', 'العنكبوت', 'الروم', 'لقمان', 'السجدة', 'الأحزاب',
    'سبأ', 'فاطر', 'يس', 'الصافات', 'ص', 'الزمر', 'غافر',
    'فصلت', 'الشورى', 'الزخرف', 'الدخان', 'الجاثية', 'الأحقاف',
    'محمد', 'الفتح', 'الحجرات', 'ق', 'الذاريات', 'الطور', 'النجم',
    'القمر', 'الرحمن', 'الواقعة', 'الحديد', 'المجادلة', 'الحشر',
    'الممتحنة', 'الصف', 'الجمعة', 'المنافقون', 'التغابن', 'الطلاق',
    'التحريم', 'الملك', 'القلم', 'الحاقة', 'المعارج', 'نوح',
    'الجن', 'المزمل', 'المدثر', 'القيامة', 'الإنسان', 'المرسلات',
    'النبأ', 'النازعات', 'عبس', 'التكوير', 'الانفطار', 'المطففين',
    'الانشقاق', 'البروج', 'الطارق', 'الأعلى', 'الغاشية', 'الفجر',
    'البلد', 'الشمس', 'الليل', 'الضحى', 'الشرح', 'التين',
    'العلق', 'القدر', 'البينة', 'الزلزلة', 'العاديات', 'القارعة',
    'التكاثر', 'العصر', 'الهمزة', 'الفيل', 'قريش', 'الماعون',
    'الكوثر', 'الكافرون', 'النصر', 'المسد', 'الإخلاص', 'الفلق',
    'الناس',
  ];

  void _syncQuranWidget() {
    final k = state;
    if (k == null) return;
    final surahName = k.currentSurah < _surahNames.length
        ? 'سورة ${_surahNames[k.currentSurah]}'
        : '';
    HomeWidgetService.updateQuranWidget(
      surahName: surahName,
      surahNumber: k.currentSurah,
      ayah: k.currentAyah,
      page: k.currentPage,
      hasKhatmah: true,
    );
  }
}

final khatmahNotifierProvider =
    StateNotifierProvider<KhatmahNotifier, KhatmahModel?>((ref) {
  return KhatmahNotifier();
});

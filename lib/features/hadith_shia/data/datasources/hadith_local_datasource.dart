import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../../core/cache/hive_cache_manager.dart';
import '../models/shia_hadith_models.dart';

class HadithLocalDataSource {
  List<ShiaHadith>? _fallbackHadiths;

  Future<List<ShiaHadith>> getCachedHadiths(String bookId) async {
    final cached = HiveCacheManager.getCachedList('book_$bookId');
    if (cached != null) {
      return cached.map((j) => ShiaHadith.fromLocalJson(j)).where((h) => h.text.isNotEmpty).toList();
    }
    return [];
  }

  Future<void> cacheHadiths(String bookId, List<ShiaHadith> hadiths) async {
    await HiveCacheManager.cacheList(
      'book_$bookId',
      hadiths.map((h) => h.toJson()).toList(),
    );
  }

  Future<ShiaHadith?> getCachedDailyHadith() async {
    final cached = HiveCacheManager.getCachedMap('daily_hadith');
    if (cached != null) {
      return ShiaHadith.fromLocalJson(cached);
    }
    return null;
  }

  Future<void> cacheDailyHadith(ShiaHadith hadith) async {
    await HiveCacheManager.cacheMap('daily_hadith', hadith.toJson());
  }

  Future<List<ShiaHadith>> getCachedSearchResults(String query) async {
    final cached = HiveCacheManager.getCachedList('search_${query.hashCode}');
    if (cached != null) {
      return cached.map((j) => ShiaHadith.fromLocalJson(j)).toList();
    }
    return [];
  }

  Future<void> cacheSearchResults(String query, List<ShiaHadith> hadiths) async {
    await HiveCacheManager.cacheList(
      'search_${query.hashCode}',
      hadiths.map((h) => h.toJson()).toList(),
    );
  }

  Future<List<ShiaHadith>> getFallbackHadiths() async {
    if (_fallbackHadiths != null) return _fallbackHadiths!;

    try {
      final data = await rootBundle.loadString('assets/data/hadiths.json');
      final List<dynamic> jsonList = json.decode(data);
      _fallbackHadiths = jsonList.asMap().entries.map((e) {
        final j = e.value as Map<String, dynamic>;
        return ShiaHadith(
          number: e.key + 1,
          bookId: 'local',
          text: j['text'] ?? j['text_arabic'] ?? '',
          narrator: j['narrator'],
          subject: j['source'] ?? j['category'],
        );
      }).where((h) => h.text.isNotEmpty).toList();
    } catch (_) {
      _fallbackHadiths = _defaultFallbacks();
    }

    return _fallbackHadiths!;
  }

  List<ShiaHadith> _defaultFallbacks() {
    return const [
      ShiaHadith(
        number: 1,
        bookId: 'local',
        text: 'إِنَّ اللَّهَ لَا يُحِبُّ كُلَّ خَوَّانٍ كَفُورٍ',
        narrator: 'الإمام علي (ع)',
        subject: 'صفات المؤمن',
      ),
      ShiaHadith(
        number: 2,
        bookId: 'local',
        text: 'مَنْ لَمْ يَهْدِهِ اللَّهُ فَلَا هَادِيَ لَهُ',
        narrator: 'الإمام الصادق (ع)',
        subject: 'الهداية',
      ),
      ShiaHadith(
        number: 3,
        bookId: 'local',
        text: 'إِنَّ اللَّهَ جَمِيلٌ يُحِبُّ الْجَمَالَ',
        narrator: 'الإمام الصادق (ع)',
        subject: 'الجمال',
      ),
      ShiaHadith(
        number: 4,
        bookId: 'local',
        text: 'خَيْرُكُمْ مَنْ تَعَلَّمَ الْقُرْآنَ وَعَلَّمَهُ',
        narrator: 'الإمام علي (ع)',
        subject: 'القرآن',
      ),
      ShiaHadith(
        number: 5,
        bookId: 'local',
        text: 'الدُّعَاءُ هُوَ الْعِبَادَةُ',
        narrator: 'الإمام علي الرضا (ع)',
        subject: 'الدعاء',
      ),
      ShiaHadith(
        number: 6,
        bookId: 'local',
        text: 'أَحَبُّ الْأَعْمَالِ إِلَى اللَّهِ أَدْوَمُهَا وَإِنْ قَلَّ',
        narrator: 'الإمام الصادق (ع)',
        subject: 'العبادة',
      ),
      ShiaHadith(
        number: 7,
        bookId: 'local',
        text: 'مَنْ لَمْ يَشْكُرِ النَّاسَ لَمْ يَشْكُرِ اللَّهَ',
        narrator: 'الإمام علي (ع)',
        subject: 'الشكر',
      ),
      ShiaHadith(
        number: 8,
        bookId: 'local',
        text: 'إِنَّ اللَّهَ يُحِبُّ الْعَبْدَ التَّوَّابَ الْمُتَظَهِّرَ',
        narrator: 'الإمام الباقر (ع)',
        subject: 'التوبة',
      ),
    ];
  }

  int get fallbackCount => _fallbackHadiths?.length ?? 8;
}

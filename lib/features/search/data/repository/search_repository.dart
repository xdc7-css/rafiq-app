import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../quran/data/datasources/quran_local_source.dart';
import '../../../hadith/data/datasources/hadith_local_source.dart';
import '../../../adhkar/data/datasources/adhkar_local_source.dart';
import '../models/search_models.dart';

final quranLocalSrcProvider = Provider<QuranLocalSource>((ref) => QuranLocalSource());
final hadithLocalSrcProvider = Provider<HadithLocalSource>((ref) => HadithLocalSource());
final adhkarLocalSrcProvider = Provider<AdhkarLocalSource>((ref) => AdhkarLocalSource());

class SearchRepository {
  final QuranLocalSource _quran;
  final HadithLocalSource _hadith;
  final AdhkarLocalSource _adhkar;

  SearchRepository(this._quran, this._hadith, this._adhkar);

  Future<SearchResults> globalSearch(String query) async {
    final q = query.trim();
    if (q.isEmpty) return const SearchResults();

    final quranResults = await _searchQuran(q);
    final hadithResults = await _searchHadith(q);
    final adhkarResults = await _searchAdhkar(q);

    return SearchResults(
      quran: quranResults,
      hadith: hadithResults,
      adhkar: adhkarResults,
      totalCount: quranResults.length + hadithResults.length + adhkarResults.length,
    );
  }

  Future<List<SearchResult>> _searchQuran(String query) async {
    final ayahs = await _quran.searchAyahs(query);
    final names = await _quran.loadSurahNames();
    return ayahs.map((a) {
      final surah = names.where((s) => s.number == a.surahNumber).firstOrNull;
      return SearchResult(
        id: 'quran_${a.number}',
        text: a.text,
        reference: '${surah?.name ?? ''} : ${a.numberInSurah}',
        subReference: 'الجزء ${a.juz}',
        type: SearchResultType.quran,
      );
    }).toList();
  }

  static const _imamNarrators = {
    1: 'الإمام علي بن أبي طالب (ع)',
    2: 'الإمام الحسن المجتبى (ع)',
    3: 'الإمام الحسين سيد الشهداء (ع)',
    4: 'الإمام زين العابدين (ع)',
    5: 'الإمام محمد الباقر (ع)',
    6: 'الإمام جعفر الصادق (ع)',
    7: 'الإمام موسى الكاظم (ع)',
    8: 'الإمام علي الرضا (ع)',
    9: 'الإمام محمد الجواد (ع)',
    10: 'الإمام علي الهادي (ع)',
    11: 'الإمام الحسن العسكري (ع)',
    12: 'الإمام المهدي (عج)',
  };

  Future<List<SearchResult>> _searchHadith(String query) async {
    final hadiths = await _hadith.searchHadiths(query);
    return hadiths.map((h) {
      return SearchResult(
        id: 'hadith_${h.id}',
        text: h.text,
        reference: h.source,
        subReference: _imamNarrators[h.imamId] ?? '',
        type: SearchResultType.hadith,
      );
    }).toList();
  }

  Future<List<SearchResult>> _searchAdhkar(String query) async {
    final dhikrs = await _adhkar.searchAdhkar(query);
    return dhikrs.map((d) {
      return SearchResult(
        id: 'dhikr_${d.id}',
        text: d.text,
        reference: d.reference,
        type: SearchResultType.adhkar,
      );
    }).toList();
  }
}

final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  return SearchRepository(
    ref.watch(quranLocalSrcProvider),
    ref.watch(hadithLocalSrcProvider),
    ref.watch(adhkarLocalSrcProvider),
  );
});

import '../datasources/mafatih_local_source.dart';
import '../models/mafatih_models.dart';

class MafatihRepository {
  final MafatihLocalSource _source;

  MafatihRepository(this._source);

  Future<List<MafatihChapter>> getChapters() => _source.loadChapters();

  List<MafatihChapter>? get cached => _source.cached;

  MafatihArticle? findArticle(String href) {
    final chapters = _source.cached;
    if (chapters == null) return null;
    for (final ch in chapters) {
      for (final sec in ch.sections) {
        for (final art in sec.articles) {
          if (art.href == href) return art;
        }
      }
    }
    return null;
  }

  List<MafatihSearchResult> search(String query) {
    final chapters = _source.cached;
    if (chapters == null || query.trim().isEmpty) return [];
    final q = _removeDiacritics(query.trim().toLowerCase());
    final results = <MafatihSearchResult>[];
    for (final ch in chapters) {
      for (final sec in ch.sections) {
        for (final art in sec.articles) {
          if (_matches(art, q)) {
            results.add(MafatihSearchResult(
              article: art,
              chapterTitle: ch.titleClean,
              sectionTitle: sec.titleSafe.isNotEmpty ? sec.titleSafe : null,
            ));
          }
        }
      }
    }
    return results;
  }

  bool _matches(MafatihArticle art, String query) {
    final title = _removeDiacritics(art.titleClean.toLowerCase());
    final arabic = _removeDiacritics(art.arabicText.toLowerCase());
    final trans = _removeDiacritics(art.translation.toLowerCase());
    final about = _removeDiacritics(art.aboutText.toLowerCase());
    if (title.contains(query)) return true;
    if (arabic.contains(query)) return true;
    if (trans.contains(query)) return true;
    if (about.contains(query)) return true;
    return false;
  }

  static String _removeDiacritics(String s) {
    const diacritics = {
      '\u064B', '\u064C', '\u064D', '\u064E', '\u064F',
      '\u0650', '\u0651', '\u0652', '\u0653', '\u0654',
      '\u0655', '\u0656', '\u0657', '\u0658', '\u0659',
      '\u065A', '\u065B', '\u065C', '\u065D', '\u065E',
      '\u065F', '\u0670',
    };
    return s.split('').where((c) => !diacritics.contains(c)).join();
  }

  void clearCache() => _source.clearCache();
}

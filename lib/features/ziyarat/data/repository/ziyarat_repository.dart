import '../datasources/ziyarat_local_source.dart';
import '../models/ziyarat_models.dart';

class ZiyaratRepository {
  final ZiyaratLocalSource _localSource;

  ZiyaratRepository(this._localSource);

  Future<List<ZiyaratModel>> getZiyarat() => _localSource.loadZiyarat();
  Future<List<DuaModel>> getDuas() => _localSource.loadDuas();
  Future<List<SahifaModel>> getSahifa() => _localSource.loadSahifa();
  Future<List<MafatihSection>> getMafatih() => _localSource.loadMafatih();
  Future<List<IslamicOccasion>> getOccasions() => _localSource.loadOccasions();

  Future<List<ContentSearchResult>> search(String query) async {
    if (query.trim().isEmpty) return [];
    final q = query.trim();
    final results = <ContentSearchResult>[];

    final ziyarat = await _localSource.loadZiyarat();
    for (final z in ziyarat) {
      if (z.title.contains(q) || z.tags.any((t) => t.contains(q))) {
        results.add(ContentSearchResult(
          id: z.id,
          title: z.title,
          type: 'ziyarat',
          matchPreview: z.fullText.length > 100
              ? '${z.fullText.substring(0, 100)}...'
              : z.fullText,
        ));
      }
    }

    final duas = await _localSource.loadDuas();
    for (final d in duas) {
      if (d.title.contains(q) || d.tags.any((t) => t.contains(q))) {
        results.add(ContentSearchResult(
          id: d.id,
          title: d.title,
          type: 'dua',
          matchPreview: d.fullText.length > 100
              ? '${d.fullText.substring(0, 100)}...'
              : d.fullText,
        ));
      }
    }

    final sahifa = await _localSource.loadSahifa();
    for (final s in sahifa) {
      if (s.title.contains(q) || s.tags.any((t) => t.contains(q))) {
        results.add(ContentSearchResult(
          id: 'sahifa_${s.number}',
          title: s.title,
          type: 'sahifa',
          matchPreview: s.fullText.length > 100
              ? '${s.fullText.substring(0, 100)}...'
              : s.fullText,
        ));
      }
    }

    final occasions = await _localSource.loadOccasions();
    for (final o in occasions) {
      if (o.title.contains(q)) {
        results.add(ContentSearchResult(
          id: o.id,
          title: o.title,
          type: 'occasion',
          matchPreview: o.description.length > 100
              ? '${o.description.substring(0, 100)}...'
              : o.description,
        ));
      }
    }

    _sortByRelevance(results, q);
    return results;
  }

  void _sortByRelevance(List<ContentSearchResult> results, String query) {
    results.sort((a, b) {
      final aTitle = a.title.startsWith(query) ? 0 : 1;
      final bTitle = b.title.startsWith(query) ? 0 : 1;
      if (aTitle != bTitle) return aTitle.compareTo(bTitle);
      return a.relevance.compareTo(b.relevance);
    });
  }

  void clearCache() => _localSource.clearCache();
}

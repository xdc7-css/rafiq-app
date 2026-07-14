import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/fatwa_model.dart';
import '../../core/fatwa_index.dart';
import '../../domain/repositories/fatwa_repository.dart';

class FatwaLocalDataSource {
  static const _bookmarksKey = 'fatwa_bookmarked_ids';
  static const _historyKey = 'fatwa_search_history';

  final FatwaIndex _index = FatwaIndex();
  bool _initialized = false;

  FatwaIndex get index => _index;

  Future<void> init() async {
    if (_initialized) return;
    await _loadFromAsset();
    await _restoreBookmarks();
    _initialized = true;
  }

  Future<void> _loadFromAsset() async {
    final jsonStr = await rootBundle.loadString('assets/data/fatwa/fatwas.json');
    final data = json.decode(jsonStr) as Map<String, dynamic>;

    final categoriesList = (data['categories'] as List<dynamic>?)
            ?.map((c) => {
                  'id': (c as Map<String, dynamic>)['id'] as String? ?? '',
                  'name': c['name'] as String? ?? '',
                })
            .toList() ??
        [];

    final categoryMap = <String, String>{};
    final catEntries = <Map<String, String>>[];
    for (final c in categoriesList) {
      final id = c['id']!;
      final name = c['name']!;
      categoryMap[id] = name;
      catEntries.add({'id': id, 'name': name});
    }

    final fatwasList = (data['fatwas'] as List<dynamic>?)
            ?.map((j) =>
                FatwaModel.fromJson(j as Map<String, dynamic>, categoryMap))
            .toList() ??
        [];

    _index.build(fatwasList, catEntries);
  }

  Future<void> _restoreBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList(_bookmarksKey) ?? [];
    for (final f in _index.getAll()) {
      if (ids.contains(f.id)) {
        f.isBookmarked = true;
      }
    }
  }

  Future<void> _saveBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = _index
        .getAll()
        .where((f) => f.isBookmarked)
        .map((f) => f.id)
        .toList();
    await prefs.setStringList(_bookmarksKey, ids);
  }

  List<SearchResult> search(FatwaSearchQuery query) {
    final results = _index.search(query.query,
        category: query.category, maxResults: query.maxResults);
    return results
        .where((r) => r.similarityScore >= query.minSimilarity)
        .toList();
  }

  List<FatwaModel> getAll() => _index.getAll();

  FatwaModel? getById(String id) => _index.getById(id);

  Future<void> toggleBookmark(String id) async {
    final fatwa = getById(id);
    if (fatwa != null) {
      fatwa.isBookmarked = !fatwa.isBookmarked;
      await _saveBookmarks();
    }
  }

  Future<bool> isBookmarked(String id) async {
    final fatwa = getById(id);
    return fatwa?.isBookmarked ?? false;
  }

  List<FatwaModel> getByCategory(String category) =>
      _index.getByCategory(category);

  List<String> getCategories() => _index.getCategories().toList()..sort();

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_bookmarksKey);
    await prefs.remove(_historyKey);
  }

  Future<List<String>> getRecentSearches({int limit = 10}) async {
    final prefs = await SharedPreferences.getInstance();
    final searches = prefs.getStringList(_historyKey) ?? [];
    return searches.take(limit).toList();
  }

  Future<void> addSearchHistory(String query) async {
    final prefs = await SharedPreferences.getInstance();
    final searches = prefs.getStringList(_historyKey) ?? [];
    searches.remove(query);
    searches.insert(0, query);
    if (searches.length > 50) searches.removeLast();
    await prefs.setStringList(_historyKey, searches);
  }

  Future<void> clearSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }

  List<FatwaModel> getRelated(String fatwaId, {int limit = 5}) {
    final fatwa = getById(fatwaId);
    if (fatwa == null) return [];
    return _index.getRelated(fatwa, limit: limit);
  }

  FatwaModel? getRandom() {
    final all = _index.getAll();
    if (all.isEmpty) return null;
    return all[DateTime.now().millisecondsSinceEpoch % all.length];
  }

  List<String> suggest(String prefix) => _index.suggest(prefix);
}

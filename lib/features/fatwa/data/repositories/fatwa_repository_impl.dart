import '../../domain/entities/fatwa_entity.dart';
import '../../domain/repositories/fatwa_repository.dart';
import '../datasources/fatwa_local_datasource.dart';

class FatwaRepositoryImpl implements FatwaRepository {
  final FatwaLocalDataSource _local;

  FatwaRepositoryImpl({required this._local});

  @override
  Future<void> init() async {
    await _local.init();
  }

  @override
  Future<List<SearchResult>> search(FatwaSearchQuery query) async {
    await _local.addSearchHistory(query.query);
    return Future.value(_local.search(query));
  }

  @override
  Future<List<FatwaEntity>> getBookmarked() async {
    return _local
        .getAll()
        .where((m) => m.isBookmarked)
        .map((m) => m.toEntity())
        .toList();
  }

  @override
  Future<void> toggleBookmark(String id) async {
    await _local.toggleBookmark(id);
  }

  @override
  Future<bool> isBookmarked(String id) async {
    return _local.isBookmarked(id);
  }

  @override
  Future<List<FatwaEntity>> getByCategory(String category) async {
    return _local.getByCategory(category).map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<FatwaEntity>> getCommonQuestions() async {
    return _local.getAll().map((m) => m.toEntity()).toList();
  }

  @override
  Future<FatwaEntity?> getById(String id) async {
    final model = _local.getById(id);
    return model?.toEntity();
  }

  @override
  Future<void> clearAll() async {
    await _local.clearAll();
  }

  @override
  Future<List<String>> getCategories() async {
    return _local.getCategories();
  }

  @override
  Future<List<String>> getRecentSearches({int limit = 10}) async {
    return _local.getRecentSearches(limit: limit);
  }

  @override
  Future<void> clearSearchHistory() async {
    await _local.clearSearchHistory();
  }

  @override
  Future<List<FatwaEntity>> getRelated(String fatwaId, {int limit = 5}) async {
    return _local
        .getRelated(fatwaId, limit: limit)
        .map((m) => m.toEntity())
        .toList();
  }

  @override
  Future<List<String>> getSuggestions(String prefix) async {
    return _local.suggest(prefix);
  }

  @override
  Future<FatwaEntity> getRandom() async {
    final model = _local.getRandom();
    if (model == null) throw Exception('لا توجد فتاوى متاحة');
    return model.toEntity();
  }
}

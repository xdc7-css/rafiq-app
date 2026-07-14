import '../entities/fatwa_entity.dart';

class SearchResult {
  final FatwaEntity fatwa;
  final double similarityScore;
  final bool isFromLocal;

  const SearchResult({
    required this.fatwa,
    required this.similarityScore,
    this.isFromLocal = true,
  });
}

class FatwaSearchQuery {
  final String query;
  final String? category;
  final bool semantic;
  final double minSimilarity;
  final int maxResults;

  const FatwaSearchQuery({
    required this.query,
    this.category,
    this.semantic = true,
    this.minSimilarity = 0.3,
    this.maxResults = 20,
  });
}

abstract class FatwaRepository {
  Future<List<SearchResult>> search(FatwaSearchQuery query);
  Future<void> init();
  Future<List<FatwaEntity>> getBookmarked();
  Future<void> toggleBookmark(String id);
  Future<bool> isBookmarked(String id);
  Future<List<FatwaEntity>> getByCategory(String category);
  Future<List<FatwaEntity>> getCommonQuestions();
  Future<FatwaEntity?> getById(String id);
  Future<void> clearAll();
  Future<List<String>> getCategories();
  Future<List<String>> getRecentSearches({int limit});
  Future<void> clearSearchHistory();
  Future<List<FatwaEntity>> getRelated(String fatwaId, {int limit});
  Future<List<String>> getSuggestions(String prefix);
  Future<FatwaEntity> getRandom();
}

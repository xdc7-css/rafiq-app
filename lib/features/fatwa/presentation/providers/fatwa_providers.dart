import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/fatwa_local_datasource.dart';
import '../../data/repositories/fatwa_repository_impl.dart';
import '../../domain/entities/fatwa_entity.dart';
import '../../domain/repositories/fatwa_repository.dart';

final fatwaLocalDataSourceProvider = Provider<FatwaLocalDataSource>((ref) {
  final ds = FatwaLocalDataSource();
  ds.init();
  return ds;
});

final fatwaRepositoryProvider = Provider<FatwaRepository>((ref) {
  final local = ref.watch(fatwaLocalDataSourceProvider);
  return FatwaRepositoryImpl(local: local);
});

class FatwaSearchState {
  final bool isLoading;
  final String query;
  final List<SearchResult> results;
  final String? error;

  const FatwaSearchState({
    this.isLoading = false,
    this.query = '',
    this.results = const [],
    this.error,
  });

  FatwaSearchState copyWith({
    bool? isLoading,
    String? query,
    List<SearchResult>? results,
    String? error,
  }) {
    return FatwaSearchState(
      isLoading: isLoading ?? this.isLoading,
      query: query ?? this.query,
      results: results ?? this.results,
      error: error,
    );
  }
}

class FatwaSearchNotifier extends StateNotifier<FatwaSearchState> {
  final FatwaRepository _repository;

  FatwaSearchNotifier(this._repository) : super(const FatwaSearchState());

  Future<void> search(String query, {String? category}) async {
    if (query.trim().isEmpty && category == null) return;

    state = state.copyWith(isLoading: true, query: query, error: null);

    try {
      final results = await _repository.search(
        FatwaSearchQuery(query: query, category: category),
      );
      state = state.copyWith(
        isLoading: false,
        results: results,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'حدث خطأ أثناء البحث: ${e.toString()}',
      );
    }
  }

  void clear() {
    state = const FatwaSearchState();
  }
}

final fatwaSearchProvider =
    StateNotifierProvider<FatwaSearchNotifier, FatwaSearchState>((ref) {
  final repo = ref.watch(fatwaRepositoryProvider);
  return FatwaSearchNotifier(repo);
});

final bookmarkedFatwasProvider = FutureProvider<List<FatwaEntity>>((ref) async {
  final repo = ref.watch(fatwaRepositoryProvider);
  return repo.getBookmarked();
});

final recentSearchesProvider = FutureProvider<List<String>>((ref) async {
  final repo = ref.watch(fatwaRepositoryProvider);
  return repo.getRecentSearches();
});

final fatwaCategoriesProvider = FutureProvider<List<String>>((ref) async {
  final repo = ref.watch(fatwaRepositoryProvider);
  return repo.getCategories();
});

final fatwaByCategoryProvider =
    FutureProvider.family<List<FatwaEntity>, String>((ref, category) async {
  final repo = ref.watch(fatwaRepositoryProvider);
  return repo.getByCategory(category);
});

final isFatwaBookmarkedProvider =
    FutureProvider.family<bool, String>((ref, id) async {
  final repo = ref.watch(fatwaRepositoryProvider);
  return repo.isBookmarked(id);
});

final refreshBookmarkedProvider = Provider<void>((ref) {
  ref.invalidate(bookmarkedFatwasProvider);
});

final relatedFatwasProvider =
    FutureProvider.family<List<FatwaEntity>, String>((ref, fatwaId) async {
  final repo = ref.watch(fatwaRepositoryProvider);
  return repo.getRelated(fatwaId);
});

final fatwaSuggestionsProvider =
    FutureProvider.family<List<String>, String>((ref, prefix) async {
  if (prefix.trim().isEmpty) return [];
  final repo = ref.watch(fatwaRepositoryProvider);
  return repo.getSuggestions(prefix);
});

final randomFatwaProvider = FutureProvider<FatwaEntity?>((ref) async {
  final repo = ref.watch(fatwaRepositoryProvider);
  try {
    return await repo.getRandom();
  } catch (_) {
    return null;
  }
});

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:daily_islamic_widget/database/local_database.dart';
import 'package:daily_islamic_widget/core/result.dart';
import '../data/models/memorial.dart';
import '../data/models/reward.dart';
import '../data/datasources/memorial_local_datasource.dart';
import '../data/datasources/memorial_remote_datasource.dart';
import '../data/datasources/memorial_memory_cache.dart';
import '../data/datasources/firebase_auth_datasource.dart';
import '../data/repositories/memorial_repository.dart';

// ── Infrastructure providers ────────────────────────────────────────────

final memorialMemoryCacheProvider = Provider<MemorialMemoryCache>((ref) {
  return MemorialMemoryCache();
});

final firebaseAuthProvider = Provider<FirebaseAnonymousAuthDataSource>((ref) {
  return FirebaseAnonymousAuthDataSource();
});

final memorialRemoteDataSourceProvider =
    Provider<MemorialRemoteDataSource>((ref) {
  return MemorialRemoteDataSource();
});

final memorialLocalDataSourceProvider = Provider<MemorialLocalDataSource>((ref) {
  final db = LocalDatabaseService.instance;
  return MemorialLocalDataSource(db);
});

final memorialRepositoryProvider = FutureProvider<MemorialRepository>((ref) async {
  final local = ref.watch(memorialLocalDataSourceProvider);
  final remote = ref.watch(memorialRemoteDataSourceProvider);
  final auth = ref.watch(firebaseAuthProvider);
  final cache = ref.watch(memorialMemoryCacheProvider);
  return MemorialRepositoryImpl(
    local: local,
    remote: remote,
    auth: auth,
    cache: cache,
  );
});

// ── Legacy providers (UI-compatible API) ────────────────────────────────

class MemorialsNotifier extends StateNotifier<List<Memorial>> {
  final MemorialRepository _repository;
  StreamSubscription<List<Memorial>>? _subscription;
  final Map<String, DateTime> _optimisticUpdates = {};

  MemorialsNotifier(this._repository) : super(const []) {
    _init();
  }

  void _init() {
    _subscription = _repository.watchMemorials().listen(
      (memorials) {
        if (!mounted) return;
        state = _mergeWithOptimistic(memorials);
      },
      onError: (_) {
        _loadFallback();
      },
    );
    _loadFallback();
  }

  List<Memorial> _mergeWithOptimistic(List<Memorial> incoming) {
    if (_optimisticUpdates.isEmpty) return incoming;
    final currentMap = {for (final m in state) m.id: m};
    return [
      for (final m in incoming)
        if (_optimisticUpdates.containsKey(m.id) &&
            (currentMap[m.id]?.updatedAt.isAfter(m.updatedAt) ?? false))
          currentMap[m.id]!
        else
          m,
    ];
  }

  Future<void> _loadFallback() async {
    if (state.isNotEmpty) return;
    final result = await _repository.getMemorials();
    if (mounted && state.isEmpty) {
      state = result.dataOrNull ?? const [];
    }
  }

  Future<void> addMemorial(Memorial memorial) async {
    await _repository.createMemorial(memorial);
  }

  Future<void> updateMemorial(Memorial memorial) async {
    await _repository.updateMemorial(memorial);
  }

  Future<void> deleteMemorial(String id) async {
    await _repository.deleteMemorial(id);
  }

  Future<void> refresh() async {}

  void updateSingleMemorial(Memorial memorial) {
    if (!mounted) return;
    _optimisticUpdates[memorial.id] = DateTime.now();
    state = [
      for (final m in state)
        if (m.id == memorial.id) memorial else m,
    ];
  }

  void clearOptimistic(String memorialId) {
    _optimisticUpdates.remove(memorialId);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

final memorialsProvider =
    StateNotifierProvider<MemorialsNotifier, List<Memorial>>((ref) {
  final repoAsync = ref.watch(memorialRepositoryProvider);
  return repoAsync.when(
    data: (repo) => MemorialsNotifier(repo),
    loading: () => MemorialsNotifier(_PlaceholderRepository()),
    error: (_, __) => MemorialsNotifier(_PlaceholderRepository()),
  );
});

class RewardsNotifier extends StateNotifier<List<Reward>> {
  final MemorialRepository _repository;
  final String memorialId;

  RewardsNotifier(this._repository, this.memorialId) : super(const []) {
    _load();
  }

  Future<void> _load() async {
    final result = await _repository.getRewards(memorialId);
    if (mounted) state = result.dataOrNull ?? const [];
  }

  Future<void> addReward(Reward reward) async {
    await _repository.addReward(reward);
    await _load();
  }

  Future<void> refresh() => _load();
}

final rewardsFamilyProvider = StateNotifierProvider.autoDispose
    .family<RewardsNotifier, List<Reward>, String>((ref, memorialId) {
  final repo = ref.watch(memorialRepositoryProvider);
  return repo.when(
    data: (repository) => RewardsNotifier(repository, memorialId),
    loading: () => RewardsNotifier(_PlaceholderRepository(), memorialId),
    error: (_, __) => RewardsNotifier(_PlaceholderRepository(), memorialId),
  );
});

final totalPrayerCountProvider =
    FutureProvider.autoDispose.family<int, String>((ref, memorialId) async {
  final repoAsync = await ref.watch(memorialRepositoryProvider.future);
  final result = await repoAsync.getTotalPrayerCount(memorialId);
  return result.dataOrNull ?? 0;
});

// ── New stream-based providers ──────────────────────────────────────────

final memorialsStreamProvider =
    StreamProvider.autoDispose<List<Memorial>>((ref) async* {
  final repoAsync = await ref.watch(memorialRepositoryProvider.future);
  yield* repoAsync.watchMemorials();
});

final rewardsStreamProvider =
    StreamProvider.autoDispose.family<List<Reward>, String>((ref, memorialId) async* {
  final repoAsync = await ref.watch(memorialRepositoryProvider.future);
  yield* repoAsync.watchRewards(memorialId);
});

// ── Auth state provider ─────────────────────────────────────────────────

final authStateProvider = StreamProvider.autoDispose<String?>((ref) async* {
  final auth = ref.watch(firebaseAuthProvider);
  yield* auth.authStateChanges;
});

final currentUserIdProvider = Provider<String?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.valueOrNull;
});

// ── Placeholder ─────────────────────────────────────────────────────────

class _PlaceholderRepository implements MemorialRepository {
  @override
  Future<Result<List<Memorial>>> getMemorials({String? userId, int limit = 20, int offset = 0}) async =>
      const Result.success([]);
  @override
  Stream<List<Memorial>> watchMemorials({String? userId}) => const Stream.empty();
  @override
  Future<Result<Memorial?>> getMemorialById(String id) async => const Result.success(null);
  @override
  Future<Result<void>> createMemorial(Memorial memorial) async => const Result.success(null);
  @override
  Future<Result<void>> updateMemorial(Memorial memorial) async => const Result.success(null);
  @override
  Future<Result<void>> deleteMemorial(String id) async => const Result.success(null);
  @override
  Future<Result<List<Reward>>> getRewards(String memorialId, {int limit = 50}) async =>
      const Result.success([]);
  @override
  Stream<List<Reward>> watchRewards(String memorialId, {int limit = 50}) => const Stream.empty();
  @override
  Future<Result<void>> addReward(Reward reward) async => const Result.success(null);
  @override
  Future<Result<int>> getTotalPrayerCount(String memorialId) async => const Result.success(0);
  @override
  Future<Result<PaginatedResult<Memorial>>> getMemorialsPaginated({
    String? userId,
    int pageSize = 20,
    int offset = 0,
  }) async =>
      const Result.success(PaginatedResult(items: [], hasMore: false, totalFetched: 0));
  @override
  Future<Result<List<Memorial>>> searchByName(String query, {String? userId}) async =>
      const Result.success([]);
  @override
  String? get currentUserId => null;
}

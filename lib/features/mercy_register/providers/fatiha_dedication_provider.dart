import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:daily_islamic_widget/core/result.dart';
import '../data/models/memorial.dart';
import '../data/models/reward.dart';
import '../data/repositories/memorial_repository.dart';
import '../providers/mercy_register_providers.dart';

/// Tracks whether the Fatiha dedication reward has been submitted
/// for a specific memorialId from the Mushaf screen.
class FatihaDedicationState {
  final bool isSubmitting;
  final bool isCompleted;

  const FatihaDedicationState({
    this.isSubmitting = false,
    this.isCompleted = false,
  });

  FatihaDedicationState copyWith({bool? isSubmitting, bool? isCompleted}) {
    return FatihaDedicationState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class FatihaDedicationNotifier extends StateNotifier<FatihaDedicationState> {
  final MemorialRepository _repo;
  final String memorialId;

  FatihaDedicationNotifier(this._repo, this.memorialId)
      : super(const FatihaDedicationState());

  Future<bool> submit() async {
    if (state.isSubmitting || state.isCompleted) return false;
    state = state.copyWith(isSubmitting: true);

    try {
      final reward = Reward.create(
        memorialId: memorialId,
        type: RewardType.quranKhatmah,
      );
      final result = await _repo.addReward(reward);
      if (result.isSuccess) {
        state = state.copyWith(isSubmitting: false, isCompleted: true);
        return true;
      }
      state = state.copyWith(isSubmitting: false);
      return false;
    } catch (_) {
      state = state.copyWith(isSubmitting: false);
      return false;
    }
  }
}

final fatihaDedicationProvider = StateNotifierProvider.autoDispose
    .family<FatihaDedicationNotifier, FatihaDedicationState, String>(
        (ref, memorialId) {
  final repo = ref.watch(memorialRepositoryProvider);
  return repo.when(
    data: (repository) => FatihaDedicationNotifier(repository, memorialId),
    loading: () => FatihaDedicationNotifier(_StubRepository(), memorialId),
    error: (_, __) => FatihaDedicationNotifier(_StubRepository(), memorialId),
  );
});

class _StubRepository implements MemorialRepository {
  @override Future<Result<List<Memorial>>> getMemorials({String? userId, int limit = 20, int offset = 0}) async => const Result.success([]);
  @override Stream<List<Memorial>> watchMemorials({String? userId}) => const Stream.empty();
  @override Future<Result<Memorial?>> getMemorialById(String id) async => const Result.success(null);
  @override Future<Result<void>> createMemorial(Memorial memorial) async => const Result.success(null);
  @override Future<Result<void>> updateMemorial(Memorial memorial) async => const Result.success(null);
  @override Future<Result<void>> deleteMemorial(String id) async => const Result.success(null);
  @override Future<Result<List<Reward>>> getRewards(String memorialId, {int limit = 50}) async => const Result.success([]);
  @override Stream<List<Reward>> watchRewards(String memorialId, {int limit = 50}) => const Stream.empty();
  @override Future<Result<void>> addReward(Reward reward) async => const Result.success(null);
  @override Future<Result<int>> getTotalPrayerCount(String memorialId) async => const Result.success(0);
  @override Future<Result<PaginatedResult<Memorial>>> getMemorialsPaginated({String? userId, int pageSize = 20, int offset = 0}) async => const Result.success(PaginatedResult(items: [], hasMore: false, totalFetched: 0));
  @override Future<Result<List<Memorial>>> searchByName(String query, {String? userId}) async => const Result.success([]);
  @override String? get currentUserId => null;
}

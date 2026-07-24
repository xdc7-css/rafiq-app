import '../models/memorial.dart';
import '../models/reward.dart';

class MemorialMemoryCache {
  final Map<String, Memorial> _memorialsById = {};
  final List<Memorial> _memorialsList = [];
  final Map<String, List<Reward>> _rewardsByMemorialId = {};
  DateTime? _lastFetchTime;
  bool _isStale = true;

  bool get isStale =>
      _isStale || _lastFetchTime == null || DateTime.now().difference(_lastFetchTime!).inMinutes > 5;

  List<Memorial> get memorials => List.unmodifiable(_memorialsList);

  Memorial? getById(String id) => _memorialsById[id];

  bool contains(String id) => _memorialsById.containsKey(id);

  // ── Memorials ───────────────────────────────────────────────────────

  void updateAllMemorials(List<Memorial> memorials) {
    _memorialsList
      ..clear()
      ..addAll(memorials);
    _memorialsById
      ..clear()
      ..addEntries(memorials.map((m) => MapEntry(m.id, m)));
    _lastFetchTime = DateTime.now();
    _isStale = false;
  }

  void addMemorial(Memorial memorial) {
    _memorialsList.insert(0, memorial);
    _memorialsById[memorial.id] = memorial;
  }

  void updateMemorial(Memorial memorial) {
    final idx = _memorialsList.indexWhere((m) => m.id == memorial.id);
    if (idx != -1) _memorialsList[idx] = memorial;
    _memorialsById[memorial.id] = memorial;
  }

  void removeMemorial(String id) {
    _memorialsList.removeWhere((m) => m.id == id);
    _memorialsById.remove(id);
    _rewardsByMemorialId.remove(id);
  }

  void updatePrayerCount(String memorialId, int newCount) {
    final memorial = _memorialsById[memorialId];
    if (memorial != null) {
      final updated = memorial.copyWith(
        prayerCount: newCount,
        updatedAt: DateTime.now(),
      );
      updateMemorial(updated);
    }
  }

  // ── Rewards ─────────────────────────────────────────────────────────

  List<Reward> getRewards(String memorialId) {
    return List.unmodifiable(_rewardsByMemorialId[memorialId] ?? []);
  }

  void updateRewards(String memorialId, List<Reward> rewards) {
    _rewardsByMemorialId[memorialId] = List.of(rewards);
  }

  void addReward(Reward reward) {
    _rewardsByMemorialId.putIfAbsent(reward.memorialId, () => []);
    _rewardsByMemorialId[reward.memorialId]!.insert(0, reward);
  }

  void incrementMemorialCounters(String memorialId, RewardType type, {int points = 1}) {
    final memorial = _memorialsById[memorialId];
    if (memorial == null) return;
    Memorial updated;
    switch (type) {
      case RewardType.dua:
        updated = memorial.copyWith(duaCount: memorial.duaCount + 1, updatedAt: DateTime.now());
      case RewardType.quranKhatmah:
        updated = memorial.copyWith(khatmahCount: memorial.khatmahCount + 1, updatedAt: DateTime.now());
      case RewardType.tasbeeh:
        updated = memorial.copyWith(tasbeehCount: memorial.tasbeehCount + 1, updatedAt: DateTime.now());
      case RewardType.prayer:
      case RewardType.surahRecitation:
      case RewardType.charity:
        updated = memorial.copyWith(prayerCount: memorial.prayerCount + points, updatedAt: DateTime.now());
    }
    updateMemorial(updated);
  }

  // ── Lifecycle ───────────────────────────────────────────────────────

  void invalidate() {
    _isStale = true;
  }

  void clear() {
    _memorialsList.clear();
    _memorialsById.clear();
    _rewardsByMemorialId.clear();
    _lastFetchTime = null;
    _isStale = true;
  }
}

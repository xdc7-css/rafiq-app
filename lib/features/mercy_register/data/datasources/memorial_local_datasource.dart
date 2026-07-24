import 'package:flutter/foundation.dart';
import 'package:daily_islamic_widget/database/local_database.dart';
import '../models/memorial.dart';
import '../models/reward.dart';

class MemorialLocalDataSource {
  final LocalDatabaseService _db;

  MemorialLocalDataSource(this._db);

  // ── Memorials ───────────────────────────────────────────────────────

  Future<List<Memorial>> getMemorials({String? userId, int limit = 20, int offset = 0}) async {
    final entries = await _db.getMemorials(userId: userId, limit: limit, offset: offset);
    return entries.map(_entryToMemorial).toList();
  }

  Stream<List<Memorial>> watchMemorials({String? userId}) {
    return _db.watchMemorials(userId: userId).map(
          (entries) => entries.map(_entryToMemorial).toList(),
        );
  }

  Future<Memorial?> getMemorialById(String id) async {
    final entry = await _db.getMemorialById(id);
    if (entry == null) return null;
    return _entryToMemorial(entry);
  }

  Future<void> createMemorial(Memorial memorial) async {
    debugPrint('[MemorialLocalDataSource] createMemorial starting for id="${memorial.id}"');
    try {
      final entry = _memorialToEntry(memorial);
      debugPrint('[MemorialLocalDataSource] Converted to entry: memorialId="${entry.memorialId}"');
      await _db.putMemorial(entry);
      debugPrint('[MemorialLocalDataSource] _db.putMemorial finished successfully');
    } catch (e, st) {
      debugPrint('[MemorialLocalDataSource] EXCEPTION in createMemorial: $e');
      debugPrint('[MemorialLocalDataSource] Stack trace:\n$st');
      rethrow;
    }
  }

  Future<void> updateMemorial(Memorial memorial) async {
    await _db.putMemorial(_memorialToEntry(memorial));
  }

  Future<void> deleteMemorial(String id) async {
    await _db.deleteMemorialById(id);
  }

  // ── Rewards ─────────────────────────────────────────────────────────

  Future<List<Reward>> getRewards(String memorialId, {int limit = 50}) async {
    final entries = await _db.getRewardsByMemorialId(memorialId, limit: limit);
    return entries.map(_rewardEntryToReward).toList();
  }

  Future<void> addReward(Reward reward) async {
    await _db.putReward(_rewardToEntry(reward));
    final memorial = await _db.getMemorialById(reward.memorialId);
    if (memorial != null) {
      switch (reward.type) {
        case RewardType.dua:
          memorial.duaCount += 1;
          break;
        case RewardType.quranKhatmah:
          memorial.khatmahCount += 1;
          break;
        case RewardType.tasbeeh:
          memorial.tasbeehCount += 1;
          break;
        case RewardType.prayer:
        case RewardType.surahRecitation:
        case RewardType.charity:
          memorial.prayerCount += reward.points;
          break;
      }
      memorial.updatedAtMs = DateTime.now().millisecondsSinceEpoch;
      await _db.putMemorial(memorial);
    }
  }

  Future<int> getTotalPrayerCount(String memorialId) async {
    final memorial = await _db.getMemorialById(memorialId);
    return memorial?.prayerCount ?? 0;
  }

  // ── Conversion helpers ──────────────────────────────────────────────

  Memorial _entryToMemorial(MemorialEntry e) => Memorial(
        id: e.memorialId,
        deceasedName: e.deceasedName,
        deceasedNameArabic: e.deceasedNameArabic.isEmpty ? null : e.deceasedNameArabic,
        dateOfDeath: DateTime.fromMillisecondsSinceEpoch(e.dateOfDeathMs),
        description: e.description.isEmpty ? null : e.description,
        prayerCount: e.prayerCount,
        duaCount: e.duaCount,
        khatmahCount: e.khatmahCount,
        tasbeehCount: e.tasbeehCount,
        createdAt: DateTime.fromMillisecondsSinceEpoch(e.createdAtMs),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(e.updatedAtMs),
        userId: e.userId.isEmpty ? null : e.userId,
        isPublic: e.isPublic,
        type: MemorialType.values[e.typeIndex.clamp(0, MemorialType.values.length - 1)],
        surahNumber: e.surahNumber == 0 ? null : e.surahNumber,
        duaText: e.duaText.isEmpty ? null : e.duaText,
        photoUrl: e.photoUrl.isEmpty ? null : e.photoUrl,
        searchName: e.searchName,
        searchNameArabic: e.searchNameArabic.isEmpty ? null : e.searchNameArabic,
      );

  MemorialEntry _memorialToEntry(Memorial m) => MemorialEntry(
        memorialId: m.id,
        deceasedName: m.deceasedName,
        deceasedNameArabic: m.deceasedNameArabic ?? '',
        dateOfDeathMs: m.dateOfDeath.millisecondsSinceEpoch,
        description: m.description ?? '',
        prayerCount: m.prayerCount,
        duaCount: m.duaCount,
        khatmahCount: m.khatmahCount,
        tasbeehCount: m.tasbeehCount,
        createdAtMs: m.createdAt.millisecondsSinceEpoch,
        updatedAtMs: m.updatedAt.millisecondsSinceEpoch,
        userId: m.userId ?? '',
        isPublic: m.isPublic,
        typeIndex: m.type.index,
        surahNumber: m.surahNumber ?? 0,
        duaText: m.duaText ?? '',
        photoUrl: m.photoUrl ?? '',
        searchName: m.searchName,
        searchNameArabic: m.searchNameArabic ?? '',
      );

  Reward _rewardEntryToReward(RewardEntry e) => Reward(
        id: e.rewardId,
        memorialId: e.memorialId,
        userId: e.userId.isEmpty ? null : e.userId,
        type: RewardType.values[e.typeIndex.clamp(0, RewardType.values.length - 1)],
        count: e.count,
        createdAt: DateTime.fromMillisecondsSinceEpoch(e.createdAtMs),
        points: e.points,
        note: e.note.isEmpty ? null : e.note,
      );

  RewardEntry _rewardToEntry(Reward r) => RewardEntry(
        rewardId: r.id,
        memorialId: r.memorialId,
        userId: r.userId ?? '',
        typeIndex: r.type.index,
        count: r.count,
        createdAtMs: r.createdAt.millisecondsSinceEpoch,
        points: r.points,
        note: r.note ?? '',
      );
}

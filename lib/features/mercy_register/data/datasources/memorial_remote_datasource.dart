import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/memorial.dart';
import '../models/reward.dart';

class PaginatedResult<T> {
  final List<T> items;
  final bool hasMore;
  final int totalFetched;

  const PaginatedResult({
    required this.items,
    required this.hasMore,
    required this.totalFetched,
  });
}

class MemorialRemoteDataSource {
  final FirebaseFirestore _firestore;

  MemorialRemoteDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _memorials =>
      _firestore.collection('memorials');

  CollectionReference<Map<String, dynamic>> get _rewards =>
      _firestore.collection('rewards');

  // ── Paginated reads ─────────────────────────────────────────────────

  Future<PaginatedResult<Memorial>> getMemorials({
    String? userId,
    int pageSize = 20,
    int offset = 0,
  }) async {
    Query<Map<String, dynamic>> query =
        _memorials.orderBy('createdAt', descending: true);

    if (userId != null) {
      query = query.where('userId', isEqualTo: userId);
    }

    final snapshot = await query.limit(pageSize + offset).get();
    final allDocs = snapshot.docs;
    final sliced = offset < allDocs.length
        ? allDocs.sublist(offset, (offset + pageSize).clamp(0, allDocs.length))
        : <QueryDocumentSnapshot<Map<String, dynamic>>>[];

    return PaginatedResult(
      items: sliced.map((doc) => Memorial.fromJson(doc.data())).toList(),
      hasMore: allDocs.length > offset + pageSize,
      totalFetched: allDocs.length,
    );
  }

  // ── Search ──────────────────────────────────────────────────────────

  Future<List<Memorial>> searchByName({
    required String query,
    String? userId,
    int limit = 20,
  }) async {
    final normalized = Memorial.normalizeArabic(query);
    if (normalized.isEmpty) return [];

    Query<Map<String, dynamic>> q = _memorials
        .where('searchName', isGreaterThanOrEqualTo: normalized)
        .where('searchName', isLessThanOrEqualTo: '$normalized\uf8ff')
        .orderBy('searchName')
        .orderBy('createdAt', descending: true)
        .limit(limit);

    if (userId != null) {
      q = q.where('userId', isEqualTo: userId);
    }

    final snapshot = await q.get();
    return snapshot.docs
        .map((doc) => Memorial.fromJson(doc.data()))
        .toList();
  }

  // ── Single reads ────────────────────────────────────────────────────

  Future<Memorial?> getMemorialById(String id) async {
    final doc = await _memorials.doc(id).get();
    if (!doc.exists || doc.data() == null) return null;
    return Memorial.fromJson(doc.data()!);
  }

  // ── Writes ──────────────────────────────────────────────────────────

  Map<String, dynamic> _memorialToFirestore(Memorial memorial) {
    final json = memorial.toJson();
    json['createdAt'] = memorial.createdAt.toIso8601String();
    json['updatedAt'] = memorial.updatedAt.toIso8601String();
    return json;
  }

  Future<void> createMemorial(Memorial memorial) async {
    await _memorials.doc(memorial.id).set(_memorialToFirestore(memorial)).timeout(
      const Duration(seconds: 15),
      onTimeout: () => throw FirebaseException(
        plugin: 'cloud_firestore',
        message: 'Firestore write timed out after 15s',
        code: 'timeout',
      ),
    );
  }

  Future<void> updateMemorial(Memorial memorial) async {
    await _memorials.doc(memorial.id).update(_memorialToFirestore(memorial));
  }

  Future<void> deleteMemorial(String id) async {
    await _memorials.doc(id).delete();
    final rewardsSnapshot =
        await _rewards.where('memorialId', isEqualTo: id).get();
    for (final doc in rewardsSnapshot.docs) {
      await doc.reference.delete();
    }
  }

  // ── Rewards ─────────────────────────────────────────────────────────

  Future<List<Reward>> getRewards(String memorialId, {int limit = 50}) async {
    final snapshot = await _rewards
        .where('memorialId', isEqualTo: memorialId)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .get();
    return snapshot.docs
        .map((doc) => Reward.fromJson(doc.data()))
        .toList();
  }

  Future<void> addReward(Reward reward) async {
    await _rewards.doc(reward.id).set(reward.toJson());
    final updates = <String, dynamic>{
      'updatedAt': DateTime.now().toIso8601String(),
    };
    switch (reward.type) {
      case RewardType.dua:
        updates['duaCount'] = FieldValue.increment(1);
        break;
      case RewardType.quranKhatmah:
        updates['khatmahCount'] = FieldValue.increment(1);
        break;
      case RewardType.tasbeeh:
        updates['tasbeehCount'] = FieldValue.increment(1);
        break;
      case RewardType.prayer:
      case RewardType.surahRecitation:
      case RewardType.charity:
        updates['prayerCount'] = FieldValue.increment(reward.points);
        break;
    }
    await _memorials.doc(reward.memorialId).update(updates);
  }

  Future<int> getTotalPrayerCount(String memorialId) async {
    final doc = await _memorials.doc(memorialId).get();
    if (!doc.exists || doc.data() == null) return 0;
    return (doc.data()!['prayerCount'] as num?)?.toInt() ?? 0;
  }

  // ── Streams ─────────────────────────────────────────────────────────

  Stream<List<Memorial>> watchMemorials({String? userId, int limit = 50}) {
    Query<Map<String, dynamic>> query =
        _memorials.orderBy('createdAt', descending: true).limit(limit);
    if (userId != null) {
      query = query.where('userId', isEqualTo: userId);
    }
    return query.snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => Memorial.fromJson(doc.data()))
              .toList(),
        );
  }

  Stream<List<Reward>> watchRewards(String memorialId, {int limit = 50}) {
    return _rewards
        .where('memorialId', isEqualTo: memorialId)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Reward.fromJson(doc.data()))
              .toList(),
        );
  }

  Stream<Memorial?> watchMemorial(String id) {
    return _memorials.doc(id).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) return null;
      return Memorial.fromJson(doc.data()!);
    });
  }
}

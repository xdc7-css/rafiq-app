import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:daily_islamic_widget/core/result.dart';
import '../models/memorial.dart';
import '../models/reward.dart';
import '../datasources/memorial_remote_datasource.dart';
import '../datasources/memorial_local_datasource.dart';
import '../datasources/memorial_memory_cache.dart';
import '../datasources/firebase_auth_datasource.dart';

export '../datasources/memorial_remote_datasource.dart' show PaginatedResult;

abstract class MemorialRepository {
  Future<Result<List<Memorial>>> getMemorials({
    String? userId,
    int limit = 20,
    int offset = 0,
  });
  Stream<List<Memorial>> watchMemorials({String? userId});
  Future<Result<Memorial?>> getMemorialById(String id);
  Future<Result<void>> createMemorial(Memorial memorial);
  Future<Result<void>> updateMemorial(Memorial memorial);
  Future<Result<void>> deleteMemorial(String id);
  Future<Result<List<Reward>>> getRewards(String memorialId, {int limit = 50});
  Stream<List<Reward>> watchRewards(String memorialId, {int limit = 50});
  Future<Result<void>> addReward(Reward reward);
  Future<Result<int>> getTotalPrayerCount(String memorialId);

  Future<Result<PaginatedResult<Memorial>>> getMemorialsPaginated({
    String? userId,
    int pageSize = 20,
    int offset = 0,
  });
  Future<Result<List<Memorial>>> searchByName(String query, {String? userId});
  String? get currentUserId;
}

class MemorialRepositoryImpl implements MemorialRepository {
  final MemorialLocalDataSource _local;
  final MemorialRemoteDataSource? _remote;
  final FirebaseAnonymousAuthDataSource? _auth;
  final MemorialMemoryCache _cache;

  MemorialRepositoryImpl({
    required this._local,
    this._remote,
    this._auth,
    MemorialMemoryCache? cache,
  }) : _cache = cache ?? MemorialMemoryCache();

  @override
  String? get currentUserId => _auth?.currentUserId;

  /// Ensures the user is authenticated before any Firestore write.
  /// Calls [signInAnonymously] if no user is currently signed in.
  Future<void> _ensureAuthenticated() async {
    if (_auth != null && !_auth.isAuthenticated) {
      _log('_ensureAuthenticated: not authenticated, signing in...');
      final uid = await _auth.signInAnonymously();
      _log('_ensureAuthenticated: signed in as uid=$uid');
    } else {
      _log('_ensureAuthenticated: already authenticated as ${_auth?.currentUserId}');
    }
  }

  // ── Reads ───────────────────────────────────────────────────────────

  @override
  Future<Result<List<Memorial>>> getMemorials({
    String? userId,
    int limit = 20,
    int offset = 0,
  }) async {
    final uid = userId ?? currentUserId;
    try {
      if (_remote != null) {
        final remoteResult =
            await _remote.getMemorials(userId: uid, pageSize: limit, offset: offset);
        _cache.updateAllMemorials(remoteResult.items);
        return Result.success(remoteResult.items);
      }
    } on FirebaseException catch (e) {
      // fall through to local
      _log('Remote getMemorials failed: ${e.message}');
    } catch (e) {
      _log('Remote getMemorials failed: $e');
    }

    try {
      final localList =
          await _local.getMemorials(userId: uid, limit: limit, offset: offset);
      _cache.updateAllMemorials(localList);
      return Result.success(localList);
    } catch (e) {
      return const Result.failure(MemorialCacheFailure());
    }
  }

  @override
  Future<Result<Memorial?>> getMemorialById(String id) async {
    final cached = _cache.getById(id);
    if (cached != null) return Result.success(cached);

    try {
      if (_remote != null) {
        final remote = await _remote.getMemorialById(id);
        if (remote != null) return Result.success(remote);
      }
    } catch (_) {}

    try {
      final local = await _local.getMemorialById(id);
      return Result.success(local);
    } catch (e) {
      return const Result.failure(MemorialCacheFailure());
    }
  }

  // ── Writes ──────────────────────────────────────────────────────────

  @override
  Future<Result<void>> createMemorial(Memorial memorial) async {
    _log('createMemorial: id=${memorial.id}, name=${memorial.deceasedName}, userId=${memorial.userId}');
    try {
      _log('createMemorial: local save starting...');
      await _local.createMemorial(memorial);
      _log('createMemorial: local save succeeded');
      _cache.addMemorial(memorial);
      _log('createMemorial: cache updated');
    } catch (e, st) {
      _log('createMemorial: LOCAL SAVE FAILED: $e');
      _log('createMemorial: stack: $st');
      debugPrint('[MemorialRepository] Returning Result.failure(MemorialCacheFailure()) due to caught exception: $e');
      return const Result.failure(MemorialCacheFailure());
    }

    if (_remote != null) {
      try {
        _log('createMemorial: ensuring authentication...');
        await _ensureAuthenticated();
        _log('createMemorial: authenticated. userId=${_auth?.currentUserId}');
        _log('createMemorial: Firestore write starting...');
        await _remote.createMemorial(memorial);
        _log('createMemorial: Firestore write succeeded');
      } catch (e) {
        _log('createMemorial: Remote createMemorial failed: $e');
      }
    } else {
      _log('createMemorial: remote is null, skipping Firestore');
    }
    _log('createMemorial: returning Result.success');
    return const Result.success(null);
  }

  @override
  Future<Result<void>> updateMemorial(Memorial memorial) async {
    final updated = memorial.copyWith(updatedAt: DateTime.now());
    try {
      await _local.updateMemorial(updated);
      _cache.updateMemorial(updated);
    } catch (e) {
      return const Result.failure(MemorialCacheFailure());
    }

    if (_remote != null) {
      try {
        await _ensureAuthenticated();
        await _remote.updateMemorial(updated);
      } catch (e) {
        _log('Remote updateMemorial failed: $e');
      }
    }
    return const Result.success(null);
  }

  @override
  Future<Result<void>> deleteMemorial(String id) async {
    try {
      await _local.deleteMemorial(id);
      _cache.removeMemorial(id);
    } catch (e) {
      return const Result.failure(MemorialCacheFailure());
    }

    if (_remote != null) {
      try {
        await _ensureAuthenticated();
        await _remote.deleteMemorial(id);
      } catch (e) {
        _log('Remote deleteMemorial failed: $e');
      }
    }
    return const Result.success(null);
  }

  // ── Rewards ─────────────────────────────────────────────────────────

  @override
  Future<Result<List<Reward>>> getRewards(String memorialId, {int limit = 50}) async {
    final cached = _cache.getRewards(memorialId);
    if (cached.isNotEmpty) return Result.success(cached);

    try {
      if (_remote != null) {
        final rewards = await _remote.getRewards(memorialId, limit: limit);
        _cache.updateRewards(memorialId, rewards);
        return Result.success(rewards);
      }
    } catch (_) {}

    try {
      final local = await _local.getRewards(memorialId, limit: limit);
      _cache.updateRewards(memorialId, local);
      return Result.success(local);
    } catch (e) {
      return const Result.failure(MemorialCacheFailure());
    }
  }

  @override
  Future<Result<void>> addReward(Reward reward) async {
    try {
      await _local.addReward(reward);
      _cache.addReward(reward);
      if (!_cache.contains(reward.memorialId)) {
        final local = await _local.getMemorialById(reward.memorialId);
        if (local != null) _cache.updateMemorial(local);
      }
      _cache.incrementMemorialCounters(reward.memorialId, reward.type, points: reward.points);
    } catch (e) {
      return const Result.failure(MemorialCacheFailure());
    }

    if (_remote != null) {
      try {
        await _ensureAuthenticated();
        await _remote.addReward(reward);
      } catch (e) {
        _log('Remote addReward failed: $e');
      }
    }
    return const Result.success(null);
  }

  @override
  Future<Result<int>> getTotalPrayerCount(String memorialId) async {
    try {
      if (_remote != null) {
        return Result.success(await _remote.getTotalPrayerCount(memorialId));
      }
    } catch (_) {}

    try {
      return Result.success(await _local.getTotalPrayerCount(memorialId));
    } catch (e) {
      return const Result.failure(MemorialCacheFailure());
    }
  }

  // ── Streams ─────────────────────────────────────────────────────────

  @override
  Stream<List<Memorial>> watchMemorials({String? userId}) {
    final uid = userId ?? currentUserId;

    if (_remote != null) {
      return _remote.watchMemorials(userId: uid).handleError((error) {
        _log('watchMemorials stream error: $error');
      });
    }

    return _local.watchMemorials(userId: uid);
  }

  @override
  Stream<List<Reward>> watchRewards(String memorialId, {int limit = 50}) {
    if (_remote != null) {
      return _remote.watchRewards(memorialId, limit: limit).handleError((error) {
        _log('watchRewards stream error: $error');
      });
    }

    return const Stream.empty();
  }

  // ── Pagination ──────────────────────────────────────────────────────

  @override
  Future<Result<PaginatedResult<Memorial>>> getMemorialsPaginated({
    String? userId,
    int pageSize = 20,
    int offset = 0,
  }) async {
    try {
      if (_remote != null) {
        final result = await _remote.getMemorials(
          userId: userId ?? currentUserId,
          pageSize: pageSize,
          offset: offset,
        );
        return Result.success(result);
      }
    } catch (_) {}

    try {
      final localList = await _local.getMemorials(
        userId: userId ?? currentUserId,
        limit: pageSize,
        offset: offset,
      );
      return Result.success(PaginatedResult(
        items: localList,
        hasMore: localList.length == pageSize,
        totalFetched: localList.length + offset,
      ));
    } catch (e) {
      return const Result.failure(MemorialCacheFailure());
    }
  }

  // ── Search ──────────────────────────────────────────────────────────

  @override
  Future<Result<List<Memorial>>> searchByName(String query, {String? userId}) async {
    try {
      if (_remote != null) {
        final results = await _remote.searchByName(
          query: query,
          userId: userId ?? currentUserId,
        );
        return Result.success(results);
      }
    } catch (_) {}

    try {
      final localList = await _local.getMemorials(userId: userId);
      final normalizedQuery = Memorial.normalizeArabic(query);
      final filtered = localList.where((m) {
        return m.searchName.contains(normalizedQuery) ||
            (m.searchNameArabic?.contains(normalizedQuery) ?? false);
      }).toList();
      return Result.success(filtered);
    } catch (e) {
      return const Result.failure(MemorialCacheFailure());
    }
  }

  void _log(String message) {
    debugPrint('[AddMemorial][Repo] $message');
  }
}

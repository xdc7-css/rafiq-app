import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../cache/hive_cache_manager.dart';

class ApiCacheService {
  final Map<String, Future<dynamic>> _inflight = {};
  int _activeRequests = 0;
  final int _maxConcurrent;
  final List<_QueuedRequest> _queue = [];

  ApiCacheService({this._maxConcurrent = 3});

  Future<T> fetch<T>(
    String cacheKey, {
    required Future<T> Function() onFetch,
    required T Function(dynamic raw) fromCache,
    required dynamic Function(T data) toCache,
    Duration? ttl,
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh) {
      final cached = HiveCacheManager.getCachedString(cacheKey);
      if (cached != null) {
        try {
          final decoded = json.decode(cached);
          final expiryMs = decoded['expiry'] as int?;
          if (expiryMs != null && DateTime.now().millisecondsSinceEpoch < expiryMs) {
            final raw = decoded['data'];
            debugPrint('[ApiCache] HIT $cacheKey');
            return fromCache(raw);
          }
        } catch (_) {
          await HiveCacheManager.remove(cacheKey);
        }
      }
    }

    if (_inflight.containsKey(cacheKey)) {
      debugPrint('[ApiCache] DEDUP $cacheKey');
      return _inflight[cacheKey]! as Future<T>;
    }

    final completer = Completer<T>();
    _inflight[cacheKey] = completer.future;

    final future = _enqueue(() async {
      try {
        debugPrint('[ApiCache] FETCH $cacheKey');
        final result = await onFetch();
        final ttlDuration = ttl ?? const Duration(hours: 1);
        final encoded = {
          'data': toCache(result),
          'expiry': DateTime.now().add(ttlDuration).millisecondsSinceEpoch,
        };
        await HiveCacheManager.cacheString(cacheKey, json.encode(encoded), ttl: ttlDuration);
        if (!completer.isCompleted) completer.complete(result);
        return result;
      } catch (e) {
        if (!completer.isCompleted) completer.completeError(e);
        rethrow;
      } finally {
        _inflight.remove(cacheKey);
      }
    });

    return future;
  }

  Future<T> _enqueue<T>(Future<T> Function() task) async {
    if (_activeRequests >= _maxConcurrent) {
      final completer = Completer<void>();
      _queue.add(_QueuedRequest(completer));
      await completer.future;
    }

    _activeRequests++;
    try {
      return await task();
    } finally {
      _activeRequests--;
      if (_queue.isNotEmpty) {
        _queue.removeAt(0).completer.complete();
      }
    }
  }

  Future<void> clearAll() async {
    await HiveCacheManager.clearAll();
    _inflight.clear();
  }

  int get pendingRequests => _queue.length;
  int get activeRequests => _activeRequests;
  int get inflightCount => _inflight.length;
}

class _QueuedRequest {
  final Completer<void> completer;
  _QueuedRequest(this.completer);
}

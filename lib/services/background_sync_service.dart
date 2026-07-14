import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'connectivity_service.dart';
import '../database/local_database.dart';

class BackgroundSyncService {
  static final BackgroundSyncService _instance = BackgroundSyncService._();
  factory BackgroundSyncService() => _instance;
  BackgroundSyncService._();

  Timer? _periodicTimer;
  Timer? _connectivityTimer;
  final ConnectivityService _connectivity = ConnectivityService();
  bool _initialized = false;
  bool _syncing = false;

  static const Duration _syncInterval = Duration(hours: 1);
  static const Duration _hadithCacheTTL = Duration(hours: 12);

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    _connectivity.onConnectivityChanged.listen((result) {
      if (result != ConnectivityResult.none) {
        debugPrint('[BackgroundSync] Connectivity restored, triggering sync');
        _triggerSync();
      }
    });

    _periodicTimer = Timer.periodic(_syncInterval, (_) {
      if (_connectivity.isOnline) {
        _triggerSync();
      }
    });

    _cleanupExpiredCache();
  }

  void _triggerSync() {
    if (_syncing) return;
    _syncing = true;
    Future.microtask(() async {
      try {
        await syncPrayerTimesCache();
        await syncShiaHadithCache();
        await _cleanupExpiredCache();
      } catch (e) {
        debugPrint('[BackgroundSync] Sync error: $e');
      } finally {
        _syncing = false;
      }
    });
  }

  Future<void> syncPrayerTimesCache() async {
    if (!_connectivity.isOnline) return;
    try {
      debugPrint('[BackgroundSync] Refreshing prayer times cache');
      // TODO: Implement actual prayer times refresh with AladhanApi
    } catch (e) {
      debugPrint('[BackgroundSync] Prayer times sync failed: $e');
    }
  }

  Future<void> syncShiaHadithCache() async {
    if (!_connectivity.isOnline) return;
    try {
      final cacheKey = 'shia_hadith_daily';
      final db = LocalDatabaseService.instance;
      final cached = await db.getCacheEntry(cacheKey);
      if (cached != null) {
        final age = DateTime.now().difference(cached.expiresAt.add(_hadithCacheTTL));
        if (age < _hadithCacheTTL) return;
      }
      debugPrint('[BackgroundSync] Refreshing Shia hadith cache');
    } catch (e) {
      debugPrint('[BackgroundSync] Shia hadith sync failed: $e');
    }
  }

  Future<void> _cleanupExpiredCache() async {
    try {
      final db = LocalDatabaseService.instance;
      await db.clearExpiredCache();
    } catch (e) {
      debugPrint('[BackgroundSync] Cache cleanup failed: $e');
    }
  }

  void dispose() {
    _periodicTimer?.cancel();
    _connectivityTimer?.cancel();
    _initialized = false;
  }
}

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:audio_service/audio_service.dart';
import 'app.dart';
import 'database/local_database.dart';
import 'database/migration/data_migrator.dart'
    if (dart.library.html) 'database/migration/data_migrator_stub.dart';
import 'services/storage_service.dart';
import 'services/notification_service.dart';
import 'services/home_widget_service.dart';
import 'services/connectivity_service.dart';
import 'services/background_sync_service.dart';
import 'core/cache/hive_cache_manager.dart';
import 'features/quran_audio/services/quran_audio_handler.dart';

late AudioHandler audioService;

void main() async {
  final mainSw = Stopwatch()..start();
  debugPrint('[Startup] ═══════════════════════════════════════');
  debugPrint('[Startup] main() started');

  WidgetsFlutterBinding.ensureInitialized();
  debugPrint('[Startup] WidgetsFlutterBinding: ${mainSw.elapsedMilliseconds} ms');

  if (!kIsWeb) {
    try {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    } catch (e) {
      debugPrint('[Startup] Orientation failed: $e');
    }
  }

  // ═══ CRITICAL: StorageService — the ONLY blocking init ═══
  debugPrint('[Startup] StorageService...');
  try {
    await StorageService.init().timeout(
      const Duration(seconds: 5),
      onTimeout: () => debugPrint('[Startup] ⚠ StorageService.init TIMED OUT (5s)'),
    );
    debugPrint('[Startup] StorageService done: ${mainSw.elapsedMilliseconds} ms');
  } catch (e) {
    debugPrint('[Startup] StorageService FAILED: $e');
  }

  // ═══ Local Database — platform-conditional (Isar on Android, SharedPreferences on Web) ═══
  unawaited(_initLocalDatabase());

  // ═══ Hive — background, non-critical ═══
  unawaited(_initHiveBackground());

  // ═══ RUN APP — first frame renders here ═══
  runApp(
    const ProviderScope(
      child: DailyIslamicWidgetApp(),
    ),
  );
  debugPrint('[Startup] ═══ runApp() at: ${mainSw.elapsedMilliseconds} ms ═══');

  // ═══ NON-CRITICAL: all fire-and-forget after first frame ═══
  unawaited(_safeInit('Notifications', _initNotifications, timeoutMs: 10000));
  unawaited(_safeInit('HomeWidget', _initHomeWidget, timeoutMs: 5000));
  unawaited(_safeInit('AudioService', _initAudioService, timeoutMs: 15000));
  unawaited(_safeInit('Connectivity', _initConnectivity, timeoutMs: 5000));
  if (!kIsWeb) {
    unawaited(_safeInit('BackgroundSync', _initBackgroundSync, timeoutMs: 10000));
  }

  mainSw.stop();
  debugPrint('[Startup] main() finished at: ${mainSw.elapsedMilliseconds} ms');
  debugPrint('[Startup] ═══════════════════════════════════════');
}

// ═══ Background initializers ═══

Future<void> _initLocalDatabase() async {
  final sw = Stopwatch()..start();
  debugPrint('[Startup] LocalDatabase init started (platform: ${kIsWeb ? "web" : "native"})');
  try {
    final db = LocalDatabaseService.instance;
    await db.initialize();
    debugPrint('[Startup] LocalDatabase opened: ${sw.elapsedMilliseconds} ms');
    await DataMigrator.migrateIfNeeded();
    debugPrint('[Startup] Data migration done: ${sw.elapsedMilliseconds} ms');
  } catch (e) {
    debugPrint('[Startup] LocalDatabase FAILED: $e');
  }
}

Future<void> _initHiveBackground() async {
  final sw = Stopwatch()..start();
  debugPrint('[Startup] Hive init started');
  try {
    await Hive.initFlutter();
    await HiveCacheManager.init();
    debugPrint('[Startup] Hive done: ${sw.elapsedMilliseconds} ms');
  } catch (e) {
    debugPrint('[Startup] Hive FAILED: $e');
  }
}

Future<void> _initNotifications() async {
  debugPrint('[Startup] Notifications init started');
  final sw = Stopwatch()..start();
  try {
    await NotificationService.init();
  } catch (e) {
    debugPrint('[Startup] Notifications FAILED: $e');
  }
  debugPrint('[Startup] Notifications done: ${sw.elapsedMilliseconds} ms');
}

Future<void> _initHomeWidget() async {
  debugPrint('[Startup] HomeWidget init started');
  final sw = Stopwatch()..start();
  try {
    await HomeWidgetService.init();
  } catch (e) {
    debugPrint('[Startup] HomeWidget FAILED: $e');
  }
  debugPrint('[Startup] HomeWidget done: ${sw.elapsedMilliseconds} ms');
}

Future<void> _initAudioService() async {
  debugPrint('[Startup] AudioService init started');
  final sw = Stopwatch()..start();
  try {
    if (kIsWeb) {
      audioService = QuranAudioHandler();
    } else {
      audioService = await AudioService.init(
        builder: () => QuranAudioHandler(),
        config: const AudioServiceConfig(
          androidNotificationChannelId: 'com.dailyislamicwidget.quran.audio',
          androidNotificationChannelName: 'تشغيل القرآن',
          androidNotificationChannelDescription: 'تشغيل القرآن الكريم في الخلفية',
          androidNotificationOngoing: true,
          androidStopForegroundOnPause: true,
          androidNotificationIcon: 'mipmap/ic_launcher',
          artDownscaleWidth: 300,
          artDownscaleHeight: 300,
        ),
      );
    }
  } catch (e) {
    debugPrint('[Startup] AudioService FAILED: $e');
    try {
      audioService = QuranAudioHandler();
    } catch (_) {}
  }
  debugPrint('[Startup] AudioService done: ${sw.elapsedMilliseconds} ms');
}

Future<void> _initConnectivity() async {
  debugPrint('[Startup] Connectivity init started');
  final sw = Stopwatch()..start();
  try {
    await ConnectivityService().init();
  } catch (e) {
    debugPrint('[Startup] Connectivity FAILED: $e');
  }
  debugPrint('[Startup] Connectivity done: ${sw.elapsedMilliseconds} ms');
}

Future<void> _initBackgroundSync() async {
  debugPrint('[Startup] BackgroundSync init started');
  final sw = Stopwatch()..start();
  try {
    await BackgroundSyncService().init();
  } catch (e) {
    debugPrint('[Startup] BackgroundSync FAILED: $e');
  }
  debugPrint('[Startup] BackgroundSync done: ${sw.elapsedMilliseconds} ms');
}

// ═══ Timeout wrapper ═══

Future<void> _safeInit(
  String name,
  Future<void> Function() fn, {
  required int timeoutMs,
}) async {
  final sw = Stopwatch()..start();
  try {
    await fn().timeout(Duration(milliseconds: timeoutMs));
  } catch (e) {
    debugPrint('[Startup] $name FAILED/TIMED OUT: $e');
  }
  sw.stop();
  debugPrint('[Startup] $name total: ${sw.elapsedMilliseconds} ms');
}

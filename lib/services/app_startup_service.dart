import 'package:flutter/material.dart';
import 'data_service.dart';
import 'greeting_service.dart';
import '../core/utils/hijri_date.dart';

class AppStartupService {
  AppStartupService._();

  static bool _completed = false;

  static bool get isCompleted => _completed;

  /// Run critical startup tasks. This method MUST NEVER throw.
  /// It always completes, even if individual tasks fail.
  static Future<void> run(BuildContext context) async {
    if (_completed) return;

    debugPrint('[Startup] AppStartupService.run() started');

    try {
      // Fire-and-forget image precaching — don't block on it.
      // Images will be loaded on demand if precaching fails.
      _fireAndForgetPrecache(context);

      // Warm up data (tiny JSON files, ~8KB total)
      await _warmUpData().timeout(
        const Duration(seconds: 5),
        onTimeout: () => debugPrint('[Startup] _warmUpData timed out'),
      );
    } catch (e, st) {
      debugPrint('[Startup] AppStartupService.run() ERROR: $e');
      debugPrint('$st');
    }

    _completed = true;
    debugPrint('[Startup] AppStartupService.run() completed');
  }

  /// Fire-and-forget: start precaching images but don't await.
  /// This avoids any deadlock from precacheImage + initState context.
  static void _fireAndForgetPrecache(BuildContext context) {
    try {
      precacheImage(
        const AssetImage('assets/images/TIMEERBG.PNG'),
        context,
        onError: (e, st) => debugPrint('[Startup] TIMEERBG.PNG failed: $e'),
      );
      precacheImage(
        const AssetImage('assets/images/whitebg.PNG'),
        context,
        onError: (e, st) => debugPrint('[Startup] whitebg.PNG failed: $e'),
      );
      debugPrint('[Startup] Image precache started (fire-and-forget)');
    } catch (e) {
      debugPrint('[Startup] Image precache launch error: $e');
    }
  }

  static Future<void> _warmUpData() async {
    final sw = Stopwatch()..start();
    try {
      await Future.wait([
        _safeWarmDataService(),
        _safeWarmGreeting(),
      ]);
    } catch (e) {
      debugPrint('[Startup] _warmUpData error: $e');
    }
    sw.stop();
    debugPrint('[Startup] Data warmed up: ${sw.elapsedMilliseconds} ms');
  }

  static Future<void> _safeWarmDataService() async {
    try {
      await DataService.init().timeout(
        const Duration(seconds: 5),
        onTimeout: () => debugPrint('[Startup] DataService.init timed out'),
      );
    } catch (e) {
      debugPrint('[Startup] DataService warm-up error: $e');
    }
  }

  static Future<void> _safeWarmGreeting() async {
    try {
      GreetingService.getGreeting(
        hijriMonth: HijriDate.now().month,
        hijriDay: HijriDate.now().day,
      );
    } catch (_) {}
  }
}

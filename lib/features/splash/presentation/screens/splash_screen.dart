import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../providers/settings_provider.dart';
import '../../../../services/app_startup_service.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    debugPrint('[Startup] SplashScreen.initState');
    _scheduleNavigation();
  }

  void _scheduleNavigation() {
    final sw = Stopwatch()..start();

    // ═══ HARD FAILSAFE: Navigate after 5 seconds NO MATTER WHAT ═══
    // This guarantees the app ALWAYS reaches HomeScreen.
    Timer(const Duration(seconds: 5), () {
      debugPrint('[Startup] FAILSAFE timer fired at ${sw.elapsedMilliseconds} ms');
      _navigate(sw);
    });

    // ═══ Try to load data in parallel — but don't let it block ═══
    _loadDataInBackground(sw);
  }

  Future<void> _loadDataInBackground(Stopwatch sw) async {
    try {
      // Run startup with its own internal timeouts
      await AppStartupService.run(context).timeout(
        const Duration(seconds: 4),
        onTimeout: () => debugPrint('[Startup] AppStartupService.run timed out'),
      );
    } catch (e) {
      debugPrint('[Startup] _loadDataInBackground error: $e');
    }

    debugPrint('[Startup] Data loaded at ${sw.elapsedMilliseconds} ms');

    // Show splash for at least 2 seconds, then navigate
    final elapsed = sw.elapsedMilliseconds;
    if (elapsed < 2000) {
      await Future.delayed(Duration(milliseconds: 2000 - elapsed));
    }

    _navigate(sw);
  }

  void _navigate(Stopwatch sw) {
    if (_navigated || !mounted) return;
    _navigated = true;
    sw.stop();
    debugPrint('[Startup] ═══ NAVIGATING at ${sw.elapsedMilliseconds} ms ═══');

    try {
      final settings = ref.read(settingsNotifierProvider);
      final route = settings.onboarded ? '/home' : '/onboarding';
      debugPrint('[Startup] Route: $route');
      context.go(route);
    } catch (e) {
      debugPrint('[Startup] Navigation error: $e');
      try {
        context.go('/onboarding');
      } catch (_) {
        debugPrint('[Startup] Fallback navigation also failed');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );

    return Scaffold(
      body: Image.asset(
        'assets/images/Splash Screen.png',
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }
}

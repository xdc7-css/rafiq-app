import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'providers/settings_provider.dart';
import 'routes/app_router.dart';
import 'theme/app_theme.dart';
import 'features/quran/providers/quran_page_providers.dart';
import 'services/home_widget_service.dart';

class DailyIslamicWidgetApp extends ConsumerStatefulWidget {
  const DailyIslamicWidgetApp({super.key});

  @override
  ConsumerState<DailyIslamicWidgetApp> createState() => _DailyIslamicWidgetAppState();
}

class _DailyIslamicWidgetAppState extends ConsumerState<DailyIslamicWidgetApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      HomeWidgetService.updatePrayerCountdown();
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    final locale = ref.watch(localeProvider);
    final appFontSize = ref.watch(
      settingsNotifierProvider.select((s) => s.appFontSize),
    );

    // Start Quran page background download on app launch.
    ref.read(quranStreamerInitProvider);

    return MaterialApp.router(
      title: 'رَفِيقْ',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: router,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(appFontSize),
          ),
          child: child!,
        );
      },
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', ''),
        Locale('en', ''),
      ],
      locale: locale,
    );
  }
}

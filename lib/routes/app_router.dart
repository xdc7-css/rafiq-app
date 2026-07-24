import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/fatwa/presentation/screens/fatwa_search_screen.dart';
import '../features/fatwa/presentation/screens/fatwa_detail_screen.dart';
import '../features/fatwa/presentation/screens/fatwa_category_screen.dart';
import '../features/ziyarat/presentation/screens/ziyarat_list_screen.dart';
import '../features/fatwa/domain/entities/fatwa_entity.dart';
import '../features/onboarding/presentation/screens/permission_onboarding_screen.dart';
import '../features/settings/presentation/screens/permissions_settings_screen.dart';
import '../features/settings/presentation/screens/adhan_test_screen.dart';
import '../features/settings/presentation/screens/adhan_reliability_screen.dart';
import '../features/settings/presentation/screens/adhan_health_screen.dart';
import '../features/home/home_screen.dart';
import '../features/quran/premium_quran_home.dart';
import '../features/hadith/hadith_screen.dart';
import '../features/tasbeeh/tasbeeh_screen.dart';
import '../features/prayer_times/prayer_times_screen.dart';
import '../features/qibla/presentation/pages/qibla_screen.dart';
import '../features/adhkar/adhkar_screen.dart';
import '../features/adhkar/adhkar_category_screen.dart';
import '../features/favorites/favorites_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/search/search_screen.dart';
import '../features/khatmah/khatmah_screen.dart';
import '../features/widget_settings/widget_settings_screen.dart';
import '../features/widget_studio/widget_studio_screen.dart';
import '../features/more/more_screen.dart';
import '../theme/app_theme.dart';
import '../widgets/premium_bottom_nav.dart';
// ── Premium Screens ──
import '../features/premium/presentation/screens/auth_screens.dart';
import '../features/premium/presentation/screens/profile_screens.dart';
import '../features/premium/presentation/screens/calendar_mosque_screens.dart';
import '../features/premium/presentation/screens/media_player_screens.dart';
import '../features/premium/presentation/screens/subscription_screen.dart';
import '../features/premium/presentation/screens/settings_sub_screens.dart';
import '../features/premium/presentation/screens/error_status_screens.dart';
import '../features/splash/presentation/screens/splash_screen.dart';
// ── Quran Audio ──
import '../features/quran_audio/presentation/reciter_browser_screen.dart';
import '../features/quran_audio/presentation/surah_list_screen.dart';
import '../features/quran_audio/presentation/full_player_screen.dart';
import '../features/quran_audio/presentation/queue_panel_screen.dart';
import '../features/quran_audio/presentation/storage_management_screen.dart';
import '../features/quran_audio/presentation/widgets/mini_player_bar.dart';
import '../features/quran_audio/providers/quran_audio_providers.dart';
// ── SVG Mushaf ──
import '../features/quran/presentation/svg_mushaf/svg_mushaf_screen.dart';
// ── ShiaAPI Hadith ──
import '../features/hadith_shia/presentation/screens/books_screen.dart';
import '../features/hadith_shia/presentation/screens/book_detail_screen.dart';
import '../features/hadith_shia/presentation/screens/hadith_search_screen.dart';
import '../features/mercy_register/presentation/screens/mercy_register_screen.dart';
import '../features/mercy_register/presentation/screens/memorial_details_screen.dart';
import '../features/mercy_register/presentation/screens/add_memorial_screen.dart';
import '../features/mercy_register/presentation/screens/dua_selection_screen.dart';
import '../features/mercy_register/presentation/screens/dua_detail_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  // Read once at creation time — do NOT watch settings to avoid
  // recreating GoRouter on every setting change, which causes
  // "Cannot use ref after the widget was disposed" errors.
  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const PermissionOnboardingScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return HomeShell(navigationShell: navigationShell);
        },
        branches: [
          // ── Branch 0: Home ──
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: HomeScreen()),
              ),
              GoRoute(
                path: '/adhkar',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: AdhkarScreen()),
              ),
            ],
          ),
          // ── Branch 1: Quran ──
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/quran',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: PremiumQuranHomePage()),
              ),
              GoRoute(
                path: '/mushaf-download',
                builder: (context, state) {
                  final page = state.uri.queryParameters['page'];
                  return SvgMushafScreen(
                    initialPage:
                        page != null ? (int.tryParse(page) ?? 1) : 1,
                  );
                },
              ),
              GoRoute(
                path: '/mushaf',
                builder: (context, state) {
                  final page = state.uri.queryParameters['page'];
                  return SvgMushafScreen(
                    initialPage:
                        page != null ? (int.tryParse(page) ?? 1) : 1,
                  );
                },
              ),
            ],
          ),
          // ── Branch 2: Ziyarat ──
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/ziyarat',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: ZiyaratListScreen()),
              ),
            ],
          ),
          // ── Branch 3: Hadith ──
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/hadith',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: HadithScreen()),
              ),
            ],
          ),
          // ── Branch 4: Settings ──
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: SettingsScreen()),
              ),
              GoRoute(
                path: '/more',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: MoreScreen()),
              ),
            ],
          ),
        ],
      ),
      // ── Quran Audio Routes ──
      GoRoute(
        path: '/quran-audio/reciters',
        builder: (context, state) => const ReciterBrowserScreen(),
      ),
      GoRoute(
        path: '/quran-audio/surahs',
        builder: (context, state) => const SurahListScreen(),
      ),
      GoRoute(
        path: '/quran-audio/player',
        builder: (context, state) => const FullPlayerScreen(),
      ),
      GoRoute(
        path: '/quran-audio/queue',
        builder: (context, state) => const QueuePanelScreen(),
      ),
      GoRoute(
        path: '/quran-audio/storage',
        builder: (context, state) => const StorageManagementScreen(),
      ),
      GoRoute(
        path: '/tasbeeh',
        builder: (context, state) => const TasbeehScreen(),
      ),
      GoRoute(
        path: '/prayer-times',
        builder: (context, state) => const PrayerTimesScreen(),
      ),
      GoRoute(path: '/qibla', builder: (context, state) => const QiblaScreen()),
      GoRoute(
        path: '/favorites',
        builder: (context, state) => const FavoritesScreen(),
      ),
      GoRoute(
        path: '/permissions',
        builder: (context, state) => const PermissionsSettingsScreen(),
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: '/khatmah',
        builder: (context, state) => const KhatmahScreen(),
      ),
      GoRoute(
        path: '/widget-settings',
        builder: (context, state) => const WidgetSettingsScreen(),
      ),
      GoRoute(
        path: '/widget-studio',
        builder: (context, state) => const WidgetStudioScreen(),
      ),
      GoRoute(path: '/books', builder: (context, state) => const BooksScreen()),
      GoRoute(
        path: '/books/:bookId',
        builder: (context, state) =>
            BookDetailScreen(bookId: state.pathParameters['bookId']!),
      ),
      GoRoute(
        path: '/hadith-search',
        builder: (context, state) => const HadithSearchScreen(),
      ),
      GoRoute(
        path: '/mercy-register',
        builder: (context, state) => const MercyRegisterScreen(),
      ),
      GoRoute(
        path: '/memorial-details/:id',
        builder: (context, state) =>
            MemorialDetailsScreen(memorialId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/add-memorial',
        builder: (context, state) => const AddMemorialScreen(),
      ),
      GoRoute(
        path: '/dua-selection/:memorialId',
        builder: (context, state) =>
            DuaSelectionScreen(memorialId: state.pathParameters['memorialId']!),
      ),
      GoRoute(
        path: '/dua-detail/:duaId',
        builder: (context, state) {
          final duaId = state.pathParameters['duaId']!;
          final memorialId = state.uri.queryParameters['memorialId'] ?? '';
          return DuaDetailScreen(duaId: duaId, memorialId: memorialId);
        },
      ),
      GoRoute(
        path: '/adhkar/:categoryId',
        builder: (context, state) => AdhkarCategoryScreen(
          categoryId: state.pathParameters['categoryId']!,
        ),
      ),
      GoRoute(
        path: '/fatwa',
        builder: (context, state) => const FatwaSearchScreen(),
      ),
      GoRoute(
        path: '/fatwa-detail',
        builder: (context, state) =>
            FatwaDetailScreen(fatwa: state.extra as FatwaEntity),
      ),
      GoRoute(
        path: '/fatwa-category',
        builder: (context, state) =>
            FatwaCategoryScreen(category: state.extra as String),
      ),
      // ── Auth Routes ──
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/otp',
        builder: (context, state) => const OtpVerificationScreen(),
      ),
      // ── Profile Routes ──
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/profile-stats',
        builder: (context, state) => const StatsScreen(),
      ),
      // ── Calendar & Mosque Routes ──
      GoRoute(
        path: '/calendar',
        builder: (context, state) => const CalendarScreen(),
      ),
      GoRoute(
        path: '/nearby-mosques',
        builder: (context, state) => const NearbyMosqueScreen(),
      ),
      // ── Media Routes ──
      GoRoute(
        path: '/audio-library',
        builder: (context, state) => const AudioLibraryScreen(),
      ),
      // ── Subscription Route ──
      GoRoute(
        path: '/subscription',
        builder: (context, state) => const SubscriptionScreen(),
      ),
      // ── Settings Sub-Routes ──
      GoRoute(
        path: '/settings/language',
        builder: (context, state) => const LanguageSettingsScreen(),
      ),
      GoRoute(
        path: '/settings/notifications',
        builder: (context, state) => const NotificationSettingsScreen(),
      ),
      GoRoute(
        path: '/settings/support',
        builder: (context, state) => const SupportScreen(),
      ),
      GoRoute(
        path: '/settings/feedback',
        builder: (context, state) => const FeedbackScreen(),
      ),
      GoRoute(
        path: '/settings/adhan-test',
        builder: (context, state) => const AdhanTestScreen(),
      ),
      GoRoute(
        path: '/settings/adhan-reliability',
        builder: (context, state) => const AdhanReliabilityScreen(),
      ),
      GoRoute(
        path: '/settings/adhan-health',
        builder: (context, state) => const AdhanHealthScreen(),
      ),
      // ── Status / Error Routes ──
      GoRoute(
        path: '/404',
        builder: (context, state) => const NotFoundScreen(),
      ),
      GoRoute(
        path: '/offline',
        builder: (context, state) => const OfflineScreen(),
      ),
      GoRoute(
        path: '/loading',
        builder: (context, state) => const LoadingScreen(),
      ),
    ],
  );
});

// ═══════════════════════════════════════════════════════════════════
//  HOME SHELL — IndexedStack for state preservation + Premium dock
// ═══════════════════════════════════════════════════════════════════

class HomeShell extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  const HomeShell({super.key, required this.navigationShell});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  static const _desktopBreakpoint = 900.0;
  static const _miniPlayerHeight = 76.0;
  static const _dockHeight = 100.0;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= _desktopBreakpoint;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final navigationShell = widget.navigationShell;

    return Scaffold(
      backgroundColor: AppTheme.bgPrimary,
      body: Consumer(
        builder: (context, ref, _) {
          final showPlayer = ref.watch(
            audioPlayerNotifierProvider.select((s) => s.hasActivePlayback),
          );
          final extraBottom = showPlayer ? _miniPlayerHeight : 0.0;

          return Stack(
            children: [
              // ── Main content area ──
              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: isDesktop
                        ? 0
                        : (_dockHeight + bottomInset + extraBottom),
                  ),
                  child: navigationShell,
                ),
              ),
              // ── Mini player bar (mobile, above dock) ──
              if (!isDesktop && showPlayer)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: _dockHeight + bottomInset,
                  child: const MiniPlayerBar(),
                ),
              // ── Premium floating dock (mobile only) ──
              if (!isDesktop)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: PremiumBottomNav(
                    selectedIndex: navigationShell.currentIndex,
                    onDestinationSelected: (index) {
                      navigationShell.goBranch(
                        index,
                        initialLocation:
                            index == navigationShell.currentIndex,
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

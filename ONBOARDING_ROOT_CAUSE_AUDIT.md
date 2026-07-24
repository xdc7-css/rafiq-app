# Onboarding Root Cause Audit
## Complete Execution Path Analysis: App Launch → HomeScreen

> **Date**: July 20, 2026  
> **Scope**: Every code path from process creation to HomeScreen rendering  
> **Mode**: Read-only analysis — no code changes

---

## Table of Contents

1. [Executive Summary](#1-executive-summary)
2. [Initialization Timeline (Sequence Diagram)](#2-initialization-timeline)
3. [Phase 0: Process Creation](#3-phase-0-process-creation)
4. [Phase 1: main() Synchronous Boot](#4-phase-1-main-synchronous-boot)
5. [Phase 2: ProviderScope + SettingsNotifier](#5-phase-2-providerscope--settingsnotifier)
6. [Phase 3: MaterialApp.router First Build](#6-phase-3-materialapprouter-first-build)
7. [Phase 4: SplashScreen Orchestration](#7-phase-4-splashscreen-orchestration)
8. [Phase 5: Navigation Decision](#8-phase-5-navigation-decision)
9. [Phase 6a: Onboarding Path (PermissionOnboardingScreen)](#9-phase-6a-onboarding-path)
10. [Phase 6b: Onboarding Path (Legacy OnboardingScreen)](#10-phase-6b-onboarding-legacy)
11. [Phase 7: Onboarding Completion → HomeScreen](#11-phase-7-onboarding-completion)
12. [Phase 8: HomeScreen + Post-Init](#12-phase-8-homescreen)
13. [Race Conditions Identified](#13-race-conditions)
14. [Root Causes Found](#14-root-causes)
15. [Dead Code](#15-dead-code)
16. [Complete Dependency Graph](#16-dependency-graph)
17. [Recommendations (Observation Only)](#17-recommendations)

---

## 1. Executive Summary

The onboarding flow is **functional but fragile**. It relies on a precise timing sequence where SharedPreferences (SP) must load synchronously before the first widget tree reads the `onboarded` flag. There are **6 race conditions**, **2 redundant onboarding screens**, **1 dead code path**, and **1 unawaited critical init** that can cause the app to silently degrade to SP-only mode.

The flow works ~99% of the time because SP is fast on modern Android, but the architecture has no guarantees.

**Critical finding**: The `_initLocalDatabase()` call in `main.dart:69` is `unawaited()`, meaning it runs concurrently with `runApp()`. If Isar hasn't opened when `SettingsNotifier._loadFromDb()` checks `db.isInitialized`, the DB path is silently skipped and the app runs entirely on SharedPreferences — losing all Isar-specific data access until the next cold start.

---

## 2. Initialization Timeline

```
TIME    EVENT                                          SOURCE
──────  ─────────────────────────────────────────────  ──────────────────────────────
0ms     Android Activity.onCreate                      MainActivity.kt
~10ms   Flutter engine boot                            Flutter framework
~20ms   WidgetsFlutterBinding.ensureInitialized()      main.dart:29
~50ms   Firebase.initializeApp() [AWAITED]             main.dart:35
~200ms  StorageService.init() [AWAITED, 5s timeout]    main.dart:59
        └─ SharedPreferences.getInstance()
        └─ First call: creates + opens SP, reads all
~200ms  unawaited(_initLocalDatabase())                main.dart:69  ← FIRES HERE
        └─ IsarService.getInstance() [ASYNC, ~200-500ms]
        └─ DataMigrator.migrateIfNeeded() [ASYNC]
~200ms  unawaited(_initHiveBackground())               main.dart:72
~200ms  runApp(ProviderScope(DailyIslamicWidgetApp))   main.dart:75
        │
        ├─ ProviderScope created
        │  └─ settingsNotifierProvider READ (first time)
        │     └─ SettingsNotifier constructor          settings_provider.dart:17
        │        ├─ StorageService.getSettings() [SYNC]
        │        │  └─ Reads 'settings' key from SP
        │        │  └─ Returns AppSettings(onboarded: false/true)
        │        │  └─ Sets state = SP values
        │        └─ _loadFromDb() [ASYNC, FIRES & FORGETS]
        │           └─ Checks db.isInitialized → false (Isar still opening)
        │           └─ RETURNS EARLY — no overwrite
        │
        ├─ routerProvider READ (first time)             app.dart:14
        │  └─ GoRouter created with initialLocation: '/splash'
        │
        ├─ quranStreamerInitProvider READ               app.dart:21
        │  └─ Triggers background Quran download
        │
        └─ MaterialApp.router builds                   app.dart:23
           └─ GoRouter renders '/splash'
              └─ SplashScreen created                  splash_screen.dart:10
                 └─ initState() → _scheduleNavigation()
                    ├─ _failSafeTimer = 5s hard timeout   splash_screen.dart:46
                    └─ addPostFrameCallback → _loadDataInBackground()
                       └─ AppStartupService.run() [4s timeout]
                          ├─ Fire-and-forget image precache
                          ├─ OEMReliabilityService.initialize()
                          ├─ PermissionAnalyticsService.initialize()
                          └─ _warmUpData() [5s timeout]
                             ├─ DataService.init()
                             └─ GreetingService.getGreeting()
                       └─ On completion: _navigate()

~300ms  ═══ IsarService.getInstance() COMPLETES ═══     (background)
        └─ _initialized = true
        └─ _initLocalDatabase() → DataMigrator.migrateIfNeeded()
           └─ Migrates SP → Isar (if first time)
           └─ Sets 'isar_migration_v1_complete' = true

~400ms  ═══ SettingsNotifier._loadFromDb() still has NOT re-run ═══
        (It only runs once in the constructor — never again)

???ms   _navigate() fires (either at 2s min splash or 5s failsafe)
        ├─ ref.read(settingsNotifierProvider) → reads current state
        ├─ state.onboarded == false → context.go('/onboarding')
        └─ OR state.onboarded == true → context.go('/home')
```

---

## 3. Phase 0: Process Creation

**File**: `android/app/src/main/kotlin/.../MainActivity.kt`  
**Code**: Standard FlutterActivity — no custom logic.

The Android OS creates the process, loads the Flutter engine, and hands off to Dart's `main()`.

---

## 4. Phase 1: main() Synchronous Boot

**File**: `lib/main.dart:24-93`

```
main() {
  1. WidgetsFlutterBinding.ensureInitialized()        [SYNC, ~10ms]
  2. Firebase.initializeApp()                         [AWAITED, ~50-200ms, CAN FAIL]
  3. SystemChrome.setPreferredOrientations()           [AWAITED, ~5ms, CAN FAIL]
  4. StorageService.init()                             [AWAITED, 5s timeout]
     └─ SharedPreferences.getInstance()                [First call: creates file]
  5. unawaited(_initLocalDatabase())                   [FIRES, NOT AWAITED]
  6. unawaited(_initHiveBackground())                  [FIRES, NOT AWAITED]
  7. runApp(ProviderScope(child: DailyIslamicWidgetApp()))
  8. unawaited(_initNotifications())                   [POST-RUN]
  9. unawaited(_initHomeWidget())                      [POST-RUN]
 10. unawaited(_initAudioService())                    [POST-RUN, 15s timeout]
 11. unawaited(_initConnectivity())                    [POST-RUN]
 12. unawaited(_initBackgroundSync())                  [POST-RUN, non-web only]
}
```

**Key observation**: Step 4 is the ONLY blocking init. Everything else is fire-and-forget. The comment at line 56 says `"StorageService — the ONLY blocking init"` — this is by design.

**Firebase failure handling**: If Firebase fails (e.g., placeholder API keys), it logs the error and continues. The app works without Firebase until any Firebase-dependent feature is used.

---

## 5. Phase 2: ProviderScope + SettingsNotifier

**Files**: `lib/main.dart:75-79`, `lib/providers/settings_provider.dart:14-31`

When `runApp()` is called, the widget tree is:

```
ProviderScope
  └─ DailyIslamicWidgetApp (ConsumerWidget)
     └─ build() calls:
        ├─ ref.watch(routerProvider)      → triggers routerProvider creation
        ├─ ref.watch(localeProvider)       → triggers localeProvider → settingsNotifierProvider
        └─ ref.read(quranStreamerInitProvider)
```

The first `ref.watch(settingsNotifierProvider)` (via `localeProvider`) triggers:

```
SettingsNotifier constructor:
  1. super(StorageService.getSettings())         [SYNC, reads from SP]
     └─ state = AppSettings parsed from SP 'settings' key
     └─ If no 'settings' key: creates default AppSettings, SAVES it to SP
  2. _loadFromDb()                              [ASYNC, FIRES IN CONSTRUCTOR]
     └─ db = LocalDatabaseService.instance       [singleton, already created]
     └─ if (!db.isInitialized) return;           [SKIPS if Isar not ready]
     └─ entry = await db.getSettings();
     └─ if (entry != null) state = parsed from Isar
```

**Critical timing**: The `SettingsNotifier` constructor runs synchronously and reads SP immediately. The `_loadFromDb()` is async and fires in the background. If Isar isn't open yet (very likely), the DB path is skipped entirely. The notifier then has SP data, which may or may not match Isar data.

---

## 6. Phase 3: MaterialApp.router First Build

**File**: `lib/app.dart:9-47`

```dart
Widget build(BuildContext context, WidgetRef ref) {
  final router = ref.watch(routerProvider);          // GoRouter cached, only created once
  final locale = ref.watch(localeProvider);           // triggers settingsNotifierProvider
  final appFontSize = ref.watch(
    settingsNotifierProvider.select((s) => s.appFontSize),
  );

  ref.read(quranStreamerInitProvider);                // fire-and-forget background download

  return MaterialApp.router(
    title: 'رَفِيقْ',
    theme: AppTheme.darkTheme,
    routerConfig: router,
    // ...
  );
}
```

**Router creation** (`lib/routes/app_router.dart:58-201`):

```dart
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    routes: [ /* 40+ routes */ ],
  );
});
```

**Key observations**:
- `routerProvider` is a plain `Provider` (not `StateProvider`), so GoRouter is created once and never rebuilt
- `initialLocation: '/splash'` — always starts at splash, no redirect logic
- The comment at line 59-61 explicitly says: "Read once at creation time — do NOT watch settings to avoid recreating GoRouter on every setting change"
- This means GoRouter has NO awareness of onboarding state — it relies entirely on SplashScreen to navigate

---

## 7. Phase 4: SplashScreen Orchestration

**File**: `lib/features/splash/presentation/screens/splash_screen.dart:10-142`

```
SplashScreen StatefulWidget
  │
  ├─ initState()
  │  └─ _scheduleNavigation()
  │     ├─ _failSafeTimer = Timer(5s, _navigate)       [HARD FAILSAFE]
  │     └─ addPostFrameCallback → _loadDataInBackground(sw)
  │        └─ AppStartupService.run(context).timeout(4s)
  │           ├─ _fireAndForgetPrecache(context)        [non-blocking]
  │           ├─ OEMReliabilityService.initialize()     [sync]
  │           ├─ PermissionAnalyticsService.initialize() [sync]
  │           └─ _warmUpData().timeout(5s)
  │              ├─ DataService.init()                  [loads ~8KB JSON]
  │              └─ GreetingService.getGreeting()       [sync computation]
  │
  │  After AppStartupService.run() completes:
  │     if (elapsed < 2000ms)
  │        Timer(2000 - elapsed, _navigate)             [MINIMUM SPLASH]
  │     else
  │        _navigate()                                  [IMMEDIATE]
  │
  ├─ _navigate()                                        [DECISION POINT]
  │  ├─ if (_navigated || !mounted || _disposed) return
  │  ├─ _navigated = true
  │  ├─ settings = ref.read(settingsNotifierProvider)
  │  ├─ if (!settings.onboarded) → context.go('/onboarding')
  │  └─ if (settings.onboarded)  → context.go('/home')
  │
  └─ build() → Image.asset('assets/images/Splash Screen.png', fit: BoxFit.cover)
```

**Timing analysis**:
- **Best case**: AppStartupService runs in <500ms → splash shows for 2s minimum → navigate at ~2s
- **Typical case**: AppStartupService runs in ~1s → splash shows for 2s → navigate at ~2s
- **Worst case**: AppStartupService takes 4s (timeout) → navigate at ~4s
- **Absolute worst**: failsafe timer fires at 5s → navigate regardless

---

## 8. Phase 5: Navigation Decision

**File**: `lib/features/splash/presentation/screens/splash_screen.dart:90-113`

```dart
void _navigate(Stopwatch sw) {
  if (_navigated || !mounted || _disposed) return;
  _navigated = true;

  final settings = ref.read(settingsNotifierProvider);  // READS CURRENT STATE
  if (!settings.onboarded) {
    context.go('/onboarding');     // → PermissionOnboardingScreen
    return;
  }
  context.go('/home');             // → HomeScreen inside ShellRoute
}
```

**Decision logic**: Pure synchronous check of `settings.onboarded`. No DB query, no network call. The value is whatever `SettingsNotifier` currently holds in memory.

**Three possible outcomes**:
1. **Fresh install**: `onboarded = false` (default) → `/onboarding`
2. **Returning user**: `onboarded = true` (from SP) → `/home`
3. **Error/fallback**: If `ref.read()` throws, catches → `/onboarding` (safe default)

---

## 9. Phase 6a: Onboarding Path (PermissionOnboardingScreen) — ACTIVE

**File**: `lib/features/onboarding/presentation/screens/permission_onboarding_screen.dart:12-527`  
**Route**: `/onboarding` → `PermissionOnboardingScreen` (registered in `app_router.dart:71-73`)

```
PermissionOnboardingScreen (ConsumerStatefulWidget)
  │
  ├─ Screen 0: Welcome
  │  ├─ Gold circle with mosque icon
  │  ├─ "مرحباً بك في رفيق" (Welcome to Rafiq)
  │  ├─ "سنقوم بإعداد التطبيق خلال أقل من دقيقة"
  │  └─ Button: "ابدأ الإعداد" → _goToScreen(1)
  │
  ├─ Screen 1: Permission Center
  │  ├─ Shows PermissionRegistry.onboardingPermissions()
  │  ├─ Each permission: PermissionStatusRow (icon + status + tap)
  │  ├─ Active permission highlighted with gold border
  │  ├─ "متابعة" button → requestAllPermissions()
  │  │  └─ OnboardingNotifier.requestAllPermissions()
  │  │     └─ PermissionRequestController.requestAllPermissions()
  │  │        └─ Sequential permission requests with dependency graph
  │  ├─ If blocked by root → shows orange notice + retry button
  │  ├─ "تخطي" (Skip) text button → _finish()
  │  └─ On completion → auto-advances to Screen 2
  │
  └─ Screen 2: Finished
     ├─ Gold circle with checkmark (elastic animation)
     ├─ "تم إعداد التطبيق بنجاح" (Setup complete)
     ├─ Checklist showing granted/denied status
     └─ Button: "ابدأ استخدام التطبيق" → _finish()

_finish() {
  1. await ref.read(settingsNotifierProvider.notifier).markOnboarded()
     ├─ state = state.copyWith(onboarded: true)
     ├─ StorageService.saveSettings(state)    [writes to SP]
     └─ db.saveSettings(json)                  [writes to Isar if initialized]
  2. if (!mounted) return
  3. context.go('/home')                       [navigates to HomeScreen]
}
```

**Permission dependency chain** (from `permission_request_controller.dart`):
```
notifications (root) → exactAlarm (if Android 12+) → batteryOptimization → foregroundService
```
- `notifications` is the root — if denied, all subsequent permissions are blocked
- `batteryOptimization` and `foregroundService` depend on `notifications` being granted
- `exactAlarm` is independent but only requested on Android 12+

---

## 10. Phase 6b: Onboarding Path (Legacy OnboardingScreen) — DEAD CODE

**File**: `lib/features/onboarding/onboarding_screen.dart:9-195`  
**Route**: NOT REGISTERED in `app_router.dart` — this screen is **unreachable**

```
OnboardingScreen (ConsumerStatefulWidget)
  ├─ 3-page PageView (Arabic text, icons, colored backgrounds)
  │  ├─ Page 1: auto_stories icon, green — "page1Title"
  │  ├─ Page 2: explore icon, gold — "page2Title"
  │  └─ Page 3: trending_up icon, blue — "page3Title"
  ├─ SmoothPageIndicator (dots)
  ├─ Next/Get Started button
  └─ Skip text button (top-right)

_completeOnboarding() {
  1. await PermissionService.requestNotificationPermission()
  2. await PermissionService.requestExactAlarmPermission()
  3. await ref.read(settingsNotifierProvider.notifier).markOnboarded()
  4. context.go('/home')
}
```

**Why it's dead**: The GoRouter in `app_router.dart` maps `/onboarding` to `PermissionOnboardingScreen` (line 71-73). `OnboardingScreen` is never referenced by any route. It's a leftover from an earlier version of the app.

---

## 11. Phase 7: Onboarding Completion → HomeScreen

**File**: `lib/features/onboarding/presentation/screens/permission_onboarding_screen.dart:63-67`

```dart
Future<void> _finish() async {
  await ref.read(settingsNotifierProvider.notifier).markOnboarded();
  if (!mounted) return;
  context.go('/home');
}
```

**markOnboarded()** (`lib/providers/settings_provider.dart:346-349`):

```dart
Future<void> markOnboarded() async {
  state = state.copyWith(onboarded: true);    // updates in-memory state
  await _saveSettings();                       // persists to SP + Isar
}
```

**_saveSettings()** (`lib/providers/settings_provider.dart:33-39`):

```dart
Future<void> _saveSettings() async {
  StorageService.saveSettings(state);          // always writes to SP
  final db = LocalDatabaseService.instance;
  if (db.isInitialized) {
    await db.saveSettings(json.encode(state.toJson()));  // writes to Isar if ready
  }
}
```

**After navigation**: `context.go('/home')` triggers GoRouter to:
1. Pop all routes (splash is gone)
2. Push `ShellRoute(builder: HomeShell)` with child `HomeScreen`
3. `HomeShell` renders `LiquidGlassNav` + content area + mini player

---

## 12. Phase 8: HomeScreen + Post-Init

**File**: `lib/routes/app_router.dart:74-109`, `lib/features/home/home_screen.dart`

```
ShellRoute
  └─ HomeShell (StatelessWidget)
     ├─ Scaffold(backgroundColor: AppTheme.bgPrimary)
     ├─ Consumer watches audioPlayerNotifierProvider
     │  └─ Shows MiniPlayerBar if hasActivePlayback
     ├─ LiquidGlassNav (bottom dock, 5 tabs)
     │  ├─ /home → index 0
     │  ├─ /quran → index 1
     │  ├─ /ziyarat → index 2
     │  ├─ /hadith → index 3
     │  └─ /settings → index 4
     └─ child = HomeScreen (routed content)
```

**Post-navigation fire-and-forget services** (still running from `main()`):
- NotificationService (10s timeout)
- HomeWidgetService (5s timeout)
- AudioService (15s timeout)
- ConnectivityService (5s timeout)
- BackgroundSyncService (10s timeout, non-web only)

---

## 13. Race Conditions Identified

### Race Condition #1: `_initLocalDatabase()` vs `SettingsNotifier._loadFromDb()`

**Severity**: MEDIUM  
**Files**: `main.dart:69`, `settings_provider.dart:17-31`

```
Timeline:
  T=0ms   unawaited(_initLocalDatabase()) fires
  T=0ms   runApp() fires → ProviderScope → SettingsNotifier created
  T=0ms   SettingsNotifier._loadFromDb() fires
  T=0ms   db.isInitialized == false → _loadFromDb() RETURNS EARLY
  T=300ms IsarService completes → db.isInitialized = true
  T=???   _loadFromDb() NEVER RE-RUNS (it's a one-shot in constructor)
```

**Impact**: On the FIRST cold start after install/migration, the SettingsNotifier reads SP data (which may be stale or default) and never overwrites from Isar. On subsequent starts, Isar is already open from the previous session's process, so `isInitialized` may be true by the time `_loadFromDb()` runs.

**Actual risk**: Low in practice because:
- On fresh install: SP and Isar both have defaults, so no data mismatch
- On reinstall: SP is cleared but Isar persists — SP defaults overwrite Isar's `onboarded: true`, causing user to see onboarding again. But this is actually the **correct behavior** (reinstall = fresh start)
- The real risk is if Isar has OTHER settings that differ from SP defaults (e.g., custom Quran font, notification preferences) — those would be silently lost until next cold start

### Race Condition #2: `_initLocalDatabase()` vs `markOnboarded()`

**Severity**: LOW  
**Files**: `main.dart:69`, `settings_provider.dart:346-349`

```
Timeline:
  T=0ms     unawaited(_initLocalDatabase()) fires
  T=2000ms  User completes onboarding → markOnboarded()
  T=2000ms  _saveSettings() → db.isInitialized check
  T=2000ms  If Isar not ready → Isar write SKIPPED
  T=2000ms  SP is updated with onboarded: true ← this is fine
  T=3000ms  Isar opens, but onboarded: true is NOT in Isar
```

**Impact**: After first onboarding completion, `onboarded: true` is in SP but not in Isar. On next cold start, SettingsNotifier reads SP (has `onboarded: true`) → splash navigates to `/home`. Then `_loadFromDb()` overwrites from Isar → `onboarded: false` → but we're already past splash, so it doesn't matter. The user never sees onboarding again because splash only runs once per session.

**Actual risk**: Essentially zero. The only scenario where this matters is if both conditions are true: (a) Isar finishes init AFTER markOnboarded but BEFORE next cold start, AND (b) Isar has `onboarded: false`. Since Isar was never told `onboarded: false`, this can't happen.

### Race Condition #3: `quranStreamerInitProvider` fires before settings are ready

**Severity**: LOW  
**Files**: `app.dart:21`, `lib/features/quran/providers/quran_page_providers.dart`

```
Timeline:
  T=0ms   MaterialApp.router builds → ref.read(quranStreamerInitProvider)
  T=0ms   Quran background download starts
  T=0ms   Settings may not be fully loaded (DB overwrites pending)
```

**Impact**: The Quran downloader starts before the user's font/download preferences are confirmed. If the user has `quranAutoAudio: true` in Isar but SP has `false`, the download may use wrong settings.

### Race Condition #4: AudioService global singleton accessed before init

**Severity**: LOW  
**Files**: `main.dart:22,85`, throughout app

```
Timeline:
  T=0ms     late AudioHandler audioService declared (NOT initialized)
  T=200ms   runApp() fires
  T=200ms   Any screen that accesses audioService before _initAudioService completes
  T=200ms   → LateInitializationError: Field 'audioService' has not been initialized
```

**Impact**: If any screen tries to use `audioService` before the 15s `_initAudioService()` completes, it will crash with a `LateInitializationError`. In practice, the splash screen doesn't use audio, and HomeScreen likely doesn't either on first load, so this is unlikely to trigger. But it's a latent bug.

### Race Condition #5: `onboardingProvider` created independently of splash navigation

**Severity**: LOW  
**Files**: `onboarding_provider.dart:95-98`

```
onboardingProvider is a StateNotifierProvider — created lazily on first read.
OnboardingNotifier constructor:
  1. Creates PermissionRequestController
  2. Adds listener
  3. Calls checkInitialPermissions()
     └─ Queries actual system permission state
     └─ Updates controller status for each permission
```

**Impact**: If the user navigates away from onboarding and back, the provider is recreated (it's not persisted). Permission states are re-queried from the system. This is correct behavior but means there's no state persistence across navigation.

### Race Condition #6: `StorageService.getSettings()` cache vs SP persistence

**Severity**: VERY LOW  
**Files**: `storage_service.dart:8,53-68`

```
StorageService._settingsCache is a static variable.
First call to getSettings():
  1. Reads from _settingsCache → null (first time)
  2. Reads from SP → parses AppSettings
  3. Saves to _settingsCache
  4. Returns parsed settings

saveSettings():
  1. Updates _settingsCache
  2. Writes to SP
```

**Impact**: If `getSettings()` is called from multiple isolates (impossible in Dart's single-isolate model), the cache would be stale. In practice, this is a non-issue since Dart is single-threaded.

---

## 14. Root Causes Found

### Root Cause #1: SettingsNotifier reads SP synchronously, DB async — no reconciliation

**File**: `lib/providers/settings_provider.dart:17-31`

The constructor does:
```dart
SettingsNotifier(this._ref) : super(StorageService.getSettings()) {
  _loadFromDb();  // async, one-shot, never retried
}
```

**Problem**: If Isar isn't ready, `_loadFromDb()` returns early and is never called again. The notifier permanently holds SP data. If SP and Isar diverge (e.g., after migration, or if user changes settings on another device via Firebase sync), the divergence is never resolved within the same session.

**Root cause**: The initialization sequence was designed for SP-only mode, and Isar was bolted on as an enhancement. The DB read should either:
- Be awaited before creating the notifier, OR
- Use a Stream/Listener pattern to reconcile when DB becomes available, OR
- Be called periodically or on app resume

### Root Cause #2: Two onboarding screens with different UX flows

**Files**: 
- `lib/features/onboarding/presentation/screens/permission_onboarding_screen.dart` (ACTIVE — 3-screen wizard, gold/navy theme, Arabic)
- `lib/features/onboarding/onboarding_screen.dart` (DEAD — 3-page PageView, Material theme, mixed)

**Problem**: The legacy `OnboardingScreen` is unreachable but still compiled. It uses `Theme.of(context)` (Material default), while `PermissionOnboardingScreen` uses `AppTheme.darkTheme` directly. The legacy screen requests only 2 permissions (notifications + exact alarm) vs the active screen's full permission center with dependency graph.

### Root Cause #3: `unawaited(_initLocalDatabase())` — fire-and-forget critical init

**File**: `main.dart:69`

**Problem**: The local database (Isar) is the primary persistence layer for the app's data model. Making it fire-and-forget means any code that runs before Isar is open will silently skip DB operations. The comment at line 68 says "platform-conditional" but the behavior is "race and hope."

### Root Cause #4: GoRouter has no redirect — relies on SplashScreen for all routing decisions

**File**: `lib/routes/app_router.dart:58-201`

**Problem**: GoRouter's `redirect` parameter is not used. This means:
- Every navigation starts at `/splash`
- SplashScreen is the sole authority for onboarding → home routing
- If SplashScreen fails to navigate (e.g., widget disposed early, context invalid), the user is stuck on a splash screen forever
- Deep links bypass splash entirely — go straight to `/home` even if not onboarded
- No route guards exist for authenticated routes (login, profile, etc.)

### Root Cause #5: `late AudioHandler audioService` global — no initialization guarantee

**File**: `main.dart:22`

```dart
late AudioHandler audioService;
```

**Problem**: This global is initialized asynchronously in `_initAudioService()` (15s timeout) but accessed synchronously throughout the app. Any access before initialization completes throws `LateInitializationError`.

### Root Cause #6: `StorageService.getOnboardingComplete()` / `setOnboardingComplete()` — dead code using different key

**Files**: `lib/services/storage_service.dart:21-29`, `lib/core/constants.dart:48`

```dart
// storage_service.dart
static bool getOnboardingComplete() {
  if (_prefs == null) return false;
  return _prefs!.getBool(AppConstants.keyOnboardingComplete) ?? false;
}

// constants.dart
static const String keyOnboardingComplete = 'onboarding_complete';
```

**Problem**: These methods read/write a SP key called `'onboarding_complete'`. But `AppSettings.onboarded` is serialized as part of the `'settings'` JSON blob under the key `'onboarded'`. These are two completely separate storage locations. The dead code methods are never called, but if they were, they'd read/write the wrong location.

---

## 15. Dead Code

| Location | Code | Why Dead |
|----------|------|----------|
| `storage_service.dart:21-29` | `getOnboardingComplete()` / `setOnboardingComplete()` | Never called. Uses separate SP key `'onboarding_complete'` vs the actual `'settings'` JSON blob |
| `onboarding_screen.dart:9-195` | Entire `OnboardingScreen` class | Not registered in GoRouter. Legacy from before PermissionOnboardingScreen |
| `constants.dart:48` | `keyOnboardingComplete = 'onboarding_complete'` | Only referenced by dead code in `storage_service.dart` |

---

## 16. Complete Dependency Graph

```
main()
 ├─ await Firebase.initializeApp()                    [BLOCKING]
 ├─ await StorageService.init()                        [BLOCKING, 5s timeout]
 │   └─ SharedPreferences.getInstance()
 ├─ unawaited(_initLocalDatabase())                    [NON-BLOCKING]
 │   ├─ LocalDatabaseService.instance                  [singleton factory]
 │   │   └─ IsarDatabaseService()
 │   ├─ await IsarService.getInstance()                [~200-500ms]
 │   │   └─ Isar.open(20 schemas)
 │   └─ await DataMigrator.migrateIfNeeded()           [~100-300ms]
 │       ├─ reads all SP keys
 │       └─ writes to Isar collections
 ├─ unawaited(_initHiveBackground())                   [NON-BLOCKING]
 │   ├─ Hive.initFlutter()
 │   └─ HiveCacheManager.init()
 ├─ runApp(ProviderScope(DailyIslamicWidgetApp()))
 │   ├─ ProviderScope
 │   │   └─ settingsNotifierProvider [first read]
 │   │       ├─ SettingsNotifier(ref)
 │   │       │   ├─ super(StorageService.getSettings())    [SYNC from SP]
 │   │       │   └─ _loadFromDb()                          [ASYNC, one-shot]
 │   │       │       ├─ if (!db.isInitialized) return      [GATE]
 │   │       │       └─ state = parsed from Isar
 │   │       └─ localeProvider [reads settingsNotifierProvider]
 │   │           └─ returns Locale(settings.language)
 │   ├─ routerProvider [first read]
 │   │   └─ GoRouter(initialLocation: '/splash')
 │   ├─ quranStreamerInitProvider [read]
 │   │   └─ background Quran download
 │   └─ MaterialApp.router
 │       └─ renders GoRouter → SplashScreen
 ├─ unawaited(_initNotifications())                    [POST-RUN]
 ├─ unawaited(_initHomeWidget())                       [POST-RUN]
 ├─ unawaited(_initAudioService())                     [POST-RUN, 15s timeout]
 │   └─ AudioService.init() → audioService global
 ├─ unawaited(_initConnectivity())                     [POST-RUN]
 └─ unawaited(_initBackgroundSync())                   [POST-RUN]

SplashScreen
 ├─ _failSafeTimer = 5s                                [ABSOLUTE DEADLINE]
 ├─ _loadDataInBackground()
 │   └─ AppStartupService.run(context).timeout(4s)
 │       ├─ _fireAndForgetPrecache(context)             [images]
 │       ├─ OEMReliabilityService.initialize()          [sync]
 │       ├─ PermissionAnalyticsService.initialize()     [sync]
 │       └─ _warmUpData().timeout(5s)
 │           ├─ DataService.init()                      [~8KB JSON load]
 │           └─ GreetingService.getGreeting()           [sync]
 ├─ min(2000ms, elapsed) wait
 └─ _navigate()
     ├─ settings = ref.read(settingsNotifierProvider)
     ├─ !settings.onboarded → context.go('/onboarding')
     │   └─ PermissionOnboardingScreen
     │       ├─ Screen 0: Welcome
     │       ├─ Screen 1: Permission Center
     │       │   └─ OnboardingNotifier → PermissionRequestController
     │       │       └─ Sequential permission requests
     │       ├─ Screen 2: Finished
     │       └─ _finish()
     │           ├─ markOnboarded() → SP + Isar
     │           └─ context.go('/home')
     └─ settings.onboarded → context.go('/home')
         └─ ShellRoute → HomeShell → HomeScreen
             ├─ LiquidGlassNav (5 tabs)
             ├─ MiniPlayerBar (conditional)
             └─ Content area
```

---

## 17. Recommendations (Observation Only)

These are architectural observations, not action items:

1. **SettingsNotifier should await DB before initial state**: Either make `_loadFromDb()` blocking (await before `super()`) or use a two-phase init pattern where SP provides initial state and DB overwrites asynchronously with proper state management.

2. **GoRouter should use `redirect`**: A redirect function checking `settings.onboarded` would protect against deep-link bypass and provide a single source of truth for routing decisions.

3. **Delete the legacy OnboardingScreen**: It's unreachable dead code with a different visual style and incomplete permission handling.

4. **Delete dead StorageService methods**: `getOnboardingComplete()` / `setOnboardingComplete()` use a separate SP key and are never called.

5. **Make `_initLocalDatabase()` awaited or use a Completer**: Fire-and-forget for the primary data store creates silent degradation paths.

6. **Replace `late AudioHandler audioService` with a lazy-init pattern**: Either use `AudioHandler?` with null checks, or wrap in a `FutureProvider` that guarantees initialization before use.

7. **Add a "settings reconciliation" step**: After DB init completes, compare SP and Isar settings and reconcile (last-write-wins by timestamp, or prefer Isar as source of truth).

---

*End of audit. No files were modified.*

# Rafeeq (رَفِيقْ) — System Architecture

> **Architecture Style**: Feature-First Clean Layering with Cross-Platform Database Duality  
> **Primary Target**: Android Native & Progressive Web App  

---

## 1. High-Level Architectural Flow

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                          1. Presentation Layer                              │
│                                                                             │
│   • Widgets (FloatingDockNav, PremiumNavbar, TasbihHeroCard)                │
│   • Screens (HomeScreen, PremiumQuranHomePage, SvgMushafScreen, etc.)       │
│   • Design System (AppTheme: Midnight Navy + Royal Gold, DsComponents)      │
└──────────────────────────────────────┬──────────────────────────────────────┘
                                       │ Watches / Listens
                                       ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                       2. State Management (Riverpod)                        │
│                                                                             │
│   • StateNotifiers & AsyncNotifiers (SettingsNotifier, PrayerTimeNotifier)  │
│   • Family & Computed Providers (surahProvider, tasbeehStatsProvider)       │
│   • GoRouter Configuration (routerProvider with indexedStack navigation)    │
└──────────────────────────────────────┬──────────────────────────────────────┘
                                       │ Calls
                                       ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                       3. Domain & Repository Layer                          │
│                                                                             │
│   • Entities & DTOs (Memorial, Verse, Hadith, TasbeehItem)                  │
│   • Repositories (PrayerTimeRepository, HadithRepository, MercyRepository)  │
│   • Business Invariants, Islamic Validation, Error Transformations          │
└──────────────────────────────────────┬──────────────────────────────────────┘
                                       │ Coordinates
                                       ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                          4. Core & Services Layer                           │
│                                                                             │
│   • Hardware Services (LocationService, NotificationService, HomeWidget)    │
│   • Audio Handler (QuranAudioHandler running via AudioService)              │
│   • Schedulers (AdhanScheduler, BackgroundSyncService)                      │
│   • Network & Client (ApiClient, ShiaApiClient, Dio, ConnectivityService)   │
└──────────────────────────────────────┬──────────────────────────────────────┘
                                       │ Accesses
                                       ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                         5. Storage & Remote Data Layer                      │
│                                                                             │
│   ┌───────────────────────────────────┐ ┌─────────────────────────────────┐ │
│   │        Local Storage              │ │         Remote Cloud            │ │
│   │  - Isar Database (Android Native) │ │  - Cloud Firestore (Memorials)  │ │
│   │  - SharedPreferences (Web)        │ │  - Firebase Auth                │ │
│   │  - Hive (HTTP Response Cache)     │ │  - EveryAyah Recitation CDN     │ │
│   │  - Asset Bundles (SVG, Duas)      │ │  - ShiaAPI Remote Services      │ │
│   └───────────────────────────────────┘ └─────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 2. Cross-Platform Database Duality (Isar vs Web)

One of Rafeeq's most critical architectural innovations is the compilation barrier between Android and Web:

```
                  ┌──────────────────────────────┐
                  │ LocalDatabaseService (Abstract)│
                  └──────────────┬───────────────┘
                                 │
                 Conditional Import (local_database.dart)
                                 │
           ┌─────────────────────┴─────────────────────┐
           │                                           │
  [dart.library.io]                           [dart.library.html]
           │                                           │
           ▼                                           ▼
┌────────────────────────────┐               ┌───────────────────────────┐
│ IsarDatabaseService        │               │ WebDatabaseService        │
│ • Native C++ engine (Isar) │               │ • SharedPreferences JSON  │
│ • 16 Collections           │               │ • Browser localStorage    │
│ • ACID, Indexes, Fast      │               │ • Safe from FFI crashes   │
└────────────────────────────┘               └───────────────────────────┘
```

### Invariant Rules:
1. **Never** import `package:isar/isar.dart` outside `lib/database/local_database_android.dart` and `lib/database/collections.dart`.
2. Model DTOs exposed to the UI/Domain layer (`database_models.dart`) are 100% free of Isar annotations, ensuring the rest of the application remains database-agnostic.

---

## 3. Background Audio Architecture

Quran recitation requires continuous background playback that survives screen locking and notification management:

```
[UI: FullPlayerScreen / MiniPlayerBar]
          │
          │ User presses play / pause / skip
          ▼
[Riverpod: quranAudioNotifierProvider]
          │
          ▼
[AudioHandler: QuranAudioHandler (lib/features/quran_audio/services/)]
          │
          ├── Updates MediaItem & PlaybackState for Android System Lockscreen
          │
          └── Controls JustAudio AudioPlayer instance
                    │
                    ▼
          [EveryAyah Audio CDN Stream]
```

---

## 4. Android Home Widget Sync

Home widgets communicate across the Flutter/Android process boundary:

1. **Trigger**:
   - App startup or prayer recalculation.
   - Background WorkManager task scheduled every 15–30 minutes.
   - System `BOOT_COMPLETED` broadcast receiver.
2. **Channel**:
   - `HomeWidgetService` serializes current prayer name, time remaining, and Islamic quote into Android `AppWidgetManager` SharedPreferences.
   - Calls `HomeWidget.updateWidget(name: 'DailyIslamicWidgetProvider')`.
3. **Android Native**:
   - `DailyIslamicWidgetProvider.kt` receives broadcast and renders custom `RemoteViews` layouts (`layout/daily_widget_provider.xml`).

---

## 5. Architectural Quality Assessment & Prioritized Roadmap

| Domain | Assessment | Priority | Recommendation |
| :--- | :--- | :--- | :--- |
| **GoRouter Safety** | Clean `routerProvider` without live settings watcher | Solved | Maintain invariant in `AGENTS.md`. |
| **Database Abstraction** | Solid conditional imports for Isar vs Web | Solved | Keep collection schemas aligned in `database_models.dart`. |
| **Accessibility** | Limited Semantics widgets across deep screens | **P1 (High)** | Execute a systematic pass wrapping interactive buttons with semantic labels. |
| **Deprecation Maintenance** | 6 deprecation notices in `svg_mushaf`, `location_service`, etc. | **P2 (Medium)** | Migrate `Vector3.translate` to `translateByVector3` and `desiredAccuracy` to `LocationSettings`. |
| **Hadith Card Audio** | Non-functional audio toggle in `hadith_card.dart` | **P2 (Medium)** | Connect to TTS or clean up UI trigger. |

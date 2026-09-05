# AGENTS.md — The Engineering Constitution for Rafeeq (رَفِيقْ)

> **رَفيِقْ (Rafeeq)** — Islamic Daily Companion Application.
> Designed with luxury, spiritual mindfulness, and technical excellence (Midnight Navy + Royal Gold).
> This document is the permanent engineering constitution for all human and AI software engineers working on Rafeeq.

---

## 1. Project Overview

- **Name**: Rafeeq — رَفِيقْ
- **Purpose**: Provide a reliable, beautiful, privacy-centric, and offline-first Islamic companion for daily worship, Quranic reading/listening, prayer synchronization, dhikr, hadith exploration, and memorial prayers (Mercy Register / سجل الرحمة).
- **Target Audience**: Arabic-speaking Muslims worldwide desiring an ad-free, respectful, battery-efficient, and aesthetically elevated spiritual assistant.
- **Visual Identity**: Midnight Navy (`#06101D` / `#0B1730`), Deep Royal Blue (`#111A33`), and Royal Warm Gold (`#D4AF37` / `#D9B96E`). RTL (Right-to-Left) Arabic first-class interface.

---

## 2. Technology Stack & Environment

| Component | Specification / Reality |
| :--- | :--- |
| **Flutter SDK** | `3.44.1` (Channel stable) |
| **Dart SDK** | `^3.12.1` |
| **State Management** | `flutter_riverpod: ^2.6.1` |
| **Routing / Navigation**| `go_router: ^14.8.1` (`StatefulShellRoute.indexedStack`) |
| **Local Database** | **Isar Community** (`^3.1.0+1`) on Android; **SharedPreferences** (`^2.3.4`) on Web; **Hive** (`^2.2.3`) for network response caching |
| **Islamic Math Engine**| `adhan_dart: ^2.0.1` (Prayer Calculations), `flutter_qiblah: ^3.2.0` (Compass & Kaaba Vector) |
| **Audio Engine** | `audio_service: ^0.18.17` + `just_audio: ^0.9.42` (Foreground service recitation) |
| **Home Widgets** | `home_widget: ^0.9.3` (Native Android AppWidget integration) |
| **Cloud & Backend** | Firebase Core `3.15.2`, Cloud Firestore `5.6.12`, Firebase Auth `5.7.0`, Cloud Functions |
| **Android Targets** | `minSdk = 21`, `targetSdk = 35`, `compileSdk = 35`, Java 21 with Desugaring enabled |
| **Platforms** | Primary: **Android**, Secondary: **Web** (PWA/Firebase Hosting) |

---

## 3. Architecture & Data Flow

Rafeeq enforces a **Feature-First Layered Architecture** with strict cross-platform compilation barriers.

```
┌──────────────────────────────────────────────────────────┐
│                   Presentation Layer                     │
│  Widgets, Screens, Theme Tokens (AppTheme, DsComponents) │
└────────────────────────────┬─────────────────────────────┘
                             │ Watches / Reads
┌────────────────────────────▼─────────────────────────────┐
│                    State Management                      │
│             Riverpod Providers / StateNotifiers          │
└────────────────────────────┬─────────────────────────────┘
                             │ Calls
┌────────────────────────────▼─────────────────────────────┐
│                    Repository Layer                      │
│       Abstractions & Domain Data Coordinators             │
└────────────────────────────┬─────────────────────────────┘
                             │ Interacts with
┌────────────────────────────▼─────────────────────────────┐
│                     Services Layer                       │
│    AdhanScheduler, LocationService, QuranAudioHandler     │
└──────────────┬─────────────────────────────┬─────────────┘
               │                             │
┌──────────────▼─────────────┐ ┌─────────────▼─────────────┐
│      Local Data Layer      │ │     Remote Cloud Layer    │
│  - Isar (Android Native)   │ │  - Cloud Firestore        │
│  - SharedPreferences (Web) │ │  - Firebase Auth          │
│  - Hive (HTTP Cache)       │ │  - ShiaAPI / Audio CDN    │
└────────────────────────────┘ └───────────────────────────┘
```

### Critical Architectural Invariants
1. **Duality of Storage (Isar vs Web)**: Never import `package:isar` directly into shared cross-platform code. Always route through `lib/database/local_database.dart` using conditional compilation (`dart.library.io` vs `dart.library.html`).
2. **GoRouter Rebuild Guard**: Never invoke `ref.watch(settingsProvider)` inside the `routerProvider` definition. Read initial state once or use top-level `refreshListenable` to prevent teardown crashes.
3. **Audio Lifecycle**: Recitation playback must route through the background `AudioHandler` (`quran_audio_handler.dart`) to ensure lock-screen controls and battery preservation.

---

## 4. Directory Map

- `lib/`
  - `api/` & `core/api/`: ShiaAPI and centralized REST client configurations.
  - `core/`: Arabic localization strings (`arabic_strings.dart`), constants, cache managers, failures.
  - `database/`: Cross-platform local persistence abstraction, Isar collections, and migration engines.
  - `features/`: 23 self-contained feature slices (home, quran, prayer_times, qibla, mercy_register, adhkar, tasbeeh, etc.).
  - `models/`: Shared immutable data transfer objects.
  - `providers/`: Root-level Riverpod providers.
  - `routes/`: `app_router.dart` defining indexed stack branches and navigation flows.
  - `services/`: Native hardware bridges (location, notifications, home_widget, adhan_scheduler).
  - `theme/`: Design tokens (`app_theme.dart`), reusable DS components (`ds_components.dart`).
  - `widgets/`: Shared luxury UI components (floating dock nav, premium navbar, tasbih cards).
- `docs/`: Complete technical engineering documentation suite.
- `.agents/`: Agent configurations and skills repository.
- `android/`: Native Gradle project, AppWidget layouts, and Proguard configurations.

---

## 5. Development, Test & Build Commands

### Static Analysis & Lints
```powershell
flutter analyze
```

### Automated Tests
```powershell
# Run all unit and widget tests
flutter test

# Run a specific test suite
flutter test test/widget_test.dart
flutter test test/svg_parse_test.dart
```

### Code Generation & Database
```powershell
# Regenerate Isar / JSON / Freezed models
dart run build_runner build --delete-conflicting-outputs
```

### Running Locally
```powershell
# Run on Android device/emulator
flutter run -d android

# Run on Web (Chrome)
flutter run -d chrome
```

### Production Builds
```powershell
# Android App Bundle (Play Store)
flutter build appbundle --release

# Android APK
flutter build apk --release

# Web production bundle
flutter build web --release
```

---

## 6. Engineering & Coding Rules

1. **Arabic Content Integrity**: Quranic verses, Hadith, and Supplications (Duas) must **NEVER** be altered, hallucinated, abbreviated, or modified. Every religious text must originate from verified static assets or verified authoritative APIs.
2. **RTL Exclusivity**: Rafeeq is a pure Arabic application. All UI labels, dialogue messages, tooltips, and status indicators must be in Arabic. English belongs only in code comments, log messages, and internal identifiers.
3. **No Blind Rewrites**: Never rewrite working services or repositories without concrete proof of failure.
4. **Strict Type Safety**: Prohibit `dynamic` usage unless explicitly interacting with raw unparsed JSON. Always parse into strongly typed DTOs.
5. **No Memory Leaks**: All `StreamSubscription`, `TextEditingController`, `AnimationController`, and `FocusNode` instances must be strictly cancelled or disposed of in `dispose()`.

---

## 7. UI, UX & Design System Rules

1. **Design Tokens**: Always use `AppTheme` colors and spacing tokens. Hardcoded hex colors (`Color(0xFF...)`) outside `app_theme.dart` are prohibited.
2. **Accessibility & Touch Targets**:
   - Every tappable target must meet or exceed **48×48 dp** (`AppTheme.minTouchTarget`).
   - Text size must never fall below **12px** for readable content (exception: secondary badge timestamps at 11px with high contrast).
   - High-contrast text: Use `AppTheme.textPrimary` (White) and `AppTheme.textElevated` on navy surfaces. Never use unreadable faint gray text.
3. **Component State Complete**: Every custom interactive component must handle: Default, Pressed, Focused, Disabled, Loading, Empty, and Error states.
4. **Responsive Boundaries**: Always test layouts across small devices (360dp width) and tablets (up to 960dp width). Use `AdaptivePageContainer` to clamp maximum readable content width.

---

## 8. Security & Privacy Rules

1. **Zero Secret Leaks**: Never commit API keys, private keys, service account credentials, or Firebase administration tokens to Git.
2. **Firestore Least-Privilege**: All Firestore access must follow `firestore.rules`. Enforce schema validation, owner ID matching, and non-negative integer counters.
3. **Local Privacy**: User bookmarks, khatmah history, and tasbih counts must remain securely on-device unless explicitly synced by user intent.
4. **Permissions Sensitivity**: Never request Location or Notification permissions on cold start. Only request permissions in context (e.g., location on Qibla/Prayer Times screen, notifications on Adhan setup) with clear explanatory rationale.

---

## 9. AI Agent Operating Protocol

As an AI engineering agent working on Rafeeq, you must obey the following protocol:

```
UNDERSTAND  ──►  PLAN  ──►  EXECUTE  ──►  VERIFY  ──►  DOCUMENT  ──►  COMMIT
```

1. **Inspect Before Modifying**: Read the actual code and dependencies before writing a single line of changes.
2. **Never Claim Without Evidence**: Never report that a test passed or an analyzer check was clean unless the command actually ran in the terminal and exited with code 0.
3. **Preserve Comments & Docstrings**: Maintain existing architectural documentation, license headers, and docstrings.
4. **Small, Atomic Diffs**: Keep modifications tightly scoped. Avoid incidental formatting changes on unrelated files.
5. **Honor the Constitution**: Every change must adhere to the rules outlined in this `AGENTS.md`.

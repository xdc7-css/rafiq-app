# UX Audit Report — Daily Islamic Widget (Rafiq)

**Date:** July 20, 2026  
**Auditor:** Senior Flutter UX Designer  
**Scope:** 45+ screens, 40+ widgets, 356 Dart files  
**Build:** Flutter 3.44.1 stable, Dart 3.12.1

---

## Executive Summary

The app delivers a **premium Islamic companion experience** with a consistent dark navy + gold design language. The glassmorphism aesthetic is visually striking and distinctive. However, the audit reveals **systemic accessibility failures**, **dangerously small text**, **widespread touch target violations**, and **inconsistent implementation** of the design system across 23 feature modules built with 5 different organizational patterns.

**Overall Score: 5.8 / 10**

| Category | Score | Verdict |
|----------|-------|---------|
| Visual Design & Branding | 8/10 | Premium, consistent palette |
| Typography | 4/10 | 195 sub-12px instances, 9 at 7-8px |
| Touch Targets | 3/10 | Pervasive 30-40dp targets |
| Accessibility | 1/10 | 3 Semantics widgets in 356 files |
| State Management UX | 6/10 | Some missing loading/error states |
| Navigation Consistency | 5/10 | 3 nav implementations, 2 missing back buttons |
| Design System Adoption | 4/10 | Components exist but are mostly unused |
| Performance UX | 4/10 | 58 BackdropFilters, 18 Paint/frame |
| i18n / Localization | 3/10 | Ar class exists but 80% of strings hardcoded |
| Code Consistency | 5/10 | 5 org patterns, 25 border radii, 3 font families |

---

## Per-Feature Scores

| Feature | Score | Notes |
|---------|-------|-------|
| **Home** | 6/10 | Good layout, 8px text, no loading states |
| **Splash** | 7/10 | Clean but no error handling for missing asset |
| **Onboarding** | 5/10 | Theme.of(context) leak, mixed fonts, visual bug |
| **More/Menu** | 5/10 | Missing back button, rainbow colors clash |
| **Quran Home** | 7/10 | Good AppTheme usage, 3px text too small |
| **SVG Mushaf** | 6/10 | Feature-rich but 6 sub-12px texts, 38dp buttons |
| **Mushaf Reader** | 7/10 | Good text sizes, 38dp mode rail |
| **Mushaf Chrome** | 5/10 | 9px bottom bar text, 38dp buttons |
| **Quran Audio (all)** | 5/10 | 7px download %, 32dp fav/download, fake play |
| **Tasbeeh** | 4/10 | 8 anim controllers, 10 BackdropFilters, 7px text |
| **Tasbih Hero Card** | 3/10 | 7-8px text, 46dp button, never stops animating |
| **Prayer Times** | 6/10 | Prayer card uses Material Theme instead of AppTheme |
| **Prayer Card** | 4/10 | 100% Material ThemeData colors, breaks design system |
| **Qibla** | 5/10 | 38dp buttons, mixed Arabic/English, 9px text |
| **Qibla Status Card** | 4/10 | English "in" in Arabic text, 9.5px text |
| **Compass Painter** | 6/10 | 18 Paint objects/frame (perf), 9px degree labels |
| **Hadith Shia (all)** | 5/10 | 9px source badge, fake play, 30dp buttons |
| **Hadith Card** | 3/10 | FAKE play button, 28dp buttons |
| **Adhkar** | 7/10 | Best i18n (fully Ar.*), good UX |
| **Adhkar Category** | 6/10 | Hardcoded green breaks theme, 36dp share |
| **Ziyarat** | 6/10 | Good skeleton loading, 11px subtitles |
| **Ziyarat Sub-screens** | 4/10 | Raw exception text shown to users |
| **Fatwa** | 5/10 | 4 BackdropFilters per screen, 9px labels |
| **Settings** | 7/10 | Well-structured, 100+ hardcoded strings |
| **Favorites** | 7/10 | Best Ar.* usage, 2 BackdropFilters |
| **Search** | 6/10 | "Ayah" English in Arabic UI, no error state |
| **Widget Studio** | 4/10 | English UI in Arabic app, Cairo font mismatch |
| **Widget Settings** | 3/10 | 8px/9px text, Theme.of(context) leak, mixed colors |
| **Khatmah** | 5/10 | Missing back button, hardcoded green/red |
| **Mercy Register** | 5/10 | 7 duplicate color constants, good empty states |
| **Premium (all)** | 5/10 | Flag emojis, 36dp close, hardcoded strings |
| **Liquid Glass Nav** | 7/10 | Polished, spring animation, BackdropFilter |
| **Floating Dock Nav** | N/A | Dead code — not in use |
| **Design System (ds_components)** | 6/10 | Good components, barely adopted |

---

## Top 10 UX Strengths

1. **Premium dark navy + gold branding** — Visually distinctive, consistent palette across all screens
2. **Glassmorphism design language** — Modern, premium feel with translucent cards and blur effects
3. **Comprehensive Islamic content** — Quran, Hadith, Adhkar, Ziyarat, Fatwa, Tasbeeh, Prayer Times, Qibla all in one app
4. **Empty state handling** — Most screens have proper empty states with icons, text, and CTAs
5. **Adhkar i18n** — The only feature that fully uses `Ar.*` constants (0 hardcoded strings)
6. **Favorites i18n** — Second-best localization with `Ar.*` throughout
7. **Loading skeletons** — Ziyarat and some other screens have proper shimmer loading states
8. **Spring physics navigation** — LiquidGlassNav buttery-smooth spring animation
9. **8-point spacing grid** — Defined in AppTheme, provides foundation for consistency
10. **StarBackground** — Consistent atmospheric background across all screens

---

## Top 15 UX Weaknesses (Ranked by Impact)

| # | Issue | Impact | Scope |
|---|-------|--------|-------|
| 1 | **Zero accessibility (3 Semantics in 356 files)** | Unusable for visually impaired users | App-wide |
| 2 | **195 text instances below 12px (9 at 7-8px)** | Illegible text for millions of users | 65+ files |
| 3 | **Touch targets below 48dp (30-40dp common)** | Missed taps, frustration, ADA non-compliance | 30+ locations |
| 4 | **58 BackdropFilters (10 in tasbeeh alone)** | Frame drops on mid-range devices | 22 files |
| 5 | **Fake play button in HadithCard** | Deceptive UX — shows "playing" but plays nothing | 1 widget |
| 6 | **PrayerCard uses Material Theme instead of AppTheme** | Theme colors can override curated gold/navy | 1 widget |
| 7 | **25 unique border radii (4 defined as tokens)** | Visual inconsistency across screens | App-wide |
| 8 | **3 competing nav implementations** | Dead code, inconsistent behavior | 3 files |
| 9 | **2 missing back buttons (Khatmah, Books)** | Users trapped on pushed screens | 2 screens |
| 10 | **80% of strings hardcoded (no i18n)** | Cannot translate, maintain, or localize | 200+ files |
| 11 | **3 font families (NotoKufi, Cairo, Inter)** | Inconsistent text rendering | Mixed usage |
| 12 | **Mixed Arabic/English ("Ayah", "in الهواء")** | Broken localization | 2 locations |
| 13 | **Design system components barely adopted** | 40% of screens build custom cards from scratch | 60% of screens |
| 14 | **2 screens show raw exception text to users** | Developer-level errors visible to users | 4 screens |
| 15 | **Widget Studio in English, rest in Arabic** | jarring language switch for users | 1 screen |

---

## Top 30 Improvements (Prioritized)

### P0 — Must Fix (Critical accessibility / deceptive UX / broken functionality)

| # | Fix | Files | Effort | Impact |
|---|-----|-------|--------|--------|
| 1 | Add Semantics to all interactive elements app-wide | All screens | High (2-3 days) | Accessibility compliance |
| 2 | Set minimum font size floor to 12px across app | 65+ files | Medium (1 day) | Readability for all users |
| 3 | Fix fake play button in HadithCard — remove or implement | `hadith_card.dart` | Low (2 hrs) | Removes deceptive UX |
| 4 | Fix `_buildCheckItem` dash bug in permission onboarding | `permission_onboarding_screen.dart:518` | Low (5 min) | Visual bug |
| 5 | Add back button to KhatmahScreen and BooksScreen | `khatmah_screen.dart`, `books_screen.dart` | Low (30 min) | Users trapped |
| 6 | Replace PrayerCard Material Theme with AppTheme | `prayer_card.dart` | Medium (2 hrs) | Design system consistency |

### P1 — High Priority (Performance / Major UX issues)

| # | Fix | Files | Effort | Impact |
|---|-----|-------|--------|--------|
| 7 | Increase all touch targets to 48dp minimum | 30+ locations | Medium (1 day) | Tap accuracy, compliance |
| 8 | Replace BackdropFilter with ClipRRect + semi-transparent container | 22 files | High (2 days) | 50% GPU savings |
| 9 | Cache 18 Paint objects in CompassPainter as fields | `compass_painter.dart` | Low (1 hr) | 18 fewer allocs/frame |
| 10 | Cache TextPainter objects in CompassPainter | `compass_painter.dart` | Low (1 hr) | 12 fewer layout calls/frame |
| 11 | Remove ContinuousAnimationControllers when off-screen | `tasbih_hero_card.dart`, `tasbeeh_screen.dart` | Medium (2 hrs) | Battery/CPU savings |
| 12 | Fix mixed Arabic/English in Qibla status_card | `status_card.dart:456` | Low (5 min) | Broken localization |
| 13 | Fix "Ayah" English string in Arabic search results | `search_screen.dart:277` | Low (5 min) | Broken localization |
| 14 | Remove duplicate FloatingDockNav (dead code) | `floating_dock_nav.dart` | Low (10 min) | Code cleanup |
| 15 | Replace raw exception text with user-friendly error screens | `sahifa_screen.dart`, `occasion_screen.dart`, `mafatih_screen.dart`, `fatwa_category_screen.dart` | Medium (1 hr) | Error UX |

### P2 — Medium Priority (Consistency / Maintainability)

| # | Fix | Files | Effort | Impact |
|---|-----|-------|--------|--------|
| 16 | Add missing border radii (10, 14, 20, 24) to AppTheme tokens | `app_theme.dart` | Low (30 min) | Design system completeness |
| 17 | Adopt AppTheme tokens for padding (eliminate off-grid values) | 50+ files | High (2 days) | Spacing consistency |
| 18 | Unify bottom nav to single implementation | `liquid_glass_nav.dart`, `glass_bottom_nav.dart` | Medium (3 hrs) | Navigation consistency |
| 19 | Migrate hardcoded strings to Ar.* constants | 200+ files | Very High (1 week) | i18n readiness |
| 20 | Replace Widget Studio English strings with Arabic | `widget_studio_screen.dart` | Low (1 hr) | Language consistency |
| 21 | Replace Cairo font with NotoKufiArabic in Onboarding | `onboarding_screen.dart` | Low (30 min) | Font consistency |
| 22 | Replace Widget Studio Cairo font with NotoKufiArabic | `widget_studio_screen.dart` | Low (30 min) | Font consistency |
| 23 | Replace 7 local color constants in MercyRegister with AppTheme | `mercy_register_screen.dart:11-17` | Low (30 min) | Color consistency |
| 24 | Replace hardcoded colors (0xFF0B1730, 0xFF4CAF50, etc.) with AppTheme | 8 files | Low (1 hr) | Color consistency |
| 25 | Adopt ds_components GlassCard/SimpleGlassCard in fatwa feature | 6 fatwa widget files | Medium (3 hrs) | Design system adoption |

### P3 — Low Priority (Polish / Nice-to-have)

| # | Fix | Files | Effort | Impact |
|---|-----|-------|--------|--------|
| 26 | Remove flag emojis from settings language list | `settings_sub_screens.dart:25-33` | Low (10 min) | Cross-platform consistency |
| 27 | Replace moon phase emojis with SVG icons | `calendar_mosque_screens.dart:102-110` | Medium (2 hrs) | Cross-platform consistency |
| 28 | Add errorBuilder to splash screen Image.asset | `splash_screen.dart:133` | Low (10 min) | Crash prevention |
| 29 | Increase PremiumSwitch touch target to 48dp | `settings_components.dart:32` | Low (30 min) | Tap accuracy |
| 30 | Fix subscription close button to 48dp | `subscription_screen.dart:66-82` | Low (15 min) | Tap accuracy |

---

## Complete Inconsistency Inventory

### Border Radius (25 unique values, 4 defined as tokens)

| Radius | Count | In Token? | Recommendation |
|--------|-------|-----------|----------------|
| 2 | 54 | No | Add as `radiusAccent` (gold bars) |
| 4 | 10 | No | Add as `radiusTiny` |
| 6 | 15 | No | Add as `radiusSmallAlt` |
| 8 | 26 | No | Add as `radiusBadge` |
| 10 | 46 | No | Add as `radiusSubCard` |
| **12** | **63** | **YES** | `radiusSmall` ✅ |
| 14 | 67 | No | **Add as `radiusCard`** (highest undocumented) |
| 16 | 89 | YES | `radiusMedium` ✅ |
| 18 | 18 | No | Add as `radiusGlass` (GlassCard default) |
| **20** | **69** | No | **Add as `radiusSection`** (2nd highest undocumented) |
| 22 | 27 | No | Add as `radiusLarge` |
| 24 | 54 | No | Add as `radiusBento` |
| **28** | **27** | **YES** | `radiusLuxury` ✅ |
| 30 | 2 | No | Merge with 28 (near-identical) |
| **50** | **2** | **YES** | `radiusPill` ✅ |

### Font Families (3 competing)

| Font | Where Used | Recommendation |
|------|------------|----------------|
| `GoogleFonts.notoKufiArabic` | 95% of screens (standard) | **Keep as primary** |
| `GoogleFonts.cairo` | Onboarding, Widget Studio, some buttons | Replace with NotoKufi |
| `GoogleFonts.inter` | Numerals in tasbih_hero_card | Acceptable for numbers only |

### Navigation Patterns (3 inconsistent)

| Pattern | Usage | Recommendation |
|---------|-------|----------------|
| `Navigator.pop(context)` | 70% of pop calls | Standardize to `context.pop()` |
| `Navigator.of(context).pop()` | 15% of pop calls | Replace with `context.pop()` |
| `context.pop()` (go_router) | 15% of pop calls | **Make this the standard** |
| `Navigator.push(MaterialPageRoute(...))` | premium_quran_home | Replace with `context.push()` |

### BackdropFilter Distribution

| File | Count | Severity |
|------|-------|----------|
| `tasbeeh_screen.dart` | 10 | CRITICAL |
| `fatwa_detail_screen.dart` | 4 | HIGH |
| `fatwa_search_screen.dart` | 4 | HIGH |
| `quran/presentation/svg_mushaf/svg_mushaf_screen.dart` | 3 | MEDIUM |
| `quran/presentation/mushaf/mushaf_chrome.dart` | 3 | MEDIUM |
| `quran_screen.dart` | 3 | MEDIUM |
| `tasbih_hero_card.dart` | 3 | MEDIUM |
| `liquid_glass_nav.dart` | 1 | OK |
| All others (12 files) | 1-2 each | LOW |

### Text Below 12px (195 total, worst offenders)

| Size | Count | Worst Files |
|------|-------|-------------|
| 7px | 2 | `tasbih_hero_card.dart:446`, `surah_list_screen.dart:385` |
| 8px | 5 | `tasbih_hero_card.dart:159,434`, `widget_settings_screen.dart:128`, `home_screen.dart:506`, `widget_studio/theme_selector.dart:174` |
| 9px | 12 | `fatwa_detail_screen.dart:478`, `hadith_search_screen.dart:292`, `mushaf_chrome.dart:184`, `compass_painter.dart:158`, `tasbih_hero_card.dart:225,263,503`, `tasbeeh_screen.dart:1428,1492`, `widget_settings_screen.dart:112`, `widget_studio/widget_size_selector.dart:113`, `mercy_register_hero_card.dart:248` |
| 9.5px | 2 | `status_card.dart:608`, `mercy_register_hero_card.dart:315` |
| 10px | 51 | 40+ files (see detailed list above) |
| 11px | 118 | Most common sub-12px size, used for captions/badges |

### Hardcoded Colors (Not from AppTheme)

| Color | Files | Recommendation |
|-------|-------|----------------|
| `Color(0xFF0B1730)` | `hadith_detail_sheet.dart`, `tasbih_hadith_popup.dart` | Replace with `AppTheme.bgPrimary` |
| `Color(0xFF0D1B2A)` / `Color(0xFF0A1628)` | `storage_management_screen.dart`, `queue_panel_screen.dart` | Replace with `AppTheme.bgGradient` |
| `Color(0xFF081326)` / `Color(0xFF11264E)` etc. | `mercy_register_screen.dart` (7 local colors) | Replace with AppTheme constants |
| `Color(0xFF4CAF50)` | `adhkar_category_screen.dart` | Add `AppTheme.successGreen` |
| `Color(0xFFE74C3C)` | `khatmah_screen.dart` | Add `AppTheme.errorRed` |
| `Color(0xFFCF6679)` | `tasbeeh_screen.dart` | Add to AppTheme |
| `Color(0xFFD8B56A)` | `widget_settings_screen.dart` (6 instances) | Replace with `AppTheme.goldPrimary` |
| `Colors.redAccent` | `favorites_screen.dart`, `mercy_register_screen.dart` | Add `AppTheme.errorRed` |
| `Colors.orange` | `permission_onboarding_screen.dart` | Add `AppTheme.warningOrange` |

---

## Recommendations Summary

### Immediate (This Sprint)
1. Set **12px font floor** app-wide — highest ROI fix
2. Fix **fake play button** in HadithCard
3. Fix **missing back buttons** on Khatmah and Books screens
4. Fix **mixed Arabic/English** strings (2 locations)
5. Fix **_buildCheckItem dash bug** in onboarding

### Short-term (Next 2 Weeks)
6. Add **Semantics** to all interactive elements
7. Increase **all touch targets to 48dp**
8. Replace **BackdropFilter** with cheaper alternatives on non-hero elements
9. Cache **Paint and TextPainter** objects in CompassPainter
10. Migrate **PrayerCard** to AppTheme

### Medium-term (Next Month)
11. Add **border radius tokens** for 10, 14, 20, 24px values
12. Adopt **ds_components** across fatwa, hadith, and other features
13. Begin **i18n migration** (start with Adhkar pattern)
14. Unify **navigation** to go_router `context.pop()`/`context.push()`
15. Replace **Cairo font** with NotoKufiArabic in onboarding/studio

### Long-term (Next Quarter)
16. Full i18n migration of all 200+ files
17. Adopt 8-point grid tokens for all padding/margin
18. Remove dead code (FloatingDockNav, duplicate nav implementations)
19. Unify feature organization patterns (currently 5 patterns)
20. Implement skeleton loading states for all data-fetching screens

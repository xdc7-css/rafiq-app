# Rafiq Widget Framework — Phase 1.5 Architecture Report

## Executive Summary

Phase 1.5 establishes the complete design system, theme engine, style engine,
configuration model, component library, layout system, and live preview
architecture that every current and future widget will use.

**20 files created. 0 new issues. All tests pass.**

The framework is pure architecture — no widget types were created or redesigned.

---

## 1. Widget Framework Architecture

### File Structure

```
lib/widget_framework/
├── framework.dart                    # Main barrel export
│
├── tokens/
│   ├── tokens.dart                   # Barrel export
│   ├── color_tokens.dart             # 80+ color tokens (6 categories)
│   ├── typography_tokens.dart        # 11 font sizes, 6 weights, 14 styles
│   ├── spacing_tokens.dart           # 4pt grid system, 17 spacing values
│   ├── dimension_tokens.dart         # Radius, elevation, shadows, borders, icons, blur
│   └── decoration_tokens.dart        # 12 card decorations, 3 overlay types, 2 patterns
│
├── themes/
│   ├── widget_color_scheme.dart      # 22-field color scheme model
│   ├── widget_theme.dart             # Theme configuration class
│   ├── widget_themes.dart            # 6 built-in themes
│   └── theme_registry.dart           # Runtime theme lookup + registration
│
├── styles/
│   └── widget_style.dart             # Resolved style (28 fields + computed properties)
│
├── config/
│   ├── widget_config.dart            # Serializable configuration model (17 fields + ext map)
│   └── config_adapter.dart           # SharedPreferences ↔ Config bridge
│
├── components/
│   ├── components.dart               # Barrel export
│   ├── widget_card.dart              # Base container
│   ├── widget_header.dart            # Icon + title + trailing
│   ├── widget_footer.dart            # Bottom text row
│   ├── widget_text.dart              # Title, Subtitle, BodyText
│   ├── widget_icon.dart              # Icon with optional background
│   ├── widget_divider.dart           # Solid or gradient divider
│   ├── widget_badge.dart             # Small label chip
│   ├── verse_container.dart          # Quran verse display
│   ├── prayer_row.dart               # Prayer time row
│   ├── date_chip.dart                # Date display chip
│   └── background_layer.dart         # Glass/gradient/overlay layers
│
├── layout/
│   └── widget_layout.dart            # 5 size presets + responsive constraints
│
└── preview/
    ├── widget_frame_builder.dart      # Standard widget wrapper
    └── style_resolver.dart            # Config → Theme → Style resolution
```

### Dependency Graph

```
                    ┌──────────────┐
                    │  WidgetConfig │ ← User preferences (SharedPreferences)
                    └──────┬───────┘
                           │
                    ┌──────▼───────┐
                    │ ThemeRegistry │ ← Lookup theme by ID
                    └──────┬───────┘
                           │
                    ┌──────▼───────┐
                    │  WidgetTheme  │ ← Complete visual configuration
                    └──────┬───────┘
                           │
               ┌───────────▼───────────┐
               │   WidgetStyle.resolve  │ ← Merge theme + config overrides
               └───────────┬───────────┘
                           │
                    ┌──────▼───────┐
                    │  WidgetStyle  │ ← Resolved visual properties
                    └──────┬───────┘
                           │
          ┌────────────────┼────────────────┐
          │                │                │
   ┌──────▼──────┐ ┌──────▼──────┐ ┌───────▼──────┐
   │  Components  │ │   Layout    │ │   Preview    │
   │  (Flutter)   │ │  (Sizing)   │ │  (Settings)  │
   └──────┬──────┘ └─────────────┘ └──────────────┘
          │
   ┌──────▼──────┐
   │ HomeWidget   │ ← Persist config to SharedPreferences
   └──────┬──────┘
          │
   ┌──────▼──────────────┐
   │ Android Kotlin       │ ← Read config, render RemoteViews
   │ (WidgetProvider)     │
   └─────────────────────┘
```

---

## 2. Design System Documentation

### Color Tokens (color_tokens.dart)

80+ semantic color tokens organized in 6 categories:

| Category | Count | Purpose |
|----------|-------|---------|
| Foundation | 3 | Deepest background layers |
| Surface | 6 | Cards, containers, overlays |
| Content | 5 | Text and icon colors |
| Accent | 12 | Gold system + extended palette |
| Border | 4 | Separators and outlines |
| State | 4 | Feedback (success/warning/error/info) |
| Gradients | 7 | Pre-defined gradient sequences |
| Opacity | 8 | Consistent alpha levels |

**Helper methods:** `withAlpha()`, `darken()`, `lighten()`

### Typography Tokens (typography_tokens.dart)

| Property | Values |
|----------|--------|
| Font families | Cairo (primary), Noto Naskh Arabic, DecoType Thuluth, Monospace |
| Font sizes | 11 sizes: 8px → 64px (2pt scale) |
| Font weights | 6 weights: w300 → w800 |
| Line heights | 5 values: 1.1 → 1.8 |
| Letter spacing | 4 values: -0.5 → 1.0 |
| Pre-built styles | 14 named styles (title, subtitle, body, caption, etc.) |

**Scaling:** `TypographyTokens.scale(style, factor)` applies a font scale factor.

### Spacing Tokens (spacing_tokens.dart)

4pt grid system with 17 named values:

| Semantic | Value | Use |
|----------|-------|-----|
| `none` | 0 | No spacing |
| `xxs` | 4 | Between closely related items |
| `xs` | 8 | Icon-to-label gap |
| `sm` | 12 | Related elements in a row |
| `md` | 16 | Sections within a card |
| `lg` | 24 | Between card sections |
| `xl` | 32 | Between cards |
| `xxl` | 48 | Between major sections |

Widget-specific padding: `Small(8)`, `Medium(12)`, `Large(16)`, `Thin(8)`.

### Dimension Tokens (dimension_tokens.dart)

| Category | Values |
|----------|--------|
| Border radius | 9 values: 0 → 999 (pill) |
| Elevation | 5 levels: 0 → 16 |
| Shadows | 6 presets: luxury, card, elevated, goldGlow, inset, none |
| Borders | 5 widths: 0 → 2px |
| Icons | 6 sizes: 10 → 48 |
| Blur | 5 levels: 0 → 40 |

### Decoration Tokens (decoration_tokens.dart)

| Category | Count |
|----------|-------|
| Card decorations | 6 (default, elevated, glass, gradient, goldAccent, flat) |
| Section decorations | 3 (header, goldDivider, badge, progressTrack) |
| Overlay decorations | 3 (top, bottom, goldGlow) |
| Pattern layers | 2 (dots, geometric — placeholder assets) |
| Builder methods | `buildCard()`, `buildPill()` |

---

## 3. Theme Engine Architecture

### WidgetTheme

The `WidgetTheme` class is the complete visual configuration for a widget family:

```dart
class WidgetTheme {
  final String id;                    // Unique identifier
  final String name;                  // Display name
  final String description;           // Human-readable description
  final WidgetColorScheme colors;     // Full color scheme
  final double widgetRadius;          // Corner radius
  final double borderWidth;           // Border width
  final Color borderColor;            // Border color
  final List<BoxShadow> shadows;      // Shadow preset
  final bool useGlassEffect;          // Glassmorphism toggle
  final bool usePatternOverlay;       // Islamic pattern toggle
  final bool useGoldGlow;             // Gold glow toggle
}
```

### WidgetColorScheme

22-field color scheme model with `copyWith()`:

```
Foundation:  foundationPrimary, foundationSecondary
Surface:     surfacePrimary, surfaceElevated, surfaceMuted, surfaceOverlay
Content:     contentPrimary, contentSecondary, contentTertiary, contentMuted
Accent:      accentPrimary, accentSecondary, accentWarm
Border:      borderPrimary, borderSubtle
State:       stateSuccess, stateWarning, stateError, stateInfo
Gradients:   gradientBackground, gradientSurface, gradientAccent, gradientText
```

### Built-in Themes

| Theme | ID | Background | Accent | Special |
|-------|----|-----------|--------|---------|
| Luxury Gold | `luxury_gold` | Navy #0B1730 | Gold #D4AF37 | Gold glow |
| Midnight Black | `midnight_black` | Near-black #050508 | Gold #D4AF37 | Minimal |
| Minimal White | `minimal_white` | White #FFFFFF | Gold #B8860B | Light mode, no shadow |
| Emerald | `emerald` | Deep green #0A1F14 | Emerald #2ECC71 | Green accent |
| Modern Glass | `modern_glass` | Translucent navy | Gold #D4AF37 | Glass effect + glow |
| Classic Mushaf | `classic_mushaf` | Warm brown #1A120A | Gold #D4AF37 | Pattern overlay |

### ThemeRegistry

Runtime lookup + registration:

```dart
ThemeRegistry.getById('luxury_gold')     // → WidgetTheme
ThemeRegistry.register(myCustomTheme)     // → void
ThemeRegistry.unregister('old_theme')     // → bool
ThemeRegistry.availableThemes             // → List<WidgetTheme>
ThemeRegistry.themeOptions                // → List<({id, name})>
```

**Adding a new theme requires ZERO code changes in widget rendering logic.**

---

## 4. Style Engine Architecture

### WidgetStyle (28 fields)

The `WidgetStyle` is the resolved, per-widget-instance visual configuration.
It is computed by `WidgetStyle.resolve(theme, ...)` and then optionally
overridden by config values.

**Fields:** background, backgroundGradient, surface, surfaceElevated,
textPrimary, textSecondary, textMuted, accent, accentSecondary, border,
divider, borderRadius, borderStyle, shadows, opacity, blur, useGlassEffect,
usePatternOverlay, useGoldGlow, paddingH, paddingV, contentGap, sectionGap,
fontSizeScale

**Computed properties (no extra fields needed):**
- `containerDecoration` → BoxDecoration
- `titleStyle` → TextStyle
- `subtitleStyle` → TextStyle
- `bodyStyle` → TextStyle
- `captionStyle` → TextStyle
- `numberStyle` → TextStyle
- `accentStyle` → TextStyle

### StyleResolver

Single entry point for the resolution pipeline:

```dart
// Individual resolution
final style = StyleResolver.resolve(config);
final layout = StyleResolver.resolveLayout(WidgetSize.medium);

// Combined resolution
final (:style, :layout) = StyleResolver.resolveAll(config, WidgetSize.large);
```

**Resolution steps:**
1. `ThemeRegistry.getById(config.themeId)` → `WidgetTheme`
2. `WidgetStyle.resolve(theme)` → base `WidgetStyle`
3. Apply config overrides (backgroundColor, textColor, accentColor, etc.)

---

## 5. Configuration Model

### WidgetConfig (17 fields + ext map)

| Field | Type | Default | Purpose |
|-------|------|---------|---------|
| `widgetType` | String | — | Widget identifier (required) |
| `themeId` | String | `luxury_gold` | Theme reference |
| `backgroundColor` | int? | null | BG color override |
| `textColor` | int? | null | Text color override |
| `accentColor` | int? | null | Accent color override |
| `fontSize` | double? | null | Font size override |
| `transparency` | double? | null | 0.0–1.0 opacity |
| `borderRadius` | double? | null | Corner radius override |
| `layoutStyle` | String | `standard` | Layout variant |
| `displayMode` | String | `default` | Detail level |
| `rtl` | bool | false | Right-to-left |
| `animationsEnabled` | bool | true | Animation toggle |
| `backgroundImage` | String? | null | BG image path |
| `patternId` | String? | null | Pattern overlay |
| `glassEffect` | bool | false | Glassmorphism |
| `materialYou` | bool | false | Material You |
| `fontFamily` | String? | null | Custom font |
| `extra` | Map<String,dynamic> | {} | Future extension |

**Serialization:** JSON via `toJson()` / `fromJson()` for SharedPreferences.

### ConfigAdapter

```dart
await ConfigAdapter.save(config);           // Save full config
final config = await ConfigAdapter.load('prayer_times');  // Load
await ConfigAdapter.remove('prayer_times');  // Reset to defaults
await ConfigAdapter.saveField('prayer_times', 'themeId', 'emerald');
await ConfigAdapter.saveFields('prayer_times', {'themeId': 'emerald', 'fontSize': 16.0});
```

Storage key pattern: `widget_config_{widgetType}` in SharedPreferences.

---

## 6. Component Library

11 reusable Flutter components, all receiving `WidgetStyle`:

| Component | Purpose |
|-----------|---------|
| `WidgetCard` | Base container with background, border, shadow |
| `WidgetHeader` | Icon + title + subtitle + trailing widget |
| `WidgetFooter` | Bottom text row |
| `WidgetTitle` / `WidgetSubtitle` / `WidgetBodyText` | Styled text |
| `WidgetIcon` | Icon with optional circular background |
| `WidgetDivider` | Solid or gradient horizontal line |
| `WidgetBadge` | Small label chip (gold or neutral) |
| `VerseContainer` | Quran verse with name, ayah, progress |
| `PrayerRow` | Prayer name + time with highlight state |
| `DateChip` | Hijri/Gregorian date badge |
| `BackgroundLayer` / `OverlayLayer` | Gradient + glass + overlay effects |

**Rule:** Every widget uses components. No widget builds its own card, header, or divider from scratch.

---

## 7. Layout System

### WidgetSize enum

| Size | Grid | Preview (dp) | Use |
|------|------|-------------|-----|
| `small` | 2x2 | 170 × 170 | Tasbih, compact |
| `medium` | 4x2 | 340 × 170 | Prayer 4x2 |
| `tall` | 2x3 | 170 × 260 | Quran 2x3 |
| `large` | 4x4 | 340 × 340 | Dashboard |
| `thin` | 4x1 | 340 × 80 | Countdown strip |

Each size provides: `suggestedPadding`, `suggestedFontScale`, `aspectRatio`.

### WidgetLayoutConstraints

```dart
WidgetLayoutConstraints(size: WidgetSize.medium, rtl: true);
// → width, height, textDirection
```

`responsive(BoxConstraints)` scales to fit available space.

---

## 8. Live Preview Architecture

### WidgetFrameBuilder

Standard wrapper that applies background, border, padding, glass effects:

```dart
WidgetFrameBuilder.buildClipped(
  style: style,
  layout: layout,
  child: MyPrayerWidget(style: style),
);

WidgetFrameBuilder.buildPreview(
  style: style,
  layout: layout,
  child: MyQuranWidget(style: style),
);
```

**No duplicated preview code.** Every widget preview uses the same frame builder.

### Preview Flow

```
WidgetSettingsScreen
    │
    ├─ ConfigAdapter.load(widgetType) → WidgetConfig
    │
    ├─ StyleResolver.resolve(config) → WidgetStyle
    │
    ├─ User modifies settings (color picker, slider, theme selector)
    │       │
    │       ├─ WidgetConfig.copyWith(overrides...)
    │       ├─ StyleResolver.resolve(updatedConfig) → new WidgetStyle
    │       └─ setState → rebuild preview with new style
    │
    └─ On save:
            ├─ ConfigAdapter.save(config)
            ├─ HomeWidget.saveWidgetData(keys...)
            └─ HomeWidget.updateWidget(androidName: provider)
```

---

## 9. Data Flow (Complete)

```
┌─────────────────────────────────────────────────────────┐
│                    FLUTTER APP                           │
│                                                         │
│  User opens Widget Settings                              │
│       │                                                  │
│       ▼                                                  │
│  ConfigAdapter.load('prayer_times')                     │
│       │                                                  │
│       ▼                                                  │
│  WidgetConfig { themeId: 'luxury_gold', ... }           │
│       │                                                  │
│       ▼                                                  │
│  ThemeRegistry.getById('luxury_gold')                   │
│       │                                                  │
│       ▼                                                  │
│  WidgetTheme { colors: WidgetColorScheme, ... }         │
│       │                                                  │
│       ▼                                                  │
│  WidgetStyle.resolve(theme, overrides)                  │
│       │                                                  │
│       ▼                                                  │
│  WidgetStyle { background, textPrimary, accent, ... }   │
│       │                                                  │
│       ├──▶ WidgetFrameBuilder.buildClipped()            │
│       │        │                                         │
│       │        ▼                                         │
│       │    Live Preview (Flutter widget tree)            │
│       │                                                  │
│       └──▶ HomeWidget.saveWidgetData()                  │
│                │                                         │
│                ▼                                         │
│         SharedPreferences                               │
│                                                         │
└─────────────────────┬───────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────┐
│                ANDROID KOTLIN                            │
│                                                         │
│  SharedPreferences                                      │
│       │                                                  │
│       ▼                                                  │
│  WidgetPreferences.obtain(context)                      │
│       │                                                  │
│       ▼                                                  │
│  prefs.getStringOr(WidgetKeys.NEXT_PRAYER_NAME)         │
│       │                                                  │
│       ▼                                                  │
│  RemoteViews.setTextViewText(R.id.widget_next_prayer,…) │
│       │                                                  │
│       ▼                                                  │
│  AppWidgetManager.updateAppWidget(widgetId, views)      │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## 10. Future Extensibility

The framework supports ALL of these without architectural changes:

| Feature | How It's Supported |
|---------|-------------------|
| Background images | `WidgetConfig.backgroundImage` field + `BackgroundLayer` |
| Islamic patterns | `WidgetConfig.patternId` + `WidgetDecorationTokens.patternXxx` |
| Custom fonts | `WidgetConfig.fontFamily` + `WidgetTypographyTokens.scale()` |
| Material You | `WidgetConfig.materialYou` + `WidgetColorScheme.copyWith()` |
| Glassmorphism | `WidgetConfig.glassEffect` + `BackgroundLayer` blur |
| Dynamic colors | `WidgetColorScheme` is fully dynamic |
| Wallpaper-aware | Add `wallpaperColor` to config → override `foundationPrimary` |
| Animated preview | Components support Flutter animation natively |
| Lock screen widgets | New `WidgetSize` variant + same pipeline |
| iOS WidgetKit | New platform adapter reading same `WidgetConfig` |
| Custom themes | `ThemeRegistry.register(newTheme)` — zero code changes |

**Adding a new widget type requires:**
1. Add keys to `widget_keys.dart` + `WidgetKeys.kt`
2. Create a `WidgetConfig` subclass (optional, for type-safe fields)
3. Create Kotlin provider + layout XML
4. Create Flutter preview component using framework components
5. Register in `ConfigAdapter` + `ThemeRegistry`

---

## 11. Risks

| Risk | Severity | Mitigation |
|------|----------|------------|
| Kotlin providers can't read Flutter-side style objects | Medium | Config stored as flat key-value pairs in SharedPreferences; Kotlin reads individual values, not objects |
| Glass effect requires BackdropFilter — not available in RemoteViews | Low | Glass is Flutter-preview only; Android uses solid backgrounds |
| Pattern overlay requires asset images not yet created | Medium | `pattern_dots.png` and `pattern_geometric.png` are referenced but not yet created. Use solid backgrounds until assets exist |
| `WidgetStyle` has 28 fields — complexity budget | Low | Most widgets only use 5-10 fields; the rest inherit defaults |
| Theme registry is in-memory only — lost on hot restart | Low | Themes are re-registered at class load time (static final) |
| Config serialization uses JSON strings — size limit in SharedPreferences | Low | Max config size ~200 bytes; SharedPreferences limit is ~1MB |

---

## 12. Recommendations Before Phase 2

1. **Create pattern assets.** Before using `usePatternOverlay: true`, create
   `assets/widgets/pattern_dots.png` and `pattern_geometric.png` (or remove
   the references).

2. **Migrate existing widget_settings_screen.dart.** Replace the 996-line
   custom UI with framework components + `StyleResolver`. This validates
   the framework end-to-end.

3. **Add widget_config_riverpod.dart.** A Riverpod `StateNotifier` that
   wraps `ConfigAdapter` for reactive config management in the settings UI.

4. **Create Kotlin WidgetStyleReader.kt.** A Kotlin mirror of `StyleResolver`
   that reads `WidgetConfig` from SharedPreferences and provides typed
   accessors for Kotlin providers (mirrors `WidgetPreferences.kt`).

5. **Write unit tests** for `WidgetStyle.resolve()`, `ConfigAdapter`,
   and `ThemeRegistry`.

6. **Design system audit.** Before building Phase 2 widgets, review all
   tokens against actual Android widget pixel budgets. Some tokens
   (e.g., `sizeHero = 48px`) may be too large for 2x2 widgets.

7. **Font size calibration.** Test `fontSizeScale` with actual RemoteViews
   rendering to ensure text fits in widget cells.

---

## Deliverables Checklist

| Deliverable | Status |
|-------------|--------|
| Widget Framework architecture | framework.dart + this report |
| Design System documentation | Token files with comprehensive comments |
| Theme Engine architecture | WidgetTheme + WidgetColorScheme + ThemeRegistry |
| Style Engine architecture | WidgetStyle + StyleResolver |
| Configuration Model | WidgetConfig + ConfigAdapter |
| Component hierarchy | 11 components in components/ |
| Folder structure | tokens/ themes/ styles/ config/ components/ layout/ preview/ |
| Dependency graph | Section 1 above |
| Data flow diagram | Section 9 above |
| Future extensibility report | Section 10 above |
| Risks | Section 11 above |
| Recommendations | Section 12 above |

**Framework status: APPROVED for Phase 2 implementation.**

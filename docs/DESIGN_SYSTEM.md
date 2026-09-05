# Rafeeq (رَفِيقْ) — Design System & Visual Identity

> **Style**: Luxury Islamic Minimalist (Midnight Navy & Royal Warm Gold)  
> **Direction**: RTL (Right-to-Left Arabic First-Class)  
> **Source of Truth**: `lib/theme/app_theme.dart` & `lib/theme/ds_components.dart`  

---

## 1. Color Palette

The color system is engineered to convey tranquility, reverent grandeur, and high visual contrast (WCAG AA compliant).

### Primary Luxury Midnight Navy
- `navyDeep`: `#06101D` (Deep abyss background, status bar)
- `navyBase`: `#081728` (Standard screen backdrop)
- `navyMid`: `#0D1E36` (Section containers, grouped surfaces)
- `navyLight`: `#12284A` (Elevated interactive surfaces)
- `bgPrimary`: `#0B1730` (Core primary background token)
- `bgCard`: `#16233E` (Standard card surface)
- `bgSurface`: `#1B2946` (Lifted sheet and dialog surface)

### Royal Accent Gold
- `goldPrimary`: `#D4AF37` (Iconic royal gold for primary badges, active icons, borders)
- `goldWarm`: `#D9B96E` (Warm accent for illuminated typography)
- `goldBright`: `#E5C97F` (Highlighted countdowns and active radio dials)
- `goldLight`: `#F0D896` (Subtle glow and soft accents)
- `goldSecondary`: `#C99A1A` (Gradients and pressed state transitions)

### Neutral & Contrast Hierarchy
- `textPrimary`: `#FFFFFF` (100% white, titles, critical data, Quran ayah text)
- `textElevated`: `#D4DBE7` (High-contrast secondary body copy)
- `textMutedPremium`: `#AEB8C8` (Subtitles, metadata, timestamps)
- `textDisabled`: `rgba(255, 255, 255, 0.60)` (Inactive options)
- `borderGold`: `rgba(212, 175, 55, 0.20)` (Standard card border)
- `borderSubtle`: `rgba(212, 175, 55, 0.10)` (Separators and dividers)

---

## 2. Typography & Fonts

Rafeeq uses three curated typefaces loaded from `assets/fonts/`:

| Family | Asset Path | Usage Role |
| :--- | :--- | :--- |
| **Cairo** | `assets/fonts/Cairo-Variable.ttf` | Primary UI typeface: navigation labels, buttons, headers, numbers, and settings. |
| **Noto Naskh Arabic** | `assets/fonts/NotoNaskhArabic-Regular.ttf` | Long-form Islamic reading: Hadith bodies, Duas, Mafatih supplications, Tafsir. |
| **DecoType Thuluth** | `assets/fonts/decotype-thuluth-iii.ttf` | Decorative sacred titles, Surah name headers, celebratory greetings (الأعياد والمناسبات). |

### Typography Scale
- **Display Large**: 28–32sp / Bold (Hero prayer countdown, Surah title)
- **Title Large**: 20–22sp / SemiBold (Screen headers, section banners)
- **Title Medium**: 16–18sp / Medium (Card titles, Tasbih count indicator)
- **Body Large**: 14–15sp / Regular (Hadith text, dua passages)
- **Body Medium**: 12–13sp / Regular (Standard descriptions, category subtitles)
- **Caption / Badge**: 11–12sp / Medium (High-contrast timestamps, status tags)
- **Rule**: No interactive or readable text may render below **12sp** on primary screens.

---

## 3. Spacing Scale & 8-Point Grid

- `sp4`: 4dp (Micro padding, badge vertical spacing)
- `sp8`: 8dp (Compact icon-to-label gap)
- `sp12`: 12dp (Sub-element margin)
- `sp16`: 16dp (Standard card interior padding)
- `sp20`: 20dp (Standard card outer margin)
- `sp24`: 24dp (Page horizontal margin `pageMarginH`)
- `sp32`: 32dp (Section separation `sectionGap`)
- `sp48`: 48dp (Minimum interactive touch target `minTouchTarget`)

---

## 4. Component State Matrix

Every core design system component must support the complete lifecycle state matrix:

```
┌─────────────┬──────────────────────────────────────────────────────────────┐
│ State       │ Visual Treatment Specification                               │
├─────────────┼──────────────────────────────────────────────────────────────┤
│ Default     │ Gradient Navy card, borderGold at 20% opacity, crisp shadow  │
│ Hover (Web) │ Border opacity rises to 40%, subtle scale (1.01x)            │
│ Pressed     │ Haptic feedback, gold overlay at 8% opacity, scale (0.98x)   │
│ Focused     │ 2px solid gold focus ring with 4dp offset                    │
│ Disabled    │ 40% overall opacity, pointer events disabled                 │
│ Loading     │ Shimmer skeleton using shimmer token (Navy base to Navy light)│
│ Error       │ Crimson accent border (`#E53935`), retry action button       │
│ Empty       │ Elegant Islamic geometric illustration + explanatory Arabic   │
└─────────────┴──────────────────────────────────────────────────────────────┘
```

---

## 5. Signature Luxury Components

1. **FloatingDockNav (`lib/widgets/floating_dock_nav.dart`)**:
   - Elevated pill-shaped dock navigation floating above bottom edge with glassmorphism blur and gold active indicator.
2. **TasbihHeroCard (`lib/widgets/tasbih_hero_card.dart`)**:
   - Circular progression meter with glowing gold counter beads and instant haptic feedback.
3. **PrayerTimesCards (`lib/widgets/prayer_times_cards.dart`)**:
   - Time badges displaying current vs upcoming prayers with dynamic astronomical icons (Fajr dawn, Dhuhr sun, Maghrib crescent).
4. **AdaptivePageContainer (`lib/widgets/adaptive_page_container.dart`)**:
   - Centers content and clamps maximum width on tablets (`760dp`) and desktop (`960dp`) to maintain optimal line length.

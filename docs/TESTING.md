# Rafeeq (رَفِيقْ) — Testing Strategy & Quality Assurance

> **Standard**: Zero Fake Tests. Only tests validating genuine religious, mathematical, and architectural invariants.  
> **Framework**: `flutter_test`, `integration_test`  

---

## 1. The Practical Testing Pyramid

```
                ┌─────────────────────────────┐
                │    Real Device Validation   │
                │  (Android Phone / Web Chrome│
                └──────────────┬──────────────┘
                               │
                ┌──────────────▼──────────────┐
                │      Integration Tests      │
                │   (GoRouter flows, DB sync) │
                └──────────────┬──────────────┘
                               │
                ┌──────────────▼──────────────┐
                │        Widget Tests         │
                │ (SvgPicture, TasbihHeroCard)│
                └──────────────┬──────────────┘
                               │
                ┌──────────────▼──────────────┐
                │         Unit Tests          │
                │ (Prayer math, Arabic search)│
                └─────────────────────────────┘
```

---

## 2. Test Execution Commands

```powershell
# Run the entire test suite
flutter test

# Run a specific unit/widget test
flutter test test/svg_parse_test.dart
flutter test test/widget_test.dart

# Run with coverage report
flutter test --coverage
```

---

## 3. Core Test Scenarios

### 1. Astronomical Calculation Tests (`adhan_dart`)
- **Equator and High Latitudes**: Verify prayer times calculation for Mecca ($21.42^\circ\text{ N}$), Cairo ($30.04^\circ\text{ N}$), London ($51.50^\circ\text{ N}$), and Oslo ($59.91^\circ\text{ N}$).
- **DST Transition**: Ensure clock changes do not shift prayer times backwards or produce negative intervals.

### 2. Arabic Search & Normalization (`arabic_search.dart`)
- Verify normalization of Alef variants (`أ`, `إ`, `آ` $\to$ `ا`), Taa Marbuta (`ة` $\to$ `ه`), and removal of Tashkeel (diacritics: Fatha, Damma, Kasra, Sukun).
- Ensure searching `الرحمن` matches `الرَّحْمَٰنِ`.

### 3. SVG Mushaf Parsing & Vector Rendering (`svg_parse_test.dart`)
- Verify that `assets/quran-svg/` coordinate paths parse cleanly into `SvgPicture` objects without throwing unhandled XML or viewBox exceptions.

### 4. Database Schema Migrations (`data_migrator.dart`)
- Test legacy `SharedPreferences` key-value pairs migrating into modern Isar 16-collection schema on Android startup.

---

## 4. Quality Rules for AI Agents

1. **Never mock religious text**: Unit tests must use canonical verses and hadith.
2. **Never claim a test passed without execution**: Always cite terminal output showing exit code 0 and total test duration.
3. **No skipped tests without documentation**: `@Skip()` is prohibited unless an associated tracked GitHub issue is explicitly linked in the test description.

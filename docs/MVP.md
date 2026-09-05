# Rafeeq (رَفِيقْ) — MVP Capabilities Matrix

> Independent, testable capabilities breakdown of Rafeeq. Every module defines its user goal, inputs/outputs, state machine, data sources, offline behavior, edge cases, and acceptance criteria.

---

## 1. Prayer Times (أوقات الصلاة)
- **Status**: `CURRENT`
- **User Goal**: Know precise prayer times for Fajr, Sunrise, Dhuhr, Asr, Maghrib, and Isha with time remaining until next prayer.
- **Inputs**: Device GPS coordinates (lat/lng), calculation method setting, Asr juristic rule, higher latitude adjustment.
- **Outputs**: Calculated prayer times, current prayer name, next prayer countdown timer, adhan audio triggers.
- **UI**: `PrayerTimesScreen`, `PremiumHeroSection`, home prayer countdown card.
- **State**: `AsyncValue<PrayerTimesState>` via Riverpod `prayerTimeProvider`.
- **Data Source**: Local computation via `adhan_dart` library; geocoding via `geocoding` / `geolocator`.
- **Offline Behavior**: 100% offline. Computes purely using mathematical astronomical formulas based on coordinates and clock.
- **Edge Cases**: Polar regions, midnight transitions, daylight saving time (DST) shifts, GPS permission denied (falls back to cached location or default holy city coordinates).
- **Acceptance Criteria**:
  - Countdown ticks every second accurately.
  - Calculation completes in < 5ms without blocking the UI thread.
  - Correct prayer highlights automatically as time elapses.

---

## 2. Quran & SVG Mushaf (القرآن الكريم والمصحف)
- **Status**: `CURRENT`
- **User Goal**: Read the Noble Quran in crisp Arabic typography with ayah markers, page navigation, audio recitation, and bookmarks.
- **Inputs**: Surah number, ayah number, page index (1–604), recitation speed, selected reciter.
- **Outputs**: Rendered vector Mushaf page (`SvgMushafScreen`), ayah highlight bounding boxes, audio recitation stream.
- **UI**: `PremiumQuranHomePage`, `SvgMushafScreen`, `FullPlayerScreen`, `MiniPlayerBar`.
- **State**: `QuranState`, `AudioPlayerState` (`quran_audio_providers.dart`).
- **Data Source**: Local vector JSON / SVG assets (`assets/quran-svg/json/`, `assets/data/quran/`), audio streaming from EveryAyah CDN.
- **Offline Behavior**: Text and pages are fully offline. Streamed recitations require internet unless previously cached via `StorageManagementScreen`.
- **Edge Cases**: High zoom pinch gesture, rapid page flipping, network interruption during audio buffering.
- **Acceptance Criteria**:
  - Pages 1 through 604 load cleanly without layout overflows.
  - Bookmarks persist to Isar/SharedPreferences.
  - Audio syncs playback state with lock screen notifications via `audio_service`.

---

## 3. Azkar & Supplications (الأذكار والأدعية)
- **Status**: `CURRENT`
- **User Goal**: Recite morning, evening, sleep, and post-prayer dhikr with counter tap tracking and completion status.
- **Inputs**: Taps on card, category selector (morning, evening, travel, etc.).
- **Outputs**: Visual counter decrement/increment, progress bar percentage, haptic feedback on completion.
- **UI**: `AdhkarScreen`, `AdhkarCategoryScreen`, `AzkarProgressSection`.
- **State**: `adhkarProvider` managing category lists and counter maps.
- **Data Source**: Local JSON files (`assets/data/duas/`, `assets/data/mafatih/`, `assets/data/sahifa/`).
- **Offline Behavior**: 100% offline. All text bundled within assets.
- **Edge Cases**: Overflow text in long supplications, rapid continuous tapping.
- **Acceptance Criteria**:
  - Haptic feedback fires on each tap and double haptic fires on completion.
  - Daily completion state resets at midnight.

---

## 4. Digital Tasbih (المسبحة الإلكترونية)
- **Status**: `CURRENT`
- **User Goal**: Count praises with digital beads, specifically Tasbeeh Fatima Al-Zahra (34 Allahu Akbar, 33 Alhamdulillah, 33 SubhanAllah) and custom targets.
- **Inputs**: Screen taps, reset button, counter mode selector.
- **Outputs**: Total count, cycle count, vibration feedback, visual bead animations.
- **UI**: `TasbeehScreen`, `TasbihHeroCard`.
- **State**: `tasbeehProvider`, `tasbeehStatsProvider`, `tasbihAlZahraProvider`.
- **Data Source**: Isar `TasbeehItem` collection (Android) or SharedPreferences (Web).
- **Offline Behavior**: 100% offline.
- **Edge Cases**: Exceeding target count, power loss during active counting session.
- **Acceptance Criteria**:
  - Auto-switches phase in Tasbeeh Fatima Al-Zahra after 34 $\to$ 33 $\to$ 33.
  - Session counts are committed to local database asynchronously without frame drops.

---

## 5. Qibla Compass (اتجاه القبلة)
- **Status**: `CURRENT`
- **User Goal**: Determine the exact direction of the Holy Kaaba in Mecca from anywhere on Earth.
- **Inputs**: Device magnetometer sensor, accelerometer, GPS coordinates.
- **Outputs**: Kaaba heading angle, compass dial rotation, deviation angle indicator, haptic pulse upon true Kaaba alignment.
- **UI**: `QiblaScreen` with gold compass rose and Kaaba icon.
- **State**: `qiblaProvider` streaming sensor events.
- **Data Source**: `flutter_qiblah` plugin + `geolocator`.
- **Offline Behavior**: Works offline provided GPS lock or cached coordinates exist and magnetometer is operational.
- **Edge Cases**: Magnetic interference (uncalibrated sensor), devices lacking hardware compass (graceful error warning displayed).
- **Acceptance Criteria**:
  - Calibrated status displayed when sensor needs 8-figure calibration motion.
  - Smooth 60fps needle rotation using tween animation.

---

## 6. Mercy Register (سجل الرحمة)
- **Status**: `CURRENT`
- **User Goal**: Create deceased memorial profiles (أموات المسلمين) and dedicate Quranic recitations, prayers, and charity on their behalf.
- **Inputs**: Deceased name, date of death, relationship, dedication type (`prayer`, `surahRecitation`, `dua`, `tasbeeh`).
- **Outputs**: Collective dedication counters, recent prayers ledger, search results.
- **UI**: `MercyRegisterScreen`, `MemorialDetailsScreen`, `AddMemorialScreen`, `PremiumMemorialCard`.
- **State**: Firestore real-time snapshots through repository streams.
- **Data Source**: Cloud Firestore (`memorials`, `rewards` collections).
- **Offline Behavior**: Offline read cache via Firestore offline persistence; additions queue and sync once online.
- **Edge Cases**: Duplicate names, malicious or offensive names, network drops during dedication transaction.
- **Acceptance Criteria**:
  - Security rules enforce validation: non-empty names ($\le 120$ chars), non-negative integer counters.
  - Dedications update aggregate count atomically.

---

## 7. Android Home Widgets (ودجت الشاشة الرئيسية)
- **Status**: `CURRENT`
- **User Goal**: View the current prayer countdown, next prayer time, and Islamic quote without opening the app.
- **Inputs**: Scheduled background worker, app lifecycle triggers.
- **Outputs**: Updated Android RemoteViews AppWidget.
- **UI**: Native Android layout XML (`daily_widget_provider.xml`).
- **State**: Managed by `HomeWidgetService` and background `AdhanScheduler`.
- **Data Source**: Isar / SharedPreferences and `adhan_dart`.
- **Offline Behavior**: 100% offline. Computes local prayer times.
- **Edge Cases**: Battery optimization killing background worker, device reboot (listened via `BOOT_COMPLETED` receiver).
- **Acceptance Criteria**:
  - Widget reflects current prayer state accurately throughout the day.
  - Tapping widget opens Rafeeq directly to the relevant screen.

---

## 8. Planned & Future Capabilities

| Feature | Target | Description |
| :--- | :--- | :--- |
| **Wear OS Companion** | `PLANNED` | Standalone smartwatch tile for Tasbeeh and prayer alerts. |
| **Multi-Language Tafsir** | `PLANNED` | English and Urdu translation layers alongside Arabic original. |
| **Audio Offline Pack Manager**| `PLANNED` | One-tap download of entire Surahs or Juzz for zero-network travel. |
| **Mosque Finder** | `FUTURE` | Nearby mosques locator with congregation timings. |

# Rafeeq (رَفِيقْ) — Data Architecture & Persistence

> **Strategy**: Local Offline-First Dual Engine with Cloud Ledger Synchronization  
> **Engines**: Isar Community (Native Android), SharedPreferences (Web PWA), Hive (Cache), Cloud Firestore (Memorial Ledger)  

---

## 1. Storage Architecture Overview

```
                      ┌────────────────────────────┐
                      │    Data Coordinator Layer   │
                      │  (Repositories & Services) │
                      └─────────────┬──────────────┘
                                    │
       ┌────────────────────────────┼───────────────────────────┐
       ▼                            ▼                           ▼
┌──────────────┐             ┌──────────────┐            ┌──────────────┐
│  Structured  │             │  Key-Value   │            │ Remote Cloud │
│  Persistence │             │  & HTTP Cache│            │  Sync Ledger │
└──────┬───────┘             └──────┬───────┘            └──────┬───────┘
       │                            │                           │
  [Platform]                  [Hive Engine]               [Firestore]
       ├── Android: Isar             └── hive_cache_manager      └── Memorials
       └── Web: SharedPreferences                                └── Rewards
```

---

## 2. The 16 Local Collections (Isar & DTO Models)

Rafeeq manages 16 structured collections in `lib/database/collections.dart` mirrored by pure Dart DTOs in `lib/database/models/database_models.dart`:

1. `BookmarkItem`: Saved verses, Quran page markers, timestamp, and user tags.
2. `KhatmahItem`: Active and completed Quran reading plans (target days, current page, daily quota).
3. `TasbeehItem`: Counters for specific praises (Allahu Akbar, SubhanAllah, Istighfar, custom dhikr).
4. `TasbeehRecord`: Historical daily audit log of dhikr counts for spiritual analytics.
5. `AdhkarProgress`: Today's completion state for morning, evening, sleep, and prayer azkar.
6. `FavoriteItem`: User-favorited hadiths, ziyarats, and verses.
7. `DailyLogItem`: Spiritual habits tracker (prayers attended, Quran read, fasting, charity).
8. `UserSettingsItem`: Local configuration (prayer juristic method, adhan sound choice, theme variant).
9. `PrayerAdjustmentItem`: Manual minute offsets (+/- minutes) per individual prayer time.
10. `CachedHadith`: Stored hadiths for offline browsing without network.
11. `CachedZiyarat`: Offline Mafatih and Sahifa supplications.
12. `CachedFatwa`: Juristic rulings cached from authoritative sources.
13. `OfflineAudioMeta`: Track metadata, file paths, reciter IDs for downloaded audio.
14. `MemorialDraft`: Locally drafted memorials prior to cloud publishing.
15. `WidgetCustomization`: Colors, opacity, font size, and layout flags for home screen widgets.
16. `SearchHistoryItem`: Recent search queries in Quran, Hadith, and Duas.

---

## 3. Web Persistence Abstraction (`WebDatabaseService`)

Because Isar requires native C++ dynamic libraries (which do not run on browser WebAssembly/JS), `WebDatabaseService` provides an equivalent interface powered by `SharedPreferences`:

- Encodes collections into JSON strings under namespaced keys (e.g., `rafiq_isar_bookmarks_v1`).
- Uses in-memory caching with asynchronous flushing to browser `localStorage`.
- Ensures zero compile-time or runtime errors on Flutter Web builds.

---

## 4. Network Cache Manager (`HiveCacheManager`)

For volatile HTTP requests (ShiaAPI hadith lists, reciter directory manifests, Quran audio catalogs):
- **Engine**: Hive (`core/cache/hive_cache_manager.dart`).
- **TTL Support**: Entries store a Unix epoch expiry; expired items are refreshed in the background.
- **Cache Eviction**: Automatically bounds cache size to avoid unbounded disk growth on mobile.

---

## 5. Cloud Firestore Data Schema (`Mercy Register`)

Cloud data is governed by strict rules in `firestore.rules`:

### Collection: `memorials/{memorialId}`
```json
{
  "id": "uuid-string",
  "userId": "firebase-auth-uid",
  "deceasedName": "string (1-120 chars)",
  "searchName": "normalized lowercase arabic string",
  "dateOfDeath": "ISO-8601 string",
  "type": "deathAnniversary | death | generalPrayer | ongoing",
  "isPublic": true,
  "prayerCount": 1420,
  "duaCount": 850,
  "khatmahCount": 12,
  "tasbeehCount": 3500,
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

### Collection: `rewards/{rewardId}` (Immutable Audit Ledger)
```json
{
  "id": "uuid-string",
  "memorialId": "referenced-memorial-id",
  "userId": "contributor-auth-uid",
  "type": "prayer | surahRecitation | dua | charity | quranKhatmah | tasbeeh",
  "count": 10,
  "points": 50,
  "createdAt": "timestamp"
}
```
*Note: Firestore rules enforce `allow update, delete: if false;` on rewards to maintain an immutable prayer ledger.*

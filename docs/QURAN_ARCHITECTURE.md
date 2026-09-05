# Rafeeq (رَفِيقْ) — Quran Architecture & SVG Vector Mushaf Engine

> **Core Engine**: Vector Graphics + Pre-rendered SVG Ayah Coordinates + Background Audio Service  
> **Mushaf Standard**: 604 Pages (Standard Madani Mushaf layout)  

---

## 1. Vector SVG Mushaf Architecture

To ensure razor-sharp calligraphy at any device resolution without downloading 500MB+ raster image files, Rafeeq uses an asset-driven SVG vector system:

```
┌────────────────────────────────────────────────────────┐
│              assets/quran-svg/json/{page}.json         │
│  - Raw SVG coordinate paths for calligraphy lines      │
│  - Surah banners and ornamental headers                │
│  - Ayah end markers and verse numbers                  │
└───────────────────────────┬────────────────────────────┘
                            │ Parsed & Compiled
                            ▼
┌────────────────────────────────────────────────────────┐
│             lib/features/quran/presentation/           │
│                   svg_mushaf_screen.dart               │
│                                                        │
│  • CustomPainter & SvgPicture rendering pipeline       │
│  • Interactive gesture zoom & pan (InteractiveViewer)  │
│  • Tap detection on ayah coordinate bounding boxes     │
└───────────────────────────┬────────────────────────────┘
                            │ Selected Ayah Tap
                            ▼
┌────────────────────────────────────────────────────────┐
│          Ayah Action Bar: Recite, Bookmark, Tafsir     │
└────────────────────────────────────────────────────────┘
```

### Performance Optimizations:
1. **Asset Chunking**: Rather than loading the entire Quran into memory, pages are streamed from assets on-demand using page virtual scrolling.
2. **Pre-caching Neighboring Pages**: When on page $N$, pages $N-1$ and $N+1$ are pre-loaded in memory for stutter-free page turning.

---

## 2. Background Recitation Audio Pipeline

The audio subsystem is engineered to comply with Android foreground service requirements:

```
               ┌───────────────────────────┐
               │    Audio Reciter Catalog  │
               │ (Minshawi, Abdulbasit,    │
               │  Mishary, Al-Ghamdi, etc.)│
               └─────────────┬─────────────┘
                             │
                             ▼
               ┌───────────────────────────┐
               │    QuranAudioHandler      │
               │ (implements BaseAudioHandler)
               └─────────────┬─────────────┘
                             │
               ┌─────────────┴─────────────┐
               ▼                           ▼
┌─────────────────────────────┐ ┌─────────────────────────────┐
│    JustAudio Player Core    │ │   Android System MediaSession│
│ • Streams ayah MP3 chunks   │ │ • Lock screen notifications │
│ • Gapless ayah transition   │ │ • Bluetooth car controls    │
│ • Local file caching        │ │ • Headphone unplug pause    │
└─────────────────────────────┘ └─────────────────────────────┘
```

---

## 3. Storage & Offline Recitation Management

- Recited ayahs can be streamed live from CDN (`EveryAyah.com`) or downloaded locally for travel.
- `StorageManagementScreen` (`lib/features/quran_audio/presentation/storage_management_screen.dart`) allows users to inspect storage consumption per reciter and delete downloaded Surahs to reclaim device space.
- Bookmarks and last-read page pointers persist in the local database (`BookmarkItem` in Isar/Web).

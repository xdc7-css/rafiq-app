# Rafeeq (رَفِيقْ) — Product Brief

> **Version**: 3.5.0  
> **Status**: Active Production & Continuous Evolution  
> **Lead Architecture**: Flutter Mobile & Web  

---

## 1. Executive Summary & Vision

**Rafeeq (رَفِيقْ)** is an elevated, luxury Islamic companion designed to be an indispensable daily sanctuary for modern Muslims. Unlike cluttered, ad-heavy alternatives, Rafeeq prioritizes serene visual aesthetics, uncompromising respect for sacred texts, deep battery and memory efficiency, and an offline-first architecture. 

It provides an integrated spiritual ecosystem: hyper-accurate prayer calculations, an authentic SVG vector Quran with recitation audio, daily adhkar and tasbeeh tracking, Qibla compass alignment, authoritative Shia & Sunni hadith repositories, home screen widgets, and a unique collective memorial ledger known as the **Mercy Register (سجل الرحمة)**.

---

## 2. Target Audience & Personas

1. **The Daily Devout (المواظب اليومي)**:
   - Uses the app multiple times a day for prayer notifications, morning/evening adhkar, and daily Quran reading.
   - Values fast launch times, reliable offline adhan alerts, and instant widget access on their Android home screen.
2. **The Quran Student & Reciter (القارئ المرتل)**:
   - Reads the Quran in pristine calligraphy, bookmarks verses, listens to world-renowned reciters, and organizes personal Khatmahs (ختمة القرآن).
3. **The Spiritual Commuter (المسافر / المتنقل)**:
   - Needs accurate GPS/compass Qibla direction, dynamic prayer times for changing cities, and zero dependence on high-speed internet.
4. **The Memorial Benefactor (صاحب سجل الرحمة)**:
   - Creates and contributes prayers, surahs, and recitations on behalf of deceased loved ones through the community ledger.

---

## 3. Core Philosophy & Guiding Principles

- **Offline-First Resilience**: All core Islamic functionality (Quran text, prayer math, Azkar, Hadith collections, and local tasbeeh) functions completely without internet connectivity.
- **Sacred Content Integrity**: Absolute zero tolerance for typos, truncation, or synthetic modification of verses and hadith.
- **Ad-Free Sanctity**: No intrusive banner ads, interstitial popups, or commercial distractions during worship.
- **Visual Nobility**: Built upon the Midnight Navy & Royal Warm Gold design system, exuding calmness, dignity, and modern Islamic heritage.
- **Battery Respect**: Background jobs (Adhan, WorkManager, Widgets) run with minimal CPU wakeups and efficient OS alarms.

---

## 4. Scope Taxonomy

### Must Have (P0 — Core Invariants)
- [x] Offline prayer calculation (`adhan_dart`) with dynamic calculation methods (Shia Ithna Ashari, Umm Al-Qura, Muslim World League, etc.).
- [x] Vector SVG Mushaf page renderer with crisp scaling at any DPI.
- [x] Interactive digital Tasbeeh counter (Tasbeeh Fatima Zahra and custom counters) with haptic feedback.
- [x] Daily Adhkar with progression indicators and target counts.
- [x] Compass-driven Qibla finder with magnetic sensor compensation.
- [x] Native Android AppWidget showing current prayer, countdown, and daily inspiration.
- [x] Background Audio Recitation with lock-screen media controls (`audio_service` + `just_audio`).
- [x] Strict data persistence across app restarts (Isar on native, SharedPreferences on web).

### Should Have (P1 — High-Value Spiritual Experience)
- [x] **Mercy Register (سجل الرحمة)**: Community memorial profiles and good deed dedications backed by Firestore.
- [x] Khatmah Planner: Tracking completion progress across days or months.
- [x] Hadith Library: Categorized collections with Arabic text search.
- [x] Ziyarat & Duas: Mafatih al-Jinan and Sahifa Sajjadiyya authentic texts.
- [x] Audio Reciter Browser: Streaming and offline caching of multiple prestigious reciters.

### Nice to Have (P2 — Extended Experience)
- [x] Widget Studio: Customization of card colors, transparency, and typography for home widgets.
- [ ] Multi-lingual Quran translations (English, French, Urdu) side-by-side.
- [ ] Wear OS companion app for rapid dhikr and prayer times.

### Out of Scope
- Commercial banner monetization or third-party ad networks.
- Social feeds, comment sections, or unmoderated chat channels.

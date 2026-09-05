# Rafeeq (رَفِيقْ) — User Experience (UX) Architecture

> **Focus**: Spiritual Serenity, Arabic RTL First-Class UX, Single-Thumb Ergonomics, and Tactile Mindfulness  

---

## 1. Ergonomic Principles

Islamic daily companion apps are frequently accessed on the go, during mosque prayers, before sleep, and immediately upon waking. Rafeeq's UX is designed around:

1. **Single-Thumb Zone**: All primary actions (Tasbih counting, audio play/pause, tab navigation, bookmarking) are situated in the bottom 40% of the screen.
2. **Glanceability**: The Home hero card communicates the single most critical piece of information at any given moment: **Which prayer is next and how much time remains?**
3. **Spiritual Reverence (No Jarring Interruptions)**: Zero loud modal popups or aggressive prompts during sacred reading.
4. **Haptic Tactility**: Subtle, crisp haptic pulses on Tasbeeh clicks recreate the mechanical tactile satisfaction of traditional prayer beads without requiring the user to look at the screen.

---

## 2. Navigation Architecture (`FloatingDockNav`)

Rafeeq uses an elevated, floating bottom dock (`lib/widgets/floating_dock_nav.dart`):

```
┌────────────────────────────────────────────────────────┐
│                        Screen Body                     │
│                                                        │
│                                                        │
│   ┌────────────────────────────────────────────────┐   │
│   │ [الرئيسية]  [القرآن]  [الزيارات]  [الحديث]  [المزيد] │   │
│   └────────────────────────────────────────────────┘   │
└────────────────────────────────────────────────────────┘
```

- **Home (الرئيسية)**: Daily prayer card, next adhan countdown, daily verse, quick tasbeeh, today's adhkar progress.
- **Quran (القرآن)**: Surah list, Juzz index, SVG Mushaf reader, audio player.
- **Ziyarat (الزيارات)**: Mafatih al-Jinan and Sahifa Sajjadiyya supplications with night reading mode.
- **Hadith (الحديث)**: Categorized prophetic and Ahl al-Bayt narrations with copy/share actions.
- **More / Settings (المزيد)**: Qibla compass, Mercy Register, Khatmah planner, Widget Studio, Adhan notification health.

---

## 3. Audio Player Drawer UX

The audio player operates on a two-tier model:
1. **MiniPlayerBar**: Floats above the bottom dock when recitation is active. Provides play/pause, surah/ayah title, and swipe-up gesture to expand.
2. **FullPlayerScreen**: Fullscreen modal drawer featuring surah artwork, ayah scrubber, reciter selection dropdown, repeat mode, and audio queue management.

---

## 4. UI/UX Audit Findings & Actionable Recommendations

Following our audit using modern UI/UX guidelines:

| Area | Current Issue | UX Impact | Recommended Solution | Priority |
| :--- | :--- | :--- | :--- | :--- |
| **Touch Targets** | Some icon buttons in audio header measure $< 48\times 48\text{dp}$ | Difficult tapping on small screens | Wrap with `minTouchTarget` (48dp) or `DsIconButton` | **P1 (High)** |
| **Micro Text** | Sub-12px text instances on secondary metadata | Hard to read for elders & outdoor sunlight | Set 12sp minimum floor across all cards | **P1 (High)** |
| **Hadith Audio** | Play icon in `HadithCard` toggles state without audio playback | User confusion; feels like a broken feature | Remove mock button or hook up to speech synthesizer | **P2 (Medium)** |
| **Empty States** | Some search screens show plain empty box | User feels uncertain if search completed | Add decorative Islamic calligraphic empty state | **P2 (Medium)** |
| **Screen Readers**| Missing `Semantics` tags on custom icon buttons | Screen reader cannot describe prayer cards | Add `Semantics(label: ..., button: true)` | **P1 (High)** |

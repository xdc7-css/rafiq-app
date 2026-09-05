# Rafeeq (رَفِيقْ) — Home Screen Widget Architecture

> **Framework**: `home_widget: ^0.9.3`  
> **Native Platform**: Android AppWidget framework (`AppWidgetProvider`)  
> **Customization Studio**: `lib/features/widget_studio/` & `lib/features/widget_settings/`  

---

## 1. Widget Lifecycle & Data Pipeline

Android AppWidgets do not execute Flutter engine code directly on the home screen launcher. Instead, Flutter renders/serializes data to native Android storage, and Android native `RemoteViews` layouts display the content.

```
┌────────────────────────────────────────────────────────┐
│                      Flutter App                       │
│                                                        │
│  1. Prayer times calculated by adhan_dart              │
│  2. Serialized to Map<String, dynamic>                 │
│  3. Written via HomeWidget.saveWidgetData()            │
│  4. HomeWidget.updateWidget(name: 'DailyWidget')       │
└───────────────────────────┬────────────────────────────┘
                            │ MethodChannel IPC
                            ▼
┌────────────────────────────────────────────────────────┐
│             Android Native SharedPreferences           │
│                 (FlutterSharedPreferences)             │
└───────────────────────────┬────────────────────────────┘
                            │ Broadcast Intent
                            ▼
┌────────────────────────────────────────────────────────┐
│       DailyIslamicWidgetProvider (Kotlin / Java)       │
│                                                        │
│  • Reads prayer keys: 'prayer_name', 'time_left'       │
│  • Inflates RemoteViews (layout/daily_widget.xml)      │
│  • AppWidgetManager.updateAppWidget() pushes to launcher│
└────────────────────────────────────────────────────────┘
```

---

## 2. Background Updates & Battery Preservation

1. **Adhan Trigger**: When `AdhanScheduler` reaches a prayer transition, it triggers a widget data refresh in the background.
2. **WorkManager Periodic Work**: Scheduled via Android WorkManager every 15–30 minutes to update countdown minutes even if the app has not been opened all day.
3. **Boot Receiver**: `android.intent.action.BOOT_COMPLETED` re-schedules widget sync jobs after device restart.

---

## 3. Widget Studio (استوديو الودجت)

Rafeeq features a dedicated customization studio allowing users to tailor their home screen widget:
- **Background Themes**: Solid Midnight Navy, Glassmorphism, Deep Gold border, Transparent mode.
- **Opacity Slider**: 20% to 100% surface transparency for wallpaper harmony.
- **Content Selection**:
  - Mode 1: Next prayer time with countdown.
  - Mode 2: Full 5 daily prayer schedule grid.
  - Mode 3: Daily Quranic verse and Hadith inspiration.
  - Mode 4: Quick-tap Tasbeeh counter widget.

# 🕌 هيكل المشروع — Daily Islamic Widget

> **رَفيِقْ** — رفيقك الإسلامي اليومي
> تطبيق Flutter عربي خالص بتصميم فاخر (نيلي + ذهبي)

---

## معلومات عامة

| PropertyInfo | القيمة |
|---|---|
| **اسم الحزمة** | `daily_islamic_widget` |
| **اسم العرض** | رَفيِقْ |
| **الإصدار** | `1.0.0+1` |
| **Flutter SDK** | `3.44.1` |
| **Dart SDK** | `^3.12.1` |
| **عدد ملفات Dart** | **248 ملف** |
| **المنصات المدعومة** | Android, Web |

---

## 📁 هيكل المجلدات الرئيسي

```
lib/
├── main.dart                          # نقطة الدخول الرئيسية
├── app.dart                           # MaterialApp + Theme + Router
│
├── core/                              # البنية التحتية الأساسية
│   ├── arabic_strings.dart            # النصوص العربية المركزة
│   ├── constants.dart                 # المعرفات والثوابت العامة
│   ├── navigation_guard.dart          # حماية التنقل
│   ├── api/                           # عميل API مركزي
│   │   └── api_client.dart
│   ├── cache/                         # نظام التخزين المؤقت
│   │   ├── cache_manager.dart         # كاش عام (JSON)
│   │   └── hive_cache_manager.dart    # Hive cache
│   ├── constants/
│   │   ├── api_constants.dart         # ثوابت API
│   │   └── app_constants.dart         # ثوابت التطبيق
│   ├── errors/                        # معالجة الأخطاء
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── network/                       # الشبكة
│   │   ├── network_info.dart
│   │   └── shia_api_client.dart       # عميل API الشيعي
│   └── utils/
│       ├── arabic_search.dart         # بحث عربي متقدم
│       └── hijri_date.dart            # تحويل التاريخ الهجري
│
├── database/                          # طبقة قاعدة البيانات (Offline First)
│   ├── collections.dart               # تعريفات Isar (16 مجموعة)
│   ├── collections.g.dart             # كود Isar المولّد
│   ├── isar_service.dart              # خدمة Isar المركزية
│   ├── local_database.dart            # ✨ واجهة مختلطة المنصات
│   ├── local_database_android.dart    # ← تنفيذ Isar
│   ├── local_database_web.dart        # ← تنفيذ SharedPreferences
│   ├── local_database_stub.dart       # ← حماية kompilasi
│   ├── migration/
│   │   ├── data_migrator.dart         # ترحيل SharedPreferences → Isar
│   │   └── data_migrator_stub.dart    # no-op على الويب
│   └── models/
│       └── database_models.dart       # 17 كلاس DTO خالٍ من Isar
│
├── data/                              # البيانات الثابتة
│   └── greetings/                     # تهاني الأشهر الهجرية (14 ملف)
│
├── models/                            # النماذج المشتركة
│   ├── models.dart                    # ملف تصدير مركزي
│   ├── settings_model.dart            # إعدادات التطبيق
│   ├── verse_model.dart               # نموذج الآية
│   ├── hadith_model.dart              # نموذج الحديث
│   ├── khatmah_model.dart             # نموذج الختمة
│   ├── tasbeeh_model.dart             # نموذج التسبيح
│   ├── favorite_model.dart            # نموذج المفضلة
│   ├── adhkar_model.dart              # نموذج الأذكار
│   ├── prayer_times.dart              # أوقات الصلاة
│   ├── greeting.dart                  # التهاني
│   ├── greeting_period.dart           # فترات التهنئة
│   └── api_models.dart                # نماذج API
│
├── providers/                         # مزودات Riverpod
│   ├── settings_provider.dart         # إعدادات التطبيق
│   ├── favorites_provider.dart        # المفضلة
│   ├── khatmah_provider.dart          # الختمة
│   ├── tasbeeh_provider.dart          # التسبيح
│   ├── tasbeeh_stats_provider.dart    # إحصائيات التسبيح
│   ├── tasbeeh_history_provider.dart  # سجل التسبيح
│   ├── tasbeeh_custom_provider.dart   # تسبيح مخصص
│   ├── adhkar_provider.dart           # الأذكار
│   ├── daily_provider.dart            # المحتوى اليومي
│   ├── prayer_time_providers.dart     # أوقات الصلاة
│   ├── prayer_provider.dart           # الصلاة
│   ├── qibla_provider.dart            # القبلة
│   ├── tasbeeh_al_zahra_provider.dart # تسبيح الزهراء
│   └── tasbih_al_zahra_provider.dart  # تسبيح الزهراء (نسخة)
│
├── services/                          # الخدمات
│   ├── storage_service.dart           # SharedPreferences
│   ├── notification_service.dart      # إشعارات عامة
│   ├── notification_helper.dart       # تعريفات القنوات
│   ├── prayer_notification_service.dart # إشعارات الصلاة
│   ├── adhan_scheduler.dart           # جدولة الأذان
│   ├── prayer_scheduler.dart          # منسق جدولة الصلاة
│   ├── prayer_service.dart            # خدمة الصلاة
│   ├── prayer_time_service.dart       # خدمة أوقات الصلاة
│   ├── location_service.dart          # تحديد الموقع
│   ├── connectivity_service.dart      # مراقبة الاتصال
│   ├── background_sync_service.dart   # مزامنة الخلفية
│   ├── data_service.dart              # خدمة البيانات
│   ├── greeting_service.dart          # خدمة التهاني
│   ├── home_widget_service.dart       # ودجت الشاشة الرئيسية
│   ├── permission_service.dart        # إدارة الأذونات
│   ├── app_startup_service.dart       # تهيئة التطبيق
│   ├── api_service.dart               # خدمة API
│   └── time_formatter.dart            # تنسيق الوقت
│
├── routes/
│   └── app_router.dart                # توجيه GoRouter
│
├── theme/
│   ├── app_theme.dart                 # الثيم (نيلي + ذهبي)
│   └── ds_components.dart             # مكونات تصميم النظام
│
├── widgets/                           # مكونات مشتركة
│   ├── floating_dock_nav.dart         # شريط التنقل السفلي
│   ├── premium_navbar.dart            # شريط التنقل العلوي
│   ├── hadith_card.dart               # بطاقة الحديث
│   ├── verse_card.dart                # بطاقة الآية
│   ├── prayer_times_cards.dart        # بطاقات أوقات الصلاة
│   ├── tasbih_hero_card.dart          # بطاقة التسبيح الرئيسية
│   ├── star_background.dart           # خلفية النجوم
│   ├── islamic_art.dart               # الفن الإسلامي
│   ├── hero_illustration.dart         # الرسم التوضيحي
│   └── azkar_progress_section.dart    # قسم تقدم الأذكار
│
└── features/                          # الوحدات الوظيفية (21 وحدة)
    ├── home/                          # الشاشة الرئيسية
    ├── quran/                         # القرآن الكريم
    ├── quran_audio/                   # تشغيل القرآن الصوتي
    ├── hadith/                        # الأحاديث النبوية
    ├── hadith_shia/                   # الأحاديث الشيعية
    ├── adhkar/                        # الأذكار اليومية
    ├── tasbeeh/                       # التسبيح
    ├── prayer_times/                  # أوقات الصلاة
    ├── qibla/                         # اتجاه القبلة
    ├── khatmah/                       # ختم القرآن
    ├── favorites/                     # المفضلة
    ├── bookmarks/                     # الإشارات المرجعية
    ├── search/                        # البحث
    ├── settings/                      # الإعدادات
    ├── onboarding/                    # الإعداد الأولي
    ├── splash/                        # شاشة البداية
    ├── fatwa/                         # الفتاوى
    ├── ziyarat/                       # الزيارات والمفاتيح
    ├── premium/                       # الشاشات المميزة
    ├── more/                          # شاشة "المزيد"
    └── widget_settings/               # إعدادات الودجت
```

---

## 🏗️ الهيكل المعماري

### نمط التصميم
- **Feature-First Architecture** مع طبقات مستوحاة من Clean Architecture
- كل وحدة وظيفية تحتوي على: `data/` → `domain/` → `presentation/`

### إدارة الحالة
- **Riverpod** (`flutter_riverpod ^2.6.1`) — مزودات `StateNotifier`

### التنقل
- **GoRouter** (`go_router ^14.8.1`) — `lib/routes/app_router.dart`

### الثيم
- تصميم فاخر **نيلي + ذهبي** ثابت — الوضع الداكن فقط (`AppTheme.darkTheme`)
- واجهة عربية بالكامل (RTL) — لا يوجد أي نص إنجليزي في الواجهة

---

## 📦 نظام قاعدة البيانات (Offline First)

### المعمارية الجديدة — تجcross-platform

```
UI → Provider → LocalDatabaseService (abstract)
                       ↑
          ┌─────────────┴──────────────┐
          │                            │
   [dart.library.io]           [dart.library.html]
          │                            │
  IsarDatabaseService          WebDatabaseService
  (Isar — Android)            (SharedPreferences — Web)
```

### الشروط الشرطية (Conditional Imports)

```dart
// local_database.dart
import 'local_database_stub.dart'
    if (dart.library.io) 'local_database_android.dart'     // ← Isar
    if (dart.library.html) 'local_database_web.dart';      // ← SharedPreferences

// main.dart
import 'database/migration/data_migrator.dart'
    if (dart.library.html) 'database/migration/data_migrator_stub.dart';
```

### مجموعات Isar (16 مجموعة)

| المجموعة | الوصف |
|---|---|
| `SettingsIsar` | إعدادات التطبيق |
| `FavoriteIsar` | العناصر المفضلة |
| `BookmarkIsar` | الإشارات المرجعية |
| `ReadingProgressIsar` | تقدم القراءة |
| `KhatmahIsar` | ختم القرآن |
| `TasbeehIsar` | عدّادات التسبيح |
| `AdhkarStateIsar` | حالة الأذكار |
| `PrayerTimesCacheIsar` | كاش أوقات الصلاة |
| `CacheEntryIsar` | كاش عام مع انتهاء صلاحية |
| `AudioStateIsar` | حالة المشغل الصوتي |
| `RecentlyPlayedIsar` | آخر ما تم تشغيله |
| `TasbihStatsIsar` | إحصائيات التسبيح |
| `TasbihHistoryIsar` | سجل جلسات التسبيح |
| `CustomTasbihIsar` | التسبيح المخصص |
| `DailyContentIsar` | المحتوى اليومي |
| `SearchHistoryIsar` | سجل البحث |

### نماذج DTO (17 نموذج — خالٍ من Isar)

位于 `lib/database/models/database_models.dart`:

| النموذج | المقابل له في Isar |
|---|---|
| `SettingsEntry` | `SettingsIsar` |
| `FavoriteEntry` | `FavoriteIsar` |
| `BookmarkEntry` | `BookmarkIsar` |
| `ReadingProgressEntry` | `ReadingProgressIsar` |
| `KhatmahEntry` | `KhatmahIsar` |
| `TasbeehEntry` | `TasbeehIsar` |
| `AdhkarStateEntry` | `AdhkarStateIsar` |
| `PrayerTimesCacheEntry` | `PrayerTimesCacheIsar` |
| `CacheEntry` | `CacheEntryIsar` |
| `AudioStateEntry` | `AudioStateIsar` |
| `RecentlyPlayedEntry` | `RecentlyPlayedIsar` |
| `TasbihStatsEntry` | `TasbihStatsIsar` |
| `TasbihHistoryEntry` | `TasbihHistoryIsar` |
| `CustomTasbihEntry` | `CustomTasbihIsar` |
| `DailyContentEntry` | `DailyContentIsar` |
| `SearchHistoryEntry` | `SearchHistoryIsar` |

---

## 🎵 النظام الصوتي

- **مكتبة التشغيل**: `audio_service ^0.18.17` للخلفية على Android
- **استثناء الويب**: `QuranAudioHandler` يتم إنشاؤه مباشرة على الويب
- **API**: `mp3quran.net` v3 — أكثر من 100 قارئ

### نظام الأذان
- **3 مؤذنين** مع ملفات MP3 محلية على Android
- خريطة مركزية: `AdhanAudioMapping.kt` (Kotlin) + `AppConstants.muadhinDisplayNames` (Dart)
- إعدادات مخصصة: فجر، ظهر، مغرب — مع مستوى الصوت والاهتزاز

---

## 🔔 نظام الإشعارات

| الإشعار | الوصف |
|---|---|
| إشعارات الصلاة | فجر، ظهر، مغرب |
| إشعار الآية اليومية | آية عشوائية يومياً |
| إشعار الحديث اليومي | حديث شيعي يومياً |
| أذان الصلاة | تشغيل الأذان عبر Foreground Service |

---

## 🔐 نظام أذونات التطبيق (8 خطوات)

1. ترحيب
2. الإشعارات
3. المنبهات الدقيقة
4. البطارية
5. التشغيل في الخلفية
6. التشغيل التلقائي (AutoStart)
7. الصوت
8. ملخص

---

## 📱 الويدجت (Home Widget)

- **ودجت القرآن**: يعرض السورة والآية والصفحة الحالية
- **ودجت التسبيح**: عداد حي مع إمكانية التحديث من الشاشة الرئيسية

---

## 🌐 التوافق

| المنصة | الحالة | قاعدة البيانات |
|---|---|---|
| Android | ✅ يبني بنجاح | Isar |
| Web | ✅ يبني بنجاح | SharedPreferences |
| iOS | ✅ مدعوم | Isar |

### ملاحظات الويب
- لا يتم تحميل أي كود Isar على الويب
- `isar` و `isar_flutter_libs` موجودان في `pubspec.yaml` لكن لا يتم استيرادهما على الويب
- التحذيرات الخاصة بـ WASM في `flutter build web` تتعلق بـ `dart:ffi` ولا تؤثر على البناء

---

## 📊 إحصائيات المشروع

| الفئة | العدد |
|---|---|
| إجمالي ملفات Dart | **248** |
| ملفات `features/` | **167** (21 وحدة وظيفية) |
| ملفات `services/` | **18** |
| ملفات `providers/` | **14** |
| ملفات `models/` | **12** |
| ملفات `core/` | **12** |
| ملفات `database/` | **10** |
| ملفات `widgets/` | **10** |
| ملفات `data/` | **15** |
| مجموعات Isar | **16** |
| نماذج DTO | **17** |
| شاشات الميزات | **40+** |

---

## 🛠️ أوامر التطوير

```bash
# بناء Android
flutter build apk --release

# بناء الويب
flutter build web --no-tree-shake-icons

# تحليل الأكواد
flutter analyze

# توليد كود Isar
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 📋 قائمة المراجععة (Checklist)

- [x] تصميم فاخر نيلي + ذهبي
- [x] واجهة عربية بالكامل (RTL)
- [x] لا يوجد نص إنجليزي في الواجهة
- [x] نظام تسبيح مع اهتزاز وصوت
- [x] تشغيل القرآن في الخلفية
- [x] إشعارات الصلاة مع أذان
- [x] نظام أذونات من 8 خطوات
- [x] قاعدة بيانات Offline First (Isar)
- [x] ترحيل تلقائي من SharedPreferences إلى Isar
- [x] توفر الويب (SharedPreferences بديل)
- [x] مزامنة خلفية مع مراقبة الاتصال
- [x] ودجت الشاشة الرئيسية
- [x] اتجاه القبلة
- [x] التقويم الهجري
- [x] البحث المتقدم بالعربية

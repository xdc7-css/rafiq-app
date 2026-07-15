// Widget data keys — Single Source of Truth for Flutter ↔ Android bridge.
//
// Every key defined here must have an identical mirror in:
//   android/.../WidgetKeys.kt
//
// The Kotlin file is a mechanical copy. If you change a key here,
// change it there too. The Kotlin file has a header comment pointing
// back to this file as the canonical source.
//
// Naming convention: all keys use `widget_` prefix + snake_case.
// New widget types add their keys in a clearly marked section below.

/// SharedPreferences file name shared between Flutter and Kotlin.
const String kWidgetPrefsName = 'HomeWidgetPreferences';

// ---------------------------------------------------------------------------
// Prayer Times
// ---------------------------------------------------------------------------
const String kKeyNextPrayerName = 'widget_next_prayer';
const String kKeyNextPrayerTime = 'widget_next_time';
const String kKeyCountdown = 'widget_countdown';

const String kKeyFajrTime = 'widget_fajr_time';
const String kKeyDhuhrTime = 'widget_dhuhr_time';
const String kKeyAsrTime = 'widget_asr_time';
const String kKeyMaghribTime = 'widget_maghrib_time';
const String kKeyIshaTime = 'widget_isha_time';
const String kKeySunriseTime = 'widget_sunrise_time';

// ---------------------------------------------------------------------------
// Quran
// ---------------------------------------------------------------------------
const String kKeyQuranSurahName = 'widget_quran_surah_name';
const String kKeyQuranSurahNumber = 'widget_quran_surah_number';
const String kKeyQuranAyah = 'widget_quran_ayah';
const String kKeyQuranPage = 'widget_quran_page';
const String kKeyQuranTotalPages = 'widget_quran_total_pages';
const String kKeyQuranProgress = 'widget_quran_progress';
const String kKeyQuranHasKhatmah = 'widget_quran_has_khatmah';

// ---------------------------------------------------------------------------
// Tasbih
// ---------------------------------------------------------------------------
const String kKeyTasbihName = 'widget_tasbih_name';
const String kKeyTasbihCount = 'widget_tasbih_count';
const String kKeyTasbihTarget = 'widget_tasbih_target';
const String kKeyTasbihId = 'widget_tasbih_id';
const String kKeyTasbihIndex = 'widget_tasbih_index';
const String kKeyTasbihTotalItems = 'widget_tasbih_total_items';

// ---------------------------------------------------------------------------
// Date / Dashboard
// ---------------------------------------------------------------------------
const String kKeyHijriDate = 'widget_hijri_date';
const String kKeyGregorianDate = 'widget_gregorian_date';
const String kKeyDayOfWeek = 'widget_day_of_week';

// ---------------------------------------------------------------------------
// Appearance
// ---------------------------------------------------------------------------
const String kKeyBgColor = 'widget_bg_color';
const String kKeyTextColor = 'widget_text_color';
const String kKeyFontSize = 'widget_font_size';

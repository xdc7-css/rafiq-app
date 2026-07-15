package com.dailyislamicwidget.daily_islamic_widget

/**
 * Widget data keys — Mirror of Dart-side source of truth.
 *
 * Canonical source: lib/services/widget_keys.dart
 * This file must be kept in sync with that file.
 *
 * If you add or rename a key, update BOTH files.
 */
object WidgetKeys {

    const val PREFS_NAME = "HomeWidgetPreferences"

    // Prayer Times
    const val NEXT_PRAYER_NAME = "widget_next_prayer"
    const val NEXT_PRAYER_TIME = "widget_next_time"
    const val COUNTDOWN = "widget_countdown"

    const val FAJR_TIME = "widget_fajr_time"
    const val DHUHR_TIME = "widget_dhuhr_time"
    const val ASR_TIME = "widget_asr_time"
    const val MAGHRIB_TIME = "widget_maghrib_time"
    const val ISHA_TIME = "widget_isha_time"
    const val SUNRISE_TIME = "widget_sunrise_time"

    // Quran
    const val QURAN_SURAH_NAME = "widget_quran_surah_name"
    const val QURAN_SURAH_NUMBER = "widget_quran_surah_number"
    const val QURAN_AYAH = "widget_quran_ayah"
    const val QURAN_PAGE = "widget_quran_page"
    const val QURAN_TOTAL_PAGES = "widget_quran_total_pages"
    const val QURAN_PROGRESS = "widget_quran_progress"
    const val QURAN_HAS_KHATMAH = "widget_quran_has_khatmah"

    // Tasbih
    const val TASBIH_NAME = "widget_tasbih_name"
    const val TASBIH_COUNT = "widget_tasbih_count"
    const val TASBIH_TARGET = "widget_tasbih_target"
    const val TASBIH_ID = "widget_tasbih_id"
    const val TASBIH_INDEX = "widget_tasbih_index"
    const val TASBIH_TOTAL_ITEMS = "widget_tasbih_total_items"

    // Date / Dashboard
    const val HIJRI_DATE = "widget_hijri_date"
    const val GREGORIAN_DATE = "widget_gregorian_date"
    const val DAY_OF_WEEK = "widget_day_of_week"

    // Appearance
    const val BG_COLOR = "widget_bg_color"
    const val TEXT_COLOR = "widget_text_color"
    const val FONT_SIZE = "widget_font_size"
}

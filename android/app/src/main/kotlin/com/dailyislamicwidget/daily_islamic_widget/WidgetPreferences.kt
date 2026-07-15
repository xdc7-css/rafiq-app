package com.dailyislamicwidget.daily_islamic_widget

import android.content.Context
import android.content.SharedPreferences
import android.util.Log

/**
 * Shared infrastructure for reading widget SharedPreferences.
 *
 * Provides safe retrieval with defaults, type conversion, and logging.
 * Widget-specific UI logic stays inside each provider — this file only
 * handles data access.
 */
object WidgetPreferences {

    private const val TAG = "WidgetPrefs"

    fun obtain(context: Context): SharedPreferences =
        context.getSharedPreferences(WidgetKeys.PREFS_NAME, Context.MODE_PRIVATE)

    // ─── String ────────────────────────────────────────────────────────
    fun SharedPreferences.getStringOr(key: String, default: String = ""): String {
        return try {
            getString(key, default) ?: default
        } catch (e: Exception) {
            Log.w(TAG, "getStringOr($key) failed: ${e.message}")
            default
        }
    }

    // ─── Int ───────────────────────────────────────────────────────────
    fun SharedPreferences.getIntOr(key: String, default: Int = 0): Int {
        return try {
            getInt(key, default)
        } catch (e: Exception) {
            Log.w(TAG, "getIntOr($key) failed: ${e.message}")
            default
        }
    }

    // ─── Boolean ───────────────────────────────────────────────────────
    fun SharedPreferences.getBooleanOr(key: String, default: Boolean = false): Boolean {
        return try {
            getBoolean(key, default)
        } catch (e: Exception) {
            Log.w(TAG, "getBooleanOr($key) failed: ${e.message}")
            default
        }
    }

    // ─── Composite helpers ─────────────────────────────────────────────

    /** Read the text color used by all widgets. Falls back to near-white. */
    fun SharedPreferences.textColor(): Int =
        getIntOr(WidgetKeys.TEXT_COLOR, 0xFFF8F8F8.toInt())

    /** Read the background color. Falls back to default dark blue. */
    fun SharedPreferences.bgColor(): Int =
        getIntOr(WidgetKeys.BG_COLOR, 0xFF0A1946.toInt())

    /** Read font size. Falls back to 14. */
    fun SharedPreferences.fontSize(): Int =
        getIntOr(WidgetKeys.FONT_SIZE, 14)
}

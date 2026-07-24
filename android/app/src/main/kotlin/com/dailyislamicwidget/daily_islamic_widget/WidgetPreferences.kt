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

    private const val TAG = "WIDGET_FORENSICS"

    fun obtain(context: Context): SharedPreferences {
        val prefs = context.getSharedPreferences(WidgetKeys.PREFS_NAME, Context.MODE_PRIVATE)
        val allKeys = prefs.all.keys
        Log.d(TAG, "[PREFS] obtain: file=${WidgetKeys.PREFS_NAME}, empty=${allKeys.isEmpty()}, keyCount=${allKeys.size}, keys=${allKeys.toList()}")
        return prefs
    }

    // ─── String ────────────────────────────────────────────────────────
    fun SharedPreferences.getStringOr(key: String, default: String = ""): String {
        return try {
            val raw = getString(key, null)
            if (raw == null) {
                Log.d(TAG, "[PREFS] getStringOr($key): MISSING → using default=\"$default\"")
                default
            } else {
                Log.d(TAG, "[PREFS] getStringOr($key): found=\"$raw\"")
                raw
            }
        } catch (e: Exception) {
            Log.e(TAG, "[PREFS] getStringOr($key): EXCEPTION", e)
            default
        }
    }

    /**
     * Read an Int from SharedPreferences.
     *
     * Handles the Flutter ↔ Android type mismatch where Dart `int` values
     * exceeding [Int.MAX_VALUE] (e.g. ARGB colors like 0xFF0A1946) are
     * encoded as 64-bit Long by the standard method codec and stored as
     * Long by the home_widget plugin. This method transparently converts
     * Long values back to Int when they fit in 32 bits.
     */
    fun SharedPreferences.getIntOr(key: String, default: Int = 0): Int {
        return try {
            val raw = all[key]
            if (raw == null) {
                Log.d(TAG, "[PREFS] getIntOr($key): MISSING → using default=$default")
                return default
            }
            val result = when (raw) {
                is Int -> {
                    Log.d(TAG, "[PREFS] getIntOr($key): type=Int, value=$raw (hex=0x${Integer.toHexString(raw)})")
                    raw
                }
                is Long -> {
                    val converted = raw.toInt()
                    Log.d(TAG, "[PREFS] getIntOr($key): type=Long, raw=$raw → toInt()=$converted (hex=0x${Integer.toHexString(converted)})")
                    converted
                }
                is Number -> {
                    val converted = raw.toInt()
                    Log.d(TAG, "[PREFS] getIntOr($key): type=${raw::class.simpleName}, raw=$raw → toInt()=$converted")
                    converted
                }
                else -> {
                    Log.w(TAG, "[PREFS] getIntOr($key): UNEXPECTED type=${raw::class.simpleName}, value=$raw → using default=$default")
                    default
                }
            }
            result
        } catch (e: Exception) {
            Log.e(TAG, "[PREFS] getIntOr($key): EXCEPTION", e)
            default
        }
    }

    // ─── Boolean ───────────────────────────────────────────────────────
    fun SharedPreferences.getBooleanOr(key: String, default: Boolean = false): Boolean {
        return try {
            val result = getBoolean(key, default)
            Log.d(TAG, "[PREFS] getBooleanOr($key): $result")
            result
        } catch (e: Exception) {
            Log.e(TAG, "[PREFS] getBooleanOr($key): EXCEPTION", e)
            default
        }
    }

    // ─── Composite helpers ─────────────────────────────────────────────

    /** Read the text color used by all widgets. Falls back to near-white. */
    fun SharedPreferences.textColor(): Int {
        val result = getIntOr(WidgetKeys.TEXT_COLOR, 0xFFF8F8F8.toInt())
        Log.d(TAG, "[PREFS] textColor(): 0x${Integer.toHexString(result)}")
        return result
    }

    /** Read the background color. Falls back to default dark blue. */
    fun SharedPreferences.bgColor(): Int {
        val result = getIntOr(WidgetKeys.BG_COLOR, 0xFF0A1946.toInt())
        Log.d(TAG, "[PREFS] bgColor(): 0x${Integer.toHexString(result)}")
        return result
    }

    /** Read font size. Falls back to 14. */
    fun SharedPreferences.fontSize(): Int {
        val result = getIntOr(WidgetKeys.FONT_SIZE, 14)
        Log.d(TAG, "[PREFS] fontSize(): $result")
        return result
    }
}

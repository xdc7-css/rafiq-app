package com.dailyislamicwidget.daily_islamic_widget

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import org.json.JSONObject
import java.util.Calendar

/// AdhanBootReceiver — recovers adhan alarms after system events.
///
/// Handles:
///   • BOOT_COMPLETED — device reboot
///   • MY_PACKAGE_REPLACED — app update
///   • TIMEZONE_CHANGED — user or system timezone change
///   • TIME_SET — manual time correction or NTP sync
///
/// Recovery strategy:
///   1. Load stored prayer schedule from SharedPreferences.
///   2. Validate each prayer's timestamp individually (is it still in the future?).
///   3. Reschedule only valid (future) prayers.
///   4. Skip prayers whose timestamps are in the past (already fired today).
///   5. If ALL prayers are stale, clear the schedule — the Flutter side will
///      recalculate on next app open.
class AdhanBootReceiver : BroadcastReceiver() {

    companion object {
        private const val TAG = "AdhanBootReceiver"
        private const val PREFS_NAME = "adhan_schedule"
        private const val KEY_PRAYER_TIMES_JSON = "prayer_times_json"
        private const val KEY_LAST_SCHEDULED_DAY = "last_scheduled_day"
        private const val KEY_ADHAN_ENABLED = "adhan_enabled"
        private const val KEY_ADHAN_VOLUME = "adhan_volume"
        private const val KEY_SELECTED_SOUND = "selected_sound"
        private const val KEY_ADHAN_FAJR = "adhan_fajr"
        private const val KEY_ADHAN_DHUHR = "adhan_dhuhr"
        private const val KEY_ADHAN_MAGHRIB = "adhan_maghrib"
        private const val KEY_BOOT_START = "boot_start"

        /// Shi'a adhan prayers (Fajr, Dhuhr, Maghrib only).
        private val ADHAN_PRAYER_NAMES = listOf("Fajr", "Dhuhr", "Maghrib")
    }

    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action ?: return
        Log.i(TAG, "[VERIFICATION] BOOT_RECEIVER_INVOKED: action=$action")

        // Phase 4.1: Trigger WorkManager recovery for all events.
        // skipAlarmReschedule=true: BootReceiver already handles alarm scheduling
        // synchronously via rescheduleAfterEvent(). The worker should NOT cancel
        // those alarms — it only runs integrity checks and schedules the next worker.
        try {
            AdhanWorkManager.runImmediately(context, trigger = action, skipAlarmReschedule = true)
            Log.i(TAG, "[PHASE4.1] WorkManager immediate worker enqueued (skipAlarmReschedule=true) for action=$action")
        } catch (e: Exception) {
            Log.e(TAG, "[PHASE4.1] WorkManager enqueue failed: ${e.message}", e)
        }

        when (action) {
            Intent.ACTION_BOOT_COMPLETED -> {
                Log.i(TAG, "[VERIFICATION] RECOVERY_TRIGGER: BOOT_COMPLETED")
                rescheduleAfterEvent(context, "BOOT_COMPLETED")
                refreshAllWidgets(context)
            }
            Intent.ACTION_MY_PACKAGE_REPLACED -> {
                Log.i(TAG, "[VERIFICATION] RECOVERY_TRIGGER: MY_PACKAGE_REPLACED")
                rescheduleAfterEvent(context, "MY_PACKAGE_REPLACED")
                refreshAllWidgets(context)
            }
            Intent.ACTION_TIMEZONE_CHANGED -> {
                Log.i(TAG, "[VERIFICATION] RECOVERY_TRIGGER: TIMEZONE_CHANGED")
                rescheduleAfterEvent(context, "TIMEZONE_CHANGED")
            }
            Intent.ACTION_TIME_CHANGED -> {
                Log.i(TAG, "[VERIFICATION] RECOVERY_TRIGGER: TIME_CHANGED")
                rescheduleAfterEvent(context, "TIME_CHANGED")
            }
            else -> {
                Log.w(TAG, "[VERIFICATION] UNHANDLED_ACTION: $action")
            }
        }
    }

    // ── Recovery ─────────────────────────────────────────────────────────────

    private fun rescheduleAfterEvent(context: Context, trigger: String) {
        Log.i(TAG, "[VERIFICATION] RECOVERY_STARTED (trigger=$trigger)")

        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)

        // ── Step 1: Check if adhan is enabled ──
        val adhanEnabled = prefs.getBoolean(KEY_ADHAN_ENABLED, true)
        if (!adhanEnabled) {
            Log.i(TAG, "[VERIFICATION] RECOVERY_SKIP: adhan disabled in settings")
            return
        }

        // ── Step 2: Check if boot reschedule is enabled ──
        val bootStart = prefs.getBoolean(KEY_BOOT_START, true)
        if (!bootStart) {
            Log.i(TAG, "[VERIFICATION] RECOVERY_SKIP: boot reschedule disabled in settings")
            return
        }

        // ── Step 3: Load stored prayer schedule ──
        val prayerTimesJson = prefs.getString(KEY_PRAYER_TIMES_JSON, null)
        if (prayerTimesJson.isNullOrEmpty()) {
            Log.w(TAG, "[VERIFICATION] RECOVERY_FAIL: no stored prayer schedule (json=${if (prayerTimesJson == null) "null" else "empty"})")
            return
        }
        Log.i(TAG, "[VERIFICATION] PRAYER_SCHEDULE_LOADED: length=${prayerTimesJson.length} chars")

        // ── Step 4: Parse and validate JSON ──
        val json: JSONObject
        try {
            json = JSONObject(prayerTimesJson)
        } catch (e: Exception) {
            Log.e(TAG, "[VERIFICATION] RECOVERY_FAIL: corrupted JSON — ${e.message}")
            prefs.edit().remove(KEY_PRAYER_TIMES_JSON).remove(KEY_LAST_SCHEDULED_DAY).apply()
            Log.i(TAG, "[VERIFICATION] CORRUPTED_DATA_CLEARED")
            return
        }

        val enabled = json.optJSONObject("enabled")
        val volume = json.optDouble("volume", 1.0)
        val soundName = json.optString("selectedSound", AdhanAudioMapping.DEFAULT_KEY)
        val prayersArray = json.optJSONArray("prayers")
        if (prayersArray == null) {
            Log.e(TAG, "[VERIFICATION] RECOVERY_FAIL: missing 'prayers' array in JSON")
            prefs.edit().remove(KEY_PRAYER_TIMES_JSON).remove(KEY_LAST_SCHEDULED_DAY).apply()
            return
        }
        Log.i(TAG, "[VERIFICATION] PRAYER_DATA_PARSED: volume=$volume, sound=$soundName, prayersInJson=${prayersArray.length()}")

        // ── Step 5: Cancel all existing alarms (prevent duplicates) ──
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as android.app.AlarmManager
        for (index in ADHAN_PRAYER_NAMES.indices) {
            val pi = android.app.PendingIntent.getBroadcast(
                context,
                4000 + index,
                Intent(context, AdhanAlarmReceiver::class.java),
                android.app.PendingIntent.FLAG_UPDATE_CURRENT or android.app.PendingIntent.FLAG_IMMUTABLE
            )
            pi.cancel()
            alarmManager.cancel(pi)
        }
        Log.i(TAG, "[VERIFICATION] EXISTING_ALARMS_CANCELLED")

        // ── Step 6: Reschedule each prayer with per-prayer validation ──
        val now = System.currentTimeMillis()
        val plugin = AdhanPlugin(context)
        var scheduledCount = 0
        var skippedPast = 0
        var skippedDisabled = 0
        var failedParse = 0

        for (i in 0 until prayersArray.length()) {
            val prayer: JSONObject
            try {
                prayer = prayersArray.getJSONObject(i)
            } catch (e: Exception) {
                Log.w(TAG, "[VERIFICATION] PRAYER_PARSE_ERROR at index=$i: ${e.message}")
                failedParse++
                continue
            }

            val name = prayer.optString("name", "")
            if (name !in ADHAN_PRAYER_NAMES) continue

            // Check if this specific prayer is enabled
            val isEnabled = enabled?.optBoolean(name, true) ?: true
            if (!isEnabled) {
                skippedDisabled++
                Log.d(TAG, "[VERIFICATION] PRAYER_SKIPPED: $name (disabled)")
                continue
            }

            val timestampMillis = prayer.optLong("timestampMillis", -1L)
            val time = prayer.optString("time", "")
            val parts = time.split(":")
            if (parts.size != 2) {
                Log.w(TAG, "[VERIFICATION] PRAYER_INVALID_TIME: $name time='$time'")
                failedParse++
                continue
            }

            val hour = parts[0].toIntOrNull()
            val minute = parts[1].toIntOrNull()
            if (hour == null || minute == null) {
                Log.w(TAG, "[VERIFICATION] PRAYER_INVALID_TIME_FORMAT: $name time='$time'")
                failedParse++
                continue
            }

            // Per-prayer staleness check: skip if timestamp is in the past.
            // scheduleSingleAlarm() has its own past-timestamp guard, but we
            // skip here to avoid unnecessary work and log clearly.
            if (timestampMillis > 0 && timestampMillis < now) {
                skippedPast++
                Log.d(TAG, "[VERIFICATION] PRAYER_PAST: $name timestamp=$timestampMillis (already fired)")
                continue
            }

            val resolvedSound = if (AdhanAudioMapping.isValidKey(soundName)) soundName else AdhanAudioMapping.DEFAULT_KEY
            plugin.scheduleSingleAlarm(name, i, hour, minute, volume.toFloat(), resolvedSound, timestampMillis)
            scheduledCount++
            Log.i(TAG, "[VERIFICATION] ALARM_RECREATED: $name at ${String.format("%02d:%02d", hour, minute)}")
        }

        // ── Step 7: Update stored day key ──
        val today = Calendar.getInstance()
        val todayKey = today.get(Calendar.DAY_OF_MONTH) +
                (today.get(Calendar.MONTH) + 1) * 100 +
                today.get(Calendar.YEAR) * 10000
        prefs.edit().putInt(KEY_LAST_SCHEDULED_DAY, todayKey).apply()

        // ── Step 8: Summary ──
        if (scheduledCount == 0 && skippedPast > 0) {
            // All prayers were in the past — schedule has expired for today.
            // Clear it so the Flutter side can recalculate on next app open.
            Log.w(TAG, "[VERIFICATION] ALL_PRAYERS_PAST: clearing schedule (Flutter will recalculate on next open)")
            prefs.edit().remove(KEY_PRAYER_TIMES_JSON).remove(KEY_LAST_SCHEDULED_DAY).apply()
        } else if (scheduledCount > 0) {
            Log.i(TAG, "[VERIFICATION] RECOVERY_COMPLETE: scheduled=$scheduledCount, skippedPast=$skippedPast, skippedDisabled=$skippedDisabled, failedParse=$failedParse")
        } else {
            Log.w(TAG, "[VERIFICATION] RECOVERY_COMPLETE: no prayers scheduled (scheduled=0, skippedPast=$skippedPast, skippedDisabled=$skippedDisabled, failedParse=$failedParse)")
        }
    }

    // ── Widgets ──────────────────────────────────────────────────────────────

    private fun refreshAllWidgets(context: Context) {
        try {
            Log.i(TAG, "[VERIFICATION] Refreshing all widgets")
            PrayerTimesWidgetProvider.updateAllWidgets(context)
            QuranWidgetProvider.updateAllWidgets(context)
            TasbihWidgetProvider.updateAllWidgets(context)
            DashboardWidgetProvider.updateAllWidgets(context)
            Log.i(TAG, "[VERIFICATION] Widget refresh complete")
        } catch (e: Exception) {
            Log.e(TAG, "[VERIFICATION] Widget refresh failed: ${e.message}", e)
        }
    }
}

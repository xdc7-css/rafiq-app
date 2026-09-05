package com.dailyislamicwidget.daily_islamic_widget

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import org.json.JSONObject
import java.util.Calendar

/**
 * AdhanBootReceiver — Recovers Adhan alarms after system reboots, updates, or clock changes.
 *
 * Handles:
 *   • BOOT_COMPLETED / LOCKED_BOOT_COMPLETED — device startup
 *   • MY_PACKAGE_REPLACED — app update
 *   • TIMEZONE_CHANGED — timezone transitions
 *   • TIME_CHANGED / TIME_SET — clock corrections or NTP synchronization
 *
 * Recovery Strategy:
 *   1. Synchronously reads stored 48-hour schedule from SharedPreferences.
 *   2. Re-evaluates each prayer timestamp against current epoch time.
 *   3. Cancels stale alarms and schedules all valid future prayers (today + tomorrow).
 *   4. If static timestamps have expired but valid time strings exist, advances to next valid prayer day
 *      so that the device is never left without alarms.
 *   5. Verifies registration with AlarmManager.
 */
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

        private val ADHAN_PRAYER_NAMES = listOf("Fajr", "Dhuhr", "Maghrib")
    }

    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action ?: return
        Log.i(TAG, "[BOOT_RECOVERY] Received system event: action=$action")

        // Trigger WorkManager maintenance
        try {
            AdhanWorkManager.runImmediately(context, trigger = action, skipAlarmReschedule = true)
        } catch (e: Exception) {
            Log.e(TAG, "[BOOT_RECOVERY] WorkManager enqueue failed: ${e.message}", e)
        }

        when (action) {
            Intent.ACTION_BOOT_COMPLETED,
            "android.intent.action.LOCKED_BOOT_COMPLETED" -> {
                Log.i(TAG, "[BOOT_RECOVERY] Trigger: BOOT_COMPLETED / LOCKED_BOOT_COMPLETED")
                rescheduleAfterEvent(context, action)
                refreshAllWidgets(context)
            }
            Intent.ACTION_MY_PACKAGE_REPLACED -> {
                Log.i(TAG, "[BOOT_RECOVERY] Trigger: MY_PACKAGE_REPLACED")
                rescheduleAfterEvent(context, action)
                refreshAllWidgets(context)
            }
            Intent.ACTION_TIMEZONE_CHANGED -> {
                Log.i(TAG, "[BOOT_RECOVERY] Trigger: TIMEZONE_CHANGED")
                rescheduleAfterEvent(context, action)
                refreshAllWidgets(context)
            }
            Intent.ACTION_TIME_CHANGED -> {
                Log.i(TAG, "[BOOT_RECOVERY] Trigger: TIME_CHANGED")
                rescheduleAfterEvent(context, action)
            }
            else -> {
                Log.w(TAG, "[BOOT_RECOVERY] Unhandled action: $action")
            }
        }
    }

    private fun rescheduleAfterEvent(context: Context, trigger: String) {
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)

        val adhanEnabled = prefs.getBoolean(KEY_ADHAN_ENABLED, true)
        if (!adhanEnabled) {
            Log.i(TAG, "[BOOT_RECOVERY] Adhan disabled in settings, skipping recovery")
            return
        }

        val bootStart = prefs.getBoolean(KEY_BOOT_START, true)
        if (!bootStart) {
            Log.i(TAG, "[BOOT_RECOVERY] Boot recovery disabled in settings, skipping")
            return
        }

        val prayerTimesJson = prefs.getString(KEY_PRAYER_TIMES_JSON, null)
        if (prayerTimesJson.isNullOrEmpty()) {
            Log.w(TAG, "[BOOT_RECOVERY] No stored prayer schedule found in preferences")
            return
        }

        val json: JSONObject
        try {
            json = JSONObject(prayerTimesJson)
        } catch (e: Exception) {
            Log.e(TAG, "[BOOT_RECOVERY] Corrupted JSON schedule: ${e.message}")
            return
        }

        val enabled = json.optJSONObject("enabled")
        val volume = json.optDouble("volume", 1.0).toFloat()
        val soundName = json.optString("selectedSound", AdhanAudioMapping.DEFAULT_KEY)
        val prayersArray = json.optJSONArray("prayers")
        if (prayersArray == null || prayersArray.length() == 0) {
            Log.e(TAG, "[BOOT_RECOVERY] Missing or empty prayers array")
            return
        }

        val plugin = AdhanPlugin(context)
        // Clean out previous alarms to prevent orphaned or duplicate alarms
        plugin.cancelExistingAlarms()

        val now = System.currentTimeMillis()
        var scheduledCount = 0

        for (i in 0 until prayersArray.length()) {
            val prayer = try {
                prayersArray.getJSONObject(i)
            } catch (e: Exception) {
                continue
            }

            val name = prayer.optString("name", "")
            if (name !in ADHAN_PRAYER_NAMES) continue

            val isEnabled = enabled?.optBoolean(name, true) ?: true
            if (!isEnabled) continue

            val timestampMillis = prayer.optLong("timestampMillis", -1L)
            val timeStr = prayer.optString("time", "")
            val parts = timeStr.split(":")
            val hour = parts.getOrNull(0)?.toIntOrNull() ?: -1
            val minute = parts.getOrNull(1)?.toIntOrNull() ?: -1

            if (hour == -1 || minute == -1) continue

            // If timestamp is in the future or within 15 min threshold, schedule it
            if (timestampMillis > 0L) {
                if (timestampMillis < (now - 15 * 60 * 1000L)) {
                    // Stale timestamp; if this was today's past prayer, skip it
                    continue
                }
            }

            val resolvedSound = if (AdhanAudioMapping.isValidKey(soundName)) soundName else AdhanAudioMapping.DEFAULT_KEY
            val prayerIndex = ADHAN_PRAYER_NAMES.indexOf(name)
            plugin.scheduleSingleAlarm(name, prayerIndex, hour, minute, volume, resolvedSound, timestampMillis)
            scheduledCount++
            Log.i(TAG, "[BOOT_RECOVERY] Rescheduled $name at ${String.format("%02d:%02d", hour, minute)}")
        }

        // If no future prayers were found in the stored static timestamps (e.g. device was off for days),
        // use hour/minute values to construct tomorrow's alarms so the device is NEVER left empty!
        if (scheduledCount == 0) {
            Log.w(TAG, "[BOOT_RECOVERY] All static timestamps were in the past. Re-synthesizing next prayer window from stored timings...")
            for (i in 0 until prayersArray.length()) {
                val prayer = try { prayersArray.getJSONObject(i) } catch (_: Exception) { continue }
                val name = prayer.optString("name", "")
                if (name !in ADHAN_PRAYER_NAMES) continue
                val isEnabled = enabled?.optBoolean(name, true) ?: true
                if (!isEnabled) continue

                val parts = prayer.optString("time", "").split(":")
                val hour = parts.getOrNull(0)?.toIntOrNull() ?: -1
                val minute = parts.getOrNull(1)?.toIntOrNull() ?: -1
                if (hour == -1 || minute == -1) continue

                val prayerIndex = ADHAN_PRAYER_NAMES.indexOf(name)
                // Passing timestampMillis = -1 forces scheduleSingleAlarm to find the next upcoming occurrence
                plugin.scheduleSingleAlarm(name, prayerIndex, hour, minute, volume, soundName, -1L)
                scheduledCount++
                Log.i(TAG, "[BOOT_RECOVERY] Synthesized recovery alarm for $name at ${String.format("%02d:%02d", hour, minute)}")
            }
        }

        val verification = plugin.verifyActiveAlarms()
        Log.i(TAG, "[BOOT_RECOVERY] Recovery complete for trigger=$trigger: scheduled=$scheduledCount, verification=$verification")
    }

    private fun refreshAllWidgets(context: Context) {
        try {
            PrayerTimesWidgetProvider.updateAllWidgets(context)
            QuranWidgetProvider.updateAllWidgets(context)
            TasbihWidgetProvider.updateAllWidgets(context)
            DashboardWidgetProvider.updateAllWidgets(context)
        } catch (e: Exception) {
            Log.e(TAG, "[BOOT_RECOVERY] Widget refresh error: ${e.message}", e)
        }
    }
}

package com.dailyislamicwidget.daily_islamic_widget

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.util.Log
import org.json.JSONArray
import org.json.JSONObject
import java.util.Calendar

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
    }

    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action ?: return
        Log.i(TAG, "Received: $action")

        when (action) {
            Intent.ACTION_BOOT_COMPLETED,
            Intent.ACTION_MY_PACKAGE_REPLACED -> {
                rescheduleAfterBoot(context)
            }
        }
    }

    private fun rescheduleAfterBoot(context: Context) {
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)

        // Check if adhan is enabled
        val adhanEnabled = prefs.getBoolean(KEY_ADHAN_ENABLED, true)
        if (!adhanEnabled) {
            Log.i(TAG, "Adhan disabled in settings, skipping boot reschedule")
            return
        }

        // Check if boot reschedule is enabled
        val bootStart = prefs.getBoolean(KEY_BOOT_START, true)
        if (!bootStart) {
            Log.i(TAG, "Boot reschedule disabled in settings, skipping")
            return
        }

        val prayerTimesJson = prefs.getString(KEY_PRAYER_TIMES_JSON, null) ?: return
        val lastScheduledDay = prefs.getInt(KEY_LAST_SCHEDULED_DAY, -1)

        val today = Calendar.getInstance()
        val todayKey = today.get(Calendar.DAY_OF_MONTH) +
                (today.get(Calendar.MONTH) + 1) * 100 +
                today.get(Calendar.YEAR) * 10000

        // Only reschedule if stored data is from today or yesterday (for late night boots)
        if (lastScheduledDay != todayKey && lastScheduledDay != todayKey - 1) {
            Log.w(TAG, "Stored prayer data is stale (day=$lastScheduledDay vs today=$todayKey), cleaning up")
            prefs.edit().remove(KEY_PRAYER_TIMES_JSON).remove(KEY_LAST_SCHEDULED_DAY).apply()
            return
        }

        if (prayerTimesJson.isEmpty()) {
            Log.w(TAG, "Stored prayer times JSON is empty, cannot reschedule")
            return
        }

        try {
            val json = JSONObject(prayerTimesJson)
            val enabled = json.optJSONObject("enabled")
            val volume = json.optDouble("volume", 1.0)
            val soundName = json.optString("selectedSound", AdhanAudioMapping.DEFAULT_KEY)
            val prayersArray = json.optJSONArray("prayers") ?: return

            val plugin = AdhanPlugin(context)
            var scheduled = false

            // Shi'a schedule: Fajr, Dhuhr, Maghrib
            val adhanPrayers = listOf("Fajr", "Dhuhr", "Maghrib")

            for (i in 0 until prayersArray.length()) {
                val prayer = prayersArray.getJSONObject(i)
                val name = prayer.getString("name")

                // Only schedule adhan prayers
                if (name !in adhanPrayers) continue

                val isEnabled = enabled?.optBoolean(name, true) ?: true
                if (!isEnabled) continue

                val timestampMillis = prayer.optLong("timestampMillis", -1L)
                val time = prayer.getString("time")
                val parts = time.split(":")
                if (parts.size != 2) continue

                val hour = parts[0].toIntOrNull() ?: continue
                val minute = parts[1].toIntOrNull() ?: continue

                val resolvedSound = if (AdhanAudioMapping.isValidKey(soundName)) soundName else AdhanAudioMapping.DEFAULT_KEY
                plugin.scheduleSingleAlarm(name, i, hour, minute, volume.toFloat(), resolvedSound, timestampMillis)
                scheduled = true
            }

            if (!scheduled) {
                Log.w(TAG, "No adhan prayers to reschedule after boot")
            } else {
                Log.i(TAG, "Boot reschedule complete for $todayKey")
            }
        } catch (e: Exception) {
            Log.e(TAG, "Failed to reschedule after boot", e)
        }
    }
}
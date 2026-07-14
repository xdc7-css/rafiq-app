package com.dailyislamicwidget.daily_islamic_widget

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.util.Log

class AdhanAlarmReceiver : BroadcastReceiver() {

    companion object {
        private const val TAG = "AdhanAlarmReceiver"
        const val ACTION_ADHAN_ALARM = "com.dailyislamicwidget.action.ADHAN_ALARM"
    }

    override fun onReceive(context: Context, intent: Intent) {
        val prayerName = intent.getStringExtra("prayer_name") ?: run {
            Log.w(TAG, "No prayer name in intent")
            return
        }
        val prayerIndex = intent.getIntExtra("prayer_index", -1)
        val volume = intent.getFloatExtra("volume", 1.0f)
        val soundName = intent.getStringExtra("sound_name") ?: AdhanAudioMapping.DEFAULT_KEY
        val rawResId = intent.getIntExtra("raw_res_id", 0)

        Log.i(TAG, "Alarm received for $prayerName (index=$prayerIndex, volume=$volume, sound=$soundName)")

        val serviceIntent = Intent(context, AdhanForegroundService::class.java).apply {
            action = AdhanForegroundService.ACTION_PLAY_ADHAN
            putExtra(AdhanForegroundService.EXTRA_PRAYER_NAME, prayerName)
            putExtra(AdhanForegroundService.EXTRA_PRAYER_INDEX, prayerIndex)
            putExtra(AdhanForegroundService.EXTRA_VOLUME, volume)
            putExtra(AdhanForegroundService.EXTRA_SOUND_NAME, soundName)
            putExtra(AdhanForegroundService.EXTRA_RAW_RES_ID, rawResId)
        }

        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                context.startForegroundService(serviceIntent)
            } else {
                context.startService(serviceIntent)
            }
        } catch (e: IllegalStateException) {
            // ForegroundServiceStartNotAllowedException on Android 12+
            // This happens when exact alarm permission is revoked and service
            // is started from background without a valid exemption.
            // Fall back to starting as a regular service — playback won't
            // survive Doze but the notification will still be shown if the
            // app process is alive.
            Log.w(TAG, "Cannot start foreground service from background, trying regular start: ${e.message}")
            try {
                context.startService(serviceIntent)
            } catch (e2: Exception) {
                Log.e(TAG, "Failed to start service even as regular service", e2)
            }
        } catch (e: Exception) {
            Log.e(TAG, "Failed to start adhan service", e)
        }
    }
}

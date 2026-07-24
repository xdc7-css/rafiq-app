package com.dailyislamicwidget.daily_islamic_widget

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.PowerManager
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

        Log.i(TAG, "[VERIFICATION] ALARM_RECEIVED for $prayerName (index=$prayerIndex, volume=$volume, sound=$soundName, rawResId=$rawResId)")

        // Phase 4.1: Track alarm fire
        AdhanScheduleMetadata.recordAlarmFire(context, true, prayerName)

        // Acquire a short-lived WakeLock to keep the CPU alive while starting the
        // foreground service.  Without this, the CPU may sleep in Doze mode between
        // onReceive() returning and the service fully starting.
        val wakeLockTag = "${context.packageName}:adhan_receiver"
        val wakeLock = (context.getSystemService(Context.POWER_SERVICE) as PowerManager)
            .newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, wakeLockTag)

        try {
            wakeLock.acquire(30_000L) // 30 second timeout — safety net
            Log.i(TAG, "[VERIFICATION] RECEIVER_WAKELOCK_ACQUIRED (tag=$wakeLockTag, isHeld=${wakeLock.isHeld})")

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
                    Log.i(TAG, "[VERIFICATION] Starting foreground service (API ${Build.VERSION.SDK_INT})...")
                    context.startForegroundService(serviceIntent)
                    Log.i(TAG, "[VERIFICATION] startForegroundService() returned successfully")
                } else {
                    Log.i(TAG, "[VERIFICATION] Starting regular service (API < 26)...")
                    context.startService(serviceIntent)
                    Log.i(TAG, "[VERIFICATION] startService() returned successfully")
                }
            } catch (e: IllegalStateException) {
                // ForegroundServiceStartNotAllowedException on Android 12+
                Log.w(TAG, "[VERIFICATION] FOREGROUND_SERVICE_START_BLOCKED: ${e.message}")
                Log.w(TAG, "[VERIFICATION] This means Android blocked background service start. Trying regular service...")
                try {
                    context.startService(serviceIntent)
                    Log.i(TAG, "[VERIFICATION] Regular startService() succeeded as fallback")
                } catch (e2: Exception) {
                    Log.e(TAG, "[VERIFICATION] REGULAR_SERVICE_START_FAILED: ${e2.message}")
                    // Phase 4.1: Track alarm fire failure (both service start attempts failed)
                    AdhanScheduleMetadata.recordAlarmFire(context, false, prayerName)
                }
            } catch (e: Exception) {
                Log.e(TAG, "[VERIFICATION] SERVICE_START_FAILED: ${e.message}", e)
                // Phase 4.1: Track alarm fire failure
                AdhanScheduleMetadata.recordAlarmFire(context, false, prayerName)
            }
        } finally {
            if (wakeLock.isHeld) {
                wakeLock.release()
                Log.i(TAG, "[VERIFICATION] RECEIVER_WAKELOCK_RELEASED")
            } else {
                Log.w(TAG, "[VERIFICATION] RECEIVER_WAKELOCK_NOT_HELD (already expired or never acquired)")
            }
        }
    }
}

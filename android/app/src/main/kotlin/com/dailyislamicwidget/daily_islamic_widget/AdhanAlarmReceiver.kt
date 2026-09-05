package com.dailyislamicwidget.daily_islamic_widget

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.PowerManager
import android.util.Log

/**
 * AdhanAlarmReceiver — Catches exact alarms scheduled by AlarmManager at prayer time.
 *
 * Hardened Architecture:
 *   1. Bounded WakeLock (15s) guarantees CPU execution during dispatch.
 *   2. Evaluates lateness policy:
 *        - ON_TIME (< 15 min): Direct notification + full Adhan audio via ForegroundService.
 *        - LATE (15 - 45 min): Heads-up notification, skips long audio playback.
 *        - MISSED (> 45 min): Subtle missed-prayer notification, zero loud audio.
 *   3. Defense-in-depth: Immediately posts a high-priority notification via NotificationManager.
 *      Even if Android 12+ throws ForegroundServiceStartNotAllowedException, the notification
 *      is already delivered to the user with vibration and action buttons.
 *   4. Safe foreground service start with exhaustive exception handling.
 */
class AdhanAlarmReceiver : BroadcastReceiver() {

    companion object {
        private const val TAG = "AdhanAlarmReceiver"
        const val ACTION_ADHAN_ALARM = "com.dailyislamicwidget.action.ADHAN_ALARM"

        // Lateness thresholds in milliseconds
        private const val THRESHOLD_LATE_MS = 15 * 60 * 1000L    // 15 minutes
        private const val THRESHOLD_MISSED_MS = 45 * 60 * 1000L  // 45 minutes
    }

    override fun onReceive(context: Context, intent: Intent) {
        val prayerName = intent.getStringExtra("prayer_name") ?: run {
            Log.w(TAG, "[ALARM] No prayer name in intent, ignoring")
            return
        }
        val prayerIndex = intent.getIntExtra("prayer_index", -1)
        val volume = intent.getFloatExtra("volume", 1.0f)
        val soundName = intent.getStringExtra("sound_name") ?: AdhanAudioMapping.DEFAULT_KEY
        val rawResId = intent.getIntExtra("raw_res_id", 0)
        val scheduledTime = intent.getLongExtra("scheduled_time", -1L)
        val isTest = prayerIndex == -1 || intent.hasExtra("test_delay_seconds")

        val now = System.currentTimeMillis()
        val latenessMs = if (scheduledTime > 0L) (now - scheduledTime).coerceAtLeast(0L) else 0L
        val minutesLate = latenessMs / (60 * 1000L)

        Log.i(TAG, "[ALARM] Received alarm for $prayerName (index=$prayerIndex, isTest=$isTest, scheduled=$scheduledTime, lateness=${minutesLate}m)")

        // Record alarm fire event in diagnostics
        AdhanScheduleMetadata.recordAlarmFire(context, true, prayerName)

        val powerManager = context.getSystemService(Context.POWER_SERVICE) as PowerManager
        val wakeLockTag = "${context.packageName}:adhan_alarm_receiver"
        val wakeLock = powerManager.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, wakeLockTag).apply {
            setReferenceCounted(false)
        }

        try {
            wakeLock.acquire(15_000L) // 15-second bounded execution window
            Log.i(TAG, "[ALARM] WakeLock acquired for 15s")

            // ─── Step 1: Lateness Assessment ───────────────────────────────────────────
            if (!isTest && latenessMs > THRESHOLD_MISSED_MS) {
                // MISSED: Device was off or heavily delayed. Do not blast loud audio hours late.
                Log.w(TAG, "[ALARM] MISSED: Alarm for $prayerName is ${minutesLate}m late (> 45m). Posting missed prayer notification.")
                val missedNotif = AdhanNotificationHelper.buildMissedPrayerNotification(context, prayerName, minutesLate)
                AdhanNotificationHelper.postNotification(context, AdhanNotificationHelper.MISSED_NOTIFICATION_ID, missedNotif)
                return
            }

            val isLate = !isTest && latenessMs > THRESHOLD_LATE_MS

            // ─── Step 2: Direct High-Priority Heads-Up Notification (Defense-in-Depth) ─
            // Posting notification directly guarantees the user sees the prayer alert immediately,
            // regardless of whether the background foreground service is accepted or delayed by Android.
            val notification = AdhanNotificationHelper.buildAdhanNotification(
                context = context,
                prayerName = prayerName,
                isTest = isTest,
                isLate = isLate
            )
            AdhanNotificationHelper.postNotification(context, AdhanNotificationHelper.NOTIFICATION_ID, notification)
            Log.i(TAG, "[ALARM] Direct heads-up notification posted")

            // If moderately late (15-45 min), do not play full 4-minute recitation; notification suffices
            if (isLate) {
                Log.i(TAG, "[ALARM] LATE: Alarm is ${minutesLate}m late. Notification shown without full audio playback.")
                return
            }

            // ─── Step 3: Launch Audio Playback Service ─────────────────────────────────
            val serviceIntent = Intent(context, AdhanForegroundService::class.java).apply {
                action = if (isTest) AdhanForegroundService.ACTION_PLAY_TEST else AdhanForegroundService.ACTION_PLAY_ADHAN
                putExtra(AdhanForegroundService.EXTRA_PRAYER_NAME, prayerName)
                putExtra(AdhanForegroundService.EXTRA_PRAYER_INDEX, prayerIndex)
                putExtra(AdhanForegroundService.EXTRA_VOLUME, volume)
                putExtra(AdhanForegroundService.EXTRA_SOUND_NAME, soundName)
                putExtra(AdhanForegroundService.EXTRA_RAW_RES_ID, rawResId)
            }

            try {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    Log.i(TAG, "[ALARM] Calling startForegroundService (API ${Build.VERSION.SDK_INT})...")
                    context.startForegroundService(serviceIntent)
                    Log.i(TAG, "[ALARM] startForegroundService dispatched successfully")
                } else {
                    context.startService(serviceIntent)
                    Log.i(TAG, "[ALARM] startService dispatched successfully (API < 26)")
                }
            } catch (e: Exception) {
                // ForegroundServiceStartNotAllowedException on Android 12+ if background start is restricted
                Log.e(TAG, "[ALARM] Foreground service start restricted: ${e.message}", e)
                AdhanScheduleMetadata.recordAlarmFire(context, false, "$prayerName (service start failed: ${e.message})")
                // User still has the heads-up notification posted in Step 2!
            }

        } catch (e: Exception) {
            Log.e(TAG, "[ALARM] Receiver processing error: ${e.message}", e)
        } finally {
            try {
                if (wakeLock.isHeld) {
                    wakeLock.release()
                    Log.i(TAG, "[ALARM] WakeLock released")
                }
            } catch (_: Exception) {}
        }
    }
}

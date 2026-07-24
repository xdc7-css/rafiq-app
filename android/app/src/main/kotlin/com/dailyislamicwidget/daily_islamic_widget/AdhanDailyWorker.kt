package com.dailyislamicwidget.daily_islamic_widget

import android.content.Context
import android.content.SharedPreferences
import android.util.Log
import androidx.work.CoroutineWorker
import androidx.work.WorkerParameters
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import org.json.JSONObject
import java.util.Calendar
import java.util.TimeZone

/**
 * AdhanDailyWorker — WorkManager coroutine worker for daily adhan reliability.
 *
 * Phase 4.1 changes:
 *   - OneTimeWorkRequest chain: schedules next worker at end of execution
 *   - skipAlarmReschedule flag: prevents cancelling alarms when BootReceiver
 *     already set them synchronously
 *   - cancelAllAlarms moved to AFTER JSON parsing to avoid destroying valid
 *     alarms on corrupted data
 *   - Every failure path logs and updates metadata
 */
class AdhanDailyWorker(
    private val context: Context,
    params: WorkerParameters
) : CoroutineWorker(context, params) {

    companion object {
        private const val TAG = "AdhanDailyWorker"
        private const val PREFS_NAME = "adhan_schedule"
        private const val KEY_PRAYER_TIMES_JSON = "prayer_times_json"
        private const val KEY_LAST_SCHEDULED_DAY = "last_scheduled_day"
        private const val KEY_ADHAN_ENABLED = "adhan_enabled"
        private const val KEY_ADHAN_VOLUME = "adhan_volume"
        private const val KEY_SELECTED_SOUND = "selected_sound"
        private const val KEY_ADHAN_FAJR = "adhan_fajr"
        private const val KEY_ADHAN_DHUHR = "adhan_dhuhr"
        private const val KEY_ADHAN_MAGHRIB = "adhan_maghrib"

        private val ADHAN_PRAYER_NAMES = listOf("Fajr", "Dhuhr", "Maghrib")

        const val WORK_NAME_DAILY = "adhan_daily_worker"
        const val WORK_NAME_IMMEDIATE = "adhan_immediate_worker"
    }

    private val prefs: SharedPreferences =
        context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)

    override suspend fun doWork(): Result = withContext(Dispatchers.IO) {
        val startTime = System.currentTimeMillis()
        val trigger = inputData.getString("trigger") ?: "periodic"
        val skipAlarmReschedule = inputData.getBoolean("skipAlarmReschedule", false)
        Log.i(TAG, "[PHASE4.1] WORKER_START: trigger=$trigger, skipAlarmReschedule=$skipAlarmReschedule, timezone=${TimeZone.getDefault().id}")

        try {
            // ── Step 1: Check if adhan is enabled ──
            val adhanEnabled = prefs.getBoolean(KEY_ADHAN_ENABLED, true)
            if (!adhanEnabled) {
                Log.i(TAG, "[PHASE4.1] WORKER_SKIP: adhan disabled")
                AdhanScheduleMetadata.recordWorkerRun(context, true)
                // Still schedule next worker — adhan might be re-enabled later
                AdhanWorkManager.scheduleNext(context)
                return@withContext Result.success()
            }

            // ── Step 2: Detect timezone changes ──
            val currentTimezone = TimeZone.getDefault().id
            val storedTimezone = AdhanScheduleMetadata.getTimezoneId(context)
            if (storedTimezone.isNotEmpty() && storedTimezone != currentTimezone) {
                Log.i(TAG, "[PHASE4.1] TIMEZONE_CHANGED: $storedTimezone → $currentTimezone")
                AdhanScheduleMetadata.updateTimezone(context, currentTimezone)
            }
            AdhanScheduleMetadata.updateTimezone(context, currentTimezone)

            // ── Step 3: Load stored prayer schedule ──
            val prayerTimesJson = prefs.getString(KEY_PRAYER_TIMES_JSON, null)
            if (prayerTimesJson.isNullOrEmpty()) {
                Log.w(TAG, "[PHASE4.1] WORKER_WARN: no stored prayer schedule")
                AdhanScheduleMetadata.recordWorkerRun(context, true)
                AdhanWorkManager.scheduleNext(context)
                return@withContext Result.success()
            }

            // ── Step 4: Parse JSON ──
            val json: JSONObject
            try {
                json = JSONObject(prayerTimesJson)
            } catch (e: Exception) {
                Log.e(TAG, "[PHASE4.1] CORRUPTED_JSON: ${e.message}")
                prefs.edit().remove(KEY_PRAYER_TIMES_JSON).remove(KEY_LAST_SCHEDULED_DAY).apply()
                AdhanScheduleMetadata.recordWorkerRun(context, false)
                AdhanWorkManager.scheduleNext(context)
                return@withContext Result.success() // Don't retry — corrupted data won't fix itself
            }

            // ── Step 5: Self-heal (if not boot-triggered) ──
            val healResult: HealResult
            if (skipAlarmReschedule) {
                Log.i(TAG, "[PHASE4.1] SKIP_ALARM_RESCHEDULE: boot/timezone handler set alarms")
                healResult = HealResult(0, 0, 0)
            } else {
                healResult = selfHealSchedule(json)
                Log.i(TAG, "[PHASE4.1] SELF_HEAL_RESULT: scheduled=${healResult.scheduled}, skipped=${healResult.skipped}, failed=${healResult.failed}")
            }

            // ── Step 6: Verify scheduling succeeded ──
            val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as android.app.AlarmManager
            val nextAlarm = alarmManager.nextAlarmClock?.triggerTime
            val schedulingVerified = nextAlarm != null && nextAlarm > System.currentTimeMillis()
            Log.i(TAG, "[PHASE4.1] SCHEDULING_VERIFIED=$schedulingVerified (nextAlarm=$nextAlarm)")

            // ── Step 7: Run integrity checks ──
            val integrity = try {
                AdhanIntegrityChecker.check(context)
            } catch (e: Exception) {
                Log.e(TAG, "[PHASE4.1] INTEGRITY_CHECK_FAILED: ${e.message}", e)
                AdhanIntegrityChecker.IntegrityReport("unknown", 0, "integrity check crashed: ${e.message}", emptyMap())
            }
            AdhanScheduleMetadata.recordVerification(
                context,
                integrity.status,
                integrity.score,
                integrity.details
            )
            Log.i(TAG, "[PHASE4.1] INTEGRITY: status=${integrity.status}, score=${integrity.score}")

            // ── Step 8: Update widgets ──
            refreshAllWidgets(context)

            // ── Step 9: Record metadata ──
            AdhanScheduleMetadata.recordSuccessfulScheduling(context)
            AdhanScheduleMetadata.recordWorkerRun(context, true)

            // ── Step 10: Schedule next worker (OneTime chain) ──
            AdhanWorkManager.scheduleNext(context)

            val elapsed = System.currentTimeMillis() - startTime
            Log.i(TAG, "[PHASE4.1] WORKER_COMPLETE: elapsed=${elapsed}ms, scheduled=${healResult.scheduled}, verified=$schedulingVerified, integrity=${integrity.status}")

            Result.success()

        } catch (e: Exception) {
            Log.e(TAG, "[PHASE4.1] WORKER_FAILED: ${e.message}", e)
            AdhanScheduleMetadata.recordWorkerRun(context, false)
            // Schedule next worker even on failure — don't break the chain
            AdhanWorkManager.scheduleNext(context)
            Result.success() // Don't retry — scheduleNext handles recovery
        }
    }

    // ── Self-healing ─────────────────────────────────────────────────────

    private data class HealResult(val scheduled: Int, val skipped: Int, val failed: Int)

    /**
     * Phase 4.1: Parses JSON FIRST, then cancels and reschedules.
     * This prevents destroying valid alarms when JSON is corrupted.
     */
    private fun selfHealSchedule(json: JSONObject): HealResult {
        Log.i(TAG, "[PHASE4.1] SELF_HEAL_STARTED")

        val volume = json.optDouble("volume", 1.0)
        val soundName = json.optString("selectedSound", AdhanAudioMapping.DEFAULT_KEY)
        val enabled = json.optJSONObject("enabled")
        val prayersArray = json.optJSONArray("prayers")

        if (prayersArray == null) {
            Log.w(TAG, "[PHASE4.1] SELF_HEAL: no prayers array — schedule corrupted, preserving existing alarms")
            return HealResult(0, 0, 1)
        }

        // Phase 4.1: Parse ALL prayers FIRST, then cancel and reschedule.
        // This avoids destroying valid alarms if parsing fails midway.
        data class ParsedPrayer(val name: String, val index: Int, val hour: Int, val minute: Int, val timestampMillis: Long)

        val validPrayers = mutableListOf<ParsedPrayer>()
        val now = System.currentTimeMillis()

        for (i in 0 until prayersArray.length()) {
            val prayer = try {
                prayersArray.getJSONObject(i)
            } catch (e: Exception) {
                Log.w(TAG, "[PHASE4.1] PRAYER_PARSE_ERROR at index=$i: ${e.message}")
                continue
            }

            val name = prayer.optString("name", "")
            if (name !in ADHAN_PRAYER_NAMES) continue

            val isEnabled = enabled?.optBoolean(name, true) ?: true
            if (!isEnabled) {
                Log.d(TAG, "[PHASE4.1] PRAYER_SKIPPED: $name (disabled)")
                continue
            }

            val timestampMillis = prayer.optLong("timestampMillis", -1L)
            val time = prayer.optString("time", "")
            val parts = time.split(":")
            if (parts.size != 2) {
                Log.w(TAG, "[PHASE4.1] INVALID_TIME: $name time='$time'")
                continue
            }

            val hour = parts[0].toIntOrNull()
            val minute = parts[1].toIntOrNull()
            if (hour == null || minute == null) {
                Log.w(TAG, "[PHASE4.1] INVALID_TIME_FORMAT: $name time='$time'")
                continue
            }

            // Skip prayers in the past
            if (timestampMillis > 0 && timestampMillis < now) {
                Log.d(TAG, "[PHASE4.1] PRAYER_PAST: $name (already fired)")
                continue
            }

            val prayerIndex = ADHAN_PRAYER_NAMES.indexOf(name)
            validPrayers.add(ParsedPrayer(name, prayerIndex, hour, minute, timestampMillis))
        }

        if (validPrayers.isEmpty()) {
            Log.w(TAG, "[PHASE4.1] SELF_HEAL: no valid prayers to schedule, preserving existing alarms")
            return HealResult(0, 0, 0)
        }

        // Phase 4.1: NOW cancel all alarms and reschedule.
        // This is safe because we've validated the new schedule.
        cancelAllAlarms()

        val plugin = AdhanPlugin(context)
        var scheduled = 0
        var failed = 0

        for (prayer in validPrayers) {
            val resolvedSound = if (AdhanAudioMapping.isValidKey(soundName)) soundName else AdhanAudioMapping.DEFAULT_KEY
            try {
                plugin.scheduleSingleAlarm(prayer.name, prayer.index, prayer.hour, prayer.minute, volume.toFloat(), resolvedSound, prayer.timestampMillis)
                scheduled++
                Log.i(TAG, "[PHASE4.1] ALARM_SCHEDULED: ${prayer.name} at ${String.format("%02d:%02d", prayer.hour, prayer.minute)}")
            } catch (e: Exception) {
                Log.e(TAG, "[PHASE4.1] ALARM_SCHEDULE_FAILED: ${prayer.name} — ${e.message}", e)
                failed++
            }
        }

        // Update stored day key
        val todayKey = getTodayKey()
        prefs.edit().putInt(KEY_LAST_SCHEDULED_DAY, todayKey).apply()

        Log.i(TAG, "[PHASE4.1] SELF_HEAL_COMPLETE: scheduled=$scheduled, failed=$failed")

        return HealResult(scheduled, validPrayers.size - scheduled, failed)
    }

    private fun cancelAllAlarms() {
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as android.app.AlarmManager
        for (index in ADHAN_PRAYER_NAMES.indices) {
            val pi = android.app.PendingIntent.getBroadcast(
                context,
                4000 + index,
                android.content.Intent(context, AdhanAlarmReceiver::class.java),
                android.app.PendingIntent.FLAG_UPDATE_CURRENT or android.app.PendingIntent.FLAG_IMMUTABLE
            )
            pi.cancel()
            alarmManager.cancel(pi)
        }
        Log.i(TAG, "[PHASE4.1] ALL_ALARMS_CANCELLED")
    }

    // ── Widgets ──────────────────────────────────────────────────────────

    private fun refreshAllWidgets(context: Context) {
        try {
            PrayerTimesWidgetProvider.updateAllWidgets(context)
            QuranWidgetProvider.updateAllWidgets(context)
            TasbihWidgetProvider.updateAllWidgets(context)
            DashboardWidgetProvider.updateAllWidgets(context)
            Log.i(TAG, "[PHASE4.1] WIDGETS_REFRESHED")
        } catch (e: Exception) {
            Log.e(TAG, "[PHASE4.1] WIDGET_REFRESH_FAILED: ${e.message}", e)
        }
    }

    private fun getTodayKey(): Int {
        val now = Calendar.getInstance()
        return now.get(Calendar.DAY_OF_MONTH) +
                (now.get(Calendar.MONTH) + 1) * 100 +
                now.get(Calendar.YEAR) * 10000
    }
}

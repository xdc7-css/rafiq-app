package com.dailyislamicwidget.daily_islamic_widget

import android.content.Context
import android.util.Log
import androidx.work.Constraints
import androidx.work.ExistingWorkPolicy
import androidx.work.NetworkType
import androidx.work.OneTimeWorkRequestBuilder
import androidx.work.WorkManager
import androidx.work.workDataOf
import java.util.Calendar
import java.util.concurrent.TimeUnit

/**
 * AdhanWorkManager — entry point for scheduling AdhanDailyWorker.
 *
 * Phase 4.1: Uses a OneTimeWorkRequest chain instead of PeriodicWorkRequest.
 *
 * Why not PeriodicWorkRequest?
 *   PeriodicWorkRequest(24h) drifts: if execution is delayed (device off, OEM
 *   restriction, Doze), the next 24h timer starts from the LATE execution,
 *   not from the intended midnight. Over days/weeks, this accumulates.
 *
 * OneTime chain strategy:
 *   1. Calculate delay until next 00:05 local time
 *   2. Enqueue OneTimeWorkRequest with that delay
 *   3. At the end of every successful worker, schedule the NEXT worker
 *   4. Chain re-established on boot, app open, or timezone change
 *
 * Unique work name: "adhan_daily_worker" with REPLACE policy ensures
 * only one scheduled worker exists at any time.
 */
object AdhanWorkManager {

    private const val TAG = "AdhanWorkManager"

    /**
     * Schedules a OneTimeWorkRequest to run near the next 00:05 local time.
     * Safe to call multiple times — uses REPLACE to avoid duplicates.
     * This is the core of the Phase 4.1 precise scheduling strategy.
     */
    fun scheduleNext(context: Context) {
        try {
            val delayMinutes = calculateDelayUntilAfterMidnight()
            Log.i(TAG, "[PHASE4.1] SCHEDULE_NEXT: delayMinutes=$delayMinutes (next run ~00:05 local)")

            val constraints = Constraints.Builder()
                .setRequiredNetworkType(NetworkType.NOT_REQUIRED)
                .setRequiresBatteryNotLow(false)
                .build()

            val workRequest = OneTimeWorkRequestBuilder<AdhanDailyWorker>()
                .setInitialDelay(delayMinutes, TimeUnit.MINUTES)
                .setInputData(workDataOf("trigger" to "scheduled"))
                .setConstraints(constraints)
                .addTag("adhan_daily")
                .build()

            WorkManager.getInstance(context)
                .enqueueUniqueWork(
                    AdhanDailyWorker.WORK_NAME_DAILY,
                    ExistingWorkPolicy.REPLACE,
                    workRequest
                )

            Log.i(TAG, "[PHASE4.1] NEXT_WORKER_SCHEDULED: will run in ${delayMinutes}min")
        } catch (e: Exception) {
            Log.e(TAG, "[PHASE4.1] SCHEDULE_NEXT_FAILED: ${e.message}", e)
        }
    }

    /**
     * Enqueues an immediate one-time worker for boot/timezone/update recovery.
     * Uses REPLACE policy so only one immediate worker runs at a time.
     * Sets skipAlarmReschedule=true when called from BootReceiver to avoid
     * cancelling alarms that BootReceiver already set synchronously.
     */
    fun runImmediately(context: Context, trigger: String = "immediate", skipAlarmReschedule: Boolean = false) {
        try {
            Log.i(TAG, "[PHASE4.1] RUN_IMMEDIATELY: trigger=$trigger, skipAlarmReschedule=$skipAlarmReschedule")

            val constraints = Constraints.Builder()
                .setRequiredNetworkType(NetworkType.NOT_REQUIRED)
                .build()

            val inputData = workDataOf(
                "trigger" to trigger,
                "skipAlarmReschedule" to skipAlarmReschedule
            )

            val workRequest = OneTimeWorkRequestBuilder<AdhanDailyWorker>()
                .setInputData(inputData)
                .setConstraints(constraints)
                .addTag("adhan_immediate")
                .build()

            WorkManager.getInstance(context)
                .enqueueUniqueWork(
                    AdhanDailyWorker.WORK_NAME_IMMEDIATE,
                    ExistingWorkPolicy.REPLACE,
                    workRequest
                )

            Log.i(TAG, "[PHASE4.1] IMMEDIATE_WORKER_ENQUEUED")
        } catch (e: Exception) {
            Log.e(TAG, "[PHASE4.1] IMMEDIATE_ENQUEUE_FAILED: ${e.message}", e)
        }
    }

    /**
     * Cancels all Adhan-related work (used when adhan is completely disabled).
     */
    fun cancelAll(context: Context) {
        try {
            WorkManager.getInstance(context)
                .cancelUniqueWork(AdhanDailyWorker.WORK_NAME_DAILY)
            WorkManager.getInstance(context)
                .cancelUniqueWork(AdhanDailyWorker.WORK_NAME_IMMEDIATE)
            Log.i(TAG, "[PHASE4.1] ALL_WORK_CANCELLED")
        } catch (e: Exception) {
            Log.e(TAG, "[PHASE4.1] CANCEL_FAILED: ${e.message}", e)
        }
    }

    /**
     * Calculates minutes until ~5 minutes after midnight (local time).
     *
     * Phase 4.1: Simplified logic. No unused variables.
     *
     * Returns 1-1440 (minutes in a day).
     */
    private fun calculateDelayUntilAfterMidnight(): Long {
        val now = Calendar.getInstance()
        val todayTarget = Calendar.getInstance().apply {
            set(Calendar.HOUR_OF_DAY, 0)
            set(Calendar.MINUTE, 5)
            set(Calendar.SECOND, 0)
            set(Calendar.MILLISECOND, 0)
        }

        val delayMillis: Long = if (now.before(todayTarget)) {
            // Before 00:05 today → target today's 00:05
            todayTarget.timeInMillis - now.timeInMillis
        } else {
            // After 00:05 today → target tomorrow's 00:05
            todayTarget.add(Calendar.DAY_OF_MONTH, 1)
            todayTarget.timeInMillis - now.timeInMillis
        }

        val delayMinutes = delayMillis / (60 * 1000)
        Log.i(TAG, "[PHASE4.1] DELAY_CALC: now=${now.time}, target=${todayTarget.time}, delayMs=$delayMillis, delayMin=$delayMinutes")
        return delayMinutes.coerceIn(1, 1440)
    }
}

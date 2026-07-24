package com.dailyislamicwidget.daily_islamic_widget

import android.content.Context
import android.content.SharedPreferences
import android.content.pm.PackageManager
import android.util.Log

/**
 * AdhanScheduleMetadata — persistent schedule metadata.
 *
 * Phase 4.1 additions:
 *   - lastSuccessfulAlarmFire / lastFailedAlarmFire (from AdhanAlarmReceiver)
 *   - lastWorkerSuccess / lastWorkerFailure timestamps
 *   - nextScheduledWorker (when the next OneTime chain worker will run)
 *   - appVersion / buildNumber (for version tracking)
 *
 * All writes use apply() (async). All reads are synchronous from memory.
 */
object AdhanScheduleMetadata {

    private const val TAG = "AdhanScheduleMetadata"
    private const val PREFS_NAME = "adhan_schedule_metadata"
    private const val VERSION = 2

    // ── Keys ─────────────────────────────────────────────────────────────
    private const val KEY_LAST_SUCCESSFUL_SCHEDULING = "last_successful_scheduling"
    private const val KEY_LAST_VERIFICATION = "last_verification"
    private const val KEY_LAST_WORKER_RUN = "last_worker_run"
    private const val KEY_SCHEDULE_VERSION = "schedule_version"
    private const val KEY_TIMEZONE_ID = "timezone_id"
    private const val KEY_CALCULATION_METHOD = "calculation_method"
    private const val KEY_LAST_INTEGRITY_STATUS = "last_integrity_status"
    private const val KEY_LAST_INTEGRITY_SCORE = "last_integrity_score"
    private const val KEY_LAST_INTEGRITY_DETAILS = "last_integrity_details"
    private const val KEY_TOTAL_WORKER_RUNS = "total_worker_runs"
    private const val KEY_TOTAL_WORKER_FAILURES = "total_worker_failures"
    // Phase 4.1 additions
    private const val KEY_LAST_SUCCESSFUL_ALARM_FIRE = "last_successful_alarm_fire"
    private const val KEY_LAST_FAILED_ALARM_FIRE = "last_failed_alarm_fire"
    private const val KEY_LAST_SUCCESSFUL_ALARM_PRAYER = "last_successful_alarm_prayer"
    private const val KEY_LAST_FAILED_ALARM_PRAYER = "last_failed_alarm_prayer"
    private const val KEY_LAST_WORKER_SUCCESS = "last_worker_success"
    private const val KEY_LAST_WORKER_FAILURE = "last_worker_failure"
    private const val KEY_NEXT_SCHEDULED_WORKER = "next_scheduled_worker"
    private const val KEY_APP_VERSION = "app_version"
    private const val KEY_BUILD_NUMBER = "build_number"
    private const val KEY_TIMEZONE_CHANGE_TIME = "timezone_change_time"

    private fun prefs(context: Context): SharedPreferences =
        context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)

    // ── Writers ──────────────────────────────────────────────────────────

    fun recordSuccessfulScheduling(context: Context) {
        val now = System.currentTimeMillis()
        prefs(context).edit()
            .putLong(KEY_LAST_SUCCESSFUL_SCHEDULING, now)
            .putInt(KEY_SCHEDULE_VERSION, VERSION)
            .apply()
        Log.i(TAG, "[PHASE4.1] METADATA: lastSuccessfulScheduling=$now")
    }

    fun recordVerification(context: Context, status: String, score: Int, details: String) {
        val now = System.currentTimeMillis()
        prefs(context).edit()
            .putLong(KEY_LAST_VERIFICATION, now)
            .putString(KEY_LAST_INTEGRITY_STATUS, status)
            .putInt(KEY_LAST_INTEGRITY_SCORE, score)
            .putString(KEY_LAST_INTEGRITY_DETAILS, details)
            .apply()
        Log.i(TAG, "[PHASE4.1] METADATA: lastVerification=$now, status=$status, score=$score")
    }

    fun recordWorkerRun(context: Context, success: Boolean) {
        val now = System.currentTimeMillis()
        val editor = prefs(context).edit()
        editor.putLong(KEY_LAST_WORKER_RUN, now)

        if (success) {
            editor.putLong(KEY_LAST_WORKER_SUCCESS, now)
            editor.putInt(KEY_TOTAL_WORKER_RUNS, prefs(context).getInt(KEY_TOTAL_WORKER_RUNS, 0) + 1)
        } else {
            editor.putLong(KEY_LAST_WORKER_FAILURE, now)
            editor.putInt(KEY_TOTAL_WORKER_FAILURES, prefs(context).getInt(KEY_TOTAL_WORKER_FAILURES, 0) + 1)
        }

        editor.apply()
        Log.i(TAG, "[PHASE4.1] METADATA: lastWorkerRun=$now, success=$success, totalRuns=${prefs(context).getInt(KEY_TOTAL_WORKER_RUNS, 0)}, totalFailures=${prefs(context).getInt(KEY_TOTAL_WORKER_FAILURES, 0)}")
    }

    fun recordAlarmFire(context: Context, success: Boolean, prayerName: String) {
        val now = System.currentTimeMillis()
        val editor = prefs(context).edit()
        if (success) {
            editor.putLong(KEY_LAST_SUCCESSFUL_ALARM_FIRE, now)
            editor.putString(KEY_LAST_SUCCESSFUL_ALARM_PRAYER, prayerName)
        } else {
            editor.putLong(KEY_LAST_FAILED_ALARM_FIRE, now)
            editor.putString(KEY_LAST_FAILED_ALARM_PRAYER, prayerName)
        }
        editor.apply()
        Log.i(TAG, "[PHASE4.1] METADATA: alarmFire: success=$success, prayer=$prayerName, time=$now")
    }

    fun recordNextScheduledWorker(context: Context, triggerTimeMillis: Long) {
        prefs(context).edit()
            .putLong(KEY_NEXT_SCHEDULED_WORKER, triggerTimeMillis)
            .apply()
        Log.i(TAG, "[PHASE4.1] METADATA: nextScheduledWorker=$triggerTimeMillis")
    }

    fun updateTimezone(context: Context, timezoneId: String) {
        prefs(context).edit()
            .putString(KEY_TIMEZONE_ID, timezoneId)
            .putLong(KEY_TIMEZONE_CHANGE_TIME, System.currentTimeMillis())
            .apply()
        Log.i(TAG, "[PHASE4.1] METADATA: timezoneId=$timezoneId")
    }

    fun updateCalculationMethod(context: Context, method: Int) {
        prefs(context).edit()
            .putInt(KEY_CALCULATION_METHOD, method)
            .apply()
        Log.i(TAG, "[PHASE4.1] METADATA: calculationMethod=$method")
    }

    fun updateAppInfo(context: Context) {
        try {
            val pInfo = context.packageManager.getPackageInfo(context.packageName, 0)
            val versionName = pInfo.versionName ?: "unknown"
            @Suppress("DEPRECATION")
            val versionCode = pInfo.longVersionCode.toInt()
            prefs(context).edit()
                .putString(KEY_APP_VERSION, versionName)
                .putInt(KEY_BUILD_NUMBER, versionCode)
                .apply()
            Log.i(TAG, "[PHASE4.1] METADATA: appVersion=$versionName, buildNumber=$versionCode")
        } catch (e: PackageManager.NameNotFoundException) {
            Log.e(TAG, "[PHASE4.1] METADATA: updateAppInfo FAILED: ${e.message}")
        }
    }

    // ── Readers ──────────────────────────────────────────────────────────

    fun getLastSuccessfulScheduling(context: Context): Long =
        prefs(context).getLong(KEY_LAST_SUCCESSFUL_SCHEDULING, 0L)

    fun getLastVerification(context: Context): Long =
        prefs(context).getLong(KEY_LAST_VERIFICATION, 0L)

    fun getLastWorkerRun(context: Context): Long =
        prefs(context).getLong(KEY_LAST_WORKER_RUN, 0L)

    fun getScheduleVersion(context: Context): Int =
        prefs(context).getInt(KEY_SCHEDULE_VERSION, 0)

    fun getTimezoneId(context: Context): String =
        prefs(context).getString(KEY_TIMEZONE_ID, "") ?: ""

    fun getCalculationMethod(context: Context): Int =
        prefs(context).getInt(KEY_CALCULATION_METHOD, 0)

    fun getLastIntegrityStatus(context: Context): String =
        prefs(context).getString(KEY_LAST_INTEGRITY_STATUS, "unknown") ?: "unknown"

    fun getLastIntegrityScore(context: Context): Int =
        prefs(context).getInt(KEY_LAST_INTEGRITY_SCORE, 0)

    fun getLastIntegrityDetails(context: Context): String =
        prefs(context).getString(KEY_LAST_INTEGRITY_DETAILS, "") ?: ""

    fun getTotalWorkerRuns(context: Context): Int =
        prefs(context).getInt(KEY_TOTAL_WORKER_RUNS, 0)

    fun getTotalWorkerFailures(context: Context): Int =
        prefs(context).getInt(KEY_TOTAL_WORKER_FAILURES, 0)

    fun getLastSuccessfulAlarmFire(context: Context): Long =
        prefs(context).getLong(KEY_LAST_SUCCESSFUL_ALARM_FIRE, 0L)

    fun getLastFailedAlarmFire(context: Context): Long =
        prefs(context).getLong(KEY_LAST_FAILED_ALARM_FIRE, 0L)

    fun getLastSuccessfulAlarmPrayer(context: Context): String =
        prefs(context).getString(KEY_LAST_SUCCESSFUL_ALARM_PRAYER, "") ?: ""

    fun getLastFailedAlarmPrayer(context: Context): String =
        prefs(context).getString(KEY_LAST_FAILED_ALARM_PRAYER, "") ?: ""

    fun getLastWorkerSuccess(context: Context): Long =
        prefs(context).getLong(KEY_LAST_WORKER_SUCCESS, 0L)

    fun getLastWorkerFailure(context: Context): Long =
        prefs(context).getLong(KEY_LAST_WORKER_FAILURE, 0L)

    fun getNextScheduledWorker(context: Context): Long =
        prefs(context).getLong(KEY_NEXT_SCHEDULED_WORKER, 0L)

    fun getAppVersion(context: Context): String =
        prefs(context).getString(KEY_APP_VERSION, "") ?: ""

    fun getBuildNumber(context: Context): Int =
        prefs(context).getInt(KEY_BUILD_NUMBER, 0)

    fun getTimezoneChangeTime(context: Context): Long =
        prefs(context).getLong(KEY_TIMEZONE_CHANGE_TIME, 0L)

    /**
     * Returns a snapshot map of all metadata for diagnostics.
     */
    fun getSnapshot(context: Context): Map<String, Any> = mapOf(
        "lastSuccessfulScheduling" to getLastSuccessfulScheduling(context),
        "lastVerification" to getLastVerification(context),
        "lastWorkerRun" to getLastWorkerRun(context),
        "scheduleVersion" to getScheduleVersion(context),
        "timezoneId" to getTimezoneId(context),
        "calculationMethod" to getCalculationMethod(context),
        "lastIntegrityStatus" to getLastIntegrityStatus(context),
        "lastIntegrityScore" to getLastIntegrityScore(context),
        "totalWorkerRuns" to getTotalWorkerRuns(context),
        "totalWorkerFailures" to getTotalWorkerFailures(context),
        "lastSuccessfulAlarmFire" to getLastSuccessfulAlarmFire(context),
        "lastFailedAlarmFire" to getLastFailedAlarmFire(context),
        "lastSuccessfulAlarmPrayer" to getLastSuccessfulAlarmPrayer(context),
        "lastFailedAlarmPrayer" to getLastFailedAlarmPrayer(context),
        "lastWorkerSuccess" to getLastWorkerSuccess(context),
        "lastWorkerFailure" to getLastWorkerFailure(context),
        "nextScheduledWorker" to getNextScheduledWorker(context),
        "appVersion" to getAppVersion(context),
        "buildNumber" to getBuildNumber(context),
        "timezoneChangeTime" to getTimezoneChangeTime(context),
    )
}

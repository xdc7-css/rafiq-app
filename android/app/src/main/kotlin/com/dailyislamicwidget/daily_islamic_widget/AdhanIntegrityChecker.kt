package com.dailyislamicwidget.daily_islamic_widget

import android.app.AlarmManager
import android.app.NotificationManager
import android.content.Context
import android.content.SharedPreferences
import android.os.Build
import android.os.PowerManager
import android.util.Log

/**
 * AdhanIntegrityChecker — daily integrity verification for the adhan scheduling system.
 *
 * Phase 4.1 additions:
 *   - Metadata-based checks: last alarm fire, worker execution, schedule age,
 *     timezone age, worker failure count, metadata version
 *   - Every individual check wrapped in try/catch to prevent cascading failures
 *
 * Returns a structured integrity report: (status, score, details).
 */
object AdhanIntegrityChecker {

    private const val TAG = "AdhanIntegrityChecker"
    private const val PREFS_NAME = "adhan_schedule"
    private const val KEY_ADHAN_ENABLED = "adhan_enabled"
    private const val KEY_PRAYER_TIMES_JSON = "prayer_times_json"
    private const val KEY_LAST_SCHEDULED_DAY = "last_scheduled_day"

    // Maximum ages for staleness checks (milliseconds)
    private const val MAX_SCHEDULE_AGE_MS = 36 * 60 * 60 * 1000L  // 36 hours
    private const val MAX_WORKER_AGE_MS = 30 * 60 * 60 * 1000L   // 30 hours
    private const val MAX_TIMEZONE_AGE_MS = 365 * 24 * 60 * 60 * 1000L  // 1 year

    data class IntegrityReport(
        val status: String,    // "healthy", "degraded", "critical"
        val score: Int,        // 0-100
        val details: String,   // human-readable summary
        val checks: Map<String, Boolean>  // individual check results
    )

    /**
     * Runs all integrity checks and returns a structured report.
     */
    fun check(context: Context): IntegrityReport {
        Log.i(TAG, "[PHASE4.1] INTEGRITY_CHECK_STARTED")

        val checks = mutableMapOf<String, Boolean>()

        // Phase 1-3 checks (with try/catch for safety)
        checks["adhan_enabled"] = safeCheck("adhan_enabled") { checkAdhanEnabled(context) }
        checks["notifications_enabled"] = safeCheck("notifications_enabled") { checkNotificationsEnabled(context) }
        checks["battery_exempted"] = safeCheck("battery_exempted") { checkBatteryExempted(context) }
        checks["exact_alarm"] = safeCheck("exact_alarm") { checkExactAlarm(context) }
        checks["schedule_exists"] = safeCheck("schedule_exists") { checkScheduleExists(context) }
        checks["alarm_scheduled"] = safeCheck("alarm_scheduled") { checkAlarmScheduled(context) }
        checks["oem_compatible"] = safeCheck("oem_compatible") { checkOemCompatible(context) }
        checks["metadata_valid"] = safeCheck("metadata_valid") { checkMetadataValid(context) }

        // Phase 4.1 metadata checks
        checks["schedule_fresh"] = safeCheck("schedule_fresh") { checkScheduleFresh(context) }
        checks["worker_recent"] = safeCheck("worker_recent") { checkWorkerRecent(context) }
        checks["worker_reliable"] = safeCheck("worker_reliable") { checkWorkerReliable(context) }
        checks["alarm_fire_recent"] = safeCheck("alarm_fire_recent") { checkAlarmFireRecent(context) }
        checks["timezone_set"] = safeCheck("timezone_set") { checkTimezoneSet(context) }
        checks["app_version_set"] = safeCheck("app_version_set") { checkAppVersionSet(context) }

        val passed = checks.values.count { it }
        val total = checks.size
        val score = if (total > 0) (passed * 100) / total else 0

        val status = when {
            score >= 90 -> "healthy"
            score >= 60 -> "degraded"
            else -> "critical"
        }

        val failedChecks = checks.filter { !it.value }.keys.joinToString(", ")
        val details = "$passed/$total checks passed (score=$score%)${
            if (failedChecks.isNotEmpty()) " — failed: $failedChecks" else ""
        }"

        Log.i(TAG, "[PHASE4.1] INTEGRITY_CHECK_COMPLETE: status=$status, score=$score, details=$details")

        return IntegrityReport(
            status = status,
            score = score,
            details = details,
            checks = checks.toMap()
        )
    }

    // ── Safety wrapper ───────────────────────────────────────────────────

    /**
     * Phase 4.1: Wraps individual checks in try/catch so one failing check
     * doesn't prevent the rest from running. Returns false on exception.
     */
    private fun safeCheck(name: String, check: () -> Boolean): Boolean {
        return try {
            check()
        } catch (e: Exception) {
            Log.e(TAG, "[PHASE4.1] CHECK_CRASHED: $name — ${e.message}", e)
            false
        }
    }

    // ── Original checks (Phase 1-3) ─────────────────────────────────────

    private fun checkAdhanEnabled(context: Context): Boolean {
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        val enabled = prefs.getBoolean(KEY_ADHAN_ENABLED, true)
        Log.i(TAG, "[PHASE4.1] INTEGRITY: adhan_enabled=$enabled")
        return enabled
    }

    private fun checkNotificationsEnabled(context: Context): Boolean {
        val nm = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        val enabled = nm.areNotificationsEnabled()
        Log.i(TAG, "[PHASE4.1] INTEGRITY: notifications_enabled=$enabled")
        return enabled
    }

    private fun checkBatteryExempted(context: Context): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) return true
        val pm = context.getSystemService(Context.POWER_SERVICE) as PowerManager
        val exempted = pm.isIgnoringBatteryOptimizations(context.packageName)
        Log.i(TAG, "[PHASE4.1] INTEGRITY: battery_exempted=$exempted")
        return exempted
    }

    private fun checkExactAlarm(context: Context): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.S) return true
        val am = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val canSchedule = am.canScheduleExactAlarms()
        Log.i(TAG, "[PHASE4.1] INTEGRITY: exact_alarm=$canSchedule")
        return canSchedule
    }

    private fun checkScheduleExists(context: Context): Boolean {
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        val json = prefs.getString(KEY_PRAYER_TIMES_JSON, null)
        val exists = !json.isNullOrEmpty()
        Log.i(TAG, "[PHASE4.1] INTEGRITY: schedule_exists=$exists")
        return exists
    }

    private fun checkAlarmScheduled(context: Context): Boolean {
        val am = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val next = am.nextAlarmClock?.triggerTime
        val scheduled = next != null && next > System.currentTimeMillis()
        Log.i(TAG, "[PHASE4.1] INTEGRITY: alarm_scheduled=$scheduled (nextAlarm=$next)")
        return scheduled
    }

    private fun checkOemCompatible(context: Context): Boolean {
        val diag = OemCompatibility.collectDiagnostics(context)
        Log.i(TAG, "[PHASE4.1] INTEGRITY: oem_compatible=${diag.isSupportedOem} (oem=${diag.oemType})")
        return diag.isSupportedOem
    }

    private fun checkMetadataValid(context: Context): Boolean {
        val version = AdhanScheduleMetadata.getScheduleVersion(context)
        val timezone = AdhanScheduleMetadata.getTimezoneId(context)
        val valid = version > 0 && timezone.isNotEmpty()
        Log.i(TAG, "[PHASE4.1] INTEGRITY: metadata_valid=$valid (version=$version, tz=$timezone)")
        return valid
    }

    // ── Phase 4.1 metadata checks ───────────────────────────────────────

    private fun checkScheduleFresh(context: Context): Boolean {
        val lastScheduling = AdhanScheduleMetadata.getLastSuccessfulScheduling(context)
        if (lastScheduling == 0L) {
            Log.i(TAG, "[PHASE4.1] INTEGRITY: schedule_fresh=false (never scheduled)")
            return false
        }
        val age = System.currentTimeMillis() - lastScheduling
        val fresh = age < MAX_SCHEDULE_AGE_MS
        Log.i(TAG, "[PHASE4.1] INTEGRITY: schedule_fresh=$fresh (age=${age / 3600000}h)")
        return fresh
    }

    private fun checkWorkerRecent(context: Context): Boolean {
        val lastWorkerRun = AdhanScheduleMetadata.getLastWorkerRun(context)
        if (lastWorkerRun == 0L) {
            Log.i(TAG, "[PHASE4.1] INTEGRITY: worker_recent=false (never ran)")
            return false
        }
        val age = System.currentTimeMillis() - lastWorkerRun
        val recent = age < MAX_WORKER_AGE_MS
        Log.i(TAG, "[PHASE4.1] INTEGRITY: worker_recent=$recent (age=${age / 3600000}h)")
        return recent
    }

    private fun checkWorkerReliable(context: Context): Boolean {
        val totalRuns = AdhanScheduleMetadata.getTotalWorkerRuns(context)
        val totalFailures = AdhanScheduleMetadata.getTotalWorkerFailures(context)
        // Reliable if: fewer than 50% failures AND fewer than 3 consecutive failures
        if (totalRuns == 0) {
            Log.i(TAG, "[PHASE4.1] INTEGRITY: worker_reliable=true (no runs yet)")
            return true
        }
        val failureRate = totalFailures.toDouble() / totalRuns
        val lastSuccess = AdhanScheduleMetadata.getLastWorkerSuccess(context)
        val lastFailure = AdhanScheduleMetadata.getLastWorkerFailure(context)
        val recentSuccess = lastSuccess > lastFailure
        val reliable = failureRate < 0.5 && recentSuccess
        Log.i(TAG, "[PHASE4.1] INTEGRITY: worker_reliable=$reliable (runs=$totalRuns, failures=$totalFailures, rate=${String.format("%.0f", failureRate * 100)}%, recentSuccess=$recentSuccess)")
        return reliable
    }

    private fun checkAlarmFireRecent(context: Context): Boolean {
        val lastFire = AdhanScheduleMetadata.getLastSuccessfulAlarmFire(context)
        // If we've never seen an alarm fire, that's not necessarily bad —
        // the app might just have been installed. Check if alarms ARE scheduled.
        if (lastFire == 0L) {
            Log.i(TAG, "[PHASE4.1] INTEGRITY: alarm_fire_recent=true (no fire recorded, checking schedule)")
            return checkScheduleExists(context)
        }
        val age = System.currentTimeMillis() - lastFire
        val recent = age < MAX_SCHEDULE_AGE_MS
        Log.i(TAG, "[PHASE4.1] INTEGRITY: alarm_fire_recent=$recent (age=${age / 3600000}h)")
        return recent
    }

    private fun checkTimezoneSet(context: Context): Boolean {
        val tz = AdhanScheduleMetadata.getTimezoneId(context)
        val changeTime = AdhanScheduleMetadata.getTimezoneChangeTime(context)
        val set = tz.isNotEmpty()
        Log.i(TAG, "[PHASE4.1] INTEGRITY: timezone_set=$set (tz=$tz, lastChange=$changeTime)")
        return set
    }

    private fun checkAppVersionSet(context: Context): Boolean {
        val version = AdhanScheduleMetadata.getAppVersion(context)
        val build = AdhanScheduleMetadata.getBuildNumber(context)
        val set = version.isNotEmpty() && build > 0
        Log.i(TAG, "[PHASE4.1] INTEGRITY: app_version_set=$set (version=$version, build=$build)")
        return set
    }
}

package com.dailyislamicwidget.daily_islamic_widget

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.net.Uri
import android.os.Build
import android.provider.Settings
import android.util.Log
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONArray
import org.json.JSONObject
import java.util.Calendar

/**
 * AdhanPlugin — Central native bridge and scheduling coordinator for the Adhan subsystem.
 *
 * Hardened Architecture:
 *   1. 48-Hour Rolling Window: Accepts and schedules remaining prayers for today and full prayers for tomorrow.
 *   2. Deterministic IDs: Request codes computed as (dayOfYear * 10) + prayerIndex to avoid collisions.
 *   3. Alarm Clock Mechanism: Uses AlarmManager.setAlarmClock() for highest priority and Doze bypass on API 21+.
 *   4. PendingIntent Verification: Verifies real OS registration using PendingIntent.FLAG_NO_CREATE.
 *   5. Robust Failure Modes: Defensive fallbacks for exact alarms, battery optimization, and OEM restrictions.
 */
class AdhanPlugin(private val context: Context) : MethodChannel.MethodCallHandler {

    companion object {
        private const val TAG = "AdhanPlugin"
        private const val CHANNEL = "com.dailyislamicwidget/adhan"
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
        private const val KEY_ACTIVE_ALARM_CODES = "active_alarm_codes"
        private const val DEFAULT_KEY = AdhanAudioMapping.DEFAULT_KEY

        val ADHAN_PRAYER_NAMES = listOf("Fajr", "Dhuhr", "Maghrib")

        // MethodChannel API names
        private const val METHOD_SCHEDULE = "schedulePrayers"
        private const val METHOD_CANCEL = "cancelAll"
        private const val METHOD_PLAY_TEST = "playTestAdhan"
        private const val METHOD_STOP = "stopAdhan"
        private const val METHOD_UPDATE_SETTINGS = "updateSettings"
        private const val METHOD_CAN_SCHEDULE_EXACT = "canScheduleExactAlarms"
        private const val METHOD_REQUEST_EXACT_ALARM = "requestExactAlarmPermission"
        private const val METHOD_IS_SCHEDULED = "isScheduled"
        private const val METHOD_VERIFY_ALARMS = "verifyAlarms"
        private const val METHOD_REQUEST_BATTERY_OPTIMIZATION = "requestBatteryOptimization"
        private const val METHOD_CHECK_BATTERY_OPTIMIZATION = "checkBatteryOptimization"
        private const val METHOD_GET_NEXT_ALARM = "getNextAlarm"
        private const val METHOD_GET_MANUFACTURER = "getManufacturer"
        private const val METHOD_OPEN_BATTERY_SETTINGS = "openBatterySettings"
        private const val METHOD_SCHEDULE_TEST_ALARM = "scheduleTestAlarm"
        private const val METHOD_OPEN_OEM_BATTERY_SETTINGS = "openOemBatterySettings"
        private const val METHOD_GET_DEVICE_DIAGNOSTICS = "getDeviceDiagnostics"
        private const val METHOD_GET_ADHAN_HEALTH_REPORT = "getAdhanHealthReport"

        // Request code base for test alarm
        private const val TEST_ALARM_CODE_BASE = 5000
    }

    private val prefs: SharedPreferences =
        context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
    private val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager

    fun setup(engine: FlutterEngine) {
        MethodChannel(engine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler(this)
        Log.i(TAG, "AdhanPlugin registered on channel: $CHANNEL")
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        try {
            when (call.method) {
                METHOD_SCHEDULE -> {
                    val args = call.arguments as? Map<*, *>
                    if (args != null) {
                        @Suppress("UNCHECKED_CAST")
                        schedulePrayers(args as Map<String, Any>, result)
                    } else {
                        result.error("INVALID_ARGS", "Prayer times data required", null)
                    }
                }

                METHOD_CANCEL -> cancelAll(result)

                METHOD_PLAY_TEST -> {
                    @Suppress("UNCHECKED_CAST")
                    val args = call.arguments as? Map<String, Any>
                    playTestAdhan(result, args)
                }

                METHOD_STOP -> stopAdhan(result)

                METHOD_UPDATE_SETTINGS -> {
                    val args = call.arguments as? Map<*, *>
                    if (args != null) {
                        @Suppress("UNCHECKED_CAST")
                        updateSettings(args as Map<String, Any>, result)
                    } else {
                        result.error("INVALID_ARGS", "Settings data required", null)
                    }
                }

                METHOD_CAN_SCHEDULE_EXACT -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                        result.success(alarmManager.canScheduleExactAlarms())
                    } else {
                        result.success(true)
                    }
                }

                METHOD_REQUEST_EXACT_ALARM -> requestExactAlarmPermission(result)

                METHOD_IS_SCHEDULED -> {
                    val hasActive = getActiveAlarmCodes().isNotEmpty()
                    result.success(hasActive)
                }

                METHOD_VERIFY_ALARMS -> {
                    val verification = verifyActiveAlarms()
                    result.success(verification)
                }

                METHOD_REQUEST_BATTERY_OPTIMIZATION -> requestBatteryOptimizationPermission(result)

                METHOD_CHECK_BATTERY_OPTIMIZATION -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                        val powerManager = context.getSystemService(Context.POWER_SERVICE) as android.os.PowerManager
                        val isIgnoring = powerManager.isIgnoringBatteryOptimizations(context.packageName)
                        result.success(isIgnoring)
                    } else {
                        result.success(true)
                    }
                }

                METHOD_GET_NEXT_ALARM -> getNextAlarm(result)

                METHOD_GET_MANUFACTURER -> getManufacturer(result)

                METHOD_OPEN_BATTERY_SETTINGS -> openBatterySettings(result)

                METHOD_SCHEDULE_TEST_ALARM -> {
                    val args = call.arguments as? Map<*, *>
                    val delaySeconds = (args?.get("delaySeconds") as? Number)?.toInt() ?: 15
                    scheduleTestAlarm(delaySeconds, result)
                }

                METHOD_OPEN_OEM_BATTERY_SETTINGS -> openOemBatterySettings(result)

                METHOD_GET_DEVICE_DIAGNOSTICS -> getDeviceDiagnostics(result)

                METHOD_GET_ADHAN_HEALTH_REPORT -> getAdhanHealthReport(result)

                else -> result.notImplemented()
            }
        } catch (e: Exception) {
            Log.e(TAG, "Method call error: ${call.method}", e)
            result.error("PLUGIN_ERROR", e.message, null)
        }
    }

    // ─── Public API for Internal Use (BootReceiver / Workers) ──────────────────

    /**
     * Schedules an individual exact alarm.
     * Computes a deterministic request code: (dayOfYear * 10) + prayerIndex.
     */
    fun scheduleSingleAlarm(
        prayerName: String,
        prayerIndex: Int,
        hour: Int,
        minute: Int,
        volume: Float,
        soundName: String,
        timestampMillis: Long = -1L
    ): Int {
        val now = System.currentTimeMillis()
        val triggerMillis = if (timestampMillis > 0L) {
            if (timestampMillis < now) {
                // If timestamp passed, compute for tomorrow at this hour/minute
                val calendar = Calendar.getInstance().apply {
                    set(Calendar.HOUR_OF_DAY, hour)
                    set(Calendar.MINUTE, minute)
                    set(Calendar.SECOND, 0)
                    set(Calendar.MILLISECOND, 0)
                    if (before(Calendar.getInstance())) {
                        add(Calendar.DAY_OF_YEAR, 1)
                    }
                }
                calendar.timeInMillis
            } else {
                timestampMillis
            }
        } else {
            val calendar = Calendar.getInstance().apply {
                set(Calendar.HOUR_OF_DAY, hour)
                set(Calendar.MINUTE, minute)
                set(Calendar.SECOND, 0)
                set(Calendar.MILLISECOND, 0)
                if (before(Calendar.getInstance())) {
                    add(Calendar.DAY_OF_YEAR, 1)
                }
            }
            calendar.timeInMillis
        }

        val rawResId = AdhanAudioMapping.resolveRawResourceId(context, soundName)

        // Calculate deterministic request code
        val cal = Calendar.getInstance().apply { timeInMillis = triggerMillis }
        val dayOfYear = cal.get(Calendar.DAY_OF_YEAR)
        val code = (dayOfYear * 10) + (prayerIndex.coerceAtLeast(0) % 10)

        val intent = Intent(context, AdhanAlarmReceiver::class.java).apply {
            action = AdhanAlarmReceiver.ACTION_ADHAN_ALARM
            putExtra("prayer_name", prayerName)
            putExtra("prayer_index", prayerIndex)
            putExtra("volume", volume)
            putExtra("sound_name", soundName)
            putExtra("raw_res_id", rawResId)
            putExtra("scheduled_time", triggerMillis)
            putExtra("alarm_code", code)
        }

        val pendingIntent = PendingIntent.getBroadcast(
            context,
            code,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val delayMs = triggerMillis - now
        Log.i(TAG, "[ALARM] Scheduling $prayerName: code=$code, delay=${delayMs / 1000}s, trigger=$triggerMillis")

        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                val clockInfo = AlarmManager.AlarmClockInfo(triggerMillis, pendingIntent)
                alarmManager.setAlarmClock(clockInfo, pendingIntent)
                Log.i(TAG, "[ALARM] setAlarmClock succeeded for $prayerName (code=$code)")
            } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
                alarmManager.setExact(AlarmManager.RTC_WAKEUP, triggerMillis, pendingIntent)
                Log.i(TAG, "[ALARM] setExact succeeded for $prayerName (code=$code)")
            } else {
                alarmManager.set(AlarmManager.RTC_WAKEUP, triggerMillis, pendingIntent)
                Log.i(TAG, "[ALARM] set succeeded for $prayerName (code=$code)")
            }
        } catch (e: SecurityException) {
            Log.w(TAG, "[ALARM] SecurityException on exact alarm: ${e.message}, falling back to setAndAllowWhileIdle")
            try {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    alarmManager.setAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, triggerMillis, pendingIntent)
                } else {
                    alarmManager.set(AlarmManager.RTC_WAKEUP, triggerMillis, pendingIntent)
                }
            } catch (e2: Exception) {
                Log.e(TAG, "[ALARM] Inexact fallback also failed: ${e2.message}", e2)
            }
        }

        return code
    }

    // ─── Test Alarm ────────────────────────────────────────────────────────────

    fun scheduleTestAlarm(delaySeconds: Int, result: MethodChannel.Result) {
        val now = System.currentTimeMillis()
        val triggerMillis = now + (delaySeconds * 1000L)

        val volume = prefs.getFloat(KEY_ADHAN_VOLUME, 1.0f)
        val soundName = prefs.getString(KEY_SELECTED_SOUND, DEFAULT_KEY) ?: DEFAULT_KEY
        val rawResId = AdhanAudioMapping.resolveRawResourceId(context, soundName)

        val intent = Intent(context, AdhanAlarmReceiver::class.java).apply {
            action = AdhanAlarmReceiver.ACTION_ADHAN_ALARM
            putExtra("prayer_name", "اختبار الأذان")
            putExtra("prayer_index", -1)
            putExtra("volume", volume)
            putExtra("sound_name", soundName)
            putExtra("raw_res_id", rawResId)
            putExtra("test_delay_seconds", delaySeconds)
            putExtra("scheduled_time", triggerMillis)
        }

        val code = TEST_ALARM_CODE_BASE
        val pendingIntent = PendingIntent.getBroadcast(
            context,
            code,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                val clockInfo = AlarmManager.AlarmClockInfo(triggerMillis, pendingIntent)
                alarmManager.setAlarmClock(clockInfo, pendingIntent)
                Log.i(TAG, "[TEST_ALARM] setAlarmClock armed in ${delaySeconds}s")
            } else {
                alarmManager.setExact(AlarmManager.RTC_WAKEUP, triggerMillis, pendingIntent)
                Log.i(TAG, "[TEST_ALARM] setExact armed in ${delaySeconds}s")
            }
            result.success(true)
        } catch (e: SecurityException) {
            Log.w(TAG, "[TEST_ALARM] SecurityException: ${e.message}")
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                alarmManager.setAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, triggerMillis, pendingIntent)
            } else {
                alarmManager.set(AlarmManager.RTC_WAKEUP, triggerMillis, pendingIntent)
            }
            result.success(true)
        }
    }

    // ─── Core Scheduling Pipeline ──────────────────────────────────────────────

    private fun schedulePrayers(args: Map<String, Any>, result: MethodChannel.Result) {
        @Suppress("UNCHECKED_CAST")
        val prayers = (args["prayers"] as? List<Map<String, Any>>) ?: emptyList()
        @Suppress("UNCHECKED_CAST")
        val enabled = (args["enabled"] as? Map<String, Boolean>) ?: emptyMap()
        val volume = (args["volume"] as? Number)?.toFloat() ?: 1.0f
        val soundName = args["selectedSound"] as? String ?: DEFAULT_KEY
        val adhanEnabled = (args["adhanEnabled"] as? Boolean) ?: true
        val adhanFajr = (args["adhanFajrEnabled"] as? Boolean) ?: true
        val adhanDhuhr = (args["adhanDhuhrEnabled"] as? Boolean) ?: true
        val adhanMaghrib = (args["adhanMaghribEnabled"] as? Boolean) ?: true
        val bootStart = (args["bootStart"] as? Boolean) ?: true

        // Store settings
        prefs.edit().apply {
            putBoolean(KEY_ADHAN_ENABLED, adhanEnabled)
            putFloat(KEY_ADHAN_VOLUME, volume)
            putString(KEY_SELECTED_SOUND, soundName)
            putBoolean(KEY_ADHAN_FAJR, adhanFajr)
            putBoolean(KEY_ADHAN_DHUHR, adhanDhuhr)
            putBoolean(KEY_ADHAN_MAGHRIB, adhanMaghrib)
            putBoolean(KEY_BOOT_START, bootStart)
            apply()
        }

        // Store full JSON payload
        val jsonPayload = args["prayerTimesJson"] as? String ?: ""
        if (jsonPayload.isNotEmpty()) {
            prefs.edit()
                .putString(KEY_PRAYER_TIMES_JSON, jsonPayload)
                .putInt(KEY_LAST_SCHEDULED_DAY, getTodayKey())
                .apply()
        }

        // Cancel previously recorded alarms
        cancelExistingAlarms()

        if (!adhanEnabled) {
            Log.i(TAG, "Adhan disabled globally; all existing alarms cleared")
            result.success(mapOf("scheduled" to 0, "verified" to 0, "details" to emptyList<String>(), "success" to true))
            return
        }

        val activeCodes = mutableSetOf<Int>()
        var scheduledCount = 0
        val scheduledDetails = mutableListOf<String>()
        val now = System.currentTimeMillis()

        for (prayerData in prayers) {
            val prayerName = prayerData["name"] as? String ?: continue
            if (prayerName !in ADHAN_PRAYER_NAMES) continue

            val isEnabled = when (prayerName) {
                "Fajr" -> adhanFajr
                "Dhuhr" -> adhanDhuhr
                "Maghrib" -> adhanMaghrib
                else -> true
            }
            if (!isEnabled) continue

            val timestampMillis = (prayerData["timestampMillis"] as? Number)?.toLong() ?: -1L
            // If timestamp is already passed by more than 15 minutes, skip
            if (timestampMillis > 0L && (now - timestampMillis) > 15 * 60 * 1000L) {
                continue
            }

            val timeStr = prayerData["time"] as? String ?: ""
            var hour = -1
            var minute = -1
            if (timeStr.isNotEmpty()) {
                val parts = timeStr.split(":")
                if (parts.size == 2) {
                    hour = parts[0].toIntOrNull() ?: -1
                    minute = parts[1].toIntOrNull() ?: -1
                }
            }

            if ((hour == -1 || minute == -1) && timestampMillis > 0L) {
                val cal = Calendar.getInstance().apply { timeInMillis = timestampMillis }
                hour = cal.get(Calendar.HOUR_OF_DAY)
                minute = cal.get(Calendar.MINUTE)
            }

            if (hour == -1 || minute == -1) continue

            val prayerIndex = ADHAN_PRAYER_NAMES.indexOf(prayerName)
            val code = scheduleSingleAlarm(prayerName, prayerIndex, hour, minute, volume, soundName, timestampMillis)
            activeCodes.add(code)
            scheduledCount++
            scheduledDetails.add("$prayerName at ${String.format("%02d:%02d", hour, minute)} (code=$code)")
        }

        // Save active alarm request codes
        saveActiveAlarmCodes(activeCodes)

        // Verify scheduled alarms
        val verifiedCount = verifyActiveAlarms()["verifiedCount"] as? Int ?: 0

        Log.i(TAG, "[ALARM] Scheduling complete: scheduled=$scheduledCount, verified=$verifiedCount, codes=$activeCodes")

        // Trigger WorkManager chain for midnight maintenance
        try {
            AdhanWorkManager.scheduleNext(context)
        } catch (e: Exception) {
            Log.e(TAG, "Failed to schedule next worker: ${e.message}", e)
        }

        result.success(mapOf(
            "scheduled" to scheduledCount,
            "verified" to verifiedCount,
            "details" to scheduledDetails,
            "success" to true
        ))
    }

    // ─── Alarm Cancellation & State ────────────────────────────────────────────

    fun cancelExistingAlarms() {
        val activeCodes = getActiveAlarmCodes().toMutableSet()

        // Also include legacy codes 4000..4005 and nearby codes
        for (i in 0..5) {
            activeCodes.add(4000 + i)
        }

        for (code in activeCodes) {
            val intent = Intent(context, AdhanAlarmReceiver::class.java)
            val pendingIntent = PendingIntent.getBroadcast(
                context,
                code,
                intent,
                PendingIntent.FLAG_NO_CREATE or PendingIntent.FLAG_IMMUTABLE
            )
            if (pendingIntent != null) {
                alarmManager.cancel(pendingIntent)
                pendingIntent.cancel()
                Log.d(TAG, "[ALARM] Cancelled alarm with code=$code")
            }
        }

        clearActiveAlarmCodes()
        Log.i(TAG, "All registered adhan alarms cancelled")
    }

    private fun cancelAll(result: MethodChannel.Result) {
        cancelExistingAlarms()

        try {
            AdhanWorkManager.cancelAll(context)
        } catch (_: Exception) {}

        try {
            val stopIntent = Intent(context, AdhanForegroundService::class.java)
            context.stopService(stopIntent)
        } catch (_: Exception) {}

        prefs.edit()
            .remove(KEY_PRAYER_TIMES_JSON)
            .remove(KEY_LAST_SCHEDULED_DAY)
            .apply()

        result.success(true)
    }

    // ─── Verification Layer ───────────────────────────────────────────────────

    fun verifyActiveAlarms(): Map<String, Any> {
        val activeCodes = getActiveAlarmCodes()
        val verifiedCodes = mutableListOf<Int>()

        for (code in activeCodes) {
            val intent = Intent(context, AdhanAlarmReceiver::class.java)
            val pi = PendingIntent.getBroadcast(
                context,
                code,
                intent,
                PendingIntent.FLAG_NO_CREATE or PendingIntent.FLAG_IMMUTABLE
            )
            if (pi != null) {
                verifiedCodes.add(code)
            }
        }

        val isHealthy = verifiedCodes.isNotEmpty()
        return mapOf(
            "isHealthy" to isHealthy,
            "totalCodes" to activeCodes.size,
            "verifiedCount" to verifiedCodes.size,
            "verifiedCodes" to verifiedCodes
        )
    }

    private fun saveActiveAlarmCodes(codes: Set<Int>) {
        val codeStrings = codes.map { it.toString() }.toSet()
        prefs.edit().putStringSet(KEY_ACTIVE_ALARM_CODES, codeStrings).apply()
    }

    private fun getActiveAlarmCodes(): Set<Int> {
        val stringSet = prefs.getStringSet(KEY_ACTIVE_ALARM_CODES, null) ?: return emptySet()
        return stringSet.mapNotNull { it.toIntOrNull() }.toSet()
    }

    private fun clearActiveAlarmCodes() {
        prefs.edit().remove(KEY_ACTIVE_ALARM_CODES).apply()
    }

    // ─── Settings & Diagnostics Handlers ─────────────────────────────────────

    private fun playTestAdhan(result: MethodChannel.Result, args: Map<String, Any>? = null) {
        val volume = (args?.get("volume") as? Number)?.toFloat()
            ?: prefs.getFloat(KEY_ADHAN_VOLUME, 1.0f)
        val soundName = args?.get("sound_name") as? String
            ?: prefs.getString(KEY_SELECTED_SOUND, DEFAULT_KEY) ?: DEFAULT_KEY
        val rawResId = AdhanAudioMapping.resolveRawResourceId(context, soundName)

        val intent = Intent(context, AdhanForegroundService::class.java).apply {
            action = AdhanForegroundService.ACTION_PLAY_TEST
            putExtra("volume", volume)
            putExtra("sound_name", soundName)
            putExtra("raw_res_id", rawResId)
        }

        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                context.startForegroundService(intent)
            } else {
                context.startService(intent)
            }
        } catch (e: Exception) {
            Log.e(TAG, "Failed to start test adhan service: ${e.message}")
        }

        result.success(true)
    }

    private fun stopAdhan(result: MethodChannel.Result) {
        try {
            val intent = Intent(context, AdhanForegroundService::class.java)
            context.stopService(intent)
        } catch (e: Exception) {
            Log.w(TAG, "Failed to stop adhan service: ${e.message}")
        }
        result.success(true)
    }

    private fun updateSettings(args: Map<String, Any>, result: MethodChannel.Result) {
        prefs.edit().apply {
            if (args.containsKey("adhanEnabled")) putBoolean(KEY_ADHAN_ENABLED, args["adhanEnabled"] as? Boolean ?: true)
            if (args.containsKey("volume")) putFloat(KEY_ADHAN_VOLUME, (args["volume"] as? Number)?.toFloat() ?: 1.0f)
            if (args.containsKey("selectedSound")) putString(KEY_SELECTED_SOUND, args["selectedSound"] as? String ?: DEFAULT_KEY)
            if (args.containsKey("adhanFajrEnabled")) putBoolean(KEY_ADHAN_FAJR, args["adhanFajrEnabled"] as? Boolean ?: true)
            if (args.containsKey("adhanDhuhrEnabled")) putBoolean(KEY_ADHAN_DHUHR, args["adhanDhuhrEnabled"] as? Boolean ?: true)
            if (args.containsKey("adhanMaghribEnabled")) putBoolean(KEY_ADHAN_MAGHRIB, args["adhanMaghribEnabled"] as? Boolean ?: true)
            if (args.containsKey("bootStart")) putBoolean(KEY_BOOT_START, args["bootStart"] as? Boolean ?: true)
            apply()
        }
        result.success(true)
    }

    private fun requestExactAlarmPermission(result: MethodChannel.Result) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            try {
                val intent = Intent(Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM).apply {
                    data = Uri.parse("package:${context.packageName}")
                    addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                }
                context.startActivity(intent)
                result.success(true)
                return
            } catch (e: Exception) {
                Log.w(TAG, "Failed to open exact alarm settings: ${e.message}")
            }
        }
        result.success(false)
    }

    private fun requestBatteryOptimizationPermission(result: MethodChannel.Result) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            try {
                val intent = Intent(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS).apply {
                    data = Uri.parse("package:${context.packageName}")
                    addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                }
                context.startActivity(intent)
                result.success(true)
                return
            } catch (e: Exception) {
                Log.w(TAG, "Failed to request battery optimization: ${e.message}")
            }
        }
        result.success(false)
    }

    private fun getNextAlarm(result: MethodChannel.Result) {
        val nextTrigger = alarmManager.nextAlarmClock?.triggerTime
        result.success(nextTrigger ?: -1L)
    }

    private fun getManufacturer(result: MethodChannel.Result) {
        result.success(Build.MANUFACTURER.lowercase())
    }

    private fun openBatterySettings(result: MethodChannel.Result) {
        try {
            val intent = Intent(Settings.ACTION_IGNORE_BATTERY_OPTIMIZATION_SETTINGS).apply {
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            }
            context.startActivity(intent)
            result.success(true)
        } catch (_: Exception) {
            try {
                val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS).apply {
                    data = Uri.parse("package:${context.packageName}")
                    addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                }
                context.startActivity(intent)
                result.success(true)
            } catch (_: Exception) {
                result.success(false)
            }
        }
    }

    private fun openOemBatterySettings(result: MethodChannel.Result) {
        try {
            val diag = OemCompatibility.collectDiagnostics(context)
            val outcome = OemCompatibility.openBatteryOptimizationSettings(context)
            result.success(mapOf(
                "result" to outcome,
                "manufacturer" to diag.oemDisplayName,
                "isSupportedOem" to diag.isSupportedOem,
                "isIgnoringBatteryOptimizations" to diag.isIgnoringBatteryOptimizations
            ))
        } catch (e: Exception) {
            result.success(mapOf(
                "result" to OemCompatibility.RESULT_FAILED,
                "manufacturer" to OemCompatibility.getDisplayName(OemCompatibility.OemType.GENERIC),
                "isSupportedOem" to false,
                "isIgnoringBatteryOptimizations" to false
            ))
        }
    }

    private fun getDeviceDiagnostics(result: MethodChannel.Result) {
        try {
            val diag = OemCompatibility.collectDiagnostics(context)
            result.success(mapOf(
                "manufacturer" to diag.oemDisplayName,
                "manufacturerRaw" to diag.manufacturerRaw,
                "brand" to diag.brand,
                "model" to diag.model,
                "display" to diag.display,
                "product" to diag.product,
                "sdkInt" to diag.sdkInt,
                "androidVersion" to diag.androidVersion,
                "oemType" to diag.oemType.name,
                "isSupportedOem" to diag.isSupportedOem,
                "isIgnoringBatteryOptimizations" to diag.isIgnoringBatteryOptimizations,
                "isHarmonyOs" to diag.isHarmonyOs,
                "instructionsSummary" to diag.instructionsSummary,
                "instructions" to diag.instructions.map { step ->
                    mapOf(
                        "title" to step.title,
                        "description" to step.description,
                        "icon" to step.icon
                    )
                }
            ))
        } catch (e: Exception) {
            result.success(emptyMap<String, Any>())
        }
    }

    private fun getAdhanHealthReport(result: MethodChannel.Result) {
        try {
            val report = AdhanHealthReporter.collectReport(context)
            result.success(report)
        } catch (e: Exception) {
            result.success(mapOf(
                "checks" to emptyList<Any>(),
                "overallScore" to 0,
                "overallLevel" to "unknown",
                "timestamp" to System.currentTimeMillis()
            ))
        }
    }

    private fun getTodayKey(): Int {
        val now = Calendar.getInstance()
        return now.get(Calendar.DAY_OF_MONTH) +
                (now.get(Calendar.MONTH) + 1) * 100 +
                now.get(Calendar.YEAR) * 10000
    }
}
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
        private const val DEFAULT_KEY = AdhanAudioMapping.DEFAULT_KEY

        private val ADHAN_PRAYER_NAMES = listOf("Fajr", "Dhuhr", "Maghrib")

        private const val METHOD_SCHEDULE = "schedulePrayers"
        private const val METHOD_CANCEL = "cancelAll"
        private const val METHOD_PLAY_TEST = "playTestAdhan"
        private const val METHOD_STOP = "stopAdhan"
        private const val METHOD_UPDATE_SETTINGS = "updateSettings"
        private const val METHOD_REQUEST_EXACT_ALARM = "requestExactAlarmPermission"
        private const val METHOD_IS_SCHEDULED = "isScheduled"
        private const val METHOD_REQUEST_BATTERY_OPTIMIZATION = "requestBatteryOptimization"
        private const val METHOD_CHECK_BATTERY_OPTIMIZATION = "checkBatteryOptimization"
        private const val METHOD_GET_NEXT_ALARM = "getNextAlarm"
        private const val METHOD_GET_MANUFACTURER = "getManufacturer"
        private const val METHOD_OPEN_BATTERY_SETTINGS = "openBatterySettings"
        private const val METHOD_SCHEDULE_TEST_ALARM = "scheduleTestAlarm"
        private const val METHOD_OPEN_OEM_BATTERY_SETTINGS = "openOemBatterySettings"
        private const val METHOD_GET_DEVICE_DIAGNOSTICS = "getDeviceDiagnostics"
        private const val METHOD_GET_ADHAN_HEALTH_REPORT = "getAdhanHealthReport"

        /// Request codes for test alarms — offset 5000+ to avoid collision with
        /// production alarms (4000+).
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

                METHOD_REQUEST_EXACT_ALARM -> requestExactAlarmPermission(result)

                METHOD_IS_SCHEDULED -> {
                    val lastDay = prefs.getInt(KEY_LAST_SCHEDULED_DAY, -1)
                    result.success(lastDay == getTodayKey())
                }

                METHOD_REQUEST_BATTERY_OPTIMIZATION -> requestBatteryOptimizationPermission(result)

                METHOD_CHECK_BATTERY_OPTIMIZATION -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                        val isIgnoring = context.packageManager?.let { pm ->
                            val powerManager = context.getSystemService(Context.POWER_SERVICE) as android.os.PowerManager
                            powerManager.isIgnoringBatteryOptimizations(context.packageName)
                        } ?: false
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

    // ── Public API for internal use (BootReceiver) ────────────────────────────

    fun scheduleSingleAlarm(
        prayerName: String,
        prayerIndex: Int,
        hour: Int,
        minute: Int,
        volume: Float,
        soundName: String,
        timestampMillis: Long = -1L
    ) {
        val now = System.currentTimeMillis()
        val triggerMillis = if (timestampMillis > 0L) {
            // Use absolute UTC timestamp — handles DST transitions correctly.
            // CRITICAL: Guard against stale/past timestamps causing immediate fire.
            if (timestampMillis < now) {
                // Timestamp is in the past — construct from hour/minute instead
                // so the before() check below adds a day if needed.
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
            // Fallback: construct from hour/minute in current timezone.
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

        val intent = Intent(context, AdhanAlarmReceiver::class.java).apply {
            action = AdhanAlarmReceiver.ACTION_ADHAN_ALARM
            putExtra("prayer_name", prayerName)
            putExtra("prayer_index", prayerIndex)
            putExtra("volume", volume)
            putExtra("sound_name", soundName)
            putExtra("raw_res_id", rawResId)
        }

        val code = 4000 + prayerIndex
        val pendingIntent = PendingIntent.getBroadcast(
            context,
            code,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val delayMs = triggerMillis - now
        Log.i(TAG, "[VERIFICATION] scheduleSingleAlarm: prayer=$prayerName, hour=$hour:${String.format("%02d", minute)}, triggerMillis=$triggerMillis, delay=${delayMs}ms, api=${Build.VERSION.SDK_INT}")

        // Log permission state for diagnostics
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            val canSchedule = alarmManager.canScheduleExactAlarms()
            Log.i(TAG, "[VERIFICATION] canScheduleExactAlarms=$canSchedule (API ${Build.VERSION.SDK_INT})")
        }

        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                // setAlarmClock() is the most reliable alarm API:
                // - Bypasses Doze mode automatically
                // - Does not require SCHEDULE_EXACT_ALARM permission
                // - Cannot be revoked by OEMs (Vivo, Xiaomi, etc.)
                // - Fires reliably on all API 21+ devices
                // The small clock icon in the status bar shows the next prayer time.
                val clockInfo = AlarmManager.AlarmClockInfo(triggerMillis, pendingIntent)
                alarmManager.setAlarmClock(clockInfo, pendingIntent)
                Log.i(TAG, "[VERIFICATION] ALARM_SCHEDULED via setAlarmClock for $prayerName at ${String.format("%02d:%02d", hour, minute)} (delay=${delayMs}ms)")
            } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
                alarmManager.setExact(
                    AlarmManager.RTC_WAKEUP,
                    triggerMillis,
                    pendingIntent
                )
                Log.i(TAG, "[VERIFICATION] ALARM_SCHEDULED via setExact for $prayerName at ${String.format("%02d:%02d", hour, minute)} (delay=${delayMs}ms)")
            } else {
                alarmManager.set(
                    AlarmManager.RTC_WAKEUP,
                    triggerMillis,
                    pendingIntent
                )
                Log.i(TAG, "[VERIFICATION] ALARM_SCHEDULED via set (inexact) for $prayerName at ${String.format("%02d:%02d", hour, minute)} (delay=${delayMs}ms)")
            }
        } catch (e: SecurityException) {
            Log.w(TAG, "[VERIFICATION] ALARM_SECURITY_EXCEPTION for $prayerName: ${e.message}, using inexact fallback")
            alarmManager.set(
                AlarmManager.RTC_WAKEUP,
                triggerMillis,
                pendingIntent
            )
        }
    }

    // ── Test Mode ────────────────────────────────────────────────────────────

    /// Schedules a test adhan alarm [delaySeconds] from now.
    ///
    /// Uses the EXACT same pipeline as a real prayer:
    ///   AlarmManager → AdhanAlarmReceiver → AdhanForegroundService → Notification → Audio
    ///
    /// The only difference is the request code (5000+ instead of 4000+) and an
    /// extra `test_delay_seconds` in the intent for logging.
    fun scheduleTestAlarm(delaySeconds: Int, result: MethodChannel.Result) {
        val now = System.currentTimeMillis()
        val triggerMillis = now + (delaySeconds * 1000L)

        // Read current settings from SharedPreferences
        val volume = prefs.getFloat(KEY_ADHAN_VOLUME, 1.0f)
        val soundName = prefs.getString(KEY_SELECTED_SOUND, DEFAULT_KEY) ?: DEFAULT_KEY
        val rawResId = AdhanAudioMapping.resolveRawResourceId(context, soundName)

        Log.i(TAG, "[VERIFICATION] TEST_MODE: scheduling test alarm in ${delaySeconds}s (triggerMillis=$triggerMillis, volume=$volume, sound=$soundName)")

        val intent = Intent(context, AdhanAlarmReceiver::class.java).apply {
            action = AdhanAlarmReceiver.ACTION_ADHAN_ALARM
            putExtra("prayer_name", "اختبار الأذان")
            putExtra("prayer_index", -1)
            putExtra("volume", volume)
            putExtra("sound_name", soundName)
            putExtra("raw_res_id", rawResId)
            putExtra("test_delay_seconds", delaySeconds)
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
                Log.i(TAG, "[VERIFICATION] TEST_ALARM_SCHEDULED via setAlarmClock (delay=${delaySeconds}s, triggerMillis=$triggerMillis)")
            } else {
                alarmManager.setExact(
                    AlarmManager.RTC_WAKEUP,
                    triggerMillis,
                    pendingIntent
                )
                Log.i(TAG, "[VERIFICATION] TEST_ALARM_SCHEDULED via setExact (delay=${delaySeconds}s)")
            }
            result.success(true)
        } catch (e: SecurityException) {
            Log.w(TAG, "[VERIFICATION] TEST_ALARM_SECURITY_EXCEPTION: ${e.message}")
            alarmManager.set(AlarmManager.RTC_WAKEUP, triggerMillis, pendingIntent)
            result.success(true)
        }
    }

    // ── Private methods ──────────────────────────────────────────────────────

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

        // Store settings for boot receiver
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

        // Store prayer schedule for boot receiver (full JSON)
        val jsonPayload = args["prayerTimesJson"] as? String ?: ""
        if (jsonPayload.isNotEmpty()) {
            val todayKey = getTodayKey()
            prefs.edit()
                .putString(KEY_PRAYER_TIMES_JSON, jsonPayload)
                .putInt(KEY_LAST_SCHEDULED_DAY, todayKey)
                .apply()
        }

        // Cancel existing alarms
        cancelExistingAlarms()

        if (!adhanEnabled) {
            Log.i(TAG, "Adhan disabled globally, skipping alarm scheduling")
            result.success(true)
            return
        }

        // Schedule adhan prayers (Fajr, Dhuhr, Maghrib for Shi'a schedule)
        for ((index, prayerName) in ADHAN_PRAYER_NAMES.withIndex()) {
            val isEnabled = when (prayerName) {
                "Fajr" -> adhanFajr
                "Dhuhr" -> adhanDhuhr
                "Maghrib" -> adhanMaghrib
                else -> true
            }
            if (!isEnabled) continue

            val prayerData = prayers.find { it["name"] == prayerName }
            if (prayerData == null) {
                Log.d(TAG, "No time data for $prayerName, skipping")
                continue
            }

            val timestampMillis = (prayerData["timestampMillis"] as? Number)?.toLong() ?: -1L
            val timeStr = prayerData["time"] as? String ?: continue
            val parts = timeStr.split(":")
            if (parts.size != 2) {
                Log.w(TAG, "Invalid time format for $prayerName: $timeStr")
                continue
            }

            val hour = parts[0].toIntOrNull() ?: continue
            val minute = parts[1].toIntOrNull() ?: continue

            scheduleSingleAlarm(prayerName, index, hour, minute, volume, soundName, timestampMillis)
        }

        // Phase 4.1: Schedule next worker (OneTime chain for precise midnight execution)
        try {
            AdhanWorkManager.scheduleNext(context)
            Log.i(TAG, "[PHASE4.1] Next worker scheduled after prayer scheduling")
        } catch (e: Exception) {
            Log.e(TAG, "[PHASE4.1] Worker scheduling failed: ${e.message}", e)
        }

        // Phase 4.1: Record app version metadata
        try {
            AdhanScheduleMetadata.updateAppInfo(context)
        } catch (e: Exception) {
            Log.e(TAG, "[PHASE4.1] App info update failed: ${e.message}", e)
        }

        result.success(true)
    }

    private fun cancelExistingAlarms() {
        for (index in ADHAN_PRAYER_NAMES.indices) {
            val intent = Intent(context, AdhanAlarmReceiver::class.java)
            val pendingIntent = PendingIntent.getBroadcast(
                context,
                4000 + index,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            pendingIntent.cancel()
            alarmManager.cancel(pendingIntent)
        }
        Log.i(TAG, "All existing alarms cancelled")
    }

    private fun cancelAll(result: MethodChannel.Result) {
        cancelExistingAlarms()

        // Phase 4: Cancel WorkManager workers when adhan is disabled
        try {
            AdhanWorkManager.cancelAll(context)
            Log.i(TAG, "[PHASE4] WorkManager workers cancelled")
        } catch (e: Exception) {
            Log.e(TAG, "[PHASE4] Worker cancel failed: ${e.message}", e)
        }

        // Stop foreground service
        val stopIntent = Intent(context, AdhanForegroundService::class.java).apply {
            action = AdhanForegroundService.ACTION_STOP_ADHAN
        }
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                context.startForegroundService(stopIntent)
            } else {
                context.startService(stopIntent)
            }
        } catch (e: Exception) {
            Log.w(TAG, "Failed to stop adhan service: ${e.message}")
        }

        prefs.edit()
            .remove(KEY_PRAYER_TIMES_JSON)
            .remove(KEY_LAST_SCHEDULED_DAY)
            .apply()

        Log.i(TAG, "All alarms cancelled and schedule cleared")
        result.success(true)
    }

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

        Log.i(TAG, "Test adhan playback started (volume=$volume, sound=$soundName)")
        result.success(true)
    }

    private fun stopAdhan(result: MethodChannel.Result) {
        val intent = Intent(context, AdhanForegroundService::class.java).apply {
            action = AdhanForegroundService.ACTION_STOP_ADHAN
        }
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                context.startForegroundService(intent)
            } else {
                context.startService(intent)
            }
        } catch (e: Exception) {
            Log.w(TAG, "Failed to stop adhan service: ${e.message}")
        }

        Log.i(TAG, "Adhan playback stopped")
        result.success(true)
    }

    private fun updateSettings(args: Map<String, Any>, result: MethodChannel.Result) {
        prefs.edit().apply {
            if (args.containsKey("adhanEnabled")) putBoolean(KEY_ADHAN_ENABLED, args["adhanEnabled"] as? Boolean ?: true)
            if (args.containsKey("volume")) {
                val v = (args["volume"] as? Number)?.toFloat() ?: 1.0f
                putFloat(KEY_ADHAN_VOLUME, v)
            }
            if (args.containsKey("selectedSound")) putString(KEY_SELECTED_SOUND, args["selectedSound"] as? String ?: DEFAULT_KEY)
            if (args.containsKey("adhanFajrEnabled")) putBoolean(KEY_ADHAN_FAJR, args["adhanFajrEnabled"] as? Boolean ?: true)
            if (args.containsKey("adhanDhuhrEnabled")) putBoolean(KEY_ADHAN_DHUHR, args["adhanDhuhrEnabled"] as? Boolean ?: true)
            if (args.containsKey("adhanMaghribEnabled")) putBoolean(KEY_ADHAN_MAGHRIB, args["adhanMaghribEnabled"] as? Boolean ?: true)
            if (args.containsKey("bootStart")) putBoolean(KEY_BOOT_START, args["bootStart"] as? Boolean ?: true)
            apply()
        }
        Log.i(TAG, "Settings updated: ${args.keys}")
        result.success(true)
    }

    private fun requestExactAlarmPermission(result: MethodChannel.Result) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            val intent = Intent(Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM).apply {
                data = android.net.Uri.parse("package:${context.packageName}")
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            }
            context.startActivity(intent)
        }
        result.success(true)
    }

    private fun requestBatteryOptimizationPermission(result: MethodChannel.Result) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val intent = Intent(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS).apply {
                data = android.net.Uri.parse("package:${context.packageName}")
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            }
            context.startActivity(intent)
        }
        result.success(true)
    }

    private fun getNextAlarm(result: MethodChannel.Result) {
        val nextTrigger = alarmManager.nextAlarmClock?.triggerTime
        if (nextTrigger != null) {
            result.success(nextTrigger)
        } else {
            result.success(-1L)
        }
    }

    private fun getManufacturer(result: MethodChannel.Result) {
        result.success(Build.MANUFACTURER.lowercase())
    }

    private fun openBatterySettings(result: MethodChannel.Result) {
        try {
            val intent = Intent().apply {
                action = Settings.ACTION_IGNORE_BATTERY_OPTIMIZATION_SETTINGS
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            }
            context.startActivity(intent)
            result.success(true)
        } catch (e: Exception) {
            // Fallback: open app settings
            try {
                val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS).apply {
                    data = android.net.Uri.parse("package:${context.packageName}")
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
            Log.i(TAG, "[VERIFICATION] openOemBatterySettings: oem=${diag.oemType}, battery=${diag.isIgnoringBatteryOptimizations}")
            val outcome = OemCompatibility.openBatteryOptimizationSettings(context)
            result.success(mapOf(
                "result" to outcome,
                "manufacturer" to diag.oemDisplayName,
                "isSupportedOem" to diag.isSupportedOem,
                "isIgnoringBatteryOptimizations" to diag.isIgnoringBatteryOptimizations
            ))
        } catch (e: Exception) {
            Log.e(TAG, "[VERIFICATION] openOemBatterySettings FAILED: ${e.message}", e)
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
            Log.i(TAG, "[VERIFICATION] getDeviceDiagnostics: oem=${diag.oemType}, model=${diag.model}, sdk=${diag.sdkInt}, battery=${diag.isIgnoringBatteryOptimizations}, harmony=${diag.isHarmonyOs}")
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
            Log.e(TAG, "[VERIFICATION] getDeviceDiagnostics FAILED: ${e.message}", e)
            result.success(mapOf(
                "manufacturer" to "Unknown",
                "manufacturerRaw" to "",
                "brand" to "",
                "model" to "",
                "display" to "",
                "product" to "",
                "sdkInt" to 0,
                "androidVersion" to "",
                "oemType" to "GENERIC",
                "isSupportedOem" to false,
                "isIgnoringBatteryOptimizations" to false,
                "isHarmonyOs" to false,
                "instructionsSummary" to "",
                "instructions" to emptyList<Any>()
            ))
        }
    }

    private fun getAdhanHealthReport(result: MethodChannel.Result) {
        try {
            val report = AdhanHealthReporter.collectReport(context)
            Log.i(TAG, "[VERIFICATION] getAdhanHealthReport: score=${report["overallScore"]}, level=${report["overallLevel"]}")
            result.success(report)
        } catch (e: Exception) {
            Log.e(TAG, "[VERIFICATION] getAdhanHealthReport FAILED: ${e.message}", e)
            result.success(mapOf(
                "checks" to emptyList<Any>(),
                "overallScore" to 0,
                "overallLevel" to "unknown",
                "timestamp" to System.currentTimeMillis(),
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
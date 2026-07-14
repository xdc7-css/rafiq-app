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
        private const val KEY_SNOOZE_MINUTES = "snooze_minutes"
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
        val triggerMillis = if (timestampMillis > 0L) {
            // Use absolute UTC timestamp — handles DST transitions correctly.
            timestampMillis
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

        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S && !alarmManager.canScheduleExactAlarms()) {
                Log.w(TAG, "Exact alarm permission not granted, using inexact alarm for $prayerName")
                alarmManager.set(
                    AlarmManager.RTC_WAKEUP,
                    triggerMillis,
                    pendingIntent
                )
            } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                alarmManager.setExactAndAllowWhileIdle(
                    AlarmManager.RTC_WAKEUP,
                    triggerMillis,
                    pendingIntent
                )
            } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
                alarmManager.setExact(
                    AlarmManager.RTC_WAKEUP,
                    triggerMillis,
                    pendingIntent
                )
            } else {
                alarmManager.set(
                    AlarmManager.RTC_WAKEUP,
                    triggerMillis,
                    pendingIntent
                )
            }
            Log.i(TAG, "Alarm set for $prayerName at ${String.format("%02d:%02d", hour, minute)} (millis=$triggerMillis)")
        } catch (e: SecurityException) {
            Log.w(TAG, "Cannot set exact alarm (missing permission), using inexact")
            alarmManager.set(
                AlarmManager.RTC_WAKEUP,
                triggerMillis,
                pendingIntent
            )
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
        val snoozeMinutes = (args["snoozeMinutes"] as? Number)?.toInt() ?: 5
        val bootStart = (args["bootStart"] as? Boolean) ?: true

        // Store settings for boot receiver
        prefs.edit().apply {
            putBoolean(KEY_ADHAN_ENABLED, adhanEnabled)
            putFloat(KEY_ADHAN_VOLUME, volume)
            putString(KEY_SELECTED_SOUND, soundName)
            putBoolean(KEY_ADHAN_FAJR, adhanFajr)
            putBoolean(KEY_ADHAN_DHUHR, adhanDhuhr)
            putBoolean(KEY_ADHAN_MAGHRIB, adhanMaghrib)
            putInt(KEY_SNOOZE_MINUTES, snoozeMinutes)
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
            if (args.containsKey("snoozeMinutes")) {
                val s = (args["snoozeMinutes"] as? Number)?.toInt() ?: 5
                putInt(KEY_SNOOZE_MINUTES, s)
            }
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

    private fun getTodayKey(): Int {
        val now = Calendar.getInstance()
        return now.get(Calendar.DAY_OF_MONTH) +
                (now.get(Calendar.MONTH) + 1) * 100 +
                now.get(Calendar.YEAR) * 10000
    }
}
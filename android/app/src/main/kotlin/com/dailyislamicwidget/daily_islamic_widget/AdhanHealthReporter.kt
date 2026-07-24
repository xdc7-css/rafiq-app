package com.dailyislamicwidget.daily_islamic_widget

import android.app.AlarmManager
import android.app.AppOpsManager
import android.app.NotificationManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.content.pm.PackageManager
import android.os.Build
import android.os.PowerManager
import android.provider.Settings
import android.util.Log

/**
 * AdhanHealthReporter — isolated native diagnostics for adhan runtime readiness.
 *
 * Single source of truth for all health checks. Does NOT modify scheduling logic.
 * Returns a structured JSON-serializable map to Flutter via MethodChannel.
 *
 * Every check returns: status (healthy/warning/error/unknown), title, description, recommendation.
 */
object AdhanHealthReporter {

    private const val TAG = "AdhanHealthReporter"
    private const val PREFS_NAME = "adhan_schedule"
    private const val KEY_ADHAN_ENABLED = "adhan_enabled"
    private const val KEY_LAST_SCHEDULED_DAY = "last_scheduled_day"
    private const val KEY_PRAYER_TIMES_JSON = "prayer_times_json"

    // ── Status constants ─────────────────────────────────────────────────
    private const val STATUS_HEALTHY = "healthy"
    private const val STATUS_WARNING = "warning"
    private const val STATUS_ERROR = "error"
    private const val STATUS_UNKNOWN = "unknown"

    /**
     * Collects the full health report. Returns a JSON-serializable map.
     */
    fun collectReport(context: Context): Map<String, Any> {
        Log.i(TAG, "[HEALTH] Starting health report collection")

        val checks = listOf(
            checkNotificationsEnabled(context),
            checkPostNotificationsPermission(context),
            checkExactAlarmCapability(context),
            checkBatteryOptimization(context),
            checkForegroundServiceCapability(context),
            checkWakeLockPermission(context),
            checkBootReceiverEnabled(context),
            checkAdhanFeatureEnabled(context),
            checkPrayerScheduleExists(context),
            checkNextPrayerScheduled(context),
            checkOemDetected(context),
            checkAndroidVersion(context),
            checkSdkLevel(context),
            checkManufacturer(context),
            checkBrand(context),
            checkModel(context),
            checkHarmonyOs(context),
            checkOemCompatibility(context),
            checkAlarmSchedulingMethod(context),
            checkAudioMode(context),
        )

        val score = calculateScore(checks)
        val level = scoreToLevel(score)

        Log.i(TAG, "[HEALTH] Report complete: score=$score, level=$level, checks=${checks.size}")

        return mapOf(
            "checks" to checks,
            "overallScore" to score,
            "overallLevel" to level,
            "timestamp" to System.currentTimeMillis(),
        )
    }

    // ── Individual health checks ─────────────────────────────────────────

    private fun checkNotificationsEnabled(context: Context): Map<String, Any> {
        val nm = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        val enabled = nm.areNotificationsEnabled()
        Log.i(TAG, "[HEALTH] notifications_enabled=$enabled")
        return buildCheck(
            id = "notifications_enabled",
            section = "notifications",
            title = "الإشعارات مفعّلة",
            status = if (enabled) STATUS_HEALTHY else STATUS_ERROR,
            value = enabled,
            description = if (enabled) "إشعارات الأذان مفعلة" else "إشعارات الأذان معطّلة — لن تظهر تنبيهات الأذان",
            recommendation = if (enabled) "" else "فعّل الإشعارات من إعدادات التطبيق لإظهار تنبيهات الأذان",
        )
    }

    private fun checkPostNotificationsPermission(context: Context): Map<String, Any> {
        val status = if (Build.VERSION.SDK_INT >= 33) {
            val granted = context.checkSelfPermission(android.Manifest.permission.POST_NOTIFICATIONS) == PackageManager.PERMISSION_GRANTED
            Log.i(TAG, "[HEALTH] post_notifications_granted=$granted (API 33+)")
            if (granted) STATUS_HEALTHY else STATUS_ERROR
        } else {
            Log.i(TAG, "[HEALTH] post_notifications=not_required (API <33)")
            STATUS_HEALTHY
        }
        val granted = if (Build.VERSION.SDK_INT >= 33) {
            context.checkSelfPermission(android.Manifest.permission.POST_NOTIFICATIONS) == PackageManager.PERMISSION_GRANTED
        } else true
        return buildCheck(
            id = "post_notifications_permission",
            section = "permissions",
            title = "إذن POST_NOTIFICATIONS",
            status = status,
            value = granted,
            description = if (granted) "إذن الإشعارات ممنوح" else "إذن الإشعارات غير ممنوح (Android 13+)",
            recommendation = if (granted) "" else "افذع إذن الإشعارات عند بدء التطبيق",
        )
    }

    private fun checkExactAlarmCapability(context: Context): Map<String, Any> {
        val am = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val canSchedule = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            am.canScheduleExactAlarms()
        } else {
            true
        }
        Log.i(TAG, "[HEALTH] can_schedule_exact_alarms=$canSchedule (API ${Build.VERSION.SDK_INT})")
        return buildCheck(
            id = "exact_alarm_capability",
            section = "alarm",
            title = "دقة المنبّه",
            status = if (canSchedule) STATUS_HEALTHY else STATUS_WARNING,
            value = canSchedule,
            description = if (canSchedule) "يمكن جدولة منبّهات دقيقة" else "لا يمكن جدولة منبّهات دقيقة — سيتم استخدام setAlarmClock كبديل",
            recommendation = if (canSchedule) "" else "التطبيق يستخدم setAlarmClock كبديل — يجب أن يعمل بشكل طبيعي",
        )
    }

    private fun checkBatteryOptimization(context: Context): Map<String, Any> {
        val isIgnoring = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val pm = context.getSystemService(Context.POWER_SERVICE) as PowerManager
            pm.isIgnoringBatteryOptimizations(context.packageName)
        } else {
            true
        }
        Log.i(TAG, "[HEALTH] ignoring_battery_optimization=$isIgnoring")
        return buildCheck(
            id = "battery_optimization",
            section = "battery",
            title = "تحسين البطارية",
            status = if (isIgnoring) STATUS_HEALTHY else STATUS_WARNING,
            value = isIgnoring,
            description = if (isIgnoring) "التطبيق غير مقيد by تحسين البطارية" else "التطبيق مقيد by تحسين البطارية — قد لا يعمل الأذان في الخلفية",
            recommendation = if (isIgnoring) "" else "افتح إعدادات البطارية واستثنِ التطبيق من التقييد",
        )
    }

    private fun checkForegroundServiceCapability(context: Context): Map<String, Any> {
        val fgPerm = context.checkSelfPermission(android.Manifest.permission.FOREGROUND_SERVICE) == PackageManager.PERMISSION_GRANTED
        val fgMedia = if (Build.VERSION.SDK_INT >= 34) {
            context.checkSelfPermission("android.permission.FOREGROUND_SERVICE_MEDIA_PLAYBACK") == PackageManager.PERMISSION_GRANTED
        } else true
        val enabled = fgPerm && fgMedia
        Log.i(TAG, "[HEALTH] foreground_service=$enabled (fgPerm=$fgPerm, fgMedia=$fgMedia)")
        return buildCheck(
            id = "foreground_service",
            section = "permissions",
            title = "خدمة الخلفية",
            status = if (enabled) STATUS_HEALTHY else STATUS_ERROR,
            value = enabled,
            description = if (enabled) "إذن تشغيل الخلفية ممنوح" else "إذن تشغيل الخلفية غير ممنوح — لن يعمل صوت الأذان",
            recommendation = if (enabled) "" else "تأكد من إذن FOREGROUND_SERVICE في AndroidManifest",
        )
    }

    private fun checkWakeLockPermission(context: Context): Map<String, Any> {
        val granted = context.checkSelfPermission(android.Manifest.permission.WAKE_LOCK) == PackageManager.PERMISSION_GRANTED
        Log.i(TAG, "[HEALTH] wakelock_permission=$granted")
        return buildCheck(
            id = "wakelock_permission",
            section = "permissions",
            title = "إذن WakeLock",
            status = if (granted) STATUS_HEALTHY else STATUS_WARNING,
            value = granted,
            description = if (granted) "إذن WakeLock ممنوح" else "إذن WakeLock غير ممنوح",
            recommendation = if (granted) "" else "أضف إذن WAKE_LOCK إلى AndroidManifest",
        )
    }

    private fun checkBootReceiverEnabled(context: Context): Map<String, Any> {
        val pm = context.packageManager
        val component = ComponentName(context, AdhanBootReceiver::class.java)
        val enabled = try {
            val info = pm.getComponentEnabledSetting(component)
            info != PackageManager.COMPONENT_ENABLED_STATE_DISABLED
        } catch (e: Exception) {
            Log.w(TAG, "[HEALTH] boot_receiver check failed: ${e.message}")
            true // Assume enabled if we can't check
        }
        Log.i(TAG, "[HEALTH] boot_receiver_enabled=$enabled")
        return buildCheck(
            id = "boot_receiver_enabled",
            section = "scheduling",
            title = "مستقبل الإقلاع",
            status = if (enabled) STATUS_HEALTHY else STATUS_WARNING,
            value = enabled,
            description = if (enabled) "مستقبل الإقلاع مفعّل — يعيد جدولة الأذان بعد التشغيل" else "مستقبل الإقلاع معطّل — لن تُعاد جدولة الأذان بعد التشغيل",
            recommendation = if (enabled) "" else "فعّل AdhanBootReceiver من إعدادات التطبيق",
        )
    }

    private fun checkAdhanFeatureEnabled(context: Context): Map<String, Any> {
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        val enabled = prefs.getBoolean(KEY_ADHAN_ENABLED, false)
        Log.i(TAG, "[HEALTH] adhan_feature_enabled=$enabled")
        return buildCheck(
            id = "adhan_feature_enabled",
            section = "scheduling",
            title = "ميزة الأذان مفعّلة",
            status = if (enabled) STATUS_HEALTHY else STATUS_WARNING,
            value = enabled,
            description = if (enabled) "الأذان مفعّل في إعدادات التطبيق" else "الأذان غير مفعّل في إعدادات التطبيق",
            recommendation = if (enabled) "" else "فعّل الأذان من إعدادات التطبيق",
        )
    }

    private fun checkPrayerScheduleExists(context: Context): Map<String, Any> {
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        val json = prefs.getString(KEY_PRAYER_TIMES_JSON, null)
        val exists = !json.isNullOrEmpty()
        Log.i(TAG, "[HEALTH] prayer_schedule_exists=$exists")
        return buildCheck(
            id = "prayer_schedule_exists",
            section = "scheduling",
            title = "جدول الصلاة موجود",
            status = if (exists) STATUS_HEALTHY else STATUS_WARNING,
            value = exists,
            description = if (exists) "جدول أوقات الصلاة محفوظ" else "لا يوجد جدول أوقات صلاة محفوظ",
            recommendation = if (exists) "" else "افتح التطبيق لتحميل أوقات الصلاة تلقائياً",
        )
    }

    private fun checkNextPrayerScheduled(context: Context): Map<String, Any> {
        val am = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val nextAlarm = am.nextAlarmClock?.triggerTime
        val scheduled = nextAlarm != null && nextAlarm > System.currentTimeMillis()
        Log.i(TAG, "[HEALTH] next_prayer_scheduled=$scheduled (nextAlarm=$nextAlarm)")
        return buildCheck(
            id = "next_prayer_scheduled",
            section = "scheduling",
            title = "الصلاة القادمة مجدولة",
            status = if (scheduled) STATUS_HEALTHY else STATUS_WARNING,
            value = scheduled,
            description = if (scheduled) "هناك منبّه مجدول للصلاة القادمة" else "لا يوجد منبّه مجدول",
            recommendation = if (scheduled) "" else "أعد فتح التطبيق لإعادة جدولة الأذان",
        )
    }

    private fun checkOemDetected(context: Context): Map<String, Any> {
        val diag = OemCompatibility.collectDiagnostics(context)
        Log.i(TAG, "[HEALTH] oem_detected=${diag.oemType}")
        return buildCheck(
            id = "oem_detected",
            section = "oem",
            title = "نوع الجهاز",
            status = if (diag.isSupportedOem) STATUS_HEALTHY else STATUS_UNKNOWN,
            value = diag.oemDisplayName,
            description = "الجهاز: ${diag.oemDisplayName} (${diag.oemType.name})",
            recommendation = if (diag.isSupportedOem) "تم اكتشاف الجهاز — تحقق من إعدادات البطارية" else "جهاز غير معروف — تحقق من إعدادات البطارية يدوياً",
        )
    }

    private fun checkAndroidVersion(context: Context): Map<String, Any> {
        val version = Build.VERSION.RELEASE
        Log.i(TAG, "[HEALTH] android_version=$version")
        return buildCheck(
            id = "android_version",
            section = "device",
            title = "إصدار Android",
            status = STATUS_HEALTHY,
            value = version,
            description = "Android $version",
            recommendation = "",
        )
    }

    private fun checkSdkLevel(context: Context): Map<String, Any> {
        val sdk = Build.VERSION.SDK_INT
        Log.i(TAG, "[HEALTH] sdk_level=$sdk")
        return buildCheck(
            id = "sdk_level",
            section = "device",
            title = "مستوى SDK",
            status = if (sdk >= 26) STATUS_HEALTHY else STATUS_WARNING,
            value = sdk,
            description = "SDK $sdk (${Build.VERSION.SECURITY_PATCH})",
            recommendation = if (sdk >= 26) "" else "الإصدار قديم — قد لا تعمل بعض الميزات",
        )
    }

    private fun checkManufacturer(context: Context): Map<String, Any> {
        val mfr = Build.MANUFACTURER
        Log.i(TAG, "[HEALTH] manufacturer=$mfr")
        return buildCheck(
            id = "manufacturer",
            section = "device",
            title = "الشركة المصنعة",
            status = STATUS_HEALTHY,
            value = mfr,
            description = "الشركة: $mfr",
            recommendation = "",
        )
    }

    private fun checkBrand(context: Context): Map<String, Any> {
        val brand = Build.BRAND
        Log.i(TAG, "[HEALTH] brand=$brand")
        return buildCheck(
            id = "brand",
            section = "device",
            title = "العلامة التجارية",
            status = STATUS_HEALTHY,
            value = brand,
            description = "العلامة: $brand",
            recommendation = "",
        )
    }

    private fun checkModel(context: Context): Map<String, Any> {
        val model = Build.MODEL
        Log.i(TAG, "[HEALTH] model=$model")
        return buildCheck(
            id = "model",
            section = "device",
            title = "طراز الجهاز",
            status = STATUS_HEALTHY,
            value = model,
            description = "الطراز: $model",
            recommendation = "",
        )
    }

    private fun checkHarmonyOs(context: Context): Map<String, Any> {
        val diag = OemCompatibility.collectDiagnostics(context)
        Log.i(TAG, "[HEALTH] harmony_os=${diag.isHarmonyOs}")
        return buildCheck(
            id = "harmony_os",
            section = "oem",
            title = "HarmonyOS",
            status = if (diag.isHarmonyOs) STATUS_WARNING else STATUS_HEALTHY,
            value = diag.isHarmonyOs,
            description = if (diag.isHarmonyOs) "الجهاز يعمل بنظام HarmonyOS" else "الجهاز لا يعمل بنظام HarmonyOS",
            recommendation = if (diag.isHarmonyOs) "تحقق من إعدادات البطارية يدوياً" else "",
        )
    }

    private fun checkOemCompatibility(context: Context): Map<String, Any> {
        val diag = OemCompatibility.collectDiagnostics(context)
        Log.i(TAG, "[HEALTH] oem_compatibility=${diag.isSupportedOem}")
        return buildCheck(
            id = "oem_compatibility",
            section = "oem",
            title = "توافق OEM",
            status = if (diag.isSupportedOem) STATUS_HEALTHY else STATUS_UNKNOWN,
            value = diag.isSupportedOem,
            description = if (diag.isSupportedOem) "الجهاز مدعوم — يمكن فتح إعدادات البطارية تلقائياً" else "الجهاز غير مدعوم — افتح إعدادات البطارية يدوياً",
            recommendation = if (diag.isSupportedOem) "" else "افتح إعدادات البطارية من إعدادات التطبيق",
        )
    }

    private fun checkAlarmSchedulingMethod(context: Context): Map<String, Any> {
        val method = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            "setAlarmClock"
        } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            "setExact"
        } else {
            "fallback"
        }
        Log.i(TAG, "[HEALTH] alarm_method=$method (API ${Build.VERSION.SDK_INT})")
        return buildCheck(
            id = "alarm_method",
            section = "alarm",
            title = "طريقة جدولة المنبّه",
            status = STATUS_HEALTHY,
            value = method,
            description = "الطريقة: $method",
            recommendation = when (method) {
                "setAlarmClock" -> "الأفضل — يتجاوز وضع الطاقة ويعمل بشكل موثوق"
                "setExact" -> "دقيق — يعمل على Android 4.4+"
                else -> "تقديري — قد لا يعمل بشكل دقيق"
            },
        )
    }

    private fun checkAudioMode(context: Context): Map<String, Any> {
        // Phase 1 migrated to USAGE_ALARM / STREAM_ALARM
        val mode = "USAGE_ALARM / STREAM_ALARM"
        Log.i(TAG, "[HEALTH] audio_mode=$mode")
        return buildCheck(
            id = "audio_mode",
            section = "alarm",
            title = "وضع الصوت",
            status = STATUS_HEALTHY,
            value = mode,
            description = "وضع الصوت: $mode",
            recommendation = "الأفضل — يضمن سماع الأذان حتى في وضع الصامت",
        )
    }

    // ── Helpers ──────────────────────────────────────────────────────────

    private fun buildCheck(
        id: String,
        section: String,
        title: String,
        status: String,
        value: Any?,
        description: String,
        recommendation: String,
    ): Map<String, Any> = mapOf(
        "id" to id,
        "section" to section,
        "title" to title,
        "status" to status,
        "value" to (value?.toString() ?: ""),
        "description" to description,
        "recommendation" to recommendation,
    )

    private fun calculateScore(checks: List<Map<String, Any>>): Int {
        if (checks.isEmpty()) return 0
        var total = 0
        for (check in checks) {
            total += when (check["status"]) {
                STATUS_HEALTHY -> 100
                STATUS_WARNING -> 60
                STATUS_ERROR -> 0
                else -> 50
            }
        }
        return total / checks.size
    }

    private fun scoreToLevel(score: Int): String = when {
        score >= 95 -> "excellent"
        score >= 80 -> "good"
        score >= 60 -> "needs_attention"
        else -> "critical"
    }
}

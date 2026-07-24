package com.dailyislamicwidget.daily_islamic_widget

import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.PowerManager
import android.provider.Settings
import android.util.Log

/**
 * OEM-specific battery optimization and AutoStart intent mappings.
 *
 * Single source of truth for all OEM detection, intent mappings,
 * battery status, and manufacturer-specific instructions.
 *
 * Detection uses Build.MANUFACTURER + Build.BRAND + Build.MODEL +
 * Build.DISPLAY + Build.PRODUCT + Build.VERSION.SDK_INT.
 *
 * Fallback chain:
 *   1. OEM-specific intent (try every known component)
 *   2. Battery optimization ignore screen
 *   3. App detail settings
 */
object OemCompatibility {

    private const val TAG = "OemCompatibility"

    // ── Result codes ─────────────────────────────────────────────────────
    const val RESULT_OPENED_OEM_SETTINGS = "opened_oem_settings"
    const val RESULT_OPENED_BATTERY_SETTINGS = "opened_battery_settings"
    const val RESULT_OPENED_APP_SETTINGS = "opened_app_settings"
    const val RESULT_UNSUPPORTED_DEVICE = "unsupported_device"
    const val RESULT_FAILED = "failed"

    // ── OEM type enum ────────────────────────────────────────────────────
    enum class OemType {
        VIVO,
        IQOO,
        XIAOMI,
        REDMI,
        POCO,
        OPPO,
        REALME,
        ONEPLUS,
        HUAWEI,
        HONOR,
        HARMONY_OS,
        GENERIC
    }

    // ── Device diagnostics data class ────────────────────────────────────
    data class DeviceDiagnostics(
        val manufacturer: String,
        val manufacturerRaw: String,
        val brand: String,
        val model: String,
        val display: String,
        val product: String,
        val sdkInt: Int,
        val androidVersion: String,
        val oemType: OemType,
        val oemDisplayName: String,
        val isSupportedOem: Boolean,
        val isIgnoringBatteryOptimizations: Boolean,
        val isHarmonyOs: Boolean,
        val instructions: List<InstructionStep>,
        val instructionsSummary: String
    )

    // ── Instruction step data class ──────────────────────────────────────
    data class InstructionStep(
        val title: String,
        val description: String,
        val icon: String
    )

    // ── OEM intent mappings ──────────────────────────────────────────────

    private val vivoIntents = listOf(
        ComponentName("com.vivo.permissionmanager", "com.vivo.permissionmanager.activity.BgStartManagerActivity"),
        ComponentName("com.vivo.permissionmanager", "com.vivo.permissionmanager.activity.SoftPermissionDetailActivity"),
        ComponentName("com.iqoo.secure", "com.iqoo.secure.ui.phoneoptimize.AddWhiteListActivity"),
        ComponentName("com.iqoo.secure", "com.iqoo.secure.ui.phoneoptimize.AddBgStartWhitelistActivity"),
        ComponentName("com.vivo.launcher", "com.vivo.launcher.extraactivity.AutoStartDetailActivity"),
    )

    private val iQooIntents = listOf(
        ComponentName("com.iqoo.secure", "com.iqoo.secure.ui.phoneoptimize.AddWhiteListActivity"),
        ComponentName("com.iqoo.secure", "com.iqoo.secure.ui.phoneoptimize.AddBgStartWhitelistActivity"),
        ComponentName("com.vivo.permissionmanager", "com.vivo.permissionmanager.activity.BgStartManagerActivity"),
        ComponentName("com.vivo.permissionmanager", "com.vivo.permissionmanager.activity.SoftPermissionDetailActivity"),
        ComponentName("com.vivo.launcher", "com.vivo.launcher.extraactivity.AutoStartDetailActivity"),
    )

    // MIUI shared by Xiaomi, Redmi, Poco — single list, no duplication
    private val miuiIntents = listOf(
        ComponentName("com.miui.securitycenter", "com.miui.permcenter.autostart.AutoStartManagementActivity"),
        ComponentName("com.miui.securitycenter", "com.miui.permcenter.permissions.PermissionsEditorActivity"),
        ComponentName("com.miui.securitycenter", "com.miui.permcenter.privacymanager.AddExceptionActivity"),
        ComponentName("com.miui.securitycenter", "com.miui.powercenter.PowerSettingsActivity"),
    )

    private val oppoIntents = listOf(
        ComponentName("com.coloros.safecenter", "com.coloros.safecenter.startupapp.StartupAppListActivity"),
        ComponentName("com.coloros.safecenter", "com.coloros.safecenter.permission.startapp.AutoStartManagementActivity"),
        ComponentName("com.oppo.safe", "com.oppo.safe.permission.startup.StartupAppListActivity"),
        ComponentName("com.oppo.safe", "com.oppo.safe.permission.startapp.AutoStartManagementActivity"),
        ComponentName("com.coloros.oppoguardelf", "com.coloros.oppoguardelf.compatibility.CompatibilityActivity"),
    )

    private val realmeIntents = listOf(
        ComponentName("com.coloros.safecenter", "com.coloros.safecenter.startupapp.StartupAppListActivity"),
        ComponentName("com.coloros.safecenter", "com.coloros.safecenter.permission.startapp.AutoStartManagementActivity"),
        ComponentName("com.oppo.safe", "com.oppo.safe.permission.startup.StartupAppListActivity"),
        ComponentName("com.oppo.safe", "com.oppo.safe.permission.startapp.AutoStartManagementActivity"),
        ComponentName("com.realme.securitycenter", "com.realme.securitycenter.power.PowerManagementActivity"),
    )

    private val huaweiIntents = listOf(
        ComponentName("com.huawei.systemmanager", "com.huawei.systemmanager.startupmgr.ui.StartupNormalAppListActivity"),
        ComponentName("com.huawei.systemmanager", "com.huawei.systemmanager.optimize.process.ProtectActivity"),
        ComponentName("com.huawei.systemmanager", "com.huawei.systemmanager.mainscreen.MainScreenActivity"),
        ComponentName("com.huawei.systemmanager", "com.huawei.systemmanager.ui.settings.SettingsActivity"),
    )

    private val honorIntents = listOf(
        ComponentName("com.hihonor.systemmanager", "com.hihonor.systemmanager.startupmgr.ui.StartupNormalAppListActivity"),
        ComponentName("com.hihonor.systemmanager", "com.hihonor.systemmanager.optimize.process.ProtectActivity"),
        ComponentName("com.hihonor.systemmanager", "com.hihonor.systemmanager.mainscreen.MainScreenActivity"),
        ComponentName("com.huawei.systemmanager", "com.huawei.systemmanager.startupmgr.ui.StartupNormalAppListActivity"),
        ComponentName("com.huawei.systemmanager", "com.huawei.systemmanager.optimize.process.ProtectActivity"),
        ComponentName("com.huawei.systemmanager", "com.huawei.systemmanager.mainscreen.MainScreenActivity"),
    )

    private val oneplusIntents = listOf(
        ComponentName("com.coloros.safecenter", "com.coloros.safecenter.startupapp.StartupAppListActivity"),
        ComponentName("com.oneplus.security", "com.oneplus.security.chainlaunch.ChainLaunchListActivity"),
        ComponentName("com.coloros.oppoguardelf", "com.coloros.oppoguardelf.compatibility.CompatibilityActivity"),
        ComponentName("com.oneplus.mtm", "com.oneplus.mtm.activity.ManageBackgroundActivity"),
    )

    // ── Public API ───────────────────────────────────────────────────────

    /**
     * Opens OEM-specific battery/AutoStart settings with full fallback chain.
     * @return One of RESULT_* constants
     */
    fun openBatteryOptimizationSettings(context: Context): String {
        val diag = collectDiagnostics(context)
        Log.i(TAG, "[VERIFICATION] OPEN_SETTINGS: oem=${diag.oemType}, manufacturer=${diag.manufacturerRaw}, brand=${diag.brand}, model=${diag.model}, display=${diag.display}, sdk=${diag.sdkInt}, harmony=${diag.isHarmonyOs}")

        val oemIntents = getIntentsForOem(diag.oemType)
        if (oemIntents.isNotEmpty()) {
            val result = tryOemIntents(context, oemIntents, diag.oemType)
            if (result != null) {
                Log.i(TAG, "[VERIFICATION] OPEN_RESULT=$result (oem=${diag.oemType})")
                return result
            }
            Log.w(TAG, "[VERIFICATION] OEM_INTENTS_ALL_FAILED (oem=${diag.oemType})")
        } else {
            Log.i(TAG, "[VERIFICATION] NO_OEM_INTENTS (oem=${diag.oemType})")
        }

        val fallbackResult = tryStandardSettings(context)
        Log.i(TAG, "[VERIFICATION] OPEN_RESULT=$fallbackResult (fallback, oem=${diag.oemType})")
        return fallbackResult
    }

    /**
     * Collects full device diagnostics including battery optimization status.
     */
    fun collectDiagnostics(context: Context): DeviceDiagnostics {
        val manufacturer = Build.MANUFACTURER.lowercase()
        val brand = Build.BRAND.lowercase()
        val model = Build.MODEL
        val display = Build.DISPLAY
        val product = Build.PRODUCT
        val sdkInt = Build.VERSION.SDK_INT
        val androidVersion = Build.VERSION.RELEASE

        val oemType = detectOem(manufacturer, brand, model, display, product)
        val isHarmonyOs = detectHarmonyOs(display, product, model, manufacturer)
        val isIgnoring = isIgnoringBatteryOptimizations(context)
        val steps = getInstructionsForOem(oemType)

        Log.i(TAG, "[VERIFICATION] DIAGNOSTICS: manufacturer=$manufacturer, brand=$brand, model=$model, display=$display, product=$product, sdk=$sdkInt, oem=$oemType, harmony=$isHarmonyOs, ignoringBattery=$isIgnoring")

        return DeviceDiagnostics(
            manufacturer = getDisplayName(oemType),
            manufacturerRaw = manufacturer,
            brand = brand,
            model = model,
            display = display,
            product = product,
            sdkInt = sdkInt,
            androidVersion = androidVersion,
            oemType = oemType,
            oemDisplayName = getDisplayName(oemType),
            isSupportedOem = oemType != OemType.GENERIC,
            isIgnoringBatteryOptimizations = isIgnoring,
            isHarmonyOs = isHarmonyOs,
            instructions = steps,
            instructionsSummary = buildInstructionsSummary(oemType, getDisplayName(oemType))
        )
    }

    fun getDisplayName(oemType: OemType): String = when (oemType) {
        OemType.VIVO -> "Vivo"
        OemType.IQOO -> "iQOO"
        OemType.XIAOMI -> "Xiaomi"
        OemType.REDMI -> "Redmi"
        OemType.POCO -> "Poco"
        OemType.OPPO -> "OPPO"
        OemType.REALME -> "Realme"
        OemType.ONEPLUS -> "OnePlus"
        OemType.HUAWEI -> "Huawei"
        OemType.HONOR -> "Honor"
        OemType.HARMONY_OS -> "HarmonyOS"
        OemType.GENERIC -> Build.MANUFACTURER.replaceFirstChar { it.uppercase() }
    }

    // ── OEM detection ────────────────────────────────────────────────────

    private fun detectOem(
        manufacturer: String,
        brand: String,
        model: String,
        display: String,
        product: String
    ): OemType {
        val combined = "$manufacturer $brand $model $display $product".lowercase()

        // iQOO must be checked before Vivo since iQOO is a Vivo sub-brand
        // but has its own secure center package
        if (combined.contains("iqoo")) return OemType.IQOO
        if (combined.contains("vivo")) return OemType.VIVO
        if (combined.contains("redmi")) return OemType.REDMI
        if (combined.contains("poco")) return OemType.POCO
        if (combined.contains("xiaomi") || combined.contains("miui")) return OemType.XIAOMI
        if (combined.contains("realme")) return OemType.REALME
        if (combined.contains("oppo") || combined.contains("coloros")) return OemType.OPPO
        if (combined.contains("oneplus") || combined.contains("oplus")) return OemType.ONEPLUS
        if (combined.contains("honor") || combined.contains("magic")) return OemType.HONOR
        if (combined.contains("huawei") || combined.contains("emui")) return OemType.HUAWEI

        // HarmonyOS detection — can run on Huawei or Honor hardware
        if (detectHarmonyOs(display, product, model, manufacturer)) return OemType.HARMONY_OS

        return OemType.GENERIC
    }

    private fun detectHarmonyOs(
        display: String,
        product: String,
        model: String,
        manufacturer: String
    ): Boolean {
        val combined = "$display $product $model $manufacturer".lowercase()
        return combined.contains("harmonyos") ||
                combined.contains("harmony os") ||
                combined.contains("harmony ") ||
                combined.contains("hmos") ||
                // HarmonyOS 4+ often shows "HarmonyOS" in Build.DISPLAY
                display.lowercase().contains("harmony")
    }

    private fun isIgnoringBatteryOptimizations(context: Context): Boolean {
        return try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                val pm = context.getSystemService(Context.POWER_SERVICE) as PowerManager
                pm.isIgnoringBatteryOptimizations(context.packageName)
            } else {
                true // Pre-Marshmallow, no battery optimization
            }
        } catch (e: Exception) {
            Log.w(TAG, "[VERIFICATION] Battery optimization check failed: ${e.message}")
            false
        }
    }

    // ── Intent resolution ────────────────────────────────────────────────

    private fun getIntentsForOem(oemType: OemType): List<ComponentName> = when (oemType) {
        OemType.VIVO -> vivoIntents
        OemType.IQOO -> iQooIntents
        OemType.XIAOMI -> miuiIntents
        OemType.REDMI -> miuiIntents
        OemType.POCO -> miuiIntents
        OemType.OPPO -> oppoIntents
        OemType.REALME -> realmeIntents
        OemType.ONEPLUS -> oneplusIntents
        OemType.HUAWEI -> huaweiIntents
        OemType.HONOR -> honorIntents
        OemType.HARMONY_OS -> huaweiIntents // HarmonyOS uses Huawei-style settings
        OemType.GENERIC -> emptyList()
    }

    private fun tryOemIntents(
        context: Context,
        intents: List<ComponentName>,
        oemType: OemType
    ): String? {
        val pm = context.packageManager
        for (component in intents) {
            Log.i(TAG, "[VERIFICATION] TRYING_OEM: oem=$oemType, component=${component.packageName}/${component.className}")
            try {
                val intent = Intent().apply {
                    this.component = component
                    addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                }
                val resolveInfo = pm.resolveActivity(intent, 0)
                if (resolveInfo != null) {
                    Log.i(TAG, "[VERIFICATION] OEM_RESOLVED: ${component.packageName}/${component.className}")
                    try {
                        context.startActivity(intent)
                        Log.i(TAG, "[VERIFICATION] OEM_OPENED_SUCCESS: ${component.packageName}/${component.className}")
                        return RESULT_OPENED_OEM_SETTINGS
                    } catch (e: SecurityException) {
                        Log.w(TAG, "[VERIFICATION] OEM_SECURITY_EXCEPTION: ${component.packageName}/${component.className}: ${e.message}")
                    } catch (e: Exception) {
                        Log.w(TAG, "[VERIFICATION] OEM_START_FAILED: ${component.packageName}/${component.className}: ${e.message}")
                    }
                } else {
                    Log.d(TAG, "[VERIFICATION] OEM_NOT_RESOLVED: ${component.packageName}/${component.className}")
                }
            } catch (e: Exception) {
                Log.w(TAG, "[VERIFICATION] OEM_INTENT_ERROR: ${component.packageName}/${component.className}: ${e.message}")
            }
        }
        return null
    }

    private fun tryStandardSettings(context: Context): String {
        try {
            Log.i(TAG, "[VERIFICATION] TRYING_STANDARD: ACTION_IGNORE_BATTERY_OPTIMIZATION_SETTINGS")
            val intent = Intent(Settings.ACTION_IGNORE_BATTERY_OPTIMIZATION_SETTINGS).apply {
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            }
            if (context.packageManager.resolveActivity(intent, 0) != null) {
                context.startActivity(intent)
                Log.i(TAG, "[VERIFICATION] STANDARD_OPENED: ACTION_IGNORE_BATTERY_OPTIMIZATION_SETTINGS")
                return RESULT_OPENED_BATTERY_SETTINGS
            }
        } catch (e: Exception) {
            Log.w(TAG, "[VERIFICATION] STANDARD_FAILED: ACTION_IGNORE_BATTERY_OPTIMIZATION_SETTINGS: ${e.message}")
        }

        try {
            Log.i(TAG, "[VERIFICATION] TRYING_STANDARD: ACTION_APPLICATION_DETAILS_SETTINGS")
            val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS).apply {
                data = Uri.parse("package:${context.packageName}")
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            }
            if (context.packageManager.resolveActivity(intent, 0) != null) {
                context.startActivity(intent)
                Log.i(TAG, "[VERIFICATION] STANDARD_OPENED: ACTION_APPLICATION_DETAILS_SETTINGS")
                return RESULT_OPENED_APP_SETTINGS
            }
        } catch (e: Exception) {
            Log.w(TAG, "[VERIFICATION] STANDARD_FAILED: ACTION_APPLICATION_DETAILS_SETTINGS: ${e.message}")
        }

        return RESULT_FAILED
    }

    // ── Instructions ─────────────────────────────────────────────────────

    private fun getInstructionsForOem(oemType: OemType): List<InstructionStep> = when (oemType) {
        OemType.VIVO -> listOf(
            InstructionStep("تفعيل التشغيل التلقائي", "افتح إدارة التطبيقات → ابحث عن التشغيل التلقائي (AutoStart) وفعّل التطبيق", "power"),
            InstructionStep("إباحة التشغيل في الخلفية", "البطارية → استهلاك البطارية → اختر التطبيق → غير مقيد", "battery"),
            InstructionStep("تشغيل في الخلفية", "افتح الإعدادات → التطبيقات → سجّل الرحمة → السماح بتشغيل الخلفية", "background"),
            InstructionStep("قفل في التطبيقات الأخيرة", "افتح قائمة التطبيقات الأخيرة → اسحب التطبيق لقفله以防 الإغلاق", "lock"),
        )
        OemType.IQOO -> listOf(
            InstructionStep("تفعيل التشغيل التلقائي", "الإعدادات → التطبيقات → التشغيل التلقائي → فعّل التطبيق", "power"),
            InstructionStep("إباحة التشغيل في الخلفية", "البطارية → استهلاك البطارية → اختر التطبيق → غير مقيد", "battery"),
            InstructionStep("تشغيل في الخلفية", "الإعدادات → التطبيقات → سجّل الرحمة → السماح بتشغيل الخلفية", "background"),
            InstructionStep("قفل في التطبيقات الأخيرة", "افتح قائمة التطبيقات الأخيرة → اسحب التطبيق لقفله以防 الإغلاق", "lock"),
        )
        OemType.XIAOMI, OemType.REDMI, OemType.POCO -> listOf(
            InstructionStep("تفعيل التشغيل التلقائي", "الأمان → صلاحيات → التشغيل التلقائي → فعّل التطبيق", "power"),
            InstructionStep("لا تقييد البطارية", "الأمان → توفير البطارية → اختر التطبيق → لا تقييد", "battery"),
            InstructionStep("إباحة التشغيل في الخلفية", "الأمان → صلاحيات → إباحة التشغيل في الخلفية → فعّل التطبيق", "background"),
            InstructionStep("إدارة البطارية اليدوية", "البطارية → إدارة البطارية → اختر التطبيق → يدوي", "battery"),
        )
        OemType.OPPO -> listOf(
            InstructionStep("قائمة البداية", "الأمان → قائمة البداية (Startup Manager) → فعّل التطبيق", "power"),
            InstructionStep("إباحة التشغيل في الخلفية", "البطارية → استهلاك البطارية → اختر التطبيق → التشغيل في الخلفية", "battery"),
            InstructionStep("إيقاف تجميد التطبيق", "الأمان → إعدادات إضافية → بطارية → إيقاف تجميد التطبيقات → أوقف تجميد التطبيق", "freeze"),
            InstructionStep("إشعار الخلفية", "الإعدادات → التطبيقات → سجّل الرحمة → الإشعارات → فعّل إشعار الخلفية", "notification"),
        )
        OemType.REALME -> listOf(
            InstructionStep("قائمة البداية", "الأمان → قائمة البداية (Startup Manager) → فعّل التطبيق", "power"),
            InstructionStep("إباحة التشغيل في الخلفية", "البطارية → استهلاك البطارية → اختر التطبيق → التشغيل في الخلفية", "battery"),
            InstructionStep("إيقاف تجميد التطبيق", "الأمان → إعدادات إضافية → بطارية → إيقاف تجميد التطبيقات → أوقف تجميد التطبيق", "freeze"),
            InstructionStep("إشعار الخلفية", "الإعدادات → التطبيقات → سجّل الرحمة → الإشعارات → فعّل إشعار الخلفية", "notification"),
        )
        OemType.ONEPLUS -> listOf(
            InstructionStep("تفعيل التشغيل التلقائي", "الأمان → قائمة البداية → فعّل التطبيق", "power"),
            InstructionStep("لا تحسين البطارية", "البطارية → استهلاك البطارية → اختر التطبيق → لا تحسين", "battery"),
            InstructionStep("تشغيل في الخلفية", "الإعدادات → التطبيقات → سجّل الرحمة → تشغيل في الخلفية", "background"),
            InstructionStep("إشعار الخلفية", "الإعدادات → التطبيقات → سجّل الرحمة → الإشعارات → فعّل إشعار الخلفية", "notification"),
        )
        OemType.HUAWEI -> listOf(
            InstructionStep("إطلاق يدوي", "الأمان → قائمة البداية → سجّل الرحمة → إعداد يدوي", "power"),
            InstructionStep("إطلاق تلقائي", "الأمان → قائمة البداية → فعّل \"إطلاق تلقائي\"", "power"),
            InstructionStep("إطلاق ثانوي", "الأمان → قائمة البداية → فعّل \"إطلاق ثانوي\"", "power"),
            InstructionStep("تشغيل في الخلفية", "الأمان → قائمة البداية → فعّl \"تشغيل في الخلفية\"", "background"),
        )
        OemType.HONOR -> listOf(
            InstructionStep("إطلاق يدوي", "الأمان → قائمة البداية → سجّل الرحمة → إعداد يدوي", "power"),
            InstructionStep("إطلاق تلقائي", "الأمان → قائمة البداية → فعّل \"إطلاق تلقائي\"", "power"),
            InstructionStep("إطلاق ثانوي", "الأمان → قائمة البداية → فعّل \"إطلاق ثانوي\"", "power"),
            InstructionStep("تشغيل في الخلفية", "الأمان → قائمة البداية → فعّl \"تشغيل في الخلفية\"", "background"),
        )
        OemType.HARMONY_OS -> listOf(
            InstructionStep("إدارة التطبيق يدوياً", "الأمان → إدارة التطبيقات → سجّل الرحمة → إدارة يدوية", "power"),
            InstructionStep("إطلاق تلقائي", "الأمان → إدارة التطبيقات → فعّل \"إطلاق تلقائي\"", "power"),
            InstructionStep("تشغيل في الخلفية", "الأمان → إدارة التطبيقات → فعّل \"تشغيل في الخلفية\"", "background"),
            InstructionStep("إشعار الخلفية", "الإعدادات → الإشعارات → سجّل الرحمة → فعّل إشعار الخلفية", "notification"),
        )
        OemType.GENERIC -> listOf(
            InstructionStep("إعدادات البطارية", "الإعدادات → البطارية → استهلاك البطارية → ابحث عن التطبيق", "battery"),
            InstructionStep("إباحة التشغيل في الخلفية", "اختر \"غير مقيد\" أو \"التشغيل في الخلفية\"", "background"),
            InstructionStep("إشعار الخلفية", "الإعدادات → الإشعارات → فعّل إشعار الخلفية", "notification"),
        )
    }

    private fun buildInstructionsSummary(oemType: OemType, displayName: String): String {
        return when (oemType) {
            OemType.VIVO, OemType.IQOO -> "$displayName تمنع تشغيل التطبيقات في الخلفية افتراضياً. يجب تفعيل التشغيل التلقائي + إباحة الخلفية + قفل في التطبيقات الأخيرة."
            OemType.XIAOMI, OemType.REDMI, OemType.POCO -> "أجهزة MIUI/澎湃OS تحد من الخلفية بشكل كبير. يجب تفعيل التشغيل التلقائي + لا تقييد البطارية + إباحة الخلفية."
            OemType.OPPO, OemType.REALME -> "$displayName تجمّد التطبيقات في الخلفية. يجب تفعيل قائمة البداية + إيقاف التجميد + إشعار الخلفية."
            OemType.ONEPLUS -> "OnePlus قد يحد من الخلفية. يجب تفعيل التشغيل التلقائي + لا تحسين البطارية + تشغيل الخلفية."
            OemType.HUAWEI -> "Huawei تحد من الخلفية بشكل كبير. يجب تفعيل الإطلاق التلقائي + الإطلاق الثانوي + التشغيل في الخلفية."
            OemType.HONOR -> "Honor تحد من الخلفية بشكل كبير. يجب تفعيل الإطلاق التلقائي + الإطلاق الثانوي + التشغيل في الخلفية."
            OemType.HARMONY_OS -> "أجهزة HarmonyOS تحد من تشغيل التطبيقات في الخلفية. يجب إدارة التطبيق يدوياً + تفعيل الإطلاق التلقائي."
            OemType.GENERIC -> "افتح إعدادات البطارية وابحث عن التطبيق لضمان تشغيله في الخلفية."
        }
    }
}

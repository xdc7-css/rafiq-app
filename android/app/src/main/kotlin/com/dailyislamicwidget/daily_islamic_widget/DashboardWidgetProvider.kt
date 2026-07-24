package com.dailyislamicwidget.daily_islamic_widget

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.os.Process
import android.widget.RemoteViews
import android.util.Log
import com.dailyislamicwidget.daily_islamic_widget.WidgetPreferences.getStringOr
import com.dailyislamicwidget.daily_islamic_widget.WidgetPreferences.getIntOr
import com.dailyislamicwidget.daily_islamic_widget.WidgetPreferences.textColor

class DashboardWidgetProvider : AppWidgetProvider() {

    companion object {
        private const val TAG = "WIDGET_FORENSICS"

        fun updateAllWidgets(context: Context) {
            try {
                val component = ComponentName(context, DashboardWidgetProvider::class.java)
                val intent = Intent(context, DashboardWidgetProvider::class.java).apply {
                    action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
                }
                val manager = AppWidgetManager.getInstance(context)
                val ids = manager.getAppWidgetIds(component)
                Log.d(TAG, "[DASH] updateAllWidgets: component=$component, ids=${ids.toList()}, count=${ids.size}")
                if (ids.isNotEmpty()) {
                    intent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, ids)
                    context.sendBroadcast(intent)
                    Log.d(TAG, "[DASH] updateAllWidgets: broadcast SENT for ${ids.size} widget(s)")
                } else {
                    Log.d(TAG, "[DASH] updateAllWidgets: NO widget instances registered")
                }
            } catch (e: Exception) {
                Log.e(TAG, "[DASH] updateAllWidgets: EXCEPTION", e)
            }
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        Log.d(TAG, "[DASH] onReceive: action=${intent.action}, extras=${intent.extras}, pid=${Process.myPid()}")
        super.onReceive(context, intent)
    }

    override fun onEnabled(context: Context) {
        Log.d(TAG, "[DASH] onEnabled: FIRST instance added, class=${this::class.java.name}, packageName=${context.packageName}, pid=${Process.myPid()}")
    }

    override fun onDisabled(context: Context) {
        Log.d(TAG, "[DASH] onDisabled: LAST instance removed, class=${this::class.java.name}")
    }

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        Log.d(TAG, "[DASH] onUpdate: class=${this::class.java.name}, providerComponent=${ComponentName(context, DashboardWidgetProvider::class.java)}, widgetCount=${appWidgetIds.size}, widgetIds=${appWidgetIds.toList()}")
        for (appWidgetId in appWidgetIds) {
            updateWidget(context, appWidgetManager, appWidgetId)
        }
        Log.d(TAG, "[DASH] onUpdate: ALL ${appWidgetIds.size} widget(s) processed")
    }

    private fun updateWidget(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int
    ) {
        Log.d(TAG, "[DASH] updateWidget START: appWidgetId=$appWidgetId")
        var views: RemoteViews? = null

        try {
            val layoutResId = R.layout.widget_dashboard_4x4
            Log.d(TAG, "[DASH] $appWidgetId: Creating RemoteViews, pkg=${context.packageName}, layoutResId=$layoutResId, layoutName=${context.resources.getResourceEntryName(layoutResId)}")
            views = RemoteViews(context.packageName, layoutResId)
            Log.d(TAG, "[DASH] $appWidgetId: RemoteViews CREATED OK")

            val prefs = WidgetPreferences.obtain(context)
            val allKeys = prefs.all.keys.toList()
            Log.d(TAG, "[DASH] $appWidgetId: SharedPreferences empty=${allKeys.isEmpty()}, keyCount=${allKeys.size}")

            try {
                val hijriDate = prefs.getStringOr(WidgetKeys.HIJRI_DATE, "")
                Log.d(TAG, "[DASH] $appWidgetId: setTextViewText widget_hijri_date → $hijriDate")
                views.setTextViewText(R.id.widget_hijri_date, hijriDate)

                val fajrTime = prefs.getStringOr(WidgetKeys.FAJR_TIME, "--:--")
                val dhuhrTime = prefs.getStringOr(WidgetKeys.DHUHR_TIME, "--:--")
                val asrTime = prefs.getStringOr(WidgetKeys.ASR_TIME, "--:--")
                val maghribTime = prefs.getStringOr(WidgetKeys.MAGHRIB_TIME, "--:--")
                val ishaTime = prefs.getStringOr(WidgetKeys.ISHA_TIME, "--:--")

                Log.d(TAG, "[DASH] $appWidgetId: DATA fajr=$fajrTime, dhuhr=$dhuhrTime, asr=$asrTime, maghrib=$maghribTime, isha=$ishaTime")

                views.setTextViewText(R.id.widget_fajr_time, fajrTime)
                views.setTextViewText(R.id.widget_dhuhr_time, dhuhrTime)
                views.setTextViewText(R.id.widget_asr_time, asrTime)
                views.setTextViewText(R.id.widget_maghrib_time, maghribTime)
                views.setTextViewText(R.id.widget_isha_time, ishaTime)

                val quranSurah = prefs.getStringOr(WidgetKeys.QURAN_SURAH_NAME, "")
                val quranAyah = prefs.getIntOr(WidgetKeys.QURAN_AYAH, 1)
                val quranProgress = prefs.getIntOr(WidgetKeys.QURAN_PROGRESS, 0)
                val quranText = if (quranSurah.isNotEmpty()) {
                    "$quranSurah - الآية $quranAyah"
                } else {
                    "ابدأ القراءة"
                }
                Log.d(TAG, "[DASH] $appWidgetId: setTextViewText widget_quran_info → $quranText")
                views.setTextViewText(R.id.widget_quran_info, quranText)
                Log.d(TAG, "[DASH] $appWidgetId: setProgressBar widget_quran_progress → $quranProgress/100")
                views.setProgressBar(R.id.widget_quran_progress, 100, quranProgress, false)

                val tasbihName = prefs.getStringOr(WidgetKeys.TASBIH_NAME, "سبحان الله")
                val tasbihCount = prefs.getIntOr(WidgetKeys.TASBIH_COUNT, 0)
                val tasbihTarget = prefs.getIntOr(WidgetKeys.TASBIH_TARGET, 33)
                val tasbihId = prefs.getStringOr(WidgetKeys.TASBIH_ID, "")

                Log.d(TAG, "[DASH] $appWidgetId: setTextViewText widget_tasbih_name → $tasbihName")
                views.setTextViewText(R.id.widget_tasbih_name, tasbihName)
                Log.d(TAG, "[DASH] $appWidgetId: setTextViewText widget_tasbih_count → $tasbihCount / $tasbihTarget")
                views.setTextViewText(R.id.widget_tasbih_count, "$tasbihCount / $tasbihTarget")

                Log.d(TAG, "[DASH] $appWidgetId: DATA hijri=$hijriDate, quran=$quranText, tasbih=$tasbihName $tasbihCount/$tasbihTarget, id=$tasbihId")

                val textCol = prefs.textColor()
                Log.d(TAG, "[DASH] $appWidgetId: textColor=0x${Integer.toHexString(textCol)}")
                views.setTextColor(R.id.widget_hijri_date, textCol)
                views.setTextColor(R.id.widget_fajr_label, textCol)
                views.setTextColor(R.id.widget_fajr_time, textCol)
                views.setTextColor(R.id.widget_dhuhr_label, textCol)
                views.setTextColor(R.id.widget_dhuhr_time, textCol)
                views.setTextColor(R.id.widget_asr_label, textCol)
                views.setTextColor(R.id.widget_asr_time, textCol)
                views.setTextColor(R.id.widget_maghrib_label, textCol)
                views.setTextColor(R.id.widget_maghrib_time, textCol)
                views.setTextColor(R.id.widget_isha_label, textCol)
                views.setTextColor(R.id.widget_isha_time, textCol)
                views.setTextColor(R.id.widget_quran_info, textCol)
                views.setTextColor(R.id.widget_tasbih_name, 0xFFD8B56A.toInt())
                views.setTextColor(R.id.widget_tasbih_count, textCol)
                Log.d(TAG, "[DASH] $appWidgetId: setTextColor SUCCEEDED")

                val incrementIntent = Intent(context, WidgetActionReceiver::class.java).apply {
                    action = WidgetActionReceiver.ACTION_TASBIH_INCREMENT
                    putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
                    putExtra("tasbih_id", tasbihId)
                }
                val incrementPending = PendingIntent.getBroadcast(
                    context, appWidgetId + 5000, incrementIntent,
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                )
                Log.d(TAG, "[DASH] $appWidgetId: increment PendingIntent SUCCEEDED, requestCode=${appWidgetId + 5000}")
                views.setOnClickPendingIntent(R.id.widget_btn_increment, incrementPending)

                val resetIntent = Intent(context, WidgetActionReceiver::class.java).apply {
                    action = WidgetActionReceiver.ACTION_TASBIH_RESET
                    putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
                    putExtra("tasbih_id", tasbihId)
                }
                val resetPending = PendingIntent.getBroadcast(
                    context, appWidgetId + 6000, resetIntent,
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                )
                Log.d(TAG, "[DASH] $appWidgetId: reset PendingIntent SUCCEEDED, requestCode=${appWidgetId + 6000}")
                views.setOnClickPendingIntent(R.id.widget_btn_reset, resetPending)
                Log.d(TAG, "[DASH] $appWidgetId: setOnClickPendingIntent SUCCEEDED")
            } catch (e: Exception) {
                Log.e(TAG, "[DASH] $appWidgetId: EXCEPTION setting dashboard data", e)
            }

            try {
                val openAppIntent = context.packageManager.getLaunchIntentForPackage(context.packageName)
                Log.d(TAG, "[DASH] $appWidgetId: getLaunchIntentForPackage = ${openAppIntent != null}")
                if (openAppIntent != null) {
                    openAppIntent.flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
                    val pendingIntent = PendingIntent.getActivity(
                        context, appWidgetId + 7000, openAppIntent,
                        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                    )
                    Log.d(TAG, "[DASH] $appWidgetId: click PendingIntent SUCCEEDED, requestCode=${appWidgetId + 7000}")
                    views.setOnClickPendingIntent(R.id.widget_container, pendingIntent)
                    Log.d(TAG, "[DASH] $appWidgetId: setOnClickPendingIntent(click) SUCCEEDED")
                } else {
                    Log.w(TAG, "[DASH] $appWidgetId: getLaunchIntentForPackage returned NULL")
                }
            } catch (e: Exception) {
                Log.e(TAG, "[DASH] $appWidgetId: EXCEPTION setting click intent", e)
            }
        } catch (e: Exception) {
            Log.e(TAG, "[DASH] $appWidgetId: OUTER EXCEPTION — layout inflation failed", e)
            views = null
        }

        try {
            if (views != null) {
                Log.d(TAG, "[DASH] $appWidgetId: CALLING appWidgetManager.updateAppWidget($appWidgetId, views)")
                appWidgetManager.updateAppWidget(appWidgetId, views)
                Log.d(TAG, "[DASH] $appWidgetId: appWidgetManager.updateAppWidget RETURNED — SUCCESS")
            } else {
                Log.e(TAG, "[DASH] $appWidgetId: views is NULL — SKIPPING updateAppWidget")
            }
        } catch (e: Exception) {
            Log.e(TAG, "[DASH] $appWidgetId: EXCEPTION in appWidgetManager.updateAppWidget", e)
        }
        Log.d(TAG, "[DASH] updateWidget END: appWidgetId=$appWidgetId")
    }
}

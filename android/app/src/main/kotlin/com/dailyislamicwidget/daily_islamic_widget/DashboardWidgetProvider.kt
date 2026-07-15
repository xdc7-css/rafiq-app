package com.dailyislamicwidget.daily_islamic_widget

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import android.util.Log
import com.dailyislamicwidget.daily_islamic_widget.WidgetPreferences.getIntOr
import com.dailyislamicwidget.daily_islamic_widget.WidgetPreferences.getStringOr
import com.dailyislamicwidget.daily_islamic_widget.WidgetPreferences.textColor

class DashboardWidgetProvider : AppWidgetProvider() {

    companion object {
        private const val TAG = "DashboardWidget"

        fun updateAllWidgets(context: Context) {
            val intent = Intent(context, DashboardWidgetProvider::class.java).apply {
                action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
            }
            val manager = AppWidgetManager.getInstance(context)
            val ids = manager.getAppWidgetIds(
                ComponentName(context, DashboardWidgetProvider::class.java)
            )
            if (ids.isNotEmpty()) {
                intent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, ids)
                context.sendBroadcast(intent)
            }
        }
    }

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateWidget(context, appWidgetManager, appWidgetId)
        }
    }

    private fun updateWidget(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int
    ) {
        val prefs = WidgetPreferences.obtain(context)

        val views = RemoteViews(context.packageName, R.layout.widget_dashboard_4x4)

        // ─── Date ───
        val hijriDate = prefs.getStringOr(WidgetKeys.HIJRI_DATE)
        views.setTextViewText(R.id.widget_hijri_date, hijriDate)

        // ─── Prayer Times ───
        val fajrTime = prefs.getStringOr(WidgetKeys.FAJR_TIME, "--:--")
        val dhuhrTime = prefs.getStringOr(WidgetKeys.DHUHR_TIME, "--:--")
        val asrTime = prefs.getStringOr(WidgetKeys.ASR_TIME, "--:--")
        val maghribTime = prefs.getStringOr(WidgetKeys.MAGHRIB_TIME, "--:--")
        val ishaTime = prefs.getStringOr(WidgetKeys.ISHA_TIME, "--:--")

        views.setTextViewText(R.id.widget_fajr_time, fajrTime)
        views.setTextViewText(R.id.widget_dhuhr_time, dhuhrTime)
        views.setTextViewText(R.id.widget_asr_time, asrTime)
        views.setTextViewText(R.id.widget_maghrib_time, maghribTime)
        views.setTextViewText(R.id.widget_isha_time, ishaTime)

        // ─── Quran ───
        val quranSurah = prefs.getStringOr(WidgetKeys.QURAN_SURAH_NAME)
        val quranAyah = prefs.getIntOr(WidgetKeys.QURAN_AYAH, 1)
        val quranProgress = prefs.getIntOr(WidgetKeys.QURAN_PROGRESS, 0)
        val quranText = if (quranSurah.isNotEmpty()) {
            "$quranSurah - الآية $quranAyah"
        } else {
            "ابدأ القراءة"
        }
        views.setTextViewText(R.id.widget_quran_info, quranText)
        views.setProgressBar(R.id.widget_quran_progress, 100, quranProgress, false)

        // ─── Tasbih ───
        val tasbihName = prefs.getStringOr(WidgetKeys.TASBIH_NAME, "سبحان الله")
        val tasbihCount = prefs.getIntOr(WidgetKeys.TASBIH_COUNT, 0)
        val tasbihTarget = prefs.getIntOr(WidgetKeys.TASBIH_TARGET, 33)
        val tasbihId = prefs.getStringOr(WidgetKeys.TASBIH_ID)

        views.setTextViewText(R.id.widget_tasbih_name, tasbihName)
        views.setTextViewText(R.id.widget_tasbih_count, "$tasbihCount / $tasbihTarget")

        // ─── Colors ───
        val textColor = prefs.textColor()
        views.setTextColor(R.id.widget_hijri_date, textColor)
        views.setTextColor(R.id.widget_fajr_label, textColor)
        views.setTextColor(R.id.widget_fajr_time, textColor)
        views.setTextColor(R.id.widget_dhuhr_label, textColor)
        views.setTextColor(R.id.widget_dhuhr_time, textColor)
        views.setTextColor(R.id.widget_asr_label, textColor)
        views.setTextColor(R.id.widget_asr_time, textColor)
        views.setTextColor(R.id.widget_maghrib_label, textColor)
        views.setTextColor(R.id.widget_maghrib_time, textColor)
        views.setTextColor(R.id.widget_isha_label, textColor)
        views.setTextColor(R.id.widget_isha_time, textColor)
        views.setTextColor(R.id.widget_quran_info, textColor)
        views.setTextColor(R.id.widget_tasbih_name, 0xFFD8B56A.toInt())
        views.setTextColor(R.id.widget_tasbih_count, textColor)

        // ─── Increment Button ───
        val incrementIntent = Intent(context, WidgetActionReceiver::class.java).apply {
            action = WidgetActionReceiver.ACTION_TASBIH_INCREMENT
            putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
            putExtra("tasbih_id", tasbihId)
        }
        val incrementPending = PendingIntent.getBroadcast(
            context, appWidgetId + 5000, incrementIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        views.setOnClickPendingIntent(R.id.widget_btn_increment, incrementPending)

        // ─── Reset Button ───
        val resetIntent = Intent(context, WidgetActionReceiver::class.java).apply {
            action = WidgetActionReceiver.ACTION_TASBIH_RESET
            putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
            putExtra("tasbih_id", tasbihId)
        }
        val resetPending = PendingIntent.getBroadcast(
            context, appWidgetId + 6000, resetIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        views.setOnClickPendingIntent(R.id.widget_btn_reset, resetPending)

        // ─── Tap Container to Open App ───
        val openAppIntent = context.packageManager.getLaunchIntentForPackage(context.packageName)
        if (openAppIntent != null) {
            openAppIntent.flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            val pendingIntent = PendingIntent.getActivity(
                context, appWidgetId + 7000, openAppIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_container, pendingIntent)
        }

        appWidgetManager.updateAppWidget(appWidgetId, views)
    }

    override fun onEnabled(context: Context) {
        Log.i(TAG, "Dashboard widget instance added")
    }

    override fun onDisabled(context: Context) {
        Log.i(TAG, "Last Dashboard widget instance removed")
    }
}

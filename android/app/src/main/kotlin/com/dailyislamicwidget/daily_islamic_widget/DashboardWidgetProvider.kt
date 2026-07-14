package com.dailyislamicwidget.daily_islamic_widget

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import android.util.Log

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
        val prefs = context.getSharedPreferences(
            PrayerTimesWidgetProvider.PREFS_NAME, Context.MODE_PRIVATE
        )

        val views = RemoteViews(context.packageName, R.layout.widget_dashboard_4x4)

        // ─── Date ───
        val hijriDate = prefs.getString("widget_hijri_date", "") ?: ""
        val gregorianDate = prefs.getString("widget_gregorian_date", "") ?: ""
        views.setTextViewText(R.id.widget_hijri_date, hijriDate)

        // ─── Prayer Times ───
        val fajrTime = prefs.getString("widget_fajr_time", "--:--") ?: "--:--"
        val dhuhrTime = prefs.getString("widget_dhuhr_time", "--:--") ?: "--:--"
        val asrTime = prefs.getString("widget_asr_time", "--:--") ?: "--:--"
        val maghribTime = prefs.getString("widget_maghrib_time", "--:--") ?: "--:--"
        val ishaTime = prefs.getString("widget_isha_time", "--:--") ?: "--:--"

        views.setTextViewText(R.id.widget_fajr_time, fajrTime)
        views.setTextViewText(R.id.widget_dhuhr_time, dhuhrTime)
        views.setTextViewText(R.id.widget_asr_time, asrTime)
        views.setTextViewText(R.id.widget_maghrib_time, maghribTime)
        views.setTextViewText(R.id.widget_isha_time, ishaTime)

        // ─── Quran ───
        val quranSurah = prefs.getString("widget_quran_surah_name", "") ?: ""
        val quranAyah = prefs.getInt("widget_quran_ayah", 1)
        val quranProgress = prefs.getInt("widget_quran_progress", 0)
        val quranText = if (quranSurah.isNotEmpty()) {
            "$quranSurah - الآية $quranAyah"
        } else {
            "ابدأ القراءة"
        }
        views.setTextViewText(R.id.widget_quran_info, quranText)
        views.setProgressBar(R.id.widget_quran_progress, 100, quranProgress, false)

        // ─── Tasbih ───
        val tasbihName = prefs.getString("widget_tasbih_name", "سبحان الله") ?: "سبحان الله"
        val tasbihCount = prefs.getInt("widget_tasbih_count", 0)
        val tasbihTarget = prefs.getInt("widget_tasbih_target", 33)
        val tasbihId = prefs.getString("widget_tasbih_id", "") ?: ""

        views.setTextViewText(R.id.widget_tasbih_name, tasbihName)
        views.setTextViewText(R.id.widget_tasbih_count, "$tasbihCount / $tasbihTarget")

        // ─── Colors ───
        val textColor = prefs.getInt("widget_text_color", 0xFFF8F8F8.toInt())
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

package com.dailyislamicwidget.daily_islamic_widget

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.widget.RemoteViews
import android.util.Log

class PrayerTimesWidgetProvider : AppWidgetProvider() {

    companion object {
        private const val TAG = "PrayerWidget"
        const val PREFS_NAME = "HomeWidgetPreferences"

        fun updateAllWidgets(context: Context) {
            val intent = Intent(context, PrayerTimesWidgetProvider::class.java).apply {
                action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
            }
            val manager = AppWidgetManager.getInstance(context)
            val ids = manager.getAppWidgetIds(
                ComponentName(context, PrayerTimesWidgetProvider::class.java)
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
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)

        val views = RemoteViews(context.packageName, R.layout.widget_prayer_4x2)

        val nextPrayer = prefs.getString("widget_next_prayer", "الصلاة") ?: "الصلاة"
        val nextTime = prefs.getString("widget_next_time", "--:--") ?: "--:--"
        val countdown = prefs.getString("widget_countdown", "") ?: ""
        val fajrTime = prefs.getString("widget_fajr_time", "--:--") ?: "--:--"
        val dhuhrTime = prefs.getString("widget_dhuhr_time", "--:--") ?: "--:--"
        val asrTime = prefs.getString("widget_asr_time", "--:--") ?: "--:--"
        val maghribTime = prefs.getString("widget_maghrib_time", "--:--") ?: "--:--"
        val ishaTime = prefs.getString("widget_isha_time", "--:--") ?: "--:--"

        views.setTextViewText(R.id.widget_next_prayer_name, nextPrayer)
        views.setTextViewText(R.id.widget_next_prayer_time, nextTime)
        views.setTextViewText(R.id.widget_countdown, countdown)
        views.setTextViewText(R.id.widget_fajr_time, fajrTime)
        views.setTextViewText(R.id.widget_dhuhr_time, dhuhrTime)
        views.setTextViewText(R.id.widget_asr_time, asrTime)
        views.setTextViewText(R.id.widget_maghrib_time, maghribTime)
        views.setTextViewText(R.id.widget_isha_time, ishaTime)

        applyColors(context, prefs, views)

        val openAppIntent = context.packageManager.getLaunchIntentForPackage(context.packageName)
        if (openAppIntent != null) {
            openAppIntent.flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            val pendingIntent = PendingIntent.getActivity(
                context, appWidgetId, openAppIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_container, pendingIntent)
        }

        appWidgetManager.updateAppWidget(appWidgetId, views)
    }

    private fun applyColors(context: Context, prefs: SharedPreferences, views: RemoteViews) {
        val textColor = prefs.getInt("widget_text_color", 0xFFF8F8F8.toInt())
        val goldColor = 0xFFD8B56A.toInt()

        views.setTextColor(R.id.widget_next_prayer_name, textColor)
        views.setTextColor(R.id.widget_next_prayer_time, goldColor)
        views.setTextColor(R.id.widget_countdown, 0xFFC9A84C.toInt())
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
    }

    override fun onEnabled(context: Context) {
        Log.i(TAG, "Prayer widget instance added")
    }

    override fun onDisabled(context: Context) {
        Log.i(TAG, "Last prayer widget instance removed")
    }
}

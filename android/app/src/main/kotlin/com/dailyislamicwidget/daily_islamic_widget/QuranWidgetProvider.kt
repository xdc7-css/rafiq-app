package com.dailyislamicwidget.daily_islamic_widget

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import android.util.Log

class QuranWidgetProvider : AppWidgetProvider() {

    companion object {
        private const val TAG = "QuranWidget"

        fun updateAllWidgets(context: Context) {
            val intent = Intent(context, QuranWidgetProvider::class.java).apply {
                action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
            }
            val manager = AppWidgetManager.getInstance(context)
            val ids = manager.getAppWidgetIds(
                ComponentName(context, QuranWidgetProvider::class.java)
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

        val views = RemoteViews(context.packageName, R.layout.widget_quran_2x3)

        val surahName = prefs.getString("widget_quran_surah_name", "سورة الفاتحة") ?: "سورة الفاتحة"
        val ayah = prefs.getInt("widget_quran_ayah", 1)
        val page = prefs.getInt("widget_quran_page", 1)
        val totalPages = prefs.getInt("widget_quran_total_pages", 604)
        val progress = prefs.getInt("widget_quran_progress", 0)
        val hasKhatmah = prefs.getBoolean("widget_quran_has_khatmah", false)

        views.setTextViewText(R.id.widget_quran_surah_name, surahName)
        views.setTextViewText(R.id.widget_quran_ayah, "الآية $ayah")
        views.setTextViewText(R.id.widget_quran_page, "الصفحة $page / $totalPages")
        views.setProgressBar(R.id.widget_quran_progress, 100, progress, false)

        val textColor = prefs.getInt("widget_text_color", 0xFFF8F8F8.toInt())
        views.setTextColor(R.id.widget_quran_surah_name, textColor)
        views.setTextColor(R.id.widget_quran_ayah, textColor)
        views.setTextColor(R.id.widget_quran_page, 0x99F8F8F8.toInt())

        val openAppIntent = context.packageManager.getLaunchIntentForPackage(context.packageName)
        if (openAppIntent != null) {
            openAppIntent.flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            openAppIntent.putExtra("open_quran", true)
            val pendingIntent = PendingIntent.getActivity(
                context, appWidgetId + 1000, openAppIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_container, pendingIntent)
        }

        appWidgetManager.updateAppWidget(appWidgetId, views)
    }

    override fun onEnabled(context: Context) {
        Log.i(TAG, "Quran widget instance added")
    }

    override fun onDisabled(context: Context) {
        Log.i(TAG, "Last Quran widget instance removed")
    }
}

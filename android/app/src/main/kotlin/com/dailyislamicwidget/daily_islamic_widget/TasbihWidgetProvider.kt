package com.dailyislamicwidget.daily_islamic_widget

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import android.util.Log

class TasbihWidgetProvider : AppWidgetProvider() {

    companion object {
        private const val TAG = "TasbihWidget"

        fun updateAllWidgets(context: Context) {
            val intent = Intent(context, TasbihWidgetProvider::class.java).apply {
                action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
            }
            val manager = AppWidgetManager.getInstance(context)
            val ids = manager.getAppWidgetIds(
                ComponentName(context, TasbihWidgetProvider::class.java)
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

        val views = RemoteViews(context.packageName, R.layout.widget_tasbih_2x2)

        val tasbihName = prefs.getString("widget_tasbih_name", "سبحان الله") ?: "سبحان الله"
        val count = prefs.getInt("widget_tasbih_count", 0)
        val target = prefs.getInt("widget_tasbih_target", 33)
        val tasbihId = prefs.getString("widget_tasbih_id", "") ?: ""

        views.setTextViewText(R.id.widget_tasbih_name, tasbihName)
        views.setTextViewText(R.id.widget_tasbih_count, count.toString())
        views.setTextViewText(R.id.widget_tasbih_target, "/ $target")

        val textColor = prefs.getInt("widget_text_color", 0xFFF8F8F8.toInt())
        views.setTextColor(R.id.widget_tasbih_name, 0xFFD8B56A.toInt())
        views.setTextColor(R.id.widget_tasbih_count, textColor)
        views.setTextColor(R.id.widget_tasbih_target, 0x66F8F8F8.toInt())

        // Increment button
        val incrementIntent = Intent(context, WidgetActionReceiver::class.java).apply {
            action = WidgetActionReceiver.ACTION_TASBIH_INCREMENT
            putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
            putExtra("tasbih_id", tasbihId)
        }
        val incrementPending = PendingIntent.getBroadcast(
            context, appWidgetId + 2000, incrementIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        views.setOnClickPendingIntent(R.id.widget_btn_increment, incrementPending)

        // Reset button
        val resetIntent = Intent(context, WidgetActionReceiver::class.java).apply {
            action = WidgetActionReceiver.ACTION_TASBIH_RESET
            putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
            putExtra("tasbih_id", tasbihId)
        }
        val resetPending = PendingIntent.getBroadcast(
            context, appWidgetId + 3000, resetIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        views.setOnClickPendingIntent(R.id.widget_btn_reset, resetPending)

        // Tap container to open app
        val openAppIntent = context.packageManager.getLaunchIntentForPackage(context.packageName)
        if (openAppIntent != null) {
            openAppIntent.flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            openAppIntent.putExtra("open_tasbih", true)
            val pendingIntent = PendingIntent.getActivity(
                context, appWidgetId + 4000, openAppIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_container, pendingIntent)
        }

        appWidgetManager.updateAppWidget(appWidgetId, views)
    }

    override fun onEnabled(context: Context) {
        Log.i(TAG, "Tasbih widget instance added")
    }

    override fun onDisabled(context: Context) {
        Log.i(TAG, "Last Tasbih widget instance removed")
    }
}

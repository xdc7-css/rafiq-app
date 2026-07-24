package com.dailyislamicwidget.daily_islamic_widget

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.util.Log
import android.widget.RemoteViews

class DebugWidgetProvider : AppWidgetProvider() {

    companion object {
        private const val TAG = "WIDGET_FORENSICS"
    }

    override fun onEnabled(context: Context) {
        Log.d(TAG, "[DEBUG] onEnabled: class=${this::class.java.name}")
    }

    override fun onDisabled(context: Context) {
        Log.d(TAG, "[DEBUG] onDisabled: class=${this::class.java.name}")
    }

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        Log.d(TAG, "[DEBUG] onUpdate: count=${appWidgetIds.size}, ids=${appWidgetIds.toList()}")
        for (id in appWidgetIds) {
            try {
                Log.d(TAG, "[DEBUG] $id: Creating RemoteViews, layout=R.layout.widget_debug_2x1")
                val views = RemoteViews(context.packageName, R.layout.widget_debug_2x1)
                Log.d(TAG, "[DEBUG] $id: RemoteViews CREATED OK")
                Log.d(TAG, "[DEBUG] $id: Calling updateAppWidget...")
                appWidgetManager.updateAppWidget(id, views)
                Log.d(TAG, "[DEBUG] $id: updateAppWidget SUCCESS")
            } catch (e: Exception) {
                Log.e(TAG, "[DEBUG] $id: EXCEPTION", e)
            }
        }
    }
}

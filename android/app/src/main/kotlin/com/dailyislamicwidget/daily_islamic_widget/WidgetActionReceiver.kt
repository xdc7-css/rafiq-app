package com.dailyislamicwidget.daily_islamic_widget

import android.appwidget.AppWidgetManager
import android.content.BroadcastReceiver
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.util.Log
import com.dailyislamicwidget.daily_islamic_widget.WidgetPreferences.getIntOr

class WidgetActionReceiver : BroadcastReceiver() {

    companion object {
        private const val TAG = "WidgetActionReceiver"
        const val ACTION_TASBIH_INCREMENT = "com.dailyislamicwidget.action.TASBIH_INCREMENT"
        const val ACTION_TASBIH_RESET = "com.dailyislamicwidget.action.TASBIH_RESET"
        const val ACTION_NEXT_TASBIH = "com.dailyislamicwidget.action.NEXT_TASBIH"
    }

    override fun onReceive(context: Context, intent: Intent) {
        Log.i(TAG, "Received action: ${intent.action}")

        when (intent.action) {
            ACTION_TASBIH_INCREMENT -> handleTasbihIncrement(context, intent)
            ACTION_TASBIH_RESET -> handleTasbihReset(context, intent)
            ACTION_NEXT_TASBIH -> handleNextTasbih(context, intent)
        }
    }

    private fun handleTasbihIncrement(context: Context, intent: Intent) {
        val prefs = WidgetPreferences.obtain(context)
        val count = prefs.getIntOr(WidgetKeys.TASBIH_COUNT, 0)
        val target = prefs.getIntOr(WidgetKeys.TASBIH_TARGET, 33)

        val newCount = if (count >= target) 0 else count + 1

        prefs.edit().putInt(WidgetKeys.TASBIH_COUNT, newCount).apply()

        Log.i(TAG, "Tasbih incremented: $count -> $newCount (target: $target)")

        triggerWidgetUpdate(context)
    }

    private fun handleTasbihReset(context: Context, intent: Intent) {
        val prefs = WidgetPreferences.obtain(context)
        prefs.edit().putInt(WidgetKeys.TASBIH_COUNT, 0).apply()

        Log.i(TAG, "Tasbih reset to 0")

        triggerWidgetUpdate(context)
    }

    private fun handleNextTasbih(context: Context, intent: Intent) {
        val prefs = WidgetPreferences.obtain(context)
        val totalItems = prefs.getIntOr(WidgetKeys.TASBIH_TOTAL_ITEMS, 1)
        var currentIndex = prefs.getIntOr(WidgetKeys.TASBIH_INDEX, 0)

        currentIndex = (currentIndex + 1) % totalItems
        prefs.edit()
            .putInt(WidgetKeys.TASBIH_INDEX, currentIndex)
            .putInt(WidgetKeys.TASBIH_COUNT, 0)
            .apply()

        Log.i(TAG, "Next tasbih selected: index=$currentIndex")

        triggerWidgetUpdate(context)
    }

    private fun triggerWidgetUpdate(context: Context) {
        PrayerTimesWidgetProvider.updateAllWidgets(context)
        QuranWidgetProvider.updateAllWidgets(context)
        TasbihWidgetProvider.updateAllWidgets(context)
        DashboardWidgetProvider.updateAllWidgets(context)
    }
}

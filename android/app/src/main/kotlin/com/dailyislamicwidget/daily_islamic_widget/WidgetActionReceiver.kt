package com.dailyislamicwidget.daily_islamic_widget

import android.appwidget.AppWidgetManager
import android.content.BroadcastReceiver
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.os.Process
import android.util.Log
import com.dailyislamicwidget.daily_islamic_widget.WidgetPreferences.getIntOr

class WidgetActionReceiver : BroadcastReceiver() {

    companion object {
        private const val TAG = "WIDGET_FORENSICS"
        const val ACTION_TASBIH_INCREMENT = "com.dailyislamicwidget.action.TASBIH_INCREMENT"
        const val ACTION_TASBIH_RESET = "com.dailyislamicwidget.action.TASBIH_RESET"
        const val ACTION_NEXT_TASBIH = "com.dailyislamicwidget.action.NEXT_TASBIH"
    }

    override fun onReceive(context: Context, intent: Intent) {
        Log.d(TAG, "[ACTION] onReceive: action=${intent.action}, extras=${intent.extras}, component=${ComponentName(context, WidgetActionReceiver::class.java)}, pid=${Process.myPid()}")

        when (intent.action) {
            ACTION_TASBIH_INCREMENT -> handleTasbihIncrement(context, intent)
            ACTION_TASBIH_RESET -> handleTasbihReset(context, intent)
            ACTION_NEXT_TASBIH -> handleNextTasbih(context, intent)
            else -> Log.w(TAG, "[ACTION] onReceive: UNKNOWN action=${intent.action}")
        }
    }

    private fun handleTasbihIncrement(context: Context, intent: Intent) {
        Log.d(TAG, "[ACTION] handleTasbihIncrement: START")
        try {
            val prefs = WidgetPreferences.obtain(context)
            val count = prefs.getIntOr(WidgetKeys.TASBIH_COUNT, 0)
            val target = prefs.getIntOr(WidgetKeys.TASBIH_TARGET, 33)

            val newCount = if (count >= target) 0 else count + 1

            val writeResult = prefs.edit().putInt(WidgetKeys.TASBIH_COUNT, newCount).commit()
            Log.d(TAG, "[ACTION] handleTasbihIncrement: $count → $newCount (target=$target), commit=$writeResult")

            triggerWidgetUpdate(context)
            Log.d(TAG, "[ACTION] handleTasbihIncrement: END — triggerWidgetUpdate called")
        } catch (e: Exception) {
            Log.e(TAG, "[ACTION] handleTasbihIncrement: EXCEPTION", e)
        }
    }

    private fun handleTasbihReset(context: Context, intent: Intent) {
        Log.d(TAG, "[ACTION] handleTasbihReset: START")
        try {
            val prefs = WidgetPreferences.obtain(context)
            val writeResult = prefs.edit().putInt(WidgetKeys.TASBIH_COUNT, 0).commit()
            Log.d(TAG, "[ACTION] handleTasbihReset: reset to 0, commit=$writeResult")

            triggerWidgetUpdate(context)
            Log.d(TAG, "[ACTION] handleTasbihReset: END — triggerWidgetUpdate called")
        } catch (e: Exception) {
            Log.e(TAG, "[ACTION] handleTasbihReset: EXCEPTION", e)
        }
    }

    private fun handleNextTasbih(context: Context, intent: Intent) {
        Log.d(TAG, "[ACTION] handleNextTasbih: START")
        try {
            val prefs = WidgetPreferences.obtain(context)
            val totalItems = prefs.getIntOr(WidgetKeys.TASBIH_TOTAL_ITEMS, 1)
            var currentIndex = prefs.getIntOr(WidgetKeys.TASBIH_INDEX, 0)

            currentIndex = (currentIndex + 1) % totalItems
            val writeResult = prefs.edit()
                .putInt(WidgetKeys.TASBIH_INDEX, currentIndex)
                .putInt(WidgetKeys.TASBIH_COUNT, 0)
                .commit()
            Log.d(TAG, "[ACTION] handleNextTasbih: index → $currentIndex, count → 0, commit=$writeResult")

            triggerWidgetUpdate(context)
            Log.d(TAG, "[ACTION] handleNextTasbih: END — triggerWidgetUpdate called")
        } catch (e: Exception) {
            Log.e(TAG, "[ACTION] handleNextTasbih: EXCEPTION", e)
        }
    }

    private fun triggerWidgetUpdate(context: Context) {
        Log.d(TAG, "[ACTION] triggerWidgetUpdate: broadcasting to ALL 4 providers")
        try {
            PrayerTimesWidgetProvider.updateAllWidgets(context)
            Log.d(TAG, "[ACTION] triggerWidgetUpdate: PrayerTimesWidgetProvider done")
        } catch (e: Exception) {
            Log.e(TAG, "[ACTION] triggerWidgetUpdate: PrayerTimesWidgetProvider FAILED", e)
        }
        try {
            QuranWidgetProvider.updateAllWidgets(context)
            Log.d(TAG, "[ACTION] triggerWidgetUpdate: QuranWidgetProvider done")
        } catch (e: Exception) {
            Log.e(TAG, "[ACTION] triggerWidgetUpdate: QuranWidgetProvider FAILED", e)
        }
        try {
            TasbihWidgetProvider.updateAllWidgets(context)
            Log.d(TAG, "[ACTION] triggerWidgetUpdate: TasbihWidgetProvider done")
        } catch (e: Exception) {
            Log.e(TAG, "[ACTION] triggerWidgetUpdate: TasbihWidgetProvider FAILED", e)
        }
        try {
            DashboardWidgetProvider.updateAllWidgets(context)
            Log.d(TAG, "[ACTION] triggerWidgetUpdate: DashboardWidgetProvider done")
        } catch (e: Exception) {
            Log.e(TAG, "[ACTION] triggerWidgetUpdate: DashboardWidgetProvider FAILED", e)
        }
        Log.d(TAG, "[ACTION] triggerWidgetUpdate: ALL providers done")
    }
}

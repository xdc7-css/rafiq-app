package com.dailyislamicwidget.daily_islamic_widget

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.os.Process
import android.widget.RemoteViews
import android.util.Log
import com.dailyislamicwidget.daily_islamic_widget.WidgetPreferences.bgColor
import com.dailyislamicwidget.daily_islamic_widget.WidgetPreferences.getStringOr
import com.dailyislamicwidget.daily_islamic_widget.WidgetPreferences.getIntOr
import com.dailyislamicwidget.daily_islamic_widget.WidgetPreferences.textColor

class PrayerTimesWidgetProvider : AppWidgetProvider() {

    companion object {
        private const val TAG = "WIDGET_FORENSICS"

        fun updateAllWidgets(context: Context) {
            try {
                val component = ComponentName(context, PrayerTimesWidgetProvider::class.java)
                val intent = Intent(context, PrayerTimesWidgetProvider::class.java).apply {
                    action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
                }
                val manager = AppWidgetManager.getInstance(context)
                val ids = manager.getAppWidgetIds(component)
                Log.d(TAG, "[PRAYER] updateAllWidgets: component=$component, ids=${ids.toList()}, count=${ids.size}")
                if (ids.isNotEmpty()) {
                    intent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, ids)
                    context.sendBroadcast(intent)
                    Log.d(TAG, "[PRAYER] updateAllWidgets: broadcast SENT for ${ids.size} widget(s)")
                } else {
                    Log.d(TAG, "[PRAYER] updateAllWidgets: NO widget instances registered")
                }
            } catch (e: Exception) {
                Log.e(TAG, "[PRAYER] updateAllWidgets: EXCEPTION", e)
            }
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        Log.d(TAG, "[PRAYER] onReceive: action=${intent.action}, extras=${intent.extras}, pid=${Process.myPid()}, tid=${Process.myTid()}")
        super.onReceive(context, intent)
    }

    override fun onEnabled(context: Context) {
        Log.d(TAG, "[PRAYER] onEnabled: FIRST instance added, class=${this::class.java.name}, packageName=${context.packageName}, pid=${Process.myPid()}")
    }

    override fun onDisabled(context: Context) {
        Log.d(TAG, "[PRAYER] onDisabled: LAST instance removed, class=${this::class.java.name}")
    }

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        Log.d(TAG, "[PRAYER] onUpdate: class=${this::class.java.name}, providerComponent=${ComponentName(context, PrayerTimesWidgetProvider::class.java)}, widgetCount=${appWidgetIds.size}, widgetIds=${appWidgetIds.toList()}, packageName=${context.packageName}")
        for (appWidgetId in appWidgetIds) {
            updateWidget(context, appWidgetManager, appWidgetId)
        }
        Log.d(TAG, "[PRAYER] onUpdate: ALL ${appWidgetIds.size} widget(s) processed")
    }

    private fun updateWidget(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int
    ) {
        Log.d(TAG, "[PRAYER] updateWidget START: appWidgetId=$appWidgetId, contextPkg=${context.packageName}")
        var views: RemoteViews? = null

        try {
            val layoutResId = R.layout.widget_prayer_4x2
            Log.d(TAG, "[PRAYER] $appWidgetId: Creating RemoteViews, pkg=${context.packageName}, layoutResId=$layoutResId, layoutName=${context.resources.getResourceEntryName(layoutResId)}")
            views = RemoteViews(context.packageName, layoutResId)
            Log.d(TAG, "[PRAYER] $appWidgetId: RemoteViews CREATED OK, class=${views.javaClass.name}")

            val prefs = WidgetPreferences.obtain(context)
            val allKeys = prefs.all.keys.toList()
            val prefsEmpty = allKeys.isEmpty()
            Log.d(TAG, "[PRAYER] $appWidgetId: SharedPreferences file=${WidgetKeys.PREFS_NAME}, empty=$prefsEmpty, keyCount=${allKeys.size}, keys=$allKeys")

            try {
                val nextPrayer = prefs.getStringOr(WidgetKeys.NEXT_PRAYER_NAME, "الصلاة")
                val nextTime = prefs.getStringOr(WidgetKeys.NEXT_PRAYER_TIME, "--:--")
                val countdown = prefs.getStringOr(WidgetKeys.COUNTDOWN, "")
                val fajrTime = prefs.getStringOr(WidgetKeys.FAJR_TIME, "--:--")
                val dhuhrTime = prefs.getStringOr(WidgetKeys.DHUHR_TIME, "--:--")
                val asrTime = prefs.getStringOr(WidgetKeys.ASR_TIME, "--:--")
                val maghribTime = prefs.getStringOr(WidgetKeys.MAGHRIB_TIME, "--:--")
                val ishaTime = prefs.getStringOr(WidgetKeys.ISHA_TIME, "--:--")

                Log.d(TAG, "[PRAYER] $appWidgetId: DATA next=$nextPrayer/$nextTime, fajr=$fajrTime, dhuhr=$dhuhrTime, asr=$asrTime, maghrib=$maghribTime, isha=$ishaTime, countdown=$countdown")

                Log.d(TAG, "[PRAYER] $appWidgetId: setTextViewText widget_next_prayer_name → $nextPrayer")
                views.setTextViewText(R.id.widget_next_prayer_name, nextPrayer)
                Log.d(TAG, "[PRAYER] $appWidgetId: setTextViewText widget_next_prayer_time → $nextTime")
                views.setTextViewText(R.id.widget_next_prayer_time, nextTime)
                Log.d(TAG, "[PRAYER] $appWidgetId: setTextViewText widget_countdown → $countdown")
                views.setTextViewText(R.id.widget_countdown, countdown)
                Log.d(TAG, "[PRAYER] $appWidgetId: setTextViewText widget_fajr_time → $fajrTime")
                views.setTextViewText(R.id.widget_fajr_time, fajrTime)
                Log.d(TAG, "[PRAYER] $appWidgetId: setTextViewText widget_dhuhr_time → $dhuhrTime")
                views.setTextViewText(R.id.widget_dhuhr_time, dhuhrTime)
                Log.d(TAG, "[PRAYER] $appWidgetId: setTextViewText widget_asr_time → $asrTime")
                views.setTextViewText(R.id.widget_asr_time, asrTime)
                Log.d(TAG, "[PRAYER] $appWidgetId: setTextViewText widget_maghrib_time → $maghribTime")
                views.setTextViewText(R.id.widget_maghrib_time, maghribTime)
                Log.d(TAG, "[PRAYER] $appWidgetId: setTextViewText widget_isha_time → $ishaTime")
                views.setTextViewText(R.id.widget_isha_time, ishaTime)
                Log.d(TAG, "[PRAYER] $appWidgetId: All setTextViewText calls SUCCEEDED")
            } catch (e: Exception) {
                Log.e(TAG, "[PRAYER] $appWidgetId: EXCEPTION setting prayer data", e)
            }

            try {
                applyColors(prefs, views)
                Log.d(TAG, "[PRAYER] $appWidgetId: applyColors SUCCEEDED")
            } catch (e: Exception) {
                Log.e(TAG, "[PRAYER] $appWidgetId: EXCEPTION applying colors", e)
            }

            try {
                val openAppIntent = context.packageManager.getLaunchIntentForPackage(context.packageName)
                Log.d(TAG, "[PRAYER] $appWidgetId: getLaunchIntentForPackage(${context.packageName}) = ${openAppIntent != null}")
                if (openAppIntent != null) {
                    openAppIntent.flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
                    val pendingIntent = PendingIntent.getActivity(
                        context, appWidgetId, openAppIntent,
                        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                    )
                    Log.d(TAG, "[PRAYER] $appWidgetId: PendingIntent.getActivity SUCCEEDED, pendingIntent=$pendingIntent, viewId=R.id.widget_container")
                    views.setOnClickPendingIntent(R.id.widget_container, pendingIntent)
                    Log.d(TAG, "[PRAYER] $appWidgetId: setOnClickPendingIntent SUCCEEDED")
                } else {
                    Log.w(TAG, "[PRAYER] $appWidgetId: getLaunchIntentForPackage returned NULL — no click handler set")
                }
            } catch (e: Exception) {
                Log.e(TAG, "[PRAYER] $appWidgetId: EXCEPTION setting click intent", e)
            }
        } catch (e: Exception) {
            Log.e(TAG, "[PRAYER] $appWidgetId: OUTER EXCEPTION — layout inflation or view creation failed", e)
            views = null
        }

        try {
            if (views != null) {
                Log.d(TAG, "[PRAYER] $appWidgetId: CALLING appWidgetManager.updateAppWidget($appWidgetId, views)")
                appWidgetManager.updateAppWidget(appWidgetId, views)
                Log.d(TAG, "[PRAYER] $appWidgetId: appWidgetManager.updateAppWidget RETURNED — SUCCESS")
            } else {
                Log.e(TAG, "[PRAYER] $appWidgetId: views is NULL — SKIPPING updateAppWidget")
            }
        } catch (e: Exception) {
            Log.e(TAG, "[PRAYER] $appWidgetId: EXCEPTION in appWidgetManager.updateAppWidget", e)
        }
        Log.d(TAG, "[PRAYER] updateWidget END: appWidgetId=$appWidgetId")
    }

    private fun applyColors(prefs: SharedPreferences, views: RemoteViews) {
        val textCol = prefs.textColor()
        val bgCol = prefs.bgColor()
        val goldColor = 0xFFD8B56A.toInt()

        Log.d(TAG, "[PRAYER] applyColors: textCol=0x${Integer.toHexString(textCol)}, bgCol=0x${Integer.toHexString(bgCol)}, gold=0x${Integer.toHexString(goldColor)}")

        views.setTextColor(R.id.widget_next_prayer_name, textCol)
        views.setTextColor(R.id.widget_next_prayer_time, goldColor)
        views.setTextColor(R.id.widget_countdown, 0xFFC9A84C.toInt())
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
    }
}

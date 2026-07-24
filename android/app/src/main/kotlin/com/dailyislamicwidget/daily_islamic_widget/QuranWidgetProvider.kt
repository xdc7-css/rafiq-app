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

class QuranWidgetProvider : AppWidgetProvider() {

    companion object {
        private const val TAG = "WIDGET_FORENSICS"

        fun updateAllWidgets(context: Context) {
            try {
                val component = ComponentName(context, QuranWidgetProvider::class.java)
                val intent = Intent(context, QuranWidgetProvider::class.java).apply {
                    action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
                }
                val manager = AppWidgetManager.getInstance(context)
                val ids = manager.getAppWidgetIds(component)
                Log.d(TAG, "[QURAN] updateAllWidgets: component=$component, ids=${ids.toList()}, count=${ids.size}")
                if (ids.isNotEmpty()) {
                    intent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, ids)
                    context.sendBroadcast(intent)
                    Log.d(TAG, "[QURAN] updateAllWidgets: broadcast SENT for ${ids.size} widget(s)")
                } else {
                    Log.d(TAG, "[QURAN] updateAllWidgets: NO widget instances registered")
                }
            } catch (e: Exception) {
                Log.e(TAG, "[QURAN] updateAllWidgets: EXCEPTION", e)
            }
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        Log.d(TAG, "[QURAN] onReceive: action=${intent.action}, extras=${intent.extras}, pid=${Process.myPid()}")
        super.onReceive(context, intent)
    }

    override fun onEnabled(context: Context) {
        Log.d(TAG, "[QURAN] onEnabled: FIRST instance added, class=${this::class.java.name}, packageName=${context.packageName}, pid=${Process.myPid()}")
    }

    override fun onDisabled(context: Context) {
        Log.d(TAG, "[QURAN] onDisabled: LAST instance removed, class=${this::class.java.name}")
    }

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        Log.d(TAG, "[QURAN] onUpdate: class=${this::class.java.name}, providerComponent=${ComponentName(context, QuranWidgetProvider::class.java)}, widgetCount=${appWidgetIds.size}, widgetIds=${appWidgetIds.toList()}")
        for (appWidgetId in appWidgetIds) {
            updateWidget(context, appWidgetManager, appWidgetId)
        }
        Log.d(TAG, "[QURAN] onUpdate: ALL ${appWidgetIds.size} widget(s) processed")
    }

    private fun updateWidget(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int
    ) {
        Log.d(TAG, "[QURAN] updateWidget START: appWidgetId=$appWidgetId")
        var views: RemoteViews? = null

        try {
            val layoutResId = R.layout.widget_quran_2x3
            Log.d(TAG, "[QURAN] $appWidgetId: Creating RemoteViews, pkg=${context.packageName}, layoutResId=$layoutResId, layoutName=${context.resources.getResourceEntryName(layoutResId)}")
            views = RemoteViews(context.packageName, layoutResId)
            Log.d(TAG, "[QURAN] $appWidgetId: RemoteViews CREATED OK")

            val prefs = WidgetPreferences.obtain(context)
            val allKeys = prefs.all.keys.toList()
            Log.d(TAG, "[QURAN] $appWidgetId: SharedPreferences empty=${allKeys.isEmpty()}, keyCount=${allKeys.size}")

            try {
                val surahName = prefs.getStringOr(WidgetKeys.QURAN_SURAH_NAME, "")
                val ayah = prefs.getIntOr(WidgetKeys.QURAN_AYAH, 1)
                val page = prefs.getIntOr(WidgetKeys.QURAN_PAGE, 1)
                val totalPages = prefs.getIntOr(WidgetKeys.QURAN_TOTAL_PAGES, 604)
                val progress = prefs.getIntOr(WidgetKeys.QURAN_PROGRESS, 0)

                Log.d(TAG, "[QURAN] $appWidgetId: DATA surah=$surahName, ayah=$ayah, page=$page/$totalPages, progress=$progress")

                val displayText = if (surahName.isNotEmpty()) {
                    "$surahName - الآية $ayah"
                } else {
                    "ابدأ القراءة"
                }
                Log.d(TAG, "[QURAN] $appWidgetId: setTextViewText widget_quran_surah_name → $displayText")
                views.setTextViewText(R.id.widget_quran_surah_name, displayText)
                Log.d(TAG, "[QURAN] $appWidgetId: setTextViewText widget_quran_ayah → الآية $ayah")
                views.setTextViewText(R.id.widget_quran_ayah, "الآية $ayah")
                Log.d(TAG, "[QURAN] $appWidgetId: setTextViewText widget_quran_page → الصفحة $page / $totalPages")
                views.setTextViewText(R.id.widget_quran_page, "الصفحة $page / $totalPages")
                Log.d(TAG, "[QURAN] $appWidgetId: setProgressBar widget_quran_progress → $progress/100")
                views.setProgressBar(R.id.widget_quran_progress, 100, progress, false)
                Log.d(TAG, "[QURAN] $appWidgetId: All setText/ProgressBar calls SUCCEEDED")
            } catch (e: Exception) {
                Log.e(TAG, "[QURAN] $appWidgetId: EXCEPTION setting quran data", e)
            }

            try {
                val textCol = prefs.textColor()
                Log.d(TAG, "[QURAN] $appWidgetId: textColor=0x${Integer.toHexString(textCol)}")
                views.setTextColor(R.id.widget_quran_surah_name, textCol)
                views.setTextColor(R.id.widget_quran_ayah, textCol)
                views.setTextColor(R.id.widget_quran_page, 0x99F8F8F8.toInt())
                Log.d(TAG, "[QURAN] $appWidgetId: setTextColor SUCCEEDED")
            } catch (e: Exception) {
                Log.e(TAG, "[QURAN] $appWidgetId: EXCEPTION applying quran colors", e)
            }

            try {
                val openAppIntent = context.packageManager.getLaunchIntentForPackage(context.packageName)
                Log.d(TAG, "[QURAN] $appWidgetId: getLaunchIntentForPackage = ${openAppIntent != null}")
                if (openAppIntent != null) {
                    openAppIntent.flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
                    openAppIntent.putExtra("open_quran", true)
                    val pendingIntent = PendingIntent.getActivity(
                        context, appWidgetId + 1000, openAppIntent,
                        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                    )
                    Log.d(TAG, "[QURAN] $appWidgetId: PendingIntent SUCCEEDED, requestCode=${appWidgetId + 1000}, pendingIntent=$pendingIntent")
                    views.setOnClickPendingIntent(R.id.widget_container, pendingIntent)
                    Log.d(TAG, "[QURAN] $appWidgetId: setOnClickPendingIntent SUCCEEDED")
                } else {
                    Log.w(TAG, "[QURAN] $appWidgetId: getLaunchIntentForPackage returned NULL")
                }
            } catch (e: Exception) {
                Log.e(TAG, "[QURAN] $appWidgetId: EXCEPTION setting click intent", e)
            }
        } catch (e: Exception) {
            Log.e(TAG, "[QURAN] $appWidgetId: OUTER EXCEPTION — layout inflation failed", e)
            views = null
        }

        try {
            if (views != null) {
                Log.d(TAG, "[QURAN] $appWidgetId: CALLING appWidgetManager.updateAppWidget($appWidgetId, views)")
                appWidgetManager.updateAppWidget(appWidgetId, views)
                Log.d(TAG, "[QURAN] $appWidgetId: appWidgetManager.updateAppWidget RETURNED — SUCCESS")
            } else {
                Log.e(TAG, "[QURAN] $appWidgetId: views is NULL — SKIPPING updateAppWidget")
            }
        } catch (e: Exception) {
            Log.e(TAG, "[QURAN] $appWidgetId: EXCEPTION in appWidgetManager.updateAppWidget", e)
        }
        Log.d(TAG, "[QURAN] updateWidget END: appWidgetId=$appWidgetId")
    }
}

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

class TasbihWidgetProvider : AppWidgetProvider() {

    companion object {
        private const val TAG = "WIDGET_FORENSICS"

        fun updateAllWidgets(context: Context) {
            try {
                val component = ComponentName(context, TasbihWidgetProvider::class.java)
                val intent = Intent(context, TasbihWidgetProvider::class.java).apply {
                    action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
                }
                val manager = AppWidgetManager.getInstance(context)
                val ids = manager.getAppWidgetIds(component)
                Log.d(TAG, "[TASBIH] updateAllWidgets: component=$component, ids=${ids.toList()}, count=${ids.size}")
                if (ids.isNotEmpty()) {
                    intent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, ids)
                    context.sendBroadcast(intent)
                    Log.d(TAG, "[TASBIH] updateAllWidgets: broadcast SENT for ${ids.size} widget(s)")
                } else {
                    Log.d(TAG, "[TASBIH] updateAllWidgets: NO widget instances registered")
                }
            } catch (e: Exception) {
                Log.e(TAG, "[TASBIH] updateAllWidgets: EXCEPTION", e)
            }
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        Log.d(TAG, "[TASBIH] onReceive: action=${intent.action}, extras=${intent.extras}, pid=${Process.myPid()}")
        super.onReceive(context, intent)
    }

    override fun onEnabled(context: Context) {
        Log.d(TAG, "[TASBIH] onEnabled: FIRST instance added, class=${this::class.java.name}, packageName=${context.packageName}, pid=${Process.myPid()}")
    }

    override fun onDisabled(context: Context) {
        Log.d(TAG, "[TASBIH] onDisabled: LAST instance removed, class=${this::class.java.name}")
    }

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        Log.d(TAG, "[TASBIH] onUpdate: class=${this::class.java.name}, providerComponent=${ComponentName(context, TasbihWidgetProvider::class.java)}, widgetCount=${appWidgetIds.size}, widgetIds=${appWidgetIds.toList()}")
        for (appWidgetId in appWidgetIds) {
            updateWidget(context, appWidgetManager, appWidgetId)
        }
        Log.d(TAG, "[TASBIH] onUpdate: ALL ${appWidgetIds.size} widget(s) processed")
    }

    private fun updateWidget(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int
    ) {
        Log.d(TAG, "[TASBIH] updateWidget START: appWidgetId=$appWidgetId")
        var views: RemoteViews? = null

        try {
            val layoutResId = R.layout.widget_tasbih_2x2
            Log.d(TAG, "[TASBIH] $appWidgetId: Creating RemoteViews, pkg=${context.packageName}, layoutResId=$layoutResId, layoutName=${context.resources.getResourceEntryName(layoutResId)}")
            views = RemoteViews(context.packageName, layoutResId)
            Log.d(TAG, "[TASBIH] $appWidgetId: RemoteViews CREATED OK")

            val prefs = WidgetPreferences.obtain(context)
            val allKeys = prefs.all.keys.toList()
            Log.d(TAG, "[TASBIH] $appWidgetId: SharedPreferences empty=${allKeys.isEmpty()}, keyCount=${allKeys.size}")

            try {
                val tasbihName = prefs.getStringOr(WidgetKeys.TASBIH_NAME, "سبحان الله")
                val count = prefs.getIntOr(WidgetKeys.TASBIH_COUNT, 0)
                val target = prefs.getIntOr(WidgetKeys.TASBIH_TARGET, 33)
                val tasbihId = prefs.getStringOr(WidgetKeys.TASBIH_ID, "")

                Log.d(TAG, "[TASBIH] $appWidgetId: DATA name=$tasbihName, count=$count, target=$target, id=$tasbihId")

                Log.d(TAG, "[TASBIH] $appWidgetId: setTextViewText widget_tasbih_name → $tasbihName")
                views.setTextViewText(R.id.widget_tasbih_name, tasbihName)
                Log.d(TAG, "[TASBIH] $appWidgetId: setTextViewText widget_tasbih_count → ${count.toString()}")
                views.setTextViewText(R.id.widget_tasbih_count, count.toString())
                Log.d(TAG, "[TASBIH] $appWidgetId: setTextViewText widget_tasbih_target → / $target")
                views.setTextViewText(R.id.widget_tasbih_target, "/ $target")

                val textCol = prefs.textColor()
                Log.d(TAG, "[TASBIH] $appWidgetId: textColor=0x${Integer.toHexString(textCol)}")
                views.setTextColor(R.id.widget_tasbih_name, 0xFFD8B56A.toInt())
                views.setTextColor(R.id.widget_tasbih_count, textCol)
                views.setTextColor(R.id.widget_tasbih_target, 0x66F8F8F8.toInt())
                Log.d(TAG, "[TASBIH] $appWidgetId: setTextColor SUCCEEDED")

                val incrementIntent = Intent(context, WidgetActionReceiver::class.java).apply {
                    action = WidgetActionReceiver.ACTION_TASBIH_INCREMENT
                    putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
                    putExtra("tasbih_id", tasbihId)
                }
                val incrementPending = PendingIntent.getBroadcast(
                    context, appWidgetId + 2000, incrementIntent,
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                )
                Log.d(TAG, "[TASBIH] $appWidgetId: increment PendingIntent SUCCEEDED, requestCode=${appWidgetId + 2000}")
                views.setOnClickPendingIntent(R.id.widget_btn_increment, incrementPending)
                Log.d(TAG, "[TASBIH] $appWidgetId: setOnClickPendingIntent(increment) SUCCEEDED")

                val resetIntent = Intent(context, WidgetActionReceiver::class.java).apply {
                    action = WidgetActionReceiver.ACTION_TASBIH_RESET
                    putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
                    putExtra("tasbih_id", tasbihId)
                }
                val resetPending = PendingIntent.getBroadcast(
                    context, appWidgetId + 3000, resetIntent,
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                )
                Log.d(TAG, "[TASBIH] $appWidgetId: reset PendingIntent SUCCEEDED, requestCode=${appWidgetId + 3000}")
                views.setOnClickPendingIntent(R.id.widget_btn_reset, resetPending)
                Log.d(TAG, "[TASBIH] $appWidgetId: setOnClickPendingIntent(reset) SUCCEEDED")
            } catch (e: Exception) {
                Log.e(TAG, "[TASBIH] $appWidgetId: EXCEPTION setting tasbih data", e)
            }

            try {
                val openAppIntent = context.packageManager.getLaunchIntentForPackage(context.packageName)
                Log.d(TAG, "[TASBIH] $appWidgetId: getLaunchIntentForPackage = ${openAppIntent != null}")
                if (openAppIntent != null) {
                    openAppIntent.flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
                    openAppIntent.putExtra("open_tasbih", true)
                    val pendingIntent = PendingIntent.getActivity(
                        context, appWidgetId + 4000, openAppIntent,
                        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                    )
                    Log.d(TAG, "[TASBIH] $appWidgetId: click PendingIntent SUCCEEDED, requestCode=${appWidgetId + 4000}")
                    views.setOnClickPendingIntent(R.id.widget_container, pendingIntent)
                    Log.d(TAG, "[TASBIH] $appWidgetId: setOnClickPendingIntent(click) SUCCEEDED")
                } else {
                    Log.w(TAG, "[TASBIH] $appWidgetId: getLaunchIntentForPackage returned NULL")
                }
            } catch (e: Exception) {
                Log.e(TAG, "[TASBIH] $appWidgetId: EXCEPTION setting click intent", e)
            }
        } catch (e: Exception) {
            Log.e(TAG, "[TASBIH] $appWidgetId: OUTER EXCEPTION — layout inflation failed", e)
            views = null
        }

        try {
            if (views != null) {
                Log.d(TAG, "[TASBIH] $appWidgetId: CALLING appWidgetManager.updateAppWidget($appWidgetId, views)")
                appWidgetManager.updateAppWidget(appWidgetId, views)
                Log.d(TAG, "[TASBIH] $appWidgetId: appWidgetManager.updateAppWidget RETURNED — SUCCESS")
            } else {
                Log.e(TAG, "[TASBIH] $appWidgetId: views is NULL — SKIPPING updateAppWidget")
            }
        } catch (e: Exception) {
            Log.e(TAG, "[TASBIH] $appWidgetId: EXCEPTION in appWidgetManager.updateAppWidget", e)
        }
        Log.d(TAG, "[TASBIH] updateWidget END: appWidgetId=$appWidgetId")
    }
}

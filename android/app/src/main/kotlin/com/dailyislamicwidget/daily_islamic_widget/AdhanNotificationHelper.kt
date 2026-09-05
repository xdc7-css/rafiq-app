package com.dailyislamicwidget.daily_islamic_widget

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.os.Build
import android.util.Log

/**
 * AdhanNotificationHelper — Centralized notification builder and channel manager.
 *
 * Ensures identical channel configuration across AdhanAlarmReceiver and AdhanForegroundService.
 * Guarantees that even if Android 12+ restricts foreground service start, a high-priority
 * notification with sound, vibration, and interactive action buttons is posted directly.
 */
object AdhanNotificationHelper {

    private const val TAG = "AdhanNotificationHelper"

    const val CHANNEL_ID = "adhan_playback_channel_v2"
    const val CHANNEL_NAME = "أذان الصلاة"
    const val CHANNEL_DESC = "تنبيهات وأصوات الأذان للصلوات الخمس"

    const val MISSED_CHANNEL_ID = "adhan_missed_channel"
    const val MISSED_CHANNEL_NAME = "تنبيهات الصلوات الفائتة"
    const val MISSED_CHANNEL_DESC = "تنبيهات عند فوات وقت الصلاة بسبب إيقاف الجهاز أو تأخر النظام"

    const val NOTIFICATION_ID = 9001
    const val MISSED_NOTIFICATION_ID = 9002

    fun ensureChannels(context: Context) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val nm = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

            // Main Adhan Channel (High Importance + Sound/Vibration + Public Lockscreen)
            val adhanChannel = NotificationChannel(
                CHANNEL_ID,
                CHANNEL_NAME,
                NotificationManager.IMPORTANCE_HIGH
            ).apply {
                description = CHANNEL_DESC
                enableLights(true)
                lightColor = Color.parseColor("#D4AF37") // Royal Gold
                enableVibration(true)
                vibrationPattern = longArrayOf(0, 500, 200, 500, 200, 500)
                lockscreenVisibility = Notification.VISIBILITY_PUBLIC
                setShowBadge(true)
                setBypassDnd(true)
            }
            nm.createNotificationChannel(adhanChannel)

            // Missed Prayer Channel (Default Importance, gentle)
            val missedChannel = NotificationChannel(
                MISSED_CHANNEL_ID,
                MISSED_CHANNEL_NAME,
                NotificationManager.IMPORTANCE_DEFAULT
            ).apply {
                description = MISSED_CHANNEL_DESC
                enableVibration(true)
                lockscreenVisibility = Notification.VISIBILITY_PUBLIC
                setShowBadge(true)
            }
            nm.createNotificationChannel(missedChannel)

            Log.i(TAG, "Notification channels verified and ensured")
        }
    }

    fun buildAdhanNotification(
        context: Context,
        prayerName: String,
        isTest: Boolean = false,
        isLate: Boolean = false
    ): Notification {
        ensureChannels(context)

        // Launch MainActivity intent
        val launchIntent = context.packageManager.getLaunchIntentForPackage(context.packageName)?.apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            putExtra("route", "/prayer-times")
        }
        val contentPendingIntent = PendingIntent.getActivity(
            context,
            1001,
            launchIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        // Stop Adhan Intent
        val stopIntent = Intent(context, AdhanForegroundService::class.java).apply {
            action = AdhanForegroundService.ACTION_STOP_ADHAN
        }
        val stopPendingIntent = PendingIntent.getService(
            context,
            1002,
            stopIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val title = if (isTest) {
            "اختبار تشغيل الأذان — رَفِيقْ"
        } else if (isLate) {
            "تنبيه: حان وقت صلاة $prayerName"
        } else {
            "حان وقت صلاة $prayerName"
        }

        val text = if (isTest) {
            "تم إطلاق منبه اختبار الأذان بنجاح عبر نظام التشغيل"
        } else if (isLate) {
            "دخل وقت صلاة $prayerName • اذكر الله واستعد للصلاة"
        } else {
            "حيّ على الصلاة • حيّ على الفلاح"
        }

        val builder = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Notification.Builder(context, CHANNEL_ID)
        } else {
            @Suppress("DEPRECATION")
            Notification.Builder(context)
        }

        val iconId = context.applicationInfo.icon.takeIf { it != 0 } ?: android.R.drawable.ic_lock_idle_alarm

        builder
            .setContentTitle(title)
            .setContentText(text)
            .setSmallIcon(iconId)
            .setContentIntent(contentPendingIntent)
            .setAutoCancel(true)
            .setOngoing(!isLate)
            .setPriority(Notification.PRIORITY_MAX)
            .setCategory(Notification.CATEGORY_ALARM)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            builder.setVisibility(Notification.VISIBILITY_PUBLIC)
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT_WATCH) {
            val stopAction = Notification.Action.Builder(
                android.R.drawable.ic_menu_close_clear_cancel,
                "إيقاف الأذان",
                stopPendingIntent
            ).build()
            builder.addAction(stopAction)
        }

        return builder.build()
    }

    fun buildMissedPrayerNotification(
        context: Context,
        prayerName: String,
        minutesLate: Long
    ): Notification {
        ensureChannels(context)

        val launchIntent = context.packageManager.getLaunchIntentForPackage(context.packageName)?.apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
        }
        val contentPendingIntent = PendingIntent.getActivity(
            context,
            1003,
            launchIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val iconId = context.applicationInfo.icon.takeIf { it != 0 } ?: android.R.drawable.ic_lock_idle_alarm

        val builder = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Notification.Builder(context, MISSED_CHANNEL_ID)
        } else {
            @Suppress("DEPRECATION")
            Notification.Builder(context)
        }

        builder
            .setContentTitle("صلاة $prayerName")
            .setContentText("دخل وقت صلاة $prayerName منذ $minutesLate دقيقة")
            .setSmallIcon(iconId)
            .setContentIntent(contentPendingIntent)
            .setAutoCancel(true)
            .setPriority(Notification.PRIORITY_DEFAULT)

        return builder.build()
    }

    fun postNotification(context: Context, id: Int, notification: Notification) {
        try {
            val nm = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            nm.notify(id, notification)
            Log.i(TAG, "Notification successfully posted: id=$id")
        } catch (e: Exception) {
            Log.e(TAG, "Failed to post notification: ${e.message}", e)
        }
    }

    fun cancelNotification(context: Context, id: Int) {
        try {
            val nm = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            nm.cancel(id)
            Log.i(TAG, "Notification cancelled: id=$id")
        } catch (e: Exception) {
            Log.e(TAG, "Failed to cancel notification: ${e.message}", e)
        }
    }
}

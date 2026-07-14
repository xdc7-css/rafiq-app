package com.dailyislamicwidget.daily_islamic_widget

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.media.AudioAttributes
import android.media.AudioFocusRequest
import android.media.AudioManager
import android.media.MediaPlayer
import android.media.MediaPlayer.OnCompletionListener
import android.media.MediaPlayer.OnErrorListener
import android.net.Uri
import android.os.Build
import android.os.IBinder
import android.os.PowerManager
import android.util.Log

class AdhanForegroundService : Service() {

    companion object {
        private const val TAG = "AdhanForegroundService"
        private const val NOTIFICATION_ID = 9001
        private const val CHANNEL_ID = "adhan_foreground_service"
        private const val CHANNEL_NAME = "أذان الصلاة"
        private const val CHANNEL_DESC = "تشغيل صوت الأذان مع الإشعار"

        const val ACTION_PLAY_ADHAN = "com.dailyislamicwidget.action.PLAY_ADHAN"
        const val ACTION_STOP_ADHAN = "com.dailyislamicwidget.action.STOP_ADHAN"
        const val ACTION_PLAY_TEST = "com.dailyislamicwidget.action.PLAY_TEST"
        const val ACTION_SNOOZE_ADHAN = "com.dailyislamicwidget.action.SNOOZE_ADHAN"
        const val EXTRA_PRAYER_NAME = "prayer_name"
        const val EXTRA_PRAYER_INDEX = "prayer_index"
        const val EXTRA_VOLUME = "volume"
        const val EXTRA_SOUND_NAME = "sound_name"
        const val EXTRA_RAW_RES_ID = "raw_res_id"
        const val EXTRA_SNOOZE_MINUTES = "snooze_minutes"
    }

    @Volatile private var mediaPlayer: MediaPlayer? = null
    @Volatile private var isPlaying = false
    private var audioManager: AudioManager? = null
    private var audioFocusRequest: AudioFocusRequest? = null
    @Volatile private var wakeLock: PowerManager.WakeLock? = null
    private var notificationManager: NotificationManager? = null
    @Volatile private var isForeground = false
    private var currentPrayerName: String = ""
    private var currentVolume: Float = 1.0f
    private var currentSoundName: String = "adhan_maitham"
    private var currentRawResId: Int = 0

    override fun onCreate() {
        super.onCreate()
        audioManager = getSystemService(Context.AUDIO_SERVICE) as AudioManager
        notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        createNotificationChannels()
        Log.i(TAG, "Service created")
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val action = intent?.action ?: return START_NOT_STICKY
        Log.i(TAG, "onStartCommand: $action (flags=$flags, startId=$startId)")

        when (action) {
            ACTION_PLAY_ADHAN -> {
                stopPlayback()
                currentPrayerName = intent.getStringExtra(EXTRA_PRAYER_NAME) ?: "صلاة"
                currentVolume = intent.getFloatExtra(EXTRA_VOLUME, 1.0f)
                currentSoundName = intent.getStringExtra(EXTRA_SOUND_NAME) ?: AdhanAudioMapping.DEFAULT_KEY
                currentRawResId = intent.getIntExtra(EXTRA_RAW_RES_ID, 0)
                val prayerIndex = intent.getIntExtra(EXTRA_PRAYER_INDEX, -1)

                showForegroundNotification(currentPrayerName)
                playAdhan(currentRawResId, currentVolume, currentPrayerName, prayerIndex)
            }

            ACTION_PLAY_TEST -> {
                stopPlayback()
                currentVolume = intent.getFloatExtra(EXTRA_VOLUME, 1.0f)
                currentSoundName = intent.getStringExtra(EXTRA_SOUND_NAME) ?: AdhanAudioMapping.DEFAULT_KEY
                currentRawResId = intent.getIntExtra(EXTRA_RAW_RES_ID, 0)

                showForegroundNotification("اختبار الأذان")
                playAdhan(currentRawResId, currentVolume, "اختبار الأذان", -1)
            }

            ACTION_STOP_ADHAN -> {
                stopPlayback()
                dismissForeground()
                stopSelf()
            }

            ACTION_SNOOZE_ADHAN -> {
                val snoozeMinutes = intent.getIntExtra(EXTRA_SNOOZE_MINUTES, getSnoozeMinutes())
                stopPlayback()
                scheduleSnooze(snoozeMinutes)
                dismissForeground()
                stopSelf()
            }
        }

        return START_NOT_STICKY
    }

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onTaskRemoved(rootIntent: Intent?) {
        Log.i(TAG, "Task removed, releasing resources")
        releaseResources()
        super.onTaskRemoved(rootIntent)
    }

    override fun onDestroy() {
        Log.i(TAG, "Service destroyed")
        releaseResources()
        super.onDestroy()
    }

    // ─── Helpers ──────────────────────────────────────────────────────────────

    private fun getSnoozeMinutes(): Int {
        return try {
            getSharedPreferences("adhan_schedule", MODE_PRIVATE)
                .getInt("snooze_minutes", 5)
        } catch (e: Exception) { 5 }
    }

    private fun dismissForeground() {
        if (isForeground) {
            try {
                stopForeground(STOP_FOREGROUND_REMOVE)
            } catch (e: Exception) {
                Log.e(TAG, "Error stopping foreground", e)
            }
            isForeground = false
        }
    }

    // ─── Playback ──────────────────────────────────────────────────────────────

    private fun playAdhan(rawResId: Int, volume: Float, prayerName: String, prayerIndex: Int) {
        if (isPlaying) {
            Log.w(TAG, "Already playing, stopping previous playback first")
            stopPlayback()
        }

        if (!requestAudioFocus()) {
            Log.w(TAG, "Audio focus denied, playing anyway")
        }

        acquireWakeLock()

        try {
            val resolvedResId = if (rawResId != 0) {
                rawResId
            } else {
                Log.w(TAG, "rawResId is 0, falling back to mapping lookup")
                AdhanAudioMapping.resolveRawResourceId(applicationContext, currentSoundName)
            }

            val uri = Uri.parse("android.resource://$packageName/$resolvedResId")

            mediaPlayer = MediaPlayer().apply {
                setAudioAttributes(
                    AudioAttributes.Builder()
                        .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                        .setUsage(AudioAttributes.USAGE_MEDIA)
                        .setFlags(AudioAttributes.FLAG_AUDIBILITY_ENFORCED)
                        .build()
                )

                setDataSource(applicationContext, uri)
                setVolume(volume.coerceIn(0.0f, 1.0f), volume.coerceIn(0.0f, 1.0f))
                setLooping(false)

                setOnPreparedListener { mp ->
                    Log.i(TAG, "MediaPlayer prepared, starting playback")
                    this@AdhanForegroundService.isPlaying = true
                    mp.start()
                    updateNotificationPlaybackState(true)
                }

                setOnCompletionListener(OnCompletionListener {
                    Log.i(TAG, "Playback completed for $prayerName")
                    this@AdhanForegroundService.isPlaying = false
                    onPlaybackCompleted(prayerIndex)
                })

                setOnErrorListener { _, what, extra ->
                    Log.e(TAG, "MediaPlayer error: what=$what, extra=$extra")
                    this@AdhanForegroundService.isPlaying = false
                    releaseResources()
                    dismissForeground()
                    stopSelf()
                    true
                }

                prepareAsync()
            }

            Log.i(TAG, "Playing adhan: ${AdhanAudioMapping.getDisplayName(currentSoundName)} (res=$resolvedResId) at volume $volume for $prayerName")

        } catch (e: Exception) {
            Log.e(TAG, "Failed to play adhan", e)
            isPlaying = false
            showErrorNotification(prayerName)
            releaseResources()
            dismissForeground()
            stopSelf()
        }
    }

    private fun onPlaybackCompleted(prayerIndex: Int) {
        releaseResources()
        dismissForeground()
        stopSelf()
    }

    private fun stopPlayback() {
        isPlaying = false
        try {
            mediaPlayer?.let { player ->
                try {
                    if (player.isPlaying) {
                        player.stop()
                    }
                } catch (e: IllegalStateException) {
                    Log.w(TAG, "MediaPlayer was not in a playable state")
                }
                player.reset()
                player.release()
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error stopping playback", e)
        } finally {
            mediaPlayer = null
        }

        releaseWakeLock()
        abandonAudioFocus()
    }

    private fun releaseResources() {
        stopPlayback()
    }

    // ─── Audio Focus ───────────────────────────────────────────────────────────

    private val audioFocusListener = AudioManager.OnAudioFocusChangeListener { focusChange ->
        Log.i(TAG, "Audio focus changed: $focusChange")
        when (focusChange) {
            AudioManager.AUDIOFOCUS_LOSS -> {
                stopPlayback()
                dismissForeground()
                stopSelf()
            }
            AudioManager.AUDIOFOCUS_LOSS_TRANSIENT -> {
                mediaPlayer?.let {
                    try {
                        if (it.isPlaying) it.pause()
                    } catch (e: IllegalStateException) { /* ignore */ }
                }
            }
            AudioManager.AUDIOFOCUS_GAIN -> {
                mediaPlayer?.let {
                    try {
                        if (!it.isPlaying) it.start()
                    } catch (e: IllegalStateException) { /* ignore */ }
                }
            }
            AudioManager.AUDIOFOCUS_LOSS_TRANSIENT_CAN_DUCK -> {
                mediaPlayer?.let {
                    try {
                        if (it.isPlaying) it.setVolume(0.2f, 0.2f)
                    } catch (e: IllegalStateException) { /* ignore */ }
                }
            }
        }
    }

    private fun requestAudioFocus(): Boolean {
        if (audioManager == null) return false

        return try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                val focusRequest = AudioFocusRequest.Builder(AudioManager.AUDIOFOCUS_GAIN).run {
                    setAudioAttributes(
                        AudioAttributes.Builder()
                            .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                            .setUsage(AudioAttributes.USAGE_MEDIA)
                            .build()
                    )
                    setOnAudioFocusChangeListener(audioFocusListener)
                    setAcceptsDelayedFocusGain(false)
                    build()
                }
                audioFocusRequest = focusRequest
                val result = audioManager?.requestAudioFocus(focusRequest)
                result == AudioManager.AUDIOFOCUS_REQUEST_GRANTED
            } else {
                @Suppress("DEPRECATION")
                val result = audioManager?.requestAudioFocus(
                    audioFocusListener,
                    AudioManager.STREAM_MUSIC,
                    AudioManager.AUDIOFOCUS_GAIN
                )
                result == AudioManager.AUDIOFOCUS_REQUEST_GRANTED
            }
        } catch (e: Exception) {
            Log.e(TAG, "Audio focus request failed", e)
            false
        }
    }

    private fun abandonAudioFocus() {
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                audioFocusRequest?.let { audioManager?.abandonAudioFocusRequest(it) }
            } else {
                @Suppress("DEPRECATION")
                audioManager?.abandonAudioFocus(audioFocusListener)
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error abandoning audio focus", e)
        } finally {
            audioFocusRequest = null
        }
    }

    // ─── Wake Lock ────────────────────────────────────────────────────────────

    private fun acquireWakeLock() {
        try {
            val powerManager = getSystemService(Context.POWER_SERVICE) as PowerManager
            wakeLock?.let {
                if (it.isHeld) it.release()
            }
            wakeLock = powerManager.newWakeLock(
                PowerManager.PARTIAL_WAKE_LOCK,
                "$packageName:adhan_playback"
            ).apply {
                acquire(10 * 60 * 1000L)
                Log.i(TAG, "Wake lock acquired")
            }
        } catch (e: Exception) {
            Log.e(TAG, "Failed to acquire wake lock", e)
        }
    }

    private fun releaseWakeLock() {
        try {
            wakeLock?.let {
                if (it.isHeld) {
                    it.release()
                    Log.i(TAG, "Wake lock released")
                }
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error releasing wake lock", e)
        } finally {
            wakeLock = null
        }
    }

    // ─── Notification Channels ─────────────────────────────────────────────────

    private fun createNotificationChannels() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val fgChannel = NotificationChannel(
                CHANNEL_ID,
                CHANNEL_NAME,
                NotificationManager.IMPORTANCE_LOW
            ).apply {
                description = CHANNEL_DESC
                enableVibration(false)
                setShowBadge(false)
            }
            notificationManager?.createNotificationChannel(fgChannel)

            val errorChannel = NotificationChannel(
                "adhan_error",
                "أخطاء الأذان",
                NotificationManager.IMPORTANCE_LOW
            ).apply {
                description = "إشعارات أخطاء الأذان"
                enableVibration(false)
                setShowBadge(false)
            }
            notificationManager?.createNotificationChannel(errorChannel)

            Log.i(TAG, "Notification channels created")
        }
    }

    // ─── Notifications ─────────────────────────────────────────────────────────

    private fun showForegroundNotification(prayerName: String) {
        val openAppIntent = packageManager.getLaunchIntentForPackage(packageName)?.apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
        }

        val openAppPendingIntent = PendingIntent.getActivity(
            this,
            0,
            openAppIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val stopIntent = Intent(this, AdhanForegroundService::class.java).apply {
            action = ACTION_STOP_ADHAN
        }
        val stopPendingIntent = PendingIntent.getService(
            this,
            NOTIFICATION_ID + 1,
            stopIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val snoozeMinutes = getSnoozeMinutes()
        val snoozeIntent = Intent(this, AdhanForegroundService::class.java).apply {
            action = ACTION_SNOOZE_ADHAN
            putExtra(EXTRA_SNOOZE_MINUTES, snoozeMinutes)
        }
        val snoozePendingIntent = PendingIntent.getService(
            this,
            NOTIFICATION_ID + 2,
            snoozeIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val builder = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Notification.Builder(this, CHANNEL_ID)
        } else {
            @Suppress("DEPRECATION")
            Notification.Builder(this)
        }

        val notification = builder
            .setContentTitle("🕌 حان الآن موعد الأذان")
            .setContentText("صلاة $prayerName")
            .setSmallIcon(android.R.drawable.ic_media_play)
            .setContentIntent(openAppPendingIntent)
            .setOngoing(true)
            .setPriority(Notification.PRIORITY_LOW)
            .setCategory(Notification.CATEGORY_SERVICE)
            .setAutoCancel(false)
            .addAction(
                android.R.drawable.ic_media_pause,
                "إيقاف",
                stopPendingIntent
            )
            .addAction(
                android.R.drawable.ic_media_next,
                "غفوة $snoozeMinutes دقائق",
                snoozePendingIntent
            )
            .setStyle(
                android.app.Notification.BigTextStyle().bigText(
                    "جاري تشغيل أذان صلاة $prayerName\n" +
                    "اضغط 'إيقاف' لإيقاف الصوت أو 'غفوة' لتأجيل $snoozeMinutes دقائق"
                )
            )
            .build()

        startForeground(NOTIFICATION_ID, notification)
        isForeground = true
        Log.i(TAG, "Foreground notification shown for: $prayerName")
    }

    private fun updateNotificationPlaybackState(isPlaying: Boolean) {
        // Reserved for future media-style notification with playback controls
    }

    private fun showErrorNotification(prayerName: String) {
        val builder = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Notification.Builder(this, "adhan_error")
        } else {
            @Suppress("DEPRECATION")
            Notification.Builder(this)
        }

        val notification = builder
            .setContentTitle("تعذر تشغيل الأذان")
            .setContentText("حدث خطأ أثناء تشغيل صوت الأذان لصلاة $prayerName")
            .setSmallIcon(android.R.drawable.ic_dialog_alert)
            .setPriority(Notification.PRIORITY_LOW)
            .build()

        notificationManager?.notify(NOTIFICATION_ID + 1, notification)
    }

    // ─── Snooze ────────────────────────────────────────────────────────────────

    private fun scheduleSnooze(minutes: Int) {
        try {
            val alarmManager = getSystemService(Context.ALARM_SERVICE) as android.app.AlarmManager
            val triggerTime = System.currentTimeMillis() + minutes * 60 * 1000L

            val intent = Intent(this, AdhanAlarmReceiver::class.java).apply {
                action = AdhanAlarmReceiver.ACTION_ADHAN_ALARM
                putExtra(EXTRA_PRAYER_NAME, currentPrayerName)
                putExtra(EXTRA_PRAYER_INDEX, 0)
                putExtra(EXTRA_VOLUME, currentVolume)
                putExtra(EXTRA_SOUND_NAME, currentSoundName)
                putExtra(EXTRA_RAW_RES_ID, currentRawResId)
            }

            val code = 5000 + Math.abs(currentPrayerName.hashCode() % 1000)
            val pendingIntent = PendingIntent.getBroadcast(
                this,
                code,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                if (alarmManager.canScheduleExactAlarms()) {
                    alarmManager.setExactAndAllowWhileIdle(
                        android.app.AlarmManager.RTC_WAKEUP,
                        triggerTime,
                        pendingIntent
                    )
                } else {
                    alarmManager.setAndAllowWhileIdle(
                        android.app.AlarmManager.RTC_WAKEUP,
                        triggerTime,
                        pendingIntent
                    )
                }
            } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                alarmManager.setExactAndAllowWhileIdle(
                    android.app.AlarmManager.RTC_WAKEUP,
                    triggerTime,
                    pendingIntent
                )
            } else {
                alarmManager.setExact(
                    android.app.AlarmManager.RTC_WAKEUP,
                    triggerTime,
                    pendingIntent
                )
            }

            Log.i(TAG, "Snooze scheduled for $minutes minutes")
        } catch (e: SecurityException) {
            Log.w(TAG, "Cannot schedule exact alarm (permission revoked), using inexact")
            try {
                val alarmManager = getSystemService(Context.ALARM_SERVICE) as android.app.AlarmManager
                val triggerTime = System.currentTimeMillis() + minutes * 60 * 1000L
                val intent = Intent(this, AdhanAlarmReceiver::class.java).apply {
                    action = AdhanAlarmReceiver.ACTION_ADHAN_ALARM
                    putExtra(EXTRA_PRAYER_NAME, currentPrayerName)
                    putExtra(EXTRA_PRAYER_INDEX, 0)
                    putExtra(EXTRA_VOLUME, currentVolume)
                    putExtra(EXTRA_SOUND_NAME, currentSoundName)
                    putExtra(EXTRA_RAW_RES_ID, currentRawResId)
                }
                val fallbackPendingIntent = PendingIntent.getBroadcast(
                    this,
                    5000 + Math.abs(currentPrayerName.hashCode() % 1000),
                    intent,
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                )
                alarmManager.set(
                    android.app.AlarmManager.RTC_WAKEUP,
                    triggerTime,
                    fallbackPendingIntent
                )
            } catch (e2: Exception) {
                Log.e(TAG, "Failed to schedule inexact snooze", e2)
            }
        } catch (e: Exception) {
            Log.e(TAG, "Failed to schedule snooze", e)
        }
    }
}

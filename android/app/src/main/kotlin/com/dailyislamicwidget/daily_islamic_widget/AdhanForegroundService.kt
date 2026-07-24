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
        const val EXTRA_PRAYER_NAME = "prayer_name"
        const val EXTRA_PRAYER_INDEX = "prayer_index"
        const val EXTRA_VOLUME = "volume"
        const val EXTRA_SOUND_NAME = "sound_name"
        const val EXTRA_RAW_RES_ID = "raw_res_id"
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
        Log.i(TAG, "[VERIFICATION] onStartCommand: action=$action, flags=$flags, startId=$startId, api=${Build.VERSION.SDK_INT}")

        when (action) {
            ACTION_PLAY_ADHAN -> {
                stopPlayback()
                currentPrayerName = intent.getStringExtra(EXTRA_PRAYER_NAME) ?: "صلاة"
                currentVolume = intent.getFloatExtra(EXTRA_VOLUME, 1.0f)
                currentSoundName = intent.getStringExtra(EXTRA_SOUND_NAME) ?: AdhanAudioMapping.DEFAULT_KEY
                currentRawResId = intent.getIntExtra(EXTRA_RAW_RES_ID, 0)
                val prayerIndex = intent.getIntExtra(EXTRA_PRAYER_INDEX, -1)

                Log.i(TAG, "[VERIFICATION] PLAY_ADHAN: prayer=$currentPrayerName, volume=$currentVolume, sound=$currentSoundName, rawResId=$currentRawResId, prayerIndex=$prayerIndex")
                showForegroundNotification(currentPrayerName)
                playAdhan(currentRawResId, currentVolume, currentPrayerName, prayerIndex)

                // START_REDELIVER_INTENT: If the system kills this service during
                // adhan playback (Doze, low memory, OEM process trimming), the
                // service is restarted with the original intent so playback resumes.
                // This is critical — adhan is a time-sensitive religious notification
                // that must not be silently dropped.
                // Note: stopSelf() in onPlaybackCompleted() prevents restart after
                // normal completion.
                Log.i(TAG, "[VERIFICATION] RESTART_POLICY: START_REDELIVER_INTENT (adhan playback)")
                return START_REDELIVER_INTENT
            }

            ACTION_PLAY_TEST -> {
                stopPlayback()
                currentVolume = intent.getFloatExtra(EXTRA_VOLUME, 1.0f)
                currentSoundName = intent.getStringExtra(EXTRA_SOUND_NAME) ?: AdhanAudioMapping.DEFAULT_KEY
                currentRawResId = intent.getIntExtra(EXTRA_RAW_RES_ID, 0)

                showForegroundNotification("اختبار الأذان")
                playAdhan(currentRawResId, currentVolume, "اختبار الأذان", -1)

                // START_NOT_STICKY: Test playback is non-critical.
                // If the system kills it, no recovery is needed.
                Log.i(TAG, "[VERIFICATION] RESTART_POLICY: START_NOT_STICKY (test playback)")
                return START_NOT_STICKY
            }

            ACTION_STOP_ADHAN -> {
                stopPlayback()
                dismissForeground()
                stopSelf()

                // START_NOT_STICKY: Explicit stop must never auto-restart.
                Log.i(TAG, "[VERIFICATION] RESTART_POLICY: START_NOT_STICKY (explicit stop)")
                return START_NOT_STICKY
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
            Log.w(TAG, "[VERIFICATION] AUDIO_FOCUS_DENIED — playing anyway")
        } else {
            Log.i(TAG, "[VERIFICATION] AUDIO_FOCUS_GRANTED")
        }

        acquireWakeLock()

        try {
            val resolvedResId = if (rawResId != 0) {
                rawResId
            } else {
                Log.w(TAG, "[VERIFICATION] rawResId is 0, falling back to mapping lookup")
                AdhanAudioMapping.resolveRawResourceId(applicationContext, currentSoundName)
            }

            val uri = Uri.parse("android.resource://$packageName/$resolvedResId")
            Log.i(TAG, "[VERIFICATION] MEDIA_PLAYER_SETUP: uri=$uri, resId=$resolvedResId, volume=$volume")

            mediaPlayer = MediaPlayer().apply {
                setAudioAttributes(
                    AudioAttributes.Builder()
                        .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                        .setUsage(AudioAttributes.USAGE_ALARM)
                        .build()
                )
                Log.i(TAG, "[VERIFICATION] AUDIO_ATTRIBUTES_APPLIED: contentType=CONTENT_TYPE_SONIFICATION, usage=USAGE_ALARM")

                setDataSource(applicationContext, uri)
                setVolume(volume.coerceIn(0.0f, 1.0f), volume.coerceIn(0.0f, 1.0f))
                setLooping(false)

                setOnPreparedListener { mp ->
                    Log.i(TAG, "[VERIFICATION] MEDIA_PLAYER_PREPARED — starting playback for $prayerName")
                    this@AdhanForegroundService.isPlaying = true
                    mp.start()
                    Log.i(TAG, "[VERIFICATION] PLAYBACK_STARTED for $prayerName (isPlaying=${mp.isPlaying})")
                    updateNotificationPlaybackState(true)
                }

                setOnCompletionListener(OnCompletionListener {
                    Log.i(TAG, "[VERIFICATION] PLAYBACK_COMPLETED for $prayerName")
                    this@AdhanForegroundService.isPlaying = false
                    onPlaybackCompleted(prayerIndex)
                })

                setOnErrorListener { _, what, extra ->
                    Log.e(TAG, "[VERIFICATION] MEDIA_PLAYER_ERROR: what=$what, extra=$extra for $prayerName")
                    this@AdhanForegroundService.isPlaying = false
                    releaseResources()
                    dismissForeground()
                    stopSelf()
                    true
                }

                prepareAsync()
            }

            Log.i(TAG, "[VERIFICATION] PREPARE_ASYNC called for $prayerName")

        } catch (e: Exception) {
            Log.e(TAG, "[VERIFICATION] PLAY_ADHAN_FAILED for $prayerName: ${e.message}", e)
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
        Log.i(TAG, "[VERIFICATION] STOP_PLAYBACK called (isPlaying=$isPlaying)")
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
        Log.i(TAG, "[VERIFICATION] AUDIO_FOCUS_CHANGED: focusChange=$focusChange")
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
                            .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                            .setUsage(AudioAttributes.USAGE_ALARM)
                            .build()
                    )
                    setOnAudioFocusChangeListener(audioFocusListener)
                    setAcceptsDelayedFocusGain(false)
                    build()
                }
                audioFocusRequest = focusRequest
                val result = audioManager?.requestAudioFocus(focusRequest)
                Log.i(TAG, "[VERIFICATION] AUDIO_FOCUS_REQUEST_API26: result=$result (GRANTED=${AudioManager.AUDIOFOCUS_REQUEST_GRANTED})")
                result == AudioManager.AUDIOFOCUS_REQUEST_GRANTED
            } else {
                @Suppress("DEPRECATION")
                val result = audioManager?.requestAudioFocus(
                    audioFocusListener,
                    AudioManager.STREAM_ALARM,
                    AudioManager.AUDIOFOCUS_GAIN
                )
                Log.i(TAG, "[VERIFICATION] AUDIO_FOCUS_REQUEST_LEGACY: result=$result (GRANTED=${AudioManager.AUDIOFOCUS_REQUEST_GRANTED})")
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
                Log.i(TAG, "[VERIFICATION] SERVICE_WAKELOCK_ACQUIRED (tag=$packageName:adhan_playback, timeout=10min)")
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
                    Log.i(TAG, "[VERIFICATION] SERVICE_WAKELOCK_RELEASED")
                } else {
                    Log.w(TAG, "[VERIFICATION] SERVICE_WAKELOCK_NOT_HELD on release")
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

        val builder = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Notification.Builder(this, CHANNEL_ID)
        } else {
            @Suppress("DEPRECATION")
            Notification.Builder(this)
        }

        val notification = builder
            .setContentTitle("حان وقت صلاة $prayerName")
            .setContentText("حيّ على الصلاة • حيّ على الفلاح")
            .setSmallIcon(android.R.drawable.ic_media_play)
            .setContentIntent(openAppPendingIntent)
            .setOngoing(true)
            .setPriority(Notification.PRIORITY_LOW)
            .setCategory(Notification.CATEGORY_SERVICE)
            .setAutoCancel(false)
            .addAction(
                android.R.drawable.ic_media_pause,
                "إيقاف الأذان",
                stopPendingIntent
            )
            .build()

        startForeground(NOTIFICATION_ID, notification)
        isForeground = true
        Log.i(TAG, "[VERIFICATION] FOREGROUND_NOTIFICATION_SHOWN for: $prayerName (notificationId=$NOTIFICATION_ID)")
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

}

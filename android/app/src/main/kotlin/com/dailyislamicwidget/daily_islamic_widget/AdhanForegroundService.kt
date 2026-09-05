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
import android.net.Uri
import android.os.Build
import android.os.IBinder
import android.os.PowerManager
import android.util.Log

/**
 * AdhanForegroundService — Foreground audio playback service for Adhan recitation.
 *
 * Hardened Architecture:
 *   1. Immediately calls startForeground() in onStartCommand to satisfy Android 14+ strict timing.
 *   2. Uses USAGE_ALARM and AudioFocus to ensure proper audio routing through alarm volume stream.
 *   3. Resolves local bundled audio (raw/adhan_*.mp3) with automatic fallback to default Adhan.
 *   4. Bounded WakeLock prevents sleeping during recitation and releases promptly on completion or stop.
 *   5. Interactive notification with 'Stop' action to let user dismiss at any time.
 */
class AdhanForegroundService : Service() {

    companion object {
        private const val TAG = "AdhanForegroundService"

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
    private var currentSoundName: String = AdhanAudioMapping.DEFAULT_KEY
    private var currentRawResId: Int = 0

    override fun onCreate() {
        super.onCreate()
        audioManager = getSystemService(Context.AUDIO_SERVICE) as AudioManager
        notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        AdhanNotificationHelper.ensureChannels(this)
        Log.i(TAG, "AdhanForegroundService created")
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val action = intent?.action ?: return START_NOT_STICKY
        Log.i(TAG, "[SERVICE] onStartCommand: action=$action, api=${Build.VERSION.SDK_INT}")

        when (action) {
            ACTION_PLAY_ADHAN -> {
                stopPlayback()
                currentPrayerName = intent.getStringExtra(EXTRA_PRAYER_NAME) ?: "الصلاة"
                currentVolume = intent.getFloatExtra(EXTRA_VOLUME, 1.0f)
                currentSoundName = intent.getStringExtra(EXTRA_SOUND_NAME) ?: AdhanAudioMapping.DEFAULT_KEY
                currentRawResId = intent.getIntExtra(EXTRA_RAW_RES_ID, 0)
                val prayerIndex = intent.getIntExtra(EXTRA_PRAYER_INDEX, -1)

                showForegroundNotification(currentPrayerName, isTest = false)
                playAdhan(currentRawResId, currentVolume, currentPrayerName, prayerIndex)
                return START_REDELIVER_INTENT
            }

            ACTION_PLAY_TEST -> {
                stopPlayback()
                currentVolume = intent.getFloatExtra(EXTRA_VOLUME, 1.0f)
                currentSoundName = intent.getStringExtra(EXTRA_SOUND_NAME) ?: AdhanAudioMapping.DEFAULT_KEY
                currentRawResId = intent.getIntExtra(EXTRA_RAW_RES_ID, 0)

                showForegroundNotification("اختبار الأذان", isTest = true)
                playAdhan(currentRawResId, currentVolume, "اختبار الأذان", -1)
                return START_NOT_STICKY
            }

            ACTION_STOP_ADHAN -> {
                stopPlayback()
                dismissForeground()
                stopSelf()
                return START_NOT_STICKY
            }
        }

        return START_NOT_STICKY
    }

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onTaskRemoved(rootIntent: Intent?) {
        Log.i(TAG, "Task removed, ensuring clean release")
        releaseResources()
        super.onTaskRemoved(rootIntent)
    }

    override fun onDestroy() {
        Log.i(TAG, "Service destroying, releasing all resources")
        releaseResources()
        super.onDestroy()
    }

    private fun dismissForeground() {
        if (isForeground) {
            try {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                    stopForeground(STOP_FOREGROUND_REMOVE)
                } else {
                    @Suppress("DEPRECATION")
                    stopForeground(true)
                }
            } catch (e: Exception) {
                Log.e(TAG, "Error stopping foreground: ${e.message}")
            }
            isForeground = false
        }
    }

    private fun playAdhan(rawResId: Int, volume: Float, prayerName: String, prayerIndex: Int) {
        if (isPlaying) {
            stopPlayback()
        }

        requestAudioFocus()
        acquireWakeLock()

        try {
            var resolvedResId = if (rawResId != 0) {
                rawResId
            } else {
                AdhanAudioMapping.resolveRawResourceId(applicationContext, currentSoundName)
            }

            // Fallback to default audio if resolution failed
            if (resolvedResId == 0) {
                Log.w(TAG, "[AUDIO] Resource 0, falling back to default adhan sound")
                resolvedResId = AdhanAudioMapping.resolveRawResourceId(applicationContext, AdhanAudioMapping.DEFAULT_KEY)
            }

            val uri = Uri.parse("android.resource://$packageName/$resolvedResId")
            Log.i(TAG, "[AUDIO] Preparing MediaPlayer with uri=$uri, volume=$volume")

            mediaPlayer = MediaPlayer().apply {
                setAudioAttributes(
                    AudioAttributes.Builder()
                        .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                        .setUsage(AudioAttributes.USAGE_ALARM)
                        .build()
                )

                setDataSource(applicationContext, uri)
                val safeVolume = volume.coerceIn(0.0f, 1.0f)
                setVolume(safeVolume, safeVolume)
                setLooping(false)

                setOnPreparedListener { mp ->
                    this@AdhanForegroundService.isPlaying = true
                    mp.start()
                    Log.i(TAG, "[AUDIO] Playback started for $prayerName")
                }

                setOnCompletionListener(OnCompletionListener {
                    Log.i(TAG, "[AUDIO] Playback completed normally for $prayerName")
                    this@AdhanForegroundService.isPlaying = false
                    onPlaybackCompleted(prayerName, prayerIndex)
                })

                setOnErrorListener { _, what, extra ->
                    Log.e(TAG, "[AUDIO] MediaPlayer error: what=$what, extra=$extra for $prayerName")
                    this@AdhanForegroundService.isPlaying = false
                    releaseResources()
                    dismissForeground()
                    stopSelf()
                    true
                }

                prepareAsync()
            }

        } catch (e: Exception) {
            Log.e(TAG, "[AUDIO] Failed to play adhan for $prayerName: ${e.message}", e)
            isPlaying = false
            releaseResources()
            dismissForeground()
            stopSelf()
        }
    }

    private fun onPlaybackCompleted(prayerName: String, prayerIndex: Int) {
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
                } catch (_: Exception) {}
                player.reset()
                player.release()
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error stopping playback: ${e.message}")
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
        Log.i(TAG, "[AUDIO] Audio focus changed: $focusChange")
        when (focusChange) {
            AudioManager.AUDIOFOCUS_LOSS -> {
                stopPlayback()
                dismissForeground()
                stopSelf()
            }
            AudioManager.AUDIOFOCUS_LOSS_TRANSIENT -> {
                try {
                    if (mediaPlayer?.isPlaying == true) mediaPlayer?.pause()
                } catch (_: Exception) {}
            }
            AudioManager.AUDIOFOCUS_GAIN -> {
                try {
                    if (mediaPlayer?.isPlaying == false) mediaPlayer?.start()
                } catch (_: Exception) {}
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
                            .setUsage(AudioAttributes.USAGE_ALARM)
                            .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                            .build()
                    )
                    setOnAudioFocusChangeListener(audioFocusListener)
                    build()
                }
                audioFocusRequest = focusRequest
                audioManager?.requestAudioFocus(focusRequest) == AudioManager.AUDIOFOCUS_REQUEST_GRANTED
            } else {
                @Suppress("DEPRECATION")
                audioManager?.requestAudioFocus(
                    audioFocusListener,
                    AudioManager.STREAM_ALARM,
                    AudioManager.AUDIOFOCUS_GAIN
                ) == AudioManager.AUDIOFOCUS_REQUEST_GRANTED
            }
        } catch (e: Exception) {
            Log.w(TAG, "Audio focus request exception: ${e.message}")
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
        } catch (_: Exception) {}
        audioFocusRequest = null
    }

    // ─── Wake Lock ─────────────────────────────────────────────────────────────

    private fun acquireWakeLock() {
        try {
            val powerManager = getSystemService(Context.POWER_SERVICE) as PowerManager
            wakeLock?.let { if (it.isHeld) it.release() }

            wakeLock = powerManager.newWakeLock(
                PowerManager.PARTIAL_WAKE_LOCK,
                "$packageName:adhan_playback"
            ).apply {
                setReferenceCounted(false)
                acquire(10 * 60 * 1000L) // 10 minute safety limit
            }
            Log.i(TAG, "[WAKELOCK] Acquired 10m bounded lock for audio playback")
        } catch (e: Exception) {
            Log.e(TAG, "Failed to acquire wake lock: ${e.message}")
        }
    }

    private fun releaseWakeLock() {
        try {
            wakeLock?.let {
                if (it.isHeld) {
                    it.release()
                    Log.i(TAG, "[WAKELOCK] Released playback lock")
                }
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error releasing wake lock: ${e.message}")
        } finally {
            wakeLock = null
        }
    }

    // ─── Notification ──────────────────────────────────────────────────────────

    private fun showForegroundNotification(prayerName: String, isTest: Boolean) {
        val notification = AdhanNotificationHelper.buildAdhanNotification(
            context = this,
            prayerName = prayerName,
            isTest = isTest,
            isLate = false
        )
        startForeground(AdhanNotificationHelper.NOTIFICATION_ID, notification)
        isForeground = true
        Log.i(TAG, "[SERVICE] startForeground invoked with notification id=${AdhanNotificationHelper.NOTIFICATION_ID}")
    }
}

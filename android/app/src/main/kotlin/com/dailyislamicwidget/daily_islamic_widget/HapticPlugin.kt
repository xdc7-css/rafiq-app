package com.dailyislamicwidget.daily_islamic_widget

import android.content.Context
import android.os.Build
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager
import android.util.Log
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 * Premium haptic feedback for the Tasbih feature.
 *
 * Uses Android VibrationEffect with predefined effects on API 29+,
 * amplitude-based vibration on API 26-28, and classic vibration as
 * fallback on older devices.
 */
class HapticPlugin(private val context: Context) : MethodChannel.MethodCallHandler {

    companion object {
        private const val TAG = "HapticPlugin"
        private const val CHANNEL = "com.dailyislamicwidget/haptic"
    }

    private val vibrator: Vibrator? by lazy { createVibrator() }

    fun setup(engine: FlutterEngine) {
        MethodChannel(engine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler(this)
        Log.d(TAG, "Registered on channel: $CHANNEL (API ${Build.VERSION.SDK_INT})")
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "lightTap" -> { vibrateLight(); result.success(null) }
            "mediumTap" -> { vibrateMedium(); result.success(null) }
            "strongTap" -> { vibrateStrong(); result.success(null) }
            else -> result.notImplemented()
        }
    }

    @Suppress("DEPRECATION")
    private fun createVibrator(): Vibrator? {
        return try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                val vm = context.getSystemService(Context.VIBRATOR_MANAGER_SERVICE) as? VibratorManager
                vm?.defaultVibrator
            } else {
                @Suppress("DEPRECATION")
                context.getSystemService(Context.VIBRATOR_SERVICE) as? Vibrator
            }
        } catch (e: Exception) {
            Log.w(TAG, "Vibrator unavailable: ${e.message}")
            null
        }
    }

    private fun vibrateLight() {
        val v = vibrator ?: return
        if (!v.hasVibrator()) return

        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                v.vibrate(VibrationEffect.createPredefined(VibrationEffect.EFFECT_CLICK))
            } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                v.vibrate(VibrationEffect.createOneShot(10, 40))
            } else {
                @Suppress("DEPRECATION")
                v.vibrate(10)
            }
        } catch (e: Exception) {
            Log.w(TAG, "lightTap failed: ${e.message}")
        }
    }

    private fun vibrateMedium() {
        val v = vibrator ?: return
        if (!v.hasVibrator()) return

        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                v.vibrate(VibrationEffect.createPredefined(VibrationEffect.EFFECT_TICK))
            } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                v.vibrate(VibrationEffect.createOneShot(15, 80))
            } else {
                @Suppress("DEPRECATION")
                v.vibrate(15)
            }
        } catch (e: Exception) {
            Log.w(TAG, "mediumTap failed: ${e.message}")
        }
    }

    private fun vibrateStrong() {
        val v = vibrator ?: return
        if (!v.hasVibrator()) return

        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                v.vibrate(VibrationEffect.createPredefined(VibrationEffect.EFFECT_HEAVY_CLICK))
            } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                v.vibrate(VibrationEffect.createOneShot(25, 180))
            } else {
                @Suppress("DEPRECATION")
                v.vibrate(30)
            }
        } catch (e: Exception) {
            Log.w(TAG, "strongTap failed: ${e.message}")
        }
    }
}

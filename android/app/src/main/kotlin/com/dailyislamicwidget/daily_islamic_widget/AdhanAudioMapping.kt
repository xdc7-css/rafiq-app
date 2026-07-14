package com.dailyislamicwidget.daily_islamic_widget

import android.content.Context

object AdhanAudioMapping {

    data class Muadhin(val displayName: String, val rawResourceName: String)

    private val muadhins = linkedMapOf(
        "adhan_maitham" to Muadhin("الحاج ميثم التمار", "adhan_maitham"),
        "adhan_mustafa" to Muadhin("الحاج مصطفى الصراف", "adhan_mustafa"),
        "adhan_ausama"  to Muadhin("الحاج أسامة الكربلائي", "adhan_ausama"),
    )

    const val DEFAULT_KEY = "adhan_maitham"

    fun resolveRawResourceId(context: Context, soundKey: String): Int {
        val key = if (muadhins.containsKey(soundKey)) soundKey else DEFAULT_KEY
        val resourceName = muadhins[key]!!.rawResourceName
        val resId = context.resources.getIdentifier(resourceName, "raw", context.packageName)
        if (resId == 0) {
            android.util.Log.e("AdhanAudioMapping", "Raw resource not found: $resourceName, falling back to $DEFAULT_KEY")
            val fallbackId = context.resources.getIdentifier(
                muadhins[DEFAULT_KEY]!!.rawResourceName, "raw", context.packageName
            )
            return fallbackId
        }
        return resId
    }

    fun isValidKey(soundKey: String): Boolean = muadhins.containsKey(soundKey)

    fun getDisplayName(soundKey: String): String {
        return muadhins[soundKey]?.displayName ?: muadhins[DEFAULT_KEY]!!.displayName
    }
}

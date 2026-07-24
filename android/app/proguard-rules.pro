# ─── Flutter widget bridge (home_widget) ───
-keep class com.dailyislamicwidget.daily_islamic_widget.** { *; }
-keep class com.davbyworth.** { *; }

# ─── Widget providers referenced from AndroidManifest ───
-keep class * extends android.appwidget.AppWidgetProvider { *; }

# ─── BroadcastReceiver for widget actions ───
-keep class * extends android.content.BroadcastReceiver { *; }

# ─── home_widget plugin ───
-keep class gl.** { *; }
-keep class es.** { *; }
-keep class io.flutter.plugins.home_widget.** { *; }

# ─── WorkManager (Phase 4: Adhan daily reliability) ───
-keep class * extends androidx.work.ListenableWorker {
    public <init>(android.content.Context, androidx.work.WorkerParameters);
}
-keep class androidx.work.impl.** { *; }
-keepattributes *Annotation*

# ─── Prevent R8 from stripping interfaces / annotations ───
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes InnerClasses

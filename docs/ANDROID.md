# Rafeeq (رَفِيقْ) — Android Native Architecture & Build Configuration

> **Build System**: Kotlin Gradle DSL (`build.gradle.kts`)  
> **Java Version**: JVM 21  
> **Target SDK**: 35 (Android 15) | **Min SDK**: 21 (Android 5.0 Lollipop)  

---

## 1. Build Specifications (`android/app/build.gradle.kts`)

```kotlin
android {
    namespace = "com.dailyislamicwidget.daily_islamic_widget"
    compileSdk = flutter.compileSdkVersion // 35
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_21
        targetCompatibility = JavaVersion.VERSION_21
        isCoreLibraryDesugaringEnabled = true
    }

    defaultConfig {
        applicationId = "com.dailyislamicwidget.daily_islamic_widget"
        minSdk = 21
        targetSdk = 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            isMinifyEnabled = true
            isShrinkResources = true
        }
    }
}
```

### Key Dependencies:
- `coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")`: Enables modern Java 8+ `java.time` and stream APIs on older Android devices (API 21–25).
- `implementation("androidx.work:work-runtime-ktx:2.10.0")`: Manages background widget synchronization and adhan rescheduling.

---

## 2. Manifest Permissions & Runtime Rationale

Rafeeq requires the following Android permissions, strictly justified by spiritual functionality:

| Permission | Technical Justification |
| :--- | :--- |
| `ACCESS_FINE_LOCATION` / `ACCESS_COARSE_LOCATION` | Calculate precise solar astronomical angles for Prayer Times and Qibla azimuth. |
| `POST_NOTIFICATIONS` (Android 13+) | Display Adhan and daily Adhkar reminders. |
| `SCHEDULE_EXACT_ALARM` | Fire the exact minute adhan notification at Fajr, Dhuhr, Asr, Maghrib, and Isha. |
| `FOREGROUND_SERVICE` & `FOREGROUND_SERVICE_MEDIA_PLAYBACK` | Uninterrupted background recitation of the Holy Quran with lock screen controls. |
| `RECEIVE_BOOT_COMPLETED` | Restore scheduled adhan alarms and widget sync jobs following a device reboot. |
| `WAKE_LOCK` | Wake device briefly to ring the Adhan audio stream. |

---

## 3. Notification Channels & Sound Assets

Adhan notifications are assigned to a dedicated high-priority channel:
- **Channel ID**: `adhan_channel`
- **Name**: `أوقات الصلاة والأذان`
- **Importance**: `IMPORTANCE_HIGH` (heads-up banner with audio playback)
- **Sound Resource**: Raw audio resource located in `android/app/src/main/res/raw/adhan.mp3` or custom adhan selection.

---

## 4. Proguard & Code Obfuscation Rules (`proguard-rules.pro`)

When building release APKs (`isMinifyEnabled = true`):
- **Isar Engine**: Keep Isar C++ JNI bridge classes.
- **Audio Service**: Keep Android media session callbacks.
- **Firebase**: Keep Firestore DTO models and reflection descriptors.

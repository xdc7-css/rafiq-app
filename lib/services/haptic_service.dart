import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Premium haptic feedback service for the Tasbih feature.
///
/// On Android, uses native VibrationEffect API for precise,
/// device-appropriate haptic feedback. Falls back to Flutter's
/// HapticFeedback on other platforms.
class HapticService {
  HapticService._();
  static final HapticService instance = HapticService._();

  static const _channel = MethodChannel('com.dailyislamicwidget/haptic');

  /// Light tap — fires on every single tap.
  /// Uses EFFECT_CLICK on modern Android, lightImpact fallback elsewhere.
  void lightTap() {
    if (kIsWeb) return;
    if (defaultTargetPlatform == TargetPlatform.android) {
      _invoke('lightTap');
    } else {
      HapticFeedback.lightImpact();
    }
  }

  /// Medium tap — fires on UI navigation and stage transitions.
  /// Uses EFFECT_TICK on modern Android, mediumImpact fallback elsewhere.
  void mediumTap() {
    if (kIsWeb) return;
    if (defaultTargetPlatform == TargetPlatform.android) {
      _invoke('mediumTap');
    } else {
      HapticFeedback.mediumImpact();
    }
  }

  /// Strong tap — fires when a dhikr cycle is completed.
  /// Uses EFFECT_HEAVY_CLICK on modern Android, heavyImpact fallback elsewhere.
  void strongTap() {
    if (kIsWeb) return;
    if (defaultTargetPlatform == TargetPlatform.android) {
      _invoke('strongTap');
    } else {
      HapticFeedback.heavyImpact();
    }
  }

  void _invoke(String method) {
    try {
      _channel.invokeMethod<void>(method);
    } on MissingPluginException {
      // Native plugin not registered — silently degrade
    } catch (_) {
      // Never crash on haptic failure
    }
  }
}

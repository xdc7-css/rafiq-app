import 'package:flutter/foundation.dart';
import '../models/permission_models.dart';

/// Lightweight, centralized analytics for permission-related events.
///
/// Logs to debug console. Designed to be swapped for Firebase Analytics
/// or any other provider by implementing a [AnalyticsBackend] and passing
/// it to [PermissionAnalyticsService.initialize].
///
/// Widgets must never call analytics directly — only services and controllers
/// should fire events through this class.
class PermissionAnalyticsService {
  PermissionAnalyticsService._();

  static AnalyticsBackend? _backend;

  /// Initializes the analytics service with an optional backend.
  ///
  /// If no backend is provided, events are logged to the debug console only.
  static void initialize({AnalyticsBackend? backend}) {
    _backend = backend;
  }

  // ── Permission Events ─────────────────────────────────────────

  static void permissionRequested(PermissionKey key) =>
      _log('permission_${key.name}_requested', {'permission': key.name});

  static void permissionGranted(PermissionKey key) =>
      _log('permission_${key.name}_granted', {'permission': key.name});

  static void permissionDenied(PermissionKey key) =>
      _log('permission_${key.name}_denied', {'permission': key.name});

  // ── Flow Events ───────────────────────────────────────────────

  static void flowCompleted({required int granted, required int total}) =>
      _log('permission_flow_completed', {
        'granted': granted,
        'total': total,
      });

  static void flowSkipped({required int granted, required int total}) =>
      _log('permission_flow_skipped', {
        'granted': granted,
        'total': total,
      });

  static void flowAbandoned({
    required String atPermission,
    required int granted,
    required int total,
  }) =>
      _log('permission_flow_abandoned', {
        'at_permission': atPermission,
        'granted': granted,
        'total': total,
      });

  static void dependencyBlocked({
    required PermissionKey blocked,
    required PermissionKey root,
  }) =>
      _log('permission_dependency_blocked', {
        'blocked': blocked.name,
        'root': root.name,
      });

  // ── OEM Events ────────────────────────────────────────────────

  static void manufacturerDetected(String manufacturer) =>
      _log('manufacturer_detected', {'manufacturer': manufacturer});

  static void manufacturerGuidanceOpened(String manufacturer) =>
      _log('manufacturer_guidance_opened', {'manufacturer': manufacturer});

  static void batterySettingsOpened() =>
      _log('battery_settings_opened', {});

  // ── Internal ──────────────────────────────────────────────────

  static void _log(String event, [Map<String, dynamic>? parameters]) {
    if (kDebugMode) {
      debugPrint('[Analytics] $event ${parameters ?? ''}');
    }
    _backend?.logEvent(event, parameters);
  }
}

/// Abstraction for analytics backends.
///
/// Implement this to connect to Firebase Analytics, Mixpanel, Amplitude, etc.
abstract class AnalyticsBackend {
  void logEvent(String name, [Map<String, dynamic>? parameters]);
}

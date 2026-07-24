import 'package:flutter/foundation.dart';
import 'adhan_scheduler.dart';

/// Detects aggressive OEM battery management and provides guidance.
///
/// Some Android manufacturers kill background services aggressively.
/// This service identifies those manufacturers and provides device-specific
/// guidance to ensure the Adhan plays reliably.
///
/// Manufacturer is detected once per app launch via the native AdhanPlugin
/// channel and cached for the session lifetime.
class OEMReliabilityService {
  OEMReliabilityService._();

  /// Cached manufacturer string (lowercase, evaluated once per app launch).
  static String _manufacturer = '';
  static bool _initialized = false;

  /// Known aggressive OEMs that kill background services.
  static const _aggressiveOems = {
    'xiaomi',
    'redmi',
    'poco',
    'huawei',
    'honor',
    'oppo',
    'realme',
    'vivo',
    'oneplus',
    'samsung',
    'meizu',
    'lenovo',
    'asus',
  };

  /// Devices that don't require this guidance (stock Android or well-behaved).
  static const _exemptOems = {
    'google', // Pixel devices
    'nokia',
  };

  /// Initializes the service by reading the manufacturer from the native layer.
  /// Call once at app startup (e.g., in main() or a startup service).
  static Future<void> initialize() async {
    if (_initialized) return;
    try {
      _manufacturer = await AdhanScheduler.instance.getManufacturer();
    } catch (_) {
      _manufacturer = '';
    }
    _initialized = true;
    if (_manufacturer.isNotEmpty) {
      debugPrint('[OEMReliability] Manufacturer: $_manufacturer');
    }
  }

  /// The detected device manufacturer (lowercase).
  static String get manufacturer => _manufacturer;

  /// Whether this device requires OEM-specific battery guidance.
  static bool get needsGuidance {
    if (!_initialized) return false;
    final m = _manufacturer;
    if (m.isEmpty) return false;
    if (_exemptOems.contains(m)) return false;
    return _aggressiveOems.contains(m);
  }

  /// Returns guidance data for the detected OEM, or null if not needed.
  static OEMGuidance? get guidance {
    if (!needsGuidance) return null;
    return const OEMGuidance(
      title: 'تحسين عمل الأذان',
      message:
          'قد يقوم هاتفك بإيقاف التطبيق في الخلفية للحفاظ على البطارية.\n\n'
          'لضمان عمل الأذان دائماً، أضف التطبيق إلى التطبيقات غير المقيدة.',
      actionLabel: 'فتح إعدادات البطارية',
    );
  }

  /// Opens the device battery optimization settings.
  static Future<bool> openBatterySettings() =>
      AdhanScheduler.instance.openBatterySettings();
}

/// OEM guidance display data.
class OEMGuidance {
  final String title;
  final String message;
  final String actionLabel;

  const OEMGuidance({
    required this.title,
    required this.message,
    required this.actionLabel,
  });
}

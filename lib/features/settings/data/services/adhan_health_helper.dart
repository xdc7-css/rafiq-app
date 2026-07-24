import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../models/adhan_health_report.dart';

/// AdhanHealthHelper — Flutter bridge to the native AdhanHealthReporter.
///
/// Single entry point for the health diagnostics system.
class AdhanHealthHelper {
  static const _channel = MethodChannel('com.dailyislamicwidget/adhan');

  AdhanHealthHelper._();
  static final AdhanHealthHelper instance = AdhanHealthHelper._();

  /// Fetches the complete health report from the native module.
  Future<AdhanHealthReport> getHealthReport() async {
    if (kIsWeb) {
      return const AdhanHealthReport(
        checks: [],
        overallScore: 0,
        overallLevel: HealthLevel.unknown,
        timestamp: 0,
      );
    }
    try {
      final result = await _channel.invokeMethod<Map<dynamic, dynamic>>(
        'getAdhanHealthReport',
      );
      if (result == null) {
        return const AdhanHealthReport(
          checks: [],
          overallScore: 0,
          overallLevel: HealthLevel.unknown,
          timestamp: 0,
        );
      }
      return AdhanHealthReport.fromMap(result);
    } catch (e, st) {
      debugPrint('[AdhanHealthHelper] getHealthReport failed: $e\n$st');
      return const AdhanHealthReport(
        checks: [],
        overallScore: 0,
        overallLevel: HealthLevel.unknown,
        timestamp: 0,
      );
    }
  }
}

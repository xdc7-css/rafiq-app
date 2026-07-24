/// AdhanHealthReport — typed Dart models for the adhan health diagnostics system.
library;

/// Every field is nullable-safe with sensible defaults.
/// No raw Map usage outside of parsing.

/// Health status of a single check.
enum HealthStatus { healthy, warning, error, unknown }

/// Overall health level.
enum HealthLevel { excellent, good, needsAttention, critical, unknown }

/// A single health check item.
class HealthCheck {
  final String id;
  final String section;
  final String title;
  final HealthStatus status;
  final String value;
  final String description;
  final String recommendation;

  const HealthCheck({
    required this.id,
    required this.section,
    required this.title,
    required this.status,
    required this.value,
    required this.description,
    required this.recommendation,
  });

  factory HealthCheck.fromMap(Map<dynamic, dynamic> map) => HealthCheck(
        id: map['id'] as String? ?? '',
        section: map['section'] as String? ?? '',
        title: map['title'] as String? ?? '',
        status: _parseStatus(map['status'] as String?),
        value: map['value']?.toString() ?? '',
        description: map['description'] as String? ?? '',
        recommendation: map['recommendation'] as String? ?? '',
      );

  static HealthStatus _parseStatus(String? value) {
    switch (value) {
      case 'healthy':
        return HealthStatus.healthy;
      case 'warning':
        return HealthStatus.warning;
      case 'error':
        return HealthStatus.error;
      default:
        return HealthStatus.unknown;
    }
  }
}

/// Full health report from the native module.
class AdhanHealthReport {
  final List<HealthCheck> checks;
  final int overallScore;
  final HealthLevel overallLevel;
  final int timestamp;

  const AdhanHealthReport({
    required this.checks,
    required this.overallScore,
    required this.overallLevel,
    required this.timestamp,
  });

  factory AdhanHealthReport.fromMap(Map<dynamic, dynamic> map) {
    final checksRaw = map['checks'] as List<dynamic>? ?? [];
    return AdhanHealthReport(
      checks: checksRaw
          .map((e) => HealthCheck.fromMap(e as Map<dynamic, dynamic>))
          .toList(),
      overallScore: (map['overallScore'] as num?)?.toInt() ?? 0,
      overallLevel: _parseLevel(map['overallLevel'] as String?),
      timestamp: (map['timestamp'] as num?)?.toInt() ?? 0,
    );
  }

  static HealthLevel _parseLevel(String? value) {
    switch (value) {
      case 'excellent':
        return HealthLevel.excellent;
      case 'good':
        return HealthLevel.good;
      case 'needs_attention':
        return HealthLevel.needsAttention;
      case 'critical':
        return HealthLevel.critical;
      default:
        return HealthLevel.unknown;
    }
  }

  /// Checks grouped by section.
  Map<String, List<HealthCheck>> get checksBySection {
    final grouped = <String, List<HealthCheck>>{};
    for (final check in checks) {
      grouped.putIfAbsent(check.section, () => []).add(check);
    }
    return grouped;
  }

  /// Count of checks with each status.
  int get healthyCount => checks.where((c) => c.status == HealthStatus.healthy).length;
  int get warningCount => checks.where((c) => c.status == HealthStatus.warning).length;
  int get errorCount => checks.where((c) => c.status == HealthStatus.error).length;
  int get unknownCount => checks.where((c) => c.status == HealthStatus.unknown).length;

  /// Human-readable level label.
  String get levelLabel {
    switch (overallLevel) {
      case HealthLevel.excellent:
        return 'ممتاز';
      case HealthLevel.good:
        return 'جيد';
      case HealthLevel.needsAttention:
        return 'يحتاج انتباه';
      case HealthLevel.critical:
        return 'حرج';
      case HealthLevel.unknown:
        return 'غير معروف';
    }
  }
}

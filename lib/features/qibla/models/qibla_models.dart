import 'package:flutter/material.dart';

enum QiblaStatus {
  loading,
  ready,
  noSensor,
  noPermission,
  permanentlyDenied,
  noGps,
  error,
}

class QiblaData {
  final QiblaStatus status;
  final double heading;
  final double qiblah;
  final double offset;
  final double? latitude;
  final double? longitude;
  final String? city;
  final String? country;
  final String? errorMessage;

  const QiblaData({
    this.status = QiblaStatus.loading,
    this.heading = 0,
    this.qiblah = 0,
    this.offset = 0,
    this.latitude,
    this.longitude,
    this.city,
    this.country,
    this.errorMessage,
  });

  bool get isAligned {
    if (status != QiblaStatus.ready) return false;
    final diff = (heading - offset).abs() % 360;
    final angularDiff = diff > 180 ? 360 - diff : diff;
    return angularDiff < 3.0;
  }

  double get angularDifference {
    final diff = (heading - offset).abs() % 360;
    return diff > 180 ? 360 - diff : diff;
  }

  double get alignmentProgress {
    return (1.0 - (angularDifference / 90.0)).clamp(0.0, 1.0);
  }

  QiblaData copyWith({
    QiblaStatus? status,
    double? heading,
    double? qiblah,
    double? offset,
    double? latitude,
    double? longitude,
    String? city,
    String? country,
    String? errorMessage,
  }) {
    return QiblaData(
      status: status ?? this.status,
      heading: heading ?? this.heading,
      qiblah: qiblah ?? this.qiblah,
      offset: offset ?? this.offset,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      city: city ?? this.city,
      country: country ?? this.country,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class QiblaColors {
  QiblaColors._();

  static const Color background = Color(0xFF081326);
  static const Color surface = Color(0xFF11264E);
  static const Color card = Color(0xFF172D4A);
  static const Color gold = Color(0xFFD8A83A);
  static const Color lightGold = Color(0xFFF3CF72);
  static const Color success = Color(0xFF43D17B);
  static const Color danger = Color(0xFFF45B69);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB7C2D0);

  static const Color goldDark = Color(0xFF8B6914);
  static const Color goldDeep = Color(0xFF4A3A0F);
  static const Color compassFace = Color(0xFF0A1628);
  static const Color compassRing = Color(0xFF1A2F4D);

  static Color get cardBorder => gold.withValues(alpha: 0.15);
  static Color get surfaceBorder => gold.withValues(alpha: 0.10);
  static Color get glowGold => gold.withValues(alpha: 0.25);
  static Color get glowSuccess => success.withValues(alpha: 0.30);

  static const LinearGradient goldGradient = LinearGradient(
    colors: [gold, lightGold],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [success, Color(0xFF2ECC71)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

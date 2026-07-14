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

  static const Color primary = Color(0xFF1E2A78);
  static const Color secondary = Color(0xFF3E5FE0);
  static const Color accentGold = Color(0xFFD4AF37);
  static const Color background = Color(0xFFF8F5EF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color success = Color(0xFF2E7D32);

  // Compass-specific dark palette (luxury brass aesthetic)
  static const Color compassBg = Color(0xFF0B1730);
  static const Color compassBgDeep = Color(0xFF060D1A);
  static const Color compassBgMid = Color(0xFF0F1E38);
  static const Color compassDial = Color(0xFF0A1428);
  static const Color goldLight = Color(0xFFF7E08B);
  static const Color goldDark = Color(0xFF6E5315);
  static const Color goldDeep = Color(0xFF4A3A0F);
  static const Color brassHighlight = Color(0xFFC9A84C);
  static const Color brassShadow = Color(0xFF3D2E0A);
}

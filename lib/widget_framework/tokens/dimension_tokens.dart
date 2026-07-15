import 'package:flutter/material.dart';

/// Widget dimension tokens — radius, elevation, shadow, border values.
abstract final class WidgetDimensionTokens {
  // ════════════════════════════════════════════════════════════════════════
  // BORDER RADIUS
  // ════════════════════════════════════════════════════════════════════════

  static const double radiusNone = 0.0;
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 20.0;
  static const double radiusXxl = 24.0;
  static const double radiusLuxury = 28.0;
  static const double radiusFull = 999.0;

  /// Standard widget corner radius.
  static const double widgetRadius = radiusLg;

  /// Compact widget corner radius (2x2).
  static const double widgetRadiusCompact = radiusMd;

  /// Large widget corner radius (4x4).
  static const double widgetRadiusLarge = radiusXxl;

  /// Pill shape for badges and chips.
  static const double pillRadius = radiusFull;

  /// Circular shape for avatars and icons.
  static const double circleRadius = radiusFull;

  // ════════════════════════════════════════════════════════════════════════
  // ELEVATION
  // ════════════════════════════════════════════════════════════════════════

  static const double elevationNone = 0.0;
  static const double elevationLow = 1.0;
  static const double elevationMedium = 4.0;
  static const double elevationHigh = 8.0;
  static const double elevationMax = 16.0;

  // ════════════════════════════════════════════════════════════════════════
  // SHADOWS
  // ════════════════════════════════════════════════════════════════════════

  /// Standard luxury shadow — gold glow.
  static const List<BoxShadow> shadowLuxury = [
    BoxShadow(
      color: Color(0x40000000),
      blurRadius: 40,
      offset: Offset(0, 16),
      spreadRadius: 0,
    ),
  ];

  /// Subtle card shadow.
  static const List<BoxShadow> shadowCard = [
    BoxShadow(
      color: Color(0x30000000),
      blurRadius: 20,
      offset: Offset(0, 8),
      spreadRadius: 0,
    ),
  ];

  /// Elevated shadow — lifted elements.
  static const List<BoxShadow> shadowElevated = [
    BoxShadow(
      color: Color(0x4D000000),
      blurRadius: 24,
      offset: Offset(0, 12),
      spreadRadius: 0,
    ),
  ];

  /// Gold glow shadow — accent elements.
  static const List<BoxShadow> shadowGoldGlow = [
    BoxShadow(
      color: Color(0x33D4AF37),
      blurRadius: 20,
      offset: Offset(0, 4),
      spreadRadius: 0,
    ),
  ];

  /// Inner shadow simulation — inset glow.
  static const List<BoxShadow> shadowInset = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 8,
      offset: Offset(0, 2),
      spreadRadius: -2,
    ),
  ];

  /// None shadow.
  static const List<BoxShadow> shadowNone = [];

  // ════════════════════════════════════════════════════════════════════════
  // BORDERS
  // ════════════════════════════════════════════════════════════════════════

  static const double borderWidthNone = 0.0;
  static const double borderWidthThin = 0.5;
  static const double borderWidthRegular = 1.0;
  static const double borderWidthMedium = 1.5;
  static const double borderWidthThick = 2.0;

  /// Standard widget border (gold, subtle).
  static Border get borderWidget => Border.all(
        color: const Color(0x33D4AF37),
        width: borderWidthRegular,
      );

  /// Gold accent border.
  static Border get borderGold => Border.all(
        color: const Color(0xFFD4AF37),
        width: borderWidthMedium,
      );

  /// Subtle divider border.
  static Border get borderSubtle => Border.all(
        color: const Color(0x1AD4AF37),
        width: borderWidthThin,
      );

  // ════════════════════════════════════════════════════════════════════════
  // ICON SIZES
  // ════════════════════════════════════════════════════════════════════════

  static const double iconMicro = 10.0;
  static const double iconSmall = 14.0;
  static const double iconMedium = 18.0;
  static const double iconLarge = 24.0;
  static const double iconXl = 32.0;
  static const double iconXxl = 48.0;

  // ════════════════════════════════════════════════════════════════════════
  // BLUR
  // ════════════════════════════════════════════════════════════════════════

  static const double blurNone = 0.0;
  static const double blurLight = 4.0;
  static const double blurMedium = 10.0;
  static const double blurHeavy = 20.0;
  static const double blurMax = 40.0;

  /// Standard glass blur.
  static double get blurGlass => blurMedium;

  /// Heavy background blur.
  static double get blurBackground => blurHeavy;
}

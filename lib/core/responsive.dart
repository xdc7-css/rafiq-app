import 'package:flutter/material.dart';

/// Centralized responsive utility for proportional sizing across screen sizes.
///
/// Reference design: 390×844 (iPhone 13).
/// All values scale relative to screen width.
class Responsive {
  Responsive._();

  // ─── Reference Dimensions ───
  static const double _refWidth = 390.0;
  static const double _refHeight = 844.0;

  // ─── Screen Info ───
  static double width(BuildContext context) => MediaQuery.sizeOf(context).width;
  static double height(BuildContext context) => MediaQuery.sizeOf(context).height;

  /// Scale factor relative to reference width (390px).
  static double scaleX(BuildContext context) => width(context) / _refWidth;

  /// Scale factor relative to reference height (844px).
  static double scaleY(BuildContext context) => height(context) / _refHeight;

  /// Uniform scale (uses the smaller axis to prevent overflow).
  static double scale(BuildContext context) {
    final sx = scaleX(context);
    final sy = scaleY(context);
    return sx < sy ? sx : sy;
  }

  // ─── Breakpoints ───
  static bool isSmall(BuildContext context) => width(context) < 370;
  static bool isMedium(BuildContext context) {
    final w = width(context);
    return w >= 370 && w < 420;
  }
  static bool isLarge(BuildContext context) => width(context) >= 420;

  // ─── Proportional Sizing ───

  /// Scale a value proportionally to screen width.
  /// Usage: Responsive.size(context, 24) → 24 on 390px, ~22 on 360px, ~26 on 420px
  static double size(BuildContext context, double base) => base * scaleX(context);

  /// Scale a vertical value proportionally to screen height.
  static double sizeV(BuildContext context, double base) => base * scaleY(context);

  /// Scale using the smaller axis (safe for both dimensions).
  static double sizeSafe(BuildContext context, double base) => base * scale(context);

  // ─── Common Responsive Values ───

  /// Horizontal page margin (16 on 360px, 20 on 390px, ~22 on 420px).
  static double pageMarginH(BuildContext context) => size(context, 20);

  /// Top page margin.
  static double pageMarginTop(BuildContext context) => size(context, 16);

  /// Bottom page margin (for nav bar clearance).
  static double pageMarginBottom(BuildContext context) => size(context, 24);

  /// Section gap between major content sections.
  static double sectionGap(BuildContext context) => size(context, 28);

  /// Card inner padding.
  static double cardPadding(BuildContext context) => size(context, 18);

  /// Card border radius.
  static double cardRadius(BuildContext context) => size(context, 24);

  // ─── Typography Scaling ───

  /// Scale a font size with a softer curve (0.85× to 1.0×).
  /// This prevents text from getting too large on big screens or too small on small ones.
  static double fontSize(BuildContext context, double base) {
    final sx = scaleX(context);
    // Softer scaling: clamp between 0.85 and 1.05 of base
    final factor = 0.85 + (sx - 0.92).clamp(-0.1, 0.2) * 0.5;
    return base * factor.clamp(0.85, 1.05);
  }

  // ─── Specific Layout Helpers ───

  /// Quick action grid cross-axis count based on screen width.
  static int quickActionColumns(BuildContext context) {
    final w = width(context);
    if (w < 360) return 3;
    if (w < 480) return 4;
    return 4;
  }

  /// Quick action icon size.
  static double quickActionIconSize(BuildContext context) => size(context, 40);

  /// Floating dock height.
  static double dockHeight(BuildContext context) => size(context, 68);

  /// Bottom sheet max height fraction.
  static double bottomSheetMaxHeight(BuildContext context) {
    final h = height(context);
    if (h < 600) return 0.75;
    return 0.65;
  }

  /// Responsive padding that adapts to screen width.
  static EdgeInsets pagePadding(BuildContext context) {
    final m = pageMarginH(context);
    return EdgeInsets.symmetric(horizontal: m);
  }

  /// Responsive horizontal + vertical padding.
  static EdgeInsets cardMargin(BuildContext context) {
    final m = size(context, 16);
    return EdgeInsets.symmetric(horizontal: m, vertical: size(context, 6));
  }
}

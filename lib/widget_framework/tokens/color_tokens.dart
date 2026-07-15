import 'package:flutter/material.dart';

/// Widget color tokens — semantic color definitions for all widgets.
///
/// These tokens are the ONLY source of color values in widget rendering.
/// Every widget references tokens; no hardcoded colors allowed.
///
/// Token hierarchy:
///   Foundation → Surface → Content → Accent → State → Semantic
///
/// Mirror in Kotlin: WidgetKeys.kt does NOT hold visual tokens.
/// Android widgets receive resolved color ints via SharedPreferences.
abstract final class WidgetColorTokens {
  // ════════════════════════════════════════════════════════════════════════
  // FOUNDATION — Deepest background layers
  // ════════════════════════════════════════════════════════════════════════

  /// Deepest background — full bleed behind widget.
  static const Color foundationPrimary = Color(0xFF0B1730);

  /// Secondary foundation — slightly lifted.
  static const Color foundationSecondary = Color(0xFF111A33);

  /// Tertiary foundation — deepest accent zone.
  static const Color foundationTertiary = Color(0xFF06101D);

  // ════════════════════════════════════════════════════════════════════════
  // SURFACE — Card, section, and container backgrounds
  // ════════════════════════════════════════════════════════════════════════

  /// Primary surface — card backgrounds.
  static const Color surfacePrimary = Color(0xFF16233E);

  /// Elevated surface — lifted cards, hover states.
  static const Color surfaceElevated = Color(0xFF1B2946);

  /// Muted surface — secondary cards, list items.
  static const Color surfaceMuted = Color(0xFF132341);

  /// Interactive surface — tappable areas.
  static const Color surfaceInteractive = Color(0xFF172C4E);

  /// Overlay surface — modals, sheets, popups.
  static const Color surfaceOverlay = Color(0xFF1B3158);

  /// Glass surface — translucent overlay.
  static const Color surfaceGlass = Color(0x1A16233E);

  // ════════════════════════════════════════════════════════════════════════
  // CONTENT — Text and icon colors
  // ════════════════════════════════════════════════════════════════════════

  /// Primary text — headings, main content.
  static const Color contentPrimary = Color(0xFFFFFFFF);

  /// Secondary text — descriptions, body.
  static const Color contentSecondary = Color(0xFFD4DBE7);

  /// Tertiary text — captions, hints, timestamps.
  static const Color contentTertiary = Color(0xFFAEB8C8);

  /// Muted text — disabled, placeholder.
  static const Color contentMuted = Color(0x73FFFFFF);

  /// Disabled text — fully disabled elements.
  static const Color contentDisabled = Color(0x73FFFFFF);

  // ════════════════════════════════════════════════════════════════════════
  // ACCENT — Gold system (the luxury signature)
  // ════════════════════════════════════════════════════════════════════════

  /// Primary gold — the signature accent.
  static const Color accentGold = Color(0xFFD4AF37);

  /// Warm gold — warmer variant for emphasis.
  static const Color accentGoldWarm = Color(0xFFD9B96E);

  /// Bright gold — highlights, active states.
  static const Color accentGoldBright = Color(0xFFE5C97F);

  /// Light gold — subtle accents, backgrounds.
  static const Color accentGoldLight = Color(0xFFF0D896);

  /// Dark gold — pressed states, borders.
  static const Color accentGoldDark = Color(0xFFB8860B);

  /// Secondary gold — alternative accent.
  static const Color accentGoldSecondary = Color(0xFFC99A1A);

  // ════════════════════════════════════════════════════════════════════════
  // ACCENT — Extended palette (feature-specific)
  // ════════════════════════════════════════════════════════════════════════

  /// Emerald — Quran, growth, life.
  static const Color accentEmerald = Color(0xFF2ECC71);

  /// Deep emerald — darker variant.
  static const Color accentEmeraldDeep = Color(0xFF27AE60);

  /// Sky blue — information, calm.
  static const Color accentSky = Color(0xFF64B5F6);

  /// Lavender — spiritual, gentle.
  static const Color accentLavender = Color(0xFFCE93D8);

  /// Coral — alerts, warmth.
  static const Color accentCoral = Color(0xFFFF8A65);

  /// Ruby — destructive, urgent.
  static const Color accentRuby = Color(0xFFCF6679);

  /// Deep ruby — stronger destructive.
  static const Color accentRubyDeep = Color(0xFFE74C3C);

  // ════════════════════════════════════════════════════════════════════════
  // BORDER — Separators and outlines
  // ════════════════════════════════════════════════════════════════════════

  /// Gold border — primary border for cards/sections.
  static const Color borderGold = Color(0x33D4AF37);

  /// Subtle border — dividers, separators.
  static const Color borderSubtle = Color(0x1AD4AF37);

  /// Strong border — focused, active elements.
  static const Color borderStrong = Color(0x66D4AF37);

  /// Interactive border — tappable outlines.
  static const Color borderInteractive = Color(0x40D4AF37);

  // ════════════════════════════════════════════════════════════════════════
  // STATE — Feedback colors
  // ════════════════════════════════════════════════════════════════════════

  /// Success state.
  static const Color stateSuccess = Color(0xFF2ECC71);

  /// Warning state.
  static const Color stateWarning = Color(0xFFF39C12);

  /// Error state.
  static const Color stateError = Color(0xFFE74C3C);

  /// Info state.
  static const Color stateInfo = Color(0xFF64B5F6);

  // ════════════════════════════════════════════════════════════════════════
  // GRADIENTS — Pre-defined gradient color sequences
  // ════════════════════════════════════════════════════════════════════════

  /// Gold gradient — top-left to bottom-right.
  static const LinearGradient gradientGold = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFD4AF37), Color(0xFFF2C94C)],
  );

  /// Background gradient — top to bottom.
  static const LinearGradient gradientBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0B1324), Color(0xFF111A33)],
  );

  /// Navy gradient — 4-stop depth gradient.
  static const LinearGradient gradientNavy = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF06101D),
      Color(0xFF081728),
      Color(0xFF0D1E36),
      Color(0xFF12284A),
    ],
  );

  /// Surface gradient — subtle card depth.
  static const LinearGradient gradientSurface = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF132341), Color(0xFF172C4E)],
  );

  /// Gold text gradient — for heading text.
  static const LinearGradient gradientGoldText = LinearGradient(
    colors: [Color(0xFFD4AF37), Color(0xFFF2C94C)],
  );

  /// Overlay gradient — top fade for readability.
  static const LinearGradient gradientOverlay = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xCC0B1730),
      Color(0x000B1730),
    ],
  );

  /// Radial gold glow — centered light burst.
  static const RadialGradient gradientGoldGlow = RadialGradient(
    center: Alignment.center,
    radius: 0.6,
    colors: [
      Color(0x33D4AF37),
      Color(0x00D4AF37),
    ],
  );

  // ════════════════════════════════════════════════════════════════════════
  // OPACITY LEVELS — Consistent alpha values
  // ════════════════════════════════════════════════════════════════════════

  static const double opacityFull = 1.0;
  static const double opacityHigh = 0.87;
  static const double opacityMedium = 0.72;
  static const double opacityLow = 0.54;
  static const double opacityMuted = 0.38;
  static const double opacityFaint = 0.20;
  static const double opacityGhost = 0.10;
  static const double opacityInvisible = 0.0;

  // ════════════════════════════════════════════════════════════════════════
  // HELPERS
  // ════════════════════════════════════════════════════════════════════════

  /// Resolves a color with a custom opacity (0.0 - 1.0).
  static Color withAlpha(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }

  /// Darkens a color by [amount] (0.0 - 1.0).
  static Color darken(Color color, [double amount = 0.1]) {
    final hsl = HSLColor.fromColor(color);
    final darkened = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return darkened.toColor();
  }

  /// Lightens a color by [amount] (0.0 - 1.0).
  static Color lighten(Color color, [double amount = 0.1]) {
    final hsl = HSLColor.fromColor(color);
    final lightened = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return lightened.toColor();
  }
}

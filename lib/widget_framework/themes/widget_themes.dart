import 'package:flutter/material.dart';
import 'widget_theme.dart';
import 'widget_color_scheme.dart';
import '../tokens/dimension_tokens.dart';

/// Built-in widget themes.
///
/// Each theme is a complete visual configuration. To add a new theme:
/// 1. Add a static const instance here (or in a separate file).
/// 2. Register it in [ThemeRegistry].
///
/// No widget rendering code changes required.
abstract final class WidgetThemes {
  // ════════════════════════════════════════════════════════════════════════
  // LUXURY GOLD — The default, premium navy + gold
  // ════════════════════════════════════════════════════════════════════════

  static const WidgetTheme luxuryGold = WidgetTheme(
    id: 'luxury_gold',
    name: 'Luxury Gold',
    description: 'Premium navy background with gold accents.',
    colors: WidgetColorScheme.defaults(),
    widgetRadius: 16,
    useGoldGlow: true,
  );

  // ════════════════════════════════════════════════════════════════════════
  // MIDNIGHT BLACK — Deep, near-black elegance
  // ════════════════════════════════════════════════════════════════════════

  static const WidgetTheme midnightBlack = WidgetTheme(
    id: 'midnight_black',
    name: 'Midnight Black',
    description: 'Near-black background with subtle gold.',
    colors: WidgetColorScheme(
      foundationPrimary: Color(0xFF050508),
      foundationSecondary: Color(0xFF0A0A0F),
      surfacePrimary: Color(0xFF111118),
      surfaceElevated: Color(0xFF1A1A24),
      surfaceMuted: Color(0xFF0E0E16),
      surfaceOverlay: Color(0xFF22222E),
      contentPrimary: Color(0xFFFFFFFF),
      contentSecondary: Color(0xFFB8B8C8),
      contentTertiary: Color(0xFF787888),
      contentMuted: Color(0x73FFFFFF),
      accentPrimary: Color(0xFFD4AF37),
      accentSecondary: Color(0xFFB8860B),
      accentWarm: Color(0xFFD9B96E),
      borderPrimary: Color(0x33D4AF37),
      borderSubtle: Color(0x1AD4AF37),
      stateSuccess: Color(0xFF2ECC71),
      stateWarning: Color(0xFFF39C12),
      stateError: Color(0xFFE74C3C),
      stateInfo: Color(0xFF64B5F6),
      gradientBackground: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF050508), Color(0xFF0A0A0F)],
      ),
      gradientSurface: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF111118), Color(0xFF1A1A24)],
      ),
      gradientAccent: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFD4AF37), Color(0xFFF2C94C)],
      ),
      gradientText: LinearGradient(
        colors: [Color(0xFFD4AF37), Color(0xFFF2C94C)],
      ),
    ),
    widgetRadius: 12,
    useGoldGlow: false,
  );

  // ════════════════════════════════════════════════════════════════════════
  // MINIMAL WHITE — Clean, light mode
  // ════════════════════════════════════════════════════════════════════════

  static const WidgetTheme minimalWhite = WidgetTheme(
    id: 'minimal_white',
    name: 'Minimal White',
    description: 'Clean white background with dark text.',
    colors: WidgetColorScheme(
      foundationPrimary: Color(0xFFF5F5F5),
      foundationSecondary: Color(0xFFEEEEEE),
      surfacePrimary: Color(0xFFFFFFFF),
      surfaceElevated: Color(0xFFF8F8F8),
      surfaceMuted: Color(0xFFF0F0F0),
      surfaceOverlay: Color(0xFFE8E8E8),
      contentPrimary: Color(0xFF1A1A2E),
      contentSecondary: Color(0xFF444455),
      contentTertiary: Color(0xFF888899),
      contentMuted: Color(0x731A1A2E),
      accentPrimary: Color(0xFFB8860B),
      accentSecondary: Color(0xFF8B6914),
      accentWarm: Color(0xFFD4AF37),
      borderPrimary: Color(0xFFB8860B),
      borderSubtle: Color(0x1AB8860B),
      stateSuccess: Color(0xFF27AE60),
      stateWarning: Color(0xFFF39C12),
      stateError: Color(0xFFE74C3C),
      stateInfo: Color(0xFF3498DB),
      gradientBackground: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFFFFFFF), Color(0xFFF5F5F5)],
      ),
      gradientSurface: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFFFFFFF), Color(0xFFF8F8F8)],
      ),
      gradientAccent: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFB8860B), Color(0xFFD4AF37)],
      ),
      gradientText: LinearGradient(
        colors: [Color(0xFFB8860B), Color(0xFF8B6914)],
      ),
    ),
    widgetRadius: 20,
    borderWidth: WidgetDimensionTokens.borderWidthThin,
    shadows: [],
    useGoldGlow: false,
  );

  // ════════════════════════════════════════════════════════════════════════
  // EMERALD — Rich green with gold
  // ════════════════════════════════════════════════════════════════════════

  static const WidgetTheme emerald = WidgetTheme(
    id: 'emerald',
    name: 'Emerald',
    description: 'Deep emerald green with gold accents.',
    colors: WidgetColorScheme(
      foundationPrimary: Color(0xFF0A1F14),
      foundationSecondary: Color(0xFF0E2A1A),
      surfacePrimary: Color(0xFF143D24),
      surfaceElevated: Color(0xFF1A4D30),
      surfaceMuted: Color(0xFF113520),
      surfaceOverlay: Color(0xFF1F5538),
      contentPrimary: Color(0xFFFFFFFF),
      contentSecondary: Color(0xFFC8E6D0),
      contentTertiary: Color(0xFF8FBE9A),
      contentMuted: Color(0x73FFFFFF),
      accentPrimary: Color(0xFF2ECC71),
      accentSecondary: Color(0xFF27AE60),
      accentWarm: Color(0xFFF0D896),
      borderPrimary: Color(0x332ECC71),
      borderSubtle: Color(0x1A2ECC71),
      stateSuccess: Color(0xFF2ECC71),
      stateWarning: Color(0xFFF39C12),
      stateError: Color(0xFFE74C3C),
      stateInfo: Color(0xFF64B5F6),
      gradientBackground: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF0A1F14), Color(0xFF0E2A1A)],
      ),
      gradientSurface: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF143D24), Color(0xFF1A4D30)],
      ),
      gradientAccent: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF2ECC71), Color(0xFFF0D896)],
      ),
      gradientText: LinearGradient(
        colors: [Color(0xFF2ECC71), Color(0xFF27AE60)],
      ),
    ),
    widgetRadius: 16,
    useGoldGlow: false,
  );

  // ════════════════════════════════════════════════════════════════════════
  // MODERN GLASS — Frosted glass effect
  // ════════════════════════════════════════════════════════════════════════

  static const WidgetTheme modernGlass = WidgetTheme(
    id: 'modern_glass',
    name: 'Modern Glass',
    description: 'Frosted glass with transparency.',
    colors: WidgetColorScheme(
      foundationPrimary: Color(0xFF0B1730),
      foundationSecondary: Color(0xFF111A33),
      surfacePrimary: Color(0x1A16233E),
      surfaceElevated: Color(0x221B2946),
      surfaceMuted: Color(0x14132341),
      surfaceOverlay: Color(0x2A1B3158),
      contentPrimary: Color(0xFFFFFFFF),
      contentSecondary: Color(0xFFD4DBE7),
      contentTertiary: Color(0xFFAEB8C8),
      contentMuted: Color(0x73FFFFFF),
      accentPrimary: Color(0xFFD4AF37),
      accentSecondary: Color(0xFFC99A1A),
      accentWarm: Color(0xFFD9B96E),
      borderPrimary: Color(0x40D4AF37),
      borderSubtle: Color(0x20D4AF37),
      stateSuccess: Color(0xFF2ECC71),
      stateWarning: Color(0xFFF39C12),
      stateError: Color(0xFFE74C3C),
      stateInfo: Color(0xFF64B5F6),
      gradientBackground: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xCC0B1730), Color(0xCC111A33)],
      ),
      gradientSurface: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0x1A16233E), Color(0x221B2946)],
      ),
      gradientAccent: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFD4AF37), Color(0xFFF2C94C)],
      ),
      gradientText: LinearGradient(
        colors: [Color(0xFFD4AF37), Color(0xFFF2C94C)],
      ),
    ),
    widgetRadius: 24,
    borderWidth: WidgetDimensionTokens.borderWidthThin,
    useGlassEffect: true,
    useGoldGlow: true,
  );

  // ════════════════════════════════════════════════════════════════════════
  // CLASSIC MUSHAF — Warm brown + cream
  // ════════════════════════════════════════════════════════════════════════

  static const WidgetTheme classicMushaf = WidgetTheme(
    id: 'classic_mushaf',
    name: 'Classic Mushaf',
    description: 'Warm brown and cream, inspired by mushaf pages.',
    colors: WidgetColorScheme(
      foundationPrimary: Color(0xFF1A120A),
      foundationSecondary: Color(0xFF231A10),
      surfacePrimary: Color(0xFF2C2117),
      surfaceElevated: Color(0xFF382C20),
      surfaceMuted: Color(0xFF251C14),
      surfaceOverlay: Color(0xFF42352A),
      contentPrimary: Color(0xFFFFF8EE),
      contentSecondary: Color(0xFFE8DCC8),
      contentTertiary: Color(0xFFB8A890),
      contentMuted: Color(0x73FFF8EE),
      accentPrimary: Color(0xFFD4AF37),
      accentSecondary: Color(0xFFC99A1A),
      accentWarm: Color(0xFFE5C97F),
      borderPrimary: Color(0x33D4AF37),
      borderSubtle: Color(0x1AD4AF37),
      stateSuccess: Color(0xFF2ECC71),
      stateWarning: Color(0xFFF39C12),
      stateError: Color(0xFFE74C3C),
      stateInfo: Color(0xFF64B5F6),
      gradientBackground: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF1A120A), Color(0xFF231A10)],
      ),
      gradientSurface: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF2C2117), Color(0xFF382C20)],
      ),
      gradientAccent: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFD4AF37), Color(0xFFF2C94C)],
      ),
      gradientText: LinearGradient(
        colors: [Color(0xFFD4AF37), Color(0xFFE5C97F)],
      ),
    ),
    widgetRadius: 16,
    usePatternOverlay: true,
  );
}

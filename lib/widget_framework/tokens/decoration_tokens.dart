import 'package:flutter/material.dart';
import 'color_tokens.dart';

/// Widget decoration tokens — gradients, patterns, and composite decorations.
abstract final class WidgetDecorationTokens {
  // ════════════════════════════════════════════════════════════════════════
  // CONTAINER DECORATIONS — Ready-to-use BoxDecoration presets
  // ════════════════════════════════════════════════════════════════════════

  /// Standard widget card — dark surface with subtle border.
  static BoxDecoration get cardDefault => BoxDecoration(
        color: WidgetColorTokens.surfacePrimary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: WidgetColorTokens.borderSubtle,
          width: 0.5,
        ),
      );

  /// Elevated card — lifted surface with shadow.
  static BoxDecoration get cardElevated => BoxDecoration(
        color: WidgetColorTokens.surfaceElevated,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x30000000),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      );

  /// Glass card — translucent with border.
  static BoxDecoration get cardGlass => BoxDecoration(
        color: WidgetColorTokens.surfaceGlass,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: WidgetColorTokens.borderSubtle,
          width: 0.5,
        ),
      );

  /// Gradient card — navy gradient with gold border.
  static BoxDecoration get cardGradient => BoxDecoration(
        gradient: WidgetColorTokens.gradientSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: WidgetColorTokens.borderGold,
          width: 0.5,
        ),
      );

  /// Gold accented card — gradient background with gold glow.
  static BoxDecoration get cardGoldAccent => BoxDecoration(
        gradient: WidgetColorTokens.gradientSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: WidgetColorTokens.borderGold,
          width: 1.0,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22D4AF37),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      );

  /// Flat card — no shadow, minimal border.
  static BoxDecoration get cardFlat => BoxDecoration(
        color: WidgetColorTokens.surfaceMuted,
        borderRadius: BorderRadius.circular(12),
      );

  // ════════════════════════════════════════════════════════════════════════
  // SECTION DECORATIONS
  // ════════════════════════════════════════════════════════════════════════

  /// Section header background.
  static BoxDecoration get sectionHeader => BoxDecoration(
        color: WidgetColorTokens.surfaceMuted,
        borderRadius: BorderRadius.circular(8),
      );

  /// Divider with gold gradient.
  static BoxDecoration get goldDivider => const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0x00D4AF37),
            Color(0xFFD4AF37),
            Color(0x00D4AF37),
          ],
        ),
      );

  /// Badge background — gold gradient pill.
  static BoxDecoration get badgeGold => BoxDecoration(
        gradient: WidgetColorTokens.gradientGold,
        borderRadius: BorderRadius.circular(999),
      );

  /// Progress track background.
  static BoxDecoration get progressTrack => BoxDecoration(
        color: WidgetColorTokens.surfaceMuted,
        borderRadius: BorderRadius.circular(999),
      );

  // ════════════════════════════════════════════════════════════════════════
  // OVERLAY DECORATIONS
  // ════════════════════════════════════════════════════════════════════════

  /// Top overlay gradient — fades dark from top.
  static BoxDecoration get overlayTop => const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xCC0B1730), Color(0x000B1730)],
        ),
      );

  /// Bottom overlay gradient — fades dark from bottom.
  static BoxDecoration get overlayBottom => const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Color(0xCC0B1730), Color(0x000B1730)],
        ),
      );

  /// Gold glow overlay — centered radial.
  static BoxDecoration get goldGlow => const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 0.6,
          colors: [Color(0x33D4AF37), Color(0x00D4AF37)],
        ),
      );

  // ════════════════════════════════════════════════════════════════════════
  // PATTERN LAYERS — Islamic pattern overlays (Flutter side)
  // ════════════════════════════════════════════════════════════════════════

  /// Subtle dot pattern overlay.
  static BoxDecoration get patternDots => BoxDecoration(
        color: WidgetColorTokens.surfacePrimary,
        image: const DecorationImage(
          image: AssetImage('assets/widgets/pattern_dots.png'),
          repeat: ImageRepeat.repeat,
          opacity: 0.05,
          scale: 1.0,
        ),
        borderRadius: BorderRadius.circular(16),
      );

  /// Islamic geometric pattern overlay.
  static BoxDecoration get patternGeometric => BoxDecoration(
        color: WidgetColorTokens.surfacePrimary,
        image: const DecorationImage(
          image: AssetImage('assets/widgets/pattern_geometric.png'),
          repeat: ImageRepeat.repeat,
          opacity: 0.03,
          scale: 1.0,
        ),
        borderRadius: BorderRadius.circular(16),
      );

  // ════════════════════════════════════════════════════════════════════════
  // BUILDERS — Create decorations with overrides
  // ════════════════════════════════════════════════════════════════════════

  /// Builds a card decoration with customizable parameters.
  static BoxDecoration buildCard({
    Color? background,
    Gradient? gradient,
    double borderRadius = 16,
    Border? border,
    List<BoxShadow>? shadows,
  }) {
    return BoxDecoration(
      color: gradient == null ? background : null,
      gradient: gradient,
      borderRadius: BorderRadius.circular(borderRadius),
      border: border,
      boxShadow: shadows,
    );
  }

  /// Builds a pill decoration.
  static BoxDecoration buildPill({
    Color? background,
    Gradient? gradient,
  }) {
    return BoxDecoration(
      color: gradient == null ? background : null,
      gradient: gradient,
      borderRadius: BorderRadius.circular(999),
    );
  }
}

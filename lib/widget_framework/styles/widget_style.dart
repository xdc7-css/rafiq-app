import 'package:flutter/material.dart';
import '../themes/widget_theme.dart';

/// Base font size used for computing [fontSizeScale].
const double _kBaseFontSize = 14.0;

/// Glass blur sigma when enabled.
const double _kGlassBlurSigma = 10.0;

/// Default shadow list for widgets.
const List<BoxShadow> _kDefaultShadows = [
  BoxShadow(
    color: Color(0x30000000),
    blurRadius: 20,
    offset: Offset(0, 8),
  ),
];

/// The resolved visual style for a single widget instance.
///
/// A [WidgetStyle] is computed by merging a [WidgetTheme] with
/// per-widget overrides from [WidgetConfig]. Every widget receives
/// exactly one [WidgetStyle] at render time.
///
/// This is the ONLY object widgets read for visual properties.
/// No widget reads from [WidgetTheme], [WidgetColorTokens], or
/// hardcoded values directly.
///
/// This class is immutable.
@immutable
class WidgetStyle {
  // ════════════════════════════════════════════════════════════════════════
  // COLORS — Resolved color scheme
  // ════════════════════════════════════════════════════════════════════════

  final Color background;
  final Gradient? backgroundGradient;
  final Color surface;
  final Color surfaceElevated;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color accent;
  final Color accentSecondary;
  final Color border;
  final Color divider;

  // ════════════════════════════════════════════════════════════════════════
  // SHAPE
  // ════════════════════════════════════════════════════════════════════════

  final double borderRadius;
  final Border? borderStyle;
  final List<BoxShadow> _shadows;

  /// Immutable shadow list.
  List<BoxShadow> get shadows => List.unmodifiable(_shadows);

  // ════════════════════════════════════════════════════════════════════════
  // EFFECTS
  // ════════════════════════════════════════════════════════════════════════

  final double opacity;
  final double blur;
  final bool useGlassEffect;
  final bool usePatternOverlay;
  final bool useGoldGlow;

  // ════════════════════════════════════════════════════════════════════════
  // SPACING
  // ════════════════════════════════════════════════════════════════════════

  final double paddingH;
  final double paddingV;
  final double contentGap;
  final double sectionGap;

  // ════════════════════════════════════════════════════════════════════════
  // TYPOGRAPHY
  // ════════════════════════════════════════════════════════════════════════

  final double fontSizeScale;

  WidgetStyle({
    required this.background,
    this.backgroundGradient,
    required this.surface,
    required this.surfaceElevated,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.accent,
    required this.accentSecondary,
    required this.border,
    required this.divider,
    required this.borderRadius,
    this.borderStyle,
    List<BoxShadow> shadows = _kDefaultShadows,
    this.opacity = 1.0,
    this.blur = 0.0,
    this.useGlassEffect = false,
    this.usePatternOverlay = false,
    this.useGoldGlow = false,
    this.paddingH = 12,
    this.paddingV = 12,
    this.contentGap = 12,
    this.sectionGap = 24,
    this.fontSizeScale = 1.0,
  }) : _shadows = List<BoxShadow>.unmodifiable(shadows);

  /// Default style from the luxury gold theme.
  const WidgetStyle.defaults()
      : background = const Color(0xFF0B1730),
        backgroundGradient = null,
        surface = const Color(0xFF16233E),
        surfaceElevated = const Color(0xFF1B2946),
        textPrimary = Colors.white,
        textSecondary = const Color(0xFFD4DBE7),
        textMuted = const Color(0xFFAEB8C8),
        accent = const Color(0xFFD4AF37),
        accentSecondary = const Color(0xFFC99A1A),
        border = const Color(0x33D4AF37),
        divider = const Color(0x1AD4AF37),
        borderRadius = 16,
        borderStyle = null,
        _shadows = _kDefaultShadows,
        opacity = 1.0,
        blur = 0.0,
        useGlassEffect = false,
        usePatternOverlay = false,
        useGoldGlow = false,
        paddingH = 12,
        paddingV = 12,
        contentGap = 12,
        sectionGap = 24,
        fontSizeScale = 1.0;

  /// Creates a copy with selective overrides.
  WidgetStyle copyWith({
    Color? background,
    Gradient? backgroundGradient,
    bool clearGradient = false,
    Color? surface,
    Color? surfaceElevated,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? accent,
    Color? accentSecondary,
    Color? border,
    Color? divider,
    double? borderRadius,
    Border? borderStyle,
    bool clearBorder = false,
    List<BoxShadow>? shadows,
    double? opacity,
    double? blur,
    bool? useGlassEffect,
    bool? usePatternOverlay,
    bool? useGoldGlow,
    double? paddingH,
    double? paddingV,
    double? contentGap,
    double? sectionGap,
    double? fontSizeScale,
  }) {
    return WidgetStyle(
      background: background ?? this.background,
      backgroundGradient:
          clearGradient ? null : (backgroundGradient ?? this.backgroundGradient),
      surface: surface ?? this.surface,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      accent: accent ?? this.accent,
      accentSecondary: accentSecondary ?? this.accentSecondary,
      border: border ?? this.border,
      divider: divider ?? this.divider,
      borderRadius: borderRadius ?? this.borderRadius,
      borderStyle: clearBorder ? null : (borderStyle ?? this.borderStyle),
      shadows: shadows ?? List.unmodifiable(_shadows),
      opacity: opacity ?? this.opacity,
      blur: blur ?? this.blur,
      useGlassEffect: useGlassEffect ?? this.useGlassEffect,
      usePatternOverlay: usePatternOverlay ?? this.usePatternOverlay,
      useGoldGlow: useGoldGlow ?? this.useGoldGlow,
      paddingH: paddingH ?? this.paddingH,
      paddingV: paddingV ?? this.paddingV,
      contentGap: contentGap ?? this.contentGap,
      sectionGap: sectionGap ?? this.sectionGap,
      fontSizeScale: fontSizeScale ?? this.fontSizeScale,
    );
  }

  // ════════════════════════════════════════════════════════════════════════
  // FACTORY — Build from theme + config overrides
  // ════════════════════════════════════════════════════════════════════════

  /// Resolves a [WidgetStyle] from a [WidgetTheme] plus optional overrides.
  factory WidgetStyle.resolve(
    WidgetTheme theme, {
    double? opacityOverride,
    double? fontSizeOverride,
    double? borderRadiusOverride,
    Color? backgroundOverride,
    Color? accentOverride,
  }) {
    final c = theme.colors;
    return WidgetStyle(
      background: backgroundOverride ?? c.foundationPrimary,
      backgroundGradient: theme.useGlassEffect ? null : c.gradientBackground,
      surface: c.surfacePrimary,
      surfaceElevated: c.surfaceElevated,
      textPrimary: c.contentPrimary,
      textSecondary: c.contentSecondary,
      textMuted: c.contentTertiary,
      accent: accentOverride ?? c.accentPrimary,
      accentSecondary: c.accentSecondary,
      border: c.borderPrimary,
      divider: c.borderSubtle,
      borderRadius: borderRadiusOverride ?? theme.widgetRadius,
      borderStyle: Border.all(color: c.borderPrimary, width: theme.borderWidth),
      shadows: theme.shadows,
      opacity: opacityOverride ?? 1.0,
      blur: theme.useGlassEffect ? _kGlassBlurSigma : 0.0,
      useGlassEffect: theme.useGlassEffect,
      usePatternOverlay: theme.usePatternOverlay,
      useGoldGlow: theme.useGoldGlow,
      fontSizeScale: fontSizeOverride != null
          ? fontSizeOverride / _kBaseFontSize
          : 1.0,
    );
  }

  // ════════════════════════════════════════════════════════════════════════
  // HELPERS — Computed text styles
  // ════════════════════════════════════════════════════════════════════════

  /// The BoxDecoration for the widget's main container.
  BoxDecoration get containerDecoration => BoxDecoration(
        color: backgroundGradient == null ? background : null,
        gradient: backgroundGradient,
        borderRadius: BorderRadius.circular(borderRadius),
        border: borderStyle,
        boxShadow: _shadows,
      );

  /// The TextStyle for the title.
  TextStyle get titleStyle => TextStyle(
        fontSize: 20 * fontSizeScale,
        fontWeight: FontWeight.w700,
        color: textPrimary,
        height: 1.2,
      );

  /// The TextStyle for subtitles.
  TextStyle get subtitleStyle => TextStyle(
        fontSize: 16 * fontSizeScale,
        fontWeight: FontWeight.w500,
        color: textSecondary,
        height: 1.4,
      );

  /// The TextStyle for body text.
  TextStyle get bodyStyle => TextStyle(
        fontSize: 14 * fontSizeScale,
        fontWeight: FontWeight.w400,
        color: textSecondary,
        height: 1.4,
      );

  /// The TextStyle for captions.
  TextStyle get captionStyle => TextStyle(
        fontSize: 12 * fontSizeScale,
        fontWeight: FontWeight.w400,
        color: textMuted,
        height: 1.4,
      );

  /// The TextStyle for large numbers (tasbih, countdown).
  TextStyle get numberStyle => TextStyle(
        fontSize: 48 * fontSizeScale,
        fontWeight: FontWeight.w700,
        color: textPrimary,
        height: 1.1,
      );

  /// The TextStyle for accent/gold text.
  TextStyle get accentStyle => TextStyle(
        fontSize: 14 * fontSizeScale,
        fontWeight: FontWeight.w600,
        color: accent,
        height: 1.4,
      );

  // ════════════════════════════════════════════════════════════════════════
  // EQUALITY
  // ════════════════════════════════════════════════════════════════════════

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WidgetStyle &&
          runtimeType == other.runtimeType &&
          background == other.background &&
          backgroundGradient == other.backgroundGradient &&
          surface == other.surface &&
          surfaceElevated == other.surfaceElevated &&
          textPrimary == other.textPrimary &&
          textSecondary == other.textSecondary &&
          textMuted == other.textMuted &&
          accent == other.accent &&
          accentSecondary == other.accentSecondary &&
          border == other.border &&
          divider == other.divider &&
          borderRadius == other.borderRadius &&
          opacity == other.opacity &&
          blur == other.blur &&
          useGlassEffect == other.useGlassEffect &&
          usePatternOverlay == other.usePatternOverlay &&
          useGoldGlow == other.useGoldGlow &&
          paddingH == other.paddingH &&
          paddingV == other.paddingV &&
          contentGap == other.contentGap &&
          sectionGap == other.sectionGap &&
          fontSizeScale == other.fontSizeScale;

  @override
  int get hashCode => Object.hashAll([
        background,
        backgroundGradient,
        surface,
        surfaceElevated,
        textPrimary,
        textSecondary,
        textMuted,
        accent,
        accentSecondary,
        border,
        divider,
        borderRadius,
        opacity,
        blur,
        useGlassEffect,
        usePatternOverlay,
        useGoldGlow,
        paddingH,
        paddingV,
        contentGap,
        sectionGap,
        fontSizeScale,
      ]);

  @override
  String toString() => 'WidgetStyle(accent: $accent, radius: $borderRadius)';
}

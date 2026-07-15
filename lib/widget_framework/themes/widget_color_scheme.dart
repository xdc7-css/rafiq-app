import 'package:flutter/material.dart';
import '../tokens/color_tokens.dart';

/// A complete widget color scheme.
///
/// Every widget receives a [WidgetColorScheme] that defines all colors
/// it needs. Widgets NEVER reference [WidgetColorTokens] directly —
/// they use the scheme, which may be a theme override or the default.
@immutable
class WidgetColorScheme {
  final Color foundationPrimary;
  final Color foundationSecondary;
  final Color surfacePrimary;
  final Color surfaceElevated;
  final Color surfaceMuted;
  final Color surfaceOverlay;
  final Color contentPrimary;
  final Color contentSecondary;
  final Color contentTertiary;
  final Color contentMuted;
  final Color accentPrimary;
  final Color accentSecondary;
  final Color accentWarm;
  final Color borderPrimary;
  final Color borderSubtle;
  final Color stateSuccess;
  final Color stateWarning;
  final Color stateError;
  final Color stateInfo;
  final LinearGradient gradientBackground;
  final LinearGradient gradientSurface;
  final LinearGradient gradientAccent;
  final LinearGradient gradientText;

  const WidgetColorScheme({
    required this.foundationPrimary,
    required this.foundationSecondary,
    required this.surfacePrimary,
    required this.surfaceElevated,
    required this.surfaceMuted,
    required this.surfaceOverlay,
    required this.contentPrimary,
    required this.contentSecondary,
    required this.contentTertiary,
    required this.contentMuted,
    required this.accentPrimary,
    required this.accentSecondary,
    required this.accentWarm,
    required this.borderPrimary,
    required this.borderSubtle,
    required this.stateSuccess,
    required this.stateWarning,
    required this.stateError,
    required this.stateInfo,
    required this.gradientBackground,
    required this.gradientSurface,
    required this.gradientAccent,
    required this.gradientText,
  });

  /// Default luxury navy + gold scheme — matches AppTheme.
  const WidgetColorScheme.defaults()
      : foundationPrimary = WidgetColorTokens.foundationPrimary,
        foundationSecondary = WidgetColorTokens.foundationSecondary,
        surfacePrimary = WidgetColorTokens.surfacePrimary,
        surfaceElevated = WidgetColorTokens.surfaceElevated,
        surfaceMuted = WidgetColorTokens.surfaceMuted,
        surfaceOverlay = WidgetColorTokens.surfaceOverlay,
        contentPrimary = WidgetColorTokens.contentPrimary,
        contentSecondary = WidgetColorTokens.contentSecondary,
        contentTertiary = WidgetColorTokens.contentTertiary,
        contentMuted = WidgetColorTokens.contentMuted,
        accentPrimary = WidgetColorTokens.accentGold,
        accentSecondary = WidgetColorTokens.accentGoldSecondary,
        accentWarm = WidgetColorTokens.accentGoldWarm,
        borderPrimary = WidgetColorTokens.borderGold,
        borderSubtle = WidgetColorTokens.borderSubtle,
        stateSuccess = WidgetColorTokens.stateSuccess,
        stateWarning = WidgetColorTokens.stateWarning,
        stateError = WidgetColorTokens.stateError,
        stateInfo = WidgetColorTokens.stateInfo,
        gradientBackground = WidgetColorTokens.gradientBackground,
        gradientSurface = WidgetColorTokens.gradientSurface,
        gradientAccent = WidgetColorTokens.gradientGold,
        gradientText = WidgetColorTokens.gradientGoldText;

  /// Creates a copy with selective overrides.
  WidgetColorScheme copyWith({
    Color? foundationPrimary,
    Color? foundationSecondary,
    Color? surfacePrimary,
    Color? surfaceElevated,
    Color? surfaceMuted,
    Color? surfaceOverlay,
    Color? contentPrimary,
    Color? contentSecondary,
    Color? contentTertiary,
    Color? contentMuted,
    Color? accentPrimary,
    Color? accentSecondary,
    Color? accentWarm,
    Color? borderPrimary,
    Color? borderSubtle,
    Color? stateSuccess,
    Color? stateWarning,
    Color? stateError,
    Color? stateInfo,
    LinearGradient? gradientBackground,
    LinearGradient? gradientSurface,
    LinearGradient? gradientAccent,
    LinearGradient? gradientText,
  }) {
    return WidgetColorScheme(
      foundationPrimary: foundationPrimary ?? this.foundationPrimary,
      foundationSecondary:
          foundationSecondary ?? this.foundationSecondary,
      surfacePrimary: surfacePrimary ?? this.surfacePrimary,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      surfaceMuted: surfaceMuted ?? this.surfaceMuted,
      surfaceOverlay: surfaceOverlay ?? this.surfaceOverlay,
      contentPrimary: contentPrimary ?? this.contentPrimary,
      contentSecondary: contentSecondary ?? this.contentSecondary,
      contentTertiary: contentTertiary ?? this.contentTertiary,
      contentMuted: contentMuted ?? this.contentMuted,
      accentPrimary: accentPrimary ?? this.accentPrimary,
      accentSecondary: accentSecondary ?? this.accentSecondary,
      accentWarm: accentWarm ?? this.accentWarm,
      borderPrimary: borderPrimary ?? this.borderPrimary,
      borderSubtle: borderSubtle ?? this.borderSubtle,
      stateSuccess: stateSuccess ?? this.stateSuccess,
      stateWarning: stateWarning ?? this.stateWarning,
      stateError: stateError ?? this.stateError,
      stateInfo: stateInfo ?? this.stateInfo,
      gradientBackground: gradientBackground ?? this.gradientBackground,
      gradientSurface: gradientSurface ?? this.gradientSurface,
      gradientAccent: gradientAccent ?? this.gradientAccent,
      gradientText: gradientText ?? this.gradientText,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WidgetColorScheme &&
          runtimeType == other.runtimeType &&
          foundationPrimary == other.foundationPrimary &&
          foundationSecondary == other.foundationSecondary &&
          surfacePrimary == other.surfacePrimary &&
          surfaceElevated == other.surfaceElevated &&
          surfaceMuted == other.surfaceMuted &&
          surfaceOverlay == other.surfaceOverlay &&
          contentPrimary == other.contentPrimary &&
          contentSecondary == other.contentSecondary &&
          contentTertiary == other.contentTertiary &&
          contentMuted == other.contentMuted &&
          accentPrimary == other.accentPrimary &&
          accentSecondary == other.accentSecondary &&
          accentWarm == other.accentWarm &&
          borderPrimary == other.borderPrimary &&
          borderSubtle == other.borderSubtle &&
          stateSuccess == other.stateSuccess &&
          stateWarning == other.stateWarning &&
          stateError == other.stateError &&
          stateInfo == other.stateInfo &&
          gradientBackground == other.gradientBackground &&
          gradientSurface == other.gradientSurface &&
          gradientAccent == other.gradientAccent &&
          gradientText == other.gradientText;

  @override
  int get hashCode => Object.hashAll([
        foundationPrimary,
        foundationSecondary,
        surfacePrimary,
        surfaceElevated,
        surfaceMuted,
        surfaceOverlay,
        contentPrimary,
        contentSecondary,
        contentTertiary,
        contentMuted,
        accentPrimary,
        accentSecondary,
        accentWarm,
        borderPrimary,
        borderSubtle,
        stateSuccess,
        stateWarning,
        stateError,
        stateInfo,
        gradientBackground,
        gradientSurface,
        gradientAccent,
        gradientText,
      ]);

  @override
  String toString() => 'WidgetColorScheme(accent: $accentPrimary)';
}

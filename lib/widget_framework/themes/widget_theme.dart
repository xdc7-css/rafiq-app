import 'package:flutter/material.dart';
import 'widget_color_scheme.dart';

/// A complete widget theme — the single configuration object that
/// defines every visual aspect of a widget family.
///
/// Themes are COMPOSABLE: start from a base and override specific parts.
/// Adding a new theme = creating a new [WidgetTheme] instance. Zero code
/// changes needed in widget rendering logic.
@immutable
class WidgetTheme {
  final String id;
  final String name;
  final String description;
  final WidgetColorScheme colors;
  final double widgetRadius;
  final double borderWidth;
  final Color borderColor;
  final List<BoxShadow> shadows;
  final bool useGlassEffect;
  final bool usePatternOverlay;
  final bool useGoldGlow;

  const WidgetTheme({
    required this.id,
    required this.name,
    this.description = '',
    required this.colors,
    this.widgetRadius = 16,
    this.borderWidth = 1,
    this.borderColor = const Color(0x33D4AF37),
    this.shadows = const [
      BoxShadow(
        color: Color(0x30000000),
        blurRadius: 20,
        offset: Offset(0, 8),
      ),
    ],
    this.useGlassEffect = false,
    this.usePatternOverlay = false,
    this.useGoldGlow = false,
  });

  /// Creates a copy with selective overrides.
  WidgetTheme copyWith({
    String? id,
    String? name,
    String? description,
    WidgetColorScheme? colors,
    double? widgetRadius,
    double? borderWidth,
    Color? borderColor,
    List<BoxShadow>? shadows,
    bool? useGlassEffect,
    bool? usePatternOverlay,
    bool? useGoldGlow,
  }) {
    return WidgetTheme(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      colors: colors ?? this.colors,
      widgetRadius: widgetRadius ?? this.widgetRadius,
      borderWidth: borderWidth ?? this.borderWidth,
      borderColor: borderColor ?? this.borderColor,
      shadows: shadows ?? this.shadows,
      useGlassEffect: useGlassEffect ?? this.useGlassEffect,
      usePatternOverlay: usePatternOverlay ?? this.usePatternOverlay,
      useGoldGlow: useGoldGlow ?? this.useGoldGlow,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WidgetTheme &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'WidgetTheme($id)';
}

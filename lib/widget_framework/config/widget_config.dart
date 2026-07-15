import 'dart:convert';
import 'package:flutter/material.dart';

/// Widget configuration model — stores every customization option
/// for a widget instance.
///
/// This is the persistent, serializable representation. It gets
/// stored in SharedPreferences and read by both Flutter (preview)
/// and Kotlin (RemoteViews rendering).
///
/// # Extensibility
/// New fields can be added with defaults without breaking existing
/// configs. The [extra] map absorbs any future key-value pairs.
@immutable
class WidgetConfig {
  /// The widget type identifier (e.g., 'prayer_times', 'quran', 'tasbih').
  final String widgetType;

  /// Theme ID — resolved via [ThemeRegistry.getById].
  final String themeId;

  /// Background color override (null = use theme default).
  final int? backgroundColor;

  /// Text color override (null = use theme default).
  final int? textColor;

  /// Accent color override (null = use theme default).
  final int? accentColor;

  /// Font size override in logical pixels (null = use theme default).
  final double? fontSize;

  /// Transparency override 0.0–1.0 (null = fully opaque).
  final double? transparency;

  /// Border radius override (null = use theme default).
  final double? borderRadius;

  /// Widget layout style ('standard', 'compact', 'minimal').
  final String layoutStyle;

  /// Display mode ('default', 'minimal', 'detailed').
  final String displayMode;

  /// Whether the widget is RTL.
  final bool rtl;

  /// Animation preferences.
  final bool animationsEnabled;

  /// Background image path (null = no image).
  final String? backgroundImage;

  /// Pattern overlay ID (null = no pattern).
  final String? patternId;

  /// Whether to use glassmorphism effect.
  final bool glassEffect;

  /// Whether to use Material You dynamic colors.
  final bool materialYou;

  /// Custom font family name (null = use theme default).
  final String? fontFamily;

  /// Text shadow enabled.
  final bool textShadow;

  /// Letter spacing override (null = use theme default).
  final double? letterSpacing;

  /// Line height override (null = use theme default).
  final double? lineHeight;

  /// Widget alignment ('top', 'center', 'bottom').
  final String verticalAlignment;

  /// Gradient angle in degrees (null = use theme default).
  final double? gradientAngle;

  /// Stroke/border opacity override (null = use theme default).
  final double? strokeOpacity;

  /// Custom additional properties for future extension.
  final Map<String, dynamic> extra;

  const WidgetConfig({
    required this.widgetType,
    this.themeId = 'luxury_gold',
    this.backgroundColor,
    this.textColor,
    this.accentColor,
    this.fontSize,
    this.transparency,
    this.borderRadius,
    this.layoutStyle = 'standard',
    this.displayMode = 'default',
    this.rtl = false,
    this.animationsEnabled = true,
    this.backgroundImage,
    this.patternId,
    this.glassEffect = false,
    this.materialYou = false,
    this.fontFamily,
    this.textShadow = false,
    this.letterSpacing,
    this.lineHeight,
    this.verticalAlignment = 'center',
    this.gradientAngle,
    this.strokeOpacity,
    this.extra = const {},
  });

  /// Default config for any widget type.
  factory WidgetConfig.defaults(String widgetType) {
    return WidgetConfig(widgetType: widgetType);
  }

  /// Creates a copy with selective overrides.
  WidgetConfig copyWith({
    String? widgetType,
    String? themeId,
    int? backgroundColor,
    bool clearBackground = false,
    int? textColor,
    bool clearText = false,
    int? accentColor,
    bool clearAccent = false,
    double? fontSize,
    bool clearFontSize = false,
    double? transparency,
    double? borderRadius,
    bool clearBorderRadius = false,
    String? layoutStyle,
    String? displayMode,
    bool? rtl,
    bool? animationsEnabled,
    String? backgroundImage,
    bool clearBackgroundImage = false,
    String? patternId,
    bool clearPattern = false,
    bool? glassEffect,
    bool? materialYou,
    String? fontFamily,
    bool clearFontFamily = false,
    bool? textShadow,
    double? letterSpacing,
    bool clearLetterSpacing = false,
    double? lineHeight,
    bool clearLineHeight = false,
    String? verticalAlignment,
    double? gradientAngle,
    bool clearGradientAngle = false,
    double? strokeOpacity,
    bool clearStrokeOpacity = false,
    Map<String, dynamic>? extra,
  }) {
    return WidgetConfig(
      widgetType: widgetType ?? this.widgetType,
      themeId: themeId ?? this.themeId,
      backgroundColor:
          clearBackground ? null : (backgroundColor ?? this.backgroundColor),
      textColor: clearText ? null : (textColor ?? this.textColor),
      accentColor: clearAccent ? null : (accentColor ?? this.accentColor),
      fontSize: clearFontSize ? null : (fontSize ?? this.fontSize),
      transparency: transparency ?? this.transparency,
      borderRadius:
          clearBorderRadius ? null : (borderRadius ?? this.borderRadius),
      layoutStyle: layoutStyle ?? this.layoutStyle,
      displayMode: displayMode ?? this.displayMode,
      rtl: rtl ?? this.rtl,
      animationsEnabled: animationsEnabled ?? this.animationsEnabled,
      backgroundImage:
          clearBackgroundImage ? null : (backgroundImage ?? this.backgroundImage),
      patternId: clearPattern ? null : (patternId ?? this.patternId),
      glassEffect: glassEffect ?? this.glassEffect,
      materialYou: materialYou ?? this.materialYou,
      fontFamily: clearFontFamily ? null : (fontFamily ?? this.fontFamily),
      textShadow: textShadow ?? this.textShadow,
      letterSpacing:
          clearLetterSpacing ? null : (letterSpacing ?? this.letterSpacing),
      lineHeight: clearLineHeight ? null : (lineHeight ?? this.lineHeight),
      verticalAlignment: verticalAlignment ?? this.verticalAlignment,
      gradientAngle:
          clearGradientAngle ? null : (gradientAngle ?? this.gradientAngle),
      strokeOpacity:
          clearStrokeOpacity ? null : (strokeOpacity ?? this.strokeOpacity),
      extra: extra ?? this.extra,
    );
  }

  // ════════════════════════════════════════════════════════════════════════
  // SERIALIZATION — SharedPreferences compatibility
  // ════════════════════════════════════════════════════════════════════════

  /// Serializes to a JSON string for SharedPreferences storage.
  String toJson() => jsonEncode(toMap());

  /// Converts to a Map.
  Map<String, dynamic> toMap() => {
        'widgetType': widgetType,
        'themeId': themeId,
        if (backgroundColor != null) 'backgroundColor': backgroundColor,
        if (textColor != null) 'textColor': textColor,
        if (accentColor != null) 'accentColor': accentColor,
        if (fontSize != null) 'fontSize': fontSize,
        if (transparency != null) 'transparency': transparency,
        if (borderRadius != null) 'borderRadius': borderRadius,
        'layoutStyle': layoutStyle,
        'displayMode': displayMode,
        'rtl': rtl,
        'animationsEnabled': animationsEnabled,
        if (backgroundImage != null) 'backgroundImage': backgroundImage,
        if (patternId != null) 'patternId': patternId,
        'glassEffect': glassEffect,
        'materialYou': materialYou,
        if (fontFamily != null) 'fontFamily': fontFamily,
        'textShadow': textShadow,
        if (letterSpacing != null) 'letterSpacing': letterSpacing,
        if (lineHeight != null) 'lineHeight': lineHeight,
        'verticalAlignment': verticalAlignment,
        if (gradientAngle != null) 'gradientAngle': gradientAngle,
        if (strokeOpacity != null) 'strokeOpacity': strokeOpacity,
        if (extra.isNotEmpty) 'extra': extra,
      };

  /// Deserializes from a JSON string.
  factory WidgetConfig.fromJson(String json) {
    return WidgetConfig.fromMap(jsonDecode(json) as Map<String, dynamic>);
  }

  /// Deserializes from a Map.
  factory WidgetConfig.fromMap(Map<String, dynamic> map) {
    return WidgetConfig(
      widgetType: map['widgetType'] as String? ?? 'unknown',
      themeId: map['themeId'] as String? ?? 'luxury_gold',
      backgroundColor: map['backgroundColor'] as int?,
      textColor: map['textColor'] as int?,
      accentColor: map['accentColor'] as int?,
      fontSize: (map['fontSize'] as num?)?.toDouble(),
      transparency: (map['transparency'] as num?)?.toDouble(),
      borderRadius: (map['borderRadius'] as num?)?.toDouble(),
      layoutStyle: map['layoutStyle'] as String? ?? 'standard',
      displayMode: map['displayMode'] as String? ?? 'default',
      rtl: map['rtl'] as bool? ?? false,
      animationsEnabled: map['animationsEnabled'] as bool? ?? true,
      backgroundImage: map['backgroundImage'] as String?,
      patternId: map['patternId'] as String?,
      glassEffect: map['glassEffect'] as bool? ?? false,
      materialYou: map['materialYou'] as bool? ?? false,
      fontFamily: map['fontFamily'] as String?,
      textShadow: map['textShadow'] as bool? ?? false,
      letterSpacing: (map['letterSpacing'] as num?)?.toDouble(),
      lineHeight: (map['lineHeight'] as num?)?.toDouble(),
      verticalAlignment: map['verticalAlignment'] as String? ?? 'center',
      gradientAngle: (map['gradientAngle'] as num?)?.toDouble(),
      strokeOpacity: (map['strokeOpacity'] as num?)?.toDouble(),
      extra: Map<String, dynamic>.from(
          map['extra'] as Map<String, dynamic>? ?? {}),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WidgetConfig &&
          runtimeType == other.runtimeType &&
          widgetType == other.widgetType &&
          themeId == other.themeId &&
          backgroundColor == other.backgroundColor &&
          textColor == other.textColor &&
          accentColor == other.accentColor &&
          fontSize == other.fontSize &&
          transparency == other.transparency &&
          borderRadius == other.borderRadius &&
          layoutStyle == other.layoutStyle &&
          displayMode == other.displayMode &&
          rtl == other.rtl &&
          animationsEnabled == other.animationsEnabled &&
          backgroundImage == other.backgroundImage &&
          patternId == other.patternId &&
          glassEffect == other.glassEffect &&
          materialYou == other.materialYou &&
          fontFamily == other.fontFamily &&
          textShadow == other.textShadow &&
          letterSpacing == other.letterSpacing &&
          lineHeight == other.lineHeight &&
          verticalAlignment == other.verticalAlignment &&
          gradientAngle == other.gradientAngle &&
          strokeOpacity == other.strokeOpacity;

  @override
  int get hashCode => Object.hashAll([
        widgetType,
        themeId,
        backgroundColor,
        textColor,
        accentColor,
        fontSize,
        transparency,
        borderRadius,
        layoutStyle,
        displayMode,
        rtl,
        animationsEnabled,
        backgroundImage,
        patternId,
        glassEffect,
        materialYou,
        fontFamily,
        textShadow,
        letterSpacing,
        lineHeight,
        verticalAlignment,
        gradientAngle,
        strokeOpacity,
      ]);

  @override
  String toString() =>
      'WidgetConfig(type: $widgetType, theme: $themeId)';
}

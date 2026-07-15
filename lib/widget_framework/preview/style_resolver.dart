import 'package:flutter/material.dart';
import '../themes/widget_theme.dart';
import '../themes/theme_registry.dart';
import '../styles/widget_style.dart';
import '../config/widget_config.dart';
import '../layout/widget_layout.dart';

/// Secondary text alpha when user overrides primary text color.
const double _kSecondaryTextAlpha = 0.85;

/// Default opacity when no transparency is configured.
const double _kDefaultOpacity = 1.0;

/// Resolves the complete rendering pipeline:
///
///   WidgetConfig → WidgetTheme → WidgetStyle
///
/// This is the single entry point that widget preview screens call.
/// It ensures every widget gets its style from the same resolution
/// logic, whether it's a Flutter preview or a Kotlin RemoteViews render.
class StyleResolver {
  StyleResolver._();

  /// Resolves a [WidgetStyle] from a [WidgetConfig].
  ///
  /// 1. Looks up the [WidgetTheme] by [WidgetConfig.themeId].
  /// 2. Creates a base [WidgetStyle] from the theme.
  /// 3. Applies all config overrides in a single copyWith call.
  static WidgetStyle resolve(WidgetConfig config) {
    // Step 1: Resolve theme
    final theme = ThemeRegistry.getById(config.themeId);

    // Step 2: Base style from theme
    var style = WidgetStyle.resolve(
      theme,
      opacityOverride: config.transparency != null
          ? _kDefaultOpacity - config.transparency!
          : null,
      fontSizeOverride: config.fontSize,
      borderRadiusOverride: config.borderRadius,
    );

    // Step 3: Apply ALL config overrides in a single copyWith to avoid
    // sequential allocations. Each copyWith creates a new object, so
    // batching is essential for performance.
    style = style.copyWith(
      background: config.backgroundColor != null
          ? Color(config.backgroundColor!)
          : null,
      clearGradient: config.backgroundColor != null,
      textPrimary: config.textColor != null ? Color(config.textColor!) : null,
      textSecondary: config.textColor != null
          ? Color(config.textColor!).withValues(alpha: _kSecondaryTextAlpha)
          : null,
      accent:
          config.accentColor != null ? Color(config.accentColor!) : null,
      useGlassEffect: config.glassEffect ? true : null,
    );

    return style;
  }

  /// Resolves the layout constraints for a given widget size.
  static WidgetLayoutConstraints resolveLayout(
    WidgetSize size, {
    bool rtl = false,
  }) {
    return WidgetLayoutConstraints(size: size, rtl: rtl);
  }

  /// Convenience: resolves both style and layout from config + size.
  static ({WidgetStyle style, WidgetLayoutConstraints layout})
      resolveAll(
    WidgetConfig config,
    WidgetSize size, {
    bool rtl = false,
  }) {
    return (
      style: resolve(config),
      layout: resolveLayout(size, rtl: rtl),
    );
  }
}

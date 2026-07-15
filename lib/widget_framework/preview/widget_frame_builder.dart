import 'package:flutter/material.dart';
import '../styles/widget_style.dart';
import '../layout/widget_layout.dart';
import '../components/background_layer.dart';

/// Builds the standard widget wrapper — applies background, border,
/// radius, padding, and optional glass/overlay effects.
///
/// Every widget preview wraps its content in this builder.
/// This ensures consistent visual treatment across all widgets.
class WidgetFrameBuilder {
  WidgetFrameBuilder._();

  /// Wraps [child] in the standard widget container.
  static Widget build({
    required WidgetStyle style,
    required WidgetLayoutConstraints layout,
    required Widget child,
  }) {
    return Directionality(
      textDirection: layout.rtl ? TextDirection.rtl : TextDirection.ltr,
      child: SizedBox(
        width: layout.width,
        height: layout.height,
        child: BackgroundLayer(
          style: style,
          child: Padding(
            padding: EdgeInsets.all(layout.size.suggestedPadding),
            child: child,
          ),
        ),
      ),
    );
  }

  /// Wraps [child] with a standard widget container and clip.
  static Widget buildClipped({
    required WidgetStyle style,
    required WidgetLayoutConstraints layout,
    required Widget child,
  }) {
    return Directionality(
      textDirection: layout.rtl ? TextDirection.rtl : TextDirection.ltr,
      child: SizedBox(
        width: layout.width,
        height: layout.height,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(style.borderRadius),
          child: BackgroundLayer(
            style: style,
            child: Padding(
              padding: EdgeInsets.all(layout.size.suggestedPadding),
              child: child,
            ),
          ),
        ),
      ),
    );
  }

  /// Builds a preview card with shadow for the settings screen.
  static Widget buildPreview({
    required WidgetStyle style,
    required WidgetLayoutConstraints layout,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(style.borderRadius + 4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(style.borderRadius + 4),
        child: buildClipped(
          style: style,
          layout: layout,
          child: child,
        ),
      ),
    );
  }
}

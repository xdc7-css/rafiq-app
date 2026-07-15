import 'dart:ui';
import 'package:flutter/material.dart';
import '../styles/widget_style.dart';

/// Background layer — applies gradient, pattern, and glass effects.
/// Wraps any widget to give it the theme's background treatment.
class BackgroundLayer extends StatelessWidget {
  final WidgetStyle style;
  final Widget child;
  final double? borderRadius;

  const BackgroundLayer({
    super.key,
    required this.style,
    required this.child,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? style.borderRadius;
    final r = BorderRadius.circular(radius);

    Widget content = child;

    // Apply glass blur if enabled and the computed blur sigma is positive
    if (style.useGlassEffect && style.blur > 0) {
      content = ClipRRect(
        borderRadius: r,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: style.blur,
            sigmaY: style.blur,
          ),
          child: content,
        ),
      );
    }

    return Container(
      decoration: style.containerDecoration,
      child: content,
    );
  }
}

/// Overlay layer — adds a gradient overlay for readability.
/// Uses [WidgetStyle] colors for the gradient stops.
class OverlayLayer extends StatelessWidget {
  final WidgetStyle style;
  final Widget child;

  const OverlayLayer({
    super.key,
    required this.style,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Gradient overlay using style's textPrimary color at low opacity
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  style.textPrimary.withValues(alpha: 0.4),
                  style.background.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ),
        // Content
        child,
      ],
    );
  }
}

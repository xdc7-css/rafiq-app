import 'package:flutter/material.dart';
import '../styles/widget_style.dart';

/// Divider component — horizontal line with optional gradient.
class WidgetDivider extends StatelessWidget {
  final WidgetStyle style;
  final double height;
  final bool useGradient;

  const WidgetDivider({
    super.key,
    required this.style,
    this.height = 1,
    this.useGradient = false,
  });

  @override
  Widget build(BuildContext context) {
    if (useGradient) {
      return Container(
        height: height,
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              style.divider.withValues(alpha: 0),
              style.accent.withValues(alpha: 0.4),
              style.divider.withValues(alpha: 0),
            ],
          ),
        ),
      );
    }

    return Container(
      height: height,
      margin: const EdgeInsets.symmetric(vertical: 4),
      color: style.divider,
    );
  }
}

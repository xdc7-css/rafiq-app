import 'package:flutter/material.dart';
import '../styles/widget_style.dart';

/// Icon container component — styled icon with optional background.
class WidgetIcon extends StatelessWidget {
  final WidgetStyle style;
  final IconData icon;
  final double? size;
  final Color? color;
  final bool withBackground;
  final double? backgroundSize;

  const WidgetIcon({
    super.key,
    required this.style,
    required this.icon,
    this.size,
    this.color,
    this.withBackground = false,
    this.backgroundSize,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize = size ?? 18;
    final bgColor = color ?? style.accent;

    if (!withBackground) {
      return Icon(icon, size: iconSize, color: bgColor);
    }

    final bgRadius = backgroundSize ?? iconSize * 1.8;
    return Container(
      width: bgRadius,
      height: bgRadius,
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: 0.15),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: iconSize, color: bgColor),
    );
  }
}

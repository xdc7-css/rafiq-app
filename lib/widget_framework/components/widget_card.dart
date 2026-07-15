import 'package:flutter/material.dart';
import '../styles/widget_style.dart';

/// Base card component — the primary container for all widgets.
///
/// Every widget wraps its content in a [WidgetCard]. It applies
/// the [WidgetStyle]'s background, border, radius, and shadow.
class WidgetCard extends StatelessWidget {
  final WidgetStyle style;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final VoidCallback? onTap;

  const WidgetCard({
    super.key,
    required this.style,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: width,
        height: height,
        margin: margin,
        padding: padding ??
            EdgeInsets.symmetric(
              horizontal: style.paddingH,
              vertical: style.paddingV,
            ),
        decoration: style.containerDecoration,
        child: Opacity(opacity: style.opacity, child: child),
      ),
    );
  }
}

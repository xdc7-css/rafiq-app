import 'package:flutter/material.dart';
import '../styles/widget_style.dart';

/// Badge component — small labeled chip for counts, labels, etc.
class WidgetBadge extends StatelessWidget {
  final WidgetStyle style;
  final String text;
  final bool isGold;
  final double? fontSize;

  const WidgetBadge({
    super.key,
    required this.style,
    required this.text,
    this.isGold = false,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isGold ? style.accent : style.surface;
    final textColor = isGold ? Colors.white : style.textSecondary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: (fontSize ?? 10) * style.fontSizeScale,
          fontWeight: FontWeight.w600,
          color: textColor,
          height: 1.2,
        ),
      ),
    );
  }
}

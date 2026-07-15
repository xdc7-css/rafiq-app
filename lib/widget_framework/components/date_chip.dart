import 'package:flutter/material.dart';
import '../styles/widget_style.dart';

/// Date chip — displays Hijri or Gregorian date in a compact badge.
class DateChip extends StatelessWidget {
  final WidgetStyle style;
  final String text;
  final bool isActive;
  final IconData? icon;

  const DateChip({
    super.key,
    required this.style,
    required this.text,
    this.isActive = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? style.accent.withValues(alpha: 0.15)
            : style.surface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: isActive ? style.accent : style.border,
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 12,
              color: isActive ? style.accent : style.textMuted,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: 11 * style.fontSizeScale,
              fontWeight: FontWeight.w500,
              color: isActive ? style.accent : style.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

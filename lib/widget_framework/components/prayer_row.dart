import 'package:flutter/material.dart';
import '../styles/widget_style.dart';
import '../tokens/spacing_tokens.dart';

/// Prayer row component — displays a single prayer time with name,
/// time, and optional highlight (for next prayer).
class PrayerRow extends StatelessWidget {
  final WidgetStyle style;
  final String name;
  final String time;
  final bool isNext;
  final bool isHighlighted;
  final IconData? icon;

  const PrayerRow({
    super.key,
    required this.style,
    required this.name,
    required this.time,
    this.isNext = false,
    this.isHighlighted = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final nameColor = isHighlighted ? style.accent : style.textPrimary;
    final timeColor = isNext ? style.accent : style.textPrimary;
    final bgColor = isHighlighted
        ? style.accent.withValues(alpha: 0.08)
        : Colors.transparent;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: WidgetSpacingTokens.xs,
        vertical: WidgetSpacingTokens.xxs,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: nameColor),
            const SizedBox(width: WidgetSpacingTokens.xs),
          ],
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontSize: 13 * style.fontSizeScale,
                fontWeight: isNext ? FontWeight.w600 : FontWeight.w400,
                color: nameColor,
              ),
              maxLines: 1,
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 13 * style.fontSizeScale,
              fontWeight: FontWeight.w600,
              color: timeColor,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../styles/widget_style.dart';
import '../tokens/spacing_tokens.dart';

/// Header component — icon + title + optional trailing widget.
class WidgetHeader extends StatelessWidget {
  final WidgetStyle style;
  final IconData? icon;
  final String title;
  final Widget? trailing;
  final String? subtitle;

  const WidgetHeader({
    super.key,
    required this.style,
    this.icon,
    required this.title,
    this.trailing,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18, color: style.accent),
          const SizedBox(width: WidgetSpacingTokens.xs),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: style.titleStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style: style.captionStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../styles/widget_style.dart';

/// Footer component — small text row at the bottom of a widget.
class WidgetFooter extends StatelessWidget {
  final WidgetStyle style;
  final String text;
  final Widget? child;

  const WidgetFooter({
    super.key,
    required this.style,
    required this.text,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            text,
            style: style.captionStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (child != null) child!,
      ],
    );
  }
}

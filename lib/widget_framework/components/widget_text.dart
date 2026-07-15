import 'package:flutter/material.dart';
import '../styles/widget_style.dart';

/// Title text component — applies style's title formatting.
class WidgetTitle extends StatelessWidget {
  final WidgetStyle style;
  final String text;
  final int maxLines;
  final TextAlign? align;

  const WidgetTitle({
    super.key,
    required this.style,
    required this.text,
    this.maxLines = 1,
    this.align,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style.titleStyle,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      textAlign: align,
    );
  }
}

/// Subtitle text component.
class WidgetSubtitle extends StatelessWidget {
  final WidgetStyle style;
  final String text;
  final int maxLines;

  const WidgetSubtitle({
    super.key,
    required this.style,
    required this.text,
    this.maxLines = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style.subtitleStyle,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }
}

/// Body text component.
class WidgetBodyText extends StatelessWidget {
  final WidgetStyle style;
  final String text;
  final int maxLines;
  final TextAlign? align;

  const WidgetBodyText({
    super.key,
    required this.style,
    required this.text,
    this.maxLines = 3,
    this.align,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style.bodyStyle,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      textAlign: align,
    );
  }
}

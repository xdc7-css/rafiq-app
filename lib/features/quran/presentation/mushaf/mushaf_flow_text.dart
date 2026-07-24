import 'package:flutter/material.dart';
import 'mushaf_layout_engine.dart';

/// Renders the composed Mushaf text (ayah bodies + verse markers) as a
/// single [RichText] with gesture detection per ayah segment.
class MushafFlowText extends StatefulWidget {
  final MushafLayoutResult layout;
  final Color textColor;
  final void Function(int index)? onAyahTap;
  final void Function(int index)? onAyahLongPress;
  final void Function(int index)? onAyahDoubleTap;

  const MushafFlowText({
    super.key,
    required this.layout,
    required this.textColor,
    this.onAyahTap,
    this.onAyahLongPress,
    this.onAyahDoubleTap,
  });

  @override
  MushafFlowTextState createState() => MushafFlowTextState();
}

class MushafFlowTextState extends State<MushafFlowText> {
  final _textKey = GlobalKey();
  TextPainter? _painter;

  @override
  void didUpdateWidget(MushafFlowText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.layout != widget.layout) {
      _painter = null;
    }
  }

  TextPainter _getPainter() {
    if (_painter != null) return _painter!;
    _painter = TextPainter(
      text: widget.layout.rootSpan,
      textDirection: TextDirection.rtl,
      maxLines: null,
    );
    return _painter!;
  }

  /// Returns the ayah index (into `layout.segments`) at [localPosition], or null.
  int? ayahIndexAtLocal(Offset localPosition) {
    final renderObject = _textKey.currentContext?.findRenderObject();
    if (renderObject is! RenderBox) return null;

    final painter = _getPainter();
    painter.layout(maxWidth: renderObject.size.width);

    final textOffset = painter.getPositionForOffset(localPosition).offset;
    if (textOffset < 0) return null;

    final segments = widget.layout.segments;
    for (int i = 0; i < segments.length; i++) {
      if (segments[i].containsTextOffset(textOffset) ||
          segments[i].containsMarkerOffset(textOffset)) {
        return i;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: widget.onAyahTap != null
          ? (details) {
              final idx = ayahIndexAtLocal(details.localPosition);
              if (idx != null) widget.onAyahTap!(idx);
            }
          : null,
      onLongPressStart: widget.onAyahLongPress != null
          ? (details) {
              final idx = ayahIndexAtLocal(details.localPosition);
              if (idx != null) widget.onAyahLongPress!(idx);
            }
          : null,
      onDoubleTapDown: widget.onAyahDoubleTap != null
          ? (details) {
              final idx = ayahIndexAtLocal(details.localPosition);
              if (idx != null) widget.onAyahDoubleTap!(idx);
            }
          : null,
      child: RepaintBoundary(
        child: RichText(
          key: _textKey,
          text: widget.layout.rootSpan,
          textDirection: TextDirection.rtl,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _painter?.dispose();
    _painter = null;
    super.dispose();
  }
}

/// Calculates the scroll offset to bring [ayahIndex] into view.
///
/// Uses the layout's root span and a [TextPainter] to measure the
/// vertical position of the ayah's text start offset.
double? mushafScrollOffsetForAyah({
  required MushafLayoutResult layout,
  required int ayahIndex,
  required double contentMaxWidth,
}) {
  if (ayahIndex < 0 || ayahIndex >= layout.segments.length) return null;

  final segment = layout.segments[ayahIndex];
  final painter = TextPainter(
    text: layout.rootSpan,
    textDirection: TextDirection.rtl,
    maxLines: null,
  );
  painter.layout(maxWidth: contentMaxWidth);

  final textOffset = segment.textStart;
  if (textOffset > layout.plainText.length) return null;

  final position = painter.getOffsetForCaret(
    TextPosition(offset: textOffset),
    Rect.zero,
  );

  painter.dispose();
  return position.dy;
}

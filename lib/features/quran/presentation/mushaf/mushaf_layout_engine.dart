import 'package:flutter/material.dart';
import '../../../../models/api_models.dart';
import 'mushaf_constants.dart';
import 'mushaf_verse_marker.dart';

/// Maps a character offset in the composed plain-text buffer to an [AyahData].
class AyahTextSegment {
  final AyahData ayah;
  final int textStart;
  final int textEnd;
  final int markerStart;
  final int markerEnd;

  const AyahTextSegment({
    required this.ayah,
    required this.textStart,
    required this.textEnd,
    required this.markerStart,
    required this.markerEnd,
  });

  bool containsTextOffset(int offset) =>
      offset >= textStart && offset < textEnd;

  bool containsMarkerOffset(int offset) =>
      offset >= markerStart && offset < markerEnd;
}

class MushafLayoutResult {
  final InlineSpan rootSpan;
  final String plainText;
  final List<AyahTextSegment> segments;

  const MushafLayoutResult({
    required this.rootSpan,
    required this.plainText,
    required this.segments,
  });

  AyahData? ayahAtOffset(int offset) {
    for (final seg in segments) {
      if (seg.containsTextOffset(offset) || seg.containsMarkerOffset(offset)) {
        return seg.ayah;
      }
    }
    return null;
  }

  int? ayahIndexAtOffset(int offset) {
    for (int i = 0; i < segments.length; i++) {
      final seg = segments[i];
      if (seg.containsTextOffset(offset) || seg.containsMarkerOffset(offset)) {
        return i;
      }
    }
    return null;
  }
}

/// Builds continuous Mushaf text — ayah bodies as [TextSpan], markers as [WidgetSpan] only.
class MushafLayoutEngine {
  MushafLayoutResult build({
    required List<AyahData> ayahs,
    required TextStyle baseStyle,
    required Color textColor,
    int? highlightedAyah,
    int? selectedAyah,
    Set<int> bookmarkedAyahs = const {},
    void Function(int numberInSurah)? onMarkerTap,
  }) {
    final buffer = StringBuffer();
    final segments = <AyahTextSegment>[];
    final children = <InlineSpan>[];

    for (int i = 0; i < ayahs.length; i++) {
      final ayah = ayahs[i];
      final isHighlighted = highlightedAyah == ayah.numberInSurah;
      final isSelected = selectedAyah == ayah.numberInSurah;
      final isBookmarked = bookmarkedAyahs.contains(ayah.numberInSurah);

      final textStart = buffer.length;
      final ayahText = ayah.text.trim();
      buffer.write(ayahText);
      final textEnd = buffer.length;

      // Thin space before inline marker (Mushaf convention).
      buffer.write('\u2009');
      final markerStart = buffer.length;
      buffer.write('\u06DD${mushafArabicDigits(ayah.numberInSurah)}');
      final markerEnd = buffer.length;

      segments.add(
        AyahTextSegment(
          ayah: ayah,
          textStart: textStart,
          textEnd: textEnd,
          markerStart: markerStart,
          markerEnd: markerEnd,
        ),
      );

      Color? bg;
      if (isSelected) {
        bg = MushafColors.goldSoft.withValues(alpha: 0.22);
      } else if (isBookmarked) {
        bg = MushafColors.gold.withValues(alpha: 0.12);
      } else if (isHighlighted) {
        bg = MushafColors.gold.withValues(alpha: 0.08);
      }

      children.add(
        TextSpan(
          text: ayahText,
          style: baseStyle.copyWith(color: textColor, backgroundColor: bg),
        ),
      );

      children.add(const TextSpan(text: '\u2009'));

      children.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: MushafVerseMarker(
            number: ayah.numberInSurah,
            size: MushafMetrics.markerSize,
            isBookmarked: isBookmarked,
            isSelected: isSelected,
            onTap: onMarkerTap != null
                ? () => onMarkerTap(ayah.numberInSurah)
                : null,
          ),
        ),
      );

      if (i < ayahs.length - 1) {
        children.add(const TextSpan(text: '\u00A0'));
      }
    }

    return MushafLayoutResult(
      rootSpan: TextSpan(
        style: baseStyle.copyWith(color: textColor),
        children: children,
      ),
      plainText: buffer.toString(),
      segments: segments,
    );
  }

  TextStyle mushafTextStyle({
    required Color color,
    double fontSize = MushafMetrics.verseFontSize,
    double height = MushafMetrics.verseLineHeight,
  }) {
    return TextStyle(
      fontFamily: kMushafFontFamily,
      fontSize: fontSize,
      height: height,
      color: color,
      letterSpacing: 0.2,
      wordSpacing: 1,
    );
  }
}

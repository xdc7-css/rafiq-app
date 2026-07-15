import 'package:flutter/material.dart';
import '../styles/widget_style.dart';

/// Verse container — displays a Quran verse with proper typography
/// and layout. Used by Quran widget and Quran section of Dashboard.
class VerseContainer extends StatelessWidget {
  final WidgetStyle style;
  final String surahName;
  final int? surahNumber;
  final String? arabicText;
  final String? translation;
  final int? ayahNumber;
  final int? pageNumber;
  final int? totalPages;
  final double? progress;

  const VerseContainer({
    super.key,
    required this.style,
    required this.surahName,
    this.surahNumber,
    this.arabicText,
    this.translation,
    this.ayahNumber,
    this.pageNumber,
    this.totalPages,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Surah name + ayah number
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 3,
              ),
              decoration: BoxDecoration(
                color: style.accent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                surahName,
                style: TextStyle(
                  fontSize: 12 * style.fontSizeScale,
                  fontWeight: FontWeight.w600,
                  color: style.accent,
                ),
              ),
            ),
            if (ayahNumber != null) ...[
              const SizedBox(width: 6),
              Text(
                'الآية $ayahNumber',
                style: style.captionStyle,
              ),
            ],
          ],
        ),

        // Arabic text (if provided)
        if (arabicText != null) ...[
          SizedBox(height: style.contentGap),
          Text(
            arabicText!,
            style: TextStyle(
              fontSize: 16 * style.fontSizeScale,
              fontWeight: FontWeight.w400,
              color: style.textPrimary,
              height: 1.8,
            ),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],

        // Translation (if provided)
        if (translation != null) ...[
          SizedBox(height: style.contentGap * 0.5),
          Text(
            translation!,
            style: TextStyle(
              fontSize: 11 * style.fontSizeScale,
              fontWeight: FontWeight.w400,
              color: style.textMuted,
              height: 1.5,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],

        // Page info + progress bar
        if (pageNumber != null) ...[
          SizedBox(height: style.contentGap),
          Row(
            children: [
              if (totalPages != null)
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: progress ?? pageNumber! / totalPages!,
                      backgroundColor: style.surface,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(style.accent),
                      minHeight: 3,
                    ),
                  ),
                ),
              if (totalPages != null) ...[
                const SizedBox(width: 6),
                Text(
                  '$pageNumber / $totalPages',
                  style: TextStyle(
                    fontSize: 10 * style.fontSizeScale,
                    color: style.textMuted,
                  ),
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }
}

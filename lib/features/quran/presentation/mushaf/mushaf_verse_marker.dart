import 'package:flutter/material.dart';
import 'mushaf_constants.dart';

/// Inline ayah number marker — rendered as a [WidgetSpan] inside the flow text.
class MushafVerseMarker extends StatelessWidget {
  final int number;
  final double size;
  final bool isBookmarked;
  final bool isSelected;
  final VoidCallback? onTap;

  const MushafVerseMarker({
    super.key,
    required this.number,
    this.size = 28,
    this.isBookmarked = false,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color borderColor;
    Color textColor;

    if (isSelected) {
      bgColor = MushafColors.goldSoft.withValues(alpha: 0.25);
      borderColor = MushafColors.goldSoft.withValues(alpha: 0.6);
      textColor = MushafColors.gold;
    } else if (isBookmarked) {
      bgColor = MushafColors.gold.withValues(alpha: 0.12);
      borderColor = MushafColors.gold.withValues(alpha: 0.35);
      textColor = MushafColors.gold;
    } else {
      bgColor = Colors.transparent;
      borderColor = MushafColors.gold.withValues(alpha: 0.22);
      textColor = MushafColors.gold.withValues(alpha: 0.75);
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
          border: Border.all(color: borderColor, width: 0.8),
        ),
        alignment: Alignment.center,
        child: Text(
          mushafArabicDigits(number),
          style: TextStyle(
            fontFamily: kMushafFontFamily,
            fontSize: size * 0.42,
            height: 1,
            color: textColor,
          ),
          textDirection: TextDirection.rtl,
        ),
      ),
    );
  }
}

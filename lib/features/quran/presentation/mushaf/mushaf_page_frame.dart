import 'package:flutter/material.dart';
import 'mushaf_constants.dart';

/// Decorative frame around a Mushaf page — gold border, subtle shadow,
/// optional page number footer.
class MushafPageFrame extends StatelessWidget {
  final int? pageNumber;
  final bool isDark;
  final Widget child;

  const MushafPageFrame({
    super.key,
    this.pageNumber,
    this.isDark = false,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = isDark ? MushafColors.borderNight : MushafColors.border;
    final bgColor = isDark ? MushafColors.paperDark : MushafColors.paper;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: MushafMetrics.pageHorizontalMargin,
      ),
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: MushafMetrics.pageMaxWidth,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: borderColor.withValues(alpha: 0.5),
            width: 0.8,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Padding(
            padding: const EdgeInsets.all(MushafMetrics.pageInnerPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: child),
                if (pageNumber != null && pageNumber! > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      mushafArabicDigits(pageNumber!),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: kMushafFontFamily,
                        fontSize: 14,
                        color: (isDark ? MushafColors.inkNight : MushafColors.ink)
                            .withValues(alpha: 0.4),
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

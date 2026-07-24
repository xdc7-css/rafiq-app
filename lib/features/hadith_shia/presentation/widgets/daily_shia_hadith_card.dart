import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../theme/app_theme.dart';
import '../../../../theme/ds_components.dart';
import '../../data/models/shia_hadith_models.dart';
import '../providers/hadith_providers.dart';

class DailyShiaHadithCard extends ConsumerStatefulWidget {
  const DailyShiaHadithCard({super.key});

  @override
  ConsumerState<DailyShiaHadithCard> createState() => _DailyShiaHadithCardState();
}

class _DailyShiaHadithCardState extends ConsumerState<DailyShiaHadithCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final hadithAsync = ref.watch(dailyShiaHadithProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return hadithAsync.when(
      data: (hadith) => _buildCard(hadith, isDark),
      loading: () => _buildSkeleton(isDark),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildCard(ShiaHadith hadith, bool isDark) {
    final fullText = hadith.text;
    final shouldTruncate = fullText.length > 200;
    final displayText =
        (_expanded || !shouldTruncate) ? fullText : '${fullText.substring(0, 195)}...';

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.15)
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: GlassCard(
        radius: AppTheme.cardRadius,
        padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.cardPadding, vertical: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GoldBadge(
                  text: 'حديث اليوم',
                  icon: Icons.auto_stories_rounded,
                ),
                Row(
                  children: [
                    _buildMiniButton(
                      icon: Icons.bookmark_border_rounded,
                      color: AppTheme.textMuted.withValues(alpha: 0.6),
                      onPressed: () {
                        HapticFeedback.selectionClick();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'تم حفظ الحديث في المفضلة',
                              style: GoogleFonts.notoKufiArabic(fontSize: 12),
                            ),
                            duration: const Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    _buildMiniButton(
                      icon: Icons.share_outlined,
                      color: AppTheme.textMuted.withValues(alpha: 0.6),
                      onPressed: () => _shareHadith(hadith),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 18),

            Text(
              '"',
              style: GoogleFonts.amiri(
                fontSize: 28,
                color: AppTheme.goldPrimary.withValues(alpha: 0.3),
              ),
            ),
            const SizedBox(height: 4),

            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: Text(
                displayText,
                style: GoogleFonts.amiri(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textPrimary,
                  height: 1.8,
                ),
                textAlign: TextAlign.justify,
                textDirection: TextDirection.rtl,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '"',
              style: GoogleFonts.amiri(
                fontSize: 28,
                color: AppTheme.goldPrimary.withValues(alpha: 0.3),
              ),
              textAlign: TextAlign.end,
            ),
            const SizedBox(height: 14),

            AppTheme.goldDivider(width: 48),
            const SizedBox(height: 14),

            Row(
              children: [
                if (hadith.sourceDisplayName.isNotEmpty)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppTheme.goldPrimary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.goldPrimary.withValues(alpha: 0.15),
                        width: 0.5,
                      ),
                    ),
                    child: Text(
                      hadith.sourceDisplayName,
                      style: GoogleFonts.notoKufiArabic(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.goldPrimary,
                      ),
                    ),
                  ),
                const Spacer(),
                if (shouldTruncate)
                  _buildMiniAction(
                    icon: _expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    tooltip: 'توسيع',
                    onPressed: () {
                      setState(() => _expanded = !_expanded);
                      HapticFeedback.lightImpact();
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeleton(bool isDark) {
    return GlassCard(
      radius: AppTheme.cardRadius,
      padding: const EdgeInsets.all(AppTheme.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 100,
                height: 24,
                decoration: BoxDecoration(
                  color: AppTheme.goldPrimary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 18),
          ...List.generate(
              3,
              (i) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      height: 14,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppTheme.goldPrimary.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  )),
        ],
      ),
    );
  }

  void _shareHadith(ShiaHadith hadith) {
    final buf = StringBuffer();
    buf.writeln('══════════════════');
    buf.writeln();
    buf.writeln('حديث اليوم');
    buf.writeln();
    buf.writeln('"');
    buf.writeln(hadith.text);
    buf.writeln('"');
    buf.writeln();
    if (hadith.sourceDisplayName.isNotEmpty) {
      buf.writeln(hadith.sourceDisplayName);
      buf.writeln();
    }
    buf.writeln('══════════════════');
    buf.writeln();
    buf.writeln('رفيق');
    Share.share(buf.toString());
    HapticFeedback.selectionClick();
  }

  Widget _buildMiniButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppTheme.goldPrimary.withValues(alpha: 0.12),
            width: 0.5,
          ),
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }

  Widget _buildMiniAction({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AppTheme.goldPrimary.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppTheme.goldPrimary.withValues(alpha: 0.15),
            width: 0.5,
          ),
        ),
        child: Icon(icon, color: AppTheme.goldPrimary, size: 16),
      ),
    );
  }
}

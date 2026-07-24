import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/arabic_strings.dart';
import '../models/models.dart';
import '../providers/favorites_provider.dart';
import '../theme/app_theme.dart';
import '../theme/ds_components.dart';

enum HadithCardStyle { standard, imamQuotes }

class HadithCard extends ConsumerStatefulWidget {
  final HadithModel hadith;
  final VoidCallback? onTap;
  final bool showFavoriteButton;
  final HadithCardStyle style;

  const HadithCard({
    super.key,
    required this.hadith,
    this.onTap,
    this.showFavoriteButton = true,
    this.style = HadithCardStyle.standard,
  });

  @override
  ConsumerState<HadithCard> createState() => _HadithCardState();
}

class _HadithCardState extends ConsumerState<HadithCard> {
  bool _isPlaying = false;
  bool _isExpanded = false;

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
    HapticFeedback.lightImpact();

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isPlaying
              ? 'جاري قراءة الحديث الشريف...'
              : 'تم إيقاف القراءة الصوتية',
          style: GoogleFonts.notoKufiArabic(fontSize: 12),
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _copyToClipboard() {
    final h = widget.hadith;
    final buf = StringBuffer();
    buf.writeln('══════════════════');
    buf.writeln();
    buf.writeln(Ar.hadithOfDay);
    buf.writeln();
    if (h.narrator.isNotEmpty) {
      buf.writeln('عن ${h.narrator}');
      buf.writeln();
    }
    buf.writeln('"');
    buf.writeln(h.textArabic);
    buf.writeln('"');
    buf.writeln();
    if (h.source.isNotEmpty) {
      buf.writeln(h.source);
      buf.writeln();
    }
    buf.writeln('══════════════════');
    buf.writeln();
    buf.writeln('رفيق');

    Clipboard.setData(ClipboardData(text: buf.toString()));
    HapticFeedback.mediumImpact();
    if (!mounted) return;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'تم نسخ الحديث الشريف إلى الحافظة',
          style: GoogleFonts.notoKufiArabic(fontSize: 12),
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final favorites = ref.watch(favoritesNotifierProvider);
    final isFavorite = favorites.any(
      (f) => f.id == 'hadith_${widget.hadith.id}',
    );
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final w = MediaQuery.sizeOf(context).width;
    final padH = w < 360 ? 16.0 : 20.0;
    final padV = w < 360 ? 18.0 : 22.0;
    final hadithFontSize = w < 360 ? 17.0 : 20.0;

    final accentGold = AppTheme.goldPrimary;
    final primaryTextColor = AppTheme.textPrimary;
    final secondaryTextColor = AppTheme.textMuted;

    // If Hadith text is very long, show a teaser when collapsed
    final fullText = widget.hadith.textArabic;
    final shouldTruncate = fullText.length > 140;
    final displayArabicText = (_isExpanded || !shouldTruncate)
        ? fullText
        : '${fullText.substring(0, 135)}...';

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.12)
                : Colors.black.withValues(alpha: 0.04),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: GlassCard(
        radius: 28,
        padding: EdgeInsets.symmetric(horizontal: padH, vertical: padV),
        child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GoldBadge(
                        text: Ar.hadithOfDay,
                        icon: Icons.nights_stay_rounded,
                      ),
                      Row(
                        children: [
                          if (widget.showFavoriteButton)
                            _buildMiniButton(
                              icon: isFavorite
                                  ? Icons.bookmark_rounded
                                  : Icons.bookmark_border_rounded,
                              color: isFavorite
                                  ? accentGold
                                  : secondaryTextColor
                                      .withValues(alpha: 0.6),
                              onPressed: () {
                                ref
                                    .read(favoritesNotifierProvider
                                        .notifier)
                                    .addHadith(widget.hadith);
                                HapticFeedback.selectionClick();
                              },
                            ),
                          const SizedBox(width: 8),
                          _buildMiniButton(
                            icon: Icons.share_outlined,
                            color: secondaryTextColor
                                .withValues(alpha: 0.6),
                            onPressed: () {
                              Share.share(
                                '${widget.hadith.textArabic}\n\n- ${widget.hadith.source}',
                              );
                              HapticFeedback.selectionClick();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  if (widget.hadith.narrator.isNotEmpty) ...[
                    Text(
                      'عن ${widget.hadith.narrator}:',
                      style: GoogleFonts.notoKufiArabic(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: accentGold.withValues(alpha: 0.9),
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 8),
                  ],
                  AnimatedSize(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    child: Text(
                      displayArabicText,
                      style: GoogleFonts.amiri(
                        fontSize: hadithFontSize,
                        fontWeight: FontWeight.w500,
                        color: primaryTextColor,
                        height: 1.6,
                      ),
                      textAlign: TextAlign.justify,
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                  const SizedBox(height: 14),
                  AppTheme.goldDivider(width: 48),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: accentGold.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: accentGold.withValues(alpha: 0.15),
                            width: 0.5,
                          ),
                        ),
                        child: Text(
                          widget.hadith.source,
                          style: GoogleFonts.notoKufiArabic(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: accentGold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildMiniAction(
                            icon: Icons.copy_rounded,
                            tooltip: 'نسخ',
                            onPressed: _copyToClipboard,
                          ),
                          const SizedBox(width: 8),
                          _buildMiniAction(
                            icon: _isPlaying
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            tooltip: 'قراءة',
                            isAccent: _isPlaying,
                            onPressed: _togglePlay,
                          ),
                          if (shouldTruncate) ...[
                            const SizedBox(width: 8),
                            _buildMiniAction(
                              icon: _isExpanded
                                  ? Icons.keyboard_arrow_up_rounded
                                  : Icons.keyboard_arrow_down_rounded,
                              tooltip: 'توسيع',
                              onPressed: () {
                                setState(
                                    () => _isExpanded = !_isExpanded);
                                HapticFeedback.lightImpact();
                              },
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
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
    bool isAccent = false,
  }) {
    final accentGold = AppTheme.goldPrimary;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isAccent ? accentGold : accentGold.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isAccent
                ? accentGold
                : AppTheme.goldPrimary.withValues(alpha: 0.15),
            width: 0.5,
          ),
        ),
        child: Icon(
          icon,
          color: isAccent
              ? (isDark ? const Color(0xFF0B1324) : Colors.white)
              : accentGold,
          size: 16,
        ),
      ),
    );
  }
}

import 'dart:ui';
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

class VerseCard extends ConsumerStatefulWidget {
  final VerseModel verse;
  final VoidCallback? onTap;
  final bool showFavoriteButton;

  const VerseCard({
    super.key,
    required this.verse,
    this.onTap,
    this.showFavoriteButton = true,
  });

  @override
  ConsumerState<VerseCard> createState() => _VerseCardState();
}

class _VerseCardState extends ConsumerState<VerseCard> {
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
          _isPlaying ? 'جاري تلاوة الآية الكريمة بصوت الشيخ...' : 'تم إيقاف التلاوة',
          style: GoogleFonts.notoKufiArabic(fontSize: 12),
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: '${widget.verse.textArabic}\n\n[${widget.verse.reference}]'));
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم نسخ الآية الكريمة إلى الحافظة', style: GoogleFonts.notoKufiArabic(fontSize: 12)),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showTafsirSheet() {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF111A33).withValues(alpha: 0.95) : const Color(0xFFFFFFFF).withValues(alpha: 0.98),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              border: Border(
                top: BorderSide(
                  color: AppTheme.goldPrimary.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: AppTheme.goldPrimary.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'تفسير آية اليوم',
                    style: GoogleFonts.notoKufiArabic(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.goldPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.verse.textArabic,
                    style: AppTheme.arabicText(size: 22, color: AppTheme.textPrimary),
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.verse.reference,
                    style: GoogleFonts.notoKufiArabic(
                      fontSize: 12,
                      color: AppTheme.goldPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Divider(height: 24),
                  Text(
                    'الشرح والتفسير:',
                    style: GoogleFonts.notoKufiArabic(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getTafsirText(widget.verse.reference),
                    style: GoogleFonts.notoKufiArabic(
                      fontSize: 13,
                      height: 1.8,
                      color: AppTheme.textMuted,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _getTafsirText(String ref) {
    if (ref.contains('خلق')) {
      return 'تأمر الآية الكريمة القارئ بالقراءة والتعلم، وتبين أن الله سبحانه وتعالى هو الخالق البارئ لكل شيء، وهو الذي خلق الإنسان من علق طري، مما يدل على قدرته البالغة ولطفه بعباده وتعليمهم ما لم يكونوا يعلمون.';
    }
    return 'هذه الآية الكريمة تحمل بين طياتها دعوة للتدبر والتفكر في آيات الله البينات، والاعتماد عليه سبحانه في كل الشؤون، فإنه يهدي القلوب الحائرة وينير دروب السالكين بفضله ورحمته الواسعة.';
  }

  @override
  Widget build(BuildContext context) {
    final favorites = ref.watch(favoritesNotifierProvider);
    final isFavorite = favorites.any((f) => f.id == 'verse_${widget.verse.id}');
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final w = MediaQuery.sizeOf(context).width;
    final padH = w < 360 ? 16.0 : 20.0;
    final padV = w < 360 ? 18.0 : 22.0;
    final verseFontSize = w < 360 ? 20.0 : 24.0;
    
    final accentGold = AppTheme.goldPrimary;
    final primaryTextColor = AppTheme.textPrimary;
    final secondaryTextColor = AppTheme.textMuted;

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withValues(alpha: 0.12) : Colors.black.withValues(alpha: 0.04),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: GlassCard(
        radius: 28,
        padding: EdgeInsets.symmetric(horizontal: padH, vertical: padV),
        onTap: widget.onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Bar of Card
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GoldBadge(
                  text: Ar.verseOfDay,
                  icon: Icons.auto_stories_rounded,
                ),
                Row(
                  children: [
                    if (widget.showFavoriteButton)
                      _buildMiniButton(
                        icon: isFavorite ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                        color: isFavorite ? accentGold : secondaryTextColor.withValues(alpha: 0.6),
                        onPressed: () {
                          ref.read(favoritesNotifierProvider.notifier).addVerse(widget.verse);
                          HapticFeedback.selectionClick();
                        },
                      ),
                    const SizedBox(width: 8),
                    _buildMiniButton(
                      icon: Icons.share_outlined,
                      color: secondaryTextColor.withValues(alpha: 0.6),
                      onPressed: () {
                        Share.share('${widget.verse.textArabic}\n\n- ${widget.verse.reference}');
                        HapticFeedback.selectionClick();
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Arabic Text
            Text(
              widget.verse.textArabic,
              style: GoogleFonts.amiri(
                fontSize: verseFontSize,
                fontWeight: FontWeight.bold,
                color: primaryTextColor,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 12),

            // Expanded translation content with size transition
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: _isExpanded
                  ? Column(
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          'الترجمة قيد الإضافة...',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: secondaryTextColor,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),

            // Divider
            AppTheme.goldDivider(width: 48),
            const SizedBox(height: 14),

            // Footer of Card
            Row(
              children: [
                // Source / Reference Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: accentGold.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: accentGold.withValues(alpha: 0.15), width: 0.5),
                  ),
                  child: Text(
                    widget.verse.reference,
                    style: GoogleFonts.notoKufiArabic(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: accentGold,
                    ),
                  ),
                ),
                const Spacer(),
                // Actions: Tafsir, Copy, Play Audio
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTextAction(
                      label: 'التفسير',
                      icon: Icons.lightbulb_outline_rounded,
                      onPressed: _showTafsirSheet,
                    ),
                    const SizedBox(width: 8),
                    _buildMiniAction(
                      icon: Icons.copy_rounded,
                      tooltip: 'نسخ',
                      onPressed: _copyToClipboard,
                    ),
                    const SizedBox(width: 8),
                    _buildMiniAction(
                      icon: _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      tooltip: 'تلاوة',
                      isAccent: _isPlaying,
                      onPressed: _togglePlay,
                    ),
                    const SizedBox(width: 8),
                    _buildMiniAction(
                      icon: _isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                      tooltip: 'ترجمة',
                      onPressed: () {
                        setState(() => _isExpanded = !_isExpanded);
                        HapticFeedback.lightImpact();
                      },
                    ),
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
          border: Border.all(color: AppTheme.goldPrimary.withValues(alpha: 0.12), width: 0.5),
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
          color: isAccent
              ? accentGold
              : accentGold.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isAccent ? accentGold : AppTheme.goldPrimary.withValues(alpha: 0.15),
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

  Widget _buildTextAction({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    final accentGold = AppTheme.goldPrimary;
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: accentGold.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppTheme.goldPrimary.withValues(alpha: 0.15), width: 0.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: accentGold, size: 13),
            const SizedBox(width: 4),
            Text(
              label,
              style: GoogleFonts.notoKufiArabic(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: accentGold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

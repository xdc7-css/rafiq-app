import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/arabic_strings.dart';
import '../../../../models/api_models.dart';
import '../../../../theme/app_theme.dart';
import 'mushaf_constants.dart';

/// Minimal top bar — hides while scrolling.
class MushafTopBar extends StatelessWidget {
  final SurahFullData surah;
  final bool visible;
  final bool isDark;
  final VoidCallback onBack;
  final VoidCallback onSearch;
  final VoidCallback onBookmarks;
  final VoidCallback onSettings;

  const MushafTopBar({
    super.key,
    required this.surah,
    required this.visible,
    required this.isDark,
    required this.onBack,
    required this.onSearch,
    required this.onBookmarks,
    required this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    final ink = isDark ? MushafColors.inkNight : MushafColors.ink;
    final juz = juzForSurah(surah.number) ?? surah.ayahs.first.juz;

    return AnimatedSlide(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
      offset: visible ? Offset.zero : const Offset(0, -1),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 220),
        opacity: visible ? 1 : 0,
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              padding: EdgeInsets.fromLTRB(
                12,
                MediaQuery.paddingOf(context).top + 6,
                12,
                10,
              ),
              decoration: BoxDecoration(
                color: (isDark ? AppTheme.bgPrimary : MushafColors.paper)
                    .withValues(alpha: 0.88),
                border: Border(
                  bottom: BorderSide(color: AppTheme.borderSubtle),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: onBack,
                    icon: Icon(Icons.arrow_back_rounded, color: ink, size: 22),
                    visualDensity: VisualDensity.compact,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          surah.name,
                          style: TextStyle(
                            fontFamily: kMushafFontFamily,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: ink,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                        Text(
                          '${Ar.juz} ${mushafArabicDigits(juz)}',
                          style: GoogleFonts.cairo(
                            fontSize: 10,
                            color: ink.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _iconBtn(Icons.search_rounded, onSearch, ink),
                  _iconBtn(Icons.bookmark_outline_rounded, onBookmarks, ink),
                  _iconBtn(Icons.tune_rounded, onSettings, ink),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _iconBtn(IconData icon, VoidCallback onTap, Color ink) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, color: ink.withValues(alpha: 0.7), size: 20),
      visualDensity: VisualDensity.compact,
    );
  }
}

/// Floating glass bottom navigation for surah navigation.
class MushafBottomBar extends StatelessWidget {
  final SurahFullData surah;
  final bool visible;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  const MushafBottomBar({
    super.key,
    required this.surah,
    required this.visible,
    this.onPrevious,
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
      offset: visible ? Offset.zero : const Offset(0, 1.2),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 220),
        opacity: visible ? 1 : 0,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            0,
            20,
            MediaQuery.paddingOf(context).bottom + 12,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
              child: Container(
                height: 58,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.bgCard.withValues(alpha: 0.85),
                      AppTheme.bgSurface.withValues(alpha: 0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppTheme.borderSubtle),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.glowGold,
                      blurRadius: 24,
                      spreadRadius: -6,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _navBtn(Icons.skip_previous_rounded, onPrevious),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          surah.name,
                          style: TextStyle(
                            fontFamily: kMushafFontFamily,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.goldPrimary,
                          ),
                        ),
                        Text(
                          '${Ar.surah} ${mushafArabicDigits(surah.number)} ${Ar.of114}',
                          style: GoogleFonts.cairo(
                            fontSize: 9,
                            color: AppTheme.textMuted,
                          ),
                        ),
                      ],
                    ),
                    _navBtn(Icons.skip_next_rounded, onNext),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _navBtn(IconData icon, VoidCallback? onTap) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, color: AppTheme.goldPrimary, size: 26),
    );
  }
}

/// Auto-hiding floating toolbar shown on single tap.
class MushafFloatingToolbar extends StatelessWidget {
  final bool visible;
  final VoidCallback onBookmark;
  final VoidCallback onCopy;
  final VoidCallback onShare;
  final VoidCallback onAudio;

  const MushafFloatingToolbar({
    super.key,
    required this.visible,
    required this.onBookmark,
    required this.onCopy,
    required this.onShare,
    required this.onAudio,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !visible,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 220),
        opacity: visible ? 1 : 0,
        child: AnimatedSlide(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          offset: visible ? Offset.zero : const Offset(0, 0.4),
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.bgCard.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: AppTheme.borderSubtle),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _tool(Icons.bookmark_outline_rounded, onBookmark),
                      _tool(Icons.copy_rounded, onCopy),
                      _tool(Icons.share_outlined, onShare),
                      _tool(Icons.headphones_rounded, onAudio),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _tool(IconData icon, VoidCallback onTap) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, color: AppTheme.goldPrimary, size: 20),
      visualDensity: VisualDensity.compact,
    );
  }
}

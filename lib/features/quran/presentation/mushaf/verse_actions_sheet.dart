import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/arabic_strings.dart';
import '../../../../models/api_models.dart';
import '../../../../theme/app_theme.dart';
import 'mushaf_constants.dart';

/// Verse action bottom sheet — copy, bookmark, play, share, tafsir, notes.
class VerseActionsSheet extends StatelessWidget {
  final SurahFullData surah;
  final AyahData ayah;
  final bool isBookmarked;
  final VoidCallback onBookmarkToggle;
  final VoidCallback onTafsir;
  final VoidCallback onAudio;
  final VoidCallback onNotes;

  const VerseActionsSheet({
    super.key,
    required this.surah,
    required this.ayah,
    required this.isBookmarked,
    required this.onBookmarkToggle,
    required this.onTafsir,
    required this.onAudio,
    required this.onNotes,
  });

  static Future<void> show(
    BuildContext context, {
    required SurahFullData surah,
    required AyahData ayah,
    required bool isBookmarked,
    required VoidCallback onBookmarkToggle,
    required VoidCallback onTafsir,
    required VoidCallback onAudio,
    required VoidCallback onNotes,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => VerseActionsSheet(
        surah: surah,
        ayah: ayah,
        isBookmarked: isBookmarked,
        onBookmarkToggle: onBookmarkToggle,
        onTafsir: onTafsir,
        onAudio: onAudio,
        onNotes: onNotes,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.bgCard.withValues(alpha: 0.96),
            border: Border(
              top: BorderSide(
                color: AppTheme.goldPrimary.withValues(alpha: 0.2),
              ),
            ),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.paddingOf(context).bottom + 16,
            top: 8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppTheme.goldPrimary.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  ayah.text,
                  style: TextStyle(
                    fontFamily: kMushafFontFamily,
                    fontSize: 24,
                    color: AppTheme.textPrimary,
                    height: 2,
                  ),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${Ar.surah} ${surah.name} • ${Ar.verses} ${mushafArabicDigits(ayah.numberInSurah)}',
                style: GoogleFonts.cairo(
                  fontSize: 12,
                  color: AppTheme.goldPrimary.withValues(alpha: 0.75),
                ),
              ),
              const SizedBox(height: 16),
              Divider(color: AppTheme.borderSubtle, height: 1),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                child: Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  spacing: 4,
                  runSpacing: 4,
                  children: [
                    _action(
                      context,
                      Icons.play_circle_outline_rounded,
                      Ar.playAyah,
                      onAudio,
                    ),
                    _action(context, Icons.copy_rounded, Ar.copy_, () {
                      Clipboard.setData(ClipboardData(text: ayah.text));
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(Ar.copy_, style: GoogleFonts.cairo()),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    }),
                    _action(context, Icons.share_outlined, Ar.share_, () {
                      Share.share(
                        '${ayah.text}\n\n— ${surah.name} (${ayah.numberInSurah})',
                      );
                      Navigator.pop(context);
                    }),
                    _action(
                      context,
                      isBookmarked
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_outline_rounded,
                      Ar.bookmark,
                      () {
                        onBookmarkToggle();
                        Navigator.pop(context);
                      },
                    ),
                    _action(context, Icons.menu_book_rounded, Ar.tafsir, () {
                      Navigator.pop(context);
                      onTafsir();
                    }),
                    _action(context, Icons.notes_rounded, Ar.addNote, () {
                      Navigator.pop(context);
                      onNotes();
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _action(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return SizedBox(
      width: 76,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              Icon(icon, color: AppTheme.goldPrimary, size: 22),
              const SizedBox(height: 4),
              Text(
                label,
                style: GoogleFonts.cairo(
                  fontSize: 9,
                  color: AppTheme.textMuted,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

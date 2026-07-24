import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/arabic_strings.dart';
import '../../../../models/api_models.dart';
import 'mushaf_constants.dart';

/// Traditional Madinah-style surah banner with gold ornaments.
class MushafSurahHeader extends StatelessWidget {
  final SurahFullData surah;
  final bool isDark;

  const MushafSurahHeader({
    super.key,
    required this.surah,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    final ink = isDark ? MushafColors.inkNight : MushafColors.ink;
    final isMeccan = surah.revelationType == 'Meccan';
    final juz = juzForSurah(surah.number) ?? surah.ayahs.first.juz;

    return Column(
      children: [
        _OrnamentLine(color: MushafColors.gold),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: MushafColors.gold.withValues(alpha: 0.35)),
              bottom: BorderSide(
                color: MushafColors.gold.withValues(alpha: 0.2),
              ),
            ),
            gradient: LinearGradient(
              colors: [
                MushafColors.gold.withValues(alpha: isDark ? 0.12 : 0.08),
                Colors.transparent,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              Text(
                '${Ar.surah} ${mushafArabicDigits(surah.number)}',
                style: GoogleFonts.cairo(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: MushafColors.gold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                surah.name,
                style: TextStyle(
                  fontFamily: kMushafFontFamily,
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                  color: ink,
                  height: 1.3,
                ),
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _chip(isMeccan ? Ar.meccan : Ar.madinan, ink),
                  const SizedBox(width: 8),
                  _chip(
                    '${mushafArabicDigits(surah.numberOfAyahs)} ${Ar.verses}',
                    ink,
                  ),
                  const SizedBox(width: 8),
                  _chip('${Ar.juz} ${mushafArabicDigits(juz)}', ink),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _OrnamentLine(color: MushafColors.gold),
      ],
    );
  }

  Widget _chip(String label, Color ink) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        border: Border.all(color: MushafColors.gold.withValues(alpha: 0.25)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: GoogleFonts.cairo(
          fontSize: 10,
          color: ink.withValues(alpha: 0.65),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class MushafBasmala extends StatelessWidget {
  final bool isDark;
  final VoidCallback? onTap;

  const MushafBasmala({super.key, this.isDark = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          Ar.bismillah,
          style: TextStyle(
            fontFamily: kMushafFontFamily,
            fontSize: 36,
            fontWeight: FontWeight.w600,
            color: MushafColors.gold.withValues(alpha: 0.9),
            height: 1.6,
          ),
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
        ),
      ),
    );
  }
}

class _OrnamentLine extends StatelessWidget {
  final Color color;
  const _OrnamentLine({required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(height: 0.5, color: color.withValues(alpha: 0.35)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Icon(
            Icons.circle,
            size: 5,
            color: color.withValues(alpha: 0.6),
          ),
        ),
        Expanded(
          child: Container(height: 0.5, color: color.withValues(alpha: 0.35)),
        ),
      ],
    );
  }
}

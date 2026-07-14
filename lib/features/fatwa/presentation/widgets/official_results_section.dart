import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/arabic_strings.dart';
import '../../../../theme/app_theme.dart';
import '../../domain/entities/fatwa_entity.dart';

class OfficialResultsSection extends StatelessWidget {
  final List<FatwaEntity> fatwas;

  const OfficialResultsSection({
    super.key,
    required this.fatwas,
  });

  @override
  Widget build(BuildContext context) {
    if (fatwas.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(16),
        Padding(
          padding: const EdgeInsets.only(right: 4, bottom: 10),
          child: Row(
            children: [
              Icon(
                Icons.language_rounded,
                size: 16,
                color: AppTheme.luxuryGold.withValues(alpha: 0.7),
              ),
              const Gap(8),
              Text(
                Ar.officialResults,
                style: GoogleFonts.notoKufiArabic(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.warmWhite.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
        ...fatwas.map((f) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _OfficialResultCard(fatwa: f),
            )),
      ],
    );
  }
}

class _OfficialResultCard extends StatelessWidget {
  final FatwaEntity fatwa;

  const _OfficialResultCard({required this.fatwa});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.darkGlassBlue.withValues(alpha: 0.4),
                AppTheme.darkGlassBlue.withValues(alpha: 0.15),
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: AppTheme.luxuryGold.withValues(alpha: 0.06),
              width: 0.5,
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => _openUrl(fatwa.sourceUrl),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppTheme.luxuryGold.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.open_in_new_rounded,
                            size: 12,
                            color: AppTheme.luxuryGold,
                          ),
                          const Gap(4),
                          Text(
                            Ar.openSource,
                            style: GoogleFonts.notoKufiArabic(
                              fontSize: 11,
                              color: AppTheme.luxuryGold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2ECC71).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      Ar.officialSource,
                      style: GoogleFonts.notoKufiArabic(
                        fontSize: 10,
                        color: const Color(0xFF2ECC71),
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(12),
              Text(
                fatwa.question,
                style: GoogleFonts.notoKufiArabic(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.warmWhite,
                  height: 1.5,
                ),
                textAlign: TextAlign.right,
              ),
              if (fatwa.answer.isNotEmpty) ...[
                const Gap(10),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: AppTheme.luxuryGold.withValues(alpha: 0.06),
                ),
                const Gap(10),
                Text(
                  fatwa.answer,
                  style: GoogleFonts.notoKufiArabic(
                    fontSize: 13,
                    color: AppTheme.warmWhite.withValues(alpha: 0.6),
                    height: 1.6,
                  ),
                  textAlign: TextAlign.right,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

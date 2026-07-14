import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/arabic_strings.dart';
import '../../../../theme/app_theme.dart';

class NoResultsSection extends ConsumerWidget {
  final String query;

  const NoResultsSection({
    super.key,
    required this.query,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const Gap(32),
        Icon(
          Icons.search_off_rounded,
          size: 64,
          color: AppTheme.warmWhite.withValues(alpha: 0.15),
        ),
        const Gap(16),
        Text(
          Ar.noExactMatch,
          style: GoogleFonts.notoKufiArabic(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.warmWhite.withValues(alpha: 0.6),
          ),
          textAlign: TextAlign.center,
        ),
        const Gap(8),
        Text(
          Ar.sendInquiryDesc,
          style: GoogleFonts.notoKufiArabic(
            fontSize: 13,
            color: AppTheme.warmWhite.withValues(alpha: 0.4),
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        const Gap(32),
        _buildOfficialButton(context),
      ],
    );
  }

  Widget _buildOfficialButton(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.luxuryGold.withValues(alpha: 0.15),
                AppTheme.luxuryGold.withValues(alpha: 0.05),
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppTheme.luxuryGold.withValues(alpha: 0.2),
              width: 0.8,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _openOfficialSite(),
              borderRadius: BorderRadius.circular(24),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 20,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          Ar.sendInquiry,
                          style: GoogleFonts.notoKufiArabic(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.luxuryGold,
                          ),
                        ),
                        const Gap(4),
                        Text(
                          Ar.openBrowser,
                          style: GoogleFonts.notoKufiArabic(
                            fontSize: 12,
                            color: AppTheme.luxuryGold.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                    const Gap(12),
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: AppTheme.goldGradient,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.open_in_new_rounded,
                        color: AppTheme.midnightNavy,
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openOfficialSite() async {
    final uri = Uri.parse('https://www.sistani.org/arabic/qa/');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

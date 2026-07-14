import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/arabic_strings.dart';
import '../../../../theme/app_theme.dart';
import '../../domain/repositories/fatwa_repository.dart';

class SmartResultCard extends ConsumerWidget {
  final SearchResult result;
  final VoidCallback onTap;

  const SmartResultCard({
    super.key,
    required this.result,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fatwa = result.fatwa;
    final scorePercent = (result.similarityScore * 100).round();

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.darkGlassBlue.withValues(alpha: 0.55),
                AppTheme.darkGlassBlue.withValues(alpha: 0.2),
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: _scoreColor.withValues(alpha: 0.12),
              width: 0.5,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(24),
              splashColor: AppTheme.luxuryGold.withValues(alpha: 0.05),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        _buildScoreBadge(scorePercent),
                        const Spacer(),
                        Text(
                          result.isFromLocal ? Ar.officialSource : '',
                          style: GoogleFonts.notoKufiArabic(
                            fontSize: 10,
                            color: AppTheme.luxuryGold.withValues(alpha: 0.4),
                          ),
                        ),
                      ],
                    ),
                    const Gap(16),
                    Text(
                      fatwa.question,
                      style: GoogleFonts.notoKufiArabic(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.warmWhite,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.right,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Gap(12),
                    Container(
                      width: double.infinity,
                      height: 1,
                      color: AppTheme.luxuryGold.withValues(alpha: 0.08),
                    ),
                    const Gap(12),
                    Text(
                      fatwa.answer,
                      style: GoogleFonts.notoKufiArabic(
                        fontSize: 13,
                        color: AppTheme.warmWhite.withValues(alpha: 0.65),
                        height: 1.6,
                      ),
                      textAlign: TextAlign.right,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Gap(16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'مكتب سماحة السيد السيستاني',
                          style: GoogleFonts.notoKufiArabic(
                            fontSize: 10,
                            color: AppTheme.luxuryGold.withValues(alpha: 0.4),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.merge_type_rounded,
                              size: 12,
                              color: AppTheme.luxuryGold.withValues(alpha: 0.5),
                            ),
                            const Gap(4),
                            Text(
                              fatwa.categoryName,
                              style: GoogleFonts.notoKufiArabic(
                                fontSize: 11,
                                color: AppTheme.luxuryGold.withValues(alpha: 0.5),
                              ),
                            ),
                            const Gap(4),
                            Icon(
                              Icons.arrow_back_rounded,
                              size: 14,
                              color: AppTheme.luxuryGold.withValues(alpha: 0.5),
                            ),
                          ],
                        ),
                      ],
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

  Widget _buildScoreBadge(int percent) {
    final color = _scoreColor;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.2),
            color.withValues(alpha: 0.05),
          ],
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, size: 14, color: color),
          const Gap(6),
          Text(
            '$percent%',
            style: GoogleFonts.notoKufiArabic(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const Gap(4),
          Text(
            Ar.matchPercent,
            style: GoogleFonts.notoKufiArabic(
              fontSize: 10,
              color: color.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Color get _scoreColor {
    final score = result.similarityScore;
    if (score >= 0.9) return const Color(0xFF2ECC71);
    if (score >= 0.75) return const Color(0xFF27AE60);
    if (score >= 0.6) return AppTheme.luxuryGold;
    if (score >= 0.4) return const Color(0xFFF39C12);
    return const Color(0xFFE74C3C);
  }
}

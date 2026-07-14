import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../theme/app_theme.dart';
import '../../domain/entities/fatwa_entity.dart';

class FatwaMiniCard extends StatelessWidget {
  final FatwaEntity fatwa;
  final VoidCallback onTap;
  final bool showIcon;

  const FatwaMiniCard({
    super.key,
    required this.fatwa,
    required this.onTap,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.darkGlassBlue.withValues(alpha: 0.35),
                AppTheme.darkGlassBlue.withValues(alpha: 0.1),
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: AppTheme.luxuryGold.withValues(alpha: 0.04),
              width: 0.5,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(18),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            fatwa.question,
                            style: GoogleFonts.notoKufiArabic(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.warmWhite,
                              height: 1.4,
                            ),
                            textAlign: TextAlign.right,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Gap(6),
                          Text(
                            fatwa.categoryName,
                            style: GoogleFonts.notoKufiArabic(
                              fontSize: 11,
                              color: AppTheme.luxuryGold.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (showIcon) ...[
                      const Gap(12),
                      Icon(
                        Icons.arrow_back_rounded,
                        size: 18,
                        color: AppTheme.luxuryGold.withValues(alpha: 0.3),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

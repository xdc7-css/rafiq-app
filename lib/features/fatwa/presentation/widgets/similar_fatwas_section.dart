import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../theme/app_theme.dart';
import '../../domain/entities/fatwa_entity.dart';
import 'fatwa_mini_card.dart';
import '../../../../core/arabic_strings.dart';

class SimilarFatwasSection extends StatelessWidget {
  final List<FatwaEntity> fatwas;
  final void Function(FatwaEntity) onTap;

  const SimilarFatwasSection({
    super.key,
    required this.fatwas,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (fatwas.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 4, bottom: 10),
          child: Row(
            children: [
              Icon(
                Icons.format_list_bulleted_rounded,
                size: 16,
                color: AppTheme.luxuryGold.withValues(alpha: 0.7),
              ),
              const Gap(8),
              Text(
                Ar.similarFatwas,
                style: GoogleFonts.notoKufiArabic(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.warmWhite.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
        ...fatwas.take(5).map(
              (f) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: FatwaMiniCard(fatwa: f, onTap: () => onTap(f)),
              ),
            ),
      ],
    );
  }
}

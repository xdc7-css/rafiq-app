import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/arabic_strings.dart';
import '../../../../core/navigation_guard.dart';
import '../../../../theme/app_theme.dart';
import '../../../../widgets/star_background.dart';
import '../../domain/entities/fatwa_entity.dart';
import '../providers/fatwa_providers.dart';
import '../widgets/similar_fatwas_section.dart';

class FatwaDetailScreen extends ConsumerWidget {
  final FatwaEntity fatwa;

  const FatwaDetailScreen({super.key, required this.fatwa});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBookmarkedAsync = ref.watch(isFatwaBookmarkedProvider(fatwa.id));
    final relatedAsync = ref.watch(relatedFatwasProvider(fatwa.id));

    return Scaffold(
      body: Stack(
        children: [
          const StarBackground(),
          SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: _buildAppBar(context, ref, isBookmarkedAsync),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 80),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildQuestionCard(),
                        const Gap(16),
                        _buildAnswerCard(),
                        const Gap(16),
                        _buildMetaSection(context),
                        const Gap(16),
                        _buildActionButtons(context, ref),
                        const Gap(24),
                        relatedAsync.when(
                          data: (related) => SimilarFatwasSection(
                            fatwas: related,
                            onTap: (f) =>
                                context.pushRoute('/fatwa-detail', extra: f),
                          ),
                          loading: () => const SizedBox.shrink(),
                          error: (_, __) => const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<bool> isBookmarked,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 16, 20, 4),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: Icon(Icons.arrow_back_rounded, color: AppTheme.luxuryGold),
          ),
          const Spacer(),
          Container(
            width: 4,
            height: 28,
            decoration: BoxDecoration(
              gradient: AppTheme.goldGradient,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Gap(12),
          Text(
            Ar.fatwa,
            style: GoogleFonts.notoKufiArabic(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppTheme.warmWhite,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.luxuryGold.withValues( alpha: 0.1),
                AppTheme.darkGlassBlue.withValues( alpha: 0.2),
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppTheme.luxuryGold.withValues( alpha: 0.1),
              width: 0.5,
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.volume_up_rounded,
                    size: 14,
                    color: AppTheme.luxuryGold,
                  ),
                  const Spacer(),
                  Text(
                    Ar.fullQuestion,
                    style: GoogleFonts.notoKufiArabic(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.luxuryGold.withValues( alpha: 0.7),
                    ),
                  ),
                  const Gap(6),
                  Container(
                    width: 3,
                    height: 16,
                    decoration: BoxDecoration(
                      gradient: AppTheme.goldGradient,
                      borderRadius: BorderRadius.circular(1.5),
                    ),
                  ),
                ],
              ),
              const Gap(16),
              Text(
                fatwa.question,
                style: GoogleFonts.notoKufiArabic(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.warmWhite,
                  height: 1.6,
                ),
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnswerCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.darkGlassBlue.withValues( alpha: 0.5),
                AppTheme.darkGlassBlue.withValues( alpha: 0.2),
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppTheme.luxuryGold.withValues( alpha: 0.06),
              width: 0.5,
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      gradient: AppTheme.goldGradient,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'ج',
                        style: GoogleFonts.notoKufiArabic(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.midnightNavy,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    Ar.fullAnswer,
                    style: GoogleFonts.notoKufiArabic(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.luxuryGold.withValues( alpha: 0.7),
                    ),
                  ),
                  const Gap(6),
                  Container(
                    width: 3,
                    height: 16,
                    decoration: BoxDecoration(
                      gradient: AppTheme.goldGradient,
                      borderRadius: BorderRadius.circular(1.5),
                    ),
                  ),
                ],
              ),
              const Gap(16),
              Text(
                fatwa.answer,
                style: GoogleFonts.notoKufiArabic(
                  fontSize: 15,
                  color: AppTheme.warmWhite.withValues( alpha: 0.85),
                  height: 1.8,
                ),
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetaSection(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.darkGlassBlue.withValues( alpha: 0.3),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppTheme.luxuryGold.withValues( alpha: 0.04),
              width: 0.5,
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _metaRow(Ar.category, fatwa.categoryName, Icons.category_rounded),
              const Gap(10),
              Container(
                width: double.infinity,
                height: 1,
                color: AppTheme.warmWhite.withValues( alpha: 0.05),
              ),
              const Gap(10),
              _metaRow(
                Ar.source,
                'مكتب سماحة السيد علي الحسيني السيستاني',
                Icons.source_rounded,
              ),
              const Gap(10),
              Container(
                width: double.infinity,
                height: 1,
                color: AppTheme.warmWhite.withValues( alpha: 0.05),
              ),
              const Gap(10),
              GestureDetector(
                onTap: () => _openSource(context),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.luxuryGold.withValues( alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
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
                    const Spacer(),
                    Icon(
                      Icons.link_rounded,
                      size: 14,
                      color: AppTheme.luxuryGold.withValues( alpha: 0.5),
                    ),
                    const Gap(6),
                    Text(
                      Ar.officialSource,
                      style: GoogleFonts.notoKufiArabic(
                        fontSize: 12,
                        color: AppTheme.luxuryGold.withValues( alpha: 0.6),
                      ),
                    ),
                    const Gap(6),
                    Container(
                      width: 3,
                      height: 16,
                      decoration: BoxDecoration(
                        gradient: AppTheme.goldGradient,
                        borderRadius: BorderRadius.circular(1.5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _metaRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppTheme.luxuryGold.withValues( alpha: 0.5)),
        const Spacer(),
        Text(
          value,
          style: GoogleFonts.notoKufiArabic(
            fontSize: 13,
            color: AppTheme.warmWhite.withValues( alpha: 0.7),
          ),
        ),
        const Gap(6),
        Text(
          '$label: ',
          style: GoogleFonts.notoKufiArabic(
            fontSize: 12,
            color: AppTheme.luxuryGold.withValues( alpha: 0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.darkGlassBlue.withValues( alpha: 0.4),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: AppTheme.luxuryGold.withValues( alpha: 0.06),
              width: 0.5,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _iconButton(Icons.copy_rounded, Ar.copy_, () {
                Clipboard.setData(
                  ClipboardData(text: '${fatwa.question}\n\n${fatwa.answer}'),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      Ar.copied,
                      style: GoogleFonts.notoKufiArabic(color: Colors.white),
                    ),
                    backgroundColor: AppTheme.darkGlassBlue,
                  ),
                );
              }),
              _iconButton(Icons.share_outlined, Ar.share_, () {
                Share.share(
                  '${fatwa.question}\n\n${fatwa.answer}\n\n${Ar.officialSource}: ${fatwa.sourceUrl}',
                );
              }),
              _iconButton(
                Icons.bookmark_outline_rounded,
                Ar.saveFatwa,
                () async {
                  await ref
                      .read(fatwaRepositoryProvider)
                      .toggleBookmark(fatwa.id);
                  ref.invalidate(isFatwaBookmarkedProvider(fatwa.id));
                  ref.invalidate(bookmarkedFatwasProvider);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          Ar.fatwaSaved,
                          style: GoogleFonts.notoKufiArabic(
                            color: Colors.white,
                          ),
                        ),
                        backgroundColor: AppTheme.darkGlassBlue,
                      ),
                    );
                  }
                },
              ),
              _iconButton(
                Icons.open_in_new_rounded,
                Ar.openSource,
                () => _openSource(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: AppTheme.luxuryGold.withValues( alpha: 0.7),
              size: 22,
            ),
            const Gap(4),
            Text(
              label,
              style: GoogleFonts.notoKufiArabic(
                fontSize: 9,
                color: AppTheme.warmWhite.withValues( alpha: 0.5),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openSource(BuildContext context) async {
    final uri = Uri.tryParse(fatwa.sourceUrl);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

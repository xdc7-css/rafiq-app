import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/arabic_strings.dart';
import '../../../../core/navigation_guard.dart';
import '../../../../theme/app_theme.dart';
import '../../../../widgets/star_background.dart';
import '../../domain/entities/fatwa_entity.dart';
import '../providers/fatwa_providers.dart';
import '../widgets/fatwa_mini_card.dart';

class FatwaCategoryScreen extends ConsumerWidget {
  final String category;

  const FatwaCategoryScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fatwasAsync = ref.watch(fatwaByCategoryProvider(category));

    return Scaffold(
      body: Stack(
        children: [
          const StarBackground(),
          SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _buildHeader(context)),
                SliverToBoxAdapter(
                  child: fatwasAsync.when(
                    data: (fatwas) => _buildFatwaList(context, fatwas),
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: CircularProgressIndicator(
                          color: AppTheme.luxuryGold,
                        ),
                      ),
                    ),
                    error: (err, _) => Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Text(
                          err.toString(),
                          style: GoogleFonts.notoKufiArabic(
                            color: AppTheme.warmWhite.withValues( alpha: 0.5),
                          ),
                        ),
                      ),
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

  Widget _buildHeader(BuildContext context) {
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
          Flexible(
            child: Text(
              category,
              style: GoogleFonts.notoKufiArabic(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppTheme.warmWhite,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFatwaList(BuildContext context, List<FatwaEntity> fatwas) {
    if (fatwas.isEmpty) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 40, 20, 80),
        child: Column(
          children: [
            Icon(
              Icons.inbox_rounded,
              size: 64,
              color: AppTheme.warmWhite.withValues( alpha: 0.1),
            ),
            const Gap(16),
            Text(
              Ar.noResultFound,
              style: GoogleFonts.notoKufiArabic(
                fontSize: 15,
                color: AppTheme.warmWhite.withValues( alpha: 0.5),
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 80),
      child: Column(
        children: fatwas
            .map(
              (f) => Padding(
                key: ValueKey('fatwa_cat_${f.id}'),
                padding: const EdgeInsets.only(bottom: 10),
                child: FatwaMiniCard(
                  fatwa: f,
                  onTap: () => context.pushRoute('/fatwa-detail', extra: f),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

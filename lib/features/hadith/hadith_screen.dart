import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/arabic_strings.dart';
import '../../theme/app_theme.dart';
import '../../widgets/star_background.dart';
import '../../widgets/hadith_card.dart';
import '../../models/hadith_model.dart';
import 'data/datasources/aqwal_local_source.dart';
import 'data/models/aqwal_model.dart';

final aqwalSrcProvider = Provider<AqwalLocalSource>((ref) => AqwalLocalSource());

final aqwalProvider = FutureProvider<List<AqwalModel>>((ref) {
  return ref.watch(aqwalSrcProvider).loadAll();
});

final imamCategoriesProvider = Provider<List<AqwalCategory>>((ref) {
  return ref.watch(aqwalSrcProvider).categories;
});

class HadithScreen extends ConsumerStatefulWidget {
  const HadithScreen({super.key});

  @override
  ConsumerState<HadithScreen> createState() => _HadithScreenState();
}

class _HadithScreenState extends ConsumerState<HadithScreen> {
  int _selectedIndex = 0;

  static const _imamNarrators = {
    1: 'الإمام علي بن أبي طالب (ع)',
    2: 'الإمام الحسن المجتبى (ع)',
    3: 'الإمام الحسين سيد الشهداء (ع)',
    4: 'الإمام زين العابدين (ع)',
    5: 'الإمام محمد الباقر (ع)',
    6: 'الإمام جعفر الصادق (ع)',
    7: 'الإمام موسى الكاظم (ع)',
    8: 'الإمام علي الرضا (ع)',
    9: 'الإمام محمد الجواد (ع)',
    10: 'الإمام علي الهادي (ع)',
    11: 'الإمام الحسن العسكري (ع)',
    12: 'الإمام المهدي (عج)',
  };

  @override
  Widget build(BuildContext context) {
    final allAsync = ref.watch(aqwalProvider);
    final cats = ref.watch(imamCategoriesProvider);

    return Stack(
      children: [
        const StarBackground(),
        allAsync.when(
          data: (all) {
            final cid = _selectedIndex < cats.length ? cats[_selectedIndex].id : '';
            final filtered = all.where((a) {
              final catId = _imamIdToCatId(a.imamId);
              return catId == cid;
            }).toList();

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _buildHeader()),
                SliverToBoxAdapter(child: _buildCategoryStrip(cats)),
                if (filtered.isEmpty)
                  SliverFillRemaining(
                    child: Center(child: Text(Ar.noData, style: GoogleFonts.notoKufiArabic(color: AppTheme.textMuted))),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (_, i) => _buildCard(filtered[i]),
                        childCount: filtered.length,
                      ),
                    ),
                  ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Text('$err', style: GoogleFonts.notoKufiArabic(color: AppTheme.textMuted)),
            ),
          ),
        ),
      ],
    );
  }

  String _imamIdToCatId(int imamId) {
    const map = {
      1: 'imam_ali', 2: 'imam_hasan', 3: 'imam_hussain', 4: 'imam_sajjad',
      5: 'imam_baqir', 6: 'imam_sadiq', 7: 'imam_kadhim', 8: 'imam_rida',
      9: 'imam_jawad', 10: 'imam_hadi', 11: 'imam_askari', 12: 'imam_mahdi',
    };
    return map[imamId] ?? '';
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
      child: Row(
        children: [
          Container(
            width: 4, height: 32,
            decoration: BoxDecoration(gradient: AppTheme.goldGradient, borderRadius: BorderRadius.circular(2)),
          ),
          const Gap(14),
          Text('أقوال الأئمة (ع)', style: GoogleFonts.notoKufiArabic(fontSize: 22, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
          const Spacer(),
          IconButton(
            onPressed: () => context.push('/search'),
            icon: Icon(Icons.search_rounded, color: AppTheme.goldPrimary.withValues(alpha: 0.7)),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryStrip(List<AqwalCategory> cats) {
    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: cats.length,
        itemBuilder: (_, i) {
          final isSel = i == _selectedIndex;
          return GestureDetector(
            onTap: () => setState(() => _selectedIndex = i),
            child: Container(
              margin: const EdgeInsets.only(left: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                gradient: isSel ? AppTheme.goldGradient : null,
                color: isSel ? null : AppTheme.bgCard.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: isSel ? AppTheme.goldPrimary : AppTheme.borderGold, width: 0.5),
              ),
              child: Text(
                cats[i].shortName,
                style: GoogleFonts.notoKufiArabic(fontSize: 11, fontWeight: FontWeight.w600,
                  color: isSel ? AppTheme.bgPrimary : AppTheme.textSecondary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCard(AqwalModel item) {
    final narrator = _imamNarrators[item.imamId] ?? '';
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: HadithCard(hadith: HadithModel(
        id: item.id,
        textArabic: item.text,
        narrator: narrator,
        source: item.source,
        bookNumber: 0,
        hadithNumber: 0,
        category: item.topic,
        categoryId: 'imam_${item.imamId}',
        reference: item.reference,
      ), showFavoriteButton: true,
      style: HadithCardStyle.imamQuotes,
      ),
    );
  }
}

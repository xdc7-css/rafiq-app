import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/dua_library.dart';
import '../../../../theme/app_theme.dart';

class DuaSelectionScreen extends StatelessWidget {
  final String memorialId;

  const DuaSelectionScreen({super.key, required this.memorialId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgPrimary,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppTheme.bgPrimary,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: AppTheme.textPrimary,
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppTheme.goldPrimary.withValues(alpha: 0.15),
                      AppTheme.bgPrimary,
                    ],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              AppTheme.goldPrimary.withValues(alpha: 0.2),
                              AppTheme.goldPrimary.withValues(alpha: 0.05),
                            ],
                          ),
                          border: Border.all(
                            color: AppTheme.goldPrimary.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          Icons.favorite_rounded,
                          size: 36,
                          color: AppTheme.goldPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'إهداء الدعاء',
                        style: GoogleFonts.notoKufiArabic(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'اختر دعاءً ليُهدى ثوابه إلى هذا المتوفى',
                        style: GoogleFonts.notoKufiArabic(
                          fontSize: 13,
                          color: AppTheme.textMuted,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          ...kDuaCategories.map((category) {
            final categoryDuas =
                kDuaItems.where((d) => d.categoryId == category.id).toList();
            if (categoryDuas.isEmpty) return const SliverToBoxAdapter();

            return SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 4,
                          height: 18,
                          decoration: BoxDecoration(
                            color: AppTheme.goldPrimary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          category.title,
                          style: GoogleFonts.notoKufiArabic(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      category.description,
                      style: GoogleFonts.notoKufiArabic(
                        fontSize: 12,
                        color: AppTheme.textMuted,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...categoryDuas.map((dua) => _DuaCard(
                          dua: dua,
                          onTap: () => context.push(
                            '/dua-detail/${dua.id}?memorialId=${Uri.encodeComponent(memorialId)}',
                          ),
                        )),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            );
          }),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }
}

class _DuaCard extends StatelessWidget {
  final DuaItem dua;
  final VoidCallback onTap;

  const _DuaCard({required this.dua, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          splashColor: AppTheme.goldPrimary.withValues(alpha: 0.08),
          highlightColor: AppTheme.goldPrimary.withValues(alpha: 0.04),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppTheme.goldPrimary.withValues(alpha: 0.08),
                width: 0.5,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppTheme.goldPrimary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.favorite_rounded,
                    size: 22,
                    color: AppTheme.goldPrimary.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dua.title,
                        style: GoogleFonts.notoKufiArabic(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dua.subtitle,
                        style: GoogleFonts.notoKufiArabic(
                          fontSize: 12,
                          color: AppTheme.goldPrimary.withValues(alpha: 0.7),
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 14,
                  color: AppTheme.textMuted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

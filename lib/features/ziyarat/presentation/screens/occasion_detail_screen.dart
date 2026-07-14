import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../theme/app_theme.dart';
import '../../../../widgets/star_background.dart';
import '../../data/models/ziyarat_models.dart';
import '../providers/ziyarat_providers.dart';
import '../widgets/ziyarat_card.dart';
import 'content_detail_screen.dart';

class OccasionDetailScreen extends ConsumerWidget {
  final IslamicOccasion occasion;
  const OccasionDetailScreen({super.key, required this.occasion});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final w = MediaQuery.sizeOf(context).width;
    final relatedZiyarat = ref.watch(occasionRelatedZiyaratProvider(occasion.id));
    final relatedDuas = ref.watch(occasionRelatedDuasProvider(occasion.id));

    return Scaffold(
      body: IslamicBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(w < 360 ? 16 : 20, 16, w < 360 ? 16 : 20, 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_forward_rounded, color: AppTheme.textPrimary),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                    Text(
                      occasion.title,
                      style: GoogleFonts.notoKufiArabic(
                        fontSize: 22, fontWeight: FontWeight.w800,
                        color: AppTheme.goldPrimary,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(w < 360 ? 16 : 20, 8, w < 360 ? 16 : 20, 100),
                  child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(child: _buildDateBadge()),
                    SliverToBoxAdapter(child: _buildDescription()),
                    if (occasion.recommendedDeeds.isNotEmpty)
                      SliverToBoxAdapter(child: _buildSectionTitle('الأعمال المستحبة')),
                    if (occasion.recommendedDeeds.isNotEmpty)
                      SliverToBoxAdapter(child: _buildDeedsList()),
                    if (occasion.relatedTexts.isNotEmpty)
                      SliverToBoxAdapter(child: _buildSectionTitle('النصوص المرتبطة')),
                    if (occasion.relatedTexts.isNotEmpty)
                      SliverToBoxAdapter(child: _buildRelatedTexts()),
                    if (occasion.relatedZiyaratIds.isNotEmpty)
                      SliverToBoxAdapter(child: _buildSectionTitle('الزيارات المرتبطة')),
                    relatedZiyarat.when(
                      data: (list) => SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (_, i) => ContentCard(
                            title: list[i].title,
                            subtitle: list[i].source,
                            icon: Icons.mosque_rounded,
                            onTap: () => _openZiyarat(context, ref, list[i]),
                          ),
                          childCount: list.length,
                        ),
                      ),
                      loading: () => const SliverToBoxAdapter(child: SizedBox()),
                      error: (_, __) => const SliverToBoxAdapter(child: SizedBox()),
                    ),
                    if (occasion.relatedDuaIds.isNotEmpty)
                      SliverToBoxAdapter(child: _buildSectionTitle('الأدعية المرتبطة')),
                    relatedDuas.when(
                      data: (list) => SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (_, i) => ContentCard(
                            title: list[i].title,
                            subtitle: list[i].source,
                            icon: Icons.volunteer_activism_rounded,
                            onTap: () => _openDua(context, ref, list[i]),
                          ),
                          childCount: list.length,
                        ),
                      ),
                      loading: () => const SliverToBoxAdapter(child: SizedBox()),
                      error: (_, __) => const SliverToBoxAdapter(child: SizedBox()),
                    ),
                  ],
                ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateBadge() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.goldPrimary.withValues(alpha: 0.15),
                  AppTheme.goldPrimary.withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.borderGold),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.calendar_month_rounded, size: 16, color: AppTheme.goldPrimary),
                const SizedBox(width: 8),
                Text(
                  occasion.dateHijri,
                  style: GoogleFonts.notoKufiArabic(
                    fontSize: 14, fontWeight: FontWeight.w600,
                    color: AppTheme.goldPrimary,
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.bgSurface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Text(
        occasion.description,
        style: GoogleFonts.notoKufiArabic(
          fontSize: 14, color: AppTheme.textSecondary, height: 1.7,
        ),
        textDirection: TextDirection.rtl,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            title,
            style: GoogleFonts.notoKufiArabic(
              fontSize: 17, fontWeight: FontWeight.w700,
              color: AppTheme.goldPrimary,
            ),
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(width: 10),
          Container(
            width: 3, height: 18,
            decoration: BoxDecoration(
              gradient: AppTheme.goldGradient,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeedsList() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.bgCard.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        children: occasion.recommendedDeeds.map((deed) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    deed,
                    style: GoogleFonts.notoKufiArabic(
                      fontSize: 14, color: AppTheme.textSecondary,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ),
                const SizedBox(width: 10),
                Icon(Icons.check_circle_rounded, size: 16,
                    color: AppTheme.goldPrimary.withValues(alpha: 0.6)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRelatedTexts() {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.bgCard.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        children: occasion.relatedTexts.map((text) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    text,
                    style: GoogleFonts.notoKufiArabic(
                      fontSize: 14, color: AppTheme.textSecondary,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ),
                const SizedBox(width: 10),
                Icon(Icons.article_rounded, size: 16,
                    color: AppTheme.textMuted),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  void _openZiyarat(BuildContext context, WidgetRef ref, ziyarat) {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => ContentDetailScreen(
        id: ziyarat.id, type: 'ziyarat',
        title: ziyarat.title, fullText: ziyarat.fullText,
        source: ziyarat.source,
        estimatedMinutes: ziyarat.estimatedMinutes,
        sectionCount: ziyarat.sectionCount,
      ),
    ));
  }

  void _openDua(BuildContext context, WidgetRef ref, dua) {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => ContentDetailScreen(
        id: dua.id, type: 'dua',
        title: dua.title, fullText: dua.fullText,
        source: dua.source,
        estimatedMinutes: dua.estimatedMinutes,
        sectionCount: dua.sectionCount,
      ),
    ));
  }
}

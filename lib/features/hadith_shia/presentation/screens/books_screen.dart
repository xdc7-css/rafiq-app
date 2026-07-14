import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../theme/app_theme.dart';
import '../../../../theme/ds_components.dart';
import '../../../../widgets/star_background.dart';
import '../../data/models/shia_hadith_models.dart';
import '../providers/hadith_providers.dart';

class BooksScreen extends ConsumerStatefulWidget {
  const BooksScreen({super.key});

  @override
  ConsumerState<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends ConsumerState<BooksScreen> {
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final books = ref.watch(bookListProvider);
    final filtered = _searchQuery.isEmpty
        ? books
        : books
            .where((b) =>
                b.nameArabic.contains(_searchQuery) ||
                b.nameEnglish.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                b.id.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();

    return Scaffold(
      body: Stack(
        children: [
          const StarBackground(),
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(child: _buildHeader()),
                SliverToBoxAdapter(child: _buildSearchBar()),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 120),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, i) => _buildBookCard(filtered[i]),
                      childCount: filtered.length,
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

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 4),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 32,
            decoration: BoxDecoration(
              gradient: AppTheme.goldGradient,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 14),
          Text(
            'كتب الحديث',
            style: GoogleFonts.notoKufiArabic(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const Spacer(),
          Text(
            '${ShiaBookInfo.allBookIds.length} كتاب',
            style: GoogleFonts.notoKufiArabic(
              fontSize: 12,
              color: AppTheme.goldPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 8),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.bgCard.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.goldPrimary.withValues(alpha: 0.1),
            width: 0.5,
          ),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (v) => setState(() => _searchQuery = v),
          style: GoogleFonts.notoKufiArabic(
            fontSize: 14,
            color: AppTheme.textPrimary,
          ),
          textDirection: TextDirection.rtl,
          decoration: InputDecoration(
            hintText: 'بحث في الكتب...',
            hintStyle: GoogleFonts.notoKufiArabic(
              fontSize: 14,
              color: AppTheme.textMuted,
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: AppTheme.goldPrimary.withValues(alpha: 0.6),
              size: 20,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBookCard(ShiaBookInfo book) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: GlassCard(
        radius: AppTheme.cardRadius,
        padding: const EdgeInsets.all(AppTheme.cardPadding),
        onTap: () {
          HapticFeedback.lightImpact();
          context.push('/books/${book.id}');
        },
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.goldPrimary.withValues(alpha: 0.2),
                    AppTheme.goldPrimary.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.menu_book_rounded,
                color: AppTheme.goldPrimary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.nameArabic,
                    style: GoogleFonts.notoKufiArabic(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (book.nameEnglish.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      book.nameEnglish,
                      style: GoogleFonts.notoKufiArabic(
                        fontSize: 12,
                        color: AppTheme.textMuted,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: AppTheme.goldPrimary.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}

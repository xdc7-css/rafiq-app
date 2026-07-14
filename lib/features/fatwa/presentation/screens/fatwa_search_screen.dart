import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/arabic_strings.dart';
import '../../../../core/navigation_guard.dart';
import '../../../../theme/app_theme.dart';
import '../../../../widgets/star_background.dart';
import '../providers/fatwa_providers.dart';
import '../widgets/smart_result_card.dart';
import '../widgets/no_results_section.dart';

class FatwaSearchScreen extends ConsumerStatefulWidget {
  const FatwaSearchScreen({super.key});

  @override
  ConsumerState<FatwaSearchScreen> createState() => _FatwaSearchScreenState();
}

class _FatwaSearchScreenState extends ConsumerState<FatwaSearchScreen> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  List<String> _suggestions = [];
  bool _showSuggestions = false;

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(fatwaSearchProvider);
    final recentSearches = ref.watch(recentSearchesProvider);
    final categoriesAsync = ref.watch(fatwaCategoriesProvider);

    return Scaffold(
      body: Stack(
        children: [
          const StarBackground(),
          SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _buildHeader()),
                SliverToBoxAdapter(child: _buildSearchBar()),
                if (_showSuggestions && _suggestions.isNotEmpty)
                  SliverToBoxAdapter(child: _buildSuggestions()),
                if (searchState.isLoading)
                  const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.luxuryGold,
                      ),
                    ),
                  )
                else if (searchState.results.isNotEmpty)
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 80),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((ctx, i) {
                        final result = searchState.results[i];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: SmartResultCard(
                            key: ValueKey('fatwa_${result.fatwa.id}'),
                            result: result,
                            onTap: () => _openDetail(result.fatwa),
                          ),
                        );
                      }, childCount: searchState.results.length),
                    ),
                  )
                else if (searchState.query.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 80),
                      child: NoResultsSection(query: searchState.query),
                    ),
                  )
                else
                  SliverToBoxAdapter(
                    child: _buildInitialState(
                      recentSearches.valueOrNull ?? [],
                      categoriesAsync.valueOrNull ?? [],
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
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: Icon(Icons.arrow_back_rounded, color: AppTheme.luxuryGold),
          ),
          const Gap(8),
          Container(
            width: 4,
            height: 28,
            decoration: BoxDecoration(
              gradient: AppTheme.goldGradient,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Gap(12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Ar.fatwa,
                style: GoogleFonts.notoKufiArabic(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.warmWhite,
                ),
              ),
              Text(
                Ar.askFatwa,
                style: GoogleFonts.notoKufiArabic(
                  fontSize: 12,
                  color: AppTheme.luxuryGold.withValues( alpha: 0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.darkGlassBlue.withValues( alpha: 0.4),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppTheme.luxuryGold.withValues( alpha: 0.08),
                width: 0.5,
              ),
            ),
            child: TextField(
              controller: _searchController,
              focusNode: _focusNode,
              textDirection: TextDirection.rtl,
              textInputAction: TextInputAction.search,
              onChanged: _onQueryChanged,
              onSubmitted: (_) => _performSearch(),
              style: GoogleFonts.notoKufiArabic(
                color: AppTheme.warmWhite,
                fontSize: 15,
              ),
              decoration: InputDecoration(
                hintText: Ar.fatwaSearchHint,
                hintStyle: GoogleFonts.notoKufiArabic(
                  color: AppTheme.warmWhite.withValues( alpha: 0.3),
                  fontSize: 15,
                ),
                prefixIcon: IconButton(
                  icon: Icon(
                    Icons.search_rounded,
                    color: AppTheme.luxuryGold.withValues( alpha: 0.6),
                    size: 24,
                  ),
                  onPressed: _performSearch,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear_rounded,
                          color: AppTheme.warmWhite.withValues( alpha: 0.4),
                          size: 20,
                        ),
                        onPressed: () {
                          _searchController.clear();
                          _suggestions = [];
                          _showSuggestions = false;
                          ref.read(fatwaSearchProvider.notifier).clear();
                          setState(() {});
                        },
                      )
                    : null,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestions() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.darkGlassBlue.withValues( alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.luxuryGold.withValues( alpha: 0.08),
                width: 0.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: _suggestions.map((s) {
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      _searchController.text = s;
                      _showSuggestions = false;
                      _performSearch();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search_rounded,
                            size: 14,
                            color: AppTheme.luxuryGold.withValues( alpha: 0.4),
                          ),
                          const Spacer(),
                          Text(
                            s,
                            style: GoogleFonts.notoKufiArabic(
                              fontSize: 13,
                              color: AppTheme.warmWhite.withValues( alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  void _onQueryChanged(String value) {
    if (value.trim().length >= 2) {
      final ds = ref.read(fatwaLocalDataSourceProvider);
      _suggestions = ds.suggest(value.trim());
      _showSuggestions = _suggestions.isNotEmpty;
    } else {
      _suggestions = [];
      _showSuggestions = false;
    }
    setState(() {});
  }

  void _performSearch() {
    final query = _searchController.text.trim();
    _showSuggestions = false;
    if (query.isNotEmpty) {
      _focusNode.unfocus();
      ref.read(fatwaSearchProvider.notifier).search(query);
    }
  }

  void _openDetail(dynamic fatwa) {
    context.pushRoute('/fatwa-detail', extra: fatwa);
  }

  Widget _buildInitialState(List<String> recent, List<String> categories) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (recent.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(right: 4, bottom: 10),
              child: Row(
                children: [
                  Icon(
                    Icons.history_rounded,
                    size: 16,
                    color: AppTheme.luxuryGold.withValues( alpha: 0.7),
                  ),
                  const Gap(8),
                  Text(
                    Ar.recentSearches,
                    style: GoogleFonts.notoKufiArabic(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.warmWhite.withValues( alpha: 0.8),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => _clearHistory(),
                    child: Text(
                      Ar.clearHistory,
                      style: GoogleFonts.notoKufiArabic(
                        fontSize: 11,
                        color: AppTheme.luxuryGold.withValues( alpha: 0.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ...recent.map(
              (q) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _buildRecentItem(q),
              ),
            ),
            const Gap(24),
          ],
          _buildCategoriesRow(categories),
        ],
      ),
    );
  }

  Widget _buildRecentItem(String query) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.darkGlassBlue.withValues( alpha: 0.25),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.luxuryGold.withValues( alpha: 0.04),
              width: 0.5,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                _searchController.text = query;
                _performSearch();
              },
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.history_rounded,
                      size: 16,
                      color: AppTheme.warmWhite.withValues( alpha: 0.3),
                    ),
                    const Gap(12),
                    Expanded(
                      child: Text(
                        query,
                        style: GoogleFonts.notoKufiArabic(
                          fontSize: 13,
                          color: AppTheme.warmWhite.withValues( alpha: 0.6),
                        ),
                        textAlign: TextAlign.right,
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

  Widget _buildCategoriesRow(List<String> categories) {
    if (categories.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 4, bottom: 10),
          child: Row(
            children: [
              Icon(
                Icons.category_rounded,
                size: 16,
                color: AppTheme.luxuryGold.withValues( alpha: 0.7),
              ),
              const Gap(8),
              Text(
                Ar.fatwaCategories,
                style: GoogleFonts.notoKufiArabic(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.warmWhite.withValues( alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: categories.take(20).map((cat) {
            return GestureDetector(
              key: ValueKey('cat_$cat'),
              onTap: () => context.push('/fatwa-category', extra: cat),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.darkGlassBlue.withValues( alpha: 0.3),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppTheme.luxuryGold.withValues( alpha: 0.06),
                        width: 0.5,
                      ),
                    ),
                    child: Text(
                      cat,
                      style: GoogleFonts.notoKufiArabic(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.warmWhite.withValues( alpha: 0.7),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Future<void> _clearHistory() async {
    final repo = ref.read(fatwaRepositoryProvider);
    await repo.clearSearchHistory();
    ref.invalidate(recentSearchesProvider);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            Ar.historyCleared,
            style: GoogleFonts.notoKufiArabic(color: Colors.white),
          ),
          backgroundColor: AppTheme.darkGlassBlue,
        ),
      );
    }
  }
}

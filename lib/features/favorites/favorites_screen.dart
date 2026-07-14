import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import '../../core/arabic_strings.dart';
import '../../providers/favorites_provider.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/star_background.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = AppTheme.bgPrimary;
    final favorites = ref.watch(favoritesNotifierProvider);
    final w = MediaQuery.sizeOf(context).width;
    final verseFavorites = favorites
        .where((f) => f.type == FavoriteType.verse)
        .toList();
    final hadithFavorites = favorites
        .where((f) => f.type == FavoriteType.hadith)
        .toList();
    final adhkarFavorites = favorites
        .where((f) => f.type == FavoriteType.adhkar)
        .toList();

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          const StarBackground(),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(w),
                _buildTabBar(),
                _buildSearchBar(),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildFavoritesList(
                        _searchQuery.isEmpty
                            ? verseFavorites
                            : verseFavorites
                                .where((f) =>
                                    f.textArabic.contains(_searchQuery) ||
                                    f.reference.contains(_searchQuery))
                                .toList(),
                        FavoriteType.verse,
                        w,
                      ),
                      _buildFavoritesList(
                        _searchQuery.isEmpty
                            ? hadithFavorites
                            : hadithFavorites
                                .where((f) =>
                                    f.textArabic.contains(_searchQuery) ||
                                    f.reference.contains(_searchQuery))
                                .toList(),
                        FavoriteType.hadith,
                        w,
                      ),
                      _buildFavoritesList(
                        _searchQuery.isEmpty
                            ? adhkarFavorites
                            : adhkarFavorites
                                .where((f) =>
                                    f.textArabic.contains(_searchQuery) ||
                                    f.reference.contains(_searchQuery))
                                .toList(),
                        FavoriteType.adhkar,
                        w,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(double w) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w < 360 ? 16 : 20, vertical: 16),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_rounded,
              color: AppTheme.warmWhite.withValues(alpha: 0.8),
            ),
          ),
          const Gap(12),
          Text(
            Ar.favoritesTitle,
            style: GoogleFonts.notoKufiArabic(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.warmWhite,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.darkGlassBlue.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.luxuryGold.withValues(alpha: 0.08),
          width: 0.5,
        ),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          gradient: AppTheme.goldGradient,
          borderRadius: BorderRadius.circular(14),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: AppTheme.midnightNavy,
        unselectedLabelColor: AppTheme.warmWhite.withValues(alpha: 0.6),
        labelStyle: GoogleFonts.notoKufiArabic(
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: GoogleFonts.notoKufiArabic(
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        tabs: [
          Tab(text: Ar.versesTab),
          Tab(text: Ar.hadithTab),
          Tab(text: Ar.adhkarTab),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.darkGlassBlue.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppTheme.luxuryGold.withValues(alpha: 0.12),
                width: 0.5,
              ),
            ),
            child: TextField(
              controller: _searchController,
              style: GoogleFonts.notoKufiArabic(
                color: AppTheme.warmWhite,
                fontSize: 14,
              ),
              textDirection: TextDirection.rtl,
              decoration: InputDecoration(
                hintText: Ar.searchFavorites,
                hintStyle: GoogleFonts.notoKufiArabic(
                  color: AppTheme.warmWhite.withValues(alpha: 0.3),
                  fontSize: 14,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: AppTheme.luxuryGold.withValues(alpha: 0.6),
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear_rounded,
                          color: AppTheme.warmWhite.withValues(alpha: 0.4),
                          size: 18,
                        ),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFavoritesList(
    List<FavoriteModel> favorites,
    FavoriteType type,
    double w,
  ) {
    if (favorites.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_rounded,
              size: w < 360 ? 52 : 64,
              color: AppTheme.luxuryGold.withValues(alpha: 0.2),
            ),
            const Gap(16),
            Text(
              Ar.noFavoritesYet,
              style: GoogleFonts.notoKufiArabic(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.warmWhite.withValues(alpha: 0.7),
              ),
            ),
            const Gap(6),
            Text(
              Ar.addFavoritesHint,
              style: GoogleFonts.notoKufiArabic(
                fontSize: 12,
                color: AppTheme.warmWhite.withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final favorite = favorites[index];
        final isEven = index % 2 == 0;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.darkGlassBlue.withValues(alpha: 0.35),
                      AppTheme.darkGlassBlue.withValues(alpha: 0.15),
                    ],
                    begin: isEven ? Alignment.topLeft : Alignment.topRight,
                    end: isEven ? Alignment.bottomRight : Alignment.bottomLeft,
                  ),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: AppTheme.luxuryGold.withValues(alpha: 0.1),
                    width: 0.5,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppTheme.luxuryGold.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              favorite.reference,
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                color: AppTheme.luxuryGold,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Share.share(
                                    '${favorite.textArabic}\n\n- ${favorite.reference}',
                                  );
                                },
                                icon: Icon(
                                  Icons.share_rounded,
                                  color: AppTheme.warmWhite.withValues(alpha: 0.6),
                                  size: 20,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  ref
                                      .read(favoritesNotifierProvider.notifier)
                                      .remove(favorite.id);
                                },
                                icon: const Icon(
                                  Icons.delete_rounded,
                                  size: 20,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Gap(12),
                      Text(
                        favorite.textArabic,
                        style: GoogleFonts.amiri(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.warmWhite,
                          height: 1.8,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import '../../core/arabic_strings.dart';
import '../../services/data_service.dart';
import '../../models/api_models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/star_background.dart';
import '../quran/data/models/quran_index.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<SearchMatch> _searchResults = [];
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) {
      if (!mounted) return;
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    if (!mounted) return;
    setState(() => _isSearching = true);

    try {
      final results = await DataService.searchQuran(query);
      if (!mounted) return;
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSearching = false);
    }
  }

  Future<void> _openSurah(int number, String nameArabic, {int? initialAyah}) async {
    await QuranIndex.instance.initialize();
    final surah = QuranIndex.instance.getSurah(number);
    if (surah == null) return;

    int targetPage = surah.startPage;
    if (initialAyah != null) {
      final page = QuranIndex.instance.getPageForSurahAyah(number, initialAyah);
      if (page != null) targetPage = page;
    }

    if (!mounted) return;
    context.push('/mushaf?page=$targetPage');
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = AppTheme.bgPrimary;
    final w = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          const StarBackground(),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(w),
                _buildSearchBar(),
                Expanded(
                  child: _isSearching
                      ? const Center(child: CircularProgressIndicator(color: AppTheme.luxuryGold))
                      : _searchResults.isEmpty
                          ? _buildEmptyState(w)
                          : _buildSearchResults(),
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
            Ar.searchAppBar,
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

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.darkGlassBlue.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppTheme.luxuryGold.withValues(alpha: 0.15),
                width: 0.5,
              ),
            ),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              style: GoogleFonts.notoKufiArabic(
                color: AppTheme.warmWhite,
                fontSize: 14,
              ),
              textDirection: TextDirection.rtl,
              decoration: InputDecoration(
                hintText: Ar.searchQuranHint,
                hintStyle: GoogleFonts.notoKufiArabic(
                  color: AppTheme.warmWhite.withValues(alpha: 0.3),
                  fontSize: 14,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: AppTheme.luxuryGold.withValues(alpha: 0.6),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear_rounded,
                          color: AppTheme.warmWhite.withValues(alpha: 0.4),
                          size: 18,
                        ),
                        onPressed: () {
                          _searchController.clear();
                          _performSearch('');
                        },
                      )
                    : null,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              onChanged: (value) => _performSearch(value),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(double w) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_rounded,
            size: w < 360 ? 52 : 64,
            color: AppTheme.luxuryGold.withValues(alpha: 0.25),
          ),
          const Gap(16),
          Text(
            Ar.searchQuran,
            style: GoogleFonts.notoKufiArabic(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.warmWhite.withValues(alpha: 0.7),
            ),
          ),
          const Gap(6),
          Text(
            Ar.searchQuranSubtitle,
            style: GoogleFonts.notoKufiArabic(
              fontSize: 13,
              color: AppTheme.warmWhite.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final match = _searchResults[index];
        final isEven = index % 2 == 0;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.darkGlassBlue.withValues(alpha: 0.3),
                      AppTheme.darkGlassBlue.withValues(alpha: 0.1),
                    ],
                    begin: isEven ? Alignment.topLeft : Alignment.topRight,
                    end: isEven ? Alignment.bottomRight : Alignment.bottomLeft,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppTheme.luxuryGold.withValues(alpha: 0.1),
                    width: 0.5,
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _openSurah(
                      match.surah.number,
                      match.surah.name,
                      initialAyah: match.numberInSurah,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    splashColor: AppTheme.luxuryGold.withValues(alpha: 0.05),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppTheme.luxuryGold.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  'Ayah ${match.numberInSurah}',
                                  style: GoogleFonts.outfit(
                                    fontSize: 12,
                                    color: AppTheme.luxuryGold,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Text(
                                match.surah.name,
                                style: GoogleFonts.amiri(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.luxuryGold,
                                ),
                                textDirection: TextDirection.rtl,
                              ),
                            ],
                          ),
                          const Gap(12),
                          Text(
                            match.text,
                            style: GoogleFonts.amiri(
                              fontSize: 18,
                              color: AppTheme.warmWhite,
                              height: 1.6,
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                        ],
                      ),
                    ),
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

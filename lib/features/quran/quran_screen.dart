import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/arabic_strings.dart';
import '../../theme/app_theme.dart';
import '../../widgets/star_background.dart';
import 'data/models/quran_index.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadIndex();
  }

  Future<void> _loadIndex() async {
    try {
      await QuranIndex.instance.initialize();
    } catch (e, st) {
      debugPrint('[QuranScreen] Error loading index: $e');
      debugPrint('[QuranScreen] Stack: $st');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  List<SurahIndex> get _filteredSurahs {
    final surahs = QuranIndex.instance.surahs;
    if (_searchQuery.isEmpty) return surahs;
    return surahs
        .where(
          (s) =>
              s.name.contains(_searchQuery) ||
              s.englishName.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/quran');
          }
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.bgPrimary,
        body: Stack(
          children: [
            const StarBackground(),
            SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: _buildHeader()),
                  SliverToBoxAdapter(child: _buildSearchBar()),
                  if (_isLoading)
                    const SliverFillRemaining(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.goldPrimary,
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final surah = _filteredSurahs[index];
                          return _buildSurahCard(surah, index);
                        }, childCount: _filteredSurahs.length),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final w = MediaQuery.sizeOf(context).width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w < 360 ? 16 : 20, vertical: 20),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Centered title
          Column(
            children: [
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 800),
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [AppTheme.goldPrimary, AppTheme.goldSoft],
                      stops: [value, (value + 0.2).clamp(0.0, 1.0)],
                    ).createShader(bounds),
                    blendMode: BlendMode.srcIn,
                    child: child,
                  );
                },
                child: Text(
                  Ar.holyQuran,
                  style: GoogleFonts.notoKufiArabic(
                    fontSize: w < 360 ? 24 : 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
              const Gap(4),
              Text(
                '${QuranIndex.instance.surahs.length} سورة • هدى للعالمين',
                style: GoogleFonts.notoKufiArabic(
                  fontSize: 13,
                  color: AppTheme.warmWhite.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
          // Back button pinned to left
          Positioned(
            left: 0,
            child: Tooltip(
              message: 'رجوع',
              child: Semantics(
                label: 'رجوع',
                button: true,
                child: _GlassBackButton(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go('/quran');
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.darkGlassBlue.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppTheme.luxuryGold.withValues(alpha: 0.08),
                width: 0.5,
              ),
            ),
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              style: GoogleFonts.notoKufiArabic(
                color: AppTheme.warmWhite,
                fontSize: 14,
              ),
              textDirection: TextDirection.rtl,
              decoration: InputDecoration(
                hintText: Ar.searchSurah,
                hintStyle: GoogleFonts.notoKufiArabic(
                  color: AppTheme.warmWhite.withValues(alpha: 0.3),
                  fontSize: 14,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: AppTheme.luxuryGold.withValues(alpha: 0.5),
                  size: 20,
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear_rounded,
                          color: AppTheme.warmWhite.withValues(alpha: 0.4),
                          size: 18,
                        ),
                        onPressed: () => setState(() => _searchQuery = ''),
                      )
                    : null,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSurahCard(SurahIndex surah, int index) {
    final isEven = index % 2 == 0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Hero(
        tag: 'surah-${surah.number}',
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
                  onTap: () => _openSurah(surah.number, surah.name),
                  borderRadius: BorderRadius.circular(20),
                  splashColor: AppTheme.luxuryGold.withValues(alpha: 0.05),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppTheme.luxuryGold.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '${surah.number}',
                              style: GoogleFonts.outfit(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.luxuryGold,
                              ),
                            ),
                          ),
                        ),
                        const Gap(16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                surah.englishName,
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.warmWhite,
                                ),
                              ),
                              const Gap(4),
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      surah.revelationType == 'Meccan'
                                          ? 'مكية'
                                          : 'مدنية',
                                      style: GoogleFonts.notoKufiArabic(
                                        fontSize: 12,
                                        color: AppTheme.luxuryGold.withValues(
                                          alpha: 0.7,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    ' • ',
                                    style: TextStyle(
                                      color: AppTheme.warmWhite.withValues(
                                        alpha: 0.3,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      '${surah.numberOfAyahs} Verses',
                                      style: GoogleFonts.outfit(
                                        fontSize: 12,
                                        color: AppTheme.warmWhite.withValues(
                                          alpha: 0.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    ' • ',
                                    style: TextStyle(
                                      color: AppTheme.warmWhite.withValues(
                                        alpha: 0.3,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      'الجزء ${surah.juz}',
                                      style: GoogleFonts.notoKufiArabic(
                                        fontSize: 11,
                                        color: AppTheme.warmWhite.withValues(
                                          alpha: 0.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Text(
                          surah.name,
                          style: GoogleFonts.amiri(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.luxuryGold,
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
      ),
    );
  }

  Future<void> _openSurah(
    int number,
    String nameArabic, {
    int? initialAyah,
  }) async {
    await QuranIndex.instance.initialize();
    final surah = QuranIndex.instance.getSurah(number);
    if (surah == null || !mounted) return;

    int targetPage = surah.startPage;
    if (initialAyah != null) {
      final page = QuranIndex.instance.getPageForSurahAyah(number, initialAyah);
      if (page != null) targetPage = page;
    }

    if (!mounted) return;
    context.push('/mushaf?page=$targetPage');
  }
}

// ─── Glassmorphism Back Button ───────────────────────────────────────────────

class _GlassBackButton extends StatefulWidget {
  final VoidCallback onTap;
  const _GlassBackButton({required this.onTap});

  @override
  State<_GlassBackButton> createState() => _GlassBackButtonState();
}

class _GlassBackButtonState extends State<_GlassBackButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scale = Tween<double>(
      begin: 1.0,
      end: 0.88,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: ClipOval(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.darkGlassBlue.withValues(alpha: 0.45),
                border: Border.all(
                  color: AppTheme.luxuryGold.withValues(alpha: 0.35),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.glowGold,
                    blurRadius: 12,
                    spreadRadius: -4,
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppTheme.luxuryGold,
                size: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

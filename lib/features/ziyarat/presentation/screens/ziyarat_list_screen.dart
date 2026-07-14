import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../theme/app_theme.dart';
import '../../../../theme/ds_components.dart';
import '../../../../widgets/star_background.dart';
import '../../../../widgets/islamic_art.dart';
import '../providers/ziyarat_providers.dart';
import '../widgets/bento_tile.dart';
import '../widgets/ziyarat_card.dart';
import 'content_detail_screen.dart';
import 'sahifa_screen.dart';
import 'mafatih_screen.dart';
import 'occasion_screen.dart';

class ZiyaratListScreen extends ConsumerStatefulWidget {
  const ZiyaratListScreen({super.key});

  @override
  ConsumerState<ZiyaratListScreen> createState() =>
      _ZiyaratListScreenState();
}

class _ZiyaratListScreenState extends ConsumerState<ZiyaratListScreen>
    with SingleTickerProviderStateMixin {
  int _selectedFilter = 0;
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final ziyarat = ref.watch(ziyaratListProvider);
    final duas = ref.watch(duasListProvider);
    final sahifa = ref.watch(sahifaListProvider);
    final mafatih = ref.watch(mafatihListProvider);
    final occasions = ref.watch(occasionsListProvider);

    return Scaffold(
      body: IslamicBackground(
        child: SafeArea(
          bottom: false,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                    w < 360 ? 16 : 20, 20, w < 360 ? 16 : 20, 0),
                sliver: SliverToBoxAdapter(child: _buildHeader()),
              ),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                    w < 360 ? 16 : 20, w < 360 ? 18 : 24, w < 360 ? 16 : 20, 0),
                sliver: SliverToBoxAdapter(
                  child: _FeaturedVerseCard(
                    ziyaratAsync: ziyarat,
                    duasAsync: duas,
                    entranceDelay: const Duration(milliseconds: 120),
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                    w < 360 ? 16 : 20, 28, w < 360 ? 16 : 20, 0),
                sliver: SliverToBoxAdapter(child: _buildFilterChips()),
              ),
              SliverPadding(
                padding: EdgeInsets.only(top: w < 360 ? 18 : 24),
                sliver: SliverToBoxAdapter(
                  child: _buildBentoGrid(
                    context,
                    ref,
                    ziyarat: ziyarat,
                    duas: duas,
                    sahifa: sahifa,
                    mafatih: mafatih,
                    occasions: occasions,
                  ),
                ),
              ),
              const SliverPadding(padding: EdgeInsets.only(bottom: 120)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        GestureDetector(
          onTap: _showSearchSheet,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.goldPrimary.withValues(alpha: 0.1),
                  AppTheme.goldPrimary.withValues(alpha: 0.04),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppTheme.goldPrimary.withValues(alpha: 0.12),
                width: 0.5,
              ),
            ),
            child: Icon(
              Icons.search_rounded,
              size: 21,
              color: AppTheme.goldPrimary.withValues(alpha: 0.8),
            ),
          ),
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'الزيارات والأدعية',
                  style: GoogleFonts.notoKufiArabic(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                    height: 1.2,
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 4,
                  height: 30,
                  decoration: BoxDecoration(
                    gradient: AppTheme.goldGradient,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'تراث أهل البيت عليهم السلام',
              style: GoogleFonts.notoKufiArabic(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppTheme.textMuted,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
        const SizedBox(width: 12),
        IslamicStar(
          size: 38,
          color: AppTheme.goldPrimary.withValues(alpha: 0.2),
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    const labels = ['الكل', 'المفضلة', 'آخر قراءة', 'القصيرة', 'المشهورة'];
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: labels.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isActive = _selectedFilter == index;
          return GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() => _selectedFilter = index);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 240),
              curve: Curves.easeOutCubic,
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                gradient: isActive
                    ? LinearGradient(
                        colors: [
                          AppTheme.goldPrimary.withValues(alpha: 0.14),
                          AppTheme.goldPrimary.withValues(alpha: 0.06),
                        ],
                      )
                    : null,
                color: isActive ? null : AppTheme.bgCard.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isActive
                      ? AppTheme.goldPrimary.withValues(alpha: 0.35)
                      : AppTheme.borderColor.withValues(alpha: 0.6),
                  width: 0.5,
                ),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: AppTheme.goldPrimary.withValues(alpha: 0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                labels[index],
                style: GoogleFonts.notoKufiArabic(
                  fontSize: 13,
                  fontWeight:
                      isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive
                      ? AppTheme.goldPrimary
                      : AppTheme.textMuted,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBentoGrid(
    BuildContext context,
    WidgetRef ref, {
    required AsyncValue ziyarat,
    required AsyncValue duas,
    required AsyncValue sahifa,
    required AsyncValue mafatih,
    required AsyncValue occasions,
  }) {
    final anyLoading = ziyarat.isLoading ||
        duas.isLoading ||
        sahifa.isLoading ||
        mafatih.isLoading ||
        occasions.isLoading;

    if (anyLoading) {
      return _buildLoadingSkeleton();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final bw = constraints.maxWidth;
        final mw = MediaQuery.sizeOf(context).width;
        const gap = 12.0;
        const fullH = 220.0;
        const halfH = 130.0;
        const midH = 170.0;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: mw < 360 ? 16 : 20),
          child: Column(
            children: [
              _ZiyaratWideTile(
                height: fullH,
                count: _getDataLength(ziyarat),
                entranceDelay: const Duration(milliseconds: 200),
                onTap: () =>
                    _openCategory(context, ref, 'ziyarat', ziyarat),
              ),
              SizedBox(height: gap),
              Row(
                children: [
                  Expanded(
                    child: _DuaCompactTile(
                      height: halfH,
                      count: _getDataLength(duas),
                      entranceDelay: const Duration(milliseconds: 300),
                      onTap: () =>
                          _openCategory(context, ref, 'duas', duas),
                    ),
                  ),
                  SizedBox(width: gap),
                  Expanded(
                    child: _SahifaEditorialTile(
                      height: halfH,
                      count: _getDataLength(sahifa),
                      entranceDelay: const Duration(milliseconds: 380),
                      onTap: () =>
                          _pushScreen(context, const SahifaScreen()),
                    ),
                  ),
                ],
              ),
              SizedBox(height: gap),
              Row(
                children: [
                  SizedBox(
                    width: bw * 0.42,
                    child: _MafatihLibraryTile(
                      height: midH,
                      count: _getDataLength(mafatih),
                      entranceDelay: const Duration(milliseconds: 460),
                      onTap: () =>
                          _pushScreen(context, const MafatihScreen()),
                    ),
                  ),
                  SizedBox(width: gap),
                  Expanded(
                    child: _OccasionsTimelineTile(
                      height: midH,
                      count: _getDataLength(occasions),
                      entranceDelay: const Duration(milliseconds: 540),
                      onTap: () =>
                          _pushScreen(context, const OccasionScreen()),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadingSkeleton() {
    final w = MediaQuery.sizeOf(context).width;
    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, _) {
        final v = _shimmerController.value;
        return Padding(
          padding:
              EdgeInsets.symmetric(horizontal: w < 360 ? 16 : 20),
          child: Column(
            children: [
              _buildShimmerTile(220, v, 0.0),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildShimmerTile(130, v, 0.15)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildShimmerTile(130, v, 0.25)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(flex: 2, child: _buildShimmerTile(170, v, 0.35)),
                  const SizedBox(width: 12),
                  Expanded(flex: 3, child: _buildShimmerTile(170, v, 0.45)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShimmerTile(double height, double animValue, double offset) {
    final t = ((animValue + offset) % 1.0);
    final shimmerX = -1.0 + 3.0 * t;

    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            AppTheme.bgCard.withValues(alpha: 0.35),
            AppTheme.bgSurface.withValues(alpha: 0.12),
            AppTheme.bgCard.withValues(alpha: 0.35),
          ],
        ),
        border: Border.all(
          color: AppTheme.borderColor.withValues(alpha: 0.35),
          width: 0.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: ShaderMask(
          shaderCallback: (rect) {
            return LinearGradient(
              begin: Alignment(shimmerX - 0.5, 0),
              end: Alignment(shimmerX + 0.5, 0),
              colors: const [
                Colors.transparent,
                Colors.white24,
                Colors.transparent,
              ],
            ).createShader(rect);
          },
          blendMode: BlendMode.srcATop,
          child: Container(
            color: AppTheme.bgCard.withValues(alpha: 0.2),
          ),
        ),
      ),
    );
  }

  int _getDataLength(AsyncValue asyncValue) {
    return asyncValue.when(
      data: (data) => (data as List).length,
      loading: () => 0,
      error: (_, __) => 0,
    );
  }

  void _openCategory(
    BuildContext context,
    WidgetRef ref,
    String type,
    AsyncValue asyncValue,
  ) {
    asyncValue.whenData((data) {
      final list = data as List;
      _pushScreen(context, _ContentListScreen(type: type, items: list));
    });
  }

  void _pushScreen(BuildContext context, Widget screen) {
    Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (_, __, ___) => screen,
      transitionDuration: const Duration(milliseconds: 350),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          ),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.04),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: child,
          ),
        );
      },
    ));
  }

  void _showSearchSheet() {
    IslamicBottomSheet.show(
      context,
      const _SearchSheetContent(),
      initial: 0.85,
    );
  }
}

// ═══════════════════════════════════════════════
// FEATURED VERSE CARD
// ═══════════════════════════════════════════════

class _FeaturedVerseCard extends StatelessWidget {
  final AsyncValue ziyaratAsync;
  final AsyncValue duasAsync;
  final Duration entranceDelay;

  const _FeaturedVerseCard({
    required this.ziyaratAsync,
    required this.duasAsync,
    this.entranceDelay = Duration.zero,
  });

  @override
  Widget build(BuildContext context) {
    return BentoTile(
      height: 168,
      heroTag: 'featured_verse',
      entranceDelay: entranceDelay,
      accentColor: AppTheme.goldPrimary,
      backgroundImage: const DecorationImage(
        image: AssetImage('assets/images/ziaratbg.png'),
        fit: BoxFit.cover,
      ),
      gradient: LinearGradient(
        colors: [
          Color(0xFF0D1E36).withValues(alpha: 0.30),
          Color(0xFF0D1E36).withValues(alpha: 0.25),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderColor: AppTheme.goldPrimary.withValues(alpha: 0.22),
      padding: const EdgeInsets.all(24),
      onTap: () => _navigateToFeature(context),
      child: Stack(
        children: [
          Positioned(
            left: -8,
            bottom: -12,
            child: Opacity(
              opacity: 0.06,
              child: MosqueSilhouette(
                height: 130,
                color: AppTheme.goldPrimary,
              ),
            ),
          ),
          Positioned(
            left: 20,
            bottom: 20,
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 16,
              color: AppTheme.goldPrimary.withValues(alpha: 0.35),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 160,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      IslamicStar(
                        size: 18,
                        color: AppTheme.goldPrimary.withValues(alpha: 0.2),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.goldPrimary.withValues(alpha: 0.12),
                              AppTheme.goldPrimary.withValues(alpha: 0.04),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppTheme.goldPrimary.withValues(alpha: 0.1),
                            width: 0.5,
                          ),
                        ),
                        child: Text(
                          'ورْد اليوم',
                          style: GoogleFonts.notoKufiArabic(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color:
                                AppTheme.goldPrimary.withValues(alpha: 0.85),
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    _getFeaturedText(),
                    style: GoogleFonts.notoNaskhArabic(
                      fontSize: 17,
                      color: AppTheme.goldSoft.withValues(alpha: 0.9),
                      height: 1.9,
                    ),
                    textAlign: TextAlign.right,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _getFeaturedSource(),
                    textAlign: TextAlign.right,
                    style: GoogleFonts.notoKufiArabic(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textMuted.withValues(alpha: 0.6),
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getFeaturedText() {
    String? text;
    ziyaratAsync.whenData((list) {
      if (list.isNotEmpty && text == null) {
        final day = DateTime.now().millisecondsSinceEpoch ~/
            Duration.millisecondsPerDay;
        final item = list[day % list.length];
        text = item.fullText.length > 100
            ? '${item.fullText.substring(0, 100)}...'
            : item.fullText;
      }
    });
    if (text != null) return text!;

    duasAsync.whenData((list) {
      if (list.isNotEmpty && text == null) {
        final day = DateTime.now().millisecondsSinceEpoch ~/
            Duration.millisecondsPerDay;
        final item = list[(day + 7) % list.length];
        text = item.fullText.length > 100
            ? '${item.fullText.substring(0, 100)}...'
            : item.fullText;
      }
    });

    return text ?? 'بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ';
  }

  String _getFeaturedSource() {
    String? source;
    ziyaratAsync.whenData((list) {
      if (list.isNotEmpty && source == null) {
        final day = DateTime.now().millisecondsSinceEpoch ~/
            Duration.millisecondsPerDay;
        source = list[day % list.length].source;
      }
    });
    if (source != null) return source!;

    duasAsync.whenData((list) {
      if (list.isNotEmpty && source == null) {
        final day = DateTime.now().millisecondsSinceEpoch ~/
            Duration.millisecondsPerDay;
        source = list[(day + 7) % list.length].source;
      }
    });

    return source ?? '';
  }

  void _navigateToFeature(BuildContext context) {
    ziyaratAsync.whenData((list) {
      if (list.isNotEmpty) {
        final day = DateTime.now().millisecondsSinceEpoch ~/
            Duration.millisecondsPerDay;
        final item = list[day % list.length];
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => ContentDetailScreen(
            id: item.id,
            type: 'ziyarat',
            title: item.title,
            fullText: item.fullText,
            source: item.source,
            estimatedMinutes: item.estimatedMinutes,
            sectionCount: item.sectionCount,
          ),
        ));
      }
    });
  }
}

// ═══════════════════════════════════════════════
// ZIYARAT — WIDE FEATURE TILE
// ═══════════════════════════════════════════════

class _ZiyaratWideTile extends StatelessWidget {
  final double height;
  final int count;
  final VoidCallback onTap;
  final Duration entranceDelay;

  const _ZiyaratWideTile({
    required this.height,
    required this.count,
    required this.onTap,
    this.entranceDelay = Duration.zero,
  });

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFFD4AF37);
    return BentoTile(
      height: height,
      heroTag: 'ziyarat_tile',
      entranceDelay: entranceDelay,
      accentColor: accent,
      backgroundImage: const DecorationImage(
        image: AssetImage('assets/images/ziaratbackground.jpg'),
        fit: BoxFit.cover,
        alignment: Alignment.centerLeft,
        filterQuality: FilterQuality.high,
      ),
      gradient: LinearGradient(
        colors: [
          Colors.transparent,
          Color(0xFF0D1E36).withValues(alpha: 0.05),
          Color(0xFF0D1E36).withValues(alpha: 0.20),
          Color(0xFF0D1E36).withValues(alpha: 0.45),
          Color(0xFF0D1E36).withValues(alpha: 0.82),
          Color(0xFF0D1E36).withValues(alpha: 0.96),
        ],
        stops: [0.0, 0.18, 0.38, 0.55, 0.75, 1.0],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
      borderColor: accent.withValues(alpha: 0.2),
      padding: const EdgeInsets.all(24),
      onTap: onTap,
      child: Stack(
        children: [
          Positioned(
            left: 12,
            bottom: 4,
            child: Opacity(
              opacity: 0.05,
              child: MosqueSilhouette(
                height: 150,
                color: accent,
              ),
            ),
          ),
          Positioned(
            left: 24,
            bottom: 24,
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 16,
              color: accent.withValues(alpha: 0.4),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 160,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      IslamicStar(
                        size: 22,
                        color: accent.withValues(alpha: 0.18),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              accent.withValues(alpha: 0.12),
                              accent.withValues(alpha: 0.04),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: accent.withValues(alpha: 0.1),
                            width: 0.5,
                          ),
                        ),
                        child: Text(
                          '$count زيارة',
                          style: GoogleFonts.notoKufiArabic(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: accent.withValues(alpha: 0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    'الزيارات',
                    style: GoogleFonts.notoKufiArabic(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'زيارات مأثورة عن أهل البيت عليهم السلام',
                    style: GoogleFonts.notoKufiArabic(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textMuted.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════
// DUAS — COMPACT TILE
// ═══════════════════════════════════════════════

class _DuaCompactTile extends StatelessWidget {
  final double height;
  final int count;
  final VoidCallback onTap;
  final Duration entranceDelay;

  const _DuaCompactTile({
    required this.height,
    required this.count,
    required this.onTap,
    this.entranceDelay = Duration.zero,
  });

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF64B5F6);
    return BentoTile(
      height: height,
      heroTag: 'dua_tile',
      entranceDelay: entranceDelay,
      accentColor: accent,
      backgroundImage: const DecorationImage(
        image: AssetImage('assets/images/adyabg.png'),
        fit: BoxFit.cover,
        alignment: Alignment.centerLeft,
      ),
      gradient: LinearGradient(
        colors: [
          Colors.transparent,
          Color(0xFF0D1E36).withValues(alpha: 0.20),
          Color(0xFF0D1E36).withValues(alpha: 0.60),
          Color(0xFF0D1E36).withValues(alpha: 0.88),
          Color(0xFF0D1E36).withValues(alpha: 0.95),
        ],
        stops: [0.0, 0.25, 0.45, 0.7, 1.0],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
      borderColor: accent.withValues(alpha: 0.18),
      padding: const EdgeInsets.all(18),
      onTap: onTap,
      child: Stack(
        children: [
          Positioned(
            left: 6,
            bottom: 2,
            child: Opacity(
              opacity: 0.1,
              child: PrayerBeadsIllustration(
                size: 54,
                color: accent,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 130,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          accent.withValues(alpha: 0.12),
                          accent.withValues(alpha: 0.04),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: accent.withValues(alpha: 0.1),
                        width: 0.5,
                      ),
                    ),
                    child: Text(
                      '$count',
                      style: GoogleFonts.notoKufiArabic(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: accent.withValues(alpha: 0.85),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'الأدعية',
                    style: GoogleFonts.notoKufiArabic(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'مناجاة ودعاء',
                    style: GoogleFonts.notoKufiArabic(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textMuted.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════
// SAHIFA — MANUSCRIPT EDITORIAL TILE
// ═══════════════════════════════════════════════

class _SahifaEditorialTile extends StatelessWidget {
  final double height;
  final int count;
  final VoidCallback onTap;
  final Duration entranceDelay;

  const _SahifaEditorialTile({
    required this.height,
    required this.count,
    required this.onTap,
    this.entranceDelay = Duration.zero,
  });

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF81C784);
    return BentoTile(
      height: height,
      heroTag: 'sahifa_tile',
      entranceDelay: entranceDelay,
      accentColor: accent,
      backgroundImage: const DecorationImage(
        image: AssetImage('assets/images/sahifasjadiabg.png'),
        fit: BoxFit.cover,
        alignment: Alignment.centerLeft,
      ),
      gradient: LinearGradient(
        colors: [
          Colors.transparent,
          Color(0xFF0D1E36).withValues(alpha: 0.20),
          Color(0xFF0D1E36).withValues(alpha: 0.60),
          Color(0xFF0D1E36).withValues(alpha: 0.88),
          Color(0xFF0D1E36).withValues(alpha: 0.95),
        ],
        stops: [0.0, 0.25, 0.45, 0.7, 1.0],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
      borderColor: accent.withValues(alpha: 0.18),
      padding: const EdgeInsets.all(18),
      onTap: onTap,
      child: Stack(
        children: [
          Positioned(
            right: 2,
            top: 2,
            child: Opacity(
              opacity: 0.07,
              child: IslamicArch(
                width: 54,
                height: 44,
                color: accent,
                opacity: 0.3,
              ),
            ),
          ),
          Positioned(
            left: 6,
            bottom: 2,
            child: Opacity(
              opacity: 0.06,
              child: _ManuscriptLines(
                width: 64,
                color: accent,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 130,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          accent.withValues(alpha: 0.12),
                          accent.withValues(alpha: 0.04),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: accent.withValues(alpha: 0.1),
                        width: 0.5,
                      ),
                    ),
                    child: Text(
                      '$count',
                      style: GoogleFonts.notoKufiArabic(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: accent.withValues(alpha: 0.85),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'الصحيفة السجادية',
                    style: GoogleFonts.notoKufiArabic(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'كلمات الإمام زين العابدين',
                    style: GoogleFonts.notoKufiArabic(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textMuted.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ManuscriptLines extends StatelessWidget {
  final double width;
  final Color color;

  const _ManuscriptLines({required this.width, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        5,
        (i) => Container(
          width: width - i * 10.0,
          height: 1,
          margin: const EdgeInsets.only(bottom: 4),
          color: color.withValues(alpha: 0.12),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════
// MAFATIH — LIBRARY TILE
// ═══════════════════════════════════════════════

class _MafatihLibraryTile extends StatelessWidget {
  final double height;
  final int count;
  final VoidCallback onTap;
  final Duration entranceDelay;

  const _MafatihLibraryTile({
    required this.height,
    required this.count,
    required this.onTap,
    this.entranceDelay = Duration.zero,
  });

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFFCE93D8);
    return BentoTile(
      height: height,
      heroTag: 'mafatih_tile',
      entranceDelay: entranceDelay,
      accentColor: accent,
      backgroundImage: const DecorationImage(
        image: AssetImage('assets/images/mfatihbg.jpg'),
        fit: BoxFit.cover,
        alignment: Alignment.centerLeft,
        filterQuality: FilterQuality.high,
      ),
      gradient: LinearGradient(
        colors: [
          Colors.transparent,
          Color(0xFF0D1E36).withValues(alpha: 0.05),
          Color(0xFF0D1E36).withValues(alpha: 0.20),
          Color(0xFF0D1E36).withValues(alpha: 0.45),
          Color(0xFF0D1E36).withValues(alpha: 0.82),
          Color(0xFF0D1E36).withValues(alpha: 0.96),
        ],
        stops: [0.0, 0.18, 0.38, 0.55, 0.75, 1.0],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
      borderColor: accent.withValues(alpha: 0.18),
      padding: const EdgeInsets.all(18),
      onTap: onTap,
      child: Stack(
        children: [
          Positioned(
            left: 2,
            bottom: 6,
            child: Opacity(
              opacity: 0.07,
              child: OpenQuranIllustration(
                width: 74,
                height: 56,
                color: accent,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 130,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          accent.withValues(alpha: 0.12),
                          accent.withValues(alpha: 0.04),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: accent.withValues(alpha: 0.1),
                        width: 0.5,
                      ),
                    ),
                    child: Text(
                      '$count',
                      style: GoogleFonts.notoKufiArabic(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: accent.withValues(alpha: 0.85),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'مفاتيح',
                    style: GoogleFonts.notoKufiArabic(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary,
                      height: 1.1,
                    ),
                  ),
                  Text(
                    'الجنان',
                    style: GoogleFonts.notoKufiArabic(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'الأدعية والزيارات',
                    style: GoogleFonts.notoKufiArabic(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textMuted.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════
// OCCASIONS — TIMELINE TILE
// ═══════════════════════════════════════════════

class _OccasionsTimelineTile extends StatelessWidget {
  final double height;
  final int count;
  final VoidCallback onTap;
  final Duration entranceDelay;

  const _OccasionsTimelineTile({
    required this.height,
    required this.count,
    required this.onTap,
    this.entranceDelay = Duration.zero,
  });

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFFFF8A65);
    return BentoTile(
      height: height,
      heroTag: 'occasions_tile',
      entranceDelay: entranceDelay,
      accentColor: accent,
      backgroundImage: const DecorationImage(
        image: AssetImage('assets/images/munasabatbg.png'),
        fit: BoxFit.cover,
        alignment: Alignment.centerLeft,
      ),
      gradient: LinearGradient(
        colors: [
          Colors.transparent,
          Color(0xFF0D1E36).withValues(alpha: 0.20),
          Color(0xFF0D1E36).withValues(alpha: 0.60),
          Color(0xFF0D1E36).withValues(alpha: 0.88),
          Color(0xFF0D1E36).withValues(alpha: 0.95),
        ],
        stops: [0.0, 0.25, 0.45, 0.7, 1.0],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
      borderColor: accent.withValues(alpha: 0.18),
      padding: const EdgeInsets.all(18),
      onTap: onTap,
      child: Stack(
        children: [
          Positioned(
            left: 10,
            bottom: 28,
            child: Opacity(
              opacity: 0.1,
              child: GoldenCrescent(
                size: 48,
                color: accent,
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 14,
            child: CustomPaint(
              size: const Size(140, 2),
              painter: _TimelineLinePainter(color: accent),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 130,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          accent.withValues(alpha: 0.12),
                          accent.withValues(alpha: 0.04),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: accent.withValues(alpha: 0.1),
                        width: 0.5,
                      ),
                    ),
                    child: Text(
                      '$count مناسبة',
                      style: GoogleFonts.notoKufiArabic(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: accent.withValues(alpha: 0.85),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'المناسبات',
                    style: GoogleFonts.notoKufiArabic(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary,
                      height: 1.1,
                    ),
                  ),
                  Text(
                    'الإسلامية',
                    style: GoogleFonts.notoKufiArabic(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'أعمال ومناسبات',
                    style: GoogleFonts.notoKufiArabic(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textMuted.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineLinePainter extends CustomPainter {
  final Color color;
  _TimelineLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = color.withValues(alpha: 0.18)
      ..strokeWidth = 1;

    canvas.drawLine(Offset(0, 0), Offset(size.width, 0), linePaint);

    final dotPaint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(const Offset(0, 0), 3, dotPaint);
    canvas.drawCircle(Offset(size.width, 0), 3, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ═══════════════════════════════════════════════
// SEARCH SHEET
// ═══════════════════════════════════════════════

class _SearchSheetContent extends StatelessWidget {
  const _SearchSheetContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 22,
              decoration: BoxDecoration(
                gradient: AppTheme.goldGradient,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'بحث',
              style: GoogleFonts.notoKufiArabic(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppTheme.bgCard.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.goldPrimary.withValues(alpha: 0.1),
              width: 0.5,
            ),
          ),
          child: TextField(
            textDirection: TextDirection.rtl,
            style: GoogleFonts.notoKufiArabic(
              fontSize: 14,
              color: AppTheme.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: 'ابحث عن زيارة أو دعاء...',
              hintStyle: GoogleFonts.notoKufiArabic(
                fontSize: 13,
                color: AppTheme.textMuted,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14),
              prefixIcon: Icon(
                Icons.search_rounded,
                color: AppTheme.goldPrimary.withValues(alpha: 0.5),
                size: 20,
              ),
            ),
          ),
        ),
        const SizedBox(height: 28),
        Center(
          child: Text(
            'ابدأ الكتابة للبحث...',
            style: GoogleFonts.notoKufiArabic(
              fontSize: 13,
              color: AppTheme.textMuted.withValues(alpha: 0.5),
            ),
          ),
        ),
        const SizedBox(height: 48),
      ],
    );
  }
}

// ═══════════════════════════════════════════════
// CONTENT LIST (premium redesign)
// ═══════════════════════════════════════════════

class _ContentListScreen extends StatelessWidget {
  final String type;
  final List<dynamic> items;
  const _ContentListScreen(
      {required this.type, required this.items});

  @override
  Widget build(BuildContext context) {
    final title = type == 'ziyarat' ? 'الزيارات' : 'الأدعية';
    final accent = type == 'ziyarat'
        ? const Color(0xFFD4AF37)
        : const Color(0xFF64B5F6);
    final icon = type == 'ziyarat'
        ? Icons.mosque_rounded
        : Icons.volunteer_activism_rounded;

    return Scaffold(
      body: IslamicBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.goldPrimary
                                  .withValues(alpha: 0.1),
                              AppTheme.goldPrimary
                                  .withValues(alpha: 0.04),
                            ],
                          ),
                          borderRadius:
                              BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.goldPrimary
                                .withValues(alpha: 0.12),
                            width: 0.5,
                          ),
                        ),
                        child: Icon(
                          Icons.arrow_forward_rounded,
                          color: AppTheme.textPrimary
                              .withValues(alpha: 0.8),
                          size: 20,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.notoKufiArabic(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textPrimary,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                        const SizedBox(width: 10),
                        Container(
                          width: 4,
                          height: 26,
                          decoration: BoxDecoration(
                            gradient: AppTheme.goldGradient,
                            borderRadius:
                                BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    IslamicStar(
                      size: 36,
                      color: accent.withValues(alpha: 0.2),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Expanded(
                child: ListView.builder(
                  padding:
                      const EdgeInsets.fromLTRB(20, 4, 20, 100),
                  itemCount: items.length,
                  itemBuilder: (_, i) {
                    final item = items[i];
                    final id = item.id;
                    return ContentCard(
                      index: i,
                      accentColor: accent,
                      title: item.title,
                      subtitle: item.source,
                      icon: icon,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ContentDetailScreen(
                              id: id,
                              type: type,
                              title: item.title,
                              fullText: item.fullText,
                              source: item.source,
                              estimatedMinutes:
                                  item.estimatedMinutes,
                              sectionCount: item.sectionCount,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

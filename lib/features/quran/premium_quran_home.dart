import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';
import '../../theme/app_theme.dart';
import '../../widgets/star_background.dart';
import '../bookmarks/data/repository/bookmark_repository.dart';
import '../bookmarks/data/models/bookmark_models.dart';
import 'data/models/quran_index.dart';
import 'data/repository/quran_repository.dart';
import 'quran_screen.dart';

class PremiumQuranHomePage extends ConsumerStatefulWidget {
  const PremiumQuranHomePage({super.key});

  @override
  ConsumerState<PremiumQuranHomePage> createState() =>
      _PremiumQuranHomePageState();
}

class _PremiumQuranHomePageState extends ConsumerState<PremiumQuranHomePage> {
  static const _fahrasBg = AssetImage('assets/images/fahrasbcakground.png');

  ReadingProgress? _lastRead;
  bool _loadingLastRead = true;

  Map<String, dynamic>? _dailyVerse;
  bool _loadingVerse = true;
  String _dailyVerseEnglish = '';

  @override
  void initState() {
    super.initState();
    _loadProgress();
    _loadDailyVerse();
  }

  Future<void> _loadProgress() async {
    try {
      await QuranIndex.instance.initialize();
      final repo = ref.read(bookmarkRepositoryProvider);
      final progress = await repo.getLastRead();
      if (mounted) {
        setState(() {
          _lastRead = progress;
          _loadingLastRead = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _loadingLastRead = false;
        });
      }
    }
  }

  Future<void> _loadDailyVerse() async {
    try {
      final repo = ref.read(quranRepositoryProvider);
      final verse = await repo.getDailyAyah();
      if (mounted && verse.isNotEmpty) {
        final english = verse['english'] as String? ?? '';
        setState(() {
          _dailyVerse = verse;
          _dailyVerseEnglish = english;
          _loadingVerse = false;
        });
        return;
      }
    } catch (_) {}
    if (mounted) {
      setState(() {
        _loadingVerse = false;
      });
    }
  }

  Future<void> _openSurah(
    int number,
    String nameArabic, {
    int? initialAyah,
  }) async {
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

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          const StarBackground(),
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Premium Header
                SliverToBoxAdapter(child: _buildHeader()),

                // Welcome / Overview
                SliverToBoxAdapter(child: _buildOverviewSection()),

                // Quick Grid Actions
                SliverToBoxAdapter(child: _buildQuickActionsGrid()),

                // Daily Verse Card
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  sliver: SliverToBoxAdapter(child: _buildDailyVerseCard()),
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
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 36,
                decoration: BoxDecoration(
                  gradient: AppTheme.goldGradient,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Gap(16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'القرآن الكريم',
                    style: GoogleFonts.notoKufiArabic(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.warmWhite,
                    ),
                  ),
                  Text(
                    'المصحف الشريف',
                    style: GoogleFonts.notoKufiArabic(
                      fontSize: 13,
                      color: AppTheme.warmWhite.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Search icon
          Container(
            decoration: BoxDecoration(
              color: AppTheme.darkGlassBlue.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.luxuryGold.withValues(alpha: 0.15),
                width: 0.5,
              ),
            ),
            child: IconButton(
              onPressed: () => context.push('/search'),
              icon: Icon(
                Icons.search_rounded,
                color: AppTheme.luxuryGold.withValues(alpha: 0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _surahNameArabic(int number) {
    final surah = QuranIndex.instance.getSurah(number);
    return surah?.name ?? 'سورة $number';
  }

  Widget _buildOverviewSection() {
    final progressVal = _lastRead != null
        ? (_lastRead!.page / 604.0).clamp(0.0, 1.0)
        : 0.0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.darkGlassBlue.withValues(alpha: 0.45),
                  AppTheme.darkGlassBlue.withValues(alpha: 0.15),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppTheme.luxuryGold.withValues(alpha: 0.2),
                width: 0.8,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.glowGold.withValues(alpha: 0.05),
                  blurRadius: 30,
                  spreadRadius: -5,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppTheme.luxuryGold.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.auto_stories_rounded,
                            color: AppTheme.luxuryGold,
                            size: 18,
                          ),
                        ),
                        const Gap(10),
                        Text(
                          'متابعة القراءة',
                          style: GoogleFonts.notoKufiArabic(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.luxuryGold,
                          ),
                        ),
                      ],
                    ),
                    if (_lastRead != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.luxuryGold.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'آخر قراءة',
                          style: GoogleFonts.notoKufiArabic(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.luxuryGold,
                          ),
                        ),
                      ),
                  ],
                ),
                const Gap(20),
                if (_loadingLastRead)
                  const SizedBox(
                    height: 80,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.luxuryGold,
                      ),
                    ),
                  )
                else if (_lastRead != null) ...[
                  Row(
                    children: [
                      // Progress Ring
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 64,
                            height: 64,
                            child: CircularProgressIndicator(
                              value: progressVal,
                              strokeWidth: 4.5,
                              backgroundColor: AppTheme.warmWhite.withValues(
                                alpha: 0.1,
                              ),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                AppTheme.luxuryGold,
                              ),
                            ),
                          ),
                          Text(
                            '${(progressVal * 100).toInt()}%',
                            style: GoogleFonts.spaceMono(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.luxuryGold,
                            ),
                          ),
                        ],
                      ),
                      const Gap(20),
                      // Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'سورة ${_surahNameArabic(_lastRead!.surahNumber)}',
                              style: GoogleFonts.notoKufiArabic(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.warmWhite,
                              ),
                            ),
                            const Gap(4),
                            Text(
                              'الآية ${_lastRead!.ayahNumber} • الجزء ${_lastRead!.juz} • الصفحة ${_lastRead!.page}',
                              style: GoogleFonts.notoKufiArabic(
                                fontSize: 12,
                                color: AppTheme.warmWhite.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Gap(20),
                  // Resume Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: AppTheme.goldGradient,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.luxuryGold.withValues(alpha: 0.25),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () => _openSurah(
                          _lastRead!.surahNumber,
                          '',
                          initialAyah: _lastRead!.ayahNumber,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: AppTheme.midnightNavy,
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'متابعة القراءة الآن',
                              style: GoogleFonts.notoKufiArabic(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Gap(8),
                            const Icon(Icons.arrow_forward_rounded, size: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppTheme.luxuryGold.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.menu_book_rounded,
                          color: AppTheme.luxuryGold,
                          size: 28,
                        ),
                      ),
                      const Gap(16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'سورة الفاتحة • البداية',
                              style: GoogleFonts.notoKufiArabic(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.warmWhite,
                              ),
                            ),
                            const Gap(4),
                            Text(
                              'ابدأ رحلتك اليوم بالقرآن الكريم',
                              style: GoogleFonts.notoKufiArabic(
                                fontSize: 12,
                                color: AppTheme.warmWhite.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Gap(20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: AppTheme.goldGradient,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ElevatedButton(
                        onPressed: () => _openSurah(1, 'الفاتحة'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: AppTheme.midnightNavy,
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          'ابدأ القراءة',
                          style: GoogleFonts.notoKufiArabic(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionsGrid() {
    final actions = [
      _QuickActionItem(
        title: 'الفهرس',
        subtitle: '114 سورة • 30 جزء',
        icon: Icons.list_alt_rounded,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const QuranScreen()),
          );
        },
      ),
      _QuickActionItem(
        title: 'القرآن المسموع',
        subtitle: '120 قارئ • بدون إنترنت',
        icon: Icons.headphones_rounded,
        onTap: () => context.push('/quran-audio/reciters'),
      ),
      _QuickActionItem(
        title: 'الإشارات المرجعية',
        subtitle: 'المحفوظات والآيات',
        icon: Icons.bookmark_added_rounded,
        onTap: () => context.push('/favorites'),
      ),
      _QuickActionItem(
        title: 'متابعة الختمة',
        subtitle: 'التخطيط والتقدم اليومي',
        icon: Icons.check_circle_outline_rounded,
        onTap: () => context.push('/khatmah'),
      ),
    ];

    const imagePaths = [
      null,
      null,
      'assets/images/asaratmrgiabg.png',
      'assets/images/mutabaaktmabg.png',
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.88,
            ),
            itemCount: actions.length,
            itemBuilder: (context, index) {
              final act = actions[index];
              final bgPath = imagePaths[index];

              if (bgPath != null) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Positioned.fill(
                        child: Opacity(
                          opacity: 0.18,
                          child: Image.asset(
                            bgPath,
                            fit: BoxFit.cover,
                            alignment: Alignment.centerRight,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: AppTheme.bgCard,
                              );
                            },
                          ),
                        ),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withValues(alpha: 0.55),
                              Colors.black.withValues(alpha: 0.10),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: AppTheme.luxuryGold.withValues(alpha: 0.15),
                              width: 0.8,
                            ),
                          ),
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: act.onTap,
                          borderRadius: BorderRadius.circular(24),
                          splashColor: AppTheme.luxuryGold.withValues(alpha: 0.15),
                          child: Padding(
                            padding: const EdgeInsets.all(18),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppTheme.luxuryGold.withValues(
                                      alpha: 0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Icon(
                                    act.icon,
                                    color: AppTheme.luxuryGold,
                                    size: 24,
                                  ),
                                ),
                                const Gap(12),
                                Text(
                                  act.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.notoKufiArabic(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.warmWhite,
                                  ),
                                ),
                                const Gap(6),
                                Text(
                                  act.subtitle,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.notoKufiArabic(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.warmWhite.withValues(
                                      alpha: 0.7,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: index == 0
                          ? null
                          : LinearGradient(
                              colors: [
                                AppTheme.darkGlassBlue.withValues(alpha: 0.3),
                                AppTheme.darkGlassBlue.withValues(alpha: 0.1),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                      image: index == 0
                          ? const DecorationImage(
                              image: _fahrasBg,
                              fit: BoxFit.cover,
                              alignment: Alignment.center,
                            )
                          : null,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: AppTheme.luxuryGold.withValues(alpha: 0.15),
                        width: 0.8,
                      ),
                    ),
                    child: Container(
                      decoration: index == 0
                          ? BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFF0A1946).withValues(alpha: 0.60),
                                  const Color(0xFF0A1946).withValues(alpha: 0.08),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                            )
                          : null,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: act.onTap,
                          borderRadius: BorderRadius.circular(24),
                          splashColor: AppTheme.luxuryGold.withValues(alpha: 0.15),
                          child: Padding(
                            padding: const EdgeInsets.all(18),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppTheme.luxuryGold.withValues(
                                      alpha: 0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Icon(
                                    act.icon,
                                    color: AppTheme.luxuryGold,
                                    size: 24,
                                  ),
                                ),
                                const Gap(12),
                                Text(
                                  act.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.notoKufiArabic(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.warmWhite,
                                  ),
                                ),
                                const Gap(6),
                                Text(
                                  act.subtitle,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.notoKufiArabic(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.warmWhite.withValues(
                                      alpha: 0.7,
                                    ),
                                  ),
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
          ),
        );
      },
    );
  }

  Widget _buildDailyVerseCard() {
    final arabicText =
        _dailyVerse?['text'] as String? ??
        'وَاسْتَعِينُوا بِالصَّبْرِ وَالصَّلَاةِ ۚ وَإِنَّهَا لَكَبِيرَةٌ إِلَّا عَلَى الْخَاشِعِينَ';
    final surahName = _dailyVerse?['surahName'] as String? ?? 'البقرة';
    final verseNumber = _dailyVerse?['verseNumber'] as int? ?? 45;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.darkGlassBlue.withValues(alpha: 0.25),
                AppTheme.darkGlassBlue.withValues(alpha: 0.1),
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppTheme.luxuryGold.withValues(alpha: 0.1),
              width: 0.5,
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.star_rounded,
                    color: AppTheme.luxuryGold,
                    size: 16,
                  ),
                  const Gap(8),
                  Text(
                    'آية اليوم • Verse of the Day',
                    style: GoogleFonts.notoKufiArabic(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.luxuryGold,
                    ),
                  ),
                  const Gap(8),
                  const Icon(
                    Icons.star_rounded,
                    color: AppTheme.luxuryGold,
                    size: 16,
                  ),
                ],
              ),
              const Gap(20),
              if (_loadingVerse)
                const SizedBox(
                  height: 40,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.luxuryGold,
                      strokeWidth: 2,
                    ),
                  ),
                )
              else ...[
                Text(
                  arabicText,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.amiri(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.luxuryGold,
                    height: 1.8,
                  ),
                ),
                const Gap(16),
                Text(
                  _dailyVerseEnglish.isNotEmpty
                      ? _dailyVerseEnglish
                      : 'And seek help through patience and prayer, and indeed, it is difficult except for the humbly submissive [to Allah].',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    color: AppTheme.warmWhite.withValues(alpha: 0.7),
                    height: 1.4,
                  ),
                ),
                const Gap(6),
                Text(
                  'Surah $surahName : $verseNumber',
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    color: AppTheme.warmWhite.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  _QuickActionItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });
}

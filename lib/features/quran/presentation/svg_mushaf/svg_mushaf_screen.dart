import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/quran_index.dart';
import '../../../bookmarks/data/models/bookmark_models.dart';
import '../../../bookmarks/data/repository/bookmark_repository.dart';
import '../../../quran_audio/providers/quran_audio_providers.dart';
import '../../../../theme/app_theme.dart';
import 'widgets/premium_floating_tools.dart';
import 'widgets/reciter_selector_sheet.dart';

const int _totalPages = 604;
const String _assetBase = 'assets/quran-svg/svg';

class SvgMushafScreen extends ConsumerStatefulWidget {
  final int initialPage;
  const SvgMushafScreen({super.key, this.initialPage = 1});

  @override
  ConsumerState<SvgMushafScreen> createState() => _SvgMushafScreenState();
}

class _SvgMushafScreenState extends ConsumerState<SvgMushafScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _chromeController;
  late Animation<Offset> _topSlideAnimation;
  late Animation<Offset> _bottomSlideAnimation;
  int _currentPage = 1;
  bool _showChrome = true;
  Timer? _chromeTimer;

  static const _bgImage = AssetImage('assets/quran/quranbackgroung/quraanbg.png');
  bool _bgPrecached = false;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage;
    _pageController = PageController(initialPage: widget.initialPage - 1);
    _chromeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _topSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _chromeController,
      curve: Curves.easeOutCubic,
    ));
    _bottomSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _chromeController,
      curve: Curves.easeOutCubic,
    ));
    _chromeController.forward();
    _startChromeTimer();
    _saveReadingPosition();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_bgPrecached) {
      _bgPrecached = true;
      precacheImage(_bgImage, context);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _chromeController.dispose();
    _chromeTimer?.cancel();
    _saveReadingPosition();
    super.dispose();
  }

  void _startChromeTimer() {
    _chromeTimer?.cancel();
    _chromeTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        _chromeController.reverse();
        setState(() => _showChrome = false);
      }
    });
  }

  void _toggleChrome() {
    if (!_showChrome) {
      setState(() => _showChrome = true);
      _chromeController.forward();
    }
    _startChromeTimer();
  }

  Future<void> _saveReadingPosition() async {
    try {
      final index = QuranIndex.instance;
      if (!index.isInitialized) await index.initialize();
      final pageInfo = index.getPageInfo(_currentPage);
      if (pageInfo != null && pageInfo.surahNumbers.isNotEmpty) {
        final bookmarkRepo = ref.read(bookmarkRepositoryProvider);
        await bookmarkRepo.saveLastRead(ReadingProgress(
          surahNumber: pageInfo.surahNumbers.first,
          ayahNumber: 1,
          page: _currentPage,
          juz: pageInfo.juz,
          lastRead: DateTime.now(),
        ));
      }
    } catch (_) {}
  }

  void _jumpToPage(int page) {
    if (page < 1 || page > _totalPages) return;
    _pageController.animateToPage(
      page - 1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
    );
  }

  PageInfo? get _pageInfo =>
      QuranIndex.instance.isInitialized
          ? QuranIndex.instance.getPageInfo(_currentPage)
          : null;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final audioState = ref.watch(audioPlayerNotifierProvider);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF071426) : Colors.grey.shade100,
      body: Stack(
        children: [
          // ── Background image (fixed, behind everything) ──
          Positioned.fill(
            child: Image(
              image: _bgImage,
              fit: BoxFit.cover,
              alignment: Alignment.center,
              gaplessPlayback: true,
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                if (wasSynchronouslyLoaded || frame != null) return child;
                return const SizedBox.expand();
              },
            ),
          ),
          // ── Subtle dark overlay for readability ──
          Positioned.fill(
            child: ColoredBox(
              color: (isDark ? const Color(0xFF071426) : Colors.black)
                  .withValues(alpha: 0.06),
            ),
          ),
          // ── SVG PageView ──
          PageView.builder(
            controller: _pageController,
            itemCount: _totalPages,
            reverse: true,
            onPageChanged: (index) {
              setState(() => _currentPage = index + 1);
              _saveReadingPosition();
              if (_showChrome) _startChromeTimer();
            },
            itemBuilder: (context, index) {
              final pageNum = index + 1;
              return _SvgPage(
                pageNumber: pageNum,
                isDark: isDark,
                onTap: () {
                  _toggleChrome();
                  if (_showChrome) _startChromeTimer();
                },
              );
            },
          ),
          if (_showChrome) ...[
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SlideTransition(
                position: _topSlideAnimation,
                child: _PremiumTopBar(
                  currentPage: _currentPage,
                  pageInfo: _pageInfo,
                  onBack: () => Navigator.of(context).pop(),
                  onSearch: _showSearchSheet,
                  onJumpToPage: _showPageNavigator,
                  onAudio: _showReciterSelector,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SlideTransition(
                position: _bottomSlideAnimation,
                child: _PremiumBottomBar(
                  currentPage: _currentPage,
                  pageInfo: _pageInfo,
                  hasMiniPlayer: audioState.hasActivePlayback,
                  onPrev: () => _jumpToPage(_currentPage - 1),
                  onNext: () => _jumpToPage(_currentPage + 1),
                  onIndex: _showIndexSheet,
                  onBookmarks: _showBookmarksSheet,
                  onAudioToggle: () => ref
                      .read(audioPlayerNotifierProvider.notifier)
                      .togglePlayPause(),
                  audioState: audioState,
                ),
              ),
            ),
          ],
          Positioned(
            left: 16,
            bottom: MediaQuery.paddingOf(context).bottom + 88,
            child: PremiumFloatingTools(
              currentSurahNumber: _getCurrentSurahNumber(),
            ),
          ),
        ],
      ),
    );
  }

  int _getCurrentSurahNumber() {
    final info = _pageInfo;
    if (info != null && info.surahNumbers.isNotEmpty) {
      return info.surahNumbers.first;
    }
    return 1;
  }

  void _showSearchSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _SearchSheet(),
    );
  }

  void _showPageNavigator() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _PageNavigatorSheet(
        currentPage: _currentPage,
        onPageSelected: (page) {
          Navigator.pop(context);
          _jumpToPage(page);
        },
      ),
    );
  }

  void _showIndexSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _IndexSheet(
        currentPage: _currentPage,
        onPageSelected: (page) {
          Navigator.pop(context);
          _jumpToPage(page);
        },
      ),
    );
  }

  void _showBookmarksSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _BookmarksSheet(
        onPageSelected: (page) {
          Navigator.pop(context);
          _jumpToPage(page);
        },
      ),
    );
  }

  void _showReciterSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ReciterSelectorSheet(
        currentSurahNumber: _getCurrentSurahNumber(),
      ),
    );
  }
}

// ─── SVG Page (unchanged rendering) ──────────────────────────────────────────

class _SvgPage extends StatefulWidget {
  final int pageNumber;
  final bool isDark;
  final VoidCallback? onTap;

  const _SvgPage({required this.pageNumber, required this.isDark, this.onTap});

  @override
  State<_SvgPage> createState() => _SvgPageState();
}

class _SvgPageState extends State<_SvgPage> {
  final TransformationController _transformationController =
      TransformationController();
  bool _isZoomed = false;

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  void _handleDoubleTapDown(TapDownDetails details) {
    if (_isZoomed) {
      _transformationController.value = Matrix4.identity();
      _isZoomed = false;
    } else {
      final tapPosition = details.localPosition;
      // ignore: deprecated_member_use
      final matrix = Matrix4.identity()
        ..translate(tapPosition.dx, tapPosition.dy)
        // ignore: deprecated_member_use
        ..scale(2.5)
        // ignore: deprecated_member_use
        ..translate(-tapPosition.dx, -tapPosition.dy);
      _transformationController.value = matrix;
      _isZoomed = true;
    }
  }

  String get _assetPath {
    final padded = widget.pageNumber.toString().padLeft(3, '0');
    return '$_assetBase/$padded.svg';
  }

  @override
  Widget build(BuildContext context) {
    final path = _assetPath;

    return GestureDetector(
      onTap: widget.onTap,
      onDoubleTapDown: _handleDoubleTapDown,
      child: InteractiveViewer(
        transformationController: _transformationController,
        minScale: 1.0,
        maxScale: 5.0,
        boundaryMargin: const EdgeInsets.all(double.infinity),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Transform.scale(
                scale: 0.86,
                child: AspectRatio(
                  aspectRatio: 0.685,
                  child: SvgPicture.asset(
                    path,
                    fit: BoxFit.contain,
                    placeholderBuilder: (context) => Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 32,
                            height: 32,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppTheme.goldPrimary.withValues(alpha: 0.5),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'صفحة ${widget.pageNumber}',
                            style: GoogleFonts.notoKufiArabic(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.3),
                            ),
                          ),
                        ],
                      ),
                    ),
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.red.withValues(alpha: 0.05),
                        padding: const EdgeInsets.all(16),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.error_outline_rounded,
                                size: 32,
                                color: Colors.white.withValues(alpha: 0.3),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'خطأ في تحميل الصفحة',
                                style: GoogleFonts.notoKufiArabic(
                                  fontSize: 12,
                                  color: Colors.white.withValues(alpha: 0.4),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Premium Top Bar ─────────────────────────────────────────────────────────

class _PremiumTopBar extends StatelessWidget {
  final int currentPage;
  final PageInfo? pageInfo;
  final VoidCallback onBack;
  final VoidCallback onSearch;
  final VoidCallback onJumpToPage;
  final VoidCallback onAudio;

  const _PremiumTopBar({
    required this.currentPage,
    this.pageInfo,
    required this.onBack,
    required this.onSearch,
    required this.onJumpToPage,
    required this.onAudio,
  });

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    return Container(
      margin: EdgeInsets.only(top: top),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF071426),
            const Color(0xFF071426).withValues(alpha: 0.85),
            const Color(0xFF071426).withValues(alpha: 0.4),
            const Color(0xFF071426).withValues(alpha: 0.0),
          ],
          stops: const [0.0, 0.3, 0.7, 1.0],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 52,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _GlassIconButton(
                icon: Icons.arrow_back_ios_rounded,
                onTap: onBack,
                size: 38,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _getPageTitle(),
                      style: GoogleFonts.notoKufiArabic(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.goldPrimary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'جزء ${pageInfo?.juz ?? 1}',
                            style: GoogleFonts.notoKufiArabic(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.goldPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'صفحة $currentPage / $_totalPages',
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            color: Colors.white.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _GlassIconButton(
                    icon: Icons.headphones_rounded,
                    onTap: onAudio,
                    size: 38,
                  ),
                  const SizedBox(width: 4),
                  _GlassIconButton(
                    icon: Icons.search_rounded,
                    onTap: onSearch,
                    size: 38,
                  ),
                  const SizedBox(width: 4),
                  _GlassIconButton(
                    icon: Icons.pin_drop_rounded,
                    onTap: onJumpToPage,
                    size: 38,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getPageTitle() {
    if (pageInfo == null || pageInfo!.surahNumbers.isEmpty) return '';
    final index = QuranIndex.instance;
    if (!index.isInitialized) return '';
    final firstSurah = index.getSurah(pageInfo!.surahNumbers.first);
    if (firstSurah == null) return '';
    if (pageInfo!.surahNumbers.length > 1) {
      final lastSurah = index.getSurah(pageInfo!.surahNumbers.last);
      if (lastSurah != null) return '${firstSurah.name} - ${lastSurah.name}';
    }
    return firstSurah.name;
  }
}

// ─── Premium Bottom Bar ──────────────────────────────────────────────────────

class _PremiumBottomBar extends StatelessWidget {
  final int currentPage;
  final PageInfo? pageInfo;
  final bool hasMiniPlayer;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final VoidCallback onIndex;
  final VoidCallback onBookmarks;
  final VoidCallback onAudioToggle;
  final AudioPlayerState audioState;

  const _PremiumBottomBar({
    required this.currentPage,
    this.pageInfo,
    required this.hasMiniPlayer,
    required this.onPrev,
    required this.onNext,
    required this.onIndex,
    required this.onBookmarks,
    required this.onAudioToggle,
    required this.audioState,
  });

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasMiniPlayer) _buildMiniPlayer(),
        Container(
          margin: EdgeInsets.only(bottom: bottom),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                const Color(0xFF071426),
                const Color(0xFF071426).withValues(alpha: 0.85),
                const Color(0xFF071426).withValues(alpha: 0.4),
                const Color(0xFF071426).withValues(alpha: 0.0),
              ],
              stops: const [0.0, 0.3, 0.7, 1.0],
            ),
          ),
          child: Row(
            children: [
              _GlassIconButton(
                icon: Icons.bookmark_border_rounded,
                onTap: onBookmarks,
                size: 48,
              ),
              const SizedBox(width: 12),
              _GlassIconButton(
                icon: Icons.chevron_right_rounded,
                onTap: onPrev,
                enabled: currentPage > 1,
                size: 48,
              ),
              const Spacer(),
              _PageIndicatorBadge(
                currentPage: currentPage,
                totalPages: _totalPages,
                juz: pageInfo?.juz ?? 1,
              ),
              const Spacer(),
              _GlassIconButton(
                icon: Icons.chevron_left_rounded,
                onTap: onNext,
                enabled: currentPage < _totalPages,
                size: 48,
              ),
              const SizedBox(width: 12),
              _GlassIconButton(
                icon: Icons.list_rounded,
                onTap: onIndex,
                size: 48,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMiniPlayer() {
    final elapsed = audioState.position;
    final total = audioState.duration;
    final progress = total.inMilliseconds > 0
        ? elapsed.inMilliseconds / total.inMilliseconds
        : 0.0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.bgCard.withValues(alpha: 0.95),
            AppTheme.bgSurface.withValues(alpha: 0.95),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.goldPrimary.withValues(alpha: 0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowDark,
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: AppTheme.goldGradient,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    '${audioState.currentSurahNumber}',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.midnightNavy,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      audioState.currentSurahName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.notoKufiArabic(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      audioState.currentReciter?.name ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.notoKufiArabic(
                        fontSize: 10,
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
              if (audioState.isBuffering)
                SizedBox(
                  width: 32,
                  height: 32,
                  child: Center(
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppTheme.goldPrimary,
                      ),
                    ),
                  ),
                )
              else
                GestureDetector(
                  onTap: onAudioToggle,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppTheme.goldPrimary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      audioState.isPlaying
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      color: AppTheme.goldPrimary,
                      size: 22,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 2,
              backgroundColor: AppTheme.goldPrimary.withValues(alpha: 0.08),
              valueColor: const AlwaysStoppedAnimation(AppTheme.goldPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Glass Icon Button ───────────────────────────────────────────────────────

class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double size;
  final bool enabled;

  const _GlassIconButton({
    required this.icon,
    required this.onTap,
    this.size = 40,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: enabled ? 0.08 : 0.03),
          shape: BoxShape.circle,
          border: Border.all(
            color: AppTheme.goldPrimary.withValues(
              alpha: enabled ? 0.25 : 0.08,
            ),
          ),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 6,
                  ),
                ]
              : null,
        ),
        child: Icon(
          icon,
          size: size * 0.42,
          color: Colors.white.withValues(alpha: enabled ? 0.85 : 0.25),
        ),
      ),
    );
  }
}

// ─── Page Indicator Badge ────────────────────────────────────────────────────

class _PageIndicatorBadge extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int juz;

  const _PageIndicatorBadge({
    required this.currentPage,
    required this.totalPages,
    required this.juz,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.goldPrimary.withValues(alpha: 0.15),
          width: 0.5,
        ),
      ),
      child: Text(
        '$juz  •  $currentPage / $totalPages',
        style: GoogleFonts.outfit(
          fontSize: 11,
          color: Colors.white.withValues(alpha: 0.8),
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

// ─── Search Sheet ────────────────────────────────────────────────────────────

class _SearchSheet extends StatefulWidget {
  const _SearchSheet();

  @override
  State<_SearchSheet> createState() => _SearchSheetState();
}

class _SearchSheetState extends State<_SearchSheet> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  List<Map<String, dynamic>> _results = [];
  bool _searching = false;

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _search(String query) {
    if (query.trim().isEmpty) {
      setState(() => _results = []);
      return;
    }
    setState(() => _searching = true);
    final index = QuranIndex.instance;
    final results = index.searchAyahs(query.trim());
    setState(() {
      _results = results;
      _searching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppTheme.bgCard,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: EdgeInsets.only(bottom: bottom),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  textDirection: TextDirection.rtl,
                  style: GoogleFonts.notoNaskhArabic(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  onChanged: _search,
                  decoration: InputDecoration(
                    hintText: 'ابحث في القرآن...',
                    hintStyle: GoogleFonts.notoKufiArabic(
                      color: Colors.white.withValues(alpha: 0.4),
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: AppTheme.goldPrimary.withValues(alpha: 0.6),
                    ),
                    suffixIcon: _controller.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.white38),
                            onPressed: () {
                              _controller.clear();
                              _search('');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.08),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: AppTheme.goldPrimary.withValues(alpha: 0.15),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: AppTheme.goldPrimary.withValues(alpha: 0.3),
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              if (_searching)
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(color: AppTheme.goldPrimary),
                )
              else
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _results.length,
                    itemBuilder: (context, index) {
                      final ayah = _results[index];
                      return _SearchResultTile(
                        ayah: ayah,
                        onTap: () {
                          Navigator.pop(context);
                          context.push('/mushaf?page=${ayah['page'] as int? ?? 1}');
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _SearchResultTile extends StatelessWidget {
  final Map<String, dynamic> ayah;
  final VoidCallback onTap;

  const _SearchResultTile({required this.ayah, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final text = ayah['aya_text'] as String? ?? '';
    final surahNo = ayah['sura_no'] as int? ?? 0;
    final ayahNo = ayah['aya_no'] as int? ?? 0;
    final page = ayah['page'] as int? ?? 1;
    final surah = QuranIndex.instance.getSurah(surahNo);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppTheme.goldPrimary.withValues(alpha: 0.08),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textDirection: TextDirection.rtl,
                  style: GoogleFonts.notoNaskhArabic(
                    fontSize: 16,
                    color: Colors.white,
                    height: 1.8,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.goldPrimary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${surah?.name ?? ''} : $ayahNo',
                        style: GoogleFonts.notoKufiArabic(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.goldPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      ' صفحة $page',
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.4),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Page Navigator Sheet ────────────────────────────────────────────────────

class _PageNavigatorSheet extends StatefulWidget {
  final int currentPage;
  final ValueChanged<int> onPageSelected;

  const _PageNavigatorSheet({
    required this.currentPage,
    required this.onPageSelected,
  });

  @override
  State<_PageNavigatorSheet> createState() => _PageNavigatorSheetState();
}

class _PageNavigatorSheetState extends State<_PageNavigatorSheet> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: '${widget.currentPage}');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.38,
      minChildSize: 0.2,
      maxChildSize: 0.5,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppTheme.bgCard,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                'الانتقال إلى صفحة',
                style: GoogleFonts.notoKufiArabic(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.goldPrimary,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white.withValues(alpha: 0.08),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: AppTheme.goldPrimary.withValues(
                                alpha: 0.3,
                              ),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: AppTheme.goldPrimary.withValues(
                                alpha: 0.3,
                              ),
                            ),
                          ),
                          suffixText: '/ $_totalPages',
                          suffixStyle: GoogleFonts.outfit(
                            fontSize: 14,
                            color: Colors.white38,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () {
                        final page = int.tryParse(_controller.text);
                        if (page != null &&
                            page >= 1 &&
                            page <= _totalPages) {
                          widget.onPageSelected(page);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: const BoxDecoration(
                          gradient: AppTheme.goldGradient,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 18,
                          color: AppTheme.midnightNavy,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  children: [
                    _QuickJumpButton(
                      label: 'الفاتحة',
                      page: 1,
                      onTap: widget.onPageSelected,
                    ),
                    const SizedBox(width: 8),
                    _QuickJumpButton(
                      label: 'البقرة',
                      page: 2,
                      onTap: widget.onPageSelected,
                    ),
                    const SizedBox(width: 8),
                    _QuickJumpButton(
                      label: 'الكهف',
                      page: 282,
                      onTap: widget.onPageSelected,
                    ),
                    const SizedBox(width: 8),
                    _QuickJumpButton(
                      label: 'يس',
                      page: 416,
                      onTap: widget.onPageSelected,
                    ),
                    const SizedBox(width: 8),
                    _QuickJumpButton(
                      label: 'الرحمن',
                      page: 531,
                      onTap: widget.onPageSelected,
                    ),
                    const SizedBox(width: 8),
                    _QuickJumpButton(
                      label: 'الناس',
                      page: 604,
                      onTap: widget.onPageSelected,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _QuickJumpButton extends StatelessWidget {
  final String label;
  final int page;
  final ValueChanged<int> onTap;

  const _QuickJumpButton({
    required this.label,
    required this.page,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(page),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppTheme.goldPrimary.withValues(alpha: 0.12),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.notoKufiArabic(
              fontSize: 10,
              color: AppTheme.goldPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Index Sheet ─────────────────────────────────────────────────────────────

class _IndexSheet extends StatelessWidget {
  final int currentPage;
  final ValueChanged<int> onPageSelected;

  const _IndexSheet({required this.currentPage, required this.onPageSelected});

  @override
  Widget build(BuildContext context) {
    final index = QuranIndex.instance;
    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppTheme.bgCard,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: DefaultTabController(
            length: 3,
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                TabBar(
                  labelColor: AppTheme.goldPrimary,
                  unselectedLabelColor: Colors.white38,
                  labelStyle: GoogleFonts.notoKufiArabic(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  indicatorColor: AppTheme.goldPrimary,
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: const [
                    Tab(text: 'السور'),
                    Tab(text: 'الأجزاء'),
                    Tab(text: 'الأحزاب'),
                  ],
                ),
                Expanded(
                  child: TabBarView(children: [
                    _buildSurahList(index, scrollController),
                    _buildJuzList(index, scrollController),
                    _buildHizbList(index, scrollController),
                  ]),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSurahList(QuranIndex index, ScrollController controller) {
    return ListView.builder(
      controller: controller,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: index.surahs.length,
      itemBuilder: (context, i) {
        final surah = index.surahs[i];
        return _IndexTile(
          number: '${surah.number}',
          titleAr: surah.name,
          titleEn: surah.englishName,
          subtitle: '${surah.numberOfAyahs} آية • الصفحة ${surah.startPage}',
          onTap: () => onPageSelected(surah.startPage),
        );
      },
    );
  }

  Widget _buildJuzList(QuranIndex index, ScrollController controller) {
    return ListView.builder(
      controller: controller,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: index.juzList.length,
      itemBuilder: (context, i) {
        final juz = index.juzList[i];
        return _IndexTile(
          number: '${juz.number}',
          titleAr: juz.nameArabic,
          titleEn: juz.nameEnglish,
          subtitle: 'صفحة ${juz.startPage} - ${juz.endPage}',
          onTap: () => onPageSelected(juz.startPage),
        );
      },
    );
  }

  Widget _buildHizbList(QuranIndex index, ScrollController controller) {
    return ListView.builder(
      controller: controller,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: index.hizbList.length,
      itemBuilder: (context, i) {
        final hizb = index.hizbList[i];
        return _IndexTile(
          number: '${hizb.number}',
          titleAr: 'الحزب ${hizb.number}',
          titleEn: 'Hizb ${hizb.number}',
          subtitle: 'صفحة ${hizb.startPage}',
          onTap: () => onPageSelected(hizb.startPage),
        );
      },
    );
  }
}

class _IndexTile extends StatelessWidget {
  final String number;
  final String titleAr;
  final String titleEn;
  final String subtitle;
  final VoidCallback onTap;

  const _IndexTile({
    required this.number,
    required this.titleAr,
    required this.titleEn,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppTheme.goldPrimary.withValues(alpha: 0.08),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.goldPrimary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      number,
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.goldPrimary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titleAr,
                        textDirection: TextDirection.rtl,
                        style: GoogleFonts.notoNaskhArabic(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '$titleEn  •  $subtitle',
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          color: Colors.white38,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_left_rounded,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Bookmarks Sheet ─────────────────────────────────────────────────────────

class _BookmarksSheet extends StatefulWidget {
  final ValueChanged<int> onPageSelected;
  const _BookmarksSheet({required this.onPageSelected});

  @override
  State<_BookmarksSheet> createState() => _BookmarksSheetState();
}

class _BookmarksSheetState extends State<_BookmarksSheet> {
  List<Map<String, dynamic>> _bookmarks = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    try {
      final data = await SharedPreferences.getInstance();
      final jsonStr = data.getString('mushaf_bookmarks');
      if (jsonStr != null) {
        final List<dynamic> list =
            List.from(const JsonDecoder().convert(jsonStr) as List);
        _bookmarks = list.cast<Map<String, dynamic>>();
      }
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppTheme.bgCard,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                'المحفوظات',
                style: GoogleFonts.notoKufiArabic(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _loading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.goldPrimary,
                        ),
                      )
                    : _bookmarks.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.bookmark_border_rounded,
                                  size: 48,
                                  color: Colors.white.withValues(alpha: 0.2),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'لا توجد حفظات بعد',
                                  style: GoogleFonts.notoKufiArabic(
                                    fontSize: 14,
                                    color: Colors.white38,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            controller: scrollController,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: _bookmarks.length,
                            itemBuilder: (context, i) {
                              final bm = _bookmarks[i];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: AppTheme.goldPrimary.withValues(
                                      alpha: 0.08,
                                    ),
                                  ),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () => widget.onPageSelected(
                                      bm['page'] as int? ?? 1,
                                    ),
                                    borderRadius: BorderRadius.circular(14),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 36,
                                            height: 36,
                                            decoration: BoxDecoration(
                                              gradient: AppTheme.goldGradient,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: const Icon(
                                              Icons.bookmark_rounded,
                                              color: AppTheme.midnightNavy,
                                              size: 18,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  bm['title'] as String? ?? '',
                                                  style:
                                                      GoogleFonts.notoKufiArabic(
                                                    color: Colors.white,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  'صفحة ${bm['page'] ?? ''}',
                                                  style: GoogleFonts.outfit(
                                                    color: Colors.white38,
                                                    fontSize: 11,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Icon(
                                            Icons.chevron_left_rounded,
                                            color: Colors.white.withValues(
                                              alpha: 0.3,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        );
      },
    );
  }
}

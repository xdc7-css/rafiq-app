import 'dart:async';
import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/arabic_strings.dart';
import '../../../../models/api_models.dart';
import '../../../../providers/khatmah_provider.dart';
import '../../../../services/data_service.dart';
import '../../../../theme/app_theme.dart';
import '../../../../widgets/star_background.dart';
import '../../../bookmarks/data/models/bookmark_models.dart';
import '../../../bookmarks/data/repository/bookmark_repository.dart';
import 'mushaf_chrome.dart';
import 'mushaf_constants.dart';
import 'mushaf_flow_text.dart';
import 'mushaf_layout_engine.dart';
import 'mushaf_page_frame.dart';
import 'mushaf_surah_header.dart';
import 'verse_actions_sheet.dart';

enum MushafReadingMode { mushaf, night, focus }

/// Authentic Madinah Mushaf reader — presentation layer only.
class MushafReaderScreen extends ConsumerStatefulWidget {
  final SurahFullData surah;
  final int? initialAyah;
  final KhatmahNotifier? khatmahNotifier;

  const MushafReaderScreen({
    super.key,
    required this.surah,
    this.initialAyah,
    this.khatmahNotifier,
  });

  @override
  ConsumerState<MushafReaderScreen> createState() => _MushafReaderScreenState();
}

class _MushafReaderScreenState extends ConsumerState<MushafReaderScreen> {
  final _scrollController = ScrollController();
  final _layoutEngine = MushafLayoutEngine();
  final _bookmarks = <int>{};
  final _flowKey = GlobalKey<MushafFlowTextState>();

  MushafReadingMode _mode = MushafReadingMode.mushaf;
  bool _chromeVisible = true;
  bool _toolbarVisible = false;
  int? _selectedAyah;
  int _lastTrackedAyah = 0;
  Timer? _chromeHideTimer;
  Timer? _toolbarHideTimer;
  double _lastScrollOffset = 0;

  bool get _isDark =>
      _mode == MushafReadingMode.night || _mode == MushafReadingMode.focus;

  Color get _textColor => _isDark ? MushafColors.inkNight : MushafColors.ink;

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
    _scrollController.addListener(_onScroll);
    if (widget.initialAyah != null && widget.initialAyah! > 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToAyah(widget.initialAyah!);
      });
    }
    _startChromeTimer();
  }

  @override
  void dispose() {
    _saveReadingProgress();
    _chromeHideTimer?.cancel();
    _toolbarHideTimer?.cancel();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadBookmarks() async {
    final repo = ref.read(bookmarkRepositoryProvider);
    final all = await repo.getBookmarksByType(BookmarkType.ayah);
    if (!mounted) return;
    setState(() {
      for (final b in all) {
        if (b.data['surahNumber'] == widget.surah.number) {
          final n = b.data['ayahNumber'];
          if (n is int) _bookmarks.add(n);
        }
      }
    });
  }

  Future<void> _toggleBookmark(int numberInSurah) async {
    final repo = ref.read(bookmarkRepositoryProvider);
    final ayah = widget.surah.ayahs.firstWhere(
      (a) => a.numberInSurah == numberInSurah,
    );
    final id = 'ayah_${ayah.number}';

    if (_bookmarks.contains(numberInSurah)) {
      await repo.removeBookmark(id);
      setState(() => _bookmarks.remove(numberInSurah));
    } else {
      await repo.addBookmark(
        BookmarkModel.ayah(
          ayahNumber: ayah.number,
          surahNumber: widget.surah.number,
          surahName: widget.surah.name,
          text: ayah.text,
          juz: ayah.juz,
          page: ayah.page,
        ),
      );
      setState(() => _bookmarks.add(numberInSurah));
    }
  }

  Future<void> _saveReadingProgress() async {
    if (_lastTrackedAyah < 1) return;
    final ayah = widget.surah.ayahs.firstWhere(
      (a) => a.numberInSurah == _lastTrackedAyah,
      orElse: () => widget.surah.ayahs.first,
    );
    await ref
        .read(bookmarkRepositoryProvider)
        .saveLastRead(
          ReadingProgress(
            surahNumber: widget.surah.number,
            ayahNumber: ayah.numberInSurah,
            page: ayah.page,
            juz: ayah.juz,
            lastRead: DateTime.now(),
          ),
        );
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final offset = _scrollController.offset;
    if ((offset - _lastScrollOffset).abs() > 8) {
      setState(() => _chromeVisible = false);
      _lastScrollOffset = offset;
    }
    _trackVisibleAyah();
  }

  void _trackVisibleAyah() {
    final state = _flowKey.currentState;
    if (state == null || !_scrollController.hasClients) return;
    final viewport = _scrollController.position.viewportDimension;
    final localY = viewport * 0.25;
    final index = state.ayahIndexAtLocal(Offset(20, localY));
    if (index == null) return;
    final num = widget.surah.ayahs[index].numberInSurah;
    if (num > _lastTrackedAyah) {
      _lastTrackedAyah = num;
      widget.khatmahNotifier?.advanceAyah();
    }
  }

  void _scrollToAyah(int numberInSurah) {
    final index = widget.surah.ayahs.indexWhere(
      (a) => a.numberInSurah == numberInSurah,
    );
    if (index < 0) return;
    final width =
        MediaQuery.sizeOf(context).width -
        MushafMetrics.pageHorizontalMargin * 2 -
        MushafMetrics.pageInnerPadding * 2;
    final layout = _layoutEngine.build(
      ayahs: widget.surah.ayahs,
      baseStyle: _layoutEngine.mushafTextStyle(color: _textColor),
      textColor: _textColor,
      bookmarkedAyahs: _bookmarks,
    );
    final offset = mushafScrollOffsetForAyah(
      layout: layout,
      ayahIndex: index,
      contentMaxWidth: width.clamp(200, MushafMetrics.pageMaxWidth),
    );
    if (offset != null && _scrollController.hasClients) {
      _scrollController.animateTo(
        offset.clamp(0, _scrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _startChromeTimer() {
    _chromeHideTimer?.cancel();
    _chromeHideTimer = Timer(const Duration(seconds: 4), () {
      if (mounted) setState(() => _chromeVisible = false);
    });
  }

  void _showChrome() {
    setState(() => _chromeVisible = true);
    _startChromeTimer();
  }

  void _showToolbarBriefly() {
    setState(() => _toolbarVisible = true);
    _toolbarHideTimer?.cancel();
    _toolbarHideTimer = Timer(const Duration(seconds: 4), () {
      if (mounted) setState(() => _toolbarVisible = false);
    });
  }

  void _onPageTap() {
    _showChrome();
    _showToolbarBriefly();
  }

  void _openVerseActions(AyahData ayah) {
    VerseActionsSheet.show(
      context,
      surah: widget.surah,
      ayah: ayah,
      isBookmarked: _bookmarks.contains(ayah.numberInSurah),
      onBookmarkToggle: () => _toggleBookmark(ayah.numberInSurah),
      onTafsir: () => _showTafsirSheet(ayah.numberInSurah),
      onAudio: _showReciterSheet,
      onNotes: () {},
    );
  }

  void _showTafsirSheet(int verseNumber) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.55,
        minChildSize: 0.35,
        maxChildSize: 0.9,
        builder: (ctx, scrollController) => ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              color: AppTheme.bgCard.withValues(alpha: 0.96),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Text(
                    Ar.tafsir,
                    style: GoogleFonts.cairo(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${widget.surah.name} • ${mushafArabicDigits(verseNumber)}',
                    style: GoogleFonts.cairo(
                      fontSize: 12,
                      color: AppTheme.goldPrimary,
                    ),
                  ),
                  const Divider(height: 24),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.all(20),
                      children: [
                        _tafsirBlock(Ar.tafsirAlMuyassar),
                        _tafsirBlock(Ar.tafsirAlSadi),
                        _tafsirBlock(Ar.tafsirIbnKathir),
                        _tafsirBlock(Ar.tafsirTabatabai),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _tafsirBlock(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.cairo(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.goldPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'لم يرد تفسير لهذه الآية بعد.',
            style: GoogleFonts.cairo(
              fontSize: 13,
              color: AppTheme.textMuted,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  void _showReciterSheet() {
    final reciters = [
      'مشاري العفاسي',
      'ماهر المعيقلي',
      'ياسر الدوسري',
      'عبد الباسط عبد الصمد',
      'سعد الغامدي',
    ];
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            color: AppTheme.bgCard.withValues(alpha: 0.96),
            padding: EdgeInsets.only(
              bottom: MediaQuery.paddingOf(ctx).bottom + 12,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                Text(
                  Ar.selectReciter,
                  style: GoogleFonts.cairo(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                ...reciters.map(
                  (r) => ListTile(
                    title: Text(
                      r,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.cairo(color: AppTheme.textPrimary),
                    ),
                    onTap: () => Navigator.pop(ctx),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _navigateSurah(int number) async {
    if (number < 1 || number > 114) return;
    final data = await DataService.getSurahFromApi(number);
    if (data == null || !mounted) return;
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => MushafReaderScreen(
          surah: data,
          khatmahNotifier: widget.khatmahNotifier,
        ),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 280),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pageNum = widget.surah.ayahs.isNotEmpty
        ? widget.surah.ayahs.first.page
        : null;
    final showBasmala = widget.surah.number != 9 && widget.surah.number != 1;

    final baseStyle = _layoutEngine.mushafTextStyle(color: _textColor);
    final layout = _layoutEngine.build(
      ayahs: widget.surah.ayahs,
      baseStyle: baseStyle,
      textColor: _textColor,
      selectedAyah: _selectedAyah,
      bookmarkedAyahs: _bookmarks,
      onMarkerTap: (n) {
        final ayah = widget.surah.ayahs.firstWhere((a) => a.numberInSurah == n);
        _openVerseActions(ayah);
      },
    );

    final bg = _mode == MushafReadingMode.focus ? MushafColors.paperDark : null;

    return Scaffold(
      backgroundColor: bg ?? AppTheme.bgPrimary,
      body: Stack(
        children: [
          if (_mode != MushafReadingMode.focus)
            const StarBackground(showParticles: false),
          GestureDetector(
            onTap: _onPageTap,
            behavior: HitTestBehavior.deferToChild,
            child: CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: MediaQuery.paddingOf(context).top + 64,
                  ),
                ),
                SliverToBoxAdapter(
                  child: _mode == MushafReadingMode.focus
                      ? _buildFocusPage(showBasmala, layout)
                      : MushafPageFrame(
                          pageNumber: pageNum,
                          isDark: _isDark,
                          child: _buildPageBody(showBasmala, layout),
                        ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: MediaQuery.paddingOf(context).bottom + 90,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: MushafTopBar(
              surah: widget.surah,
              visible: _chromeVisible,
              isDark: _isDark,
              onBack: () => Navigator.pop(context),
              onSearch: () => context.push('/search'),
              onBookmarks: () => context.push('/favorites'),
              onSettings: () => context.push('/settings'),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: MushafBottomBar(
              surah: widget.surah,
              visible: _chromeVisible,
              onPrevious: widget.surah.number > 1
                  ? () => _navigateSurah(widget.surah.number - 1)
                  : null,
              onNext: widget.surah.number < 114
                  ? () => _navigateSurah(widget.surah.number + 1)
                  : null,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: MediaQuery.paddingOf(context).bottom + 80,
            child: MushafFloatingToolbar(
              visible: _toolbarVisible && _selectedAyah != null,
              onBookmark: () {
                if (_selectedAyah != null) _toggleBookmark(_selectedAyah!);
              },
              onCopy: () {
                if (_selectedAyah == null) return;
                final ayah = widget.surah.ayahs.firstWhere(
                  (a) => a.numberInSurah == _selectedAyah,
                );
                Clipboard.setData(ClipboardData(text: ayah.text));
              },
              onShare: () {
                if (_selectedAyah == null) return;
                final ayah = widget.surah.ayahs.firstWhere(
                  (a) => a.numberInSurah == _selectedAyah,
                );
                Share.share('${ayah.text}\n\n— ${widget.surah.name}');
              },
              onAudio: _showReciterSheet,
            ),
          ),
          Positioned(
            right: 10,
            top: MediaQuery.paddingOf(context).top + 72,
            child: _modeRail(),
          ),
        ],
      ),
    );
  }

  Widget _buildFocusPage(bool showBasmala, MushafLayoutResult layout) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: _buildPageBody(showBasmala, layout),
    );
  }

  Widget _buildPageBody(bool showBasmala, MushafLayoutResult layout) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MushafSurahHeader(surah: widget.surah, isDark: _isDark),
        if (showBasmala) MushafBasmala(isDark: _isDark),
        MushafFlowText(
          key: _flowKey,
          layout: layout,
          textColor: _textColor,
          onAyahTap: (index) {
            final ayah = layout.segments[index].ayah;
            setState(() {
              _selectedAyah = _selectedAyah == ayah.numberInSurah
                  ? null
                  : ayah.numberInSurah;
            });
            _showToolbarBriefly();
          },
          onAyahLongPress: (index) {
            final ayah = layout.segments[index].ayah;
            setState(() => _selectedAyah = ayah.numberInSurah);
            _openVerseActions(ayah);
          },
          onAyahDoubleTap: (index) {
            _toggleBookmark(layout.segments[index].ayah.numberInSurah);
          },
        ),
      ],
    );
  }

  Widget _modeRail() {
    return Column(
      children: [
        _modeBtn(
          Icons.menu_book_rounded,
          MushafReadingMode.mushaf,
          Ar.mushafMode,
        ),
        const SizedBox(height: 6),
        _modeBtn(Icons.nightlight_round, MushafReadingMode.night, Ar.nightMode),
        const SizedBox(height: 6),
        _modeBtn(
          Icons.center_focus_strong_rounded,
          MushafReadingMode.focus,
          Ar.focusMode,
        ),
      ],
    );
  }

  Widget _modeBtn(IconData icon, MushafReadingMode mode, String tip) {
    final active = _mode == mode;
    return Tooltip(
      message: tip,
      child: GestureDetector(
        onTap: () => setState(() => _mode = mode),
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            gradient: active ? AppTheme.goldGradient : null,
            color: active ? null : AppTheme.bgCard.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: active ? AppTheme.goldPrimary : AppTheme.borderSubtle,
            ),
          ),
          child: Icon(
            icon,
            size: 17,
            color: active ? AppTheme.bgPrimary : AppTheme.goldPrimary,
          ),
        ),
      ),
    );
  }
}

import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../theme/app_theme.dart';
import '../../../../widgets/star_background.dart';

// ─────────────────────────────────────────────────
// Data Models (local, no backend needed)
// ─────────────────────────────────────────────────

class AudioTrack {
  final String id;
  final String title;
  final String subtitle;
  final String reciter;
  final String duration;
  final bool isDownloaded;
  final int surahNumber;

  const AudioTrack({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.reciter,
    required this.duration,
    this.isDownloaded = false,
    required this.surahNumber,
  });
}

final _sampleTracks = <AudioTrack>[
  const AudioTrack(id: '1', title: 'الفاتحة', subtitle: 'سورة الفاتحة — ٧ آيات', reciter: 'مشاري العفاسي', duration: '1:02', isDownloaded: true, surahNumber: 1),
  const AudioTrack(id: '2', title: 'البقرة', subtitle: 'سورة البقرة — ٢٨٦ آيات', reciter: 'عبدالرحمن السديس', duration: '2:41:05', isDownloaded: false, surahNumber: 2),
  const AudioTrack(id: '3', title: 'آل عمران', subtitle: 'سورة آل عمران — ٢٠٠ آيات', reciter: 'سعد الغامدي', duration: '1:55:30', isDownloaded: true, surahNumber: 3),
  const AudioTrack(id: '4', title: 'النساء', subtitle: 'سورة النساء — ١٧٦ آيات', reciter: 'ماهر المعيقلي', duration: '1:43:22', isDownloaded: false, surahNumber: 4),
  const AudioTrack(id: '5', title: 'المائدة', subtitle: 'سورة المائدة — ١٢٠ آيات', reciter: 'مشاري العفاسي', duration: '1:18:47', isDownloaded: true, surahNumber: 5),
  const AudioTrack(id: '6', title: 'الأنعام', subtitle: 'سورة الأنعام — ١٦٥ آيات', reciter: 'عبدالباسط عبدالصمد', duration: '1:33:14', isDownloaded: false, surahNumber: 6),
  const AudioTrack(id: '7', title: 'الكهف', subtitle: 'سورة الكهف — ١١٠ آيات', reciter: 'مشاري العفاسي', duration: '55:11', isDownloaded: true, surahNumber: 18),
  const AudioTrack(id: '8', title: 'يس', subtitle: 'سورة يس — ٨٣ آيات', reciter: 'سعد الغامدي', duration: '22:33', isDownloaded: true, surahNumber: 36),
  const AudioTrack(id: '9', title: 'الرحمن', subtitle: 'سورة الرحمن — ٧٨ آيات', reciter: 'ماهر المعيقلي', duration: '18:45', isDownloaded: false, surahNumber: 55),
  const AudioTrack(id: '10', title: 'الملك', subtitle: 'سورة الملك — ٣٠ آيات', reciter: 'عبدالرحمن السديس', duration: '8:12', isDownloaded: true, surahNumber: 67),
];

// ─────────────────────────────────────────────────
// Audio Library Screen
// ─────────────────────────────────────────────────

class AudioLibraryScreen extends StatefulWidget {
  const AudioLibraryScreen({super.key});

  @override
  State<AudioLibraryScreen> createState() => _AudioLibraryScreenState();
}

class _AudioLibraryScreenState extends State<AudioLibraryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedReciterIndex = 0;
  AudioTrack? _currentTrack;

  final _reciters = ['الكل', 'مشاري العفاسي', 'السديس', 'سعد الغامدي', 'ماهر المعيقلي'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryText = AppTheme.textPrimary;
    final secondaryText = AppTheme.textMuted;
    final gold = AppTheme.goldPrimary;

    final filteredTracks = _selectedReciterIndex == 0
        ? _sampleTracks
        : _sampleTracks.where((t) => t.reciter.contains(_reciters[_selectedReciterIndex])).toList();

    final downloadedTracks = _sampleTracks.where((t) => t.isDownloaded).toList();

    return Scaffold(
      backgroundColor: AppTheme.bgPrimary,
      body: Stack(
        children: [
          const StarBackground(),
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.maybePop(context),
                        icon: Icon(Icons.arrow_back_ios_new_rounded, color: gold, size: 20),
                      ),
                      Expanded(
                        child: Text(
                          'مكتبة التلاوات',
                          style: GoogleFonts.notoKufiArabic(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: primaryText,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                        },
                        icon: Icon(Icons.search_rounded, color: gold, size: 22),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Currently Playing Mini Player
                if (_currentTrack != null)
                  _MiniPlayer(
                    track: _currentTrack!,
                    onTap: () => _openFullPlayer(context, _currentTrack!),
                    isDark: isDark,
                  ),

                // Tabs
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: isDark ? AppTheme.bgCard.withValues( alpha: 0.5) : Colors.white.withValues( alpha: 0.6),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: gold.withValues( alpha: 0.15)),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        gradient: AppTheme.goldGradient,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      labelColor: isDark ? AppTheme.bgPrimary : Colors.white,
                      unselectedLabelColor: secondaryText,
                      labelStyle: GoogleFonts.notoKufiArabic(fontSize: 13, fontWeight: FontWeight.w600),
                      tabs: const [
                        Tab(text: 'كل السور'),
                        Tab(text: 'المحملة'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Reciter Filter (only on "All" tab)
                SizedBox(
                  height: 36,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: _reciters.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, i) {
                      final selected = i == _selectedReciterIndex;
                      return GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() => _selectedReciterIndex = i);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            gradient: selected ? AppTheme.goldGradient : null,
                            color: selected ? null : (isDark ? AppTheme.bgCard.withValues( alpha: 0.5) : Colors.white.withValues( alpha: 0.7)),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: selected ? Colors.transparent : gold.withValues( alpha: 0.2),
                            ),
                          ),
                          child: Text(
                            _reciters[i],
                            style: GoogleFonts.notoKufiArabic(
                              fontSize: 12,
                              color: selected ? (isDark ? AppTheme.bgPrimary : Colors.white) : secondaryText,
                              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Track List
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _TrackList(
                        tracks: filteredTracks,
                        currentTrack: _currentTrack,
                        onTap: (t) {
                          HapticFeedback.mediumImpact();
                          setState(() => _currentTrack = t);
                          _openFullPlayer(context, t);
                        },
                        isDark: isDark,
                        gold: gold,
                        primaryText: primaryText,
                        secondaryText: secondaryText,
                      ),
                      _TrackList(
                        tracks: downloadedTracks,
                        currentTrack: _currentTrack,
                        onTap: (t) {
                          HapticFeedback.mediumImpact();
                          setState(() => _currentTrack = t);
                          _openFullPlayer(context, t);
                        },
                        isDark: isDark,
                        gold: gold,
                        primaryText: primaryText,
                        secondaryText: secondaryText,
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

  void _openFullPlayer(BuildContext context, AudioTrack track) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, __, ___) => AudioPlayerScreen(track: track),
        transitionsBuilder: (_, anim, __, child) =>
            SlideTransition(position: Tween(begin: const Offset(0, 1), end: Offset.zero).animate(anim), child: child),
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// Track List Widget
// ─────────────────────────────────────────────────

class _TrackList extends StatelessWidget {
  final List<AudioTrack> tracks;
  final AudioTrack? currentTrack;
  final ValueChanged<AudioTrack> onTap;
  final bool isDark;
  final Color gold;
  final Color primaryText;
  final Color secondaryText;

  const _TrackList({
    required this.tracks,
    this.currentTrack,
    required this.onTap,
    required this.isDark,
    required this.gold,
    required this.primaryText,
    required this.secondaryText,
  });

  @override
  Widget build(BuildContext context) {
    if (tracks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.download_done_rounded, color: gold.withValues( alpha: 0.3), size: 64),
            const SizedBox(height: 16),
            Text('لا توجد تلاوات محملة بعد',
                style: GoogleFonts.notoKufiArabic(fontSize: 14, color: secondaryText)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      itemCount: tracks.length,
      itemBuilder: (context, i) {
        final track = tracks[i];
        final isPlaying = currentTrack?.id == track.id;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GestureDetector(
            onTap: () => onTap(track),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isPlaying
                    ? gold.withValues( alpha: 0.12)
                    : (isDark ? AppTheme.bgCard.withValues( alpha: 0.4) : Colors.white.withValues( alpha: 0.6)),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isPlaying ? gold.withValues( alpha: 0.4) : gold.withValues( alpha: 0.1),
                ),
              ),
              child: Row(
                children: [
                  // Surah Number / Play Indicator
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: isPlaying ? AppTheme.goldGradient : null,
                      color: isPlaying ? null : (isDark ? AppTheme.bgSurface : Colors.white),
                      shape: BoxShape.circle,
                      border: isPlaying ? null : Border.all(color: gold.withValues( alpha: 0.2)),
                    ),
                    child: Center(
                      child: isPlaying
                          ? const _PulsingBars()
                          : Text(
                              '${track.surahNumber}',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: isDark ? primaryText : const Color(0xFF1A1A1A),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Track Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(track.title,
                            style: GoogleFonts.notoKufiArabic(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: isPlaying ? gold : primaryText,
                            )),
                        const SizedBox(height: 3),
                        Text(track.reciter,
                            style: GoogleFonts.notoKufiArabic(
                              fontSize: 11,
                              color: secondaryText,
                            )),
                      ],
                    ),
                  ),

                  // Duration + Download
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(track.duration,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: secondaryText,
                          )),
                      const SizedBox(height: 4),
                      Icon(
                        track.isDownloaded ? Icons.download_done_rounded : Icons.download_outlined,
                        size: 16,
                        color: track.isDownloaded ? gold : secondaryText.withValues( alpha: 0.5),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────
// Mini Player
// ─────────────────────────────────────────────────

class _MiniPlayer extends StatelessWidget {
  final AudioTrack track;
  final VoidCallback onTap;
  final bool isDark;

  const _MiniPlayer({required this.track, required this.onTap, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final gold = AppTheme.goldPrimary;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: gold.withValues( alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: gold.withValues( alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(gradient: AppTheme.goldGradient, shape: BoxShape.circle),
                    child: const Center(child: _PulsingBars()),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(track.title,
                            style: GoogleFonts.notoKufiArabic(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: gold,
                            )),
                        Text(track.reciter,
                            style: GoogleFonts.notoKufiArabic(
                              fontSize: 11,
                              color: AppTheme.textMuted,
                            )),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.skip_previous_rounded, color: gold, size: 22),
                      const SizedBox(width: 8),
                      Icon(Icons.pause_circle_filled_rounded, color: gold, size: 32),
                      const SizedBox(width: 8),
                      Icon(Icons.skip_next_rounded, color: gold, size: 22),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// Pulsing Audio Bars Widget
// ─────────────────────────────────────────────────

class _PulsingBars extends StatefulWidget {
  const _PulsingBars();

  @override
  State<_PulsingBars> createState() => _PulsingBarsState();
}

class _PulsingBarsState extends State<_PulsingBars> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(3, (i) {
      return AnimationController(
        duration: Duration(milliseconds: 400 + i * 120),
        vsync: this,
      )..repeat(reverse: true);
    });
    _animations = _controllers.map((c) => Tween(begin: 0.2, end: 1.0).animate(c)).toList();
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(3, (i) {
        return AnimatedBuilder(
          animation: _animations[i],
          builder: (_, __) {
            return Container(
              width: 3,
              height: 14 * _animations[i].value,
              margin: const EdgeInsets.symmetric(horizontal: 1),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2),
              ),
            );
          },
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────
// Full Audio Player Screen
// ─────────────────────────────────────────────────

class AudioPlayerScreen extends StatefulWidget {
  final AudioTrack track;

  const AudioPlayerScreen({super.key, required this.track});

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen>
    with TickerProviderStateMixin {
  bool _isPlaying = true;
  bool _isFavorited = false;
  double _progress = 0.23;
  double _volume = 0.8;
  bool _isRepeat = false;
  bool _isShuffle = false;

  late AnimationController _vinylController;
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _vinylController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _waveController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _vinylController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gold = AppTheme.goldPrimary;
    final primaryText = AppTheme.textPrimary;
    final secondaryText = AppTheme.textMuted;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Blurred Background
          Container(
            decoration: BoxDecoration(
              gradient: isDark
                  ? const LinearGradient(
                      colors: [Color(0xFF0B1324), Color(0xFF1A0A2E)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    )
                  : const LinearGradient(
                      colors: [Color(0xFFF5F2ED), Color(0xFFE8D9C0)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
            ),
          ),
          const StarBackground(),

          // Gold Glow behind vinyl
          Positioned(
            top: MediaQuery.sizeOf(context).height * 0.15,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: gold.withValues( alpha: 0.15),
                      blurRadius: 80,
                      spreadRadius: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Top bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isDark ? AppTheme.bgCard.withValues( alpha: 0.4) : Colors.white.withValues( alpha: 0.6),
                            shape: BoxShape.circle,
                            border: Border.all(color: gold.withValues( alpha: 0.2)),
                          ),
                          child: Icon(Icons.keyboard_arrow_down_rounded, color: gold, size: 24),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text('يُشغّل الآن',
                                style: GoogleFonts.notoKufiArabic(fontSize: 11, color: secondaryText)),
                            Text(widget.track.reciter,
                                style: GoogleFonts.notoKufiArabic(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: primaryText,
                                )),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          setState(() => _isFavorited = !_isFavorited);
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isDark ? AppTheme.bgCard.withValues( alpha: 0.4) : Colors.white.withValues( alpha: 0.6),
                            shape: BoxShape.circle,
                            border: Border.all(color: gold.withValues( alpha: 0.2)),
                          ),
                          child: Icon(
                            _isFavorited ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                            color: _isFavorited ? Colors.red : gold,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Vinyl/Album Art
                AnimatedBuilder(
                  animation: _vinylController,
                  builder: (_, __) {
                    return Transform.rotate(
                      angle: _isPlaying ? _vinylController.value * 2 * math.pi : 0,
                      child: Container(
                        width: 220,
                        height: 220,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              gold.withValues( alpha: 0.3),
                              isDark ? AppTheme.bgCard : const Color(0xFFE8D9C0),
                              isDark ? AppTheme.bgPrimary : const Color(0xFFF5F2ED),
                            ],
                            stops: const [0.0, 0.4, 1.0],
                          ),
                          border: Border.all(
                            color: gold.withValues( alpha: 0.25),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isDark ? Colors.black.withValues( alpha: 0.5) : Colors.black.withValues( alpha: 0.1),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'بِسْمِ اللَّهِ',
                                style: GoogleFonts.notoKufiArabic(
                                  fontSize: 14,
                                  color: gold,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                widget.track.title,
                                style: GoogleFonts.notoKufiArabic(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: primaryText,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: gold,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: gold.withValues( alpha: 0.5),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 32),

                // Track Name
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      Text(
                        widget.track.title,
                        style: GoogleFonts.notoKufiArabic(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: primaryText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.track.subtitle,
                        style: GoogleFonts.notoKufiArabic(
                          fontSize: 13,
                          color: secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Progress Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      SliderTheme(
                        data: SliderThemeData(
                          trackHeight: 4,
                          thumbColor: gold,
                          activeTrackColor: gold,
                          inactiveTrackColor: gold.withValues( alpha: 0.2),
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                          overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                        ),
                        child: Slider(
                          value: _progress,
                          onChanged: (v) => setState(() => _progress = v),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('0:14', style: GoogleFonts.inter(fontSize: 11, color: secondaryText)),
                            Text(widget.track.duration,
                                style: GoogleFonts.inter(fontSize: 11, color: secondaryText)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Playback Controls
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _ControlButton(
                        icon: Icons.shuffle_rounded,
                        color: _isShuffle ? gold : secondaryText.withValues( alpha: 0.6),
                        size: 22,
                        onTap: () => setState(() => _isShuffle = !_isShuffle),
                      ),
                      _ControlButton(
                        icon: Icons.skip_previous_rounded,
                        color: primaryText,
                        size: 34,
                        onTap: () => HapticFeedback.lightImpact(),
                      ),
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          setState(() => _isPlaying = !_isPlaying);
                        },
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            gradient: AppTheme.goldGradient,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: gold.withValues( alpha: 0.4),
                                blurRadius: 20,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: Icon(
                            _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                            color: isDark ? AppTheme.bgPrimary : Colors.white,
                            size: 36,
                          ),
                        ),
                      ),
                      _ControlButton(
                        icon: Icons.skip_next_rounded,
                        color: primaryText,
                        size: 34,
                        onTap: () => HapticFeedback.lightImpact(),
                      ),
                      _ControlButton(
                        icon: Icons.repeat_rounded,
                        color: _isRepeat ? gold : secondaryText.withValues( alpha: 0.6),
                        size: 22,
                        onTap: () => setState(() => _isRepeat = !_isRepeat),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Volume
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: Row(
                    children: [
                      Icon(Icons.volume_down_rounded, color: secondaryText, size: 18),
                      Expanded(
                        child: SliderTheme(
                          data: SliderThemeData(
                            trackHeight: 2,
                            thumbColor: gold,
                            activeTrackColor: gold.withValues( alpha: 0.8),
                            inactiveTrackColor: gold.withValues( alpha: 0.15),
                            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
                            overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
                          ),
                          child: Slider(
                            value: _volume,
                            onChanged: (v) => setState(() => _volume = v),
                          ),
                        ),
                      ),
                      Icon(Icons.volume_up_rounded, color: secondaryText, size: 18),
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
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  final VoidCallback onTap;

  const _ControlButton({
    required this.icon,
    required this.color,
    required this.size,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, color: color, size: size),
    );
  }
}

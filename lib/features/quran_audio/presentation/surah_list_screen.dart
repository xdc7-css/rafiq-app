import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/ds_components.dart';
import '../../../widgets/star_background.dart';
import '../data/models/quran_audio_models.dart';
import '../providers/quran_audio_providers.dart';

class SurahListScreen extends ConsumerStatefulWidget {
  const SurahListScreen({super.key});

  @override
  ConsumerState<SurahListScreen> createState() => _SurahListScreenState();
}

class _SurahListScreenState extends ConsumerState<SurahListScreen> {
  final _searchController = TextEditingController();
  late QuranReciter _reciter;
  late Moshaf _moshaf;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final extra = GoRouterState.of(context).extra;
    if (extra is Map) {
      _reciter = extra['reciter'] as QuranReciter;
      _moshaf = extra['moshaf'] as Moshaf;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<int> _availableSurahs() {
    final av = _moshaf.parsedSurahNumbers();
    if (av.isEmpty) return List.generate(114, (i) => i + 1);
    return av;
  }

  List<int> _filteredSurahs() {
    final all = _availableSurahs();
    final q = _searchController.text.trim();
    if (q.isEmpty) return all;
    return all.where((surahNum) {
      final name = surahName(surahNum);
      return name.contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final playerState = ref.watch(audioPlayerNotifierProvider);
    final downloads = ref.watch(downloadsProvider);
    final favorites = ref.watch(audioFavoritesProvider);
    final surahs = _filteredSurahs();

    return Scaffold(
      body: Stack(
        children: [
          const StarBackground(showParticles: false),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                _buildReciterInfo(),
                _buildSearchBar(),
                Expanded(
                  child: surahs.isEmpty
                      ? _buildEmptySearch()
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
                          itemCount: surahs.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 6),
                          itemBuilder: (context, index) => _SurahTile(
                            number: surahs[index],
                            name: surahName(surahs[index]),
                            revelationType: revelationType(surahs[index]),
                            isActive: playerState.hasActivePlayback &&
                                playerState.currentReciter?.id == _reciter.id &&
                                playerState.currentSurahNumber == surahs[index],
                            isPlaying: playerState.hasActivePlayback &&
                                playerState.isPlaying &&
                                playerState.currentReciter?.id == _reciter.id &&
                                playerState.currentSurahNumber == surahs[index],
                            isDownloaded: downloads.isDownloaded(_reciter.id, surahs[index]),
                            isDownloading: downloads.isDownloading(_reciter.id, surahs[index]),
                            downloadProgress: downloads.progress(_reciter.id, surahs[index]),
                            isFavorite: favorites.isSurahFav('${_reciter.id}_${surahs[index]}'),
                            onPlay: () => _playSurah(surahs[index], downloads),
                            onDownload: () => _downloadSurah(surahs[index]),
                            onFavorite: () => ref.read(audioFavoritesProvider.notifier).toggleSurah(
                              '${_reciter.id}_${surahs[index]}',
                            ),
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
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.goldPrimary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.borderGold, width: 0.5),
              ),
              child: const Icon(Icons.arrow_back_rounded, color: AppTheme.goldPrimary, size: 22),
            ),
          ),
          const SizedBox(width: 14),
          Text(
            'السور',
            style: GoogleFonts.notoKufiArabic(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const Spacer(),
          GoldBadge(
            text: '${_availableSurahs().length} سورة',
            icon: Icons.auto_stories_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildReciterInfo() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
      child: Row(
        children: [
          Icon(Icons.person_rounded, size: 14, color: AppTheme.goldPrimary),
          const SizedBox(width: 6),
          Text(
            _reciter.name,
            style: GoogleFonts.notoKufiArabic(
              fontSize: 13,
              color: AppTheme.goldPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 12),
          Icon(Icons.audio_file_rounded, size: 14, color: AppTheme.textMuted),
          const SizedBox(width: 6),
          Text(
            _moshaf.name,
            style: GoogleFonts.notoKufiArabic(
              fontSize: 12,
              color: AppTheme.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.bgCard.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppTheme.borderGold, width: 0.5),
        ),
        child: TextField(
          controller: _searchController,
          textDirection: TextDirection.rtl,
          style: GoogleFonts.notoKufiArabic(fontSize: 14, color: AppTheme.textPrimary),
          decoration: InputDecoration(
            hintText: 'ابحث عن سورة...',
            hintTextDirection: TextDirection.rtl,
            hintStyle: GoogleFonts.notoKufiArabic(fontSize: 14, color: AppTheme.textMuted),
            prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.goldPrimary, size: 22),
            suffixIcon: _searchController.text.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      _searchController.clear();
                      setState(() {});
                    },
                    child: Icon(Icons.close_rounded, color: AppTheme.textMuted, size: 20),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
          onChanged: (_) => setState(() {}),
        ),
      ),
    );
  }

  Widget _buildEmptySearch() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 64, color: AppTheme.goldPrimary.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          Text(
            'لا توجد نتائج',
            style: GoogleFonts.notoKufiArabic(fontSize: 16, color: AppTheme.textMuted),
          ),
        ],
      ),
    );
  }

  Future<void> _playSurah(int surahNumber, DownloadsState downloads) async {
    final allSurahs = List.generate(114, (i) => i + 1);
    final startIndex = allSurahs.indexOf(surahNumber);
    await ref.read(audioPlayerNotifierProvider.notifier).playSurahQueue(
      reciter: _reciter,
      moshaf: _moshaf,
      surahNumbers: allSurahs,
      startIndex: startIndex,
    );
  }

  void _downloadSurah(int surahNumber) {
    final url = _moshaf.audioUrl(surahNumber);
    ref.read(downloadsProvider.notifier).download(_reciter.id, surahNumber, url);
  }
}

class _SurahTile extends StatelessWidget {
  final int number;
  final String name;
  final String revelationType;
  final bool isActive;
  final bool isPlaying;
  final bool isDownloaded;
  final bool isDownloading;
  final double downloadProgress;
  final bool isFavorite;
  final VoidCallback onPlay;
  final VoidCallback onDownload;
  final VoidCallback onFavorite;

  const _SurahTile({
    required this.number,
    required this.name,
    required this.revelationType,
    required this.isActive,
    required this.isPlaying,
    required this.isDownloaded,
    required this.isDownloading,
    required this.downloadProgress,
    required this.isFavorite,
    required this.onPlay,
    required this.onDownload,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      radius: 18,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      borderColor: isActive ? AppTheme.goldPrimary.withValues(alpha: 0.4) : null,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: isActive
                  ? AppTheme.goldGradient
                  : LinearGradient(
                      colors: [AppTheme.goldPrimary.withValues(alpha: 0.1), AppTheme.goldPrimary.withValues(alpha: 0.03)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                number.toString(),
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isActive ? AppTheme.bgPrimary : AppTheme.goldPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.notoKufiArabic(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isActive ? AppTheme.goldPrimary : AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      revelationType == 'Meccan' ? 'مكية' : 'مدنية',
                      style: GoogleFonts.notoKufiArabic(
                        fontSize: 10,
                        color: AppTheme.textMuted,
                      ),
                    ),
                    if (isDownloaded) ...[
                      const SizedBox(width: 8),
                      Icon(Icons.download_done_rounded, size: 12, color: AppTheme.goldPrimary),
                      const SizedBox(width: 2),
                      Text(
                        'محملة',
                        style: GoogleFonts.notoKufiArabic(fontSize: 10, color: AppTheme.goldPrimary),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onFavorite,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppTheme.goldPrimary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                size: 16,
                color: isFavorite ? Colors.redAccent : AppTheme.goldPrimary.withValues(alpha: 0.5),
              ),
            ),
          ),
          const SizedBox(width: 6),
          if (isDownloading)
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(
                    value: downloadProgress,
                    strokeWidth: 2,
                    color: AppTheme.goldPrimary,
                    backgroundColor: AppTheme.goldPrimary.withValues(alpha: 0.1),
                  ),
                ),
                Text(
                  '${(downloadProgress * 100).round()}%',
                  style: GoogleFonts.inter(fontSize: 7, color: AppTheme.goldPrimary, fontWeight: FontWeight.bold),
                ),
              ],
            )
          else if (!isDownloaded)
            GestureDetector(
              onTap: onDownload,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppTheme.goldPrimary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.download_rounded, size: 16, color: AppTheme.goldPrimary),
              ),
            ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onPlay,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isActive
                    ? AppTheme.goldPrimary.withValues(alpha: 0.2)
                    : AppTheme.goldPrimary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                color: isActive ? AppTheme.goldPrimary : AppTheme.goldPrimary,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

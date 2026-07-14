import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/ds_components.dart';
import '../../../widgets/star_background.dart';
import '../data/models/quran_audio_models.dart';
import '../providers/quran_audio_providers.dart';

class ReciterBrowserScreen extends ConsumerStatefulWidget {
  const ReciterBrowserScreen({super.key});

  @override
  ConsumerState<ReciterBrowserScreen> createState() => _ReciterBrowserScreenState();
}

class _ReciterBrowserScreenState extends ConsumerState<ReciterBrowserScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(recitersProvider.notifier).load();
      ref.read(audioFavoritesProvider.notifier).load();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recitersState = ref.watch(recitersProvider);
    final favorites = ref.watch(audioFavoritesProvider);

    return Scaffold(
      body: Stack(
        children: [
          const StarBackground(showParticles: false),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(recitersState),
                _buildSearchBar(),
                Expanded(child: _buildBody(recitersState, favorites)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(RecitersState state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
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
            'القارئ',
            style: GoogleFonts.notoKufiArabic(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const Spacer(),
          GoldBadge(
            text: '${state.reciters.length} قارئ',
            icon: Icons.people_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.bgCard.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppTheme.borderGold, width: 0.5),
        ),
        child: TextField(
          controller: _searchController,
          textDirection: TextDirection.rtl,
          style: GoogleFonts.notoKufiArabic(
            fontSize: 14,
            color: AppTheme.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: 'ابحث عن قارئ...',
            hintTextDirection: TextDirection.rtl,
            hintStyle: GoogleFonts.notoKufiArabic(
              fontSize: 14,
              color: AppTheme.textMuted,
            ),
            prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.goldPrimary, size: 22),
            suffixIcon: _searchController.text.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      _searchController.clear();
                      ref.read(recitersProvider.notifier).search('');
                    },
                    child: Icon(Icons.close_rounded, color: AppTheme.textMuted, size: 20),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
          onChanged: (v) => ref.read(recitersProvider.notifier).search(v),
        ),
      ),
    );
  }

  Widget _buildBody(RecitersState state, AudioFavoritesState fav) {
    if (state.status == RecitersStatus.initial ||
        state.status == RecitersStatus.loading) {
      return _buildSkeleton();
    }

    if (state.status == RecitersStatus.error) {
      return _buildError(state.error);
    }

    final list = state.filtered;

    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 64, color: AppTheme.goldPrimary.withValues(alpha: 0.3)),
            const SizedBox(height: 16),
            Text(
              'لا توجد نتائج',
              style: GoogleFonts.notoKufiArabic(
                fontSize: 16,
                color: AppTheme.textMuted,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
      itemCount: list.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) => _ReciterCard(
        reciter: list[index],
        isFavorite: fav.isReciterFav(list[index].id.toString()),
        onTap: () => _openReciter(context, list[index]),
        onFavoriteToggle: () {
          ref.read(audioFavoritesProvider.notifier).toggleReciter(
            list[index].id.toString(),
          );
        },
      ),
    );
  }

  void _openReciter(BuildContext context, QuranReciter reciter) {
    if (reciter.moshaf.length == 1) {
      context.push('/quran-audio/surahs', extra: {
        'reciter': reciter,
        'moshaf': reciter.moshaf.first,
      });
    } else {
      _showMoshafPicker(context, reciter);
    }
  }

  void _showMoshafPicker(BuildContext context, QuranReciter reciter) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _MoshafPickerSheet(
        reciter: reciter,
        onSelect: (moshaf) {
          Navigator.pop(context);
          context.push('/quran-audio/surahs', extra: {
            'reciter': reciter,
            'moshaf': moshaf,
          });
        },
      ),
    );
  }

  Widget _buildSkeleton() {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
      itemCount: 8,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, __) => const SkeletonCard(height: 80),
    );
  }

  Widget _buildError(String? msg) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off_rounded, size: 64, color: AppTheme.goldPrimary.withValues(alpha: 0.3)),
            const SizedBox(height: 16),
            Text(
              msg ?? 'حدث خطأ',
              style: GoogleFonts.notoKufiArabic(
                fontSize: 14,
                color: AppTheme.textMuted,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            GoldButton(
              label: 'إعادة المحاولة',
              onTap: () => ref.read(recitersProvider.notifier).retry(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReciterCard extends StatelessWidget {
  final QuranReciter reciter;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  const _ReciterCard({
    required this.reciter,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      radius: 20,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.goldPrimary.withValues(alpha: 0.2), AppTheme.goldPrimary.withValues(alpha: 0.05)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                reciter.name.isNotEmpty ? reciter.name[0] : '?',
                style: GoogleFonts.notoKufiArabic(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.goldPrimary,
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
                  reciter.name,
                  style: GoogleFonts.notoKufiArabic(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  reciter.riwayah,
                  style: GoogleFonts.notoKufiArabic(
                    fontSize: 11,
                    color: AppTheme.goldPrimary,
                  ),
                  maxLines: 1,
                ),
                const SizedBox(height: 2),
                Text(
                  '${reciter.moshaf.length} رواية | ${reciter.count} سورة',
                  style: GoogleFonts.notoKufiArabic(
                    fontSize: 10,
                    color: AppTheme.textMuted,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onFavoriteToggle,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppTheme.goldPrimary.withValues(alpha: isFavorite ? 0.15 : 0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                color: isFavorite ? Colors.redAccent : AppTheme.goldPrimary.withValues(alpha: 0.5),
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppTheme.goldPrimary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.play_arrow_rounded, color: AppTheme.goldPrimary, size: 20),
          ),
        ],
      ),
    );
  }
}

class _MoshafPickerSheet extends StatelessWidget {
  final QuranReciter reciter;
  final ValueChanged<Moshaf> onSelect;

  const _MoshafPickerSheet({required this.reciter, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.4,
      minChildSize: 0.3,
      maxChildSize: 0.6,
      builder: (context, scrollController) => ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.bgSurface.withValues(alpha: 0.95),
              border: Border(top: BorderSide(color: AppTheme.borderGold, width: 0.5)),
            ),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.goldPrimary.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    children: [
                      Text(
                        'اختر الرواية',
                        style: GoogleFonts.notoKufiArabic(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        reciter.name,
                        style: GoogleFonts.notoKufiArabic(
                          fontSize: 12,
                          color: AppTheme.goldPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(color: AppTheme.borderGold, height: 1),
                Expanded(
                  child: ListView.separated(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: reciter.moshaf.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final moshaf = reciter.moshaf[index];
                      return GlassCard(
                        radius: 18,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        onTap: () => onSelect(moshaf),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppTheme.goldPrimary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(Icons.audio_file_rounded, color: AppTheme.goldPrimary, size: 22),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    moshaf.name,
                                    style: GoogleFonts.notoKufiArabic(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    '${moshaf.count} سورة متاحة',
                                    style: GoogleFonts.notoKufiArabic(
                                      fontSize: 11,
                                      color: AppTheme.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_back_rounded, color: AppTheme.goldPrimary, size: 20),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


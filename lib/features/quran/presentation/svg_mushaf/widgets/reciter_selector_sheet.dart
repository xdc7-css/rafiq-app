import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../theme/app_theme.dart';
import '../../../../quran_audio/data/models/quran_audio_models.dart';
import '../../../../quran_audio/providers/quran_audio_providers.dart';

class ReciterSelectorSheet extends ConsumerStatefulWidget {
  final int currentSurahNumber;
  const ReciterSelectorSheet({super.key, required this.currentSurahNumber});

  @override
  ConsumerState<ReciterSelectorSheet> createState() =>
      _ReciterSelectorSheetState();
}

class _ReciterSelectorSheetState extends ConsumerState<ReciterSelectorSheet> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  String _searchQuery = '';
  String _selectedCategory = 'الكل';

  static const _categories = ['الكل', 'مكي', 'مدنى', 'حفص', 'ورش', 'شعبة'];

  @override
  void initState() {
    super.initState();
    final recitersState = ref.read(recitersProvider);
    if (recitersState.status == RecitersStatus.initial) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(recitersProvider.notifier).load();
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  List<QuranReciter> _filterReciters(List<QuranReciter> reciters) {
    var filtered = reciters;
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((r) =>
              r.name.contains(_searchQuery) ||
              r.riwayah.contains(_searchQuery))
          .toList();
    }
    if (_selectedCategory != 'الكل') {
      filtered = filtered
          .where((r) =>
              r.riwayah.contains(_selectedCategory) ||
              r.name.contains(_selectedCategory))
          .toList();
    }
    return filtered;
  }

  void _selectReciter(QuranReciter reciter) {
    final moshaf = reciter.primaryMoshaf;
    if (moshaf == null) return;
    ref.read(audioPlayerNotifierProvider.notifier).playSurah(
          reciter: reciter,
          moshaf: moshaf,
          surahNumber: widget.currentSurahNumber,
        );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    final recitersState = ref.watch(recitersProvider);
    final audioState = ref.watch(audioPlayerNotifierProvider);
    final currentReciterId = audioState.currentReciter?.id;

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
              _buildHandle(),
              _buildHeader(),
              _buildSearchBar(),
              _buildCategoryChips(),
              const SizedBox(height: 8),
              Expanded(
                child: _buildContent(
                  recitersState,
                  scrollController,
                  currentReciterId,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHandle() {
    return Container(
      width: 40,
      height: 4,
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: AppTheme.goldGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.record_voice_over_rounded,
              color: AppTheme.midnightNavy,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'اختر القارئ',
                  style: GoogleFonts.notoKufiArabic(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'تصفح واختر قارئك المفضل',
                  style: GoogleFonts.notoKufiArabic(
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
              child: Icon(
                Icons.close_rounded,
                size: 16,
                color: Colors.white.withValues(alpha: 0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: TextField(
        controller: _searchController,
        focusNode: _focusNode,
        textDirection: TextDirection.rtl,
        style: GoogleFonts.notoKufiArabic(color: Colors.white, fontSize: 14),
        onChanged: (v) => setState(() => _searchQuery = v),
        decoration: InputDecoration(
          hintText: 'ابحث عن قارئ...',
          hintStyle: GoogleFonts.notoKufiArabic(
            color: Colors.white.withValues(alpha: 0.3),
            fontSize: 13,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: AppTheme.goldPrimary.withValues(alpha: 0.5),
            size: 20,
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear_rounded,
                    size: 16,
                    color: Colors.white.withValues(alpha: 0.4),
                  ),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.06),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: AppTheme.goldPrimary.withValues(alpha: 0.1),
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
            vertical: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final selected = _selectedCategory == cat;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: selected
                    ? AppTheme.goldPrimary.withValues(alpha: 0.15)
                    : Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: selected
                      ? AppTheme.goldPrimary.withValues(alpha: 0.4)
                      : Colors.white.withValues(alpha: 0.08),
                ),
              ),
              child: Center(
                child: Text(
                  cat,
                  style: GoogleFonts.notoKufiArabic(
                    fontSize: 12,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    color: selected
                        ? AppTheme.goldPrimary
                        : Colors.white.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(
    RecitersState recitersState,
    ScrollController controller,
    int? currentReciterId,
  ) {
    if (recitersState.status == RecitersStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppTheme.goldPrimary),
      );
    }
    if (recitersState.status == RecitersStatus.error) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: Colors.white.withValues(alpha: 0.2),
            ),
            const SizedBox(height: 12),
            Text(
              recitersState.error ?? 'حدث خطأ',
              style: GoogleFonts.notoKufiArabic(
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => ref.read(recitersProvider.notifier).retry(),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  gradient: AppTheme.goldGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'إعادة المحاولة',
                  style: GoogleFonts.notoKufiArabic(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.midnightNavy,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    final filtered = _filterReciters(recitersState.reciters);
    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 48,
              color: Colors.white.withValues(alpha: 0.15),
            ),
            const SizedBox(height: 12),
            Text(
              'لا يوجد نتائج',
              style: GoogleFonts.notoKufiArabic(
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: controller,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final reciter = filtered[index];
        final isActive = reciter.id == currentReciterId;
        return _ReciterTile(
          reciter: reciter,
          isActive: isActive,
          onTap: () => _selectReciter(reciter),
        );
      },
    );
  }
}

class _ReciterTile extends StatelessWidget {
  final QuranReciter reciter;
  final bool isActive;
  final VoidCallback onTap;

  const _ReciterTile({
    required this.reciter,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isActive
            ? AppTheme.goldPrimary.withValues(alpha: 0.1)
            : Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive
              ? AppTheme.goldPrimary.withValues(alpha: 0.35)
              : Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: isActive
                        ? AppTheme.goldGradient
                        : LinearGradient(
                            colors: [
                              Colors.white.withValues(alpha: 0.08),
                              Colors.white.withValues(alpha: 0.04),
                            ],
                          ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      reciter.name.isNotEmpty
                          ? reciter.name.characters.first
                          : '?',
                      style: GoogleFonts.notoKufiArabic(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: isActive
                            ? AppTheme.midnightNavy
                            : AppTheme.goldPrimary,
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
                        reciter.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.notoKufiArabic(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${reciter.riwayah}  •  ${reciter.letter}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.notoKufiArabic(
                          fontSize: 11,
                          color: Colors.white.withValues(alpha: 0.45),
                        ),
                      ),
                    ],
                  ),
                ),
                if (isActive)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      gradient: AppTheme.goldGradient,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'يعمل',
                      style: GoogleFonts.notoKufiArabic(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.midnightNavy,
                      ),
                    ),
                  )
                else
                  Icon(
                    Icons.play_circle_outline_rounded,
                    color: AppTheme.goldPrimary.withValues(alpha: 0.5),
                    size: 24,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

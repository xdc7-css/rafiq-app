import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../theme/app_theme.dart';
import '../../../../theme/ds_components.dart';
import '../../../../widgets/star_background.dart';
import '../../data/models/shia_hadith_models.dart';
import '../providers/hadith_providers.dart';
import '../widgets/hadith_detail_sheet.dart';

class HadithSearchScreen extends ConsumerStatefulWidget {
  const HadithSearchScreen({super.key});

  @override
  ConsumerState<HadithSearchScreen> createState() => _HadithSearchScreenState();
}

class _HadithSearchScreenState extends ConsumerState<HadithSearchScreen> {
  final _controller = TextEditingController();
  Timer? _debounce;
  String _currentQuery = '';

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() => _currentQuery = value);
      ref.read(hadithSearchQueryProvider.notifier).state = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final resultsAsync = ref.watch(hadithSearchResultsProvider);

    return Scaffold(
      body: Stack(
        children: [
          const StarBackground(),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                _buildSearchBar(),
                Expanded(
                  child: _currentQuery.isEmpty
                      ? _buildInitialState()
                      : resultsAsync.when(
                          data: (results) => results.isEmpty
                              ? _buildEmptyState()
                              : _buildResults(results),
                          loading: () => const Center(
                            child: CircularProgressIndicator(
                              color: AppTheme.goldPrimary,
                              strokeWidth: 2,
                            ),
                          ),
                          error: (_, __) => _buildErrorState(),
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
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppTheme.textPrimary,
              size: 20,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            'بحث في الأحاديث',
            style: GoogleFonts.notoKufiArabic(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.bgCard.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.goldPrimary.withValues(alpha: 0.1),
            width: 0.5,
          ),
        ),
        child: TextField(
          controller: _controller,
          autofocus: true,
          onChanged: _onSearchChanged,
          style: GoogleFonts.notoKufiArabic(
            fontSize: 14,
            color: AppTheme.textPrimary,
          ),
          textDirection: TextDirection.rtl,
          decoration: InputDecoration(
            hintText: 'ابحث عن حديث...',
            hintStyle: GoogleFonts.notoKufiArabic(
              fontSize: 14,
              color: AppTheme.textMuted,
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: AppTheme.goldPrimary.withValues(alpha: 0.6),
              size: 20,
            ),
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      _controller.clear();
                      setState(() => _currentQuery = '');
                      ref.read(hadithSearchQueryProvider.notifier).state = '';
                    },
                    icon: Icon(
                      Icons.clear_rounded,
                      color: AppTheme.textMuted,
                      size: 18,
                    ),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInitialState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_rounded,
            size: 64,
            color: AppTheme.goldPrimary.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 16),
          Text(
            'ابحث في كتب الحديث الشيعية',
            style: GoogleFonts.notoKufiArabic(
              fontSize: 16,
              color: AppTheme.textMuted,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'الكافي • فضائل الشيعة • التوحيد وغيرها',
            style: GoogleFonts.notoKufiArabic(
              fontSize: 12,
              color: AppTheme.textMuted.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 64,
            color: AppTheme.goldPrimary.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد نتائج لـ "$_currentQuery"',
            style: GoogleFonts.notoKufiArabic(
              fontSize: 16,
              color: AppTheme.textMuted,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'جرّب كلمات بحث مختلفة',
            style: GoogleFonts.notoKufiArabic(
              fontSize: 12,
              color: AppTheme.textMuted.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.cloud_off_rounded,
            size: 64,
            color: AppTheme.goldPrimary.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 16),
          Text(
            'تعذر البحث',
            style: GoogleFonts.notoKufiArabic(
              fontSize: 16,
              color: AppTheme.textMuted,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'تحقق من الاتصال بالإنترنت',
            style: GoogleFonts.notoKufiArabic(
              fontSize: 12,
              color: AppTheme.textMuted.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResults(List<ShiaHadith> results) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
      itemCount: results.length,
      itemBuilder: (_, i) => _buildResultItem(results[i]),
    );
  }

  Widget _buildResultItem(ShiaHadith hadith) {
    final preview = hadith.text.length > 120
        ? '${hadith.text.substring(0, 115)}...'
        : hadith.text;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: GlassCard(
        radius: 20,
        padding: const EdgeInsets.all(16),
        onTap: () {
          HapticFeedback.lightImpact();
          HadithDetailSheet.show(context, hadith);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppTheme.goldPrimary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    hadith.sourceDisplayName,
                    style: GoogleFonts.notoKufiArabic(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.goldPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '#${hadith.number}',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: AppTheme.textMuted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              preview,
              style: GoogleFonts.amiri(
                fontSize: 16,
                color: AppTheme.textPrimary,
                height: 1.6,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
      ),
    );
  }
}

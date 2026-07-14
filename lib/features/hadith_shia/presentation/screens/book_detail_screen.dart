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

class BookDetailScreen extends ConsumerWidget {
  final String bookId;

  const BookDetailScreen({super.key, required this.bookId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookInfo = ShiaBookInfo.fromId(bookId);
    final hadithsAsync = ref.watch(bookHadithsProvider(bookId));

    return Scaffold(
      body: Stack(
        children: [
          const StarBackground(),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context, bookInfo),
                Expanded(
                  child: hadithsAsync.when(
                    data: (hadiths) => _buildHadithList(context, hadiths),
                    loading: () => const Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.goldPrimary,
                        strokeWidth: 2,
                      ),
                    ),
                    error: (err, _) => Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.cloud_off_rounded,
                                size: 48,
                                color: AppTheme.goldPrimary.withValues(alpha: 0.3)),
                            const SizedBox(height: 16),
                            Text(
                              'تعذر الاتصال بالخادم',
                              style: GoogleFonts.notoKufiArabic(
                                fontSize: 16,
                                color: AppTheme.textMuted,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'تحقق من اشتراك ShiaAPI والاتصال بالإنترنت',
                              style: GoogleFonts.notoKufiArabic(
                                fontSize: 12,
                                color: AppTheme.textMuted,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            GoldButton(
                              label: 'إعادة المحاولة',
                              onTap: () => ref.invalidate(bookHadithsProvider(bookId)),
                              height: 44,
                              outlined: true,
                            ),
                          ],
                        ),
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

  Widget _buildHeader(BuildContext context, ShiaBookInfo bookInfo) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bookInfo.nameArabic,
                  style: GoogleFonts.notoKufiArabic(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (bookInfo.nameEnglish.isNotEmpty)
                  Text(
                    bookInfo.nameEnglish,
                    style: GoogleFonts.notoKufiArabic(
                      fontSize: 11,
                      color: AppTheme.textMuted,
                    ),
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.goldPrimary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              bookInfo.id,
              style: GoogleFonts.inter(
                fontSize: 10,
                color: AppTheme.goldPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHadithList(BuildContext context, List<ShiaHadith> hadiths) {
    if (hadiths.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.menu_book_rounded,
                size: 48, color: AppTheme.goldPrimary.withValues(alpha: 0.3)),
            const SizedBox(height: 16),
            Text(
              'لا توجد أحاديث حالياً',
              style: GoogleFonts.notoKufiArabic(
                fontSize: 16,
                color: AppTheme.textMuted,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'قد يكون الخادم غير متاح حالياً',
              style: GoogleFonts.notoKufiArabic(
                fontSize: 12,
                color: AppTheme.textMuted,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
      itemCount: hadiths.length,
      itemBuilder: (_, i) => _buildHadithItem(context, hadiths[i]),
    );
  }

  Widget _buildHadithItem(BuildContext context, ShiaHadith hadith) {
    final preview = hadith.text.length > 150
        ? '${hadith.text.substring(0, 145)}...'
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
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.goldPrimary.withValues(alpha: 0.1),
                    border: Border.all(
                      color: AppTheme.goldPrimary.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${hadith.number}',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.goldPrimary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
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
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: AppTheme.goldPrimary.withValues(alpha: 0.4),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

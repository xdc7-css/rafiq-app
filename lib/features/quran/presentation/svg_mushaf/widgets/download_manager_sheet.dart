import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../theme/app_theme.dart';
import '../../../../quran_audio/providers/quran_audio_providers.dart';

class DownloadManagerSheet extends ConsumerStatefulWidget {
  final int currentSurahNumber;
  const DownloadManagerSheet({super.key, required this.currentSurahNumber});

  @override
  ConsumerState<DownloadManagerSheet> createState() =>
      _DownloadManagerSheetState();
}

class _DownloadManagerSheetState extends ConsumerState<DownloadManagerSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final audioState = ref.read(audioPlayerNotifierProvider);
      final reciter = audioState.currentReciter;
      if (reciter != null) {
        ref.read(downloadsProvider.notifier).checkAllDownloaded(
              reciter.id,
              List.generate(114, (i) => i + 1),
            );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    final audioState = ref.watch(audioPlayerNotifierProvider);
    final downloadsState = ref.watch(downloadsProvider);
    final reciter = audioState.currentReciter;
    final moshaf = audioState.currentMoshaf;

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.35,
      maxChildSize: 0.9,
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
              _buildHeader(reciter?.name),
              if (reciter == null || moshaf == null)
                Expanded(child: _buildNoReciter())
              else
                Expanded(
                  child: _buildSurahGrid(
                    scrollController: scrollController,
                    reciterId: reciter.id,
                    moshaf: moshaf,
                    downloadsState: downloadsState,
                    currentSurah: widget.currentSurahNumber,
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

  Widget _buildHeader(String? reciterName) {
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
              Icons.download_rounded,
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
                  'التحميلات',
                  style: GoogleFonts.notoKufiArabic(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                if (reciterName != null)
                  Text(
                    reciterName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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

  Widget _buildNoReciter() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.voice_over_off_rounded,
            size: 48,
            color: Colors.white.withValues(alpha: 0.15),
          ),
          const SizedBox(height: 12),
          Text(
            'اختر قارئ أولاً',
            style: GoogleFonts.notoKufiArabic(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSurahGrid({
    required ScrollController scrollController,
    required int reciterId,
    required dynamic moshaf,
    required DownloadsState downloadsState,
    required int currentSurah,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            children: [
              _buildStatBadge(
                icon: Icons.download_done_rounded,
                label: 'محمل',
                count: downloadsState.downloadedKeys.length,
              ),
              const SizedBox(width: 8),
              _buildStatBadge(
                icon: Icons.cloud_download_rounded,
                label: 'جاري التحميل',
                count: downloadsState.downloadingKeys.length,
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            controller: scrollController,
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.85,
            ),
            itemCount: 114,
            itemBuilder: (context, index) {
              final surahNum = index + 1;
              final key = '${reciterId}_$surahNum';
              final isDownloaded = downloadsState.downloadedKeys.contains(key);
              final isDownloading = downloadsState.downloadingKeys.contains(key);
              final progress = downloadsState.progressMap[key] ?? 0.0;
              final isCurrent = surahNum == currentSurah;

              return _SurahDownloadTile(
                surahNumber: surahNum,
                isDownloaded: isDownloaded,
                isDownloading: isDownloading,
                progress: progress,
                isCurrent: isCurrent,
                onTap: () {
                  if (isDownloaded) {
                    _showDeleteDialog(reciterId, surahNum);
                  } else if (!isDownloading) {
                    final url = moshaf.audioUrl(surahNum);
                    ref
                        .read(downloadsProvider.notifier)
                        .download(reciterId, surahNum, url);
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatBadge({
    required IconData icon,
    required String label,
    required int count,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 14,
              color: AppTheme.goldPrimary.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 6),
            Text(
              '$count $label',
              style: GoogleFonts.notoKufiArabic(
                fontSize: 11,
                color: Colors.white.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(int reciterId, int surahNumber) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.bgCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: AppTheme.goldPrimary.withValues(alpha: 0.2),
          ),
        ),
        title: Text(
          'حذف التحميل',
          style: GoogleFonts.notoKufiArabic(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        content: Text(
          'هل تريد حذف السورة $surahNumber من التحميلات؟',
          style: GoogleFonts.notoKufiArabic(
            fontSize: 13,
            color: Colors.white.withValues(alpha: 0.6),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'إلغاء',
              style: GoogleFonts.notoKufiArabic(color: Colors.white54),
            ),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(downloadsProvider.notifier)
                  .deleteDownload(reciterId, surahNumber);
              Navigator.pop(ctx);
            },
            child: Text(
              'حذف',
              style: GoogleFonts.notoKufiArabic(
                color: Colors.redAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SurahDownloadTile extends StatelessWidget {
  final int surahNumber;
  final bool isDownloaded;
  final bool isDownloading;
  final double progress;
  final bool isCurrent;
  final VoidCallback onTap;

  const _SurahDownloadTile({
    required this.surahNumber,
    required this.isDownloaded,
    required this.isDownloading,
    required this.progress,
    required this.isCurrent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isDownloaded
        ? AppTheme.goldPrimary.withValues(alpha: 0.12)
        : isCurrent
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.white.withValues(alpha: 0.03);
    final borderColor = isDownloaded
        ? AppTheme.goldPrimary.withValues(alpha: 0.35)
        : isCurrent
            ? AppTheme.goldPrimary.withValues(alpha: 0.15)
            : Colors.white.withValues(alpha: 0.06);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isDownloading)
                    SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(
                        value: progress > 0 ? progress : null,
                        strokeWidth: 2.5,
                        color: AppTheme.goldPrimary,
                        backgroundColor: Colors.white.withValues(alpha: 0.1),
                      ),
                    )
                  else
                    Icon(
                      isDownloaded
                          ? Icons.check_circle_rounded
                          : Icons.add_circle_outline_rounded,
                      size: 24,
                      color: isDownloaded
                          ? AppTheme.goldPrimary
                          : Colors.white.withValues(alpha: 0.3),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    '$surahNumber',
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isDownloaded
                          ? AppTheme.goldPrimary
                          : Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
            if (isCurrent)
              Positioned(
                top: 4,
                left: 4,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppTheme.goldPrimary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/ds_components.dart';
import '../providers/quran_audio_providers.dart';

class StorageManagementScreen extends ConsumerWidget {
  const StorageManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(storageStatsProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppTheme.bgPrimary,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0D1B2A), Color(0xFF0A1628)],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                const SizedBox(height: 16),
                Expanded(
                  child: statsAsync.when(
                    data: (stats) => _buildContent(context, ref, stats),
                    loading: () => const Center(
                      child: CircularProgressIndicator(color: AppTheme.goldPrimary),
                    ),
                    error: (_, __) => Center(
                      child: Text(
                        'حدث خطأ',
                        style: GoogleFonts.notoKufiArabic(color: AppTheme.textMuted),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.bgCard.withValues(alpha: 0.6),
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.borderGold, width: 0.5),
              ),
              child: const Icon(Icons.arrow_forward_ios_rounded, color: AppTheme.textPrimary, size: 18),
            ),
          ),
          const Spacer(),
          Text(
            'إدارة التخزين',
            style: GoogleFonts.notoKufiArabic(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, StorageStats stats) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        _buildOverviewCard(stats),
        const SizedBox(height: 20),
        _buildSectionTitle('التنزيلات'),
        const SizedBox(height: 8),
        _buildInfoRow(
          icon: Icons.download_rounded,
          label: 'حجم التنزيلات',
          value: stats.downloadedSizeFormatted,
        ),
        _buildInfoRow(
          icon: Icons.audio_file_rounded,
          label: 'عدد الملفات',
          value: '${stats.downloadedFileCount} ملف',
        ),
        const SizedBox(height: 16),
        _buildSectionTitle('الذاكرة المؤقتة'),
        const SizedBox(height: 8),
        _buildInfoRow(
          icon: Icons.cleaning_services_rounded,
          label: 'حجم الكاش',
          value: stats.cacheSizeFormatted,
        ),
        const SizedBox(height: 24),
        _buildDangerButton(
          icon: Icons.delete_sweep_rounded,
          title: 'مسح الذاكرة المؤقتة',
          subtitle: 'حذف الملفات المؤقتة فقط (لا يحذف التنزيلات)',
          onTap: () => _confirmClearCache(context, ref),
        ),
        const SizedBox(height: 12),
        _buildDangerButton(
          icon: Icons.delete_forever_rounded,
          title: 'مسح جميع التنزيلات',
          subtitle: 'حذف جميع ملفات القرآن المحفوظة',
          onTap: () => _confirmClearDownloads(context, ref),
          isDestructive: true,
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildOverviewCard(StorageStats stats) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'إجمالي التخزين',
            style: GoogleFonts.notoKufiArabic(
              fontSize: 14,
              color: AppTheme.textMuted,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            stats.totalSizeFormatted,
            style: GoogleFonts.notoKufiArabic(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: AppTheme.goldPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatChip(
                  icon: Icons.download_rounded,
                  label: 'التنزيلات',
                  value: stats.downloadedSizeFormatted,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatChip(
                  icon: Icons.cleaning_services_rounded,
                  label: 'الكاش',
                  value: stats.cacheSizeFormatted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.bgCard.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderGold.withValues(alpha: 0.3), width: 0.5),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppTheme.goldPrimary, size: 20),
          const SizedBox(height: 6),
          Text(
            label,
            style: GoogleFonts.notoKufiArabic(fontSize: 11, color: AppTheme.textMuted),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: GoogleFonts.notoKufiArabic(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.notoKufiArabic(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppTheme.goldPrimary,
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.bgCard.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.borderGold.withValues(alpha: 0.2), width: 0.5),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.goldPrimary, size: 18),
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.notoKufiArabic(fontSize: 13, color: AppTheme.textMuted),
            ),
            const Spacer(),
            Text(
              value,
              style: GoogleFonts.notoKufiArabic(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDangerButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDestructive
              ? Colors.redAccent.withValues(alpha: 0.1)
              : AppTheme.bgCard.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDestructive
                ? Colors.redAccent.withValues(alpha: 0.3)
                : AppTheme.borderGold.withValues(alpha: 0.3),
            width: 0.5,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isDestructive ? Colors.redAccent : AppTheme.goldPrimary, size: 24),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.notoKufiArabic(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDestructive ? Colors.redAccent : AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.notoKufiArabic(
                      fontSize: 11,
                      color: AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_left_rounded, color: AppTheme.textMuted, size: 20),
          ],
        ),
      ),
    );
  }

  void _confirmClearCache(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: AppTheme.bgCard,
          title: Text(
            'مسح الذاكرة المؤقتة',
            style: GoogleFonts.notoKufiArabic(color: AppTheme.textPrimary),
          ),
          content: Text(
            'سيتم حذف الملفات المؤقتة فقط. لن تُحذف التنزيلات.',
            style: GoogleFonts.notoKufiArabic(color: AppTheme.textMuted),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('إلغاء', style: GoogleFonts.notoKufiArabic(color: AppTheme.textMuted)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(ctx);
                final storage = ref.read(audioStorageServiceProvider);
                await storage.clearCache();
                ref.invalidate(storageStatsProvider);
              },
              child: Text('مسح', style: GoogleFonts.notoKufiArabic(color: AppTheme.goldPrimary)),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmClearDownloads(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: AppTheme.bgCard,
          title: Text(
            'مسح جميع التنزيلات',
            style: GoogleFonts.notoKufiArabic(color: Colors.redAccent),
          ),
          content: Text(
            'سيتم حذف جميع ملفات القرآن المحفوظة. هذا الإجراء لا يمكن التراجع عنه.',
            style: GoogleFonts.notoKufiArabic(color: AppTheme.textMuted),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('إلغاء', style: GoogleFonts.notoKufiArabic(color: AppTheme.textMuted)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(ctx);
                final storage = ref.read(audioStorageServiceProvider);
                await storage.clearAllDownloads();
                ref.invalidate(storageStatsProvider);
              },
              child: Text('مسح الكل', style: GoogleFonts.notoKufiArabic(color: Colors.redAccent)),
            ),
          ],
        ),
      ),
    );
  }
}

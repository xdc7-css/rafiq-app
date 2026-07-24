import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../theme/app_theme.dart';
import '../../providers/mercy_register_providers.dart';

class MemorialDetailsScreen extends ConsumerWidget {
  final String memorialId;

  const MemorialDetailsScreen({super.key, required this.memorialId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memorials = ref.watch(memorialsProvider);
    final memorial = memorials.where((m) => m.id == memorialId).firstOrNull;

    return Scaffold(
      backgroundColor: AppTheme.bgPrimary,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: AppTheme.textPrimary),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  Text(
                    memorial?.displayName ?? 'تفاصيل السجل',
                    style: GoogleFonts.notoKufiArabic(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: memorial == null
                  ? Center(
                      child: Text(
                        'السجل غير موجود',
                        style: GoogleFonts.notoKufiArabic(
                          color: AppTheme.textMuted,
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      child: Column(
                        children: [
                          const SizedBox(height: 24),
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppTheme.goldPrimary.withValues(alpha: 0.1),
                              border: Border.all(
                                color: AppTheme.goldPrimary.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Icon(
                              Icons.menu_book_rounded,
                              size: 40,
                              color: AppTheme.goldPrimary,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            memorial.displayName,
                            style: GoogleFonts.notoKufiArabic(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'منذ ${memorial.timeAgo}',
                            style: GoogleFonts.notoKufiArabic(
                              fontSize: 13,
                              color: AppTheme.textMuted,
                            ),
                          ),
                          const SizedBox(height: 32),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _StatTile(
                                label: 'الدعاء',
                                value: '${memorial.duaCount}',
                                icon: Icons.favorite_rounded,
                              ),
                              _StatTile(
                                label: 'الختمات',
                                value: '${memorial.khatmahCount}',
                                icon: Icons.menu_book_rounded,
                              ),
                              _StatTile(
                                label: 'التسبيح',
                                value: '${memorial.tasbeehCount}',
                                icon: Icons.spa_rounded,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          if (memorial.description != null &&
                              memorial.description!.isNotEmpty) ...[
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppTheme.bgCard.withValues(alpha: 0.4),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppTheme.borderSubtle,
                                  width: 0.5,
                                ),
                              ),
                              child: Text(
                                memorial.description!,
                                style: GoogleFonts.notoKufiArabic(
                                  fontSize: 13,
                                  color: AppTheme.textMuted,
                                  height: 1.8,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                          if (memorial.duaText != null &&
                              memorial.duaText!.isNotEmpty) ...[
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppTheme.goldPrimary.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppTheme.goldPrimary.withValues(alpha: 0.15),
                                  width: 0.5,
                                ),
                              ),
                              child: Text(
                                memorial.duaText!,
                                style: GoogleFonts.notoKufiArabic(
                                  fontSize: 16,
                                  color: AppTheme.goldPrimary,
                                  height: 2.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppTheme.bgCard.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderSubtle, width: 0.5),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.goldPrimary, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.notoKufiArabic(
                fontSize: 14,
                color: AppTheme.textMuted,
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppTheme.goldPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

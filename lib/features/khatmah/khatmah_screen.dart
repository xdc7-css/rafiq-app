import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/arabic_strings.dart';
import '../../providers/khatmah_provider.dart';
import '../../models/khatmah_model.dart';
import '../../theme/app_theme.dart';
import '../../theme/ds_components.dart';
import '../../widgets/star_background.dart';

class KhatmahScreen extends ConsumerStatefulWidget {
  const KhatmahScreen({super.key});

  @override
  ConsumerState<KhatmahScreen> createState() => _KhatmahScreenState();
}

class _KhatmahScreenState extends ConsumerState<KhatmahScreen> {
  @override
  Widget build(BuildContext context) {
    final khatmah = ref.watch(khatmahNotifierProvider);
    final w = MediaQuery.sizeOf(context).width;

    return IslamicBackground(
      child: SafeArea(
        child: khatmah == null
            ? _buildNoKhatmah(w)
            : _buildKhatmahContent(khatmah, w),
      ),
    );
  }

  Widget _buildNoKhatmah(double w) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(w < 360 ? 16 : 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu_book,
              size: w < 360 ? 56 : 64,
              color: AppTheme.goldPrimary.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              Ar.startKhatmah,
              style: GoogleFonts.notoKufiArabic(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              Ar.startKhatmahDesc,
              textAlign: TextAlign.center,
              style: GoogleFonts.notoKufiArabic(
                fontSize: 14,
                color: AppTheme.textMuted,
              ),
            ),
            SizedBox(height: w < 360 ? 18 : 24),
            GlassCard(
              radius: 20,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              onTap: () => _startNewKhatmah(context),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.play_arrow, color: AppTheme.goldPrimary),
                  const SizedBox(width: 8),
                  Text(
                    Ar.startNewKhatmah,
                    style: GoogleFonts.notoKufiArabic(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.goldPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKhatmahContent(KhatmahModel khatmah, double w) {
    final surahName = KhatmahModel.surahName(khatmah.currentSurah);
    final juz = khatmah.currentJuz;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Progress Card
          GlassCard(
            radius: 28,
            padding: EdgeInsets.all(w < 360 ? 16 : 20),
            glowing: true,
            child: Column(
              children: [
                SizedBox(
                  width: w < 360 ? 120.0 : 140.0,
                  height: w < 360 ? 120.0 : 140.0,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: w < 360 ? 120.0 : 140.0,
                        height: w < 360 ? 120.0 : 140.0,
                        child: CircularProgressIndicator(
                          value: khatmah.progress,
                          strokeWidth: 10,
                          backgroundColor: AppTheme.goldPrimary.withValues(
                            alpha: 0.15,
                          ),
                          valueColor: const AlwaysStoppedAnimation(
                            AppTheme.goldPrimary,
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${khatmah.progressPercentage}%',
                            style: GoogleFonts.notoKufiArabic(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          Text(
                            '${khatmah.currentPage}/${KhatmahModel.totalPages}',
                            style: GoogleFonts.notoKufiArabic(
                              fontSize: 13,
                              color: AppTheme.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  Ar.khatmahProgressLabel,
                  style: GoogleFonts.notoKufiArabic(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.goldPrimary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppTheme.borderGold, width: 0.5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            'سورة $surahName',
                            style: GoogleFonts.notoKufiArabic(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.goldPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'الآية ${khatmah.currentAyah}',
                            style: GoogleFonts.notoKufiArabic(
                              fontSize: 13,
                              color: AppTheme.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Statistics
          Row(
            children: [
              Expanded(
                child: _buildStatCard('الأجزاء', '$juz/30', Icons.bookmark),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatCard(
                  Ar.daysActive,
                  '${khatmah.daysActive}',
                  Icons.calendar_today,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  Ar.readingStreak,
                  '${khatmah.currentStreak} يوم',
                  Icons.local_fire_department,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatCard(
                  Ar.remainingPagesLabel,
                  '${khatmah.remainingPages}',
                  Icons.bookmark_border,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'الآيات المقروءة',
                  '${khatmah.totalAyahsRead}',
                  Icons.auto_stories_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatCard(
                  Ar.estCompletion,
                  khatmah.estimatedCompletionDate != null
                      ? _formatDate(khatmah.estimatedCompletionDate!)
                      : Ar.notApplicable,
                  Icons.event,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Quick Actions
          Row(
            children: [
              Expanded(
                child: GlassCard(
                  radius: 16,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 8,
                  ),
                  onTap: () => context.push('/quran'),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.play_arrow_rounded,
                        color: AppTheme.goldPrimary,
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'استئناف',
                        style: GoogleFonts.notoKufiArabic(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.goldPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GlassCard(
                  radius: 16,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 8,
                  ),
                  onTap: () => _shareProgress(khatmah),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.share_outlined,
                        color: AppTheme.goldPrimary,
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        Ar.share,
                        style: GoogleFonts.notoKufiArabic(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.goldPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: GlassCard(
                  radius: 16,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 8,
                  ),
                  onTap: () => _startNewKhatmah(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: AppTheme.goldPrimary, size: 20),
                      const SizedBox(width: 6),
                      Text(
                        Ar.newKhatmah,
                        style: GoogleFonts.notoKufiArabic(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.goldPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GlassCard(
                  radius: 16,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 8,
                  ),
                  onTap: () => _showResetDialog(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.refresh,
                        color: AppTheme.goldPrimary,
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'إعادة تعيين',
                        style: GoogleFonts.notoKufiArabic(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.goldPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return GlassCard(
      radius: 16,
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          Icon(icon, color: AppTheme.goldPrimary, size: 22),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.notoKufiArabic(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.notoKufiArabic(
              fontSize: 11,
              color: AppTheme.textMuted,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}/${date.month}/${date.day}';
  }

  void _shareProgress(KhatmahModel khatmah) {
    final surahName = KhatmahModel.surahName(khatmah.currentSurah);
    final text =
        'لقد أتممت ${khatmah.progressPercentage}% من الختمة القرآنية! '
        'وصلت إلى سورة $surahName آية ${khatmah.currentAyah}. '
        '${khatmah.totalAyahsRead} آية مقروءة.';
    Share.share(text);
  }

  void _startNewKhatmah(BuildContext context) {
    final nameController = TextEditingController(text: Ar.myKhatmah);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.bgCard,
        title: Text(
          Ar.startNewKhatmah,
          style: GoogleFonts.notoKufiArabic(color: AppTheme.textPrimary),
        ),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: Ar.khatmahName,
            hintText: Ar.khatmahNameHint,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(Ar.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              ref
                  .read(khatmahNotifierProvider.notifier)
                  .startNewKhatmah(name: nameController.text);
              Navigator.pop(context);
            },
            child: Text(Ar.start),
          ),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.bgCard,
        title: Text(
          Ar.resetKhatmah,
          style: GoogleFonts.notoKufiArabic(color: AppTheme.textPrimary),
        ),
        content: Text(
          Ar.resetKhatmahConfirm,
          style: GoogleFonts.notoKufiArabic(color: AppTheme.textMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(Ar.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(khatmahNotifierProvider.notifier).reset();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE74C3C),
            ),
            child: Text(Ar.resetKhatmahAction),
          ),
        ],
      ),
    );
  }
}

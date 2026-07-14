import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/adhkar_model.dart';
import '../theme/app_theme.dart';
import '../theme/ds_components.dart';
import 'islamic_art.dart';

/// Daily azkar progress with circular indicator and stats.
class AzkarProgressSection extends StatelessWidget {
  final List<AdhkarCategory> categories;

  const AzkarProgressSection({super.key, required this.categories});

  ({int completed, int total, int remaining, double progress}) _stats() {
    var completed = 0;
    var total = 0;
    for (final cat in categories) {
      for (final dhikr in cat.adhkar) {
        total += dhikr.targetCount;
        completed += dhikr.currentCount.clamp(0, dhikr.targetCount);
      }
    }
    final remaining = total - completed;
    final progress = total > 0 ? completed / total : 0.0;
    return (completed: completed, total: total, remaining: remaining, progress: progress);
  }

  @override
  Widget build(BuildContext context) {
    final stats = _stats();
    final pct = (stats.progress * 100).round();

    return GlassCard(
      radius: 28,
      padding: const EdgeInsets.all(20),
      onTap: () => context.push('/adhkar'),
      child: Stack(
        children: [
          Positioned(
            left: -20,
            bottom: -10,
            child: PrayerRug(width: 70, height: 90),
          ),
          Positioned(
            right: -8,
            top: -8,
            child: FloralOrnament(size: 80, opacity: 0.05),
          ),
          Row(
            children: [
              GoldCircularProgress(
                value: stats.progress,
                size: 110,
                strokeWidth: 8,
                centerText: '$pct%',
                subtitle: 'مكتمل',
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 3,
                          height: 18,
                          decoration: BoxDecoration(
                            gradient: AppTheme.goldGradient,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'تقدم الأذكار اليوم',
                          style: GoogleFonts.notoKufiArabic(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _StatRow(
                      label: 'مكتمل',
                      value: '${stats.completed}',
                      icon: Icons.check_circle_outline_rounded,
                    ),
                    const SizedBox(height: 8),
                    _StatRow(
                      label: 'متبقي',
                      value: '${stats.remaining}',
                      icon: Icons.hourglass_empty_rounded,
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: stats.progress,
                        minHeight: 5,
                        backgroundColor: AppTheme.goldPrimary.withValues(alpha: 0.08),
                        valueColor: const AlwaysStoppedAnimation(AppTheme.goldPrimary),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppTheme.goldPrimary.withValues(alpha: 0.7)),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.notoKufiArabic(
            fontSize: 12,
            color: AppTheme.textMuted,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: GoogleFonts.notoKufiArabic(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppTheme.goldSoft,
          ),
        ),
      ],
    );
  }
}

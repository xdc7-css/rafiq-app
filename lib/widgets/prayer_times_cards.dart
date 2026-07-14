import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/arabic_strings.dart';
import '../models/prayer_times.dart';
import '../providers/settings_provider.dart';
import '../services/time_formatter.dart';
import '../theme/app_theme.dart';
import '../theme/ds_components.dart';

class PrayerTimesCards extends ConsumerWidget {
  final PrayerTimes? prayerTimes;
  final String? nextPrayer;
  final Duration? timeUntilNext;
  final bool isLoading;
  final String? error;
  final VoidCallback? onRetry;

  const PrayerTimesCards({
    super.key,
    this.prayerTimes,
    this.nextPrayer,
    this.timeUntilNext,
    this.isLoading = false,
    this.error,
    this.onRetry,
  });

  static const _arabicNames = {
    'Fajr': 'الفجر',
    'Sunrise': 'الشروق',
    'Dhuhr': 'الظهر',
    'Asr': 'العصر',
    'Maghrib': 'المغرب',
    'Isha': 'العشاء',
  };

  static IconData _iconFor(String name) {
    switch (name) {
      case 'Fajr':
        return Icons.wb_twilight_rounded;
      case 'Sunrise':
        return Icons.wb_sunny_outlined;
      case 'Dhuhr':
        return Icons.light_mode_rounded;
      case 'Asr':
        return Icons.wb_cloudy_rounded;
      case 'Maghrib':
        return Icons.wb_twilight_rounded;
      case 'Isha':
        return Icons.nightlight_round;
      default:
        return Icons.access_time_rounded;
    }
  }

  double _progressFor(String arabicName, DateTime prayerTime) {
    if (nextPrayer != arabicName || timeUntilNext == null) return 0;
    final total = const Duration(hours: 6);
    final elapsed = total - timeUntilNext!;
    return (elapsed.inMinutes / total.inMinutes).clamp(0.0, 1.0);
  }

  List<Map<String, dynamic>> _buildPrayerList() {
    if (prayerTimes == null) return [];
    final ordered = ['Fajr', 'Sunrise', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];
    return ordered
        .map((name) => {
              'name': name,
              'time': prayerTimes!.timings[name],
            })
        .where((m) => m['time'] != null)
        .toList();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsNotifierProvider);
    final numerals = settings.numeralSystem;
    final timeFmt = settings.timeFormat;
    final locale = settings.language;
    final prayers = _buildPrayerList();
    final w = MediaQuery.sizeOf(context).width;
    final cardW = w < 360 ? 92.0 : w < 420 ? 100.0 : 108.0;
    final listH = w < 360 ? 126.0 : 138.0;

    if (isLoading || prayers.isEmpty) {
      if (error != null) {
        return GlassCard(
          radius: 28,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: SizedBox(
            height: listH,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        Ar.noConnection,
                        style: GoogleFonts.notoKufiArabic(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        error!,
                        style: GoogleFonts.notoKufiArabic(
                          fontSize: 10,
                          color: Colors.white70,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: AppTheme.goldPrimary.withValues(alpha: 0.2),
                    foregroundColor: AppTheme.goldPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh_rounded),
                ),
              ],
            ),
          ),
        );
      }

      return SizedBox(
        height: listH,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          itemCount: 6,
          separatorBuilder: (_, __) => const SizedBox(width: 10),
          itemBuilder: (context, index) => _PrayerCardSkeleton(cardWidth: cardW),
        ),
      );
    }

    return SizedBox(
      height: listH,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemCount: prayers.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final prayer = prayers[index];
          final name = prayer['name'] as String;
          final time = prayer['time'] as DateTime;
          final arabic = _arabicNames[name] ?? name;
          final isActive = nextPrayer == arabic;
          final remaining = (isActive && timeUntilNext != null)
              ? TimeFormatter.formatRemaining(timeUntilNext!, numerals: numerals)
              : '';
          final progress = _progressFor(arabic, time);

          return _PrayerCard(
            name: arabic,
            time: TimeFormatter.formatTime(
              time,
              format: timeFmt,
              numerals: numerals,
              locale: locale,
            ),
            remaining: remaining,
            icon: _iconFor(name),
            isActive: isActive,
            progress: progress,
            cardWidth: cardW,
          );
        },
      ),
    );
  }
}

class _PrayerCardSkeleton extends StatelessWidget {
  final double cardWidth;
  const _PrayerCardSkeleton({this.cardWidth = 108});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = AppTheme.bgCard;
    return Container(
      width: cardWidth,
      decoration: BoxDecoration(
        color: cardBg.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? AppTheme.borderSubtle : AppTheme.goldPrimary.withValues(alpha: 0.15),
          width: 0.5,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppTheme.goldPrimary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: 60,
            height: 12,
            decoration: BoxDecoration(
              color: AppTheme.goldPrimary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 45,
            height: 10,
            decoration: BoxDecoration(
              color: AppTheme.goldPrimary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrayerCard extends StatefulWidget {
  final String name;
  final String time;
  final String remaining;
  final IconData icon;
  final bool isActive;
  final double progress;
  final double cardWidth;

  const _PrayerCard({
    required this.name,
    required this.time,
    required this.remaining,
    required this.icon,
    required this.isActive,
    required this.progress,
    this.cardWidth = 108,
  });

  @override
  State<_PrayerCard> createState() => _PrayerCardState();
}

class _PrayerCardState extends State<_PrayerCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = AppTheme.bgCard;
    final textCol = AppTheme.textPrimary;
    final textMutedCol = AppTheme.textMuted;
    final accentGold = AppTheme.goldPrimary;
    final shadowCol = isDark ? Colors.black.withValues(alpha: 0.25) : Colors.black.withValues(alpha: 0.04);
    final borderCol = isDark ? AppTheme.borderSubtle : accentGold.withValues(alpha: 0.15);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        width: widget.cardWidth,
        transform: Matrix4.translationValues(0, _hovered ? -3 : 0, 0),
        decoration: BoxDecoration(
          color: cardBg.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: widget.isActive
                ? accentGold.withValues(alpha: 0.6)
                : borderCol.withValues(alpha: 0.15),
            width: widget.isActive ? 1.2 : 0.5,
          ),
          boxShadow: [
            if (widget.isActive || _hovered)
              BoxShadow(
                color: accentGold.withValues(
                    alpha: widget.isActive ? 0.15 : 0.08),
                blurRadius: widget.isActive ? 16 : 8,
                spreadRadius: widget.isActive ? 0 : -3,
              ),
            BoxShadow(
              color: shadowCol,
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Stack(
            children: [
              if (widget.isActive)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: widget.progress),
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeOut,
                    builder: (context, value, _) => LinearProgressIndicator(
                      value: value,
                      minHeight: 3,
                      backgroundColor: accentGold.withValues(alpha: 0.1),
                      valueColor: AlwaysStoppedAnimation(accentGold),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: widget.isActive
                            ? accentGold.withValues(alpha: 0.2)
                            : (isDark ? AppTheme.bgSurface.withValues(alpha: 0.5) : accentGold.withValues(alpha: 0.08)),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: widget.isActive
                            ? [BoxShadow(color: accentGold.withValues(alpha: 0.15), blurRadius: 8)]
                            : null,
                      ),
                      child: Icon(
                        widget.icon,
                        size: 18,
                        color: widget.isActive ? accentGold : textMutedCol,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.name,
                      style: GoogleFonts.notoKufiArabic(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: widget.isActive ? accentGold : textCol,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.time,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: textMutedCol,
                      ),
                    ),
                    if (widget.remaining.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        widget.remaining,
                        style: GoogleFonts.notoKufiArabic(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: accentGold,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

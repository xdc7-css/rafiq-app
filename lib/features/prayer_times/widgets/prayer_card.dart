import 'package:flutter/material.dart';
import '../../../core/arabic_strings.dart';

class PrayerCard extends StatelessWidget {
  final String name;
  final String time;
  final IconData icon;
  final bool isCurrent;
  final bool isNext;
  final bool isPassed;
  final double progress;
  final String? remaining;

  const PrayerCard({
    super.key,
    required this.name,
    required this.time,
    required this.icon,
    this.isCurrent = false,
    this.isNext = false,
    this.isPassed = false,
    this.progress = 0.0,
    this.remaining,
  });

  static IconData iconFor(String prayerName) {
    switch (prayerName) {
      case 'Fajr':
        return Icons.nightlight_round;
      case 'Sunrise':
        return Icons.wb_sunny;
      case 'Dhuhr':
        return Icons.wb_sunny_outlined;
      case 'Asr':
        return Icons.wb_cloudy;
      case 'Maghrib':
        return Icons.wb_twilight;
      case 'Isha':
        return Icons.nights_stay;
      case 'Imsak':
        return Icons.dark_mode;
      case 'Midnight':
        return Icons.nightlight;
      default:
        return Icons.access_time;
    }
  }

  static String arabicNameFor(String prayerName) {
    switch (prayerName) {
      case 'Fajr':
        return Ar.fajr;
      case 'Sunrise':
        return Ar.sunrise;
      case 'Dhuhr':
        return Ar.dhuhr;
      case 'Asr':
        return Ar.asr;
      case 'Maghrib':
        return Ar.maghrib;
      case 'Isha':
        return Ar.isha;
      case 'Imsak':
        return Ar.imsak;
      case 'Midnight':
        return Ar.midnight;
      default:
        return prayerName;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isActive = isCurrent || isNext;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: isActive ? 2 : 0,
      color: isNext
          ? theme.colorScheme.primaryContainer
          : isPassed
              ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5)
              : theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isNext
            ? BorderSide(color: theme.colorScheme.primary, width: 1.5)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isNext
                    ? theme.colorScheme.primary
                    : isPassed
                        ? theme.colorScheme.onSurface.withValues(alpha: 0.08)
                        : theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isNext
                    ? theme.colorScheme.onPrimary
                    : isPassed
                        ? theme.colorScheme.onSurface.withValues(alpha: 0.3)
                        : theme.colorScheme.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isPassed
                          ? theme.colorScheme.onSurface.withValues(alpha: 0.4)
                          : null,
                    ),
                  ),
                  if (isNext && remaining != null)
                    Text(
                      '$remaining ${Ar.remainingLabel}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  time,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isNext
                        ? theme.colorScheme.primary
                        : isPassed
                            ? theme.colorScheme.onSurface.withValues(alpha: 0.3)
                            : null,
                  ),
                ),
                if (isActive && progress > 0)
                  SizedBox(
                    width: 60,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: progress.clamp(0.0, 1.0),
                        minHeight: 4,
                        backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                        valueColor: AlwaysStoppedAnimation(
                          isNext
                              ? theme.colorScheme.primary
                              : theme.colorScheme.tertiary,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

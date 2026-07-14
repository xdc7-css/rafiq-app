import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/arabic_strings.dart';
import '../../../../../models/prayer_times.dart';
import '../../../../../providers/settings_provider.dart';
import '../../../../../providers/prayer_time_providers.dart';
import '../../../../../services/time_formatter.dart';
import '../../../../../theme/app_theme.dart';
import '../prayer_period.dart';

class PremiumPrayerTimeline extends ConsumerWidget {
  final PrayerTimesState state;
  final PrayerTimes times;
  final AnimationController timelineController;
  final bool isDark;
  final PrayerPeriod prayerPeriod;

  const PremiumPrayerTimeline({
    required this.state,
    required this.times,
    required this.timelineController,
    required this.isDark,
    required this.prayerPeriod,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsNotifierProvider);
    final numerals = settings.numeralSystem;
    final timeFmt = settings.timeFormat;
    final locale = settings.language;
    final orderedTimes = ['Fajr', 'Sunrise', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  gradient: AppTheme.goldGradient,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                Ar.prayerSchedule,
                style: GoogleFonts.notoKufiArabic(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              const Spacer(),
              _TimelineLegend(isDark: isDark),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 180,
            child: AnimatedBuilder(
              animation: timelineController,
              builder: (context, _) {
                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  itemCount: orderedTimes.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    final name = orderedTimes[index];
                    final time = times.timings[name];
                    if (time == null) return const SizedBox.shrink();

                    final isPassed = time.isBefore(DateTime.now());
                    final isNext = state.nextPrayer == name;
                    final isCurrent = state.currentPrayer == name && !isNext;
                    final isActive = isNext || isCurrent;

                    return _TimelineMilestone(
                      name: _getArabicName(name),
                      nameEn: name,
                      time: time,
                      isPassed: isPassed && !isNext,
                      isNext: isNext,
                      isCurrent: isCurrent,
                      isActive: isActive,
                      progress: isNext && state.timeUntilNext != null
                          ? _computeProgress(times, name, DateTime.now())
                          : 0.0,
                      remaining: isNext && state.timeUntilNext != null
                          ? state.timeUntilNext!
                          : null,
                      timelineProgress: timelineController.value,
                      index: index,
                      prayerPeriod: prayerPeriod,
                      isDark: isDark,
                      numerals: numerals,
                      timeFmt: timeFmt,
                      locale: locale,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  double _computeProgress(PrayerTimes times, String nextName, DateTime now) {
    final ordered = ['Fajr', 'Sunrise', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];
    final currentIdx = ordered.indexOf(nextName);
    if (currentIdx <= 0) return 0;

    final currentTime = times.timings[ordered[currentIdx - 1]];
    final nextTime = times.timings[nextName];
    if (currentTime == null || nextTime == null) return 0;

    final total = nextTime.difference(currentTime).inSeconds;
    if (total <= 0) return 0;

    final elapsed = now.difference(currentTime).inSeconds;
    return (elapsed / total).clamp(0.0, 1.0);
  }

  String _getArabicName(String prayer) {
    switch (prayer) {
      case 'Fajr':
        return 'الفجر';
      case 'Sunrise':
        return 'الشروق';
      case 'Dhuhr':
        return 'الظهر';
      case 'Asr':
        return 'العصر';
      case 'Maghrib':
        return 'المغرب';
      case 'Isha':
        return 'العشاء';
      default:
        return prayer;
    }
  }
}

class _TimelineLegend extends StatelessWidget {
  final bool isDark;

  const _TimelineLegend({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _LegendItem(
          color: AppTheme.textMuted,
          label: 'مضى',
          isDark: isDark,
        ),
        const SizedBox(width: 16),
        _LegendItem(
          color: AppTheme.goldPrimary,
          label: 'التالي',
          isDark: isDark,
          isActive: true,
        ),
        const SizedBox(width: 16),
        _LegendItem(
          color: AppTheme.goldPrimary,
          label: 'الحالية',
          isDark: isDark,
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final bool isDark;
  final bool isActive;

  const _LegendItem({
    required this.color,
    required this.label,
    required this.isDark,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            boxShadow: [
              if (isActive)
                BoxShadow(
                  color: color.withValues(alpha: 0.5),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
            ],
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.notoKufiArabic(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppTheme.textMuted,
          ),
        ),
      ],
    );
  }
}

class _TimelineMilestone extends StatefulWidget {
  final String name;
  final String nameEn;
  final DateTime time;
  final bool isPassed;
  final bool isNext;
  final bool isCurrent;
  final bool isActive;
  final double progress;
  final Duration? remaining;
  final double timelineProgress;
  final int index;
  final PrayerPeriod prayerPeriod;
  final bool isDark;
  final NumeralSystem numerals;
  final TimeFormat timeFmt;
  final String locale;

  const _TimelineMilestone({
    required this.name,
    required this.nameEn,
    required this.time,
    required this.isPassed,
    required this.isNext,
    required this.isCurrent,
    required this.isActive,
    required this.progress,
    required this.remaining,
    required this.timelineProgress,
    required this.index,
    required this.prayerPeriod,
    required this.isDark,
    required this.numerals,
    required this.timeFmt,
    required this.locale,
  });

  @override
  State<_TimelineMilestone> createState() => _TimelineMilestoneState();
}

class _TimelineMilestoneState extends State<_TimelineMilestone>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressController;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  void _handleTapDown(_) {
    _pressController.forward();
  }

  void _handleTapUp(_) {
    _pressController.reverse();
  }

  void _handleTapCancel() {
    _pressController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_pressController]),
      builder: (context, _) {
        final scale = 1.0 - _pressController.value * 0.05;
        final elevation = 1.0 + _pressController.value * 0.5;

        return GestureDetector(
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          child: Transform.scale(
            scale: scale,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              width: 150,
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: _getCardColors(),
                  stops: const [0.0, 0.5, 1.0],
                ),
                border: Border.all(
                  color: _getBorderColor().withValues(alpha: 0.3),
                  width: widget.isActive ? 1.5 : 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.shadowDark.withValues(alpha: 0.3 * elevation),
                    blurRadius: 24 * elevation,
                    offset: Offset(0, 8 * elevation),
                    spreadRadius: -4 * elevation,
                  ),
                  if (widget.isActive)
                    BoxShadow(
                      color: _getGlowColor().withValues(alpha: 0.2 * elevation),
                      blurRadius: 20 * elevation,
                      offset: Offset(0, 4 * elevation),
                      spreadRadius: -2 * elevation,
                    ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1 * elevation),
                    blurRadius: 30 * elevation,
                    offset: Offset(0, 12 * elevation),
                    spreadRadius: -8 * elevation,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Prayer icon
                      _PrayerMilestoneIcon(
                        name: widget.nameEn,
                        isActive: widget.isActive,
                        isPassed: widget.isPassed,
                        isCurrent: widget.isCurrent,
                        prayerPeriod: widget.prayerPeriod,
                        isDark: widget.isDark,
                      ),

                      const SizedBox(height: 16),

                      // Prayer name
                      Text(
                        widget.name,
                        style: GoogleFonts.notoKufiArabic(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: _getTextColor(),
                          height: 1.3,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 6),

                      // Time
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 13,
                            color: _getTimeColor(),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            TimeFormatter.formatTime(
                              widget.time,
                              format: widget.timeFmt,
                              numerals: widget.numerals,
                              locale: widget.locale,
                            ),
                            style: GoogleFonts.spaceMono(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: _getTimeColor(),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),

                      // Status / Countdown
                      if (widget.isNext && widget.remaining != null) ...[
                        const SizedBox(height: 14),
                        _MilestoneCountdown(
                          hours: widget.remaining!.inHours,
                          minutes: widget.remaining!.inMinutes.remainder(60),
                          progress: widget.progress,
                          isDark: widget.isDark,
                          numerals: widget.numerals,
                        ),
                      ] else if (widget.isCurrent) ...[
                        const SizedBox(height: 14),
                        _CurrentPrayerIndicator(isDark: widget.isDark),
                      ] else if (widget.isPassed) ...[
                        const SizedBox(height: 14),
                        _PassedIndicator(isDark: widget.isDark),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<Color> _getCardColors() {
    if (widget.isDark) {
      if (widget.isActive) {
        return [
          AppTheme.bgCard.withValues(alpha: 0.95),
          AppTheme.bgSecondary.withValues(alpha: 0.85),
          AppTheme.bgPrimary.withValues(alpha: 0.9),
        ];
      }
      if (widget.isPassed) {
        return [
          AppTheme.bgCard.withValues(alpha: 0.7),
          AppTheme.bgSecondary.withValues(alpha: 0.6),
          AppTheme.bgPrimary.withValues(alpha: 0.7),
        ];
      }
      return [
        AppTheme.bgCard.withValues(alpha: 0.85),
        AppTheme.bgSecondary.withValues(alpha: 0.75),
        AppTheme.bgPrimary.withValues(alpha: 0.8),
      ];
    } else {
      if (widget.isActive) {
        return [
          AppTheme.bgCard.withValues(alpha: 0.95),
          AppTheme.bgSecondary.withValues(alpha: 0.85),
          AppTheme.bgPrimary.withValues(alpha: 0.9),
        ];
      }
      if (widget.isPassed) {
        return [
          AppTheme.bgCard.withValues(alpha: 0.7),
          AppTheme.bgSecondary.withValues(alpha: 0.6),
          AppTheme.bgPrimary.withValues(alpha: 0.7),
        ];
      }
      return [
        AppTheme.bgCard.withValues(alpha: 0.85),
        AppTheme.bgSecondary.withValues(alpha: 0.75),
        AppTheme.bgPrimary.withValues(alpha: 0.8),
      ];
    }
  }

  Color _getBorderColor() {
    if (widget.isActive) return _getGlowColor();
    if (widget.isPassed) return AppTheme.borderSubtle;
    return AppTheme.borderGold;
  }

  Color _getTextColor() {
    if (widget.isActive) {
      return AppTheme.textPrimary;
    }
    if (widget.isPassed) {
      return AppTheme.textMuted;
    }
    return AppTheme.textPrimary;
  }

  Color _getTimeColor() {
    if (widget.isActive) {
      return _getGlowColor();
    }
    if (widget.isPassed) {
      return AppTheme.textMuted;
    }
    return AppTheme.goldPrimary;
  }

  Color _getGlowColor() {
    return AppTheme.goldPrimary;
  }
}

class _PrayerMilestoneIcon extends StatelessWidget {
  final String name;
  final bool isActive;
  final bool isPassed;
  final bool isCurrent;
  final PrayerPeriod prayerPeriod;
  final bool isDark;

  const _PrayerMilestoneIcon({
    required this.name,
    required this.isActive,
    required this.isPassed,
    required this.isCurrent,
    required this.prayerPeriod,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color iconColor;
    Color bgColor;

    if (isPassed) {
      icon = Icons.check_circle_rounded;
      iconColor = isDark ? AppTheme.goldPrimary : AppTheme.goldPrimary;
      bgColor = AppTheme.goldPrimary.withValues(alpha: 0.15);
    } else if (isCurrent) {
      icon = _getPrayerIcon(name);
      iconColor = AppTheme.goldPrimary;
      bgColor = AppTheme.goldPrimary.withValues(alpha: 0.15);
    } else {
      icon = _getPrayerIcon(name);
      iconColor = isDark ? AppTheme.goldPrimary : AppTheme.goldPrimary;
      bgColor = AppTheme.goldPrimary.withValues(alpha: 0.1);
    }

    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [bgColor, bgColor.withValues(alpha: 0.5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        border: Border.all(
          color: (isActive ? AppTheme.goldPrimary : AppTheme.borderGold)
              .withValues(alpha: 0.3),
          width: isActive ? 2 : 1,
        ),
        boxShadow: [
          if (isActive)
            BoxShadow(
              color: _getGlowColor().withValues(alpha: 0.3),
              blurRadius: 20,
              spreadRadius: 2,
            ),
        ],
      ),
      child: Icon(icon, size: 28, color: iconColor),
    );
  }

  IconData _getPrayerIcon(String name) {
    switch (name) {
      case 'الفجر':
        return Icons.wb_twilight_rounded;
      case 'الشروق':
        return Icons.wb_sunny_rounded;
      case 'الظهر':
        return Icons.wb_sunny_outlined;
      case 'العصر':
        return Icons.brightness_5_rounded;
      case 'المغرب':
        return Icons.nights_stay_rounded;
      case 'العشاء':
        return Icons.nightlight_rounded;
      default:
        return Icons.mosque_rounded;
    }
  }

  Color _getGlowColor() {
    return AppTheme.goldPrimary;
  }
}

class _MilestoneCountdown extends StatelessWidget {
  final int hours;
  final int minutes;
  final double progress;
  final bool isDark;
  final NumeralSystem numerals;

  const _MilestoneCountdown({
    required this.hours,
    required this.minutes,
    required this.progress,
    required this.isDark,
    required this.numerals,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.goldPrimary.withValues(alpha: 0.12),
            AppTheme.goldSoft.withValues(alpha: 0.06),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.borderGold.withValues(alpha: 0.2),
          width: 0.5,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              _SmallCountdownDigit(value: hours, label: 'س', isDark: isDark, numerals: numerals),
              _SmallCountdownSeparator(isDark: isDark),
              _SmallCountdownDigit(value: minutes, label: 'د', isDark: isDark, numerals: numerals),
            ],
          ),
          const SizedBox(height: 8),
          _ProgressIndicator(progress: progress, isDark: isDark),
        ],
      ),
    );
  }
}

class _SmallCountdownDigit extends StatelessWidget {
  final int value;
  final String label;
  final bool isDark;
  final NumeralSystem numerals;

  const _SmallCountdownDigit({
    required this.value,
    required this.label,
    required this.isDark,
    required this.numerals,
  });

  @override
  Widget build(BuildContext context) {
    final str = TimeFormatter.convertDigits(
      value.toString().padLeft(2, '0'),
      numerals,
    );
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ...str.split('').map((digit) {
          return Text(
            digit,
            style: GoogleFonts.spaceMono(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppTheme.goldPrimary,
              height: 1.0,
              letterSpacing: 1,
            ),
          );
        }),
        const SizedBox(width: 2),
        Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Text(
            label,
            style: GoogleFonts.notoKufiArabic(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: AppTheme.goldPrimary.withValues(alpha: 0.7),
              height: 1.0,
            ),
          ),
        ),
      ],
    );
  }
}

class _SmallCountdownSeparator extends StatefulWidget {
  final bool isDark;

  const _SmallCountdownSeparator({required this.isDark});

  @override
  State<_SmallCountdownSeparator> createState() =>
      _SmallCountdownSeparatorState();
}

class _SmallCountdownSeparatorState extends State<_SmallCountdownSeparator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final opacity = 0.5 + 0.5 * math.sin(_controller.value * 2 * math.pi);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
          child: Opacity(
            opacity: opacity,
            child: Text(
              ':',
              style: GoogleFonts.spaceMono(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppTheme.goldPrimary.withValues(alpha: 0.5),
                height: 1.0,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ProgressIndicator extends StatelessWidget {
  final double progress;
  final bool isDark;

  const _ProgressIndicator({required this.progress, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2.5),
        color: AppTheme.bgPrimary.withValues(alpha: 0.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2.5),
        child: Stack(
          children: [
            FractionallySizedBox(
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(gradient: AppTheme.goldGradient),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CurrentPrayerIndicator extends StatelessWidget {
  final bool isDark;

  const _CurrentPrayerIndicator({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.goldPrimary.withValues(alpha: 0.15),
            AppTheme.goldPrimary.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.goldPrimary.withValues(alpha: 0.3),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.goldPrimary,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'الصلاة الحالية',
            style: GoogleFonts.notoKufiArabic(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.goldPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _PassedIndicator extends StatelessWidget {
  final bool isDark;

  const _PassedIndicator({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.goldPrimary.withValues(alpha: 0.1),
            AppTheme.goldPrimary.withValues(alpha: 0.04),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.borderGold.withValues(alpha: 0.15),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle_rounded,
            size: 14,
            color: AppTheme.goldPrimary,
          ),
          const SizedBox(width: 8),
          Text(
            'أُديت',
            style: GoogleFonts.notoKufiArabic(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.goldPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

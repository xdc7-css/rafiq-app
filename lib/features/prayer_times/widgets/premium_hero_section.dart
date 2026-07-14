import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/prayer_times.dart';
import '../../../providers/settings_provider.dart';
import '../../../providers/prayer_time_providers.dart';
import '../../../services/time_formatter.dart';
import '../../../theme/app_theme.dart';

class PremiumHeroSection extends ConsumerWidget {
  final PrayerTimesState state;
  final PrayerTimes times;
  final bool isDark;

  static const _shiaPrayers = ['Fajr', 'Dhuhr', 'Maghrib'];

  const PremiumHeroSection({
    required this.state,
    required this.times,
    required this.isDark,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsNotifierProvider);
    final numerals = settings.numeralSystem;
    final timeFmt = settings.timeFormat;
    final locale = settings.language;

    final heroPrayer = _getHeroPrayer(times);
    final timeUntilHero = _getTimeUntilHeroPrayer(times);

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final isCompact = w < 360;

        final prayerNameSize = isCompact ? 30.0 : 38.0;
        final timeSize = isCompact ? 15.0 : 17.0;
        final infoSize = isCompact ? 10.0 : 12.0;
        final sentenceSize = isCompact ? 9.0 : 11.0;

        final sp2 = isCompact ? 8.0 : 12.0;
        final sp3 = isCompact ? 6.0 : 8.0;
        final sp4 = isCompact ? 4.0 : 6.0;
        final sp5 = isCompact ? 8.0 : 12.0;
        final sp6 = isCompact ? 6.0 : 8.0;

        return AspectRatio(
          aspectRatio: 1.4,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/images/TIMEERBG.PNG',
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 70,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.18),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 200,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.40),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: AppTheme.goldPrimary.withValues(alpha: 0.30),
                        width: 1,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  right: 24,
                  child: SizedBox(
                    width: (w - 48) * 0.48,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: isCompact ? 16 : 20,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _getArabicName(heroPrayer),
                            style: TextStyle(
                              fontFamily: 'DecoTypeThuluth',
                              fontFamilyFallback: const [
                                'NotoKufiArabic',
                              ],
                              fontSize: prayerNameSize,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                              height: 1.0,
                            ),
                          ),
                          SizedBox(height: sp2),
                          Text(
                            TimeFormatter.formatTimeHMS(
                              times.timings[heroPrayer],
                              format: timeFmt,
                              numerals: numerals,
                              locale: locale,
                            ),
                            style: GoogleFonts.spaceMono(
                              fontSize: timeSize,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.goldPrimary,
                              letterSpacing: 0.6,
                            ),
                          ),
                          SizedBox(height: sp3),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_rounded,
                                size: infoSize,
                                color: AppTheme.goldPrimary.withValues(alpha: 0.7),
                              ),
                              SizedBox(width: infoSize < 12 ? 2 : 3),
                              Flexible(
                                child: Text(
                                  state.cityName,
                                  style: GoogleFonts.notoKufiArabic(
                                    fontSize: infoSize,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white.withValues(alpha: 0.75),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: sp4),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today_rounded,
                                size: infoSize - 1,
                                color: AppTheme.goldPrimary.withValues(alpha: 0.50),
                              ),
                              SizedBox(width: infoSize < 12 ? 2 : 3),
                              Flexible(
                                child: Text(
                                  _buildHijriDate(times, numerals),
                                  style: GoogleFonts.notoKufiArabic(
                                    fontSize: infoSize - 1,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white.withValues(alpha: 0.60),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: sp5),
                          _PremiumCountdownPanel(
                            timeUntilNext: timeUntilHero,
                            isCompact: isCompact,
                            numerals: numerals,
                          ),
                          SizedBox(height: sp6),
                          Text(
                            _getCountdownSentence(heroPrayer),
                            style: GoogleFonts.notoKufiArabic(
                              fontSize: sentenceSize,
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withValues(alpha: 0.50),
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getHeroPrayer(PrayerTimes times) {
    final now = DateTime.now();
    for (final key in _shiaPrayers) {
      final time = times.timings[key];
      if (time != null && time.isAfter(now)) return key;
    }
    return 'Fajr';
  }

  Duration _getTimeUntilHeroPrayer(PrayerTimes times) {
    final now = DateTime.now();
    final heroPrayer = _getHeroPrayer(times);
    final prayerTime = times.timings[heroPrayer];

    if (prayerTime != null && prayerTime.isAfter(now)) {
      return prayerTime.difference(now);
    }

    if (heroPrayer == 'Fajr') {
      final todayFajr = times.timings['Fajr'];
      if (todayFajr != null) {
        return todayFajr.add(const Duration(hours: 24)).difference(now);
      }
    }

    return Duration.zero;
  }

  String _getArabicName(String prayer) {
    switch (prayer) {
      case 'Fajr':
        return 'الفجر';
      case 'Dhuhr':
        return 'الظهر';
      case 'Maghrib':
        return 'المغرب';
      default:
        return 'الفجر';
    }
  }

  String _buildHijriDate(PrayerTimes t, NumeralSystem numerals) {
    final parts = <String>[];
    if (t.hijriDate.isNotEmpty) {
      parts.add(TimeFormatter.convertDigits(t.hijriDate, numerals));
    }
    if (t.hijriMonth.isNotEmpty) parts.add(t.hijriMonth);
    if (t.hijriYear.isNotEmpty) {
      parts.add('${TimeFormatter.convertDigits(t.hijriYear, numerals)} هـ');
    }
    return parts.join(' ');
  }

  String _getCountdownSentence(String prayer) {
    switch (prayer) {
      case 'Fajr':
        return 'يتبقى على أذان صلاة الفجر بعد';
      case 'Dhuhr':
        return 'يتبقى على أذان صلاة الظهر بعد';
      case 'Maghrib':
        return 'يتبقى على أذان صلاة المغرب بعد';
      default:
        return 'يتبقى على أذان صلاة الفجر بعد';
    }
  }
}

// ── Premium Countdown Panel ──

class _PremiumCountdownPanel extends StatefulWidget {
  final Duration timeUntilNext;
  final bool isCompact;
  final NumeralSystem numerals;

  const _PremiumCountdownPanel({
    required this.timeUntilNext,
    required this.isCompact,
    required this.numerals,
  });

  @override
  State<_PremiumCountdownPanel> createState() => _PremiumCountdownPanelState();
}

class _PremiumCountdownPanelState extends State<_PremiumCountdownPanel> {
  late Timer _timer;
  late Duration _remaining;

  @override
  void initState() {
    super.initState();
    _remaining = widget.timeUntilNext;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remaining.inSeconds > 0) {
        setState(() {
          _remaining = Duration(seconds: _remaining.inSeconds - 1);
        });
      } else {
        _timer.cancel();
      }
    });
  }

  @override
  void didUpdateWidget(_PremiumCountdownPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.timeUntilNext != widget.timeUntilNext) {
      _remaining = widget.timeUntilNext;
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hours = _remaining.inHours;
    final minutes = _remaining.inMinutes.remainder(60);
    final seconds = _remaining.inSeconds.remainder(60);

    final numberSize = widget.isCompact ? 18.0 : 22.0;
    final labelSize = widget.isCompact ? 7.0 : 8.0;
    final containerPadding = widget.isCompact
        ? const EdgeInsets.symmetric(horizontal: 8, vertical: 10)
        : const EdgeInsets.symmetric(horizontal: 10, vertical: 12);

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          width: double.infinity,
          padding: containerPadding,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: AppTheme.goldPrimary.withValues(alpha: 0.22),
              width: 0.7,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              children: [
                _CountdownUnit(
                  value: hours,
                  label: 'ساعات',
                  numberSize: numberSize,
                  labelSize: labelSize,
                  numerals: widget.numerals,
                ),
                const _CountdownSeparator(),
                _CountdownUnit(
                  value: minutes,
                  label: 'دقائق',
                  numberSize: numberSize,
                  labelSize: labelSize,
                  numerals: widget.numerals,
                ),
                const _CountdownSeparator(),
                _CountdownUnit(
                  value: seconds,
                  label: 'ثوانٍ',
                  numberSize: numberSize,
                  labelSize: labelSize,
                  numerals: widget.numerals,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Countdown Unit ──

class _CountdownUnit extends StatelessWidget {
  final int value;
  final String label;
  final double numberSize;
  final double labelSize;
  final NumeralSystem numerals;

  const _CountdownUnit({
    required this.value,
    required this.label,
    required this.numberSize,
    required this.labelSize,
    required this.numerals,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, -0.4),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOut,
                    ),
                  ),
                  child: child,
                ),
              );
            },
            child: Text(
              TimeFormatter.convertDigits(
                value.toString().padLeft(2, '0'),
                numerals,
              ),
              key: ValueKey<int>(value),
              style: GoogleFonts.spaceMono(
                fontSize: numberSize,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                height: 1,
              ),
            ),
          ),
          SizedBox(height: labelSize * 0.4),
          Text(
            label,
            style: GoogleFonts.notoKufiArabic(
              fontSize: labelSize,
              fontWeight: FontWeight.w600,
              color: AppTheme.goldPrimary.withValues(alpha: 0.70),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Countdown Separator ──

class _CountdownSeparator extends StatelessWidget {
  const _CountdownSeparator();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        ':',
        style: GoogleFonts.spaceMono(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppTheme.goldPrimary.withValues(alpha: 0.45),
          height: 1,
        ),
      ),
    );
  }
}

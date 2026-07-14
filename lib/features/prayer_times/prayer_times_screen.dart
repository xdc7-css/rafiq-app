import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/arabic_strings.dart';
import '../../../../models/prayer_times.dart';
import '../../../../providers/prayer_time_providers.dart';
import '../../../../theme/app_theme.dart';
import 'widgets/permission_dialog.dart';
import 'widgets/premium_background.dart';
import 'widgets/premium_hero_section.dart';
import 'widgets/premium_timeline.dart';
import 'prayer_period.dart';

class PrayerTimesScreen extends ConsumerStatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  ConsumerState<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends ConsumerState<PrayerTimesScreen>
    with TickerProviderStateMixin {
  late AnimationController _timelineController;

  @override
  void initState() {
    super.initState();
    _timelineController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(prayerTimesProvider.notifier).load();
        _timelineController.forward();
      }
    });
  }

  @override
  void dispose() {
    _timelineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(prayerTimesProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: _buildPremiumAppBar(state, theme, isDark),
      body: _buildBody(state, theme, isDark),
    );
  }

  PreferredSizeWidget _buildPremiumAppBar(
    PrayerTimesState state,
    ThemeData theme,
    bool isDark,
  ) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      leadingWidth: 56,
      leading: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: _GlassIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onTap: () => Navigator.of(context).pop(),
          isDark: isDark,
        ),
      ),
      title: Text(
        Ar.prayerTimesAppBar,
        style: GoogleFonts.notoKufiArabic(
           fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppTheme.textPrimary,
          letterSpacing: -0.3,
        ),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: _GlassIconButton(
            icon: Icons.refresh_rounded,
            onTap: () => ref.read(prayerTimesProvider.notifier).refresh(),
            isDark: isDark,
          ),
        ),
      ],
    );
  }

  Widget _buildBody(PrayerTimesState state, ThemeData theme, bool isDark) {
    switch (state.status) {
      case PrayerTimesStatus.initial:
      case PrayerTimesStatus.loadingFresh:
        return _buildLoadingState(isDark);
      case PrayerTimesStatus.locationDisabled:
        return _buildGpsDisabled(isDark);
      case PrayerTimesStatus.locationDenied:
        return _buildPermissionDenied(isDark);
      case PrayerTimesStatus.error:
        return _buildError(state, isDark);
      case PrayerTimesStatus.loaded:
        return _buildPremiumContent(state, isDark);
    }
  }

  Widget _buildLoadingState(bool isDark) {
    return Stack(
      children: [
        const PremiumBackground(),
        const Center(child: PremiumLoadingIndicator()),
      ],
    );
  }

  Widget _buildGpsDisabled(bool isDark) {
    return Stack(
      children: [
        const PremiumBackground(),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _GlassCard(
                  isDark: isDark,
                  padding: const EdgeInsets.all(48),
                  borderRadius: 36,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.goldPrimary.withValues(alpha: 0.15),
                              AppTheme.goldSoft.withValues(alpha: 0.05),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppTheme.borderGold.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          Icons.location_off_rounded,
                          size: 50,
                          color: AppTheme.goldPrimary.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        Ar.gpsDisabledTitle,
                        style: GoogleFonts.notoKufiArabic(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textPrimary,
                          height: 1.3,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        Ar.gpsDisabledMsg,
                        style: GoogleFonts.tajawal(
                          fontSize: 16,
                          color: AppTheme.textMuted,
                          height: 1.6,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      _PremiumButton(
                        text: Ar.openLocationSettings,
                        icon: Icons.settings_rounded,
                        onPressed: () =>
                            PermissionDialog.showGpsDisabled(context),
                        isDark: isDark,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPermissionDenied(bool isDark) {
    return Stack(
      children: [
        const PremiumBackground(),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _GlassCard(
                  isDark: isDark,
                  padding: const EdgeInsets.all(48),
                  borderRadius: 36,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.goldPrimary.withValues(alpha: 0.15),
                              AppTheme.goldSoft.withValues(alpha: 0.05),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppTheme.borderGold.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          Icons.shield_rounded,
                          size: 50,
                          color: AppTheme.goldPrimary.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        Ar.permissionDeniedTitle,
                        style: GoogleFonts.notoKufiArabic(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textPrimary,
                          height: 1.3,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        Ar.permissionDeniedMsg,
                        style: GoogleFonts.tajawal(
                          fontSize: 16,
                          color: AppTheme.textMuted,
                          height: 1.6,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      _PremiumButton(
                        text: Ar.openAppSettings,
                        icon: Icons.settings_rounded,
                        onPressed: () =>
                            PermissionDialog.showPermissionDenied(context),
                        isDark: isDark,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildError(PrayerTimesState state, bool isDark) {
    return Stack(
      children: [
        const PremiumBackground(),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _GlassCard(
                  isDark: isDark,
                  padding: const EdgeInsets.all(48),
                  borderRadius: 36,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.goldPrimary.withValues(alpha: 0.15),
                              AppTheme.goldSoft.withValues(alpha: 0.05),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppTheme.borderGold.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          Icons.cloud_off_rounded,
                          size: 50,
                          color: AppTheme.goldPrimary.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        Ar.noConnection,
                        style: GoogleFonts.notoKufiArabic(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textPrimary,
                          height: 1.3,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        state.errorMessage ?? '',
                        style: GoogleFonts.tajawal(
                          fontSize: 16,
                          color: AppTheme.textMuted,
                          height: 1.6,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      _PremiumButton(
                        text: Ar.retry,
                        icon: Icons.refresh_rounded,
                        onPressed: () =>
                            ref.read(prayerTimesProvider.notifier).refresh(),
                        isDark: isDark,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPremiumContent(PrayerTimesState state, bool isDark) {
    final times = state.prayerTimes!;

    return Stack(
      children: [
        const PremiumBackground(),
        SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: PremiumHeroSection(
                  state: state,
                  times: times,
                  isDark: isDark,
                ),
              ),
              SliverToBoxAdapter(
                child:
                    _buildPremiumDateSection(
                          times: state.prayerTimes!,
                          isDark: isDark,
                        )
                        .animate()
                        .fadeIn(duration: 300.ms, delay: 300.ms)
                        .slideY(begin: 0.1, end: 0),
              ),
              SliverToBoxAdapter(
                child:
                    PremiumPrayerTimeline(
                          state: state,
                          times: state.prayerTimes!,
                          timelineController: _timelineController,
                          isDark: isDark,
                          prayerPeriod: _getPrayerPeriod(
                            times,
                            state.currentPrayer,
                          ),
                        )
                        .animate()
                        .fadeIn(duration: 800.ms, delay: 500.ms)
                        .slideY(begin: 0.15, end: 0),
              ),
              SliverToBoxAdapter(
                child:
                    _buildPremiumInfoSection(
                          times: state.prayerTimes!,
                          state: state,
                          isDark: isDark,
                        )
                        .animate()
                        .fadeIn(duration: 600.ms, delay: 700.ms)
                        .slideY(begin: 0.1, end: 0),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ],
    );
  }

  PrayerPeriod _getPrayerPeriod(PrayerTimes times, String? currentPrayer) {
    final now = DateTime.now();
    if (currentPrayer == null) return PrayerPeriod.none;

    switch (currentPrayer) {
      case 'Fajr':
        return PrayerPeriod.fajr;
      case 'Sunrise':
        return PrayerPeriod.sunrise;
      case 'Dhuhr':
        return PrayerPeriod.dhuhr;
      case 'Asr':
        return PrayerPeriod.asr;
      case 'Maghrib':
        return PrayerPeriod.maghrib;
      case 'Isha':
        return PrayerPeriod.isha;
      default:
        final fajr = times.timings['Fajr'];
        final sunrise = times.timings['Sunrise'];
        final dhuhr = times.timings['Dhuhr'];
        final asr = times.timings['Asr'];
        final maghrib = times.timings['Maghrib'];
        final isha = times.timings['Isha'];

        if (fajr != null && now.isBefore(fajr)) return PrayerPeriod.preFajr;
        if (fajr != null &&
            sunrise != null &&
            now.isAfter(fajr) &&
            now.isBefore(sunrise)) {
          return PrayerPeriod.fajr;
        }
        if (sunrise != null &&
            dhuhr != null &&
            now.isAfter(sunrise) &&
            now.isBefore(dhuhr)) {
          return PrayerPeriod.sunrise;
        }
        if (dhuhr != null &&
            asr != null &&
            now.isAfter(dhuhr) &&
            now.isBefore(asr)) {
          return PrayerPeriod.dhuhr;
        }
        if (asr != null &&
            maghrib != null &&
            now.isAfter(asr) &&
            now.isBefore(maghrib)) {
          return PrayerPeriod.asr;
        }
        if (maghrib != null &&
            isha != null &&
            now.isAfter(maghrib) &&
            now.isBefore(isha)) {
          return PrayerPeriod.maghrib;
        }
        return PrayerPeriod.isha;
    }
  }

  // ─── Premium Date Section ───
  Widget _buildPremiumDateSection({
    required PrayerTimes times,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: _GlassCard(
        isDark: isDark,
        padding: const EdgeInsets.all(20),
        borderRadius: 28,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'التاريخ الهجري',
                    style: GoogleFonts.notoKufiArabic(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textMuted,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    times.hijriDate,
                    style: GoogleFonts.notoKufiArabic(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  if (times.hijriMonth.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      '${times.hijriMonth} ${times.hijriYear}',
                      style: GoogleFonts.notoKufiArabic(
                        fontSize: 12,
                        color: AppTheme.textMuted,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'التاريخ الميلادي',
                    style: GoogleFonts.notoKufiArabic(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textMuted,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    times.gregorianDate,
                    style: GoogleFonts.notoKufiArabic(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  if (times.gregorianWeekday.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      times.gregorianWeekday,
                      style: GoogleFonts.notoKufiArabic(
                        fontSize: 12,
                        color: AppTheme.textMuted,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Premium Info Section ───
  Widget _buildPremiumInfoSection({
    required PrayerTimes times,
    required PrayerTimesState state,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: _GlassCard(
        isDark: isDark,
        padding: const EdgeInsets.all(20),
        borderRadius: 28,
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
                  'معلومات إضافية',
                  style: GoogleFonts.notoKufiArabic(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _InfoRow(
              label: 'المدينة',
              value: state.cityName.isNotEmpty ? state.cityName : '—',
              icon: Icons.location_on_rounded,
              isDark: isDark,
            ),
            const SizedBox(height: 16),
            _InfoRow(
              label: 'المذهب',
              value: 'الإمامية الإثنا عشرية',
              icon: Icons.gite_rounded,
              isDark: isDark,
            ),
            const SizedBox(height: 16),
            _InfoRow(
              label: 'طريقة الحساب',
              value: 'المعتمدة لدى مراجع الشيعة',
              icon: Icons.calculate_rounded,
              isDark: isDark,
            ),
            const SizedBox(height: 16),
            _InfoRow(
              label: 'التقويم',
              value: 'الهجري المعتمد',
              icon: Icons.calendar_today_rounded,
              isDark: isDark,
            ),
            const SizedBox(height: 16),
            _InfoRow(
              label: 'التوقيت المحلي',
              value: times.timezone,
              icon: Icons.access_time_rounded,
              isDark: isDark,
            ),
            const SizedBox(height: 16),
            _InfoRow(
              label: 'آخر تحديث',
              value: 'الآن',
              icon: Icons.update_rounded,
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Reusable Widget Classes ───

class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isDark;

  const _GlassIconButton({
    required this.icon,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              (isDark ? AppTheme.goldPrimary : AppTheme.goldPrimary).withValues(
                alpha: 0.1,
              ),
              (isDark ? AppTheme.goldSoft : AppTheme.goldSoft).withValues(
                alpha: 0.03,
              ),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          border: Border.all(
            color: AppTheme.borderGold.withValues(alpha: 0.3),
            width: 0.5,
          ),
        ),
        child: Icon(icon, color: AppTheme.goldPrimary, size: 20),
      ),
    );
  }
}

/// Premium glass card
class _GlassCard extends StatelessWidget {
  final Widget child;
  final bool isDark;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final List<BoxShadow>? boxShadow;

  const _GlassCard({
    required this.child,
    required this.isDark,
    this.padding = const EdgeInsets.all(20),
    this.borderRadius = 28,
  }) : boxShadow = null;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          colors: [
            AppTheme.bgCard.withValues(
              alpha: 0.85,
            ),
            AppTheme.bgSurface.withValues(
              alpha: 0.6,
            ),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: AppTheme.borderGold.withValues(alpha: 0.2),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowDark.withValues(alpha: 0.3),
            blurRadius: 24,
            offset: const Offset(0, 8),
            spreadRadius: -4,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: child,
        ),
      ),
    );
  }
}

/// Premium button
class _PremiumButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isDark;

  const _PremiumButton({
    required this.text,
    required this.icon,
    required this.onPressed,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppTheme.goldPrimary, AppTheme.goldSoft],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: AppTheme.goldPrimary.withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 6),
              spreadRadius: -2,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppTheme.bgPrimary, size: 20),
            const SizedBox(width: 10),
            Text(
              text,
              style: GoogleFonts.cairo(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppTheme.bgPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool isDark;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.goldPrimary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 16, color: AppTheme.goldPrimary),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: GoogleFonts.notoKufiArabic(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppTheme.textMuted,
          ),
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
    );
  }
}

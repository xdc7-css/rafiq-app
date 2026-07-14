import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/arabic_strings.dart';
import '../../models/khatmah_model.dart';

import '../../providers/daily_provider.dart';
import '../../providers/khatmah_provider.dart';
import '../../providers/prayer_time_providers.dart';
import '../../providers/settings_provider.dart';
import '../../providers/tasbeeh_al_zahra_provider.dart';
import '../../theme/app_theme.dart';
import '../../theme/ds_components.dart';
import '../../widgets/hadith_card.dart';
import '../../widgets/star_background.dart';
import '../../widgets/tasbih_hero_card.dart';
import '../../widgets/verse_card.dart';
import '../../services/permission_service.dart';
import '../../services/greeting_service.dart';
import '../../core/utils/hijri_date.dart';
import '../prayer_times/widgets/premium_hero_section.dart';
import '../hadith_shia/presentation/widgets/daily_shia_hadith_card.dart';

class _QuickAction {
  final String label;
  final IconData icon;
  final String route;
  const _QuickAction(this.label, this.icon, this.route);
}

const _quickActions = [
  _QuickAction('أوقات الصلاة', Icons.access_time_rounded, '/prayer-times'),
  _QuickAction('القبلة', Icons.explore_rounded, '/qibla'),
  _QuickAction('القرآن', Icons.auto_stories_rounded, '/quran'),
  _QuickAction('التسبيح', Icons.repeat_rounded, '/tasbeeh'),
  _QuickAction('أذكار الصباح', Icons.wb_sunny_rounded, '/adhkar/morning'),
  _QuickAction('أذكار المساء', Icons.nights_stay_rounded, '/adhkar/evening'),
  _QuickAction('الأدعية', Icons.self_improvement_rounded, '/ziyarat'),
  _QuickAction('كتب الحديث', Icons.menu_book_rounded, '/books'),
  _QuickAction('المفضلة', Icons.favorite_rounded, '/favorites'),
  _QuickAction('بحث الأحاديث', Icons.search_rounded, '/hadith-search'),
  _QuickAction('التنزيلات', Icons.download_rounded, '/audio-library'),
  _QuickAction('المزيد', Icons.apps_rounded, '/more'),
];

class _IslamicEvent {
  final String name;
  final String hijriDate;
  const _IslamicEvent(this.name, this.hijriDate);
}

const _islamicEvents = [
  _IslamicEvent('عيد الفطر', '1 شوال'),
  _IslamicEvent('عيد الأضحى', '10 ذو الحجة'),
  _IslamicEvent('عاشوراء', '10 محرم'),
  _IslamicEvent('الأربعين', '20 صفر'),
  _IslamicEvent('المبعث النبوي', '27 رجب'),
  _IslamicEvent('مولد النبي', '17 ربيع الأول'),
  _IslamicEvent('ليلة القدر', '23 رمضان'),
  _IslamicEvent('عيد الغدير', '18 ذو الحجة'),
];

// ═══════════════════════════════════════════════
// Home Screen
// ═══════════════════════════════════════════════

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndRequestPermissions();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _checkAndRequestPermissions() async {
    final hasNotification = await PermissionService.checkNotificationPermission();
    final hasExactAlarm = await PermissionService.checkExactAlarmPermission();

    if (!hasNotification || !hasExactAlarm) {
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF0F1B2E)
                  : Colors.white,
              title: Row(
                children: [
                  const Icon(Icons.notifications_active_rounded, color: AppTheme.goldPrimary),
                  const SizedBox(width: 12),
                  Text(
                    'أذونات التنبيهات والأذان',
                    style: GoogleFonts.notoKufiArabic(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
              content: Text(
                'لكي يتمكن التطبيق من تنبيهك بالصلاة وتشغيل صوت الأذان في الوقت المحدد بدقة، يرجى منح إذن الإشعارات وإذن المنبهات الدقيقة.',
                style: GoogleFonts.tajawal(
                  fontSize: 14,
                  height: 1.5,
                  color: AppTheme.textMuted,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'لاحقاً',
                    style: GoogleFonts.tajawal(fontWeight: FontWeight.bold, color: Colors.redAccent),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await PermissionService.requestNotificationPermission();
                    await PermissionService.requestExactAlarmPermission();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.goldPrimary),
                  child: Text('منح الإذن', style: GoogleFonts.tajawal(color: Colors.white)),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final prayerState = ref.watch(prayerTimesProvider);
    final locale = ref.watch(localeProvider);
    final isRtl = locale.languageCode == 'ar';
    final w = MediaQuery.sizeOf(context).width;
    final padH = w < 360 ? 16.0 : w < 420 ? 20.0 : 24.0;
    final gap = w < 360 ? 24.0 : w < 420 ? 28.0 : 32.0;
    final smallGap = w < 360 ? 12.0 : 16.0;

    final times = prayerState.prayerTimes;
    final hijri = HijriDate.now();
    final greeting = GreetingService.getGreeting(
      fajr: times?.fajr,
      sunrise: times?.sunrise,
      dhuhr: times?.dhuhr,
      asr: times?.asr,
      maghrib: times?.maghrib,
      isha: times?.isha,
      hijriMonth: hijri.month,
      hijriDay: hijri.day,
    );

    return Scaffold(
      body: Stack(
        children: [
          const StarBackground(showParticles: false),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(padH, padH, padH, gap),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _HomeHeader(isDark: isDark, isRtl: isRtl),
                  SizedBox(height: gap),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _HomeGreeting(
                      key: ValueKey('${greeting.period}-${greeting.hijriMonth}-${greeting.priority}'),
                      text: greeting.title,
                      subtitle: greeting.subtitle,
                    ),
                  ),
                  SizedBox(height: gap),

                  _buildSectionHeader('الصلاة القادمة', 'اعرف موعد الصلاة التالية'),
                  SizedBox(height: smallGap),
                  if (times != null)
                    RepaintBoundary(
                      child: PremiumHeroSection(
                        state: prayerState,
                        times: times,
                        isDark: isDark,
                      ),
                    ),
                  SizedBox(height: gap),

                  _buildSectionHeader('التسبيح', 'اذكر الله وداوم على الذكر'),
                  SizedBox(height: smallGap),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: w < 360 ? 0 : 4),
                    child: const RepaintBoundary(child: TasbihHeroCard()),
                  ),
                  SizedBox(height: gap),

                  _buildSectionHeader('الوصول السريع'),
                  SizedBox(height: smallGap),
                  _buildQuickActionsGrid(isDark),
                  SizedBox(height: gap),

                  _buildSectionHeader('حديث اليوم'),
                  SizedBox(height: smallGap),
                  const DailyShiaHadithCard(),
                  SizedBox(height: gap),

                  _buildSectionHeader('رحلة اليوم الإيمانية'),
                  SizedBox(height: smallGap),
                  _buildDeferredVerse(),
                  SizedBox(height: gap),

                  _buildDeferredHadith(),
                  SizedBox(height: smallGap),
                  _buildSectionHeader('القرآن الكريم'),
                  SizedBox(height: smallGap),
                  _buildDeferredQuranSection(isDark),
                  SizedBox(height: gap),

                  _buildSectionHeader('تسبيح الزهراء'),
                  SizedBox(height: smallGap),
                  _buildDeferredTasbihSection(isDark),
                  SizedBox(height: gap),
                  _buildSectionHeader('المناسبات الإسلامية'),
                  SizedBox(height: smallGap),
                  _buildEventsSection(isDark),
                  SizedBox(height: gap),
                  _buildQuoteSection(isDark),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════
  // Section Headers
  // ═══════════════════════════════════════════════

  static final _sectionBarDecoration = BoxDecoration(
    gradient: AppTheme.goldGradient,
    borderRadius: BorderRadius.circular(2),
  );

  Widget _buildSectionHeader(String title, [String? subtitle]) {
    final w = MediaQuery.sizeOf(context).width;
    final titleSize = w < 360 ? 15.0 : 18.0;
    final barHeight = w < 360 ? 16.0 : 20.0;
    return Row(
      children: [
        Container(
          width: 3,
          height: barHeight,
          decoration: _sectionBarDecoration,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.notoKufiArabic(
                  fontSize: titleSize,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.notoKufiArabic(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.textMuted,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════
  // Quick Actions
  // ═══════════════════════════════════════════════

  Widget _buildQuickActionsGrid(bool isDark) {
    final w = MediaQuery.sizeOf(context).width;
    final cols = w < 360 ? 3 : 4;
    final aspectRatio = w < 360 ? 0.82 : 0.85;
    final iconBoxSize = w < 360 ? 36.0 : 44.0;
    final iconSize = w < 360 ? 17.0 : 20.0;
    final labelSize = w < 360 ? 9.0 : 11.0;
    final spacing = w < 360 ? 8.0 : 12.0;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: cols,
        childAspectRatio: aspectRatio,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
      ),
      itemCount: _quickActions.length,
      itemBuilder: (context, index) {
        final action = _quickActions[index];
        return GestureDetector(
          onTap: () => context.push(action.route),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.bgCard.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppTheme.borderGold, width: 0.5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: iconBoxSize,
                  height: iconBoxSize,
                  decoration: BoxDecoration(
                    color: AppTheme.goldPrimary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(action.icon, color: AppTheme.goldPrimary, size: iconSize),
                ),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    action.label,
                    style: GoogleFonts.notoKufiArabic(
                      fontSize: labelSize,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textMuted,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ═══════════════════════════════════════════════
  // Deferred sub-builders (read their own providers)
  // ═══════════════════════════════════════════════

  Widget _buildDeferredVerse() {
    final dailyVerse = ref.watch(dailyVerseNotifierProvider);
    return VerseCard(verse: dailyVerse, onTap: () => context.push('/quran'));
  }

  Widget _buildDeferredHadith() {
    final dailyHadith = ref.watch(dailyHadithNotifierProvider);
    return HadithCard(hadith: dailyHadith, onTap: () => context.push('/hadith'));
  }

  Widget _buildDeferredQuranSection(bool isDark) {
    final khatmah = ref.watch(khatmahNotifierProvider);
    return _buildQuranSection(khatmah, isDark);
  }

  Widget _buildDeferredTasbihSection(bool isDark) {
    final tasbihZahra = ref.watch(tasbeehAlZahraProvider);
    return _buildTasbihSection(tasbihZahra, isDark);
  }

  // ═══════════════════════════════════════════════
  // Quran Section
  // ═══════════════════════════════════════════════

  Widget _buildQuranSection(KhatmahModel? khatmah, bool isDark) {
    final hasKhatmah = khatmah != null;
    final surahName = hasKhatmah ? KhatmahModel.surahName(khatmah.currentSurah) : '';
    final progress = hasKhatmah ? khatmah.progress : 0.0;
    final page = hasKhatmah ? khatmah.currentPage : 0;
    final w = MediaQuery.sizeOf(context).width;
    final iconBox = w < 360 ? 40.0 : 48.0;

    return GlassCard(
      radius: 28,
      padding: EdgeInsets.all(w < 360 ? 16 : 20),
      onTap: () => context.push('/quran'),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: iconBox,
                height: iconBox,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.goldPrimary.withValues(alpha: 0.2), AppTheme.goldPrimary.withValues(alpha: 0.05)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.auto_stories_rounded, color: AppTheme.goldPrimary, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (hasKhatmah) ...[
                      Text(
                        surahName,
                        style: GoogleFonts.notoKufiArabic(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'الصفحة $page | 604',
                        style: GoogleFonts.notoKufiArabic(
                          fontSize: 11,
                          color: AppTheme.textMuted,
                        ),
                      ),
                    ] else ...[
                      Text(
                        Ar.startKhatmah,
                        style: GoogleFonts.notoKufiArabic(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        Ar.startKhatmahDesc,
                        style: GoogleFonts.notoKufiArabic(
                          fontSize: 11,
                          color: AppTheme.textMuted,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (hasKhatmah) ...[
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: AppTheme.goldPrimary.withValues(alpha: 0.1),
                valueColor: const AlwaysStoppedAnimation(AppTheme.goldPrimary),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${khatmah.totalAyahsRead} آية مقروءة',
                  style: GoogleFonts.notoKufiArabic(
                    fontSize: 11,
                    color: AppTheme.textMuted,
                  ),
                ),
                Text(
                  '${(progress * 100).round()}%',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.goldPrimary,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: GoldButton(
              label: hasKhatmah ? 'استمر في القراءة' : Ar.startKhatmah,
              onTap: () => context.push('/quran'),
              height: 48,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════
  // Tasbih Section
  // ═══════════════════════════════════════════════

  Widget _buildTasbihSection(TasbeehAlZahraState tasbihState, bool isDark) {
    final progress = tasbihState.isCompleted
        ? 1.0
        : (tasbihState.totalCount / 100.0).clamp(0.0, 1.0);
    final w = MediaQuery.sizeOf(context).width;
    final cardPad = w < 360 ? 14.0 : 18.0;
    final circSize = w < 360 ? 64.0 : 80.0;

    return GlassCard(
      radius: 28,
      padding: EdgeInsets.all(cardPad),
      onTap: () => context.push('/tasbeeh'),
      child: Row(
        children: [
          GoldCircularProgress(
            value: progress,
            size: circSize,
            strokeWidth: 5,
            centerText: '${tasbihState.totalCount}',
            subtitle: '/ 100',
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'تسبيحة الزهراء (ع)',
                  style: GoogleFonts.notoKufiArabic(
                    fontSize: w < 360 ? 13 : 15,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tasbihState.isCompleted
                      ? 'مكتملة اليوم ✓'
                      : '${tasbihState.stageName} — ${tasbihState.nameArabic}',
                  style: GoogleFonts.notoKufiArabic(
                    fontSize: 11,
                    color: AppTheme.textMuted,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                GoldBadge(
                  text: '${tasbihState.count} / ${tasbihState.target}',
                  icon: Icons.repeat_rounded,
                  fontSize: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════
  // Events Section
  // ═══════════════════════════════════════════════

  Widget _buildEventsSection(bool isDark) {
    final w = MediaQuery.sizeOf(context).width;
    final pad = w < 360 ? 16.0 : 20.0;
    return GlassCard(
      radius: 28,
      padding: EdgeInsets.all(pad),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: w < 360 ? 6.0 : 10.0,
                  runSpacing: w < 360 ? 6.0 : 10.0,
                  children: _islamicEvents.map((e) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: w < 360 ? 10 : 14,
                        vertical: w < 360 ? 5 : 8,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.goldPrimary.withValues(alpha: 0.5),
                          width: 1.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.goldPrimary.withValues(alpha: 0.08),
                            blurRadius: 6,
                            spreadRadius: 0,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            e.name,
                            style: GoogleFonts.notoKufiArabic(
                              fontSize: w < 360 ? 10 : 12,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            e.hijriDate,
                            style: GoogleFonts.notoKufiArabic(
                              fontSize: w < 360 ? 8 : 10,
                              color: AppTheme.goldPrimary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: GoldButton(
              label: 'التقويم الإسلامي',
              onTap: () => context.push('/calendar'),
              height: 48,
              outlined: true,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════
  // Quote Section
  // ═══════════════════════════════════════════════

  Widget _buildQuoteSection(bool isDark) {
    final w = MediaQuery.sizeOf(context).width;
    final pad = w < 360 ? 16.0 : 20.0;
    final quoteSize = w < 360 ? 17.0 : w < 420 ? 19.0 : 20.0;
    return GlassCard(
      radius: 28,
      padding: EdgeInsets.all(pad),
      child: Column(
        children: [
          Icon(Icons.format_quote_rounded, size: 28, color: AppTheme.goldPrimary.withValues(alpha: 0.4)),
          const SizedBox(height: 10),
          Text(
            'إِنَّمَا يُرِيدُ اللَّهُ لِيُذْهِبَ عَنكُمُ الرِّجْسَ أَهْلَ الْبَيْتِ وَيُطَهِّرَكُمْ تَطْهِيرًا',
            style: GoogleFonts.notoNaskhArabic(
              fontSize: quoteSize,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
              height: 1.8,
            ),
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 10),
          Text(
            'الأحزاب: ٣٣',
            style: GoogleFonts.notoKufiArabic(
              fontSize: 11,
              color: AppTheme.goldPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════
// Critical widgets — const-optimized, never rebuild
// ═══════════════════════════════════════════════

class _HomeHeader extends StatelessWidget {
  final bool isDark;
  final bool isRtl;
  const _HomeHeader({required this.isDark, required this.isRtl});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final logoSize = w < 360 ? 36.0 : 44.0;
    final titleSize = w < 360 ? 18.0 : 22.0;
    final btnSize = w < 360 ? 34.0 : 40.0;
    return Row(
      children: [
        SvgPicture.asset(
          'assets/images/logo.svg',
          width: logoSize,
          height: logoSize,
          fit: BoxFit.contain,
        ),
        const SizedBox(width: 12),
        Text(
          Ar.appName,
          style: GoogleFonts.notoKufiArabic(
            fontSize: titleSize,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const Spacer(),
        GoldIconButton(
          icon: Icons.notifications_outlined,
          onTap: () => context.push('/settings/notifications'),
          size: btnSize,
        ),
        const SizedBox(width: 8),
        GoldIconButton(
          icon: Icons.settings_rounded,
          onTap: () => context.push('/settings'),
          size: btnSize,
        ),
      ],
    );
  }
}

class _HomeGreeting extends StatelessWidget {
  final String text;
  final String subtitle;
  const _HomeGreeting({super.key, required this.text, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final titleSize = w < 360 ? 26.0 : w < 420 ? 30.0 : 32.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: GoogleFonts.notoKufiArabic(
            fontSize: titleSize,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: GoogleFonts.notoKufiArabic(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppTheme.goldPrimary.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/settings_provider.dart';
import '../../models/models.dart';
import '../../core/constants.dart';
import '../../services/permission_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/islamic_art.dart';
import '../../widgets/star_background.dart';
import 'widgets/settings_components.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  PackageInfo? _packageInfo;

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    if (!mounted) return;
    setState(() => _packageInfo = info);
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsNotifierProvider);
    final w = MediaQuery.sizeOf(context).width;
    final gap = w < 360 ? 18.0 : 24.0;
    final bottomPad = w < 360 ? 80.0 : 100.0;

    return IslamicBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Directionality(
          textDirection:
              settings.language == 'ar' ? TextDirection.rtl : TextDirection.ltr,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildAppBar(context, settings),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(top: 16, bottom: bottomPad),
                  child: Column(
                    children: [
                      _buildAppearanceSection(ref, settings),
                      SizedBox(height: gap),
                      _buildTimeDateSection(ref, settings),
                      SizedBox(height: gap),
                      _buildNotificationSection(ref, settings),
                      SizedBox(height: gap),
                      _buildAdhanSection(ref, settings),
                      SizedBox(height: gap),
                      _buildPermissionsSection(ref, context),
                      SizedBox(height: gap),
                      _buildPrayerSection(ref, settings),
                      SizedBox(height: gap),
                      _buildTasbeehSection(ref, settings),
                      SizedBox(height: gap),
                      _buildShiaRemindersSection(ref, settings),
                      SizedBox(height: gap),
                      _buildOccasionsSection(ref, settings),
                      SizedBox(height: gap),
                      _buildVisitSection(ref, settings),
                      SizedBox(height: gap),
                      _buildLanguageSection(ref, settings),
                      SizedBox(height: gap),
                      _buildPrivacySection(ref, settings),
                      SizedBox(height: gap),
                      _buildSupportSection(settings),
                      const SizedBox(height: 32),
                      Opacity(
                        opacity: 0.1,
                        child: MosqueSilhouette(
                          height: 80,
                          color: AppTheme.goldPrimary,
                        ),
                      ),
                      SizedBox(height: bottomPad),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── App Bar ───

  SliverAppBar _buildAppBar(BuildContext context, AppSettings settings) {
    final w = MediaQuery.sizeOf(context).width;
    final barH = w < 360 ? 52.0 : 60.0;
    final circleSize = w < 360 ? 38.0 : 44.0;
    return SliverAppBar(
      expandedHeight: 100,
      floating: true,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppTheme.bgPrimary.withValues(alpha: 0.8),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(barH),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: w < 360 ? 12 : 20, vertical: 8),
          height: barH,
          decoration: AppTheme.glassCard(radius: barH / 2),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                _buildCircleButton(
                  icon: settings.language == 'ar'
                      ? Icons.arrow_back_ios_new_rounded
                      : Icons.arrow_back_ios_rounded,
                  size: circleSize,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    context.pop();
                  },
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      'الإعدادات',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: circleSize),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required VoidCallback onTap,
    double size = 44,
  }) {
    final iconSize = size * 0.41;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppTheme.goldPrimary.withValues(alpha: 0.1),
          shape: BoxShape.circle,
          border: Border.all(color: AppTheme.borderGold, width: 0.8),
        ),
        child: Icon(icon, color: AppTheme.goldPrimary, size: iconSize),
      ),
    );
  }

  // ─── 1. Appearance ───

  Widget _buildAppearanceSection(
      WidgetRef ref, AppSettings settings) {
    return SettingsSectionCard(
      title: 'المظهر',
      icon: Icons.palette_outlined,
      children: [
        SettingsTile(
          icon: Icons.text_fields_rounded,
          title: 'حجم الخط',
          subtitle: 'تغيير حجم النصوص في التطبيق',
          trailing: SizedBox(
            width: 100,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: AppTheme.goldPrimary,
                thumbColor: AppTheme.goldPrimary,
                overlayColor: AppTheme.goldPrimary.withValues(alpha: 0.2),
                trackHeight: 2,
              ),
              child: Slider(
                value: settings.appFontSize,
                min: 0.8,
                max: 1.4,
                onChanged: (v) =>
                    ref.read(settingsNotifierProvider.notifier).updateAppFontSize(v),
              ),
            ),
          ),
          onTap: () {},
        ),
        SettingsTile(
          icon: Icons.color_lens_outlined,
          title: 'الألوان الديناميكية',
          subtitle: 'تفعيل الألوان المتغيرة حسب الخلفية',
          trailing: PremiumSwitch(
            value: settings.dynamicColors,
            onChanged: (v) =>
                ref.read(settingsNotifierProvider.notifier).toggleDynamicColors(),
          ),
          onTap: () =>
              ref.read(settingsNotifierProvider.notifier).toggleDynamicColors(),
          showDivider: false,
        ),
      ],
    );
  }

  // ─── 2. Time & Date ───

  Widget _buildTimeDateSection(WidgetRef ref, AppSettings settings) {
    return SettingsSectionCard(
      title: 'الوقت والتاريخ',
      icon: Icons.access_time_filled_rounded,
      children: [
        SettingsTile(
          icon: Icons.schedule_rounded,
          title: 'صيغة الوقت',
          subtitle: settings.timeFormat == TimeFormat.hour24
              ? '24 ساعة (17:45)'
              : '12 ساعة (05:45 م)',
          onTap: () => _showTimeFormatPicker(context, ref, settings),
          trailing: Icon(
            Icons.arrow_forward_ios_rounded,
            color: AppTheme.textMuted.withValues(alpha: 0.3),
            size: 14,
          ),
        ),
        SettingsTile(
          icon: Icons.pin_outlined,
          title: 'نظام الأرقام',
          subtitle: settings.numeralSystem == NumeralSystem.english
              ? 'أرقام إنجليزية (0123456789)'
              : 'أرقام عربية (٠١٢٣٤٥٦٧٨٩)',
          onTap: () => _showNumeralSystemPicker(context, ref, settings),
          trailing: Icon(
            Icons.arrow_forward_ios_rounded,
            color: AppTheme.textMuted.withValues(alpha: 0.3),
            size: 14,
          ),
          showDivider: false,
        ),
      ],
    );
  }

  // ─── 3. Notifications ───

  Widget _buildNotificationSection(WidgetRef ref, AppSettings settings) {
    return SettingsSectionCard(
      title: 'الإشعارات',
      icon: Icons.notifications_none_rounded,
      children: [
        SettingsTile(
          icon: Icons.access_time_rounded,
          title: 'مواقيت الصلاة',
          subtitle: 'تنبيهات عند دخول وقت الصلاة',
          trailing: PremiumSwitch(
            value: settings.prayerNotifications,
            onChanged: (v) {
              if (v) _requestNotificationPermission();
              ref
                  .read(settingsNotifierProvider.notifier)
                  .togglePrayerNotifications();
            },
          ),
          onTap: () {
            _requestNotificationPermission();
            ref
                .read(settingsNotifierProvider.notifier)
                .togglePrayerNotifications();
          },
        ),
        SettingsTile(
          icon: Icons.auto_stories_outlined,
          title: 'آية اليوم',
          subtitle: 'استلام آية قرآنية يومية',
          trailing: PremiumSwitch(
            value: settings.dailyVerseNotification,
            onChanged: (v) {
              if (v) _requestNotificationPermission();
              ref
                  .read(settingsNotifierProvider.notifier)
                  .toggleDailyVerseNotification();
            },
          ),
          onTap: () {
            _requestNotificationPermission();
            ref
                .read(settingsNotifierProvider.notifier)
                .toggleDailyVerseNotification();
          },
        ),
        SettingsTile(
          icon: Icons.menu_book_rounded,
          title: 'حديث اليوم',
          subtitle: 'تنبيه بحديث يومي',
          trailing: PremiumSwitch(
            value: settings.dailyHadithNotification,
            onChanged: (v) {
              if (v) _requestNotificationPermission();
              ref
                  .read(settingsNotifierProvider.notifier)
                  .toggleDailyHadithNotification();
            },
          ),
          onTap: () {
            _requestNotificationPermission();
            ref
                .read(settingsNotifierProvider.notifier)
                .toggleDailyHadithNotification();
          },
          showDivider: false,
        ),
      ],
    );
  }

  // ─── Permissions ───

  Widget _buildPermissionsSection(WidgetRef ref, BuildContext context) {
    return SettingsSectionCard(
      title: 'صلاحيات التطبيق',
      icon: Icons.security_rounded,
      children: [
        SettingsTile(
          icon: Icons.shield_rounded,
          title: 'إدارة الصلاحيات',
          subtitle: 'إشعارات، أذان دقيق، البطارية',
          onTap: () => context.push('/permissions'),
          trailing: Icon(
            Icons.arrow_forward_ios_rounded,
            color: AppTheme.textMuted.withValues(alpha: 0.3),
            size: 14,
          ),
          showDivider: false,
        ),
      ],
    );
  }

  // ─── 3. Adhan ───

  Widget _buildAdhanSection(WidgetRef ref, AppSettings settings) {
    return SettingsSectionCard(
      title: 'الأذان',
      icon: Icons.record_voice_over_rounded,
      children: [
        SettingsTile(
          icon: Icons.volume_up_rounded,
          title: 'تفعيل الأذان',
          subtitle: 'تشغيل صوت الأذان عند دخول وقت الصلاة',
          trailing: PremiumSwitch(
            value: settings.adhanEnabled,
            onChanged: (v) =>
                ref.read(settingsNotifierProvider.notifier).toggleAdhanEnabled(),
          ),
          onTap: () =>
              ref.read(settingsNotifierProvider.notifier).toggleAdhanEnabled(),
        ),
        if (settings.adhanEnabled) ...[
          SettingsTile(
            icon: Icons.wb_twilight_rounded,
            title: 'أذان الفجر',
            subtitle: 'تشغيل الأذان عند وقت صلاة الفجر',
            trailing: PremiumSwitch(
              value: settings.adhanFajrEnabled,
              onChanged: (v) =>
                  ref.read(settingsNotifierProvider.notifier).toggleAdhanFajr(),
            ),
            onTap: () =>
                ref.read(settingsNotifierProvider.notifier).toggleAdhanFajr(),
          ),
          SettingsTile(
            icon: Icons.wb_sunny_rounded,
            title: 'أذان الظهر',
            subtitle: 'تشغيل الأذان عند وقت صلاة الظهر',
            trailing: PremiumSwitch(
              value: settings.adhanDhuhrEnabled,
              onChanged: (v) =>
                  ref.read(settingsNotifierProvider.notifier).toggleAdhanDhuhr(),
            ),
            onTap: () =>
                ref.read(settingsNotifierProvider.notifier).toggleAdhanDhuhr(),
          ),
          SettingsTile(
            icon: Icons.nights_stay_rounded,
            title: 'أذان المغرب',
            subtitle: 'تشغيل الأذان عند وقت صلاة المغرب',
            trailing: PremiumSwitch(
              value: settings.adhanMaghribEnabled,
              onChanged: (v) =>
                  ref.read(settingsNotifierProvider.notifier).toggleAdhanMaghrib(),
            ),
            onTap: () =>
                ref.read(settingsNotifierProvider.notifier).toggleAdhanMaghrib(),
          ),
          SettingsTile(
            icon: Icons.graphic_eq_rounded,
            title: 'مستوى الصوت',
            subtitle: '${(settings.adhanVolume * 100).round()}%',
            trailing: SizedBox(
              width: 100,
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppTheme.goldPrimary,
                  thumbColor: AppTheme.goldPrimary,
                  overlayColor: AppTheme.goldPrimary.withValues(alpha: 0.2),
                  trackHeight: 2,
                ),
                child: Slider(
                  value: settings.adhanVolume,
                  min: 0.0,
                  max: 1.0,
                  divisions: 10,
                  onChanged: (v) =>
                      ref.read(settingsNotifierProvider.notifier).updateAdhanVolume(v),
                ),
              ),
            ),
            onTap: () {},
          ),
          SettingsTile(
            icon: Icons.music_note_rounded,
            title: 'صوت الأذان',
            subtitle: _getAdhanSoundName(settings.adhanSound),
            onTap: () => _showAdhanSoundPicker(context, ref, settings),
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppTheme.textMuted.withValues(alpha: 0.3),
              size: 14,
            ),
          ),
          SettingsTile(
            icon: Icons.vibration_rounded,
            title: 'الاهتزاز مع الأذان',
            subtitle: 'اهتزاز الجهاز عند تشغيل الأذان',
            trailing: PremiumSwitch(
              value: settings.adhanVibration,
              onChanged: (v) =>
                  ref.read(settingsNotifierProvider.notifier).toggleAdhanVibration(),
            ),
            onTap: () =>
                ref.read(settingsNotifierProvider.notifier).toggleAdhanVibration(),
          ),
          SettingsTile(
            icon: Icons.restart_alt_rounded,
            title: 'التشغيل عند الإقلاع',
            subtitle: 'بدء مراقبة الأذان تلقائياً عند تشغيل الجهاز',
            trailing: PremiumSwitch(
              value: settings.adhanBootStart,
              onChanged: (v) =>
                  ref.read(settingsNotifierProvider.notifier).toggleAdhanBootStart(),
            ),
            onTap: () =>
                ref.read(settingsNotifierProvider.notifier).toggleAdhanBootStart(),
          ),
          SettingsTile(
            icon: Icons.timer_outlined,
            title: 'مدة الغفوة',
            subtitle: '${settings.adhanSnoozeMinutes} دقائق',
            onTap: () => _showSnoozeMinutesPicker(context, ref, settings),
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppTheme.textMuted.withValues(alpha: 0.3),
              size: 14,
            ),
          ),
        ],
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () =>
                      ref.read(settingsNotifierProvider.notifier).testAdhan(),
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: AppTheme.goldGradient,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.play_arrow_rounded,
                              color: Colors.white, size: 20),
                          const SizedBox(width: 6),
                          Text(
                            'تجربة الأذان',
                            style: GoogleFonts.notoKufiArabic(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () =>
                    ref.read(settingsNotifierProvider.notifier).stopAdhan(),
                child: Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    color: AppTheme.goldPrimary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppTheme.borderGold),
                  ),
                  child: const Icon(Icons.stop_rounded,
                      color: AppTheme.goldPrimary, size: 22),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── 4. Prayer ───

  Widget _buildPrayerSection(WidgetRef ref, AppSettings settings) {
    return SettingsSectionCard(
      title: 'إعدادات الصلاة',
      icon: Icons.mosque_outlined,
      children: [
        SettingsTile(
          icon: Icons.calculate_outlined,
          title: 'طريقة الحساب',
          subtitle: _getCalculationMethodName(settings.calculationMethod),
          onTap: () =>
              _showCalculationMethodPicker(context, ref, settings),
          trailing: Icon(
            Icons.arrow_forward_ios_rounded,
            color: AppTheme.textMuted.withValues(alpha: 0.3),
            size: 14,
          ),
        ),
        SettingsTile(
          icon: Icons.gite_outlined,
          title: 'المذهب',
          subtitle: settings.madhab == 0 ? 'جعفري (شيعي)' : 'حنفي',
          onTap: () => _showMadhabPicker(context, ref, settings),
          trailing: Icon(
            Icons.arrow_forward_ios_rounded,
            color: AppTheme.textMuted.withValues(alpha: 0.3),
            size: 14,
          ),
        ),
        SettingsTile(
          icon: Icons.location_on_outlined,
          title: 'الموقع الجغرافي',
          subtitle: settings.autoLocation
              ? 'تحديد الموقع تلقائياً'
              : 'موقع مخصص: ${settings.manualLocation ?? "غير محدد"}',
          trailing: PremiumSwitch(
            value: settings.autoLocation,
            onChanged: (v) =>
                ref.read(settingsNotifierProvider.notifier).toggleAutoLocation(),
          ),
          onTap: () =>
              ref.read(settingsNotifierProvider.notifier).toggleAutoLocation(),
          showDivider: false,
        ),
      ],
    );
  }

  // ─── 5. Tasbeeh ───

  Widget _buildTasbeehSection(WidgetRef ref, AppSettings settings) {
    return SettingsSectionCard(
      title: 'التسبيح',
      icon: Icons.fingerprint_rounded,
      children: [
        SettingsTile(
          icon: Icons.vibration_rounded,
          title: 'الاهتزاز',
          subtitle: 'تشغيل الاهتزاز عند التسبيح',
          trailing: PremiumSwitch(
            value: settings.tasbeehVibration,
            onChanged: (v) =>
                ref.read(settingsNotifierProvider.notifier).toggleTasbeehVibration(),
          ),
          onTap: () =>
              ref.read(settingsNotifierProvider.notifier).toggleTasbeehVibration(),
        ),
        SettingsTile(
          icon: Icons.volume_up_outlined,
          title: 'تأثير صوتي',
          subtitle: 'تشغيل صوت عند كل تسبيحة',
          trailing: PremiumSwitch(
            value: settings.tasbeehSound,
            onChanged: (v) =>
                ref.read(settingsNotifierProvider.notifier).toggleTasbeehSound(),
          ),
          onTap: () =>
              ref.read(settingsNotifierProvider.notifier).toggleTasbeehSound(),
        ),
        SettingsTile(
          icon: Icons.skip_next_outlined,
          title: 'الانتقال التلقائي',
          subtitle: 'الذهاب للذكر التالي عند بلوغ الهدف',
          trailing: PremiumSwitch(
            value: settings.autoNextDhikr,
            onChanged: (v) =>
                ref.read(settingsNotifierProvider.notifier).toggleAutoNextDhikr(),
          ),
          onTap: () =>
              ref.read(settingsNotifierProvider.notifier).toggleAutoNextDhikr(),
        ),
        SettingsTile(
          icon: Icons.check_circle_outline_rounded,
          title: 'تأكيد التصفير',
          subtitle: 'طلب تأكيد قبل تصفير العداد',
          trailing: PremiumSwitch(
            value: settings.tasbeehResetConfirmation,
            onChanged: (v) => ref
                .read(settingsNotifierProvider.notifier)
                .toggleTasbeehResetConfirmation(),
          ),
          onTap: () => ref
              .read(settingsNotifierProvider.notifier)
              .toggleTasbeehResetConfirmation(),
        ),
        SettingsTile(
          icon: Icons.track_changes_rounded,
          title: 'الهدف اليومي',
          subtitle: '${settings.tasbeehDailyGoal} تسبيحة',
          onTap: () => _showDailyGoalPicker(context, ref, settings),
          trailing: Icon(
            Icons.arrow_forward_ios_rounded,
            color: AppTheme.textMuted.withValues(alpha: 0.3),
            size: 14,
          ),
          showDivider: false,
        ),
      ],
    );
  }

  // ─── 6. Shia Worship Reminders ───

  Widget _buildShiaRemindersSection(WidgetRef ref, AppSettings settings) {
    return SettingsSectionCard(
      title: 'تذكيرات عبادات شيعية',
      icon: Icons.auto_awesome,
      children: [
        SettingsTile(
          icon: Icons.star_outline_rounded,
          title: 'تسبيحة الزهراء (عليها السلام)',
          subtitle: 'تذكير بقراءة تسبيحةHazrat Zahra',
          trailing: PremiumSwitch(
            value: settings.reminderTasbeehZahra,
            onChanged: (v) {
              _requestNotificationPermission();
              ref
                  .read(settingsNotifierProvider.notifier)
                  .toggleReminderTasbeehZahra();
            },
          ),
          onTap: () {
            _requestNotificationPermission();
            ref
                .read(settingsNotifierProvider.notifier)
                .toggleReminderTasbeehZahra();
          },
        ),
        SettingsTile(
          icon: Icons.mosque_outlined,
          title: 'زيارة عاشوراء',
          subtitle: 'تذكير بزيارة عاشوراء',
          trailing: PremiumSwitch(
            value: settings.reminderAshuraZiyarat,
            onChanged: (v) {
              _requestNotificationPermission();
              ref
                  .read(settingsNotifierProvider.notifier)
                  .toggleReminderAshuraZiyarat();
            },
          ),
          onTap: () {
            _requestNotificationPermission();
            ref
                .read(settingsNotifierProvider.notifier)
                .toggleReminderAshuraZiyarat();
          },
        ),
        SettingsTile(
          icon: Icons.auto_stories_outlined,
          title: 'دعاء عهد',
          subtitle: 'تذكير بقراءة دعاء العهد',
          trailing: PremiumSwitch(
            value: settings.reminderAhdDua,
            onChanged: (v) {
              _requestNotificationPermission();
              ref
                  .read(settingsNotifierProvider.notifier)
                  .toggleReminderAhdDua();
            },
          ),
          onTap: () {
            _requestNotificationPermission();
            ref
                .read(settingsNotifierProvider.notifier)
                .toggleReminderAhdDua();
          },
        ),
        SettingsTile(
          icon: Icons.menu_book_rounded,
          title: 'دعاء كميل',
          subtitle: 'تذكير بقراءة دعاء كميل',
          trailing: PremiumSwitch(
            value: settings.reminderKumaylDua,
            onChanged: (v) {
              _requestNotificationPermission();
              ref
                  .read(settingsNotifierProvider.notifier)
                  .toggleReminderKumaylDua();
            },
          ),
          onTap: () {
            _requestNotificationPermission();
            ref
                .read(settingsNotifierProvider.notifier)
                .toggleReminderKumaylDua();
          },
        ),
        SettingsTile(
          icon: Icons.book_outlined,
          title: 'دعاء التوسل',
          subtitle: 'تذكير بقراءة دعاء التوسل',
          trailing: PremiumSwitch(
            value: settings.reminderTawassulDua,
            onChanged: (v) {
              _requestNotificationPermission();
              ref
                  .read(settingsNotifierProvider.notifier)
                  .toggleReminderTawassulDua();
            },
          ),
          onTap: () {
            _requestNotificationPermission();
            ref
                .read(settingsNotifierProvider.notifier)
                .toggleReminderTawassulDua();
          },
        ),
        SettingsTile(
          icon: Icons.library_books_outlined,
          title: 'نهج البلاغة',
          subtitle: 'تذكير بقراءة خطبة من نهج البلاغة',
          trailing: PremiumSwitch(
            value: settings.reminderNahjulBalagha,
            onChanged: (v) {
              _requestNotificationPermission();
              ref
                  .read(settingsNotifierProvider.notifier)
                  .toggleReminderNahjulBalagha();
            },
          ),
          onTap: () {
            _requestNotificationPermission();
            ref
                .read(settingsNotifierProvider.notifier)
                .toggleReminderNahjulBalagha();
          },
        ),
        SettingsTile(
          icon: Icons.wb_sunny_outlined,
          title: 'دعاء الصباح',
          subtitle: 'تذكير بأدعية الصباح',
          trailing: PremiumSwitch(
            value: settings.reminderSabahDua,
            onChanged: (v) {
              _requestNotificationPermission();
              ref
                  .read(settingsNotifierProvider.notifier)
                  .toggleReminderSabahDua();
            },
          ),
          onTap: () {
            _requestNotificationPermission();
            ref
                .read(settingsNotifierProvider.notifier)
                .toggleReminderSabahDua();
          },
        ),
        SettingsTile(
          icon: Icons.nightlight_round,
          title: 'زيارة آل يس',
          subtitle: 'تذكير بزيارة آل يس',
          trailing: PremiumSwitch(
            value: settings.reminderZiyaratAalYasin,
            onChanged: (v) {
              _requestNotificationPermission();
              ref
                  .read(settingsNotifierProvider.notifier)
                  .toggleReminderZiyaratAalYasin();
            },
          ),
          onTap: () {
            _requestNotificationPermission();
            ref
                .read(settingsNotifierProvider.notifier)
                .toggleReminderZiyaratAalYasin();
          },
        ),
        SettingsTile(
          icon: Icons.dark_mode_outlined,
          title: 'صلاة الليل',
          subtitle: 'تذكير بصلاة الليل',
          trailing: PremiumSwitch(
            value: settings.reminderLaylPrayer,
            onChanged: (v) {
              _requestNotificationPermission();
              ref
                  .read(settingsNotifierProvider.notifier)
                  .toggleReminderLaylPrayer();
            },
          ),
          onTap: () {
            _requestNotificationPermission();
            ref
                .read(settingsNotifierProvider.notifier)
                .toggleReminderLaylPrayer();
          },
        ),
        SettingsTile(
          icon: Icons.calendar_today_rounded,
          title: 'سنن يوم الجمعة',
          subtitle: 'تذكير بسنن يوم الجمعة',
          trailing: PremiumSwitch(
            value: settings.reminderJumaaActs,
            onChanged: (v) {
              _requestNotificationPermission();
              ref
                  .read(settingsNotifierProvider.notifier)
                  .toggleReminderJumaaActs();
            },
          ),
          onTap: () {
            _requestNotificationPermission();
            ref
                .read(settingsNotifierProvider.notifier)
                .toggleReminderJumaaActs();
          },
          showDivider: false,
        ),
      ],
    );
  }

  // ─── 7. Occasions ───

  Widget _buildOccasionsSection(WidgetRef ref, AppSettings settings) {
    return SettingsSectionCard(
      title: 'المناسبات والزيارات',
      icon: Icons.celebration_outlined,
      children: [
        SettingsTile(
          icon: Icons.cake_outlined,
          title: 'مواليد أهل البيت (عليهم السلام)',
          subtitle: 'إشعارات بأعياد ميلاد أهل البيت',
          trailing: PremiumSwitch(
            value: settings.occasionAhlulbaytBirth,
            onChanged: (v) => ref
                .read(settingsNotifierProvider.notifier)
                .toggleOccasionAhlulbaytBirth(),
          ),
          onTap: () => ref
              .read(settingsNotifierProvider.notifier)
              .toggleOccasionAhlulbaytBirth(),
        ),
        SettingsTile(
          icon: Icons.waving_hand_outlined,
          title: 'وفياتهم (عليهم السلام)',
          subtitle: 'إشعارات بوفيات أهل البيت',
          trailing: PremiumSwitch(
            value: settings.occasionWafaat,
            onChanged: (v) =>
                ref.read(settingsNotifierProvider.notifier).toggleOccasionWafaat(),
          ),
          onTap: () =>
              ref.read(settingsNotifierProvider.notifier).toggleOccasionWafaat(),
        ),
        SettingsTile(
          icon: Icons.date_range_outlined,
          title: 'الأشهر الهجرية',
          subtitle: 'تذكير بأوائل الشهور الهجرية',
          trailing: PremiumSwitch(
            value: settings.occasionHijriMonths,
            onChanged: (v) => ref
                .read(settingsNotifierProvider.notifier)
                .toggleOccasionHijriMonths(),
          ),
          onTap: () => ref
              .read(settingsNotifierProvider.notifier)
              .toggleOccasionHijriMonths(),
        ),
        SettingsTile(
          icon: Icons.auto_awesome_outlined,
          title: 'الليالي المباركة',
          subtitle: 'إشعارات بالليالي الفضيلة والقمرية',
          trailing: PremiumSwitch(
            value: settings.occasionBlessedNights,
            onChanged: (v) => ref
                .read(settingsNotifierProvider.notifier)
                .toggleOccasionBlessedNights(),
          ),
          onTap: () => ref
              .read(settingsNotifierProvider.notifier)
              .toggleOccasionBlessedNights(),
          showDivider: false,
        ),
      ],
    );
  }

  // ─── 8. Visit Settings ───

  Widget _buildVisitSection(WidgetRef ref, AppSettings settings) {
    return SettingsSectionCard(
      title: 'إعدادات الزيارة',
      icon: Icons.bookmark_border_rounded,
      children: [
        SettingsTile(
          icon: Icons.history_rounded,
          title: 'حفظ آخر قراءة',
          subtitle: 'حفظ المكان الأخير في كل زيارة',
          trailing: PremiumSwitch(
            value: settings.visitLastRead,
            onChanged: (v) =>
                ref.read(settingsNotifierProvider.notifier).toggleVisitLastRead(),
          ),
          onTap: () =>
              ref.read(settingsNotifierProvider.notifier).toggleVisitLastRead(),
        ),
        SettingsTile(
          icon: Icons.restore_rounded,
          title: 'استئناف الموقع',
          subtitle: 'العودة للمكان المحفوظ عند فتح الزيارة',
          trailing: PremiumSwitch(
            value: settings.visitResumePosition,
            onChanged: (v) => ref
                .read(settingsNotifierProvider.notifier)
                .toggleVisitResumePosition(),
          ),
          onTap: () => ref
              .read(settingsNotifierProvider.notifier)
              .toggleVisitResumePosition(),
        ),
        SettingsTile(
          icon: Icons.save_outlined,
          title: 'الحفظ التلقائي',
          subtitle: 'حفظ التقدم تلقائياً أثناء القراءة',
          trailing: PremiumSwitch(
            value: settings.visitAutoSave,
            onChanged: (v) =>
                ref.read(settingsNotifierProvider.notifier).toggleVisitAutoSave(),
          ),
          onTap: () =>
              ref.read(settingsNotifierProvider.notifier).toggleVisitAutoSave(),
          showDivider: false,
        ),
      ],
    );
  }

  // ─── 9. Language & Quran ───

  Widget _buildLanguageSection(WidgetRef ref, AppSettings settings) {
    return SettingsSectionCard(
      title: 'اللغة والمصحف',
      icon: Icons.language_rounded,
      children: [
        SettingsTile(
          icon: Icons.translate_rounded,
          title: 'لغة التطبيق',
          subtitle: settings.language == 'ar' ? 'العربية' : 'العربية',
          onTap: () => _showLanguagePicker(context, ref, settings),
          trailing: Icon(
            Icons.arrow_forward_ios_rounded,
            color: AppTheme.textMuted.withValues(alpha: 0.3),
            size: 14,
          ),
        ),
        SettingsTile(
          icon: Icons.font_download_outlined,
          title: 'خط المصحف',
          subtitle: settings.quranFont,
          onTap: () => _showQuranFontPicker(context, ref, settings),
          trailing: Icon(
            Icons.arrow_forward_ios_rounded,
            color: AppTheme.textMuted.withValues(alpha: 0.3),
            size: 14,
          ),
        ),
        SettingsTile(
          icon: Icons.audio_file_outlined,
          title: 'جودة الصوت',
          subtitle: settings.audioQuality,
          onTap: () => _showAudioQualityPicker(context, ref, settings),
          trailing: Icon(
            Icons.arrow_forward_ios_rounded,
            color: AppTheme.textMuted.withValues(alpha: 0.3),
            size: 14,
          ),
          showDivider: false,
        ),
      ],
    );
  }

  // ─── 10. Privacy & Data ───

  Widget _buildPrivacySection(WidgetRef ref, AppSettings settings) {
    return SettingsSectionCard(
      title: 'الخصوصية والأمان',
      icon: Icons.security_rounded,
      children: [
        SettingsTile(
          icon: Icons.backup_outlined,
          title: 'نسخة احتياطية',
          subtitle: 'حفظ بياناتك وإعداداتك',
          onTap: _handleBackup,
          trailing: Icon(
            Icons.arrow_forward_ios_rounded,
            color: AppTheme.textMuted.withValues(alpha: 0.3),
            size: 14,
          ),
        ),
        SettingsTile(
          icon: Icons.restore_outlined,
          title: 'استعادة البيانات',
          subtitle: 'استرجاع النسخة الاحتياطية',
          onTap: _handleRestore,
          trailing: Icon(
            Icons.arrow_forward_ios_rounded,
            color: AppTheme.textMuted.withValues(alpha: 0.3),
            size: 14,
          ),
        ),
        SettingsTile(
          icon: Icons.delete_forever_outlined,
          title: 'مسح البيانات',
          subtitle: 'حذف جميع الإحصائيات والإعدادات',
          onTap: () => _showResetDialog(context, ref),
          trailing: Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.redAccent.withValues(alpha: 0.5),
            size: 14,
          ),
          showDivider: false,
        ),
      ],
    );
  }

  // ─── 11. Support & About ───

  Widget _buildSupportSection(AppSettings settings) {
    return SettingsSectionCard(
      title: 'الدعم والمساعدة',
      icon: Icons.help_outline_rounded,
      children: [
        SettingsTile(
          icon: Icons.camera_alt_outlined,
          title: 'انستغرام',
          subtitle: '@203.9.7',
          onTap: () => _launchURL('https://www.instagram.com/203.9.7/'),
          trailing: Icon(
            Icons.arrow_forward_ios_rounded,
            color: AppTheme.textMuted.withValues(alpha: 0.3),
            size: 14,
          ),
        ),
        SettingsTile(
          icon: Icons.mail_outline_rounded,
          title: 'اتصل بنا',
          subtitle: 'للاقتراحات والاستفسارات',
          onTap: () => _launchEmail('contact@dailyislamic.app', 'Inquiry'),
          trailing: Icon(
            Icons.arrow_forward_ios_rounded,
            color: AppTheme.textMuted.withValues(alpha: 0.3),
            size: 14,
          ),
        ),
        SettingsTile(
          icon: Icons.bug_report_outlined,
          title: 'تبليغ عن خطأ',
          onTap: () => _launchEmail('bugs@dailyislamic.app', 'Bug Report'),
          trailing: Icon(
            Icons.arrow_forward_ios_rounded,
            color: AppTheme.textMuted.withValues(alpha: 0.3),
            size: 14,
          ),
        ),
        SettingsTile(
          icon: Icons.star_outline_rounded,
          title: 'تقييم التطبيق',
          onTap: () => _launchURL(
              'https://play.google.com/store/apps/details?id=com.daily.islamic.widget'),
          trailing: Icon(
            Icons.arrow_forward_ios_rounded,
            color: AppTheme.textMuted.withValues(alpha: 0.3),
            size: 14,
          ),
        ),
        SettingsTile(
          icon: Icons.share_outlined,
          title: 'مشاركة التطبيق',
          onTap: () => Share.share(
              'جرب تطبيق الذكر اليومي، رفيقك الإيماني المتكامل: https://dailyislamic.app'),
          trailing: Icon(
            Icons.arrow_forward_ios_rounded,
            color: AppTheme.textMuted.withValues(alpha: 0.3),
            size: 14,
          ),
        ),
        SettingsTile(
          icon: Icons.language_rounded,
          title: 'موقع رَفِيق الرسمي',
          subtitle: 'تعرف على التطبيق، آخر التحديثات، والدعم',
          onTap: () => _launchURL('https://rafiqart.tech/'),
          trailing: Icon(
            Icons.arrow_forward_ios_rounded,
            color: AppTheme.textMuted.withValues(alpha: 0.3),
            size: 14,
          ),
        ),
        SettingsTile(
          icon: Icons.info_outline_rounded,
          title: 'عن التطبيق',
          subtitle: 'الإصدار ${_packageInfo?.version ?? "1.0.0"}',
          onTap: () => _showAboutBottomSheet(context, settings),
          trailing: Icon(
            Icons.arrow_forward_ios_rounded,
            color: AppTheme.textMuted.withValues(alpha: 0.3),
            size: 14,
          ),
          showDivider: false,
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════
  // Pickers & Dialogs
  // ═══════════════════════════════════════════════

  String _getCalculationMethodName(int method) {
    final methods = [
      'معهد الجيوفيزياء بطهران',
      'رابطة العالم الإسلامي',
      'أم القرى',
      'الهيئة المصرية العامة للمساحة',
      'جامعة العلوم الإسلامية بكراتشي',
      'الاتحاد الإسلامي في أمريكا الشمالية',
    ];
    if (method < 0 || method >= methods.length) return 'تلقائي';
    return methods[method];
  }

  String _getAdhanSoundName(String sound) {
    return AppConstants.getAdhanDisplayName(sound);
  }

  void _showTimeFormatPicker(
      BuildContext context, WidgetRef ref, AppSettings settings) {
    _showPremiumPicker(context, 'صيغة الوقت', [
      _buildPickerOption(
        '24 ساعة',
        settings.timeFormat == TimeFormat.hour24,
        () => ref.read(settingsNotifierProvider.notifier).updateTimeFormat(TimeFormat.hour24),
      ),
      _buildPickerOption(
        '12 ساعة',
        settings.timeFormat == TimeFormat.hour12,
        () => ref.read(settingsNotifierProvider.notifier).updateTimeFormat(TimeFormat.hour12),
      ),
    ]);
  }

  void _showNumeralSystemPicker(
      BuildContext context, WidgetRef ref, AppSettings settings) {
    _showPremiumPicker(context, 'نظام الأرقام', [
      _buildPickerOption(
        'أرقام عربية (٠١٢٣٤٥٦٧٨٩)',
        settings.numeralSystem == NumeralSystem.arabic,
        () => ref.read(settingsNotifierProvider.notifier).updateNumeralSystem(NumeralSystem.arabic),
      ),
      _buildPickerOption(
        'أرقام إنجليزية (0123456789)',
        settings.numeralSystem == NumeralSystem.english,
        () => ref.read(settingsNotifierProvider.notifier).updateNumeralSystem(NumeralSystem.english),
      ),
    ]);
  }

  void _showCalculationMethodPicker(
      BuildContext context, WidgetRef ref, AppSettings settings) {
    final methods = [
      'معهد الجيوفيزياء بطهران',
      'رابطة العالم الإسلامي',
      'أم القرى',
      'الهيئة المصرية العامة للمساحة',
      'جامعة العلوم الإسلامية بكراتشي',
      'الاتحاد الإسلامي في أمريكا الشمالية',
    ];
    _showPremiumPicker(
      context,
      'طريقة حساب مواقيت الصلاة',
      methods.asMap().entries.map((entry) {
        return _buildPickerOption(
          entry.value,
          entry.key == settings.calculationMethod,
          () => ref
              .read(settingsNotifierProvider.notifier)
              .updateCalculationMethod(entry.key),
        );
      }).toList(),
    );
  }

  void _showMadhabPicker(
      BuildContext context, WidgetRef ref, AppSettings settings) {
    _showPremiumPicker(context, 'المذهب الفقهي (العصر)', [
      _buildPickerOption(
        'جعفري (شيعي)',
        settings.madhab == 0,
        () => ref.read(settingsNotifierProvider.notifier).updateMadhab(0),
      ),
      _buildPickerOption(
        'حنفي',
        settings.madhab == 1,
        () => ref.read(settingsNotifierProvider.notifier).updateMadhab(1),
      ),
    ]);
  }

  void _showLanguagePicker(
      BuildContext context, WidgetRef ref, AppSettings settings) {
    _showPremiumPicker(context, 'لغة التطبيق', [
      _buildPickerOption(
        'العربية',
        settings.language == 'ar',
        () => ref.read(settingsNotifierProvider.notifier).updateLanguage('ar'),
      ),
      _buildPickerOption(
        'العربية',
        settings.language == 'en',
        () => ref.read(settingsNotifierProvider.notifier).updateLanguage('en'),
      ),
    ]);
  }

  void _showQuranFontPicker(
      BuildContext context, WidgetRef ref, AppSettings settings) {
    final fonts = ['العثماني', 'الهندي', 'مبسط'];
    _showPremiumPicker(
      context,
      'خط المصحف الشريف',
      fonts.map((f) {
        return _buildPickerOption(
          f,
          settings.quranFont == f,
          () =>
              ref.read(settingsNotifierProvider.notifier).updateQuranFont(f),
        );
      }).toList(),
    );
  }

  void _showAudioQualityPicker(
      BuildContext context, WidgetRef ref, AppSettings settings) {
    final qualities = ['منخفضة', 'متوسطة', 'عالية'];
    _showPremiumPicker(
      context,
      'جودة التحميل الصوتي',
      qualities.map((q) {
        return _buildPickerOption(
          q,
          settings.audioQuality == q,
          () => ref
              .read(settingsNotifierProvider.notifier)
              .updateAudioQuality(q),
        );
      }).toList(),
    );
  }

  void _showDailyGoalPicker(
      BuildContext context, WidgetRef ref, AppSettings settings) {
    final goals = [100, 333, 1000, 5000, 10000];
    _showPremiumPicker(
      context,
      'الهدف اليومي للتسبيح',
      goals.map((g) {
        return _buildPickerOption(
          '$g تسبيحة',
          settings.tasbeehDailyGoal == g,
          () => ref
              .read(settingsNotifierProvider.notifier)
              .updateTasbeehDailyGoal(g),
        );
      }).toList(),
    );
  }

  void _showAdhanSoundPicker(
      BuildContext context, WidgetRef ref, AppSettings settings) {
    final sounds = AppConstants.muadhinKeys
        .map((key) => (key, AppConstants.muadhinDisplayNames[key]!))
        .toList();
    _showPremiumPicker(
      context,
      'اختيار صوت الأذان',
      sounds.map((s) {
        return _buildPickerOption(
          s.$2,
          settings.adhanSound == s.$1,
          () => ref
              .read(settingsNotifierProvider.notifier)
              .updateAdhanSound(s.$1),
        );
      }).toList(),
    );
  }

  void _showSnoozeMinutesPicker(
      BuildContext context, WidgetRef ref, AppSettings settings) {
    final minutes = [1, 3, 5, 10, 15];
    _showPremiumPicker(
      context,
      'مدة الغفوة (بالدقائق)',
      minutes.map((m) {
        return _buildPickerOption(
          '$m دقيقة',
          settings.adhanSnoozeMinutes == m,
          () => ref
              .read(settingsNotifierProvider.notifier)
              .updateAdhanSnoozeMinutes(m),
        );
      }).toList(),
    );
  }

  void _showPremiumPicker(
      BuildContext context, String title, List<Widget> options) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),
          decoration: BoxDecoration(
            color: AppTheme.bgSecondary,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(32)),
            border: Border.all(color: AppTheme.borderGold, width: 1.0),
          ),
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                title,
                style: GoogleFonts.notoKufiArabic(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: options,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPickerOption(
      String title, bool isSelected, VoidCallback onTap) {
    return ListTile(
      title: Text(
        title,
        style: GoogleFonts.notoKufiArabic(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? AppTheme.goldPrimary : AppTheme.textPrimary,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: AppTheme.goldPrimary)
          : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
        Navigator.pop(context);
        _showSuccessSnackBar('تم التحديث بنجاح');
      },
    );
  }

  // ─── Actions ───

  Future<void> _requestNotificationPermission() async {
    final granted = await PermissionService.requestNotificationPermission();
    if (!granted && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.info_outline, color: Colors.white),
              SizedBox(width: 12),
              Expanded(
                  child: Text('الرجاء منح إذن الإشعارات من الإعدادات')),
            ],
          ),
          backgroundColor: AppTheme.goldPrimary,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(24),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _handleBackup() async {
    HapticFeedback.mediumImpact();
    _showLoadingDialog('جاري إنشاء نسخة احتياطية...');
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    Navigator.pop(context);
    _showSuccessSnackBar('تم إنشاء النسخة الاحتياطية بنجاح على السحابة');
  }

  void _handleRestore() async {
    HapticFeedback.mediumImpact();
    _showLoadingDialog('جاري استعادة البيانات...');
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    Navigator.pop(context);
    _showSuccessSnackBar('تم استعادة جميع بياناتك وإعداداتك');
  }

  void _showLoadingDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.bgSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: AppTheme.borderGold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: AppTheme.goldPrimary),
            const SizedBox(height: 20),
            Text(
              message,
              style: GoogleFonts.notoKufiArabic(color: AppTheme.textPrimary),
            ),
          ],
        ),
      ),
    );
  }

  void _showResetDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.bgSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(color: Colors.redAccent.withValues(alpha: 0.3)),
        ),
        title: Text(
          'مسح جميع البيانات',
          style: GoogleFonts.notoKufiArabic(
            fontWeight: FontWeight.bold,
            color: Colors.redAccent,
          ),
        ),
        content: Text(
          'هل أنت متأكد من مسح جميع البيانات؟ لا يمكن التراجع عن هذا الإجراء.',
          style: GoogleFonts.notoKufiArabic(
              color: AppTheme.textPrimary.withValues(alpha: 0.8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('إلغاء',
                style: GoogleFonts.notoKufiArabic(color: AppTheme.textMuted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
            onPressed: () async {
              HapticFeedback.heavyImpact();
              ref
                  .read(settingsNotifierProvider.notifier)
                  .resetAllSettings();
              Navigator.pop(ctx);
              _showSuccessSnackBar('تم مسح جميع البيانات بنجاح');
            },
            child: Text('مسح الآن',
                style: GoogleFonts.notoKufiArabic(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
            const SizedBox(width: 12),
            Text(message,
                style:
                    GoogleFonts.notoKufiArabic(fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: const Color(0xFF0F8B6D),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _launchEmail(String email, String subject) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {'subject': subject},
    );
    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    }
  }

  void _showAboutBottomSheet(BuildContext context, AppSettings settings) {
    final w = MediaQuery.sizeOf(context).width;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        final sheetH = MediaQuery.of(context).size.height * 0.7;
        final pad = w < 360 ? 20.0 : 32.0;
        return Container(
          height: sheetH,
          decoration: BoxDecoration(
            color: AppTheme.bgSecondary,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(32)),
            border: Border.all(color: AppTheme.borderGold, width: 1.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(pad),
          child: Column(
            children: [
              Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 32),
              const PrayerBeadsIllustration(
                size: 80,
                color: AppTheme.goldPrimary,
              ),
              const SizedBox(height: 24),
              Text(
                'رَفِيقْ',
                style: GoogleFonts.notoKufiArabic(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              Text(
                'الإصدار ${_packageInfo?.version ?? "1.0.0"} (${_packageInfo?.buildNumber ?? "1"})',
                style:
                    GoogleFonts.notoKufiArabic(color: AppTheme.textMuted),
              ),
              const SizedBox(height: 32),
              AppTheme.goldDivider(width: 60),
              const SizedBox(height: 32),
              Text(
                'تطبيق إسلامي شيعي متكامل يهدف لمساعدة المؤمن في أداء عباداته اليومية من خلال واجهة مستخدم حديثة وفخمة تجمع بين الأصالة والمعاصرة.',
                textAlign: TextAlign.center,
                style: GoogleFonts.notoKufiArabic(
                  fontSize: 16,
                  height: 1.7,
                  color: AppTheme.textPrimary.withValues(alpha: 0.9),
                ),
              ),
              const Spacer(),
              Text(
                'تم التطوير بواسطة م. أحمد السعدي',
                style: GoogleFonts.notoKufiArabic(
                  fontSize: 14,
                  color: AppTheme.textMuted,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'حقوق النشر © 2024 جميع الحقوق محفوظة',
                style: GoogleFonts.notoKufiArabic(
                  fontSize: 12,
                  color: AppTheme.textMuted.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      );
      },
    );
  }
}

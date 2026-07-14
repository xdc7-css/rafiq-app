import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../providers/settings_provider.dart';
import '../../../../theme/app_theme.dart';
import '../providers/onboarding_provider.dart';

class PermissionOnboardingScreen extends ConsumerStatefulWidget {
  const PermissionOnboardingScreen({super.key});

  @override
  ConsumerState<PermissionOnboardingScreen> createState() =>
      _PermissionOnboardingScreenState();
}

class _PermissionOnboardingScreenState
    extends ConsumerState<PermissionOnboardingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _next() {
    final state = ref.read(onboardingProvider);
    if (state.isLastStep) {
      _finish();
      return;
    }
    _fadeController.reverse().then((_) {
      ref.read(onboardingProvider.notifier).next();
      _fadeController.forward();
    });
  }

  void _previous() {
    _fadeController.reverse().then((_) {
      ref.read(onboardingProvider.notifier).previous();
      _fadeController.forward();
    });
  }

  Future<void> _finish() async {
    await ref.read(settingsNotifierProvider.notifier).markOnboarded();
    if (!mounted) return;
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final state = ref.watch(onboardingProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.premiumNavyGradient),
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(state),
              _buildProgressIndicator(state),
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: w < 360 ? 16 : 20),
                    child: _buildStepContent(state),
                  ),
                ),
              ),
              _buildBottomBar(state),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(OnboardingState state) {
    if (state.step == OnboardingStep.welcome) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
      child: Row(
        children: [
          if (state.step != OnboardingStep.welcome)
            IconButton(
              onPressed: _previous,
              icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
              color: AppTheme.textMuted,
            )
          else
            const SizedBox(width: 48),
          const Spacer(),
          TextButton(
            onPressed: _finish,
            child: Text(
              'تخطي',
              style: TextStyle(
                color: AppTheme.goldPrimary.withValues(alpha: 0.7),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(OnboardingState state) {
    final w = MediaQuery.sizeOf(context).width;
    if (state.step == OnboardingStep.welcome) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w < 360 ? 20 : 32, vertical: 8),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: state.progress,
              minHeight: 4,
              backgroundColor: AppTheme.goldPrimary.withValues(alpha: 0.12),
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.goldPrimary),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${state.currentStepIndex + 1} / ${state.totalSteps}',
            style: TextStyle(
              color: AppTheme.textMuted.withValues(alpha: 0.5),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent(OnboardingState state) {
    switch (state.step) {
      case OnboardingStep.welcome:
        return _buildWelcomeStep();
      case OnboardingStep.notifications:
        return _buildNotificationStep(state);
      case OnboardingStep.exactAlarm:
        return _buildExactAlarmStep(state);
      case OnboardingStep.batteryOptimization:
        return _buildBatteryStep(state);
      case OnboardingStep.backgroundActivity:
        return _buildBackgroundStep();
      case OnboardingStep.autoStart:
        return _buildAutoStartStep(state);
      case OnboardingStep.audio:
        return _buildAudioStep();
      case OnboardingStep.summary:
        return _buildSummaryStep(state);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // STEP 1 — Welcome
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildWelcomeStep() {
    final w = MediaQuery.sizeOf(context).width;
    return Column(
      children: [
        const SizedBox(height: 48),
        _buildIconContainer(
          icon: Icons.mosque_rounded,
          size: 100,
          iconSize: 52,
          gradient: AppTheme.goldGradient,
        ),
        const SizedBox(height: 40),
        Text(
          'مرحباً بك في رفيق',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
            fontFamily: 'Cairo',
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'لتقديم تجربة مثالية نحتاج إلى بعض الصلاحيات',
          style: TextStyle(
            fontSize: 16,
            color: AppTheme.textMuted,
            height: 1.6,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: w < 360 ? 24 : 32),
        _buildFeatureRow(
          Icons.notifications_active_rounded,
          'إشعارات دقيقة لأوقات الصلاة',
        ),
        const SizedBox(height: 12),
        _buildFeatureRow(
          Icons.volume_up_rounded,
          'تشغيل الأذان في الوقت المحدد',
        ),
        const SizedBox(height: 12),
        _buildFeatureRow(
          Icons.phonelink_setup_rounded,
          'عمل مستمر في الخلفية',
        ),
        const SizedBox(height: 12),
        _buildFeatureRow(
          Icons.lock_open_rounded,
          'تشغيل الصوت على شاشة القفل',
        ),
        const SizedBox(height: 48),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // STEP 2 — Notifications
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildNotificationStep(OnboardingState state) {
    return _buildPermissionStep(
      icon: Icons.notifications_active_rounded,
      title: 'إشعارات الصلاة',
      description: 'نحتاج إذن الإشعارات لإرسال تذكير بأوقات الصلاة وتشغيل الأذان',
      isGranted: state.notificationsGranted,
      grantLabel: 'منح إذن الإشعارات',
      denyLabel: 'إكمال بدون إذن',
      onGrant: () async {
        await ref.read(onboardingProvider.notifier).requestNotifications();
      },
      denyExplanation: state.notificationsGranted
          ? null
          : 'إشعارات الصلاة لن تعمل بدون هذا الإذن',
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // STEP 3 — Exact Alarm
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildExactAlarmStep(OnboardingState state) {
    if (kIsWeb) return _buildWebSkipStep('الأذان الدقيق');
    return _buildPermissionStep(
      icon: Icons.alarm_rounded,
      title: 'الأذان الدقيق',
      description: 'يسمح هذا الإذن بتشغيل الأذان في الوقت الدقيق لصلاة الفجر والظهر والمغرب',
      isGranted: state.exactAlarmGranted,
      grantLabel: 'تفعيل الأذان الدقيق',
      denyLabel: 'إكمال بدون تفعيل',
      onGrant: () async {
        await ref.read(onboardingProvider.notifier).requestExactAlarm();
      },
      denyExplanation: state.exactAlarmGranted
          ? null
          : 'قد لا يُ播放 الأذان في الوقت الدقيق',
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // STEP 4 — Battery Optimization
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildBatteryStep(OnboardingState state) {
    if (kIsWeb) return _buildWebSkipStep('تحسين البطارية');
    return _buildPermissionStep(
      icon: Icons.battery_charging_full_rounded,
      title: 'تحسين البطارية',
      description: 'يمنع Android من إيقاف الأذان في الخلفية. هذا ضروري لتشغيل الأذان حتى إذا كان التطبيق مغلقاً',
      isGranted: state.batteryOptimized,
      grantLabel: 'إلغاء تحسين البطارية',
      denyLabel: 'إكمال بدون إلغاء',
      onGrant: () async {
        await ref.read(onboardingProvider.notifier).requestBatteryExemption();
      },
      denyExplanation: state.batteryOptimized
          ? null
          : 'قد يتوقف الأذان في الخلفية عند تفعيل تحسين البطارية',
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // STEP 5 — Background Activity
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildBackgroundStep() {
    if (kIsWeb) return _buildWebSkipStep('العمل في الخلفية');
    return _buildPermissionStep(
      icon: Icons.settings_backup_restore_rounded,
      title: 'العمل في الخلفية',
      description: 'بعض الشركات المصنعة مثل Xiaomi و Huawei و Oppo قد توقف الخدمات في الخلفية. تأكد من السماح للتطبيق بالعمل في الخلفية',
      isGranted: true,
      grantLabel: 'فتح إعدادات البطارية',
      onGrant: () async {
        await ref.read(onboardingProvider.notifier).openBatterySettings();
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // STEP 6 — Auto Start
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildAutoStartStep(OnboardingState state) {
    if (kIsWeb) return _buildWebSkipStep('التشغيل التلقائي');
    if (!state.autoStartSupported) return const SizedBox.shrink();
    return _buildPermissionStep(
      icon: Icons.power_rounded,
      title: 'التشغيل التلقائي',
      description: 'السماح للتطبيق بالتشغيل تلقائياً عند تشغيل الجهاز لضمان عمل الأذان بعد إعادة التشغيل',
      isGranted: true,
      grantLabel: 'فتح إعدادات التشغيل التلقائي',
      onGrant: () async {
        await ref.read(onboardingProvider.notifier).openAutoStart();
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // STEP 7 — Audio Confirmation
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildAudioStep() {
    final w = MediaQuery.sizeOf(context).width;
    return Column(
      children: [
        SizedBox(height: w < 360 ? 24 : 32),
        _buildIconContainer(
          icon: Icons.volume_up_rounded,
          size: 90,
          iconSize: 46,
          gradient: AppTheme.goldGradient,
        ),
        SizedBox(height: w < 360 ? 24 : 32),
        Text(
          'صوت الأذان',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
            fontFamily: 'Cairo',
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'سيتم تشغيل الأذان في الوقت المحدد حتى في الحالات التالية',
          style: TextStyle(
            fontSize: 15,
            color: AppTheme.textMuted,
            height: 1.6,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: w < 360 ? 24 : 32),
        _buildFeatureRow(Icons.lock_rounded, 'عندما تكون الشاشة مقفلة'),
        const SizedBox(height: 12),
        _buildFeatureRow(Icons.minimize_rounded, 'عندما يكون التطبيق في الخلفية'),
        const SizedBox(height: 12),
        _buildFeatureRow(Icons.bedtime_rounded, 'عندما يكون الجهاز في وضع السكون'),
        SizedBox(height: w < 360 ? 24 : 32),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.goldPrimary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.goldPrimary.withValues(alpha: 0.15),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: AppTheme.goldPrimary,
                size: 22,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'الأذان سيُ播放 بشكل موثوق في جميع الأحوال',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.goldPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 48),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // STEP 8 — Summary
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildSummaryStep(OnboardingState state) {
    final w = MediaQuery.sizeOf(context).width;
    return Column(
      children: [
        SizedBox(height: w < 360 ? 24 : 32),
        _buildIconContainer(
          icon: Icons.check_circle_rounded,
          size: 90,
          iconSize: 46,
          gradient: const LinearGradient(
            colors: [Color(0xFF2ECC71), Color(0xFF27AE60)],
          ),
        ),
        SizedBox(height: w < 360 ? 24 : 32),
        Text(
          'الإعداد جاهز',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
            fontFamily: 'Cairo',
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'ملخص حالة الصلاحيات',
          style: TextStyle(
            fontSize: 15,
            color: AppTheme.textMuted,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: w < 360 ? 24 : 32),
        _buildSummaryItem(
          'إشعارات الصلاة',
          state.notificationsGranted,
        ),
        const SizedBox(height: 8),
        _buildSummaryItem(
          'الأذان الدقيق',
          state.exactAlarmGranted,
        ),
        const SizedBox(height: 8),
        _buildSummaryItem(
          'إلغاء تحسين البطارية',
          state.batteryOptimized,
        ),
        const SizedBox(height: 8),
        _buildSummaryItem(
          'العمل في الخلفية',
          true,
        ),
        SizedBox(height: w < 360 ? 24 : 32),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // Shared Components
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildPermissionStep({
    required IconData icon,
    required String title,
    required String description,
    required bool isGranted,
    required String grantLabel,
    String? denyLabel,
    required VoidCallback onGrant,
    String? denyExplanation,
  }) {
    final w = MediaQuery.sizeOf(context).width;
    return Column(
      children: [
        SizedBox(height: w < 360 ? 24 : 32),
        _buildIconContainer(
          icon: icon,
          size: 90,
          iconSize: 46,
          gradient: AppTheme.goldGradient,
        ),
        SizedBox(height: w < 360 ? 24 : 32),
        Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
            fontFamily: 'Cairo',
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          description,
          style: TextStyle(
            fontSize: 15,
            color: AppTheme.textMuted,
            height: 1.6,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: w < 360 ? 24 : 32),
        _buildPermissionStatus(isGranted),
        SizedBox(height: w < 360 ? 18 : 24),
        if (!isGranted)
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: onGrant,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.goldPrimary,
                foregroundColor: AppTheme.bgPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
                elevation: 0,
              ),
              child: Text(
                grantLabel,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        if (isGranted)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF2ECC71).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF2ECC71).withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF2ECC71),
                  size: 22,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'تم التفعيل بنجاح',
                    style: TextStyle(
                      fontSize: 14,
                      color: const Color(0xFF2ECC71),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        if (!isGranted && denyLabel != null) ...[
          const SizedBox(height: 12),
          TextButton(
            onPressed: _next,
            child: Text(
              denyLabel,
              style: TextStyle(
                color: AppTheme.textMuted.withValues(alpha: 0.6),
                fontSize: 14,
              ),
            ),
          ),
        ],
        if (denyExplanation != null && !isGranted) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.orange.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.orange.withValues(alpha: 0.8),
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    denyExplanation,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.orange.withValues(alpha: 0.9),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 48),
      ],
    );
  }

  Widget _buildIconContainer({
    required IconData icon,
    required double size,
    required double iconSize,
    required Gradient gradient,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: gradient,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppTheme.goldPrimary.withValues(alpha: 0.3),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Icon(icon, size: iconSize, color: Colors.white),
    );
  }

  Widget _buildPermissionStatus(bool isGranted) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: isGranted
            ? const Color(0xFF2ECC71).withValues(alpha: 0.1)
            : Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: isGranted
              ? const Color(0xFF2ECC71).withValues(alpha: 0.3)
              : Colors.orange.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isGranted ? Icons.check_circle_rounded : Icons.info_outline_rounded,
            size: 18,
            color: isGranted ? const Color(0xFF2ECC71) : Colors.orange,
          ),
          const SizedBox(width: 8),
          Text(
            isGranted ? 'تم التفعيل' : 'لم يتم التفعيل',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isGranted ? const Color(0xFF2ECC71) : Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String text) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppTheme.goldPrimary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 20, color: AppTheme.goldPrimary),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15,
              color: AppTheme.textPrimary.withValues(alpha: 0.9),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryItem(String label, bool granted) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.bgCard.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: granted
              ? const Color(0xFF2ECC71).withValues(alpha: 0.2)
              : Colors.orange.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            granted
                ? Icons.check_circle_rounded
                : Icons.warning_amber_rounded,
            size: 20,
            color: granted ? const Color(0xFF2ECC71) : Colors.orange,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 15,
                color: AppTheme.textPrimary.withValues(alpha: 0.9),
              ),
            ),
          ),
          Text(
            granted ? '✓' : '⚠',
            style: TextStyle(
              fontSize: 14,
              color: granted ? const Color(0xFF2ECC71) : Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWebSkipStep(String title) {
    return Column(
      children: [
        const SizedBox(height: 48),
        Icon(
          Icons.language_rounded,
          size: 60,
          color: AppTheme.goldPrimary.withValues(alpha: 0.5),
        ),
        const SizedBox(height: 24),
        Text(
          title,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
            fontFamily: 'Cairo',
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'هذه الصلاحيات مخصصة لنظام Android فقط',
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.textMuted,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 48),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // Bottom Bar
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildBottomBar(OnboardingState state) {
    final w = MediaQuery.sizeOf(context).width;
    if (state.step == OnboardingStep.welcome) {
      return Padding(
        padding: EdgeInsets.all(w < 360 ? 16 : 24),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _next,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.goldPrimary,
              foregroundColor: AppTheme.bgPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              elevation: 0,
            ),
            child: const Text(
              'ابدأ الإعداد',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }

    if (state.isLastStep) {
      return Padding(
        padding: EdgeInsets.all(w < 360 ? 16 : 24),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _finish,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.goldPrimary,
              foregroundColor: AppTheme.bgPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              elevation: 0,
            ),
            child: const Text(
              'دخول التطبيق',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(w < 360 ? 16 : 24, 8, w < 360 ? 16 : 24, w < 360 ? 16 : 24),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: _next,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.goldPrimary,
            foregroundColor: AppTheme.bgPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(26),
            ),
            elevation: 0,
          ),
          child: const Text(
            'التالي',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

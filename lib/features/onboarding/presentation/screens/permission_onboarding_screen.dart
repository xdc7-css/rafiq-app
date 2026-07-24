import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../models/permission_models.dart';
import '../../../../providers/settings_provider.dart';
import '../../../../services/permission_request_controller.dart';
import '../../../../theme/app_theme.dart';
import '../../../../widgets/permission_status_row.dart';
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
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  final ScrollController _scrollController = ScrollController();
  int _lastActiveIndex = -1;

  /// Platform-filtered permission list (built once per screen lifecycle)
  late final List<PermissionDefinition> _permissions;

  @override
  void initState() {
    super.initState();
    _permissions = PermissionRegistry.onboardingPermissions();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _goToScreen(int screen) {
    _controller.reverse().then((_) {
      ref.read(onboardingProvider.notifier).goToScreen(screen);
      _controller.forward();
    });
  }

  Future<void> _finish() async {
    await ref.read(settingsNotifierProvider.notifier).markOnboarded();
    if (!mounted) return;
    context.go('/home');
  }

  void _scrollToActive(int index) {
    if (!_scrollController.hasClients || index < 0) return;
    _scrollController.animateTo(
      index * 92.0,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final state = ref.watch(onboardingProvider);
    final controller = state.controller;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final idx = controller.activeIndex;
      if (idx != _lastActiveIndex) {
        _lastActiveIndex = idx;
        if (idx >= 0) _scrollToActive(idx);
      }
    });

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.premiumNavyGradient),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: state.isWelcome
                  ? _buildWelcomeScreen(w)
                  : state.isPermissions
                      ? _buildPermissionsScreen(w, state, controller)
                      : _buildFinishedScreen(w, state, controller),
            ),
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // SCREEN 1 — Welcome
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildWelcomeScreen(double w) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w < 360 ? 20 : 28),
      child: Column(
        children: [
          const Spacer(flex: 2),
          _buildProgressDots(0),
          const SizedBox(height: 40),
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppTheme.goldGradient,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.goldPrimary.withValues(alpha: 0.35),
                  blurRadius: 40,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: const Icon(Icons.mosque_rounded, size: 56, color: Colors.white),
          ),
          const SizedBox(height: 40),
          Text(
            'مرحباً بك في رفيق',
            style: GoogleFonts.cairo(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'سنقوم بإعداد التطبيق خلال أقل من دقيقة\nللحصول على أفضل تجربة.',
            style: TextStyle(fontSize: 15, color: AppTheme.textMuted, height: 1.7),
            textAlign: TextAlign.center,
          ),
          const Spacer(flex: 3),
          _buildPrimaryButton(label: 'ابدأ الإعداد', onPressed: () => _goToScreen(1)),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // SCREEN 2 — Smart Permission Center
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildPermissionsScreen(
      double w, OnboardingState state, PermissionRequestController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w < 360 ? 16 : 20),
      child: Column(
        children: [
          const SizedBox(height: 12),
          _buildProgressDots(1),
          const SizedBox(height: 20),
          Text(
            'إعداد الأذان',
            style: GoogleFonts.cairo(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'نحتاج هذه الصلاحيات لتشغيل الأذان في الوقت المناسب',
            style: TextStyle(
              fontSize: 13,
              color: AppTheme.textMuted.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          _buildCompletionIndicator(controller),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: AppTheme.glassCard(radius: 24),
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: _permissions.length,
                itemBuilder: (context, index) {
                  final item = _permissions[index];
                  final isActive = controller.activeIndex == index;
                  final isLast = index == _permissions.length - 1;
                  return Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutCubic,
                        margin: EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: isActive ? 2 : 0,
                        ),
                        decoration: isActive
                            ? BoxDecoration(
                                color: AppTheme.goldPrimary.withValues(alpha: 0.06),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppTheme.goldPrimary.withValues(alpha: 0.2),
                                  width: 1,
                                ),
                              )
                            : null,
                        child: PermissionStatusRow(
                          item: item,
                          status: controller.status(item.key),
                          compact: true,
                          onTap: item.showRetry
                              ? () => ref
                                  .read(onboardingProvider.notifier)
                                  .retryPermission(item.key)
                              : null,
                        ),
                      ),
                      if (!isLast)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: Divider(height: 1, color: AppTheme.borderSubtle),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (controller.blockedByRoot) ...[
            _buildBlockedNotice(),
            const SizedBox(height: 12),
          ],
          _buildPrimaryButton(
            label: controller.requesting
                ? 'جاري التفعيل...'
                : controller.blockedByRoot
                    ? 'تفعيل الإشعارات'
                    : 'متابعة',
            onPressed: controller.requesting
                ? null
                : () {
                    if (controller.blockedByRoot) {
                      // Retry just the root permission
                      ref.read(onboardingProvider.notifier).retryPermission(
                            controller.blockedRoot ?? PermissionKey.notifications,
                          );
                    } else {
                      ref.read(onboardingProvider.notifier).requestAllPermissions();
                    }
                  },
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: _finish,
            child: Text(
              'تخطي',
              style: TextStyle(color: AppTheme.goldPrimary.withValues(alpha: 0.6), fontSize: 14),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // SCREEN 3 — Finished (Navy/Gold theme)
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildFinishedScreen(
      double w, OnboardingState state, PermissionRequestController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w < 360 ? 20 : 28),
      child: Column(
        children: [
          const Spacer(flex: 2),
          _buildProgressDots(2),
          const SizedBox(height: 40),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 600),
            curve: Curves.elasticOut,
            builder: (context, value, child) =>
                Transform.scale(scale: value, child: child),
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppTheme.goldGradient,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.goldPrimary.withValues(alpha: 0.4),
                    blurRadius: 40,
                    spreadRadius: 4,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(Icons.check_rounded, size: 56, color: Colors.white),
            ),
          ),
          const SizedBox(height: 36),
          Text(
            'تم إعداد التطبيق بنجاح',
            style: GoogleFonts.cairo(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: AppTheme.glassCard(radius: 20),
            child: Column(
              children: _permissions
                  .where((p) => !p.isInformational)
                  .map((p) => [
                        _buildCheckItem(
                          p.title,
                          controller.status(p.key) == PermissionUIStatus.granted,
                        ),
                        const SizedBox(height: 14),
                      ])
                  .expand((e) => e)
                  .toList()
                ..removeLast(),
            ),
          ),
          const Spacer(flex: 3),
          _buildPrimaryButton(label: 'ابدأ استخدام التطبيق', onPressed: _finish),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // Shared Components
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildCompletionIndicator(PermissionRequestController controller) {
    final granted = controller.grantedCount;
    final total = controller.totalCount;
    final allDone = granted == total;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: granted.toDouble()),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        final displayCount = value.round();
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: Text(
                '$displayCount',
                key: ValueKey(displayCount),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: allDone ? AppTheme.goldPrimary : AppTheme.textPrimary,
                ),
              ),
            ),
            Text(
              ' / $total',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: AppTheme.textMuted.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              allDone ? 'تم التفعيل' : 'صلاحيات مفعّلة',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: allDone
                    ? AppTheme.goldPrimary
                    : AppTheme.textMuted.withValues(alpha: 0.6),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProgressDots(int current) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        final isActive = i == current;
        final isDone = i < current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isDone || isActive ? 28 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isDone || isActive
                ? AppTheme.goldPrimary
                : AppTheme.goldPrimary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  Widget _buildBlockedNotice() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.orange.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded, size: 18, color: Colors.orange),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'إشعارات الصلاة مطلوبة لتفعيل باقي الصلاحيات',
              style: TextStyle(
                fontSize: 12,
                color: Colors.orange.withValues(alpha: 0.8),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryButton({required String label, VoidCallback? onPressed}) {
    final isEnabled = onPressed != null;
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.goldPrimary,
          foregroundColor: AppTheme.bgPrimary,
          disabledBackgroundColor: AppTheme.goldPrimary.withValues(alpha: 0.4),
          disabledForegroundColor: AppTheme.bgPrimary.withValues(alpha: 0.6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          elevation: isEnabled ? 4 : 0,
          shadowColor: AppTheme.goldPrimary.withValues(alpha: 0.3),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            fontFamily: GoogleFonts.cairo().fontFamily,
          ),
        ),
      ),
    );
  }

  Widget _buildCheckItem(String label, bool granted) {
    return Row(
      children: [
        Icon(
          granted ? Icons.check_circle_rounded : Icons.cancel_rounded,
          size: 22,
          color: granted ? AppTheme.goldPrimary : AppTheme.textMuted.withValues(alpha: 0.4),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: granted ? AppTheme.textPrimary : AppTheme.textMuted.withValues(alpha: 0.5),
          ),
        ),
        const Spacer(),
        Text(
           granted ? '-' : '-',
          style: TextStyle(
            fontSize: 14,
            color: granted ? AppTheme.goldPrimary : AppTheme.textMuted.withValues(alpha: 0.3),
          ),
        ),
      ],
    );
  }
}

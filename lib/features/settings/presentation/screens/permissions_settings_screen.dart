import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../services/permission_service.dart';
import '../../../../theme/app_theme.dart';

class PermissionsSettingsScreen extends ConsumerStatefulWidget {
  const PermissionsSettingsScreen({super.key});

  @override
  ConsumerState<PermissionsSettingsScreen> createState() =>
      _PermissionsSettingsScreenState();
}

class _PermissionsSettingsScreenState
    extends ConsumerState<PermissionsSettingsScreen> {
  bool _notificationsGranted = false;
  bool _exactAlarmGranted = false;
  bool _batteryOptimized = false;
  bool _autoStartSupported = false;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    final notifications = await PermissionService.checkNotificationPermission();
    final exactAlarm = await PermissionService.checkExactAlarmPermission();
    final battery = await PermissionService.checkBatteryOptimizationExemption();
    final autoStart = PermissionService.supportsAutoStart;

    if (!mounted) return;
    setState(() {
      _notificationsGranted = notifications;
      _exactAlarmGranted = exactAlarm;
      _batteryOptimized = battery;
      _autoStartSupported = autoStart;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgPrimary,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildAppBar(),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 100),
                child: Column(
                  children: [
                    _buildPermissionCard(
                      icon: Icons.notifications_active_rounded,
                      title: 'إشعارات الصلاة',
                      description: 'تذكير بأوقات الصلاة وتشغيل الأذان',
                      isGranted: _notificationsGranted,
                      onGrant: () async {
                        await PermissionService.requestNotificationPermission();
                        await _checkPermissions();
                      },
                    ),
                    const SizedBox(height: 16),
                    if (!kIsWeb) ...[
                      _buildPermissionCard(
                        icon: Icons.alarm_rounded,
                        title: 'الأذان الدقيق',
                        description: 'تشغيل الأذان في الوقت الدقيق',
                        isGranted: _exactAlarmGranted,
                        onGrant: () async {
                          await PermissionService.requestExactAlarmPermission();
                          await _checkPermissions();
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildPermissionCard(
                        icon: Icons.battery_charging_full_rounded,
                        title: 'إلغاء تحسين البطارية',
                        description: 'منع Android من إيقاف الأذان في الخلفية',
                        isGranted: _batteryOptimized,
                        onGrant: () async {
                          await PermissionService.requestBatteryOptimizationExemption();
                          await _checkPermissions();
                        },
                      ),
                      if (_autoStartSupported) ...[
                        const SizedBox(height: 16),
                        _buildPermissionCard(
                          icon: Icons.power_rounded,
                          title: 'التشغيل التلقائي',
                          description: 'تشغيل التطبيق تلقائياً بعد إعادة تشغيل الجهاز',
                          isGranted: true,
                          onGrant: () async {
                            await PermissionService.openAutoStartSettings();
                          },
                        ),
                      ],
                    ],
                    const SizedBox(height: 24),
                    _buildInfoCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: true,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.arrow_forward_ios_rounded, size: 20),
        color: AppTheme.goldPrimary,
      ),
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
        title: Text(
          'صلاحيات التطبيق',
          style: GoogleFonts.notoKufiArabic(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.goldPrimary,
          ),
        ),
        centerTitle: true,
      ),
    );
  }

  Widget _buildPermissionCard({
    required IconData icon,
    required String title,
    required String description,
    required bool isGranted,
    required VoidCallback onGrant,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.bgCard.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isGranted
              ? const Color(0xFF2ECC71).withValues(alpha: 0.2)
              : AppTheme.goldPrimary.withValues(alpha: 0.12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.goldPrimary.withValues(alpha: 0.15),
                      AppTheme.goldPrimary.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, size: 24, color: AppTheme.goldPrimary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.notoKufiArabic(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                isGranted
                    ? Icons.check_circle_rounded
                    : Icons.cancel_rounded,
                size: 20,
                color: isGranted
                    ? const Color(0xFF2ECC71)
                    : Colors.orange,
              ),
              const SizedBox(width: 8),
              Text(
                isGranted ? '✓ مفعل' : '⚠ غير مفعل',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isGranted
                      ? const Color(0xFF2ECC71)
                      : Colors.orange,
                ),
              ),
              const Spacer(),
              if (!isGranted)
                ElevatedButton(
                  onPressed: onGrant,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.goldPrimary,
                    foregroundColor: AppTheme.bgPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'تفعيل',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              if (isGranted)
                TextButton(
                  onPressed: onGrant,
                  child: Text(
                    'تعديل',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.goldPrimary.withValues(alpha: 0.7),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.goldPrimary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.goldPrimary.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 20,
            color: AppTheme.goldPrimary.withValues(alpha: 0.6),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'بعض الصلاحيات اختيارية لكنها مطلوبة لعمل الأذان بشكل موثوق',
              style: TextStyle(
                fontSize: 13,
                color: AppTheme.textMuted.withValues(alpha: 0.7),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

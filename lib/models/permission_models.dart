import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../services/permission_service.dart';

// ═══════════════════════════════════════════════════════════════════
// Permission Key
// ═══════════════════════════════════════════════════════════════════

enum PermissionKey { notifications, exactAlarm, battery, foreground }

// ═══════════════════════════════════════════════════════════════════
// Permission Definition
// ═══════════════════════════════════════════════════════════════════

class PermissionDefinition {
  final PermissionKey key;
  final IconData icon;
  final String title;
  final String subtitle;
  final bool showRetry;
  final bool isRequestable;
  final bool isInformational;

  const PermissionDefinition({
    required this.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.showRetry = true,
    this.isRequestable = true,
    this.isInformational = false,
  });
}

// ═══════════════════════════════════════════════════════════════════
// Platform Permission Registry
// ═══════════════════════════════════════════════════════════════════

class PermissionRegistry {
  PermissionRegistry._();

  static bool get _isAndroid =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  static bool get _isIOS =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

  // ── Onboarding Permissions ──────────────────────────────────────

  static List<PermissionDefinition> onboardingPermissions() {
    if (_isAndroid) return _androidOnboarding;
    if (_isIOS) return _iosOnboarding;
    return _webOnboarding;
  }

  static final _androidOnboarding = [
    const PermissionDefinition(
      key: PermissionKey.notifications,
      icon: Icons.notifications_active_rounded,
      title: 'الإشعارات',
      subtitle: 'لإعلامك بدخول وقت الصلاة',
    ),
    const PermissionDefinition(
      key: PermissionKey.exactAlarm,
      icon: Icons.alarm_rounded,
      title: 'التنبيهات الدقيقة',
      subtitle: 'لضمان تشغيل الأذان في وقته',
    ),
    const PermissionDefinition(
      key: PermissionKey.battery,
      icon: Icons.battery_charging_full_rounded,
      title: 'إلغاء تحسين البطارية',
      subtitle: 'لمنع إيقاف الأذان في الخلفية',
    ),
    const PermissionDefinition(
      key: PermissionKey.foreground,
      icon: Icons.lock_open_rounded,
      title: 'العمل أثناء قفل الشاشة',
      subtitle: 'ليستمر الأذان حتى عند قفل الهاتف',
      showRetry: false,
      isRequestable: false,
    ),
  ];

  static final _iosOnboarding = [
    const PermissionDefinition(
      key: PermissionKey.notifications,
      icon: Icons.notifications_active_rounded,
      title: 'الإشعارات',
      subtitle: 'لإعلامك بدخول وقت الصلاة',
    ),
    const PermissionDefinition(
      key: PermissionKey.foreground,
      icon: Icons.refresh_rounded,
      title: 'التحديث في الخلفية',
      subtitle: 'للحفاظ على دقة مواعيد الصلاة',
      showRetry: false,
      isRequestable: false,
    ),
  ];

  static final _webOnboarding = [
    const PermissionDefinition(
      key: PermissionKey.notifications,
      icon: Icons.notifications_active_rounded,
      title: 'الإشعارات',
      subtitle: 'لإعلامك بدخول وقت الصلاة',
    ),
  ];

  // ── Settings Permissions ────────────────────────────────────────

  static List<PermissionDefinition> settingsPermissions() {
    final list = <PermissionDefinition>[];
    if (_isAndroid) {
      list.addAll(_androidSettings);
    } else if (_isIOS) {
      list.addAll(_iosSettings);
    } else {
      list.addAll(_webSettings);
    }
    if (_isAndroid) list.add(_autoStart);
    return list;
  }

  static final _androidSettings = [
    const PermissionDefinition(
      key: PermissionKey.notifications,
      icon: Icons.notifications_active_rounded,
      title: 'إشعارات الصلاة',
      subtitle: 'تذكير بأوقات الصلاة وتشغيل الأذان',
    ),
    const PermissionDefinition(
      key: PermissionKey.exactAlarm,
      icon: Icons.alarm_rounded,
      title: 'الأذان الدقيق',
      subtitle: 'تشغيل الأذان في الوقت الدقيق',
    ),
    const PermissionDefinition(
      key: PermissionKey.battery,
      icon: Icons.battery_charging_full_rounded,
      title: 'إلغاء تحسين البطارية',
      subtitle: 'منع Android من إيقاف الأذان في الخلفية',
    ),
  ];

  static final _iosSettings = [
    const PermissionDefinition(
      key: PermissionKey.notifications,
      icon: Icons.notifications_active_rounded,
      title: 'إشعارات الصلاة',
      subtitle: 'تذكير بأوقات الصلاة وتشغيل الأذان',
    ),
  ];

  static final _webSettings = [
    const PermissionDefinition(
      key: PermissionKey.notifications,
      icon: Icons.notifications_active_rounded,
      title: 'إشعارات الصلاة',
      subtitle: 'تذكير بأوقات الصلاة',
    ),
  ];

  static const _autoStart = PermissionDefinition(
    key: PermissionKey.foreground,
    icon: Icons.power_rounded,
    title: 'التشغيل التلقائي',
    subtitle: 'تشغيل التطبيق تلقائياً بعد إعادة تشغيل الجهاز',
    showRetry: false,
    isRequestable: false,
    isInformational: true,
  );

  // ── Check Function Mapping ─────────────────────────────────────

  static Future<bool> checkPermission(PermissionKey key) async {
    switch (key) {
      case PermissionKey.notifications:
        return PermissionService.checkNotificationPermission();
      case PermissionKey.exactAlarm:
        return PermissionService.checkExactAlarmPermission();
      case PermissionKey.battery:
        return PermissionService.checkBatteryOptimizationExemption();
      case PermissionKey.foreground:
        return true;
    }
  }

  // ── Request Function Mapping ───────────────────────────────────

  static Future<bool> requestPermission(PermissionKey key) async {
    switch (key) {
      case PermissionKey.notifications:
        return PermissionService.requestNotificationPermission();
      case PermissionKey.exactAlarm:
        await PermissionService.requestExactAlarmPermission();
        return PermissionService.checkExactAlarmPermission();
      case PermissionKey.battery:
        return PermissionService.requestBatteryOptimizationExemption();
      case PermissionKey.foreground:
        return true;
    }
  }
}

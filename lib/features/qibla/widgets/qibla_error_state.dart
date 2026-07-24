import 'package:flutter/material.dart';
import '../models/qibla_models.dart';

class QiblaErrorState extends StatelessWidget {
  final QiblaStatus status;
  final VoidCallback onRetry;
  final String? errorMessage;

  const QiblaErrorState({
    super.key,
    required this.status,
    required this.onRetry,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getConfig(status);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: config.color.withValues(alpha: 0.10),
              ),
              child: Icon(config.icon, color: config.color, size: 40),
            ),
            const SizedBox(height: 24),
            Text(
              config.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: QiblaColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              config.subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                height: 1.7,
                color: QiblaColors.textSecondary,
              ),
            ),
            const SizedBox(height: 28),
            GestureDetector(
              onTap: onRetry,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                decoration: BoxDecoration(
                  gradient: QiblaColors.goldGradient,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  config.buttonText,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: QiblaColors.background,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _ErrorConfig _getConfig(QiblaStatus status) {
    switch (status) {
      case QiblaStatus.noSensor:
        return _ErrorConfig(
          icon: Icons.sensors_off_rounded,
          color: QiblaColors.lightGold,
          title: 'الجهاز لا يدعم بوصلة',
          subtitle: 'جهازك لا يحتوي على مستشعر بوصلة',
          buttonText: 'حسناً',
        );
      case QiblaStatus.noPermission:
        return _ErrorConfig(
          icon: Icons.location_disabled_rounded,
          color: QiblaColors.gold,
          title: 'فعّل خدمة الموقع',
          subtitle: 'الرجاء منح صلاحية الموقع من إعدادات الجهاز',
          buttonText: 'إعادة المحاولة',
        );
      case QiblaStatus.permanentlyDenied:
        return _ErrorConfig(
          icon: Icons.location_off_rounded,
          color: QiblaColors.danger,
          title: 'تم حظر صلاحية الموقع',
          subtitle: 'افتح إعدادات الجهاز وافعّل صلاحية الموقع يدوياً',
          buttonText: 'فتح الإعدادات',
        );
      case QiblaStatus.noGps:
        return _ErrorConfig(
          icon: Icons.gps_off_rounded,
          color: QiblaColors.textSecondary,
          title: 'خدمة الموقع مطفأة',
          subtitle: 'افتح خدمة الموقع من إعدادات الجهاز',
          buttonText: 'إعادة المحاولة',
        );
      default:
        return _ErrorConfig(
          icon: Icons.error_outline_rounded,
          color: QiblaColors.danger,
          title: 'حدث خطأ',
          subtitle: errorMessage ?? 'تحقق من إعدادات الجهاز وحاول مرة أخرى',
          buttonText: 'إعادة المحاولة',
        );
    }
  }
}

class _ErrorConfig {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final String buttonText;

  const _ErrorConfig({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.buttonText,
  });
}

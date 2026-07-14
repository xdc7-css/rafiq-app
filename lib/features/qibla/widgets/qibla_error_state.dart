import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    final isSensorError = status == QiblaStatus.noSensor;
    final isPermDenied = status == QiblaStatus.permanentlyDenied;
    final isNoPermission = status == QiblaStatus.noPermission;
    final isNoGps = status == QiblaStatus.noGps;

    final title = isSensorError
        ? 'الجهاز لا يدعم بوصلة'
        : isPermDenied
            ? 'تم حظر صلاحية الموقع'
            : isNoPermission
                ? 'فعّل خدمة الموقع'
                : isNoGps
                    ? 'خدمة الموقع مطفأة'
                    : 'حدث خطأ';

    final subtitle = isSensorError
        ? 'جهازك لا يحتوي على مستشعر بوصلة hardware'
        : isPermDenied
            ? 'تم رفض الصلاحية نهائياً — افتح إعدادات الجهاز وافعّل صلاحية الموقع يدوياً'
            : isNoPermission
                ? 'الرجاء منح صلاحية الموقع من إعدادات الجهاز'
                : isNoGps
                    ? 'خدمة الموقع مطفأة — افتحها من الإعدادات'
                    : errorMessage ?? 'تحقق من إعدادات الجهاز وحاول مرة أخرى';

    final icon = isSensorError
        ? Icons.sensors_off_rounded
        : isPermDenied
            ? Icons.location_off_rounded
            : isNoPermission
                ? Icons.location_disabled_rounded
                : isNoGps
                    ? Icons.location_off_rounded
                    : Icons.error_outline_rounded;

    final color = isSensorError
        ? Colors.amberAccent
        : isPermDenied
            ? Colors.redAccent
            : isNoPermission
                ? Colors.orangeAccent
                : isNoGps
                    ? Colors.cyanAccent
                    : Colors.redAccent;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [
            QiblaColors.accentGold.withValues(alpha: 0.04),
            Colors.transparent,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: QiblaColors.accentGold.withValues(alpha: 0.18),
          width: 0.6,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      color.withValues(alpha: 0.08),
                      color.withValues(alpha: 0.01),
                    ],
                    stops: const [0.3, 1.0],
                  ),
                ),
                child: Icon(icon, color: color, size: 38),
              ),
              const SizedBox(height: 18),
              Text(
                title,
                style: GoogleFonts.notoKufiArabic(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: QiblaColors.textPrimary,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.notoKufiArabic(
                  fontSize: 12,
                  height: 1.8,
                  color: QiblaColors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: onRetry,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFD4AF37), Color(0xFFF2C94C)],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    isPermDenied ? 'فتح الإعدادات' : 'إعادة المحاولة',
                    style: GoogleFonts.notoKufiArabic(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: QiblaColors.compassBg,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

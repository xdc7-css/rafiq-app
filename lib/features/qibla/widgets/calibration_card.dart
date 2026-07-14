import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../painters/calibration_painter.dart';
import '../models/qibla_models.dart';

class CalibrationCard extends StatelessWidget {
  final double progress;
  final VoidCallback onCalibrate;

  const CalibrationCard({
    super.key,
    required this.progress,
    required this.onCalibrate,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: const AlwaysStoppedAnimation(0),
      builder: (_, __) {
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: QiblaColors.accentGold.withValues(alpha: 0.18)),
            boxShadow: [
              BoxShadow(
                color: AppThemeCalibration.shadowDark,
                blurRadius: 22,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  gradient: LinearGradient(
                    colors: [QiblaColors.accentGold.withValues(alpha: 0.05), Colors.transparent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    SizedBox(
                      width: 56,
                      height: 56,
                      child: CustomPaint(
                        painter: CalibrationPainter(progress),
                        size: const Size(56, 56),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'معايرة البوصلة',
                            style: GoogleFonts.notoKufiArabic(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: QiblaColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'حرك الهاتف بشكل ∞ لمعايرة البوصلة',
                            style: GoogleFonts.notoKufiArabic(
                              fontSize: 9.5,
                              color: QiblaColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        onCalibrate();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                        decoration: BoxDecoration(
                          gradient: QiblaColors.accentGold == Colors.transparent
                              ? null
                              : const LinearGradient(
                                  colors: [Color(0xFFD4AF37), Color(0xFFF2C94C)],
                                ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'معايرة',
                          style: GoogleFonts.notoKufiArabic(
                            fontSize: 10,
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
          ),
        );
      },
    );
  }
}

class AppThemeCalibration {
  AppThemeCalibration._();
  static Color get shadowDark => Colors.black.withValues(alpha: 0.28);
}

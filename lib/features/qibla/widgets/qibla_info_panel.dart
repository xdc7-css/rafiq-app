import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/qibla_models.dart';

class QiblaInfoPanel extends StatelessWidget {
  final String? city;
  final String? country;
  final double qiblahAngle;
  final String cardinal;
  final bool hasLocation;

  const QiblaInfoPanel({
    super.key,
    this.city,
    this.country,
    required this.qiblahAngle,
    required this.cardinal,
    this.hasLocation = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: [
            QiblaColors.accentGold.withValues(alpha: 0.05),
            Colors.transparent,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: QiblaColors.accentGold.withValues(alpha: 0.12),
          width: 0.6,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Angle display
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '${qiblahAngle.round()}°',
                    style: GoogleFonts.inter(
                      fontSize: 38,
                      fontWeight: FontWeight.w800,
                      color: QiblaColors.accentGold,
                      letterSpacing: -2,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    cardinal,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: QiblaColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),

              Text(
                'اتجاه القبلة',
                style: GoogleFonts.notoKufiArabic(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: QiblaColors.textPrimary,
                ),
              ),

              const SizedBox(height: 10),

              // Divider
              Container(
                width: double.infinity,
                height: 1,
                color: QiblaColors.textSecondary.withValues(alpha: 0.08),
              ),

              const SizedBox(height: 10),

              // Location info
              if (hasLocation && city != null && country != null) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on_rounded,
                        color: QiblaColors.accentGold.withValues(alpha: 0.6), size: 15),
                    const SizedBox(width: 5),
                    Text(
                      '$city، $country',
                      style: GoogleFonts.notoKufiArabic(
                        fontSize: 11,
                        color: QiblaColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ] else ...[
                Icon(Icons.location_off_rounded,
                    color: QiblaColors.textSecondary.withValues(alpha: 0.35), size: 15),
                const SizedBox(height: 1),
                Text(
                  ' gps غير مُفعّل',
                  style: GoogleFonts.notoKufiArabic(
                    fontSize: 9,
                    color: QiblaColors.textSecondary.withValues(alpha: 0.35),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/oem_reliability_service.dart';
import '../services/permission_analytics_service.dart';
import '../theme/app_theme.dart';

/// Premium informational card for aggressive OEM devices.
///
/// Only renders when [OEMReliabilityService.needsGuidance] is true.
/// Hidden on unsupported platforms and well-behaved manufacturers.
class OEMGuidanceCard extends StatelessWidget {
  const OEMGuidanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final guidance = OEMReliabilityService.guidance;
    if (guidance == null) return const SizedBox.shrink();

    final w = MediaQuery.sizeOf(context).width;
    final pad = w < 360 ? 16.0 : 20.0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(pad),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.goldPrimary.withValues(alpha: 0.08),
            AppTheme.goldPrimary.withValues(alpha: 0.03),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.goldPrimary.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.goldPrimary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.shield_rounded,
                  size: 20,
                  color: AppTheme.goldPrimary.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  guidance.title,
                  style: GoogleFonts.notoKufiArabic(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            guidance.message,
            style: GoogleFonts.notoKufiArabic(
              fontSize: 13,
              color: AppTheme.textMuted.withValues(alpha: 0.7),
              height: 1.6,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                PermissionAnalyticsService.manufacturerGuidanceOpened(
                  OEMReliabilityService.manufacturer,
                );
                OEMReliabilityService.openBatterySettings();
                PermissionAnalyticsService.batterySettingsOpened();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.goldPrimary,
                foregroundColor: AppTheme.bgPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
                elevation: 0,
              ),
              child: Text(
                guidance.actionLabel,
                style: GoogleFonts.notoKufiArabic(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../services/adhan_battery_helper.dart';
import '../../../../theme/app_theme.dart';

/// Screen that helps users enable battery optimization exemptions
/// so the adhan service runs reliably on OEM devices.
///
/// Shows device diagnostics, battery optimization status,
/// and manufacturer-specific step-by-step instructions.
class AdhanReliabilityScreen extends StatefulWidget {
  const AdhanReliabilityScreen({super.key});

  @override
  State<AdhanReliabilityScreen> createState() => _AdhanReliabilityScreenState();
}

class _AdhanReliabilityScreenState extends State<AdhanReliabilityScreen> {
  DeviceDiagnostics? _diagnostics;
  bool _isLoading = true;
  OemSettingsOutcome? _lastOutcome;
  bool _hasOpenedSettings = false;

  @override
  void initState() {
    super.initState();
    _loadDiagnostics();
  }

  Future<void> _loadDiagnostics() async {
    final diag = await AdhanBatteryHelper.instance.getDeviceDiagnostics();
    if (!mounted) return;
    setState(() {
      _diagnostics = diag;
      _isLoading = false;
    });
  }

  Future<void> _openSettings() async {
    final outcome =
        await AdhanBatteryHelper.instance.openBatteryOptimizationSettings();
    if (!mounted) return;
    setState(() {
      _lastOutcome = outcome;
      _hasOpenedSettings = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'تحسين موثوقية الأذان',
            style: GoogleFonts.notoKufiArabic(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.goldPrimary,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_forward_ios_rounded,
                color: AppTheme.goldPrimary, size: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: _isLoading
            ? Center(
                child:
                    CircularProgressIndicator(color: AppTheme.goldPrimary))
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBatteryStatusCard(),
                    const SizedBox(height: 16),
                    _buildDeviceCard(),
                    const SizedBox(height: 16),
                    if (_lastOutcome != null) ...[
                      _buildActionStatusCard(),
                      const SizedBox(height: 16),
                    ],
                    _buildInstructionsCard(),
                    const SizedBox(height: 24),
                    _buildOpenButton(),
                    if (_hasOpenedSettings) ...[
                      const SizedBox(height: 16),
                      _buildFollowUp(),
                    ],
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildBatteryStatusCard() {
    final diag = _diagnostics;
    if (diag == null) return const SizedBox.shrink();

    final isOptimized = diag.isIgnoringBatteryOptimizations;
    final color = isOptimized ? Colors.orange : Colors.green;
    final icon = isOptimized
        ? Icons.battery_alert_rounded
        : Icons.battery_std_rounded;
    final title = isOptimized ? 'البطارية مقيدة' : 'البطارية مُثبّتة';
    final subtitle = isOptimized
        ? 'نظام البطارية يقيد التطبيق — قد لا يعمل الأذان'
        : 'التطبيق غير مقيد by البطارية — يعمل بشكل طبيعي';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.notoKufiArabic(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.notoKufiArabic(
                    fontSize: 12,
                    color: AppTheme.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceCard() {
    final diag = _diagnostics;
    if (diag == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.goldPrimary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.goldPrimary.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.phone_android_rounded,
                  color: AppTheme.goldPrimary, size: 24),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  diag.manufacturer,
                  style: GoogleFonts.notoKufiArabic(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              if (diag.isSupportedOem)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'مدعوم',
                    style: GoogleFonts.notoKufiArabic(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.greenAccent,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          _buildInfoRow('الطراز', diag.model.isNotEmpty ? diag.model : diag.manufacturerRaw),
          _buildInfoRow('Android', '${diag.androidVersion} (SDK ${diag.sdkInt})'),
          if (diag.isHarmonyOs)
            _buildInfoRow('النظام', 'HarmonyOS'),
          if (diag.brand.isNotEmpty && diag.brand != diag.manufacturerRaw)
            _buildInfoRow('العلامة التجارية', diag.brand),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: GoogleFonts.notoKufiArabic(
              fontSize: 11,
              color: AppTheme.textMuted,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.notoKufiArabic(
                fontSize: 11,
                color: Colors.white.withValues(alpha: 0.7),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionStatusCard() {
    final outcome = _lastOutcome;
    if (outcome == null) return const SizedBox.shrink();

    final (color, icon, text) = switch (outcome.result) {
      OemSettingsResult.openedOemSettings => (
          Colors.green,
          Icons.check_circle_outline_rounded,
          'تم فتح إعدادات الجهاز بنجاح',
        ),
      OemSettingsResult.openedBatterySettings => (
          Colors.blue,
          Icons.battery_std_rounded,
          'تم فتح إعدادات البطارية',
        ),
      OemSettingsResult.openedAppSettings => (
          Colors.orange,
          Icons.settings_applications_rounded,
          'تم فتح إعدادات التطبيق',
        ),
      OemSettingsResult.unsupportedDevice => (
          Colors.orange,
          Icons.warning_amber_rounded,
          'جهاز غير مدعوم — استخدم الإعدادات القياسية',
        ),
      OemSettingsResult.failed => (
          Colors.red,
          Icons.error_outline_rounded,
          'فشل فتح الإعدادات — حاول يدوياً',
        ),
    };

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.notoKufiArabic(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionsCard() {
    final diag = _diagnostics;
    if (diag == null || diag.instructions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.bgCard.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.goldPrimary.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline_rounded,
                  color: AppTheme.goldPrimary, size: 18),
              const SizedBox(width: 8),
              Text(
                'خطوات التفعيل على ${diag.manufacturer}',
                style: GoogleFonts.notoKufiArabic(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.goldPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            diag.instructionsSummary,
            style: GoogleFonts.notoKufiArabic(
              fontSize: 12,
              color: AppTheme.textMuted,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          ...diag.instructions.asMap().entries.map((entry) {
            final index = entry.key;
            final step = entry.value;
            return _buildStepTile(index + 1, step);
          }),
        ],
      ),
    );
  }

  Widget _buildStepTile(int stepNumber, InstructionStep step) {
    final iconData = _getStepIcon(step.icon);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppTheme.goldPrimary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '$stepNumber',
                style: GoogleFonts.notoKufiArabic(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.goldPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(iconData, color: AppTheme.goldPrimary, size: 14),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        step.title,
                        style: GoogleFonts.notoKufiArabic(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  step.description,
                  style: GoogleFonts.notoKufiArabic(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.7),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getStepIcon(String icon) {
    switch (icon) {
      case 'power':
        return Icons.power_settings_new_rounded;
      case 'battery':
        return Icons.battery_std_rounded;
      case 'background':
        return Icons.layers_rounded;
      case 'notification':
        return Icons.notifications_active_rounded;
      case 'lock':
        return Icons.lock_outline_rounded;
      case 'freeze':
        return Icons.ac_unit_rounded;
      default:
        return Icons.info_outline_rounded;
    }
  }

  Widget _buildOpenButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _openSettings,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.goldPrimary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.battery_charging_full_rounded, size: 20),
            const SizedBox(width: 8),
            Text(
              'افتح إعدادات البطارية',
              style: GoogleFonts.notoKufiArabic(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFollowUp() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.amber.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_outline_rounded,
              color: Colors.amber.shade400, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'بعد فتح الإعدادات، اتبع الخطوات أعلاه لتفعيل تشغيل التطبيق في الخلفية ثم عد إلى التطبيق.',
              style: GoogleFonts.notoKufiArabic(
                fontSize: 12,
                color: Colors.amber.shade300,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/adhan_health_report.dart';
import '../../data/services/adhan_health_helper.dart';
import '../../../../theme/app_theme.dart';

/// Premium adhan health diagnostics dashboard.
///
/// Displays a professional diagnostic UI with expandable section cards,
/// health score gauge, and per-check status indicators.
class AdhanHealthScreen extends StatefulWidget {
  const AdhanHealthScreen({super.key});

  @override
  State<AdhanHealthScreen> createState() => _AdhanHealthScreenState();
}

class _AdhanHealthScreenState extends State<AdhanHealthScreen> {
  AdhanHealthReport? _report;
  bool _isLoading = true;
  final Set<String> _expandedSections = {'device', 'permissions', 'scheduling'};

  @override
  void initState() {
    super.initState();
    _loadReport();
  }

  Future<void> _loadReport() async {
    setState(() => _isLoading = true);
    final report = await AdhanHealthHelper.instance.getHealthReport();
    if (!mounted) return;
    setState(() {
      _report = report;
      _isLoading = false;
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
            'تشخيص الأذان',
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
          actions: [
            IconButton(
              icon: Icon(Icons.refresh_rounded,
                  color: AppTheme.goldPrimary, size: 20),
              onPressed: _loadReport,
            ),
          ],
        ),
        body: _isLoading
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: AppTheme.goldPrimary),
                    const SizedBox(height: 16),
                    Text(
                      'جاري الفحص...',
                      style: GoogleFonts.notoKufiArabic(
                        fontSize: 14,
                        color: AppTheme.textMuted,
                      ),
                    ),
                  ],
                ),
              )
            : _report == null
                ? _buildEmptyState()
                : _buildReport(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.health_and_safety_rounded,
              color: AppTheme.textMuted, size: 48),
          const SizedBox(height: 16),
          Text(
            'لا توجد بيانات',
            style: GoogleFonts.notoKufiArabic(
              fontSize: 16,
              color: AppTheme.textMuted,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _loadReport,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.goldPrimary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'إعادة المحاولة',
              style: GoogleFonts.notoKufiArabic(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReport() {
    final report = _report!;
    final grouped = report.checksBySection;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildScoreGauge(report),
          const SizedBox(height: 16),
          _buildSummaryRow(report),
          const SizedBox(height: 24),
          ..._sectionOrder.map((section) {
            final checks = grouped[section];
            if (checks == null || checks.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildSectionCard(section, checks),
            );
          }),
        ],
      ),
    );
  }

  static const _sectionOrder = [
    'device',
    'oem',
    'permissions',
    'alarm',
    'battery',
    'notifications',
    'scheduling',
  ];

  static const _sectionLabels = {
    'device': 'الجهاز',
    'oem': 'النظام',
    'permissions': 'الصلاحيات',
    'alarm': 'المنبّه',
    'battery': 'البطارية',
    'notifications': 'الإشعارات',
    'scheduling': 'الجدولة',
  };

  static const _sectionIcons = {
    'device': Icons.phone_android_rounded,
    'oem': Icons.settings_input_component_rounded,
    'permissions': Icons.admin_panel_settings_rounded,
    'alarm': Icons.alarm_rounded,
    'battery': Icons.battery_std_rounded,
    'notifications': Icons.notifications_active_rounded,
    'scheduling': Icons.schedule_rounded,
  };

  Widget _buildScoreGauge(AdhanHealthReport report) {
    final color = _scoreColor(report.overallScore);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Column(
        children: [
          SizedBox(
            width: 120,
            height: 120,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: CircularProgressIndicator(
                    value: report.overallScore / 100,
                    strokeWidth: 8,
                    backgroundColor: color.withValues(alpha: 0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${report.overallScore}',
                      style: GoogleFonts.notoKufiArabic(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    Text(
                      report.levelLabel,
                      style: GoogleFonts.notoKufiArabic(
                        fontSize: 12,
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(AdhanHealthReport report) {
    return Row(
      children: [
        _buildSummaryChip('سليم', report.healthyCount, Colors.green),
        const SizedBox(width: 8),
        _buildSummaryChip('تحذير', report.warningCount, Colors.orange),
        const SizedBox(width: 8),
        _buildSummaryChip('خطأ', report.errorCount, Colors.red),
        const SizedBox(width: 8),
        _buildSummaryChip('غير معروف', report.unknownCount, Colors.grey),
      ],
    );
  }

  Widget _buildSummaryChip(String label, int count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.15)),
        ),
        child: Column(
          children: [
            Text(
              '$count',
              style: GoogleFonts.notoKufiArabic(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.notoKufiArabic(
                fontSize: 10,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(String section, List<HealthCheck> checks) {
    final isExpanded = _expandedSections.contains(section);
    final sectionHealthy = checks.every((c) => c.status == HealthStatus.healthy);
    final sectionColor = sectionHealthy ? Colors.green : Colors.orange;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.bgCard.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.goldPrimary.withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                if (isExpanded) {
                  _expandedSections.remove(section);
                } else {
                  _expandedSections.add(section);
                }
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Icon(
                    _sectionIcons[section] ?? Icons.help_outline_rounded,
                    color: AppTheme.goldPrimary,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _sectionLabels[section] ?? section,
                      style: GoogleFonts.notoKufiArabic(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: sectionColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${checks.length}',
                      style: GoogleFonts.notoKufiArabic(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: sectionColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: AppTheme.textMuted,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            Divider(
                height: 1,
                color: AppTheme.goldPrimary.withValues(alpha: 0.08)),
            ...checks.map((check) => _buildCheckRow(check)),
          ],
        ],
      ),
    );
  }

  Widget _buildCheckRow(HealthCheck check) {
    final (color, icon) = _statusVisual(check.status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppTheme.goldPrimary.withValues(alpha: 0.04),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  check.title,
                  style: GoogleFonts.notoKufiArabic(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ),
              if (check.value.isNotEmpty)
                Text(
                  check.value,
                  style: GoogleFonts.notoKufiArabic(
                    fontSize: 11,
                    color: AppTheme.textMuted,
                  ),
                ),
            ],
          ),
          if (check.description.isNotEmpty) ...[
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(right: 24),
              child: Text(
                check.description,
                style: GoogleFonts.notoKufiArabic(
                  fontSize: 11,
                  color: AppTheme.textMuted,
                  height: 1.4,
                ),
              ),
            ),
          ],
          if (check.recommendation.isNotEmpty) ...[
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(right: 24),
              child: Row(
                children: [
                  Icon(Icons.lightbulb_outline_rounded,
                      color: Colors.amber.shade400, size: 12),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      check.recommendation,
                      style: GoogleFonts.notoKufiArabic(
                        fontSize: 10,
                        color: Colors.amber.shade300,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  (Color, IconData) _statusVisual(HealthStatus status) {
    switch (status) {
      case HealthStatus.healthy:
        return (Colors.green, Icons.check_circle_outline_rounded);
      case HealthStatus.warning:
        return (Colors.orange, Icons.warning_amber_rounded);
      case HealthStatus.error:
        return (Colors.red, Icons.error_outline_rounded);
      case HealthStatus.unknown:
        return (Colors.grey, Icons.help_outline_rounded);
    }
  }

  Color _scoreColor(int score) {
    if (score >= 90) return Colors.green;
    if (score >= 75) return Colors.lightGreen;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }
}

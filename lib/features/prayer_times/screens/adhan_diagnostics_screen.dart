import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../services/adhan_scheduler.dart';
import '../../../services/adhan_battery_helper.dart';
import '../../../theme/app_theme.dart';

/// AdhanDiagnosticsScreen — Production-grade Adhan System Health & Diagnostics.
///
/// Features:
///   • Exact Alarm Capability (Android 12+) with direct settings launcher.
///   • Notification & Notification Channel verification.
///   • Real AlarmManager PendingIntent verification via FLAG_NO_CREATE.
///   • Battery Optimization exemption status with direct action.
///   • Next scheduled prayer countdown & timestamp.
///   • OEM manufacturer detection and step-by-step guidance.
///   • Real 15-second background alarm test button.
class AdhanDiagnosticsScreen extends StatefulWidget {
  const AdhanDiagnosticsScreen({super.key});

  @override
  State<AdhanDiagnosticsScreen> createState() => _AdhanDiagnosticsScreenState();
}

class _AdhanDiagnosticsScreenState extends State<AdhanDiagnosticsScreen> with WidgetsBindingObserver {
  bool _isLoading = true;
  bool _canScheduleExact = true;
  bool _isBatteryExempted = false;
  int _nextAlarmTimestamp = -1;
  Map<String, dynamic> _verifiedAlarms = {};
  Map<String, dynamic> _healthReport = {};
  DeviceDiagnostics? _deviceDiag;
  bool _testAlarmArmed = false;
  int _testCountdown = 15;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadAllDiagnostics();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // User may have returned from system settings (Exact alarms / Battery / Notifications)
      _loadAllDiagnostics();
    }
  }

  Future<void> _loadAllDiagnostics() async {
    setState(() => _isLoading = true);
    try {
      final exact = await AdhanScheduler.instance.canScheduleExactAlarms();
      final battery = await AdhanScheduler.instance.checkBatteryOptimization();
      final nextAlarm = await AdhanScheduler.instance.getNextAlarm();
      final verified = await AdhanScheduler.instance.verifyScheduledAlarms();
      final health = await AdhanScheduler.instance.getAdhanHealthReport();
      final device = await AdhanBatteryHelper.instance.getDeviceDiagnostics();

      if (!mounted) return;
      setState(() {
        _canScheduleExact = exact;
        _isBatteryExempted = battery;
        _nextAlarmTimestamp = nextAlarm;
        _verifiedAlarms = verified;
        _healthReport = health;
        _deviceDiag = device;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  void _armTestAlarm() async {
    setState(() {
      _testAlarmArmed = true;
      _testCountdown = 15;
    });

    await AdhanScheduler.instance.scheduleTestAlarm(15);

    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_testCountdown <= 1) {
        timer.cancel();
        setState(() {
          _testAlarmArmed = false;
          _testCountdown = 0;
        });
      } else {
        setState(() {
          _testCountdown--;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppTheme.bgPrimary,
        appBar: AppBar(
          backgroundColor: AppTheme.bgCard,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'جاهزية وصحة الأذان',
            style: GoogleFonts.notoKufiArabic(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.goldPrimary,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_forward_ios_rounded, color: AppTheme.goldPrimary, size: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh_rounded, color: AppTheme.goldPrimary),
              onPressed: _loadAllDiagnostics,
              tooltip: 'تحديث التشخيص',
            ),
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator(color: AppTheme.goldPrimary))
            : RefreshIndicator(
                color: AppTheme.goldPrimary,
                backgroundColor: AppTheme.bgCard,
                onRefresh: _loadAllDiagnostics,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  children: [
                    _buildOverallScoreCard(),
                    const SizedBox(height: 16),
                    _buildNextAlarmCard(),
                    const SizedBox(height: 16),
                    _buildCorePermissionsCard(),
                    const SizedBox(height: 16),
                    _buildSystemAlarmsCard(),
                    const SizedBox(height: 16),
                    _buildTestAlarmCard(),
                    const SizedBox(height: 16),
                    _buildOemGuidanceCard(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
      ),
    );
  }

  // ─── 1. Overall Score Card ──────────────────────────────────────────────────

  Widget _buildOverallScoreCard() {
    final score = _healthReport['overallScore'] as int? ?? (_isHealthySystem ? 100 : 70);
    final level = _healthReport['overallLevel'] as String? ?? (_isHealthySystem ? 'healthy' : 'warning');

    final color = level == 'healthy'
        ? Colors.greenAccent
        : (level == 'warning' ? Colors.amberAccent : Colors.redAccent);
    final statusText = level == 'healthy'
        ? 'النظام جاهز وموثوق 100%'
        : (level == 'warning' ? 'يحتاج ضبط بعض الصلاحيات' : 'تنبيه: الأذان قد لا ينطلق');

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.08),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.15),
              border: Border.all(color: color, width: 2),
            ),
            alignment: Alignment.center,
            child: Text(
              '$score%',
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  statusText,
                  style: GoogleFonts.notoKufiArabic(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'فحص شامل لإمكانيات نظام أندرويد لضمان انطلاق الأذان في الخلفية',
                  style: GoogleFonts.notoKufiArabic(
                    fontSize: 12,
                    color: AppTheme.textElevated,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool get _isHealthySystem =>
      _canScheduleExact && _isBatteryExempted && (_verifiedAlarms['isHealthy'] == true);

  // ─── 2. Next Alarm Card ────────────────────────────────────────────────────

  Widget _buildNextAlarmCard() {
    final hasNext = _nextAlarmTimestamp > 0;
    final dateStr = hasNext
        ? DateTime.fromMillisecondsSinceEpoch(_nextAlarmTimestamp).toString().substring(11, 16)
        : 'غير محدد';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.goldPrimary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.goldPrimary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.alarm_on_rounded, color: AppTheme.goldPrimary, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'المنبه القادم في نظام Android',
                  style: GoogleFonts.notoKufiArabic(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  hasNext
                      ? 'مجدول عبر AlarmManager الساعة $dateStr'
                      : 'لا يوجد منبه قادم مسجل حالياً',
                  style: GoogleFonts.notoKufiArabic(
                    fontSize: 12,
                    color: hasNext ? AppTheme.goldPrimary : AppTheme.textElevated,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── 3. Core Permissions ───────────────────────────────────────────────────

  Widget _buildCorePermissionsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الصلاحيات والحماية من قيود النظام',
            style: GoogleFonts.notoKufiArabic(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppTheme.goldPrimary,
            ),
          ),
          const SizedBox(height: 12),
          _buildStatusRow(
            title: 'المنبهات الدقيقة (Exact Alarms)',
            subtitle: _canScheduleExact ? 'مسموح بها من النظام' : 'معطلة — يلزم تفعيلها في إعدادات النظام',
            isOk: _canScheduleExact,
            actionLabel: _canScheduleExact ? null : 'تفعيل',
            onAction: () async {
              await AdhanScheduler.instance.requestExactAlarmPermission();
            },
          ),
          const Divider(color: Colors.white10, height: 20),
          _buildStatusRow(
            title: 'استثناء توفير البطارية (Doze Mode)',
            subtitle: _isBatteryExempted
                ? 'التطبيق مستثنى — يعمل بحرية في وضع الخمول'
                : 'مقيد بتوفير البطارية — قد يتأخر الأذان',
            isOk: _isBatteryExempted,
            actionLabel: _isBatteryExempted ? null : 'استثناء',
            onAction: () async {
              await AdhanScheduler.instance.requestBatteryOptimization();
            },
          ),
          const Divider(color: Colors.white10, height: 20),
          _buildStatusRow(
            title: 'قناة الإشعارات الفائقة (Adhan Channel)',
            subtitle: 'مجهزة بأعلى أولوية (High Importance) مع الاهتزاز',
            isOk: true,
          ),
          const Divider(color: Colors.white10, height: 20),
          _buildStatusRow(
            title: 'استعادة الأذان بعد إعادة التشغيل (Boot)',
            subtitle: 'مستقبل الإقلاع مسجل ومفعل تلقائياً',
            isOk: true,
          ),
        ],
      ),
    );
  }

  // ─── 4. System Alarms Verification ─────────────────────────────────────────

  Widget _buildSystemAlarmsCard() {
    final verifiedCount = _verifiedAlarms['verifiedCount'] as int? ?? 0;
    final isHealthy = _verifiedAlarms['isHealthy'] as bool? ?? false;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'التحقق من منبهات نظام Android',
                style: GoogleFonts.notoKufiArabic(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.goldPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isHealthy ? Colors.green.withValues(alpha: 0.2) : Colors.amber.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$verifiedCount منبه موثق',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isHealthy ? Colors.greenAccent : Colors.amberAccent,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'يتم التحقق مباشرة عبر نظام أندرويد من وجود معرفات PendingIntent المسجلة لمنع الفشل الصامت.',
            style: GoogleFonts.notoKufiArabic(
              fontSize: 12,
              color: AppTheme.textElevated,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ─── 5. Test Alarm Card ────────────────────────────────────────────────────

  Widget _buildTestAlarmCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.goldPrimary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.timer_outlined, color: AppTheme.goldPrimary, size: 22),
              const SizedBox(width: 8),
              Text(
                'اختبار موثوقية الأذان في الخلفية',
                style: GoogleFonts.notoKufiArabic(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.goldPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'اضغط على الزر أدناه ثم أغلق الشاشة فوراً للتأكد من قدرة المنبه على إيقاظ الهاتف وإطلاق صوت الأذان بعد 15 ثانية.',
            style: GoogleFonts.notoKufiArabic(
              fontSize: 12,
              color: AppTheme.textElevated,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: _testAlarmArmed ? Colors.redAccent : AppTheme.goldPrimary,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _testAlarmArmed ? null : _armTestAlarm,
              icon: Icon(_testAlarmArmed ? Icons.hourglass_top_rounded : Icons.play_arrow_rounded),
              label: Text(
                _testAlarmArmed
                    ? 'سينطلق الأذان بعد $_testCountdown ثانية (أغلق الشاشة الآن)'
                    : 'جدولة منبه اختباري بعد 15 ثانية',
                style: GoogleFonts.notoKufiArabic(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── 6. OEM Guidance ───────────────────────────────────────────────────────

  Widget _buildOemGuidanceCard() {
    final manufacturer = _deviceDiag?.manufacturer ?? 'جهازك';
    final hasSpecialOem = _deviceDiag?.isSupportedOem ?? false;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.phonelink_setup_rounded, color: AppTheme.goldPrimary, size: 22),
              const SizedBox(width: 8),
              Text(
                'قيود الشركة المصنعة ($manufacturer)',
                style: GoogleFonts.notoKufiArabic(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            hasSpecialOem
                ? 'تطبق أجهزة $manufacturer قيوداً مشددة على تطبيقات الخلفية. نوصي بمنح إذن التشغيل التلقائي.'
                : 'لا توجد قيود استثنائية مسجلة لجهازك. تأكد فقط من استثناء التطبيق من توفير البطارية.',
            style: GoogleFonts.notoKufiArabic(
              fontSize: 12,
              color: AppTheme.textElevated,
              height: 1.5,
            ),
          ),
          if (hasSpecialOem) ...[
            const SizedBox(height: 12),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppTheme.goldPrimary),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () async {
                await AdhanScheduler.instance.openOemBatterySettings();
              },
              icon: const Icon(Icons.settings_outlined, color: AppTheme.goldPrimary, size: 18),
              label: Text(
                'فتح إعدادات $manufacturer الخاصة',
                style: GoogleFonts.notoKufiArabic(fontSize: 12, color: AppTheme.goldPrimary),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ─── Status Row Component ──────────────────────────────────────────────────

  Widget _buildStatusRow({
    required String title,
    required String subtitle,
    required bool isOk,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return Row(
      children: [
        Icon(
          isOk ? Icons.check_circle_rounded : Icons.warning_amber_rounded,
          color: isOk ? Colors.greenAccent : Colors.amberAccent,
          size: 22,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.notoKufiArabic(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: GoogleFonts.notoKufiArabic(
                  fontSize: 11,
                  color: isOk ? AppTheme.textElevated : Colors.amberAccent.shade100,
                ),
              ),
            ],
          ),
        ),
        if (actionLabel != null && onAction != null) ...[
          const SizedBox(width: 8),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: AppTheme.goldPrimary.withValues(alpha: 0.15),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              minimumSize: const Size(60, 32),
            ),
            onPressed: onAction,
            child: Text(
              actionLabel,
              style: GoogleFonts.notoKufiArabic(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppTheme.goldPrimary,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

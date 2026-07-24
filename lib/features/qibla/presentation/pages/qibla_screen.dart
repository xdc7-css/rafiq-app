import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../providers/qibla_provider.dart';
import '../../models/qibla_models.dart';
import '../../widgets/qibla_compass.dart';
import '../../widgets/help_card.dart';
import '../../widgets/status_card.dart';
import '../../widgets/glass_bottom_nav.dart';
import '../../widgets/qibla_error_state.dart';

class QiblaScreen extends ConsumerStatefulWidget {
  const QiblaScreen({super.key});
  @override
  ConsumerState<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends ConsumerState<QiblaScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _breatheController;
  late AnimationController _alignController;
  late AnimationController _entranceController;
  late AnimationController _particleController;
  int _selectedNav = 2;
  int _lastHapticDegree = -999;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _breatheController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _alignController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 25),
    )..repeat();

    Future.microtask(() => ref.read(qiblaProvider.notifier).init());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _breatheController.dispose();
    _alignController.dispose();
    _entranceController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!mounted) return;
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      _breatheController.stop();
      _particleController.stop();
    } else if (state == AppLifecycleState.resumed) {
      if (!_breatheController.isAnimating) _breatheController.repeat(reverse: true);
      if (!_particleController.isAnimating) _particleController.repeat();
    }
  }

  @override
  Widget build(BuildContext context) {
    final qiblaState = ref.watch(qiblaProvider);

    return Scaffold(
      backgroundColor: QiblaColors.background,
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _particleController,
            builder: (_, __) => CustomPaint(
              painter: _BgPainter(_particleController.value * math.pi * 4),
              size: Size.infinite,
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                _buildAppBar(qiblaState),
                Expanded(
                  child: _buildBody(qiblaState),
                ),
              ],
            ),
          ),

          if (qiblaState.status == QiblaStatus.ready)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SafeArea(
                child: GlassBottomNav(
                  selectedIndex: _selectedNav,
                  onTap: (i) => setState(() => _selectedNav = i),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAppBar(QiblaData state) {
    final isReady = state.status == QiblaStatus.ready;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: QiblaColors.surface.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: QiblaColors.gold.withValues(alpha: 0.08),
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          _GlassBtn(
            icon: Icons.arrow_back_rounded,
            onTap: () => Navigator.pop(context),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'القبلة',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: QiblaColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isReady ? QiblaColors.success : QiblaColors.danger,
                        boxShadow: [
                          BoxShadow(
                            color: (isReady ? QiblaColors.success : QiblaColors.danger)
                                .withValues(alpha: 0.5),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (state.city != null && state.country != null)
                  Text(
                    '${state.city}, ${state.country}',
                    style: const TextStyle(
                      fontSize: 10,
                      color: QiblaColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          _GlassBtn(
            icon: Icons.settings_rounded,
            onTap: null,
          ),
        ],
      ),
    );
  }

  Widget _buildBody(QiblaData state) {
    switch (state.status) {
      case QiblaStatus.loading:
        return _buildLoading();
      case QiblaStatus.ready:
        return _buildReady(state);
      default:
        return QiblaErrorState(
          status: state.status,
          onRetry: state.status == QiblaStatus.permanentlyDenied
              ? () => Geolocator.openAppSettings()
              : () => ref.read(qiblaProvider.notifier).init(),
          errorMessage: state.errorMessage,
        );
    }
  }

  Widget _buildLoading() {
    return AnimatedBuilder(
      animation: _breatheController,
      builder: (_, __) {
        final b = _breatheController.value;
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: QiblaColors.goldGradient,
                  boxShadow: [
                    BoxShadow(
                      color: QiblaColors.gold.withValues(alpha: 0.15 + b * 0.2),
                      blurRadius: 24 + b * 16,
                      spreadRadius: 2 + b * 4,
                    ),
                  ],
                ),
                child: const Center(
                  child: SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: QiblaColors.background,
                      backgroundColor: Colors.white24,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'جاري تحديد اتجاه القبلة...',
                style: TextStyle(fontSize: 14, color: QiblaColors.textSecondary),
              ),
              const SizedBox(height: 6),
              Text(
                'يتم قياس الموقع والبوصلة',
                style: TextStyle(
                  fontSize: 11,
                  color: QiblaColors.textSecondary.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReady(QiblaData state) {
    final isAligned = state.isAligned;

    if (isAligned && !_alignController.isAnimating) {
      _alignController.repeat(reverse: true);
      HapticFeedback.heavyImpact();
      _lastHapticDegree = -999;
    } else if (!isAligned && _alignController.isAnimating) {
      _alignController.stop();
      _alignController.reset();
    }

    if (!isAligned) {
      final degree = state.angularDifference.round();
      if (degree <= 30 && degree % 5 == 0 && degree != _lastHapticDegree) {
        _lastHapticDegree = degree;
        HapticFeedback.lightImpact();
      }
    }

    return AnimatedBuilder(
      animation: _entranceController,
      builder: (_, child) {
        return Opacity(
          opacity: _entranceController.value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - _entranceController.value)),
            child: child,
          ),
        );
      },
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 130),
        child: Column(
          children: [
            const SizedBox(height: 8),
            _buildCompassSection(state),
            const SizedBox(height: 24),
            _buildAlignmentStatus(state),
            const SizedBox(height: 16),
            HelpCard(
              alignmentProgress: state.alignmentProgress,
              isAligned: isAligned,
            ),
            const SizedBox(height: 16),
            StatusCard(state: state),
            const SizedBox(height: 16),
            _buildBottomActionButtons(state),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildCompassSection(QiblaData state) {
    final compassSize = MediaQuery.of(context).size.width * 0.67;

    return AnimatedBuilder(
      animation: Listenable.merge([_breatheController, _alignController]),
      builder: (_, __) {
        final b = _breatheController.value;
        final a = state.isAligned ? _alignController.value : 0.0;
        final glowI = state.isAligned ? 0.5 + a * 0.5 : b * 0.15;

        return Center(
          child: QiblaCompass(
            heading: state.heading,
            qiblahBearing: state.offset,
            remainingAngle: state.angularDifference,
            isAligned: state.isAligned,
            alignmentProgress: state.alignmentProgress,
            glowIntensity: glowI,
            size: compassSize,
          ),
        );
      },
    );
  }

  Widget _buildAlignmentStatus(QiblaData state) {
    final isAligned = state.isAligned;
    final remaining = state.angularDifference.round();

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      child: isAligned
          ? Container(
              key: const ValueKey('aligned'),
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    QiblaColors.success.withValues(alpha: 0.12),
                    QiblaColors.success.withValues(alpha: 0.03),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: QiblaColors.success.withValues(alpha: 0.3),
                  width: 0.8,
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_rounded, color: QiblaColors.success, size: 22),
                  SizedBox(width: 10),
                  Text(
                    'القبلة صحيحة',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: QiblaColors.success,
                    ),
                  ),
                ],
              ),
            )
          : Container(
              key: const ValueKey('offset'),
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: QiblaColors.card.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: QiblaColors.gold.withValues(alpha: 0.12),
                  width: 0.5,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.navigation_rounded,
                    color: QiblaColors.gold.withValues(alpha: 0.7),
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'تبقى $remaining°',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: QiblaColors.gold,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'للوصول إلى اتجاه القبلة',
                    style: TextStyle(
                      fontSize: 11,
                      color: QiblaColors.textSecondary.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildBottomActionButtons(QiblaData state) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: QiblaColors.surface.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: QiblaColors.gold.withValues(alpha: 0.08),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _BottomActionBtn(
            icon: Icons.refresh_rounded,
            tooltip: 'تحديث الموقع',
            onTap: () {
              ref.read(qiblaProvider.notifier).init();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('جاري إعادة تحديد موقعك الجغرافي والاتجاه...')),
              );
            },
          ),
          _BottomActionBtn(
            icon: Icons.copy_rounded,
            tooltip: 'نسخ بيانات القبلة',
            onTap: () {
              final text = 'بيانات اتجاه القبلة:\n'
                  '- اتجاه القبلة (السمت): ${state.qiblah.toStringAsFixed(1)}°\n'
                  '- زاوية الهاتف الحالية: ${state.heading.round()}°\n'
                  '- الموقع: ${state.city ?? ''}, ${state.country ?? ''}\n'
                  '- الإحداثيات: ${state.latitude?.toStringAsFixed(6) ?? ''},${state.longitude?.toStringAsFixed(6) ?? ''}';
              Clipboard.setData(ClipboardData(text: text));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم نسخ بيانات القبلة بالكامل')),
              );
            },
          ),
          _BottomActionBtn(
            icon: Icons.share_rounded,
            tooltip: 'مشاركة البيانات',
            onTap: () {
              final text = 'أنا أستخدم البوصلة في تطبيق الحقيبة الإسلامية لتحديد اتجاه القبلة.\n'
                  'اتجاه القبلة في موقعي الحالي (${state.city ?? ''}) هو ${state.qiblah.toStringAsFixed(1)}° بالنسبة للشمال.';
              Share.share(text);
            },
          ),
          _BottomActionBtn(
            icon: Icons.map_rounded,
            tooltip: 'خرائط جوجل',
            onTap: () async {
              if (state.latitude != null && state.longitude != null) {
                final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=${state.latitude},${state.longitude}');
                try {
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  } else {
                    throw 'Could not launch URL';
                  }
                } catch (_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تعذر فتح الخرائط حالياً')),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('يرجى تحديد الموقع أولاً')),
                );
              }
            },
          ),
          _BottomActionBtn(
            icon: Icons.compass_calibration_rounded,
            tooltip: 'معايرة البوصلة',
            onTap: () => _showGlobalCalibration(context),
          ),
        ],
      ),
    );
  }

  void _showGlobalCalibration(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: QiblaColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            border: Border(
              top: BorderSide(
                color: QiblaColors.gold,
                width: 0.8,
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Icon(
                Icons.compass_calibration_rounded,
                color: QiblaColors.gold,
                size: 40,
              ),
              const SizedBox(height: 12),
              const Text(
                'طريقة معايرة البوصلة',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: QiblaColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'إذا شعرت أن اتجاه القبلة غير دقيق، يرجى اتباع الخطوات التالية لمعايرة بوصلة هاتفك الذكي وتصحيح انحراف الحساسات:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: QiblaColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              _buildCalibrationStep('1', 'ارفع هاتفك أمام صدرك واجعله موازياً للأرض.'),
              _buildCalibrationStep('2', 'قم بتحريك الهاتف في الهواء برسم مسار كامل على شكل رقم ثمانية بالإنجليزية (∞) أو علامة اللانهائية عدة مرات بشكل متواصل.'),
              _buildCalibrationStep('3', 'تجنب الوقوف بجوار الأسطح المعدنية الكبيرة أو المجالات المغناطيسية القوية (مثل أجهزة التلفزيون أو مكبرات الصوت الكبيرة) أثناء القياس.'),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: QiblaColors.gold,
                    foregroundColor: QiblaColors.background,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'تمت المعايرة بنجاح',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalibrationStep(String number, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              color: QiblaColors.gold,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              number,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: QiblaColors.background,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 11.5,
                color: QiblaColors.textPrimary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomActionBtn extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _BottomActionBtn({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      textStyle: const TextStyle(fontSize: 10, color: QiblaColors.background),
      decoration: BoxDecoration(
        color: QiblaColors.lightGold,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: QiblaColors.gold.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: QiblaColors.gold.withValues(alpha: 0.15),
                width: 0.5,
              ),
            ),
            child: Icon(icon, color: QiblaColors.gold, size: 20),
          ),
        ),
      ),
    );
  }
}

class _GlassBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _GlassBtn({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: QiblaColors.gold.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: QiblaColors.gold.withValues(alpha: 0.15),
            width: 0.5,
          ),
        ),
        child: Icon(icon, color: QiblaColors.gold, size: 18),
      ),
    );
  }
}

class _BgPainter extends CustomPainter {
  final double time;
  _BgPainter(this.time);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final bg = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF060D1A), Color(0xFF081326), Color(0xFF0B1A30)],
      ).createShader(rect);
    canvas.drawRect(rect, bg);

    final cx = size.width / 2;
    final cy = size.height * 0.35;
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          QiblaColors.gold.withValues(alpha: 0.03),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: size.width * 0.5));
    canvas.drawCircle(Offset(cx, cy), size.width * 0.5, glowPaint);

    final dotPaint = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.0);
    final rng = math.Random(42);
    for (int i = 0; i < 25; i++) {
      final dx = rng.nextDouble() * size.width;
      final dy = rng.nextDouble() * size.height;
      final phase = i * 0.7;
      final alpha = (0.3 + 0.3 * math.sin(time * 0.4 + phase)).clamp(0.0, 1.0);
      dotPaint.color = QiblaColors.gold.withValues(alpha: alpha * 0.08);
      canvas.drawCircle(Offset(dx, dy), 1.0 + rng.nextDouble() * 1.5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(_BgPainter old) => old.time != time;
}

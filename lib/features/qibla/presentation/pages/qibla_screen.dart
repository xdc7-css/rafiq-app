import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../providers/qibla_provider.dart';
import '../../../../theme/app_theme.dart';
import '../../models/qibla_models.dart';
import '../../widgets/compass_dial.dart';
import '../../widgets/kaaba_icon.dart';
import '../../widgets/alignment_indicator.dart';
import '../../widgets/qibla_info_panel.dart';
import '../../widgets/qibla_error_state.dart';

class _QP {
  final double x, y, size, opacity, phase, speed, amp;
  const _QP(this.x, this.y, this.size, this.opacity, this.phase, this.speed, this.amp);
}

class _QiblaBgPainter extends CustomPainter {
  final double time;
  final List<_QP> particles;

  _QiblaBgPainter(this.time, this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final bg = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF060D1A), Color(0xFF0B1A30), Color(0xFF0F2640)],
      ).createShader(rect);
    canvas.drawRect(rect, bg);

    final cx = size.width / 2;
    final cy = size.height * 0.38;
    final radial = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 0.5,
        colors: [
          AppTheme.goldPrimary.withValues(alpha: 0.05),
          AppTheme.goldPrimary.withValues(alpha: 0.015),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: size.width * 0.5));
    canvas.drawCircle(Offset(cx, cy), size.width * 0.5, radial);

    final ornPaint = Paint()
      ..color = AppTheme.goldPrimary.withValues(alpha: 0.02)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    final ornSize = size.shortestSide * 0.6;
    final ornPath = Path();
    final r = ornSize / 2;
    for (int i = 0; i < 8; i++) {
      final a = i * math.pi / 4;
      final x = cx + r * math.cos(a);
      final y = cy + r * math.sin(a);
      if (i == 0) {
        ornPath.moveTo(x, y);
      } else {
        ornPath.lineTo(x, y);
      }
    }
    ornPath.close();
    canvas.drawPath(ornPath, ornPaint);
    canvas.drawCircle(Offset(cx, cy), r * 0.15, ornPaint);

    for (final p in particles) {
      final dx = p.x + math.sin(time * p.speed + p.phase) * p.amp;
      final dy = p.y + math.cos(time * p.speed * 0.7 + p.phase * 1.3) * p.amp * 0.6;
      final alpha =
          (p.opacity * (0.5 + 0.5 * math.sin(time * 0.5 + p.phase))).clamp(0.0, 1.0);
      final pp = Paint()
        ..color = AppTheme.goldPrimary.withValues(alpha: alpha)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5);
      canvas.drawCircle(Offset(dx, dy), p.size, pp);
    }
  }

  @override
  bool shouldRepaint(_QiblaBgPainter old) => old.time != time;
}

class QiblaScreen extends ConsumerStatefulWidget {
  const QiblaScreen({super.key});
  @override
  ConsumerState<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends ConsumerState<QiblaScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _breatheController;
  late AnimationController _alignedController;
  late AnimationController _entranceController;
  late AnimationController _particleController;
  late AnimationController _calibrateController;
  List<_QP> _particles = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _breatheController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _alignedController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();
    _calibrateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    final rng = math.Random(42);
    _particles = List.generate(35, (_) => _QP(
          rng.nextDouble() * 500,
          rng.nextDouble() * 900,
          1.0 + rng.nextDouble() * 2.5,
          0.06 + rng.nextDouble() * 0.2,
          rng.nextDouble() * math.pi * 2,
          0.3 + rng.nextDouble() * 0.8,
          8 + rng.nextDouble() * 25,
        ));

    Future.microtask(() => ref.read(qiblaProvider.notifier).init());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _breatheController.dispose();
    _alignedController.dispose();
    _entranceController.dispose();
    _particleController.dispose();
    _calibrateController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState lifecycleState) {
    if (!mounted) return;
    if (lifecycleState == AppLifecycleState.paused ||
        lifecycleState == AppLifecycleState.inactive) {
      _breatheController.stop();
      _particleController.stop();
      _calibrateController.stop();
    } else if (lifecycleState == AppLifecycleState.resumed) {
      if (!_breatheController.isAnimating) _breatheController.repeat(reverse: true);
      if (!_particleController.isAnimating) _particleController.repeat();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(qiblaProvider);

    return Scaffold(
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _particleController,
            builder: (_, __) => CustomPaint(
              painter: _QiblaBgPainter(
                _particleController.value * math.pi * 4,
                _particles,
              ),
              size: Size.infinite,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(state),
                Expanded(child: _buildBody(state)),
              ],
            ),
          ),
          if (state.status == QiblaStatus.ready) _buildControlDock(state),
        ],
      ),
    );
  }

  Widget _buildAppBar(QiblaData state) {
    final isReady = state.status == QiblaStatus.ready;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 6, 16, 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppTheme.borderGold, width: 0.5),
        boxShadow: [
          BoxShadow(
              color: AppTheme.shadowDark,
              blurRadius: 30,
              offset: const Offset(0, 8),
              spreadRadius: -4),
          BoxShadow(color: AppTheme.shadowGold, blurRadius: 20),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.bgCard.withValues(alpha: 0.5),
                  AppTheme.bgSecondary.withValues(alpha: 0.3),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                _glassBtn(Icons.arrow_back_rounded, () => Navigator.pop(context)),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('القبلة',
                              style: GoogleFonts.notoKufiArabic(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.textPrimary)),
                          const SizedBox(width: 8),
                          Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isReady ? Colors.greenAccent : Colors.redAccent,
                              boxShadow: [
                                BoxShadow(
                                  color: (isReady
                                          ? Colors.greenAccent
                                          : Colors.redAccent)
                                      .withValues(alpha: 0.5),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 1),
                      Row(
                        children: [
                          Text('اتجاه الكعبة المشرفة',
                              style: GoogleFonts.notoKufiArabic(
                                  fontSize: 10, color: AppTheme.textMuted)),
                          const Spacer(),
                          if (state.city != null && state.country != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.goldPrimary.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: AppTheme.borderGold, width: 0.3),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.location_on_rounded,
                                      size: 8, color: AppTheme.goldPrimary),
                                  const SizedBox(width: 3),
                                  Text('${state.city}, ${state.country}',
                                      style: GoogleFonts.notoKufiArabic(
                                          fontSize: 8,
                                          color: AppTheme.goldPrimary)),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                _glassBtn(
                  isReady ? Icons.navigation_rounded : Icons.gps_off_rounded,
                  null,
                  accentColor: isReady ? null : Colors.redAccent,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _glassBtn(IconData icon, VoidCallback? onTap, {Color? accentColor}) {
    final c = accentColor ?? AppTheme.goldPrimary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: c.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: c.withValues(alpha: 0.2), width: 0.5),
        ),
        child: Icon(icon, color: c, size: 20),
      ),
    );
  }

  Widget _buildBody(QiblaData state) {
    switch (state.status) {
      case QiblaStatus.loading:
        return _buildLoading();
      case QiblaStatus.noSensor:
        return QiblaErrorState(
          status: QiblaStatus.noSensor,
          onRetry: () => ref.read(qiblaProvider.notifier).init(),
        );
      case QiblaStatus.noPermission:
        return QiblaErrorState(
          status: state.status,
          onRetry: () => ref.read(qiblaProvider.notifier).init(),
        );
      case QiblaStatus.permanentlyDenied:
        return QiblaErrorState(
          status: state.status,
          onRetry: () => Geolocator.openAppSettings(),
        );
      case QiblaStatus.noGps:
        return QiblaErrorState(
          status: QiblaStatus.noGps,
          onRetry: () => ref.read(qiblaProvider.notifier).init(),
        );
      case QiblaStatus.error:
        return QiblaErrorState(
          status: QiblaStatus.error,
          errorMessage: state.errorMessage,
          onRetry: () => ref.read(qiblaProvider.notifier).init(),
        );
      case QiblaStatus.ready:
        return _buildReady(state);
    }
  }

  Widget _buildLoading() {
    final w = MediaQuery.sizeOf(context).width;
    return Center(
      child: AnimatedBuilder(
        animation: _breatheController,
        builder: (_, __) {
          final b = _breatheController.value;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppTheme.goldGradient,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.goldPrimary
                          .withValues(alpha: 0.2 + b * 0.3),
                      blurRadius: 30 + b * 20,
                      spreadRadius: 2 + b * 4,
                    ),
                  ],
                ),
                child: Center(
                  child: SizedBox(
                    width: 36,
                    height: 36,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: AppTheme.bgPrimary,
                      backgroundColor: AppTheme.bgPrimary.withValues(alpha: 0.15),
                    ),
                  ),
                ),
              ),
              SizedBox(height: w < 360 ? 18 : 24),
              Text('جاري تحديد اتجاه القبلة...',
                  style: GoogleFonts.notoKufiArabic(
                      fontSize: 14, color: AppTheme.textMuted)),
              const SizedBox(height: 8),
              Text('يتم قياس الموقع والبوصلة',
                  style: GoogleFonts.notoKufiArabic(
                      fontSize: 11,
                      color: AppTheme.textMuted.withValues(alpha: 0.6))),
            ],
          );
        },
      ),
    );
  }

  Widget _buildReady(QiblaData state) {
    final heading = state.heading;
    final offset = state.offset;
    final isAligned = state.isAligned;

    if (isAligned && !_alignedController.isAnimating) {
      _alignedController.repeat(reverse: true);
      HapticFeedback.heavyImpact();
    } else if (!isAligned && _alignedController.isAnimating) {
      _alignedController.stop();
      _alignedController.reset();
    }

    return AnimatedBuilder(
      animation: _entranceController,
      builder: (_, child) {
        return Opacity(
          opacity: _entranceController.value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - _entranceController.value)),
            child: child,
          ),
        );
      },
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
        child: Column(
          children: [
            _buildCompassSection(state, heading, isAligned),
            const SizedBox(height: 20),
            AlignmentIndicator(
              isAligned: isAligned,
              offset: offset,
              pulseAnimation: _alignedController,
            ),
            const SizedBox(height: 16),
            QiblaInfoPanel(
              city: state.city,
              country: state.country,
              qiblahAngle: offset,
              cardinal: _cardinalFromAngle(offset),
              hasLocation: state.latitude != null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompassSection(QiblaData state, double heading, bool isAligned) {
    return AnimatedBuilder(
      animation: Listenable.merge([_breatheController, _alignedController]),
      builder: (_, __) {
        final b = _breatheController.value;
        final a = isAligned ? _alignedController.value : 0.0;
        final compassSize = MediaQuery.of(context).size.width * 0.60;

        return Center(
          child: SizedBox(
            width: compassSize + 60,
            height: compassSize + 60,
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (isAligned)
                  for (int i = 0; i < 3; i++)
                    Container(
                      width: compassSize + 50 + i * 24,
                      height: compassSize + 50 + i * 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.greenAccent.withValues(
                              alpha: (0.15 - i * 0.04) * (1.0 - a * 0.4)),
                          width: 2.0 - i * 0.5,
                        ),
                        boxShadow: i == 0
                            ? [
                                BoxShadow(
                                  color: Colors.greenAccent.withValues(
                                      alpha: 0.1 * (1.0 - a * 0.3)),
                                  blurRadius: 40 + a * 30,
                                  spreadRadius: 4 + a * 6,
                                ),
                              ]
                            : null,
                      ),
                    ),

                // Kaaba icon above compass
                Positioned(
                  top: 0,
                  child: KaabaIcon(
                    isAligned: isAligned,
                    breatheValue: b,
                    size: compassSize * 0.22,
                  ),
                ),

                // Compass dial
                CompassDial(
                  heading: heading,
                  qiblah: state.qiblah,
                  isAligned: isAligned,
                  size: compassSize,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildControlDock(QiblaData state) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: AppTheme.borderGold, width: 0.5),
          boxShadow: [
            BoxShadow(
                color: AppTheme.shadowDark,
                blurRadius: 40,
                offset: const Offset(0, 12),
                spreadRadius: -8),
            BoxShadow(color: AppTheme.shadowGold, blurRadius: 20),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.bgCard.withValues(alpha: 0.6),
                    AppTheme.bgSecondary.withValues(alpha: 0.4),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _dockBtn(Icons.my_location_rounded, 'الموقع',
                      () => ref.read(qiblaProvider.notifier).init()),
                  _dockBtn(Icons.sensors_rounded, 'البوصلة', () {
                    HapticFeedback.mediumImpact();
                    ref.read(qiblaProvider.notifier).init();
                  }),
                  _dockBtn(Icons.map_rounded, 'الخريطة', _openMaps),
                  _dockBtn(
                    state.status == QiblaStatus.ready
                        ? Icons.check_circle_rounded
                        : Icons.error_outline_rounded,
                    state.status == QiblaStatus.ready
                        ? 'GPS متصل'
                        : 'GPS غير متصل',
                    null,
                    isStatic: true,
                    accent: state.status == QiblaStatus.ready
                        ? Colors.greenAccent
                        : Colors.redAccent,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _dockBtn(IconData icon, String label, VoidCallback? onTap,
      {bool isStatic = false, Color accent = AppTheme.goldPrimary}) {
    final c = accent;
    final content = AnimatedBuilder(
      animation: _breatheController,
      builder: (_, __) {
        final b = _breatheController.value;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: c.withValues(alpha: 0.08 + b * 0.03),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: c.withValues(alpha: 0.2), width: 0.5),
              ),
              child: Icon(icon, color: c, size: 20),
            ),
            const SizedBox(height: 3),
            Text(label,
                style: GoogleFonts.notoKufiArabic(
                    fontSize: 8, fontWeight: FontWeight.w600, color: c)),
          ],
        );
      },
    );
    if (isStatic || onTap == null) return content;
    return GestureDetector(onTap: onTap, child: content);
  }

  String _cardinalFromAngle(double angle) {
    const dirs = [
      'N', 'NNE', 'NE', 'ENE', 'E', 'ESE', 'SE', 'SSE',
      'S', 'SSW', 'SW', 'WSW', 'W', 'WNW', 'NW', 'NNW',
    ];
    final idx = ((angle + 11.25) % 360 / 22.5).floor() % 16;
    return dirs[idx];
  }

  Future<void> _openMaps() async {
    final uri = Uri.parse('https://www.google.com/maps/dir//Mecca+Saudi+Arabia');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

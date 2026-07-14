import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';
import '../../providers/tasbih_al_zahra_provider.dart';
import '../../providers/tasbeeh_stats_provider.dart';
import '../../providers/tasbeeh_custom_provider.dart';
import '../../providers/tasbeeh_history_provider.dart';
import '../../theme/app_theme.dart';
import '../../theme/ds_components.dart';
import '../hadith_shia/presentation/widgets/tasbih_hadith_popup.dart';

enum TasbihMode { standard, zahra, custom }

class _DhikrType {
  final String label;
  final String translit;
  final int target;
  const _DhikrType(this.label, this.translit, this.target);
}

const _standardTypes = [
  _DhikrType('سبحان الله', 'سبحان الله', 33),
  _DhikrType('الحمد لله', 'الحمد لله', 33),
  _DhikrType('الله أكبر', 'الله أكبر', 34),
  _DhikrType('لا إله إلا الله', 'لا إله إلا الله', 100),
  _DhikrType('أستغفر الله', 'أستغفر الله', 70),
  _DhikrType('الصلاة على محمد وآل محمد', 'الصلاة على محمد وآل محمد', 100),
];

class _Particle {
  final double x, y, size, opacity, phase, speed, amplitude;
  const _Particle(this.x, this.y, this.size, this.opacity, this.phase, this.speed, this.amplitude);
}

class _TasbeehBackgroundPainter extends CustomPainter {
  final double time;
  final List<_Particle> particles;

  _TasbeehBackgroundPainter(this.time, this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    final bgPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF060D1A), Color(0xFF0B1A30), Color(0xFF0F2640)],
      ).createShader(rect);
    canvas.drawRect(rect, bgPaint);

    final centerX = size.width / 2;
    final centerY = size.height * 0.42;
    final radialPaint = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 0.6,
        colors: [
          AppTheme.goldPrimary.withValues(alpha: 0.06),
          AppTheme.goldPrimary.withValues(alpha: 0.02),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: Offset(centerX, centerY), radius: size.width * 0.6));
    canvas.drawCircle(Offset(centerX, centerY), size.width * 0.6, radialPaint);

    final ornamentPaint = Paint()
      ..color = AppTheme.goldPrimary.withValues(alpha: 0.025)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    final ornSize = size.shortestSide * 0.7;
    final ornPath = Path();
    final cx = size.width / 2;
    final cy = size.height * 0.35;
    final r = ornSize / 2;
    for (int i = 0; i < 8; i++) {
      final angle = i * math.pi / 4;
      final x = cx + r * math.cos(angle);
      final y = cy + r * math.sin(angle);
      if (i == 0) { ornPath.moveTo(x, y); } else { ornPath.lineTo(x, y); }
    }
    ornPath.close();
    for (int i = 0; i < 8; i++) {
      final angle = i * math.pi / 4 + math.pi / 8;
      final x = cx + r * 0.5 * math.cos(angle);
      final y = cy + r * 0.5 * math.sin(angle);
      if (i == 0) { ornPath.moveTo(x, y); } else { ornPath.lineTo(x, y); }
    }
    ornPath.close();
    canvas.drawPath(ornPath, ornamentPaint);
    canvas.drawCircle(Offset(cx, cy), r * 0.15, ornamentPaint);

    for (final p in particles) {
      final dx = p.x + math.sin(time * p.speed + p.phase) * p.amplitude;
      final dy = p.y + math.cos(time * p.speed * 0.7 + p.phase * 1.3) * p.amplitude * 0.6;
      final alpha = (p.opacity * (0.6 + 0.4 * math.sin(time * 0.5 + p.phase))).clamp(0.0, 1.0);
      final particlePaint = Paint()
        ..color = AppTheme.goldPrimary.withValues(alpha: alpha)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5);
      canvas.drawCircle(Offset(dx, dy), p.size, particlePaint);
    }
  }

  @override
  bool shouldRepaint(_TasbeehBackgroundPainter old) => old.time != time;
}

class TasbeehScreen extends ConsumerStatefulWidget {
  const TasbeehScreen({super.key});
  @override
  ConsumerState<TasbeehScreen> createState() => _TasbeehScreenState();
}

class _TasbeehScreenState extends ConsumerState<TasbeehScreen>
    with TickerProviderStateMixin {
  TasbihMode _mode = TasbihMode.zahra;
  int _standardIndex = 0;
  int _standardCount = 0;
  int _customIndex = 0;
  int _customCount = 0;
  bool _vibration = true;
  bool _showStats = false;

  late AnimationController _tapController;
  late AnimationController _breatheController;
  late AnimationController _celebrateController;
  late AnimationController _particleController;
  late AnimationController _entranceController;
  late AnimationController _counterPopController;
  late AnimationController _webPulseController;
  late AnimationController _fingerprintRippleController;
  late AnimationController _stageFlashController;
  Timer? _justAdvancedTimer;
  TasbihAlZahraStage? _flashStage;

  List<_Particle> _particles = [];

  @override
  void initState() {
    super.initState();
    _tapController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 200),
    );
    _breatheController = AnimationController(
      vsync: this, duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _celebrateController = AnimationController(
      vsync: this, duration: const Duration(seconds: 2),
    );
    _particleController = AnimationController(
      vsync: this, duration: const Duration(seconds: 30),
    )..repeat();
    _entranceController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 800),
    )..forward();
    _counterPopController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 100),
    );
    _webPulseController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 180),
    );
    _fingerprintRippleController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 300),
    );
    _stageFlashController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 220),
    );

    final rng = math.Random(42);
    _particles = List.generate(40, (_) {
      return _Particle(
        rng.nextDouble() * 500,
        rng.nextDouble() * 900,
        1.0 + rng.nextDouble() * 2.5,
        0.08 + rng.nextDouble() * 0.25,
        rng.nextDouble() * math.pi * 2,
        0.3 + rng.nextDouble() * 0.8,
        8 + rng.nextDouble() * 25,
      );
    });
  }

  @override
  void dispose() {
    _tapController.dispose();
    _breatheController.dispose();
    _celebrateController.dispose();
    _particleController.dispose();
    _entranceController.dispose();
    _counterPopController.dispose();
    _webPulseController.dispose();
    _fingerprintRippleController.dispose();
    _stageFlashController.dispose();
    _justAdvancedTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final zahraState = ref.watch(tasbihAlZahraProvider);
    final stats = ref.watch(tasbihStatsProvider);

    return Scaffold(
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _particleController,
            builder: (_, __) => CustomPaint(
              painter: _TasbeehBackgroundPainter(
                _particleController.value * math.pi * 4, _particles,
              ),
              size: Size.infinite,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(),
                _buildModeChips(),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(w < 360 ? 12 : 16, 4, w < 360 ? 12 : 16, 100),
                    child: AnimatedBuilder(
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
                      child: Column(
                        children: [
                          if (_mode == TasbihMode.zahra)
                            _buildZahraContent(zahraState)
                          else
                            _buildStandardContent(),
                          SizedBox(height: w < 360 ? 18 : 24),
                          _buildFingerprintButton(zahraState),
                          SizedBox(height: w < 360 ? 16 : 20),
                          _buildStatsToggle(),
                          if (_showStats) ...[
                            const SizedBox(height: 12),
                            _buildStatsPanel(stats),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (zahraState.isComplete) _buildCompletionOverlay(zahraState),
        ],
      ),
    );
  }

  // ─── Premium App Bar ───

  Widget _buildAppBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 6, 16, 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppTheme.borderGold, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowDark,
            blurRadius: 30, offset: const Offset(0, 8), spreadRadius: -4,
          ),
          BoxShadow(
            color: AppTheme.shadowGold,
            blurRadius: 20, offset: const Offset(0, 0),
          ),
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
                _glassIconButton(Icons.arrow_back_rounded, () => Navigator.pop(context)),
                const Spacer(),
                Column(
                  children: [
                    Text('التسبيح',
                        style: GoogleFonts.notoKufiArabic(
                            fontSize: 18, fontWeight: FontWeight.w800,
                            color: AppTheme.textPrimary)),
                    Text('سبحان الله وبحمده',
                        style: GoogleFonts.notoKufiArabic(
                            fontSize: 10, color: AppTheme.textMuted)),
                  ],
                ),
                const Spacer(),
                _glassIconButton(Icons.tune_rounded, _showSettingsSheet),
                const SizedBox(width: 6),
                _glassIconButton(Icons.bar_chart_rounded, () {
                  setState(() => _showStats = !_showStats);
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _glassIconButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
          color: AppTheme.goldPrimary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.borderGold, width: 0.5),
        ),
        child: Icon(icon, color: AppTheme.goldPrimary, size: 20),
      ),
    );
  }

  // ─── Mode Chips ───

  Widget _buildModeChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _modeChip('تسبيحة الزهراء (ع)', TasbihMode.zahra),
            const SizedBox(width: 8),
            _modeChip('أذكار عامة', TasbihMode.standard),
            const SizedBox(width: 8),
            _modeChip('تسابيح مخصصة', TasbihMode.custom),
          ],
        ),
      ),
    );
  }

  Widget _modeChip(String label, TasbihMode mode) {
    final active = _mode == mode;
    return GestureDetector(
      onTap: () => setState(() => _mode = mode),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          gradient: active ? AppTheme.goldGradient : null,
          color: active ? null : AppTheme.goldPrimary.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: active ? AppTheme.goldPrimary : AppTheme.borderGold.withValues(alpha: 0.25),
            width: active ? 0.8 : 0.5,
          ),
          boxShadow: active ? [
            BoxShadow(
              color: AppTheme.goldPrimary.withValues(alpha: 0.25),
              blurRadius: 12, spreadRadius: 0, offset: const Offset(0, 4),
            ),
          ] : null,
        ),
        child: Text(label,
            style: GoogleFonts.notoKufiArabic(
                fontSize: 12, fontWeight: FontWeight.w700,
                color: active ? AppTheme.bgPrimary : AppTheme.goldPrimary)),
      ),
    );
  }

  // ─── Zahra Content ───

  Widget _buildZahraContent(TasbihAlZahraState state) {
    final w = MediaQuery.sizeOf(context).width;
    return Column(
      children: [
        _buildPhraseCard(state.currentDhikr, state.stageArabic, state.remaining),
        SizedBox(height: w < 360 ? 18 : 24),
        _buildCounterRing(state.currentCount, state.target, state.progress),
        SizedBox(height: w < 360 ? 16 : 20),
        _buildZahraProgressCards(state),
      ],
    );
  }

  // ─── Phrase Card ───

  Widget _buildPhraseCard(String dhikr, String stage, int remaining) {
    final w = MediaQuery.sizeOf(context).width;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      transitionBuilder: (child, anim) {
        return FadeTransition(
          opacity: anim,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.12),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: anim,
              curve: Curves.easeOutCubic,
            )),
            child: child,
          ),
        );
      },
      child: Container(
        key: ValueKey('${dhikr}_${_breatheController.value > 0.5 ? 'a' : 'b'}'),
        margin: EdgeInsets.symmetric(horizontal: w < 360 ? 12 : 16),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppTheme.borderGold, width: 0.5),
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadowDark,
              blurRadius: 24, offset: const Offset(0, 8), spreadRadius: -4,
            ),
            BoxShadow(
              color: AppTheme.shadowGold,
              blurRadius: 20, offset: const Offset(0, 0),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.goldPrimary.withValues(alpha: 0.08),
                    AppTheme.goldPrimary.withValues(alpha: 0.02),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                children: [
                  Text(dhikr,
                      style: GoogleFonts.notoKufiArabic(
                          fontSize: 28, fontWeight: FontWeight.bold,
                          color: AppTheme.goldPrimary)),
                  const SizedBox(height: 6),
                  Text(stage,
                      style: GoogleFonts.notoKufiArabic(
                          fontSize: 12, color: AppTheme.textMuted)),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppTheme.goldPrimary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text('المتبقي: $remaining',
                        style: GoogleFonts.notoKufiArabic(
                            fontSize: 10, color: AppTheme.goldPrimary)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─── Main Counter Ring ───

  Widget _buildCounterRing(int current, int target, double progress) {
    final w = MediaQuery.sizeOf(context).width;
    return AnimatedBuilder(
      animation: Listenable.merge([_breatheController, _tapController, _webPulseController]),
      builder: (context, _) {
        final breathe = _breatheController.value;
        final tapScale = 1.0 - _tapController.value * 0.02;

        double webScale = 1.0;
        double webGlow = 0.0;
        if (kIsWeb && _webPulseController.isAnimating) {
          final wv = _webPulseController.value;
          webScale = wv < 0.5 ? 1.0 - wv * 2 * 0.015 : 1.0 - (1.0 - wv) * 2 * 0.015;
          webGlow = wv < 0.5 ? 0.15 + wv * 2 * 0.20 : 0.15 + (1.0 - wv) * 2 * 0.20;
        }

        final ringSize = w < 360 ? 220.0 : 260.0;
        final innerSize = ringSize - 32;

        return Transform.scale(
          scale: tapScale * webScale,
          child: Container(
            width: ringSize,
            height: ringSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.shadowDark,
                  blurRadius: 40, offset: const Offset(0, 12), spreadRadius: -8,
                ),
                BoxShadow(
                  color: AppTheme.goldPrimary.withValues(alpha: 0.08 + breathe * 0.1 + webGlow),
                  blurRadius: 50 + breathe * 30,
                  spreadRadius: 4 + breathe * 4,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(ringSize / 2),
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 12 + breathe * 4, sigmaY: 12 + breathe * 4),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.bgCard.withValues(alpha: 0.35 + breathe * 0.1),
                        AppTheme.bgSecondary.withValues(alpha: 0.2),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border.all(
                      color: AppTheme.borderGold.withValues(alpha: 0.15 + breathe * 0.1),
                      width: 1.0,
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: innerSize,
                        height: innerSize,
                        child: CircularProgressIndicator(
                          value: 1.0,
                          strokeWidth: 3,
                          color: AppTheme.goldPrimary.withValues(alpha: 0.05),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                      SizedBox(
                        width: innerSize,
                        height: innerSize,
                        child: CircularProgressIndicator(
                          value: progress.clamp(0.0, 1.0),
                          strokeWidth: 8,
                          color: AppTheme.goldPrimary.withValues(alpha: 0.15 + breathe * 0.1),
                          backgroundColor: Colors.transparent,
                          strokeCap: StrokeCap.round,
                        ),
                      ),
                      SizedBox(
                        width: innerSize - 20,
                        height: innerSize - 20,
                        child: CircularProgressIndicator(
                          value: progress.clamp(0.0, 1.0),
                          strokeWidth: 6,
                          color: AppTheme.goldPrimary,
                          backgroundColor: AppTheme.goldPrimary.withValues(alpha: 0.05),
                          strokeCap: StrokeCap.round,
                        ),
                      ),
                      SizedBox(
                        width: innerSize - 48,
                        height: innerSize - 48,
                        child: CircularProgressIndicator(
                          value: progress.clamp(0.0, 1.0),
                          strokeWidth: 3,
                          color: AppTheme.goldSoft.withValues(alpha: 0.3 + breathe * 0.2),
                          backgroundColor: Colors.transparent,
                          strokeCap: StrokeCap.round,
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedBuilder(
                            animation: _counterPopController,
                            builder: (context, child) {
                              final v = _counterPopController.value;
                              final popScale = v < 0.5
                                  ? 1.0 + v * 2 * 0.08
                                  : 1.0 + (1.0 - v) * 2 * 0.08;
                              return Transform.scale(
                                scale: popScale,
                                child: child,
                              );
                            },
                            child: Text(
                              '$current',
                              style: GoogleFonts.inter(
                                fontSize: w < 360 ? 42 : 52,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.goldPrimary,
                                shadows: [
                                  Shadow(
                                    color: AppTheme.goldPrimary.withValues(alpha: 0.3),
                                    blurRadius: 12,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text('من $target',
                              style: GoogleFonts.notoKufiArabic(
                                  fontSize: 14, color: AppTheme.textMuted)),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.goldPrimary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${(progress * 100).toInt()}%',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.goldPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ─── Fingerprint Tap Button ───

  Widget _buildFingerprintButton(TasbihAlZahraState zahraState) {
    final w = MediaQuery.sizeOf(context).width;
    final isComplete = _mode == TasbihMode.zahra && zahraState.isComplete;
    final btnSize = w < 360 ? 96.0 : 110.0;
    final btnInnerSize = w < 360 ? 78.0 : 90.0;

    return GestureDetector(
      onTapDown: (_) {
        _tapController.forward();
        HapticFeedback.lightImpact();
      },
      onTapUp: (_) {
        _tapController.reverse();
        _handleTap(zahraState);
      },
      onTapCancel: () => _tapController.reverse(),
      child: AnimatedBuilder(
        animation: Listenable.merge([_tapController, _breatheController, _fingerprintRippleController]),
        builder: (context, _) {
          final tap = _tapController.value;
          final breathe = _breatheController.value;
          final ripple = _fingerprintRippleController.value;
          final scale = 1.0 - tap * 0.05;
          final pulseRingOpacity = (0.3 - tap * 0.2) * (0.6 + 0.4 * breathe);
          final rippleScale = 0.5 + ripple * 1.0;
          final rippleOpacity = 0.3 * (1.0 - ripple);

          return SizedBox(
            width: btnSize,
            height: btnSize,
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (ripple > 0)
                  Transform.scale(
                    scale: rippleScale,
                    child: Container(
                      width: btnSize,
                      height: btnSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppTheme.goldPrimary.withValues(alpha: rippleOpacity),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                for (int i = 0; i < 2; i++)
                  Positioned(
                    width: btnSize + i * 20 + breathe * 16,
                    height: btnSize + i * 20 + breathe * 16,
                    child: Transform.scale(
                      scale: scale,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppTheme.goldPrimary.withValues(
                              alpha: pulseRingOpacity * (i == 0 ? 0.5 : 0.2),
                            ),
                            width: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                Transform.scale(
                  scale: scale,
                    child: Container(
                      width: btnInnerSize,
                      height: btnInnerSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppTheme.goldGradient,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.shadowGold.withValues(alpha: 0.6 + breathe * 0.3 + tap * 0.2),
                          blurRadius: 30 + breathe * 20,
                          spreadRadius: 2 + tap * 4,
                        ),
                        BoxShadow(
                          color: AppTheme.shadowDark,
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                          spreadRadius: -4,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(btnInnerSize / 2),
                      child: BackdropFilter(
                        filter: ui.ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withValues(alpha: 0.15),
                                Colors.white.withValues(alpha: 0.0),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.2 + tap * 0.1),
                              width: 1.5,
                            ),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              if (tap > 0)
                                Container(
                                  width: btnInnerSize,
                                  height: btnInnerSize,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withValues(alpha: tap * 0.08),
                                  ),
                                ),
                              Icon(
                                isComplete ? Icons.check_circle_rounded : Icons.fingerprint,
                                color: AppTheme.bgPrimary,
                                size: isComplete ? 42 : 38,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ─── Zahra Progress Cards ───

  Widget _buildZahraProgressCards(TasbihAlZahraState state) {
    final stages = [
      ('الله أكبر', 34, TasbihAlZahraStage.takbeer),
      ('الحمد لله', 33, TasbihAlZahraStage.tahmeed),
      ('سبحان الله', 33, TasbihAlZahraStage.tasbeeh),
    ];
    return Row(
      children: stages.map((s) {
        final isComplete = state.stage.index > s.$3.index ||
            (state.stage == s.$3 && state.currentCount >= s.$2);
        final isCurrent = state.stage == s.$3 && !isComplete;
        final progress = isComplete ? 1.0 : (isCurrent ? state.progress : 0.0);
        final shouldFlash = _flashStage == s.$3 && _stageFlashController.isAnimating;
        return Expanded(
          child: AnimatedBuilder(
            animation: Listenable.merge([_breatheController, _stageFlashController]),
            builder: (_, __) {
              final breathe = _breatheController.value;
              final flashOpacity = shouldFlash ? (1.0 - _stageFlashController.value) * 0.25 : 0.0;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                decoration: BoxDecoration(
                  gradient: isComplete
                      ? LinearGradient(
                          colors: [
                            AppTheme.goldPrimary.withValues(alpha: 0.9),
                            AppTheme.goldSoft.withValues(alpha: 0.6),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : isCurrent
                          ? LinearGradient(colors: [
                              AppTheme.goldPrimary.withValues(alpha: 0.12 + breathe * 0.06 + flashOpacity),
                              AppTheme.goldPrimary.withValues(alpha: 0.04 + flashOpacity * 0.5),
                            ])
                          : null,
                  color: isCurrent || isComplete ? null : AppTheme.goldPrimary.withValues(alpha: 0.03),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isComplete
                        ? AppTheme.goldPrimary
                        : isCurrent
                            ? AppTheme.borderGold.withValues(alpha: 0.5 + breathe * 0.3)
                            : AppTheme.borderGold.withValues(alpha: 0.1),
                    width: isCurrent ? 0.8 : 0.5,
                  ),
                  boxShadow: isComplete ? [
                    BoxShadow(
                      color: AppTheme.goldPrimary.withValues(alpha: 0.2),
                      blurRadius: 8,
                    ),
                  ] : null,
                ),
                child: Column(
                  children: [
                    Text(s.$1,
                        style: GoogleFonts.notoKufiArabic(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: isComplete ? AppTheme.bgPrimary : AppTheme.goldPrimary)),
                    const SizedBox(height: 4),
                    Text('${s.$2}',
                        style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isComplete ? AppTheme.bgPrimary : AppTheme.textMuted)),
                    const SizedBox(height: 6),
                    Container(
                      height: 3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: AppTheme.goldPrimary.withValues(alpha: 0.1),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: progress.clamp(0.0, 1.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: isComplete
                                ? AppTheme.bgPrimary
                                : AppTheme.goldPrimary,
                          ),
                        ),
                      ),
                    ),
                    if (isCurrent) ...[
                      const SizedBox(height: 4),
                      Text('${state.currentCount}',
                          style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.goldPrimary)),
                    ],
                    if (isComplete)
                      const Padding(
                        padding: EdgeInsets.only(top: 2),
                        child: Icon(Icons.check_circle_rounded,
                            color: AppTheme.bgPrimary, size: 14),
                      ),
                  ],
                ),
              );
            },
          ),
        );
      }).toList(),
    );
  }

  // ─── Standard Content ───

  Widget _buildStandardContent() {
    final w = MediaQuery.sizeOf(context).width;
    final customList = ref.watch(customTasbihListProvider);

    return Column(
      children: [
        SizedBox(
          height: 44,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            itemCount: _standardTypes.length +
                (_mode == TasbihMode.custom ? customList.length : 0),
            separatorBuilder: (_, __) => const SizedBox(width: 6),
            itemBuilder: (context, i) {
              String label;
              bool active;
              if (_mode == TasbihMode.custom && i >= _standardTypes.length) {
                final c = customList[i - _standardTypes.length];
                label = c.nameArabic;
                active = _customIndex == i - _standardTypes.length;
              } else {
                label = _standardTypes[i].label;
                active = _standardIndex == i;
              }
              return GestureDetector(
                onTap: () {
                  if (_mode == TasbihMode.custom &&
                      i >= _standardTypes.length) {
                    setState(() => _customIndex = i - _standardTypes.length);
                  } else {
                    setState(() {
                      _standardIndex = i;
                      _standardCount = 0;
                    });
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: active ? AppTheme.goldGradient : null,
                    color: active ? null : AppTheme.goldPrimary.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: active
                          ? AppTheme.goldPrimary
                          : AppTheme.borderGold.withValues(alpha: 0.15),
                      width: active ? 0.8 : 0.5,
                    ),
                    boxShadow: active ? [
                      BoxShadow(
                        color: AppTheme.goldPrimary.withValues(alpha: 0.2),
                        blurRadius: 8,
                      ),
                    ] : null,
                  ),
                  child: Center(
                    child: Text(label,
                        style: GoogleFonts.notoKufiArabic(
                            fontSize: 12, fontWeight: FontWeight.w700,
                            color: active ? AppTheme.bgPrimary : AppTheme.textMuted)),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: w < 360 ? 18 : 24),
        if (_mode == TasbihMode.standard)
          _buildStandardDhikrDisplay()
        else
          _buildCustomDhikrDisplay(customList),
      ],
    );
  }

  Widget _buildStandardDhikrDisplay() {
    final w = MediaQuery.sizeOf(context).width;
    final type = _standardTypes[_standardIndex];
    return Column(
      children: [
        _buildPhraseCard(type.label, type.translit, type.target - _standardCount),
        SizedBox(height: w < 360 ? 18 : 24),
        _buildCounterRing(_standardCount, type.target,
            type.target > 0 ? _standardCount / type.target : 0),
      ],
    );
  }

  Widget _buildCustomDhikrDisplay(List<CustomTasbih> customList) {
    final w = MediaQuery.sizeOf(context).width;
    if (customList.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppTheme.borderGold.withValues(alpha: 0.15)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  AppTheme.goldPrimary.withValues(alpha: 0.04),
                  Colors.transparent,
                ]),
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Icon(Icons.add_circle_outline_rounded,
                      size: w < 360 ? 48 : 56, color: AppTheme.goldPrimary.withValues(alpha: 0.3)),
                  const SizedBox(height: 16),
                  Text('لا توجد تسابيح مخصصة',
                      style: GoogleFonts.notoKufiArabic(
                          fontSize: 15, color: AppTheme.textMuted)),
                  const SizedBox(height: 16),
                  GoldButton(
                    label: 'إضافة تسبيحة',
                    onTap: () => _showAddCustomDialog(),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    final c = customList[_customIndex];
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: w < 360 ? 12 : 16),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.borderGold, width: 0.5),
            boxShadow: [
              BoxShadow(color: AppTheme.shadowDark, blurRadius: 20, offset: const Offset(0, 6)),
              BoxShadow(color: AppTheme.shadowGold, blurRadius: 16),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 14, sigmaY: 14),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    AppTheme.goldPrimary.withValues(alpha: 0.06),
                    Colors.transparent,
                  ]),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () => ref.read(customTasbihListProvider.notifier).remove(c.id),
                      child: Icon(Icons.delete_outline_rounded,
                          size: 16, color: AppTheme.textMuted),
                    ),
                    const SizedBox(width: 12),
                    Text(c.nameArabic,
                        style: GoogleFonts.notoKufiArabic(
                            fontSize: 18, fontWeight: FontWeight.bold,
                            color: AppTheme.goldPrimary)),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () => ref
                          .read(customTasbihListProvider.notifier)
                          .toggleFavorite(c.id),
                      child: Icon(
                        c.isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        size: 16,
                        color: c.isFavorite ? Colors.redAccent : AppTheme.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        _buildCounterRing(
            _customCount, c.target, c.target > 0 ? _customCount / c.target : 0),
        if (customList.length > 1) ...[
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  if (_customIndex > 0) {
                    setState(() { _customIndex--; _customCount = 0; });
                    HapticFeedback.selectionClick();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.goldPrimary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.borderGold, width: 0.5),
                  ),
                  child: const Icon(Icons.arrow_forward_rounded,
                      color: AppTheme.goldPrimary, size: 20),
                ),
              ),
              const SizedBox(width: 16),
              Text('${_customIndex + 1} / ${customList.length}',
                  style: GoogleFonts.inter(
                      fontSize: 13, fontWeight: FontWeight.w600,
                      color: AppTheme.textMuted)),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () {
                  if (_customIndex < customList.length - 1) {
                    setState(() { _customIndex++; _customCount = 0; });
                    HapticFeedback.selectionClick();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.goldPrimary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.borderGold, width: 0.5),
                  ),
                  child: const Icon(Icons.arrow_back_rounded,
                      color: AppTheme.goldPrimary, size: 20),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  // ─── Tap Handler ───

  void _handleTap(TasbihAlZahraState zahraState) {
    ref.read(tasbihStatsProvider.notifier).recordTap();

    if (_mode == TasbihMode.zahra) {
      final notifier = ref.read(tasbihAlZahraProvider.notifier);
      final willAdvance = (zahraState.stage == TasbihAlZahraStage.takbeer && zahraState.currentCount + 1 >= 34) ||
          (zahraState.stage == TasbihAlZahraStage.tahmeed && zahraState.currentCount + 1 >= 33);
      final willComplete = zahraState.stage == TasbihAlZahraStage.tasbeeh && zahraState.currentCount + 1 >= 33;

      notifier.increment();

      _counterPopController.forward(from: 0);
      _fingerprintRippleController.forward(from: 0);
      if (kIsWeb) _webPulseController.forward(from: 0);

      if (willAdvance) {
        switch (zahraState.stage) {
          case TasbihAlZahraStage.takbeer:
            _flashStage = TasbihAlZahraStage.tahmeed;
            break;
          case TasbihAlZahraStage.tahmeed:
            _flashStage = TasbihAlZahraStage.tasbeeh;
            break;
          default:
            _flashStage = null;
        }
        _stageFlashController.forward(from: 0);
      }

      if (willComplete) {
        _celebrateController.forward(from: 0);
        ref.read(tasbihHistoryProvider.notifier).add(TasbihSession(
              id: const Uuid().v4(),
              type: 'zahra',
              label: 'تسبيحة الزهراء',
              count: zahraState.totalCount + 1,
              startedAt: DateTime.now(),
            ));
        Future.delayed(const Duration(milliseconds: 1200), () {
          if (mounted) TasbihHadithPopup.show(context);
        });
      }
    } else if (_mode == TasbihMode.standard) {
      final type = _standardTypes[_standardIndex];
      final newCount = _standardCount + 1;
      if (newCount >= type.target) {
        HapticFeedback.heavyImpact();
        ref.read(tasbihHistoryProvider.notifier).add(TasbihSession(
              id: const Uuid().v4(),
              type: 'standard',
              label: type.label,
              count: newCount,
              startedAt: DateTime.now(),
            ));
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) TasbihHadithPopup.show(context);
        });
      } else if (newCount % 33 == 0) {
        HapticFeedback.heavyImpact();
      } else {
        switch (_standardIndex) {
          case 0:
            HapticFeedback.selectionClick();
            break;
          case 1:
            HapticFeedback.lightImpact();
            break;
          case 2:
            HapticFeedback.mediumImpact();
            break;
          default:
            HapticFeedback.lightImpact();
            break;
        }
      }

      _counterPopController.forward(from: 0);
      if (kIsWeb) _webPulseController.forward(from: 0);

      setState(() {
        _standardCount = newCount >= type.target ? 0 : newCount;
      });
    } else if (_mode == TasbihMode.custom) {
      final customList = ref.read(customTasbihListProvider);
      if (_customIndex < customList.length) {
        final c = customList[_customIndex];
        final newCount = _customCount + 1;
        if (newCount >= c.target) {
          HapticFeedback.heavyImpact();
          ref.read(tasbihHistoryProvider.notifier).add(TasbihSession(
                id: const Uuid().v4(),
                type: 'custom',
                label: c.nameArabic,
                count: newCount,
                startedAt: DateTime.now(),
              ));
          Future.delayed(const Duration(milliseconds: 300), () {
            if (mounted) TasbihHadithPopup.show(context);
          });
        } else if (newCount % 33 == 0) {
          HapticFeedback.mediumImpact();
        } else {
          HapticFeedback.lightImpact();
        }

        _counterPopController.forward(from: 0);
        if (kIsWeb) _webPulseController.forward(from: 0);

        setState(() {
          _customCount = newCount >= c.target ? 0 : newCount;
        });
      }
    }
  }

  // ─── Stats ───

  Widget _buildStatsToggle() {
    return GestureDetector(
      onTap: () => setState(() => _showStats = !_showStats),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.borderGold.withValues(alpha: 0.2)),
          boxShadow: [
            BoxShadow(color: AppTheme.shadowDark, blurRadius: 16, offset: const Offset(0, 4)),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(colors: [
                  AppTheme.goldPrimary.withValues(alpha: 0.06),
                  Colors.transparent,
                ]),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(_showStats ? Icons.expand_less_rounded : Icons.bar_chart_rounded,
                      color: AppTheme.goldPrimary, size: 20),
                  const SizedBox(width: 8),
                  Text('الإحصائيات',
                      style: GoogleFonts.notoKufiArabic(
                          fontSize: 13, fontWeight: FontWeight.w600,
                          color: AppTheme.goldPrimary)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsPanel(TasbihStats stats) {
    final goal = ref.watch(tasbihDailyGoalProvider);
    final progress = goal > 0 ? (stats.todayCount / goal).clamp(0.0, 1.0) : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppTheme.borderGold.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(color: AppTheme.shadowDark, blurRadius: 30, offset: const Offset(0, 8)),
          BoxShadow(color: AppTheme.shadowGold, blurRadius: 20),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: LinearGradient(
                colors: [
                  AppTheme.bgCard.withValues(alpha: 0.5),
                  AppTheme.bgSecondary.withValues(alpha: 0.3),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(children: [
                  Expanded(child: _statCard('اليوم', '${stats.todayCount}', Icons.today_rounded)),
                  const SizedBox(width: 8),
                  Expanded(child: _statCard('الأسبوع', '${stats.weeklyCount}', Icons.date_range_rounded)),
                ]),
                const SizedBox(height: 8),
                Row(children: [
                  Expanded(child: _statCard('الشهر', '${stats.monthlyCount}', Icons.calendar_month_rounded)),
                  const SizedBox(width: 8),
                  Expanded(child: _statCard('الإجمالي', '${stats.lifetimeCount}', Icons.all_inclusive_rounded)),
                ]),
                const SizedBox(height: 8),
                Row(children: [
                  Expanded(
                    child: _statCard(
                      'أطول جلسة',
                      '${stats.longestSession}',
                      Icons.timer_rounded,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(colors: [
                          AppTheme.goldPrimary.withValues(alpha: 0.08),
                          AppTheme.goldPrimary.withValues(alpha: 0.02),
                        ]),
                        border: Border.all(
                          color: AppTheme.borderGold,
                          width: 0.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.flag_rounded,
                                  color: AppTheme.goldPrimary, size: 13),
                              const SizedBox(width: 6),
                              Text('الهدف اليومي',
                                  style: GoogleFonts.notoKufiArabic(
                                      fontSize: 9, color: AppTheme.textMuted)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 6,
                              backgroundColor:
                                  AppTheme.goldPrimary.withValues(alpha: 0.1),
                              valueColor: AlwaysStoppedAnimation(
                                progress >= 1.0
                                    ? Colors.greenAccent
                                    : AppTheme.goldPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${stats.todayCount} / $goal',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _statCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(colors: [
          AppTheme.goldPrimary.withValues(alpha: 0.06),
          AppTheme.goldPrimary.withValues(alpha: 0.01),
        ]),
        border: Border.all(
          color: AppTheme.borderGold.withValues(alpha: 0.15),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppTheme.goldPrimary, size: 14),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: GoogleFonts.notoKufiArabic(
                      fontSize: 9, color: AppTheme.textMuted)),
              Text(value,
                  style: GoogleFonts.inter(
                      fontSize: 16, fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary)),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Premium Completion Overlay ───

  Widget _buildCompletionOverlay(TasbihAlZahraState state) {
    final w = MediaQuery.sizeOf(context).width;
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _celebrateController,
        builder: (context, _) {
          final celebrate = _celebrateController.value;
          final scale = 0.6 + 0.4 * celebrate;
          final opacity = celebrate.clamp(0.0, 1.0);
          final particleOpacity = (0.5 * (1.0 - (celebrate - 0.5).clamp(0.0, 0.5) * 2)).clamp(0.0, 1.0);

          return GestureDetector(
            onTap: () {},
            child: Container(
              color: Colors.transparent,
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(
                    sigmaX: 20 * celebrate,
                    sigmaY: 20 * celebrate,
                  ),
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.7 * celebrate),
                    child: Stack(
                      children: [
                        CustomPaint(
                          painter: _CompletionParticlesPainter(celebrate, particleOpacity),
                          size: Size.infinite,
                        ),
                        Center(
                          child: Transform.scale(
                            scale: scale,
                            child: Opacity(
                              opacity: opacity,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: w < 360 ? 68 : 80,
                                    height: w < 360 ? 68 : 80,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: AppTheme.goldGradient,
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppTheme.goldPrimary.withValues(alpha: 0.4),
                                          blurRadius: 30,
                                          spreadRadius: 4,
                                        ),
                                      ],
                                    ),
                                    child: Icon(Icons.celebration_rounded,
                                        color: AppTheme.bgPrimary, size: w < 360 ? 36 : 44),
                                  ),
                                  SizedBox(height: w < 360 ? 18 : 24),
                                  ShaderMask(
                                    shaderCallback: (bounds) => AppTheme.goldGradient.createShader(bounds),
                                    child: Text('✨ تقبل الله ✨',
                                        style: GoogleFonts.notoKufiArabic(
                                            fontSize: w < 360 ? 26 : 34,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: AppTheme.goldPrimary.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: AppTheme.borderGold,
                                        width: 0.5,
                                      ),
                                    ),
                                    child: Text('أحسنت',
                                        style: GoogleFonts.notoKufiArabic(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                            color: AppTheme.goldPrimary)),
                                  ),
                                  const SizedBox(height: 12),
                                  Text('لقد أتممت التسبيح بنجاح',
                                      style: GoogleFonts.notoKufiArabic(
                                          fontSize: 14, color: Colors.white70)),
                                  const SizedBox(height: 24),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      _completionStat('عدد التكبيرات', '34'),
                                      _completionDivider(),
                                      _completionStat('عدد التحميدات', '33'),
                                      _completionDivider(),
                                      _completionStat('عدد التسبيحات', '33'),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: AppTheme.goldPrimary.withValues(alpha: 0.08),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text('المجموع: ${state.totalCount}',
                                        style: GoogleFonts.inter(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: AppTheme.goldPrimary)),
                                  ),
                                  SizedBox(height: w < 360 ? 20 : 28),
                                  GoldButton(
                                    label: 'إعادة',
                                    onTap: () => ref.read(tasbihAlZahraProvider.notifier).reset(),
                                  ),
                                  const SizedBox(height: 10),
                                  GestureDetector(
                                    onTap: _shareAchievement,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(18),
                                        border: Border.all(
                                          color: AppTheme.borderGold,
                                          width: 0.5,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.share_rounded,
                                              color: AppTheme.goldPrimary, size: 16),
                                          const SizedBox(width: 8),
                                          Text('مشاركة الإنجاز',
                                              style: GoogleFonts.notoKufiArabic(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppTheme.goldPrimary)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  TextButton(
                                    onPressed: () => ref.read(tasbihAlZahraProvider.notifier).reset(),
                                    child: Text('إغلاق',
                                        style: GoogleFonts.notoKufiArabic(
                                            color: Colors.white54, fontSize: 13)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _completionStat(String label, String value) {
    return Column(
      children: [
        Text(value,
            style: GoogleFonts.inter(
                fontSize: 18, fontWeight: FontWeight.bold,
                color: AppTheme.goldPrimary)),
        Text(label,
            style: GoogleFonts.notoKufiArabic(
                fontSize: 9, color: Colors.white60)),
      ],
    );
  }

  Widget _completionDivider() {
    return Container(
      width: 1,
      height: 30,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: AppTheme.borderGold,
    );
  }

  void _shareAchievement() {
    final s = ref.read(tasbihAlZahraProvider);
    Share.share('✨ تقبل الله ✨\nأحسنت! لقد أتممت تسبيحة الزهراء\nالمجموع: ${s.totalCount} تسبيحة\n#رفيق');
  }

  // ─── Settings Sheet ───

  void _showSettingsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _buildSettingsSheet(),
    );
  }

  Widget _buildSettingsSheet() {
    final goal = ref.watch(tasbihDailyGoalProvider);
    return DraggableScrollableSheet(
      initialChildSize: 0.45,
      minChildSize: 0.3,
      maxChildSize: 0.6,
      builder: (_, scrollController) => ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.bgSurface.withValues(alpha: 0.95),
                  AppTheme.bgCard.withValues(alpha: 0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border(
                top: BorderSide(color: AppTheme.borderGold, width: 0.5),
              ),
            ),
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.all(24),
              children: [
                Center(
                  child: Container(
                    width: 44, height: 4,
                    decoration: BoxDecoration(
                      color: AppTheme.goldPrimary.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text('الإعدادات',
                    style: GoogleFonts.notoKufiArabic(
                        fontSize: 20, fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary)),
                const SizedBox(height: 8),
                AppTheme.goldDivider(),
                const SizedBox(height: 24),
                _settingsTile(
                  icon: Icons.vibration_rounded,
                  title: 'الاهتزاز',
                  subtitle: 'اهتزاز عند كل ضغطة',
                  trailing: Switch(
                    value: _vibration,
                    onChanged: (v) => setState(() => _vibration = v),
                    activeTrackColor: AppTheme.goldPrimary.withValues(alpha: 0.3),
                    activeThumbColor: AppTheme.goldPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                _settingsTile(
                  icon: Icons.flag_rounded,
                  title: 'الهدف اليومي',
                  subtitle: 'الهدف: $goal تسبيحة',
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          final newGoal = (goal - 100).clamp(100, 10000);
                          ref.read(tasbihDailyGoalProvider.notifier).state = newGoal;
                        },
                        child: _miniButton(Icons.remove_rounded),
                      ),
                      const SizedBox(width: 8),
                      Text('$goal',
                          style: GoogleFonts.inter(
                              fontSize: 16, fontWeight: FontWeight.bold,
                              color: AppTheme.goldPrimary)),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          final newGoal = (goal + 100).clamp(100, 10000);
                          ref.read(tasbihDailyGoalProvider.notifier).state = newGoal;
                        },
                        child: _miniButton(Icons.add_rounded),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                _settingsTile(
                  icon: Icons.delete_sweep_rounded,
                  title: 'إعادة تعيين الإحصائيات',
                  subtitle: 'مسح جميع الإحصائيات',
                  trailing: GestureDetector(
                    onTap: () {
                      ref.invalidate(tasbihStatsProvider);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text('مسح',
                          style: GoogleFonts.notoKufiArabic(
                              fontSize: 12,
                              color: const Color(0xFFCF6679))),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _miniButton(IconData icon) {
    return Container(
      width: 32, height: 32,
      decoration: BoxDecoration(
        color: AppTheme.goldPrimary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.borderGold, width: 0.5),
      ),
      child: Icon(icon, color: AppTheme.goldPrimary, size: 16),
    );
  }

  Widget _settingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(colors: [
          AppTheme.goldPrimary.withValues(alpha: 0.04),
          Colors.transparent,
        ]),
        border: Border.all(
          color: AppTheme.borderGold.withValues(alpha: 0.1),
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.goldPrimary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.notoKufiArabic(
                        fontSize: 14, fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary)),
                Text(subtitle,
                    style: GoogleFonts.notoKufiArabic(
                        fontSize: 11, color: AppTheme.textMuted)),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }

  // ─── Custom Tasbih Dialog ───

  void _showAddCustomDialog() {
    final nameController = TextEditingController();
    final targetController = TextEditingController(text: '33');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        content: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.bgSurface.withValues(alpha: 0.95),
                    AppTheme.bgCard.withValues(alpha: 0.9),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: AppTheme.borderGold, width: 0.5),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('إضافة تسبيحة',
                      style: GoogleFonts.notoKufiArabic(
                          fontSize: 18, fontWeight: FontWeight.bold,
                          color: AppTheme.goldPrimary)),
                  const SizedBox(height: 4),
                  AppTheme.goldDivider(),
                  const SizedBox(height: 16),
                  TextField(
                    controller: nameController,
                    textDirection: TextDirection.rtl,
                    style: GoogleFonts.notoKufiArabic(
                        fontSize: 14, color: AppTheme.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'اسم التسبيحة',
                      hintTextDirection: TextDirection.rtl,
                      hintStyle: GoogleFonts.notoKufiArabic(
                          fontSize: 14, color: AppTheme.textMuted),
                      filled: true,
                      fillColor: AppTheme.goldPrimary.withValues(alpha: 0.04),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: AppTheme.goldPrimary)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: targetController,
                    keyboardType: TextInputType.number,
                    textDirection: TextDirection.ltr,
                    style: GoogleFonts.inter(
                        fontSize: 14, color: AppTheme.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'العدد (مثال: 33)',
                      hintStyle: GoogleFonts.notoKufiArabic(
                          fontSize: 14, color: AppTheme.textMuted),
                      filled: true,
                      fillColor: AppTheme.goldPrimary.withValues(alpha: 0.04),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: AppTheme.goldPrimary)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: Text('إلغاء',
                              style: GoogleFonts.notoKufiArabic(
                                  color: AppTheme.textMuted,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            final name = nameController.text.trim();
                            final target = int.tryParse(targetController.text.trim()) ?? 33;
                            if (name.isNotEmpty) {
                              ref.read(customTasbihListProvider.notifier).add(CustomTasbih(
                                    id: const Uuid().v4(),
                                    name: name,
                                    nameArabic: name,
                                    target: target,
                                    createdAt: DateTime.now(),
                                  ));
                              Navigator.pop(ctx);
                            }
                          },
                          child: Container(
                            height: 44,
                            decoration: BoxDecoration(
                              gradient: AppTheme.goldGradient,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Center(
                              child: Text('إضافة',
                                  style: GoogleFonts.notoKufiArabic(
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.bgPrimary)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Completion Particles Painter ───

class _CompletionParticlesPainter extends CustomPainter {
  final double progress;
  final double opacity;

  _CompletionParticlesPainter(this.progress, this.opacity);

  @override
  void paint(Canvas canvas, Size size) {
    if (opacity <= 0) return;
    final rng = math.Random(42);
    for (int i = 0; i < 30; i++) {
      final x = rng.nextDouble() * size.width;
      final y = (rng.nextDouble() * size.height * 0.6) +
          (progress * size.height * 0.4);
      final alpha = opacity * (0.2 + 0.8 * (1.0 - (y / size.height)));
      final particleSize = 1.5 + rng.nextDouble() * 2.5;
      final paint = Paint()
        ..color = AppTheme.goldPrimary.withValues(alpha: alpha.clamp(0.0, 0.4))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1);
      canvas.drawCircle(Offset(x, y), particleSize, paint);
    }

    final cx = size.width / 2;
    final cy = size.height * 0.3;
    final ornamentPaint = Paint()
      ..color = AppTheme.goldPrimary.withValues(alpha: (0.04 * opacity).clamp(0.0, 0.04))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    final r = 80 + (1.0 - progress) * 20;
    final path = Path();
    for (int i = 0; i < 8; i++) {
      final angle = i * math.pi / 4;
      final x = cx + r * math.cos(angle);
      final y = cy + r * math.sin(angle);
      if (i == 0) { path.moveTo(x, y); } else { path.lineTo(x, y); }
    }
    path.close();
    canvas.drawPath(path, ornamentPaint);
  }

  @override
  bool shouldRepaint(_CompletionParticlesPainter old) =>
      old.progress != progress || old.opacity != opacity;
}

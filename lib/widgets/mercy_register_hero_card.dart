import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vector_graphics/vector_graphics.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../providers/mercy_message_provider.dart';

class MercyRegisterHeroCard extends ConsumerStatefulWidget {
  const MercyRegisterHeroCard({super.key});

  @override
  ConsumerState<MercyRegisterHeroCard> createState() => _MercyRegisterHeroCardState();
}

class _MercyRegisterHeroCardState extends ConsumerState<MercyRegisterHeroCard>
    with TickerProviderStateMixin {
  late AnimationController _particleController;
  late AnimationController _shimmerController;
  Timer? _shimmerTimer;
  
  bool _isHovered = false;
  bool _isPressed = false;
  
  final List<_Particle> _particles = [];

  @override
  void initState() {
    super.initState();
    
    // Ambient floating particles animation
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    // Generate 12 ambient particles
    final random = Random();
    for (int i = 0; i < 12; i++) {
      _particles.add(
        _Particle(
          xRatio: random.nextDouble(),
          yRatio: random.nextDouble(),
          speed: 0.12 + random.nextDouble() * 0.15,
          size: 1.5 + random.nextDouble() * 2.5,
          angle: random.nextDouble() * 2 * pi,
        ),
      );
    }

    // Shimmer sweep every 6 seconds
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _shimmerTimer = Timer.periodic(const Duration(seconds: 6), (timer) {
      if (mounted) {
        _shimmerController.forward(from: 0.0);
      }
    });
  }

  @override
  void dispose() {
    _particleController.dispose();
    _shimmerController.dispose();
    _shimmerTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dailyMessage = ref.watch(mercyMessageProvider);
    final w = MediaQuery.sizeOf(context).width;
    
    // Same height logic as Tasbih card
    final cardH = w < 360 ? 180.0 : w < 420 ? 200.0 : 220.0;
    
    return RepaintBoundary(
      child: AnimatedScale(
        scale: (_isHovered || _isPressed) ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: cardH,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppTheme.goldPrimary.withValues(
                alpha: (_isHovered || _isPressed) ? 0.35 : 0.15,
              ),
              width: 0.8,
            ),
            gradient: const LinearGradient(
              colors: [
                Color(0xFF081326),
                Color(0xFF11264E),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 30,
                offset: const Offset(0, 10),
                spreadRadius: -4,
              ),
              if (_isHovered || _isPressed)
                BoxShadow(
                  color: AppTheme.goldPrimary.withValues(alpha: 0.2),
                  blurRadius: 24,
                  spreadRadius: 1,
                  offset: const Offset(0, 0),
                ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              children: [
                // 1. Very subtle Islamic geometric pattern
                const Positioned.fill(
                  child: Opacity(
                    opacity: 0.03,
                    child: VectorGraphic(
                      loader: AssetBytesLoader('assets/decorations/star_pattern.svg.vec'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // 2. Extremely subtle floating particles
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: _particleController,
                    builder: (context, _) {
                      return CustomPaint(
                        painter: _ParticlePainter(_particles, _particleController.value),
                      );
                    },
                  ),
                ),

                // 3. Gold shimmer sweep every few seconds
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: _shimmerController,
                    builder: (context, _) {
                      if (!_shimmerController.isAnimating) return const SizedBox.shrink();
                      final progress = _shimmerController.value;
                      final xTranslation = (progress * 3.0) - 1.5;
                      return FractionallySizedBox(
                        widthFactor: 0.3,
                        alignment: Alignment(xTranslation, 0),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                AppTheme.goldPrimary.withValues(alpha: 0.12),
                                AppTheme.goldPrimary.withValues(alpha: 0.03),
                                Colors.transparent,
                              ],
                              stops: const [0.0, 0.5, 0.7, 1.0],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // 4. Soft gold decorative corners
                ..._buildCorners(),

                // 5. Hero & InkWell interaction layer
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => context.push('/mercy-register'),
                      onHover: (hovered) => setState(() => _isHovered = hovered),
                      onTapDown: (_) => setState(() => _isPressed = true),
                      onTapCancel: () => setState(() => _isPressed = false),
                      splashColor: AppTheme.goldPrimary.withValues(alpha: 0.08),
                      highlightColor: AppTheme.goldPrimary.withValues(alpha: 0.03),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Header
                            _buildHeader(),
                            const SizedBox(height: 6),
                            
                            // Main Content (split visually into Left/Right)
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Left section: Elegant Islamic Crescent Illustration
                                  SizedBox(
                                    width: (w - 32) * 0.35,
                                    child: Center(
                                      child: Hero(
                                        tag: 'mercy_register_card',
                                        child: CustomPaint(
                                          size: const Size(64, 64),
                                          painter: _CrescentMoonPainter(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  
                                  // Right section: Daily Message
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          dailyMessage,
                                          style: GoogleFonts.notoKufiArabic(
                                            fontSize: w < 360 ? 11 : 13,
                                            fontWeight: FontWeight.w600,
                                            color: AppTheme.textPrimary,
                                            height: 1.5,
                                          ),
                                          textAlign: TextAlign.right,
                                          textDirection: TextDirection.rtl,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              'تتغير هذه الرسالة يوميًا',
                                              style: GoogleFonts.notoKufiArabic(
                                                fontSize: 9,
                                                color: AppTheme.textMutedPremium.withValues(alpha: 0.5),
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            Icon(
                                              Icons.info_outline_rounded,
                                              size: 10,
                                              color: AppTheme.goldPrimary.withValues(alpha: 0.5),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 8),
                            
                            // Bottom: Premium Button
                            _buildBottomButton(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.08, end: 0, curve: Curves.easeOutQuad);
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'إهداء الثواب',
              style: GoogleFonts.notoKufiArabic(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppTheme.goldWarm,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        // Gold Accent Line
        Container(
          width: 64,
          height: 1.2,
          decoration: const BoxDecoration(
            gradient: AppTheme.goldGradient,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'اهدِ ثواب أعمالك لمن تحب من موتى المسلمين',
          style: GoogleFonts.notoKufiArabic(
            fontSize: 9.5,
            color: AppTheme.textMutedPremium,
          ),
          textDirection: TextDirection.rtl,
        ),
      ],
    );
  }

  Widget _buildBottomButton() {
    return Center(
      child: Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          gradient: AppTheme.goldGradient,
          borderRadius: BorderRadius.circular(19),
          boxShadow: [
            BoxShadow(
              color: AppTheme.goldPrimary.withValues(alpha: 0.25),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'الدخول إلى سجل الرحمة',
              style: GoogleFonts.notoKufiArabic(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: AppTheme.bgPrimary,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_back_rounded, // Left arrow pointing forward in RTL
              size: 15,
              color: AppTheme.bgPrimary,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCorners() {
    const size = 22.0;
    final cornerWidget = Opacity(
      opacity: 0.2,
      child: const SizedBox(
        width: size,
        height: size,
        child: VectorGraphic(
          loader: AssetBytesLoader('assets/decorations/islamic_corner.svg.vec'),
          fit: BoxFit.contain,
        ),
      ),
    );

    return [
      Positioned(top: 4, left: 4, child: cornerWidget),
      Positioned(top: 4, right: 4, child: RotatedBox(quarterTurns: 1, child: cornerWidget)),
      Positioned(bottom: 4, right: 4, child: RotatedBox(quarterTurns: 2, child: cornerWidget)),
      Positioned(bottom: 4, left: 4, child: RotatedBox(quarterTurns: 3, child: cornerWidget)),
    ];
  }
}

class _Particle {
  final double xRatio;
  final double yRatio;
  final double speed;
  final double size;
  final double angle;

  _Particle({
    required this.xRatio,
    required this.yRatio,
    required this.speed,
    required this.size,
    required this.angle,
  });
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double animationValue;

  _ParticlePainter(this.particles, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (var p in particles) {
      final x = p.xRatio * size.width + sin(animationValue * 2 * pi + p.angle) * 6;
      final y = ((p.yRatio - animationValue * p.speed) % 1.0) * size.height;
      
      // Fade out smoothly near borders
      final borderFade = sin(((y / size.height) * pi).clamp(0.0, pi));
      final opacity = (0.04 + 0.12 * borderFade);
      paint.color = AppTheme.goldPrimary.withValues(alpha: opacity);
      
      canvas.drawCircle(Offset(x, y), p.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}

class _CrescentMoonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * 0.32;

    // 1. Soft radial light glow behind crescent
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppTheme.goldPrimary.withValues(alpha: 0.22),
          AppTheme.goldPrimary.withValues(alpha: 0.05),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: size.width * 0.45));
    canvas.drawCircle(Offset(cx, cy), size.width * 0.45, glowPaint);

    // 2. Crescent Moon Path Difference
    final moonPaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          AppTheme.goldWarm,
          AppTheme.goldLight,
        ],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
      ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: r))
      ..style = PaintingStyle.fill;

    final path = Path()..addOval(Rect.fromCircle(center: Offset(cx, cy), radius: r));
    final cutPath = Path()
      ..addOval(Rect.fromCircle(center: Offset(cx + r * 0.35, cy - r * 0.1), radius: r * 0.95));
      
    final crescentPath = Path.combine(PathOperation.difference, path, cutPath);
    canvas.drawPath(crescentPath, moonPaint);

    // 3. Hanging lantern from tip of crescent
    final tipX = cx - r * 0.1;
    final tipY = cy - r * 0.75;
    final lanternY = cy - 2;

    final stringPaint = Paint()
      ..color = AppTheme.goldPrimary.withValues(alpha: 0.4)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(tipX, tipY), Offset(tipX, lanternY), stringPaint);

    // Mini lantern body
    final lanternPaint = Paint()
      ..color = AppTheme.goldWarm
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromCenter(center: Offset(tipX, lanternY + 4), width: 5, height: 7), lanternPaint);

    // Mini glow inside lantern
    canvas.drawCircle(
      Offset(tipX, lanternY + 4),
      4,
      Paint()
        ..color = AppTheme.goldLight.withValues(alpha: 0.7)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
    );

    // 4. Soft clouds silhouette at the bottom
    final cloudPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.04)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx - 10, cy + r * 0.72), 12, cloudPaint);
    canvas.drawCircle(Offset(cx + 8, cy + r * 0.76), 10, cloudPaint);

    // 5. Sparkling star
    final starCenter = Offset(cx - r * 0.1, cy - r * 0.2);
    canvas.drawCircle(
      starCenter,
      6,
      Paint()
        ..color = AppTheme.goldLight.withValues(alpha: 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );
    _drawStar(canvas, starCenter, 3.5);
  }

  void _drawStar(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..color = AppTheme.goldLight.withValues(alpha: 0.9)
      ..style = PaintingStyle.fill;
    
    final path = Path();
    for (int i = 0; i < 4; i++) {
      final angle = i * pi / 2;
      path.moveTo(center.dx, center.dy);
      path.lineTo(center.dx + cos(angle) * radius * 1.8, center.dy + sin(angle) * radius * 1.8);
    }
    
    canvas.drawPath(
      path,
      Paint()
        ..color = AppTheme.goldLight.withValues(alpha: 0.6)
        ..strokeWidth = 0.6
        ..style = PaintingStyle.stroke,
    );
    canvas.drawCircle(center, radius * 0.3, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

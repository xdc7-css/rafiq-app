import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/qibla_models.dart';
import '../painters/compass_painter.dart';

class QiblaCompass extends StatefulWidget {
  final double heading;
  final double qiblahBearing;
  final double remainingAngle;
  final bool isAligned;
  final double alignmentProgress;
  final double glowIntensity;
  final double size;

  const QiblaCompass({
    super.key,
    required this.heading,
    required this.qiblahBearing,
    required this.remainingAngle,
    this.isAligned = false,
    this.alignmentProgress = 0.0,
    this.glowIntensity = 0.0,
    required this.size,
  });

  @override
  State<QiblaCompass> createState() => _QiblaCompassState();
}

class _QiblaCompassState extends State<QiblaCompass> {
  double _needleAngle = 0;
  double _smoothedAngle = 0;
  bool _initialized = false;

  @override
  void didUpdateWidget(QiblaCompass oldWidget) {
    super.didUpdateWidget(oldWidget);
    final rawAngle = _normalizeShortest(
      widget.qiblahBearing - widget.heading,
    );

    if (!_initialized) {
      _smoothedAngle = rawAngle;
      _needleAngle = rawAngle;
      _initialized = true;
    } else {
      var delta = rawAngle - _smoothedAngle;
      while (delta > 180) delta -= 360;
      while (delta < -180) delta += 360;
      _smoothedAngle += delta * 0.35;
      _smoothedAngle = _smoothedAngle % 360;
      if (_smoothedAngle > 180) _smoothedAngle -= 360;
    }
  }

  static double _normalizeShortest(double angle) {
    var result = angle % 360;
    if (result > 180) result -= 360;
    if (result < -180) result += 360;
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final needleTarget = _smoothedAngle;
    final kaabaAngle = widget.qiblahBearing * math.pi / 180;
    final markerRadius = widget.size * 0.41;
    final markerSize = widget.size * 0.10;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: widget.size,
            height: widget.size,
            child: CustomPaint(
              painter: CompassPainter(
                glowIntensity: widget.glowIntensity,
              ),
            ),
          ),

          TweenAnimationBuilder<double>(
            tween: _ShortestAngleTween(
              currentAngle: _needleAngle,
              targetAngle: needleTarget,
            ),
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            onEnd: () {
              _needleAngle = needleTarget;
            },
            builder: (context, angle, _) {
              return Transform.rotate(
                angle: angle * math.pi / 180,
                child: SizedBox(
                  width: widget.size,
                  height: widget.size,
                  child: CustomPaint(
                    painter: _QiblaNeedlePainter(
                      isAligned: widget.isAligned,
                      glowIntensity: widget.glowIntensity,
                      remainingAngle: widget.remainingAngle,
                    ),
                  ),
                ),
              );
            },
          ),

          Positioned(
            top: widget.size * 0.025,
            child: _FixedIndicator(isAligned: widget.isAligned),
          ),

          Positioned(
            left: widget.size / 2 +
                markerRadius * math.sin(kaabaAngle) -
                markerSize / 2,
            top: widget.size / 2 -
                markerRadius * math.cos(kaabaAngle) -
                markerSize / 2,
            child: _KaabaOrbitMarker(
              size: markerSize,
              isAligned: widget.isAligned,
              glowIntensity: widget.glowIntensity,
              remainingAngle: widget.remainingAngle,
            ),
          ),
        ],
      ),
    );
  }
}

class _ShortestAngleTween extends Tween<double> {
  _ShortestAngleTween({
    required double currentAngle,
    required double targetAngle,
  }) : super(
          begin: currentAngle,
          end: currentAngle + _shortestDelta(currentAngle, targetAngle),
        );

  static double _shortestDelta(double from, double to) {
    var delta = (to - from) % 360;
    if (delta > 180) delta -= 360;
    if (delta < -180) delta += 360;
    return delta;
  }
}

class _QiblaNeedlePainter extends CustomPainter {
  final bool isAligned;
  final double glowIntensity;
  final double remainingAngle;

  const _QiblaNeedlePainter({
    required this.isAligned,
    required this.glowIntensity,
    required this.remainingAngle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = math.min(cx, cy);

    canvas.save();
    canvas.translate(cx, cy);

    final pointerLen = r * 0.70;
    final baseWidth = r * 0.08;
    final baseRadius = r * 0.04;

    double glowAlpha = 0.15;
    double glowSpread = 4.0;
    if (remainingAngle < 10.0) {
      final progress = (10.0 - remainingAngle) / 10.0;
      glowAlpha = 0.15 + progress * 0.35;
      glowSpread = 4.0 + progress * 8.0;
    }
    if (isAligned) {
      glowAlpha = 0.6;
      glowSpread = 14.0;
    }

    final shadowPaint = Paint()
      ..color = (isAligned ? QiblaColors.success : QiblaColors.gold)
          .withValues(alpha: glowAlpha)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, glowSpread);

    final pointerPath = Path()
      ..moveTo(-baseWidth / 2, 0)
      ..lineTo(0, -pointerLen)
      ..lineTo(baseWidth / 2, 0)
      ..arcToPoint(
        Offset(-baseWidth / 2, 0),
        radius: Radius.circular(baseRadius),
        clockwise: true,
      )
      ..close();

    canvas.drawPath(pointerPath, shadowPaint);

    final mainPaint = Paint()
      ..shader = LinearGradient(
        begin: const Alignment(0.0, 1.0),
        end: const Alignment(0.0, -1.0),
        colors: isAligned
            ? [
                const Color(0xFF2ECC71),
                QiblaColors.success,
                const Color(0xFFE8F8F0),
              ]
            : [
                QiblaColors.goldDark,
                QiblaColors.gold,
                QiblaColors.lightGold,
              ],
        stops: const [0.0, 0.7, 1.0],
      ).createShader(Rect.fromLTRB(-baseWidth, -pointerLen, baseWidth, 0))
      ..style = PaintingStyle.fill;

    canvas.drawPath(pointerPath, mainPaint);

    final dividerPath = Path()
      ..moveTo(0, -pointerLen)
      ..lineTo(0, 0)
      ..lineTo(baseWidth / 2, 0)
      ..close();
    final dividerPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;
    canvas.drawPath(dividerPath, dividerPaint);

    final capR = r * 0.085;
    final capPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.15, -0.2),
        colors: [
          QiblaColors.lightGold,
          QiblaColors.gold,
          QiblaColors.goldDark,
          Color(0xFF3E2D0A),
        ],
        stops: [0.0, 0.4, 0.8, 1.0],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: capR));
    canvas.drawCircle(Offset.zero, capR, capPaint);

    final rimPaint = Paint()
      ..color = QiblaColors.lightGold.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawCircle(Offset.zero, capR, rimPaint);

    final jewelR = capR * 0.45;
    final jewelPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.2, -0.2),
        colors: isAligned
            ? [
                const Color(0xFFE8F8F0),
                QiblaColors.success,
                const Color(0xFF1E8449),
              ]
            : [
                const Color(0xFFFFF3CD),
                QiblaColors.gold,
                QiblaColors.goldDark,
              ],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: jewelR));
    canvas.drawCircle(Offset.zero, jewelR, jewelPaint);

    final shinePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 0.8);
    canvas.drawCircle(
      Offset(-jewelR * 0.25, -jewelR * 0.25),
      jewelR * 0.2,
      shinePaint,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _QiblaNeedlePainter old) {
    return old.isAligned != isAligned ||
        old.glowIntensity != glowIntensity ||
        old.remainingAngle != remainingAngle;
  }
}

class _FixedIndicator extends StatelessWidget {
  final bool isAligned;
  const _FixedIndicator({this.isAligned = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomPaint(
          size: const Size(18, 14),
          painter: _TrianglePainter(
            color: isAligned ? QiblaColors.success : QiblaColors.gold,
          ),
        ),
        Container(
          width: 3,
          height: 10,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                isAligned ? QiblaColors.success : QiblaColors.gold,
                (isAligned ? QiblaColors.success : QiblaColors.gold)
                    .withValues(alpha: 0.0),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;
  const _TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [color, color.withValues(alpha: 0.7)],
      ).createShader(Offset.zero & size)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _TrianglePainter old) => old.color != color;
}

class _KaabaOrbitMarker extends StatelessWidget {
  final double size;
  final bool isAligned;
  final double glowIntensity;
  final double remainingAngle;

  const _KaabaOrbitMarker({
    required this.size,
    this.isAligned = false,
    this.glowIntensity = 0.0,
    required this.remainingAngle,
  });

  @override
  Widget build(BuildContext context) {
    double scale = 1.0;
    if (isAligned) {
      scale = 1.15 + 0.10 * glowIntensity;
    } else if (remainingAngle < 5.0) {
      scale = 1.0 + 0.08 * (glowIntensity / 0.15).clamp(0.0, 1.0);
    }

    final glowAlpha = isAligned
        ? 0.20 + glowIntensity * 0.20
        : (remainingAngle < 5.0 ? 0.10 + glowIntensity : 0.08);

    return Transform.scale(
      scale: scale,
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: size * 1.4,
              height: size * 1.4,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    (isAligned ? QiblaColors.success : QiblaColors.gold)
                        .withValues(alpha: glowAlpha),
                    Colors.transparent,
                  ],
                ),
              ),
            ),

            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment(-0.3, -0.3),
                  end: Alignment(0.3, 0.3),
                  colors: [Color(0xFF1A2F4D), Color(0xFF0E1A30)],
                ),
                border: Border.all(
                  color: isAligned
                      ? QiblaColors.success.withValues(alpha: 0.8)
                      : QiblaColors.gold.withValues(alpha: 0.6),
                  width: isAligned ? 2.2 : 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (isAligned ? QiblaColors.success : QiblaColors.gold)
                        .withValues(
                            alpha: isAligned
                                ? 0.3 + glowIntensity * 0.2
                                : 0.15 + glowIntensity * 0.5),
                    blurRadius: isAligned
                        ? 12 + glowIntensity * 8
                        : 6 + glowIntensity * 4,
                    spreadRadius: isAligned ? 1.5 + glowIntensity * 2.0 : 0.5,
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/kaaba.png',
                  fit: BoxFit.contain,
                  gaplessPlayback: true,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.mosque_rounded,
                    size: size * 0.5,
                    color: QiblaColors.gold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

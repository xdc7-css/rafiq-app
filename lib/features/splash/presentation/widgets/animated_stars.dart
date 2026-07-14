import 'dart:math' as math;
import 'package:flutter/material.dart';

class AnimatedStars extends StatefulWidget {
  const AnimatedStars({super.key});

  @override
  State<AnimatedStars> createState() => _AnimatedStarsState();
}

class _AnimatedStarsState extends State<AnimatedStars>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_Star> _stars;
  final _random = math.Random();

  @override
  void initState() {
    super.initState();
    // Drifts and twinkles are animated via a single continuous controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();

    _stars = List.generate(45, (_) => _Star(random: _random));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Stars Layer
        RepaintBoundary(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return CustomPaint(
                painter: _StarsPainter(
                  stars: _stars,
                  progress: _controller.value,
                ),
                size: Size.infinite,
              );
            },
          ),
        ),
        // Overlaid Shooting Stars
        const ShootingStar(),
      ],
    );
  }
}

class _Star {
  final double x;
  final double y;
  final double size;
  final double twinkleSpeed;
  final double twinkleOffset;
  final double driftSpeed;
  final double driftAngle;

  _Star({required math.Random random})
      : x = random.nextDouble(),
        y = random.nextDouble() * 0.75, // Confine stars to top 75% of screen
        size = 0.6 + random.nextDouble() * 1.4,
        twinkleSpeed = 0.8 + random.nextDouble() * 2.2,
        twinkleOffset = random.nextDouble() * math.pi * 2,
        driftSpeed = 0.001 + random.nextDouble() * 0.003,
        driftAngle = random.nextDouble() * math.pi * 2;
}

class _StarsPainter extends CustomPainter {
  final List<_Star> stars;
  final double progress;

  _StarsPainter({required this.stars, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final star in stars) {
      // Calculate slow drift
      final drift = progress * star.driftSpeed * 8;
      final x = ((star.x + drift * math.cos(star.driftAngle)) % 1.0) * size.width;
      final y = ((star.y + drift * math.sin(star.driftAngle) * 0.35) % 0.75) * size.height;

      // Twinkling effect using sine wave
      final twinkle = 0.2 +
          0.8 *
              ((math.sin(progress * math.pi * 2 * star.twinkleSpeed +
                      star.twinkleOffset) +
                  1) /
                  2);

      final paint = Paint()
        ..color = Color.lerp(
          const Color(0xFFF4D27A), // Secondary Gold
          Colors.white,
          0.7,
        )!.withValues(alpha: twinkle * 0.5)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 0.5);

      canvas.drawCircle(Offset(x, y), star.size, paint);
    }
  }

  @override
  bool shouldRepaint(_StarsPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class ShootingStar extends StatefulWidget {
  const ShootingStar({super.key});

  @override
  State<ShootingStar> createState() => _ShootingStarState();
}

class _ShootingStarState extends State<ShootingStar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<double> _position;
  final _random = math.Random();

  double _startX = 0;
  double _startY = 0;
  double _angle = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _opacity = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 60),
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 20),
    ]).animate(_controller);

    _position = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _scheduleNext();
      }
    });

    _scheduleNext();
  }

  void _scheduleNext() {
    if (!mounted) return;
    // Trigger a shooting star every 6 to 12 seconds randomly
    Future.delayed(
      Duration(seconds: 6 + _random.nextInt(6)),
      () {
        if (mounted) {
          _reset();
          _controller.forward(from: 0);
        }
      },
    );
  }

  void _reset() {
    _startX = 0.15 + _random.nextDouble() * 0.7; // Avoid screen edges
    _startY = 0.05 + _random.nextDouble() * 0.25;
    _angle = 0.35 + _random.nextDouble() * 0.35; // diagonal down-right
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          if (_controller.value == 0 || _opacity.value == 0) {
            return const SizedBox.shrink();
          }

          final size = MediaQuery.sizeOf(context);
          final startX = _startX * size.width;
          final startY = _startY * size.height;
          final len = size.width * 0.15 * _position.value;
          final endX = startX + len * math.cos(_angle);
          final endY = startY + len * math.sin(_angle);

          return CustomPaint(
            painter: _ShootingStarPainter(
              start: Offset(startX, startY),
              end: Offset(endX, endY),
              opacity: _opacity.value,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _ShootingStarPainter extends CustomPainter {
  final Offset start;
  final Offset end;
  final double opacity;

  _ShootingStarPainter({
    required this.start,
    required this.end,
    required this.opacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xFFFFD970).withValues(alpha: opacity),
          Colors.transparent,
        ],
      ).createShader(Rect.fromPoints(start, end))
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(start, end, paint);

    // Glowing head
    final glowPaint = Paint()
      ..color = const Color(0xFFFFD970).withValues(alpha: opacity * 0.9)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
    canvas.drawCircle(end, 2.2, glowPaint);
  }

  @override
  bool shouldRepaint(_ShootingStarPainter oldDelegate) =>
      oldDelegate.opacity != opacity ||
      oldDelegate.start != start ||
      oldDelegate.end != end;
}

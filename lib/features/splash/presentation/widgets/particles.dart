import 'dart:math' as math;
import 'package:flutter/material.dart';

class ParticlesWidget extends StatefulWidget {
  const ParticlesWidget({super.key});

  @override
  State<ParticlesWidget> createState() => _ParticlesWidgetState();
}

class _ParticlesWidgetState extends State<ParticlesWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_Particle> _particles;
  final _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 25),
    )..repeat();

    _particles = List.generate(20, (_) => _Particle(random: _random));
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
          return CustomPaint(
            painter: _ParticlesPainter(
              particles: _particles,
              progress: _controller.value,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _Particle {
  final double x;
  final double y;
  final double radius;
  final double speed;
  final double driftScale;
  final double driftFrequency;

  _Particle({required math.Random random})
      : x = random.nextDouble(),
        y = random.nextDouble(),
        radius = 1.5 + random.nextDouble() * 2.5,
        speed = 0.05 + random.nextDouble() * 0.08,
        driftScale = 0.02 + random.nextDouble() * 0.03,
        driftFrequency = 1.0 + random.nextDouble() * 2.0;
}

class _ParticlesPainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;

  _ParticlesPainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      // Calculate upward movement. Wraps at the top (0.0).
      double yFraction = (p.y - progress * p.speed) % 1.0;
      final y = yFraction * size.height;

      // Horizontal wave drift
      final drift = math.sin(progress * p.driftFrequency * math.pi * 2) * p.driftScale * size.width;
      final x = ((p.x * size.width) + drift) % size.width;

      // Opacity fades near edges of screen
      double edgeFade = 1.0;
      if (yFraction < 0.1) {
        edgeFade = yFraction / 0.1;
      } else if (yFraction > 0.9) {
        edgeFade = (1.0 - yFraction) / 0.1;
      }

      final paint = Paint()
        ..color = const Color(0xFFFFD970).withValues(alpha: 0.08 * edgeFade) // Golden-amber glow, very subtle
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0);

      canvas.drawCircle(Offset(x, y), p.radius, paint);
    }
  }

  @override
  bool shouldRepaint(_ParticlesPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

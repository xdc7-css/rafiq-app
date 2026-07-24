import 'package:flutter/material.dart';
import 'package:vector_graphics/vector_graphics.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimatedLogo extends StatelessWidget {
  const AnimatedLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox(
        width: 125,
        height: 125,
        child: VectorGraphic(
          loader: AssetBytesLoader('assets/images/logo.svg.vec'),
          fit: BoxFit.contain,
        ),
      )
          .animate()
          .scale(
            begin: const Offset(0.75, 0.75),
            end: const Offset(1.0, 1.0),
            duration: 900.ms,
            curve: Curves.easeOutBack, // Playful yet premium springy feel
          )
          .fadeIn(
            duration: 900.ms,
            curve: Curves.easeOut,
          ),
    );
  }
}

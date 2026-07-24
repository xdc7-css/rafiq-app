import 'package:flutter/material.dart';

class KaabaWidget extends StatelessWidget {
  const KaabaWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 125,
      height: 125,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          colors: [Color(0xff1E293B), Color(0xff111A33)],
        ),
        border: Border.all(color: const Color(0xffD4AF37), width: 2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xffD4AF37).withValues(alpha: .18),
            blurRadius: 30,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            //---------------------------------
            // Glow
            //---------------------------------
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xffD4AF37).withValues(alpha: .08),
              ),
            ),

            //---------------------------------
            // Kaaba
            //---------------------------------
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xff2B2B2B), Color(0xff050505)],
                ),
              ),
            ),

            //---------------------------------
            // Gold Belt
            //---------------------------------
            Positioned(
              top: 23,
              child: Container(
                width: 58,
                height: 6,
                decoration: BoxDecoration(
                  color: const Color(0xffD4AF37),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),

            //---------------------------------
            // Left Face
            //---------------------------------
            Positioned(
              right: 35,
              child: Container(
                width: 8,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: .35),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),

            //---------------------------------
            // Door
            //---------------------------------
            Positioned(
              bottom: 18,
              child: Container(
                width: 12,
                height: 22,
                decoration: BoxDecoration(
                  color: const Color(0xffD4AF37),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

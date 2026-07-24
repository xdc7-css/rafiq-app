import 'package:flutter/material.dart';

class QiblaStatusCard extends StatelessWidget {
  final double heading;
  final double qiblaDirection;
  final String city;
  final bool aligned;

  const QiblaStatusCard({
    super.key,
    required this.heading,
    required this.qiblaDirection,
    required this.city,
    required this.aligned,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xff18233D), Color(0xff111A33)],
        ),
        border: Border.all(
          color: const Color(0xffD4AF37).withValues(alpha: .18),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .18),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),

      child: Column(
        children: [
          //--------------------------------
          Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: aligned ? Colors.greenAccent : Colors.orangeAccent,
                  boxShadow: [
                    BoxShadow(
                      color: aligned ? Colors.greenAccent : Colors.orangeAccent,
                      blurRadius: 14,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Text(
                  aligned ? "أنت تواجه القبلة" : "حرّك الهاتف قليلاً",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: aligned
                      ? Colors.green.withValues(alpha: .18)
                      : Colors.amber.withValues(alpha: .15),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  aligned ? "متوافق" : "غير متوافق",
                  style: TextStyle(
                    color: aligned ? Colors.greenAccent : Colors.amber,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          //--------------------------------
          Row(
            children: [
              Expanded(
                child: _InfoTile(
                  title: "اتجاه الهاتف",
                  value: "${heading.toStringAsFixed(0)}°",
                  icon: Icons.explore,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: _InfoTile(
                  title: "اتجاه القبلة",
                  value: "${qiblaDirection.toStringAsFixed(0)}°",
                  icon: Icons.navigation,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: _InfoTile(
                  title: "الموقع",
                  value: city,
                  icon: Icons.location_on,
                ),
              ),

              const SizedBox(width: 16),

              const Expanded(
                child: _InfoTile(
                  title: "الدقة",
                  value: "Excellent",
                  icon: Icons.gps_fixed,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/////////////////////////////////////////////////////////////

class _InfoTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _InfoTile({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: const Color(0xff1E293B),

        borderRadius: BorderRadius.circular(22),
      ),

      child: Column(
        children: [
          Icon(icon, color: const Color(0xffD4AF37)),

          const SizedBox(height: 12),

          Text(title, style: const TextStyle(color: Colors.white70)),

          const SizedBox(height: 8),

          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}

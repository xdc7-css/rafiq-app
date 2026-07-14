import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../theme/app_theme.dart';
import '../../../../theme/ds_components.dart';
import '../../../../widgets/star_background.dart';
import '../../../../core/utils/hijri_date.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen>
    with TickerProviderStateMixin {
  DateTime _selectedDate = DateTime.now();
  late final AnimationController _fadeCtrl;
  late final AnimationController _monthCtrl;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..forward();
    _monthCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0.0,
      upperBound: 1.0,
    )..value = 1.0;
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _monthCtrl.dispose();
    super.dispose();
  }

  void _goMonth(int delta) {
    _monthCtrl.reverse(from: 1.0).then((_) {
      setState(() {
        _selectedDate = DateTime(
          _selectedDate.year,
          _selectedDate.month + delta,
          _selectedDate.day,
        );
      });
      _monthCtrl.forward(from: 0.0);
    });
  }

  void _selectDay(int day) {
    final hijriSelected = HijriDate.fromDate(_selectedDate);
    final maxDays = _daysInHijriMonth(hijriSelected.month, hijriSelected.year);
    if (day < 1 || day > maxDays) return;
    HapticFeedback.selectionClick();
    setState(() {
      _selectedDate = _hijriToGregorian(
        hijriSelected.year,
        hijriSelected.month,
        day,
      );
    });
  }

  int _daysInHijriMonth(int month, int year) {
    final normal = [30, 29, 30, 29, 30, 29, 30, 29, 30, 29, 30, 29];
    final isLeapYear = [2, 5, 7, 10, 13, 16, 18, 21, 24, 26, 29]
        .contains(year % 30);
    if (isLeapYear && month == 12) return 30;
    return normal[month - 1];
  }

  DateTime _hijriToGregorian(int hY, int hM, int hD) {
    int jd = (hD +
            ((hM - 1) * 29.5).round() +
            (hY - 1) * 354 +
            (3 + ((hY * 11) % 30)) ~/ 2 +
            1948440 -
            385);
    int l = jd + 68569;
    int n = ((4 * l) / 146097).floor();
    l = l - ((146097 * n + 3) / 4).floor();
    int i = ((4000 * (l + 1)) / 1461001).floor();
    l = l - ((1461 * i) / 4).floor() + 31;
    int j = ((80 * l) / 2447).floor();
    int day = l - ((2447 * j) / 80).floor();
    l = j ~/ 11;
    int month = j + 2 - 12 * l;
    int year = 100 * (n - 49) + i + l;
    return DateTime(year, month, day);
  }

  String _moonPhaseEmoji(int hijriDay) {
    if (hijriDay <= 1) return '🌑';
    if (hijriDay <= 4) return '🌒';
    if (hijriDay <= 7) return '🌓';
    if (hijriDay <= 10) return '🌔';
    if (hijriDay <= 14) return '🌕';
    if (hijriDay <= 17) return '🌖';
    if (hijriDay <= 21) return '🌗';
    if (hijriDay <= 25) return '🌘';
    return '🌑';
  }

  String _moonPhaseName(int hijriDay) {
    if (hijriDay <= 1) return 'شهر جديد';
    if (hijriDay <= 7) return 'هلال متزايد';
    if (hijriDay <= 10) return 'تربيع أول';
    if (hijriDay <= 14) return 'تربيع ثاني';
    if (hijriDay <= 17) return 'بدر';
    if (hijriDay <= 21) return 'تربيع أخير';
    if (hijriDay <= 25) return 'تربيع أخير';
    return 'أسود';
  }

  static const _weekdayLabels = [
    'سب',
    'أح',
    'إث',
    'ثل',
    'أر',
    'خم',
    'جم',
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentGold = AppTheme.goldPrimary;
    final primaryTextColor = AppTheme.textPrimary;
    final secondaryTextColor = AppTheme.textMuted;
    final hijri = HijriDate.fromDate(_selectedDate);
    final maxDays = _daysInHijriMonth(hijri.month, hijri.year);
    final isSelectedToday = _selectedDate.year == DateTime.now().year &&
        _selectedDate.month == DateTime.now().month &&
        _selectedDate.day == DateTime.now().day;

    return Scaffold(
      body: Stack(
        children: [
          const StarBackground(),
          FadeTransition(
            opacity: _fadeCtrl,
            child: SafeArea(
              child: CustomScrollView(
                slivers: [
                  // ── Back Button ──
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 24, 0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: _GlassCircleButton(
                          icon: Icons.arrow_back_ios_new_rounded,
                          onTap: () => context.pop(),
                        ),
                      ),
                    ),
                  ),

                  // ── Hero Header ──
                  SliverToBoxAdapter(
                    child: _buildHeroHeader(
                      accentGold,
                      primaryTextColor,
                      secondaryTextColor,
                      hijri,
                    ),
                  ),

                  // ── Month Navigation + Calendar ──
                  SliverToBoxAdapter(
                    child: _buildCalendarCard(
                      accentGold,
                      primaryTextColor,
                      secondaryTextColor,
                      hijri,
                      maxDays,
                    ),
                  ),

                  // ── Selected Day Panel ──
                  SliverToBoxAdapter(
                    child: _buildSelectedDayPanel(
                      accentGold,
                      primaryTextColor,
                      secondaryTextColor,
                      hijri,
                      isSelectedToday,
                    ),
                  ),

                  // ── Date Converter ──
                  SliverToBoxAdapter(
                    child: _buildConverterSection(
                      accentGold,
                      primaryTextColor,
                      secondaryTextColor,
                      isDark,
                    ),
                  ),

                  const SliverToBoxAdapter(
                    child: SizedBox(height: 40),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═════════════════════════════════════════════════════════════════════════════
  // HERO HEADER
  // ═════════════════════════════════════════════════════════════════════════════

  Widget _buildHeroHeader(
    Color accentGold,
    Color primaryTextColor,
    Color secondaryTextColor,
    HijriDate hijri,
  ) {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 8, 24, 20),
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Ghost decoration: crescent + mosque silhouette
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _HeroGhostPainter(),
              ),
            ),
          ),
          Column(
            children: [
              // Moon phase icon
              Text(
                _moonPhaseEmoji(hijri.day),
                style: const TextStyle(fontSize: 40),
              ),
              const SizedBox(height: 12),
              // Large month name
              Text(
                hijri.monthName,
                style: GoogleFonts.notoKufiArabic(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: primaryTextColor,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              // Hijri year
              Text(
                '${hijri.year} هـ',
                style: GoogleFonts.notoKufiArabic(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: accentGold,
                ),
              ),
              const SizedBox(height: 4),
              // Gregorian equivalent
              Text(
                '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year} م',
                style: GoogleFonts.notoKufiArabic(
                  fontSize: 13,
                  color: secondaryTextColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ═════════════════════════════════════════════════════════════════════════════
  // CALENDAR CARD
  // ═════════════════════════════════════════════════════════════════════════════

  Widget _buildCalendarCard(
    Color accentGold,
    Color primaryTextColor,
    Color secondaryTextColor,
    HijriDate hijri,
    int maxDays,
  ) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: GlassCard(
        radius: 28,
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
        child: Column(
          children: [
            // ── Navigation Row ──
            _buildNavigationRow(accentGold, primaryTextColor, hijri),
            const SizedBox(height: 16),
            // ── Weekday Pills ──
            _buildWeekdayPills(accentGold),
            const SizedBox(height: 12),
            // ── Day Grid ──
            AnimatedBuilder(
              animation: _monthCtrl,
              builder: (context, child) {
                return Opacity(
                  opacity: _monthCtrl.value,
                  child: Transform.translate(
                    offset: Offset(0, 8 * (1 - _monthCtrl.value)),
                    child: child,
                  ),
                );
              },
              child: _buildDayGrid(
                accentGold,
                primaryTextColor,
                hijri,
                maxDays,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationRow(
    Color accentGold,
    Color primaryTextColor,
    HijriDate hijri,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _GlassCircleButton(
          icon: Icons.chevron_right_rounded,
          onTap: () => _goMonth(-1),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, anim) => FadeTransition(
            opacity: anim,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.15, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: anim,
                curve: Curves.easeOutCubic,
              )),
              child: child,
            ),
          ),
          child: Text(
            '${hijri.monthName} ${hijri.year} هـ',
            key: ValueKey('${hijri.month}-${hijri.year}'),
            style: GoogleFonts.notoKufiArabic(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: primaryTextColor,
            ),
          ),
        ),
        _GlassCircleButton(
          icon: Icons.chevron_left_rounded,
          onTap: () => _goMonth(1),
        ),
      ],
    );
  }

  Widget _buildWeekdayPills(Color accentGold) {
    return Row(
      children: List.generate(7, (i) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: accentGold.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(
              _weekdayLabels[i],
              style: GoogleFonts.notoKufiArabic(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: accentGold,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildDayGrid(
    Color accentGold,
    Color primaryTextColor,
    HijriDate hijri,
    int maxDays,
  ) {
    // Determine which weekday the 1st falls on (0=Saturday in our layout)
    final firstDate = _hijriToGregorian(hijri.year, hijri.month, 1);
    final firstWeekday = (firstDate.weekday + 1) % 7; // Convert to Sat=0

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
      ),
      itemCount: maxDays + firstWeekday,
      itemBuilder: (context, index) {
        if (index < firstWeekday) return const SizedBox.shrink();
        final dayNum = index - firstWeekday + 1;
        final isToday = dayNum == hijri.day;
        final isSelected = dayNum ==
            HijriDate.fromDate(_selectedDate).day &&
            hijri.month == HijriDate.fromDate(_selectedDate).month;

        return GestureDetector(
          onTap: () => _selectDay(dayNum),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
              gradient: isSelected
                  ? AppTheme.goldGradient
                  : isToday
                      ? LinearGradient(
                          colors: [
                            accentGold.withValues(alpha: 0.15),
                            accentGold.withValues(alpha: 0.08),
                          ],
                        )
                      : null,
              color: (!isSelected && !isToday)
                  ? accentGold.withValues(alpha: 0.04)
                  : null,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? accentGold
                    : isToday
                        ? accentGold.withValues(alpha: 0.35)
                        : accentGold.withValues(alpha: 0.1),
                width: isSelected ? 1.2 : 0.5,
              ),
              boxShadow: isToday
                  ? [
                      BoxShadow(
                        color: accentGold.withValues(alpha: 0.12),
                        blurRadius: 8,
                        spreadRadius: 0,
                      ),
                    ]
                  : null,
            ),
            alignment: Alignment.center,
            child: Text(
              '$dayNum',
              style: GoogleFonts.notoKufiArabic(
                fontSize: 14,
                fontWeight: isSelected || isToday
                    ? FontWeight.w800
                    : FontWeight.w600,
                color: isSelected
                    ? const Color(0xFF0B1324)
                    : isToday
                        ? accentGold
                        : primaryTextColor,
              ),
            ),
          ),
        );
      },
    );
  }

  // ═════════════════════════════════════════════════════════════════════════════
  // SELECTED DAY PANEL
  // ═════════════════════════════════════════════════════════════════════════════

  Widget _buildSelectedDayPanel(
    Color accentGold,
    Color primaryTextColor,
    Color secondaryTextColor,
    HijriDate hijri,
    bool isSelectedToday,
  ) {
    final weekdayName = _getWeekdayName(_selectedDate.weekday);

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: GlassCard(
        radius: 24,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: accentGold.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.calendar_today_rounded,
                    color: accentGold,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${hijri.day} ${hijri.monthName} ${hijri.year} هـ',
                        style: GoogleFonts.notoKufiArabic(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: primaryTextColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year} م — $weekdayName',
                        style: GoogleFonts.notoKufiArabic(
                          fontSize: 12,
                          color: secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Info chips row
            Row(
              children: [
                _InfoChip(
                  icon: Icons.nightlight_round,
                  label: _moonPhaseName(hijri.day),
                  accentGold: accentGold,
                ),
                const SizedBox(width: 8),
                if (isSelectedToday)
                  _InfoChip(
                    icon: Icons.star_rounded,
                    label: 'اليوم',
                    accentGold: accentGold,
                    highlighted: true,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getWeekdayName(int weekday) {
    const names = [
      'الإثنين',
      'الثلاثاء',
      'الأربعاء',
      'الخميس',
      'الجمعة',
      'السبت',
      'الأحد',
    ];
    return names[weekday - 1];
  }

  // ═════════════════════════════════════════════════════════════════════════════
  // DATE CONVERTER
  // ═════════════════════════════════════════════════════════════════════════════

  Widget _buildConverterSection(
    Color accentGold,
    Color primaryTextColor,
    Color secondaryTextColor,
    bool isDark,
  ) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: GlassCard(
        radius: 28,
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        accentGold.withValues(alpha: 0.12),
                        accentGold.withValues(alpha: 0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.swap_horiz_rounded,
                    color: accentGold,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'محول التاريخ',
                        style: GoogleFonts.notoKufiArabic(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: primaryTextColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'تحويل أي تاريخ ميلادي إلى هجري',
                        style: GoogleFonts.notoKufiArabic(
                          fontSize: 11,
                          color: secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            GoldButton(
              label: 'اختر تاريخاً ميلادياً',
              icon: Icons.date_range_rounded,
              outlined: true,
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() {
                    _selectedDate = picked;
                  });
                  HapticFeedback.selectionClick();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// PRIVATE WIDGETS
// ═══════════════════════════════════════════════════════════════════════════════

class _GlassCircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _GlassCircleButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: AppTheme.bgCard.withValues(alpha: 0.5),
          shape: BoxShape.circle,
          border: Border.all(
            color: AppTheme.borderGold,
            width: 0.8,
          ),
        ),
        child: Icon(
          icon,
          color: AppTheme.goldPrimary,
          size: 20,
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color accentGold;
  final bool highlighted;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.accentGold,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: highlighted
            ? accentGold.withValues(alpha: 0.15)
            : accentGold.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: highlighted
              ? accentGold.withValues(alpha: 0.4)
              : accentGold.withValues(alpha: 0.12),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: accentGold),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.notoKufiArabic(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: highlighted ? accentGold : AppTheme.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// HERO GHOST PAINTER — crescent + mosque silhouette
// ═══════════════════════════════════════════════════════════════════════════════

class _HeroGhostPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Crescent moon — top right area
    final moonPaint = Paint()
      ..color = const Color(0xFFD4AF37).withValues(alpha: 0.05)
      ..style = PaintingStyle.fill;

    final moonCenter = Offset(cx + size.width * 0.28, cy - size.height * 0.25);
    canvas.drawCircle(moonCenter, 36, moonPaint);
    // Cut-out for crescent
    canvas.drawCircle(
      moonCenter + const Offset(10, -6),
      30,
      Paint()
        ..color = const Color(0xFF0B1730).withValues(alpha: 0.8)
        ..style = PaintingStyle.fill,
    );

    // Star near crescent
    final starPaint = Paint()
      ..color = const Color(0xFFD4AF37).withValues(alpha: 0.04)
      ..style = PaintingStyle.fill;
    _drawStar5(canvas, moonCenter + const Offset(30, -18), 6, starPaint);

    // Mosque dome silhouette — bottom center
    final mosquePaint = Paint()
      ..color = const Color(0xFFD4AF37).withValues(alpha: 0.04)
      ..style = PaintingStyle.fill;

    final base = cy + size.height * 0.32;
    final dome = Path()
      ..moveTo(cx - 80, base)
      ..quadraticBezierTo(cx - 40, base - 50, cx, base - 60)
      ..quadraticBezierTo(cx + 40, base - 50, cx + 80, base)
      ..close();
    canvas.drawPath(dome, mosquePaint);

    // Minaret left
    canvas.drawRect(
      Rect.fromLTWH(cx - 90, base - 80, 6, 80),
      mosquePaint,
    );
    // Minaret right
    canvas.drawRect(
      Rect.fromLTWH(cx + 84, base - 80, 6, 80),
      mosquePaint,
    );

    // Geometric ornament — subtle octagon pattern
    final ornPaint = Paint()
      ..color = const Color(0xFFD4AF37).withValues(alpha: 0.03)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.6;

    final ornCenter = Offset(cx - size.width * 0.22, cy + size.height * 0.18);
    _drawOctagon(canvas, ornCenter, 28, ornPaint);
    _drawOctagon(canvas, ornCenter, 20, ornPaint);
  }

  void _drawStar5(Canvas canvas, Offset c, double r, Paint paint) {
    final path = Path();
    for (int i = 0; i < 5; i++) {
      final outerAngle = (pi * 2 / 5) * i - pi / 2;
      final innerAngle = outerAngle + pi / 5;
      final outerP = Offset(c.dx + r * cos(outerAngle), c.dy + r * sin(outerAngle));
      final innerP = Offset(c.dx + r * 0.4 * cos(innerAngle), c.dy + r * 0.4 * sin(innerAngle));
      if (i == 0) {
        path.moveTo(outerP.dx, outerP.dy);
      } else {
        path.lineTo(outerP.dx, outerP.dy);
      }
      path.lineTo(innerP.dx, innerP.dy);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawOctagon(Canvas canvas, Offset c, double r, Paint paint) {
    final path = Path();
    for (int i = 0; i < 8; i++) {
      final angle = (pi / 4) * i - pi / 8;
      final p = Offset(c.dx + r * cos(angle), c.dy + r * sin(angle));
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class NearbyMosqueScreen extends StatelessWidget {
  const NearbyMosqueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final accentGold = AppTheme.goldPrimary;
    final primaryTextColor = AppTheme.textPrimary;
    final secondaryTextColor = AppTheme.textMuted;

    final mosques = [
      ('مسجد الروضة المباركة', 'حي الروضة، الشارع الرئيسي', '٢٥٠ متر', true),
      (
        'جامع الإمام علي بن أبي طالب',
        'شارع الرسالة، بالقرب من المكتبة',
        '٦٢٠ متر',
        true,
      ),
      ('مسجد السكينة والتقوى', 'حي السلام، الزاوية الجنوبية', '١.١ كم', false),
      ('جامع النور الكبير', 'وسط المدينة، طريق المعراج', '١.٨ كم', true),
    ];

    return Scaffold(
      body: Stack(
        children: [
          const StarBackground(),
          SafeArea(
            child: CustomScrollView(
              slivers: [
                // AppBar
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => context.pop(),
                          icon: Icon(
                            Icons.arrow_back_rounded,
                            color: accentGold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'المساجد القريبة',
                          style: GoogleFonts.notoKufiArabic(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: primaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Description Card
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                    child: GlassCard(
                      radius: 30,
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Icon(
                            Icons.near_me_rounded,
                            color: accentGold,
                            size: 24,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'تحديد المواقع المفعلة',
                                  style: GoogleFonts.notoKufiArabic(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: primaryTextColor,
                                  ),
                                ),
                                Text(
                                  'يتم تحديد المسافة والاتجاه التقريبي بناءً على إحداثيات موقعك الحالي',
                                  style: GoogleFonts.notoKufiArabic(
                                    fontSize: 11,
                                    color: secondaryTextColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Mosques List
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 80),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final mosque = mosques[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: GlassCard(
                          radius: 24,
                          padding: const EdgeInsets.all(18),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: accentGold.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(
                                  Icons.mosque_rounded,
                                  color: accentGold,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      mosque.$1,
                                      style: GoogleFonts.notoKufiArabic(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: primaryTextColor,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      mosque.$2,
                                      style: GoogleFonts.notoKufiArabic(
                                        fontSize: 10,
                                        color: secondaryTextColor,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.directions_walk_rounded,
                                          color: accentGold,
                                          size: 12,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'يبعد: ${mosque.$3}',
                                          style: GoogleFonts.notoKufiArabic(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: accentGold,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: mosque.$4
                                                ? const Color(
                                                    0xFF0F8B6D,
                                                  ).withValues(alpha: 0.12)
                                                : Colors.red.withValues(
                                                    alpha: 0.1,
                                                  ),
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                          child: Text(
                                            mosque.$4
                                                ? 'تقام الصلاة الآن'
                                                : 'مفتوح للزيارة',
                                            style: GoogleFonts.notoKufiArabic(
                                              fontSize: 8,
                                              fontWeight: FontWeight.bold,
                                              color: mosque.$4
                                                  ? const Color(0xFF0F8B6D)
                                                  : Colors.red,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.map_rounded,
                                  color: accentGold,
                                ),
                                onPressed: () {
                                  HapticFeedback.lightImpact();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'جاري الانتقال إلى خرائط جوجل لتحديد المسار...',
                                        style: GoogleFonts.notoKufiArabic(
                                          fontSize: 12,
                                        ),
                                      ),
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    }, childCount: mosques.length),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

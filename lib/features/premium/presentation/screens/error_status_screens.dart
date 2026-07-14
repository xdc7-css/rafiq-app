import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../theme/app_theme.dart';
import '../../../../widgets/star_background.dart';

// ─────────────────────────────────────────────────
// 404 Not Found Screen
// ─────────────────────────────────────────────────

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _StatusScreen(
      icon: Icons.search_off_rounded,
      title: 'الصفحة غير موجودة',
      subtitle: 'يبدو أن الصفحة التي تبحث عنها قد انتقلت أو غير موجودة',
      arabicCode: '٤٠٤',
      actionLabel: 'العودة للرئيسية',
      onAction: () => Navigator.of(context).pushNamedAndRemoveUntil('/home', (r) => false),
      secondaryActionLabel: 'الصفحة السابقة',
      onSecondaryAction: () => Navigator.maybePop(context),
      glowColor: const Color(0xFFD4AF37),
    );
  }
}

// ─────────────────────────────────────────────────
// Offline / No Connection Screen
// ─────────────────────────────────────────────────

class OfflineScreen extends StatefulWidget {
  final VoidCallback? onRetry;

  const OfflineScreen({super.key, this.onRetry});

  @override
  State<OfflineScreen> createState() => _OfflineScreenState();
}

class _OfflineScreenState extends State<OfflineScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gold = AppTheme.goldPrimary;
    final primaryText = AppTheme.textPrimary;
    final secondaryText = AppTheme.textMuted;

    return Scaffold(
      backgroundColor: AppTheme.bgPrimary,
      body: Stack(
        children: [
          const StarBackground(),
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated pulse rings
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (_, __) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            // Outer ring
                            Container(
                              width: 130 + 20 * _pulseController.value,
                              height: 130 + 20 * _pulseController.value,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF64748B).withValues( alpha: 0.15 * (1 - _pulseController.value)),
                                  width: 1,
                                ),
                              ),
                            ),
                            // Middle ring
                            Container(
                              width: 110,
                              height: 110,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF64748B).withValues( alpha: 0.08),
                              ),
                            ),
                            // Icon container
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isDark ? AppTheme.bgCard : const Color(0xFFF0ECE5),
                                border: Border.all(color: const Color(0xFF64748B).withValues( alpha: 0.2)),
                              ),
                              child: const Icon(
                                Icons.wifi_off_rounded,
                                color: Color(0xFF64748B),
                                size: 36,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 36),
                    Text(
                      'لا يوجد اتصال بالإنترنت',
                      style: GoogleFonts.notoKufiArabic(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: primaryText,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'تحقق من اتصالك بالإنترنت وحاول مرة أخرى.\nيمكنك الاستمرار في استخدام القرآن والأذكار بدون إنترنت.',
                      style: GoogleFonts.notoKufiArabic(
                        fontSize: 13,
                        color: secondaryText,
                        height: 1.8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),

                    // Offline features chips
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: [
                        _AvailableChip(label: '📖 القرآن الكريم', gold: gold, isDark: isDark),
                        _AvailableChip(label: '🤲 الأذكار', gold: gold, isDark: isDark),
                        _AvailableChip(label: '🕌 مواقيت الصلاة', gold: gold, isDark: isDark),
                        _AvailableChip(label: '🧭 القبلة', gold: gold, isDark: isDark),
                      ],
                    ),
                    const SizedBox(height: 36),
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        widget.onRetry?.call();
                      },
                      child: Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: AppTheme.goldGradient,
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(color: gold.withValues( alpha: 0.35), blurRadius: 16),
                          ],
                        ),
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.refresh_rounded, color: Colors.white, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'إعادة المحاولة',
                                style: GoogleFonts.notoKufiArabic(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? AppTheme.bgPrimary : Colors.white,
                                ),
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
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// Generic Error Screen
// ─────────────────────────────────────────────────

class ErrorScreen extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry;

  const ErrorScreen({super.key, this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return _StatusScreen(
      icon: Icons.error_outline_rounded,
      title: 'حدث خطأ غير متوقع',
      subtitle: message ?? 'نعتذر عن هذا الخطأ. حاول مرة أخرى أو تواصل مع الدعم الفني.',
      arabicCode: null,
      actionLabel: 'إعادة المحاولة',
      onAction: onRetry ?? () => Navigator.maybePop(context),
      secondaryActionLabel: 'تواصل مع الدعم',
      onSecondaryAction: () {},
      glowColor: const Color(0xFFEF4444),
    );
  }
}

// ─────────────────────────────────────────────────
// Empty State Screen
// ─────────────────────────────────────────────────

class EmptyStateScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyStateScreen({
    super.key,
    this.title = 'لا يوجد محتوى بعد',
    this.subtitle = 'ابدأ باستكشاف التطبيق وإضافة محتوى مفضل لديك',
    this.icon = Icons.inbox_rounded,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return _StatusScreen(
      icon: icon,
      title: title,
      subtitle: subtitle,
      arabicCode: null,
      actionLabel: actionLabel ?? 'استكشف الآن',
      onAction: onAction ?? () => Navigator.maybePop(context),
      secondaryActionLabel: null,
      onSecondaryAction: null,
      glowColor: AppTheme.goldPrimary,
    );
  }
}

// ─────────────────────────────────────────────────
// Loading Screen
// ─────────────────────────────────────────────────

class LoadingScreen extends StatefulWidget {
  final String? message;

  const LoadingScreen({super.key, this.message});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with TickerProviderStateMixin {
  late AnimationController _rotateController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;
  int _dotCount = 0;

  @override
  void initState() {
    super.initState();
    _rotateController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..repeat(reverse: true);

    _fadeAnim = Tween(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return false;
      setState(() => _dotCount = (_dotCount + 1) % 4);
      return true;
    });
  }

  @override
  void dispose() {
    _rotateController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gold = AppTheme.goldPrimary;
    final primaryText = AppTheme.textPrimary;

    return Scaffold(
      backgroundColor: AppTheme.bgPrimary,
      body: Stack(
        children: [
          const StarBackground(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _rotateController,
                  builder: (_, __) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        // Outer arc
                        Transform.rotate(
                          angle: _rotateController.value * 2 * math.pi,
                          child: CustomPaint(
                            size: const Size(90, 90),
                            painter: _ArcPainter(color: gold, strokeWidth: 3),
                          ),
                        ),
                        // Inner arc (counter-rotate)
                        Transform.rotate(
                          angle: -_rotateController.value * 2 * math.pi * 1.5,
                          child: CustomPaint(
                            size: const Size(68, 68),
                            painter: _ArcPainter(color: gold.withValues( alpha: 0.4), strokeWidth: 2),
                          ),
                        ),
                        // Center mosque icon
                        AnimatedBuilder(
                          animation: _fadeAnim,
                          builder: (_, child) => Opacity(opacity: _fadeAnim.value, child: child),
                          child: Icon(Icons.mosque_rounded, color: gold, size: 28),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 32),
                AnimatedBuilder(
                  animation: _fadeAnim,
                  builder: (_, __) {
                    return Opacity(
                      opacity: _fadeAnim.value,
                      child: Text(
                        (widget.message ?? 'جارٍ التحميل') + '.' * _dotCount,
                        style: GoogleFonts.notoKufiArabic(
                          fontSize: 16,
                          color: primaryText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ',
                  style: GoogleFonts.notoKufiArabic(
                    fontSize: 13,
                    color: gold.withValues( alpha: 0.7),
                    fontStyle: FontStyle.italic,
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

// ─────────────────────────────────────────────────
// Shared _StatusScreen Template
// ─────────────────────────────────────────────────

class _StatusScreen extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? arabicCode;
  final String actionLabel;
  final VoidCallback onAction;
  final String? secondaryActionLabel;
  final VoidCallback? onSecondaryAction;
  final Color glowColor;

  const _StatusScreen({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.arabicCode,
    required this.actionLabel,
    required this.onAction,
    this.secondaryActionLabel,
    this.onSecondaryAction,
    required this.glowColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gold = AppTheme.goldPrimary;
    final primaryText = AppTheme.textPrimary;
    final secondaryText = AppTheme.textMuted;

    return Scaffold(
      backgroundColor: AppTheme.bgPrimary,
      body: Stack(
        children: [
          const StarBackground(),
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon with glow
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: glowColor.withValues( alpha: 0.08),
                        border: Border.all(color: glowColor.withValues( alpha: 0.2)),
                        boxShadow: [
                          BoxShadow(
                            color: glowColor.withValues( alpha: 0.2),
                            blurRadius: 40,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: Icon(icon, color: glowColor, size: 48),
                    ),

                    if (arabicCode != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        arabicCode!,
                        style: GoogleFonts.notoKufiArabic(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: glowColor.withValues( alpha: 0.3),
                        ),
                      ),
                    ] else
                      const SizedBox(height: 24),

                    Text(
                      title,
                      style: GoogleFonts.notoKufiArabic(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: primaryText,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      subtitle,
                      style: GoogleFonts.notoKufiArabic(
                        fontSize: 13,
                        color: secondaryText,
                        height: 1.8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),

                    // Primary Action
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        onAction();
                      },
                      child: Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: AppTheme.goldGradient,
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(color: gold.withValues( alpha: 0.35), blurRadius: 16),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            actionLabel,
                            style: GoogleFonts.notoKufiArabic(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppTheme.bgPrimary : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),

                    if (secondaryActionLabel != null && onSecondaryAction != null) ...[
                      const SizedBox(height: 14),
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          onSecondaryAction!();
                        },
                        child: Text(
                          secondaryActionLabel!,
                          style: GoogleFonts.notoKufiArabic(
                            fontSize: 14,
                            color: gold,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// Helper Widgets
// ─────────────────────────────────────────────────

class _AvailableChip extends StatelessWidget {
  final String label;
  final Color gold;
  final bool isDark;

  const _AvailableChip({required this.label, required this.gold, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: gold.withValues( alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: gold.withValues( alpha: 0.2)),
      ),
      child: Text(
        label,
        style: GoogleFonts.notoKufiArabic(fontSize: 12, color: gold),
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// Arc Painter for Loading
// ─────────────────────────────────────────────────

class _ArcPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  const _ArcPainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    const startAngle = -math.pi / 2;
    const sweepAngle = math.pi * 1.5; // 270 degrees arc

    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _ArcPainter old) => old.color != color;
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../theme/app_theme.dart';
import '../../../../theme/ds_components.dart';
import '../../../../widgets/star_background.dart';

// ─────────────────────────────────────────────────
// Subscription Screen
// ─────────────────────────────────────────────────

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen>
    with SingleTickerProviderStateMixin {
  int _selectedPlan = 1; // 0=monthly, 1=yearly, 2=lifetime
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnim;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    _shimmerAnim = Tween<double>(begin: -1.5, end: 1.5).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _shimmerController.dispose();
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
            child: Column(
              children: [
                // Close Button
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.maybePop(context),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppTheme.bgCard.withValues(alpha: 0.4)
                                : Colors.white.withValues(alpha: 0.7),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: gold.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Icon(
                            Icons.close_rounded,
                            color: secondaryText,
                            size: 18,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'النسخة المميزة',
                        style: GoogleFonts.notoKufiArabic(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: gold,
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(width: 36),
                    ],
                  ),
                ),

                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 24),

                        // Crown Icon with glow
                        AnimatedBuilder(
                          animation: _shimmerAnim,
                          builder: (_, __) {
                            return Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    gold.withValues(alpha: 0.2),
                                    gold.withValues(alpha: 0.05),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: gold.withValues(alpha: 0.3),
                                    blurRadius: 30,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.workspace_premium_rounded,
                                color: gold,
                                size: 44,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),

                        Text(
                          'ارتقِ بتجربتك الروحانية',
                          style: GoogleFonts.notoKufiArabic(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: primaryText,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'استمتع بتجربة إسلامية لا مثيل لها مع كل المميزات الحصرية',
                          style: GoogleFonts.notoKufiArabic(
                            fontSize: 13,
                            color: secondaryText,
                            height: 1.6,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 28),

                        // Features List
                        _FeaturesCard(
                          isDark: isDark,
                          gold: gold,
                          primaryText: primaryText,
                          secondaryText: secondaryText,
                        ),

                        const SizedBox(height: 24),

                        // Plan Selector
                        Text(
                          'اختر خطتك',
                          style: GoogleFonts.notoKufiArabic(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: primaryText,
                          ),
                        ),
                        const SizedBox(height: 16),

                        _PlanCard(
                          index: 0,
                          selected: _selectedPlan == 0,
                          title: 'شهري',
                          price: '9.99',
                          period: 'شهر',
                          badge: null,
                          note: 'يُجدَّد تلقائياً كل شهر',
                          isDark: isDark,
                          gold: gold,
                          primaryText: primaryText,
                          secondaryText: secondaryText,
                          onTap: () => setState(() => _selectedPlan = 0),
                        ),
                        const SizedBox(height: 12),
                        _PlanCard(
                          index: 1,
                          selected: _selectedPlan == 1,
                          title: 'سنوي',
                          price: '59.99',
                          period: 'سنة',
                          badge: 'وفّر 50%',
                          note: 'أي 5.0 دولار/شهر',
                          isDark: isDark,
                          gold: gold,
                          primaryText: primaryText,
                          secondaryText: secondaryText,
                          onTap: () => setState(() => _selectedPlan = 1),
                        ),
                        const SizedBox(height: 12),
                        _PlanCard(
                          index: 2,
                          selected: _selectedPlan == 2,
                          title: 'مدى الحياة',
                          price: '119.99',
                          period: 'مرة واحدة',
                          badge: 'الأفضل قيمة',
                          note: 'دفعة واحدة للأبد',
                          isDark: isDark,
                          gold: gold,
                          primaryText: primaryText,
                          secondaryText: secondaryText,
                          onTap: () => setState(() => _selectedPlan = 2),
                        ),

                        const SizedBox(height: 28),

                        // Subscribe Button
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            _showSuccessSheet(context, isDark, gold);
                          },
                          child: AnimatedBuilder(
                            animation: _shimmerAnim,
                            builder: (_, child) {
                              return Container(
                                height: 58,
                                decoration: BoxDecoration(
                                  gradient: AppTheme.goldGradient,
                                  borderRadius: BorderRadius.circular(22),
                                  boxShadow: [
                                    BoxShadow(
                                      color: gold.withValues(alpha: 0.4),
                                      blurRadius: 20,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(22),
                                  child: Stack(
                                    children: [
                                      child!,
                                      // Shimmer
                                      Positioned.fill(
                                        child: FractionallySizedBox(
                                          widthFactor: 0.3,
                                          alignment: Alignment(
                                            _shimmerAnim.value,
                                            0,
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.white.withValues(
                                                    alpha: 0.0,
                                                  ),
                                                  Colors.white.withValues(
                                                    alpha: 0.25,
                                                  ),
                                                  Colors.white.withValues(
                                                    alpha: 0.0,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            child: Center(
                              child: Text(
                                _selectedPlan == 0
                                    ? 'ابدأ الاشتراك الشهري'
                                    : _selectedPlan == 1
                                    ? 'ابدأ الاشتراك السنوي'
                                    : 'احصل على النسخة الدائمة',
                                style: GoogleFonts.notoKufiArabic(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? AppTheme.bgPrimary
                                      : Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Terms
                        Text(
                          'بالاشتراك توافق على شروط الخدمة وسياسة الخصوصية.\nيُلغى الاشتراك في أي وقت من الإعدادات.',
                          style: GoogleFonts.notoKufiArabic(
                            fontSize: 11,
                            color: secondaryText.withValues(alpha: 0.7),
                            height: 1.7,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessSheet(BuildContext context, bool isDark, Color gold) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.bgSecondary : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          border: Border.all(color: gold.withValues(alpha: 0.2)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: AppTheme.goldGradient,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_rounded,
                color: isDark ? AppTheme.bgPrimary : Colors.white,
                size: 40,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'مبارك! تم الاشتراك بنجاح',
              style: GoogleFonts.notoKufiArabic(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: gold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'أنت الآن عضو مميز في مجتمعنا الروحاني',
              style: GoogleFonts.notoKufiArabic(
                fontSize: 13,
                color: AppTheme.textMuted,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: gold,
                  foregroundColor: isDark ? AppTheme.bgPrimary : Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'ابدأ الاستكشاف',
                  style: GoogleFonts.notoKufiArabic(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// Features Card
// ─────────────────────────────────────────────────

class _FeaturesCard extends StatelessWidget {
  final bool isDark;
  final Color gold;
  final Color primaryText;
  final Color secondaryText;

  const _FeaturesCard({
    required this.isDark,
    required this.gold,
    required this.primaryText,
    required this.secondaryText,
  });

  @override
  Widget build(BuildContext context) {
    final features = [
      ('تلاوات صوتية بجودة عالية', Icons.graphic_eq_rounded),
      ('القرآن الكريم كاملاً بدون إنترنت', Icons.wifi_off_rounded),
      ('أكثر من ٥٠٠٠ حديث نبوي شريف', Icons.auto_stories_rounded),
      ('إحصائيات وتتبع التقدم الروحاني', Icons.insights_rounded),
      ('قبلة دقيقة بالـ GPS + خرائط المساجد', Icons.mosque_rounded),
      ('خلفيات وقوالب مخصصة للويدجت', Icons.widgets_rounded),
      ('بدون إعلانات تماماً', Icons.block_rounded),
      ('دعم فني على مدار الساعة', Icons.support_agent_rounded),
    ];

    return GlassCard(
      radius: 24,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: List.generate(features.length, (i) {
          return Padding(
            padding: EdgeInsets.only(bottom: i < features.length - 1 ? 14 : 0),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: gold.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(features[i].$2, color: gold, size: 16),
                ),
                const SizedBox(width: 14),
                Text(
                  features[i].$1,
                  style: GoogleFonts.notoKufiArabic(
                    fontSize: 13,
                    color: primaryText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Icon(Icons.check_circle_rounded, color: gold, size: 18),
              ],
            ),
          );
        }),
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// Plan Card
// ─────────────────────────────────────────────────

class _PlanCard extends StatelessWidget {
  final int index;
  final bool selected;
  final String title;
  final String price;
  final String period;
  final String? badge;
  final String note;
  final bool isDark;
  final Color gold;
  final Color primaryText;
  final Color secondaryText;
  final VoidCallback onTap;

  const _PlanCard({
    required this.index,
    required this.selected,
    required this.title,
    required this.price,
    required this.period,
    this.badge,
    required this.note,
    required this.isDark,
    required this.gold,
    required this.primaryText,
    required this.secondaryText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: selected
              ? gold.withValues(alpha: 0.12)
              : (isDark
                    ? AppTheme.bgCard.withValues(alpha: 0.4)
                    : Colors.white.withValues(alpha: 0.6)),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: selected ? gold : gold.withValues(alpha: 0.15),
            width: selected ? 1.5 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: gold.withValues(alpha: 0.15),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? gold : secondaryText.withValues(alpha: 0.4),
                  width: selected ? 0 : 1.5,
                ),
                gradient: selected ? AppTheme.goldGradient : null,
              ),
              child: selected
                  ? Icon(
                      Icons.check_rounded,
                      color: isDark ? AppTheme.bgPrimary : Colors.white,
                      size: 14,
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.notoKufiArabic(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: selected ? gold : primaryText,
                        ),
                      ),
                      if (badge != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            gradient: AppTheme.goldGradient,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            badge!,
                            style: GoogleFonts.notoKufiArabic(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppTheme.bgPrimary : Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    note,
                    style: GoogleFonts.notoKufiArabic(
                      fontSize: 11,
                      color: secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$$price',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: selected ? gold : primaryText,
                  ),
                ),
                Text(
                  period,
                  style: GoogleFonts.notoKufiArabic(
                    fontSize: 11,
                    color: secondaryText,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../theme/ds_components.dart';
import '../../core/navigation_guard.dart';
import '../../widgets/star_background.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return IslamicBackground(
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader(w)),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildCard(context, _items[index], w),
                  childCount: _items.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(double w) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4, height: 36,
                decoration: BoxDecoration(
                  gradient: AppTheme.goldGradient,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Gap(14),
              Text('المزيد', style: GoogleFonts.notoKufiArabic(
                fontSize: 28, fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
              )),
              const Gap(10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  gradient: AppTheme.goldGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('أدوات إيمانية', style: GoogleFonts.notoKufiArabic(
                  fontSize: 10, fontWeight: FontWeight.w700,
                  color: AppTheme.bgPrimary,
                )),
              ),
            ],
          ),
          const Gap(14),
          Container(
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.goldPrimary.withValues(alpha: 0.5),
                  AppTheme.goldPrimary.withValues(alpha: 0.05),
                ],
                stops: const [0, 0.6],
              ),
            ),
          ),
          const Gap(8),
          Row(
            children: [
              Icon(Icons.auto_awesome_rounded, size: 14, color: AppTheme.goldPrimary.withValues(alpha: 0.5)),
              const Gap(6),
              Text('كل ما تحتاجه لرحلة إيمانية متكاملة', style: GoogleFonts.notoKufiArabic(
                fontSize: 12, color: AppTheme.textMuted,
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, _MoreItem item, double w) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: GlassCard(
        radius: 20,
        padding: const EdgeInsets.fromLTRB(16, 14, 20, 14),
        onTap: () {
          if (item.route == '/ziyarat') {
            context.go('/ziyarat');
          } else if (!context.isCurrentRoute(item.route)) {
            context.push(item.route);
          }
        },
        child: Row(
          children: [
            Container(
              width: w < 360 ? 44 : 52, height: w < 360 ? 44 : 52,
              decoration: BoxDecoration(
                gradient: item.gradient,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: item.gradient.colors.first.withValues(alpha: 0.3),
                    blurRadius: 10, spreadRadius: 1,
                  ),
                ],
              ),
              child: Icon(item.icon, color: AppTheme.bgPrimary, size: 24),
            ),
            const Gap(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.label, style: GoogleFonts.notoKufiArabic(
                    fontSize: 16, fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  )),
                  const Gap(3),
                  Text(item.subtitle, style: GoogleFonts.notoKufiArabic(
                    fontSize: 11, color: AppTheme.textMuted,
                  )),
                ],
              ),
            ),
            Icon(Icons.chevron_left_rounded, color: AppTheme.textMuted.withValues(alpha: 0.3), size: 22),
          ],
        ),
      ),
    );
  }
}

class _MoreItem {
  final IconData icon;
  final String label;
  final String subtitle;
  final String route;
  final LinearGradient gradient;

  const _MoreItem({
    required this.icon, required this.label,
    required this.subtitle, required this.route,
    required this.gradient,
  });
}

final List<_MoreItem> _items = [
  _MoreItem(
    icon: Icons.mosque_rounded, label: 'الزيارات والأدعية',
    subtitle: 'زيارة المعصومين، الأدعية المأثورة، الصحيفة السجادية',
    route: '/ziyarat',
    gradient: const LinearGradient(colors: [Color(0xFFD4AF37), Color(0xFFB8962E)]),
  ),
  _MoreItem(
    icon: Icons.gavel_rounded, label: 'الاستفتاءات',
    subtitle: 'أحكام شرعية وفتاوى دينية',
    route: '/fatwa',
    gradient: const LinearGradient(colors: [Color(0xFFD4AF37), Color(0xFFF2C94C)]),
  ),
  _MoreItem(
    icon: Icons.timer_rounded, label: 'التسبيح',
    subtitle: 'تسبيح إلكتروني مع عداد',
    route: '/tasbeeh',
    gradient: const LinearGradient(colors: [Color(0xFFD4AF37), Color(0xFFB8962E)]),
  ),
  _MoreItem(
    icon: Icons.access_time_rounded, label: 'مواقيت الصلاة',
    subtitle: 'أوقات الصلاة حسب منطقتك',
    route: '/prayer-times',
    gradient: const LinearGradient(colors: [Color(0xFF4A6FA5), Color(0xFF2D4A7A)]),
  ),
  _MoreItem(
    icon: Icons.explore_rounded, label: 'القبلة',
    subtitle: 'بوصلة القبلة من موقعك',
    route: '/qibla',
    gradient: const LinearGradient(colors: [Color(0xFF2ECC71), Color(0xFF1A8C4A)]),
  ),
  _MoreItem(
    icon: Icons.favorite_rounded, label: 'المفضلة',
    subtitle: 'المحفوظات والآيات المختارة',
    route: '/favorites',
    gradient: const LinearGradient(colors: [Color(0xFFE74C3C), Color(0xFFC0392B)]),
  ),
  _MoreItem(
    icon: Icons.book_rounded, label: 'الختمة',
    subtitle: 'تتبع تلاوة القرآن الكريم',
    route: '/khatmah',
    gradient: const LinearGradient(colors: [Color(0xFFD4AF37), Color(0xFF9A7B1C)]),
  ),
  _MoreItem(
    icon: Icons.search_rounded, label: 'البحث',
    subtitle: 'بحث في الآيات والأحاديث والأذكار',
    route: '/search',
    gradient: const LinearGradient(colors: [Color(0xFF8E44AD), Color(0xFF6C3483)]),
  ),
  _MoreItem(
    icon: Icons.widgets_rounded, label: 'الودجت',
    subtitle: 'إعدادات القطعة الإسلامية',
    route: '/widget-settings',
    gradient: const LinearGradient(colors: [Color(0xFF1ABC9C), Color(0xFF16A085)]),
  ),
  _MoreItem(
    icon: Icons.settings_rounded, label: 'الإعدادات',
    subtitle: 'تخصيص التطبيق حسب رغبتك',
    route: '/settings',
    gradient: const LinearGradient(colors: [Color(0xFF7F8C8D), Color(0xFF5D6D7E)]),
  ),
];

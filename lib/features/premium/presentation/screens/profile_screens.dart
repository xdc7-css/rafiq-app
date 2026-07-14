import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../theme/app_theme.dart';
import '../../../../theme/ds_components.dart';
import '../../../../widgets/star_background.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final accentGold = AppTheme.goldPrimary;
    final primaryTextColor = AppTheme.textPrimary;
    final secondaryTextColor = AppTheme.textMuted;

    final achievements = [
      ('الذاكر المثابر', 'إكمال ١٠٠٠ تسبيحة في يوم واحد', Icons.star_rounded),
      (
        'القارئ المتدبر',
        'قراءة جزء كامل من القرآن',
        Icons.auto_stories_rounded,
      ),
      (
        'صاحب الهمة',
        'المحافظة على الصلوات ٧ أيام متتالية',
        Icons.mosque_rounded,
      ),
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
                          'الملف الشخصي',
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

                // User Info Header
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                    child: GlassCard(
                      radius: 30,
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: accentGold.withValues(alpha: 0.15),
                            child: Icon(
                              Icons.person_rounded,
                              color: accentGold,
                              size: 48,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'عبد الرحمن',
                            style: GoogleFonts.notoKufiArabic(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: primaryTextColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'عضو برونزي • تاريخ الانضمام: شوال ١٤٤٧ هـ',
                            style: GoogleFonts.notoKufiArabic(
                              fontSize: 11,
                              color: accentGold,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Streak & Mini Stats
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: GlassCard(
                            radius: 24,
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.local_fire_department_rounded,
                                  color: Colors.orangeAccent,
                                  size: 28,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '١٢ يوم',
                                  style: GoogleFonts.notoKufiArabic(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: primaryTextColor,
                                  ),
                                ),
                                Text(
                                  'نشاط متواصل',
                                  style: GoogleFonts.notoKufiArabic(
                                    fontSize: 10,
                                    color: secondaryTextColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GlassCard(
                            radius: 24,
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.emoji_events_rounded,
                                  color: accentGold,
                                  size: 28,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '٣ شارات',
                                  style: GoogleFonts.notoKufiArabic(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: primaryTextColor,
                                  ),
                                ),
                                Text(
                                  'الإنجازات المفتوحة',
                                  style: GoogleFonts.notoKufiArabic(
                                    fontSize: 10,
                                    color: secondaryTextColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Section: Achievements List
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
                    child: Text(
                      'الإنجازات الأخيرة',
                      style: GoogleFonts.notoKufiArabic(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: primaryTextColor,
                      ),
                    ),
                  ),
                ),

                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final ach = achievements[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: GlassCard(
                          radius: 20,
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: accentGold.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  ach.$3,
                                  color: accentGold,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ach.$1,
                                      style: GoogleFonts.notoKufiArabic(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: primaryTextColor,
                                      ),
                                    ),
                                    Text(
                                      ach.$2,
                                      style: GoogleFonts.notoKufiArabic(
                                        fontSize: 10,
                                        color: secondaryTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.check_circle_rounded,
                                color: const Color(0xFF0F8B6D),
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      );
                    }, childCount: achievements.length),
                  ),
                ),

                // Navigation shortcuts
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 80),
                    child: Column(
                      children: [
                        _buildSettingsRow(
                          context,
                          'عرض الإحصائيات الكاملة',
                          Icons.query_stats_rounded,
                          () {
                            context.push('/stats');
                          },
                        ),
                        const SizedBox(height: 10),
                        _buildSettingsRow(
                          context,
                          'ترقية العضوية للفاخر (Premium)',
                          Icons.workspace_premium_rounded,
                          () {
                            context.push('/subscription');
                          },
                          isAccent: true,
                        ),
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

  Widget _buildSettingsRow(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap, {
    bool isAccent = false,
  }) {
    final accentGold = AppTheme.goldPrimary;
    final primaryTextColor = AppTheme.textPrimary;

    return GlassCard(
      radius: 20,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: isAccent ? accentGold : primaryTextColor, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.notoKufiArabic(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: isAccent ? accentGold : primaryTextColor,
              ),
            ),
          ),
          Icon(
            Icons.chevron_left_rounded,
            color: isAccent
                ? accentGold
                : AppTheme.textMuted,
            size: 20,
          ),
        ],
      ),
    );
  }
}

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final accentGold = AppTheme.goldPrimary;
    final primaryTextColor = AppTheme.textPrimary;
    final secondaryTextColor = AppTheme.textMuted;

    return Scaffold(
      body: Stack(
        children: [
          const StarBackground(),
          SafeArea(
            child: CustomScrollView(
              slivers: [
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
                          'الإحصائيات والتقدم',
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

                // Stats Dashboard Cards
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                    child: GlassCard(
                      radius: 30,
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'تلاوة القرآن اليومية',
                            style: GoogleFonts.notoKufiArabic(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: primaryTextColor,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '٦٥ آية',
                                    style: GoogleFonts.notoKufiArabic(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: primaryTextColor,
                                    ),
                                  ),
                                  Text(
                                    'المجموع اليومي',
                                    style: GoogleFonts.notoKufiArabic(
                                      fontSize: 11,
                                      color: secondaryTextColor,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 50,
                                height: 50,
                                child: CircularProgressIndicator(
                                  value: 0.65,
                                  strokeWidth: 6,
                                  backgroundColor: accentGold.withValues(
                                    alpha: 0.08,
                                  ),
                                  valueColor: AlwaysStoppedAnimation(
                                    accentGold,
                                  ),
                                  strokeCap: StrokeCap.round,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                    child: GlassCard(
                      radius: 30,
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'إجمالي التسبيح والأذكار',
                            style: GoogleFonts.notoKufiArabic(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: primaryTextColor,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '٣,٤٢٠ تسبيحة',
                                    style: GoogleFonts.notoKufiArabic(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: primaryTextColor,
                                    ),
                                  ),
                                  Text(
                                    'مجموع الأسبوع الحالي',
                                    style: GoogleFonts.notoKufiArabic(
                                      fontSize: 11,
                                      color: secondaryTextColor,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 50,
                                height: 50,
                                child: CircularProgressIndicator(
                                  value: 0.82,
                                  strokeWidth: 6,
                                  backgroundColor: accentGold.withValues(
                                    alpha: 0.08,
                                  ),
                                  valueColor: AlwaysStoppedAnimation(
                                    accentGold,
                                  ),
                                  strokeCap: StrokeCap.round,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                    child: GlassCard(
                      radius: 30,
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'المحافظة على الجماعة والصلوات',
                            style: GoogleFonts.notoKufiArabic(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: primaryTextColor,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '٩٤٪',
                                    style: GoogleFonts.inter(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: primaryTextColor,
                                    ),
                                  ),
                                  Text(
                                    'نسبة الالتزام الشهري',
                                    style: GoogleFonts.notoKufiArabic(
                                      fontSize: 11,
                                      color: secondaryTextColor,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 50,
                                height: 50,
                                child: CircularProgressIndicator(
                                  value: 0.94,
                                  strokeWidth: 6,
                                  backgroundColor: accentGold.withValues(
                                    alpha: 0.08,
                                  ),
                                  valueColor: AlwaysStoppedAnimation(
                                    accentGold,
                                  ),
                                  strokeCap: StrokeCap.round,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
}

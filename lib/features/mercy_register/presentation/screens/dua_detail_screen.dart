import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/dua_library.dart';
import '../../data/models/reward.dart';
import '../../providers/mercy_register_providers.dart';
import '../../../../theme/app_theme.dart';
import '../../../../widgets/premium_success_notification.dart';

class DuaDetailScreen extends ConsumerStatefulWidget {
  final String duaId;
  final String memorialId;

  const DuaDetailScreen({
    super.key,
    required this.duaId,
    required this.memorialId,
  });

  @override
  ConsumerState<DuaDetailScreen> createState() => _DuaDetailScreenState();
}

class _DuaDetailScreenState extends ConsumerState<DuaDetailScreen> {
  bool _isSubmitting = false;
  bool _isBookmarked = false;

  DuaItem? get _dua =>
      kDuaItems.where((d) => d.id == widget.duaId).firstOrNull;

  @override
  Widget build(BuildContext context) {
    final dua = _dua;
    if (dua == null) {
      return Scaffold(
        backgroundColor: AppTheme.bgPrimary,
        body: Center(
          child: Text(
            'الدعاء غير موجود',
            style: GoogleFonts.notoKufiArabic(color: AppTheme.textMuted),
          ),
        ),
      );
    }

    final bottom = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: AppTheme.bgPrimary,
      body: Stack(
        children: [
          // Background gradient
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppTheme.goldPrimary.withValues(alpha: 0.08),
                    AppTheme.bgPrimary,
                    AppTheme.bgPrimary,
                  ],
                  stops: const [0.0, 0.3, 1.0],
                ),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                // App bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 18,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        dua.title,
                        style: GoogleFonts.notoKufiArabic(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          setState(() => _isBookmarked = !_isBookmarked);
                          showPremiumSuccess(
                            context,
                            message: _isBookmarked
                                ? 'تمت إضافة الدعاء إلى المفضلة'
                                : 'تمت إزالة الدعاء من المفضلة',
                          );
                        },
                        icon: Icon(
                          _isBookmarked
                              ? Icons.bookmark_rounded
                              : Icons.bookmark_outline_rounded,
                          size: 22,
                          color: _isBookmarked
                              ? AppTheme.goldPrimary
                              : AppTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),

                // Scrollable dua content
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 24),

                        // Decorative frame
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            color: AppTheme.bgCard.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: AppTheme.goldPrimary.withValues(alpha: 0.15),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.goldPrimary.withValues(alpha: 0.05),
                                blurRadius: 30,
                                spreadRadius: -5,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // Ornament
                              Icon(
                                Icons.auto_fix_high_rounded,
                                size: 28,
                                color: AppTheme.goldPrimary.withValues(alpha: 0.5),
                              ),
                              const SizedBox(height: 20),

                              // Dua text
                              Text(
                                dua.fullText,
                                style: GoogleFonts.notoKufiArabic(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.textPrimary,
                                  height: 2.2,
                                ),
                                textAlign: TextAlign.center,
                              ),

                              const SizedBox(height: 24),

                              // Divider
                              Container(
                                width: 60,
                                height: 2,
                                decoration: BoxDecoration(
                                  color: AppTheme.goldPrimary.withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(1),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Source
                              if (dua.source != null)
                                Text(
                                  dua.source!,
                                  style: GoogleFonts.notoKufiArabic(
                                    fontSize: 12,
                                    color: AppTheme.goldPrimary.withValues(alpha: 0.6),
                                  ),
                                ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Action buttons row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _ActionButton(
                              icon: Icons.copy_rounded,
                              label: 'نسخ',
                              onTap: () {
                                Clipboard.setData(
                                  ClipboardData(text: dua.fullText),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'تم نسخ الدعاء',
                                      style: GoogleFonts.notoKufiArabic(),
                                    ),
                                    backgroundColor: AppTheme.bgCard,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 16),
                            _ActionButton(
                              icon: Icons.share_rounded,
                              label: 'مشاركة',
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'ميزة المشاركة قريباً',
                                      style: GoogleFonts.notoKufiArabic(),
                                    ),
                                    backgroundColor: AppTheme.bgCard,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),

                // Bottom CTA
                Container(
                  padding: EdgeInsets.fromLTRB(24, 16, 24, bottom + 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        AppTheme.bgPrimary.withValues(alpha: 0.95),
                      ],
                    ),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: Material(
                      borderRadius: BorderRadius.circular(18),
                      elevation: 4,
                      shadowColor: AppTheme.goldPrimary.withValues(alpha: 0.3),
                      child: Ink(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.goldPrimary.withValues(alpha: 0.9),
                              AppTheme.goldPrimary,
                            ],
                          ),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: _isSubmitting ? null : _submitDedication,
                          child: Center(
                            child: _isSubmitting
                                ? SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppTheme.bgPrimary,
                                    ),
                                  )
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.volunteer_activism_rounded,
                                        size: 18,
                                        color: AppTheme.bgPrimary,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        'إهداء هذا الدعاء',
                                        style: GoogleFonts.notoKufiArabic(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: AppTheme.bgPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
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

  Future<void> _submitDedication() async {
    if (_isSubmitting) return;
    setState(() => _isSubmitting = true);

    try {
      final repo = await ref.read(memorialRepositoryProvider.future);
      final reward = Reward.create(
        memorialId: widget.memorialId,
        type: RewardType.dua,
        note: _dua?.title,
      );
      await repo.addReward(reward);
      final updated = (await repo.getMemorialById(widget.memorialId)).dataOrNull;
      if (updated != null) {
        ref.read(memorialsProvider.notifier).updateSingleMemorial(updated);
      }

      if (mounted) {
        HapticFeedback.heavyImpact();
        showPremiumSuccess(
          context,
          message: 'تم إهداء الدعاء بنجاح',
        );
        Navigator.of(context)
          ..pop()
          ..pop();
      }
    } catch (_) {
      if (mounted) {
        showPremiumSuccess(
          context,
          message: 'حدث خطأ، حاول مرة أخرى',
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.bgCard,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        splashColor: AppTheme.goldPrimary.withValues(alpha: 0.08),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppTheme.goldPrimary.withValues(alpha: 0.1),
              width: 0.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: AppTheme.goldPrimary.withValues(alpha: 0.7)),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.notoKufiArabic(
                  fontSize: 13,
                  color: AppTheme.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

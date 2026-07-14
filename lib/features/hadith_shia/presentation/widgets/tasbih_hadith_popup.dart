import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../theme/app_theme.dart';
import '../../../../theme/ds_components.dart';
import '../../data/models/shia_hadith_models.dart';
import '../providers/hadith_providers.dart';

class TasbihHadithPopup extends ConsumerStatefulWidget {
  final VoidCallback? onDismiss;

  const TasbihHadithPopup({super.key, this.onDismiss});

  static void show(BuildContext context, {VoidCallback? onDismiss}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TasbihHadithPopup(onDismiss: onDismiss),
    );
  }

  @override
  ConsumerState<TasbihHadithPopup> createState() => _TasbihHadithPopupState();
}

class _TasbihHadithPopupState extends ConsumerState<TasbihHadithPopup>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hadithAsync = ref.watch(tasbihCompletionHadithProvider);

    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          decoration: BoxDecoration(
            color: const Color(0xFF0B1730),
            borderRadius: BorderRadius.circular(AppTheme.cardRadius),
            border: Border.all(
              color: AppTheme.goldPrimary.withValues(alpha: 0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.goldPrimary.withValues(alpha: 0.08),
                blurRadius: 40,
                spreadRadius: -4,
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 30,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.goldPrimary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.goldPrimary.withValues(alpha: 0.2),
                      AppTheme.goldPrimary.withValues(alpha: 0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: AppTheme.goldPrimary.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  Icons.auto_stories_rounded,
                  color: AppTheme.goldPrimary,
                  size: 30,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'أحسنت! تقبّل الله طاعتكم',
                style: GoogleFonts.notoKufiArabic(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.goldPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                'حديث عن الذكر والعبادة',
                style: GoogleFonts.notoKufiArabic(
                  fontSize: 12,
                  color: AppTheme.textMuted,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: hadithAsync.when(
                  data: (hadith) => _buildHadithContent(hadith),
                  loading: () => const SizedBox(
                    height: 100,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.goldPrimary,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Row(
                  children: [
                    Expanded(
                      child: GoldButton(
                        label: 'مشاركة',
                        onTap: () => _share(),
                        height: 48,
                        outlined: true,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GoldButton(
                        label: 'إغلاق',
                        onTap: () {
                          Navigator.of(context).pop();
                          widget.onDismiss?.call();
                        },
                        height: 48,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHadithContent(ShiaHadith hadith) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.goldPrimary.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.goldPrimary.withValues(alpha: 0.1),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '❝',
            style: GoogleFonts.amiri(
              fontSize: 24,
              color: AppTheme.goldPrimary.withValues(alpha: 0.3),
            ),
          ),
          Text(
            hadith.text,
            style: GoogleFonts.amiri(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppTheme.textPrimary,
              height: 1.8,
            ),
            textAlign: TextAlign.justify,
            textDirection: TextDirection.rtl,
          ),
          Text(
            '❞',
            style: GoogleFonts.amiri(
              fontSize: 24,
              color: AppTheme.goldPrimary.withValues(alpha: 0.3),
            ),
            textAlign: TextAlign.end,
          ),
          if (hadith.sourceDisplayName.isNotEmpty) ...[
            const SizedBox(height: 10),
            AppTheme.goldDivider(width: 32),
            const SizedBox(height: 10),
            Row(
              children: [
                if (hadith.narrator != null && hadith.narrator!.isNotEmpty) ...[
                  Expanded(
                    child: Text(
                      'عن ${hadith.narrator}',
                      style: GoogleFonts.notoKufiArabic(
                        fontSize: 11,
                        color: AppTheme.goldPrimary.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                ],
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.goldPrimary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppTheme.goldPrimary.withValues(alpha: 0.12),
                      width: 0.5,
                    ),
                  ),
                  child: Text(
                    hadith.sourceDisplayName,
                    style: GoogleFonts.notoKufiArabic(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.goldPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _share() {
    final hadithAsync = ref.read(tasbihCompletionHadithProvider);
    hadithAsync.whenData((hadith) {
      final buf = StringBuffer();
      buf.writeln('══════ ❁ ══════');
      buf.writeln();
      buf.writeln('📿 حديث بعد التسبيح');
      buf.writeln();
      buf.writeln('❝');
      buf.writeln(hadith.text);
      buf.writeln('❞');
      buf.writeln();
      if (hadith.sourceDisplayName.isNotEmpty) {
        buf.writeln('📚 ${hadith.sourceDisplayName}');
      }
      buf.writeln();
      buf.writeln('══════ ❁ ══════');
      buf.writeln();
      buf.writeln('🤍 رفيق');
      Share.share(buf.toString());
    });
    HapticFeedback.selectionClick();
  }
}

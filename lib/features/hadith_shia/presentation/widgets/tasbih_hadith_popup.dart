import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../theme/app_theme.dart';
import '../../../../theme/ds_components.dart';

class TasbihHadithPopup extends StatefulWidget {
  final VoidCallback? onDismiss;
  final String? memorialName;
  final VoidCallback? onDedicate;

  const TasbihHadithPopup({super.key, this.onDismiss, this.memorialName, this.onDedicate});

  static void show(BuildContext context, {VoidCallback? onDismiss, String? memorialName, VoidCallback? onDedicate}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TasbihHadithPopup(onDismiss: onDismiss, memorialName: memorialName, onDedicate: onDedicate),
    );
  }

  @override
  State<TasbihHadithPopup> createState() => _TasbihHadithPopupState();
}

class _TasbihHadithPopupState extends State<TasbihHadithPopup>
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
                  Icons.favorite_rounded,
                  color: AppTheme.goldPrimary,
                  size: 30,
                ),
              ),
              const SizedBox(height: 16),
              ShaderMask(
                shaderCallback: (bounds) => AppTheme.goldGradient.createShader(bounds),
                child: Text(
                  'اذكروا أمواتكم بالرحمة',
                  style: GoogleFonts.notoKufiArabic(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'اهدِ ثواب هذا العمل لمن تحب،\nوأكثروا لهم من الدعاء والرحمة.',
                style: GoogleFonts.notoKufiArabic(
                  fontSize: 12,
                  color: AppTheme.textMuted,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
              if (widget.memorialName != null) ...[
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppTheme.goldPrimary.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppTheme.goldPrimary.withValues(alpha: 0.12),
                        width: 0.5,
                      ),
                    ),
                    child: Text(
                      'المرحوم: ${widget.memorialName}',
                      style: GoogleFonts.notoKufiArabic(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.goldPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: AppTheme.goldDivider(),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'اللهم اغفر له وارحمه، واجعل ما أُهدي إليه نورًا ورحمة.',
                  style: GoogleFonts.amiri(
                    fontSize: 15,
                    color: AppTheme.textSecondary,
                    height: 1.8,
                  ),
                  textAlign: TextAlign.center,
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
                        label: widget.onDedicate != null ? 'إهداء هذا التسبيح' : 'إغلاق',
                        onTap: () {
                          Navigator.of(context).pop();
                          if (widget.onDedicate != null) {
                            widget.onDedicate!();
                          } else {
                            widget.onDismiss?.call();
                          }
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

  void _share() {
    final buf = StringBuffer();
    buf.writeln('══════════════════');
    buf.writeln();
    buf.writeln('اذكروا أمواتكم بالرحمة');
    buf.writeln();
    buf.writeln('اهدِ ثواب هذا العمل لمن تحب، وأكثروا لهم من الدعاء والرحمة.');
    buf.writeln();
    if (widget.memorialName != null) {
      buf.writeln('المرحوم: ${widget.memorialName}');
      buf.writeln();
    }
    buf.writeln('اللهم اغفر له وارحمه، واجعل ما أُهدي إليه نورًا ورحمة.');
    buf.writeln();
    buf.writeln('══════════════════');
    buf.writeln();
    buf.writeln('رفيق');
    Share.share(buf.toString());
    HapticFeedback.selectionClick();
  }
}

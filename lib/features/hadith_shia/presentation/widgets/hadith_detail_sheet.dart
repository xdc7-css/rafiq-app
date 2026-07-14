import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../theme/app_theme.dart';
import '../../data/models/shia_hadith_models.dart';

class HadithDetailSheet extends StatelessWidget {
  final ShiaHadith hadith;

  const HadithDetailSheet({super.key, required this.hadith});

  static void show(BuildContext context, ShiaHadith hadith) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => HadithDetailSheet(hadith: hadith),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.92,
      minChildSize: 0.4,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF0B1730),
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.goldPrimary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                AppTheme.goldPrimary.withValues(alpha: 0.2),
                                AppTheme.goldPrimary.withValues(alpha: 0.05),
                              ],
                            ),
                            border: Border.all(
                              color: AppTheme.goldPrimary.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '${hadith.number}',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.goldPrimary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                hadith.sourceDisplayName,
                                style: GoogleFonts.notoKufiArabic(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              Text(
                                'حديث رقم ${hadith.number}',
                                style: GoogleFonts.notoKufiArabic(
                                  fontSize: 12,
                                  color: AppTheme.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => _share(context),
                          icon: Icon(
                            Icons.share_outlined,
                            color: AppTheme.goldPrimary,
                            size: 20,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: hadith.text));
                            HapticFeedback.mediumImpact();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'تم النسخ إلى الحافظة',
                                  style: GoogleFonts.notoKufiArabic(fontSize: 12),
                                ),
                                duration: const Duration(seconds: 2),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.copy_rounded,
                            color: AppTheme.goldPrimary.withValues(alpha: 0.7),
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppTheme.goldPrimary.withValues(alpha: 0.04),
                        borderRadius: BorderRadius.circular(20),
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
                              fontSize: 32,
                              color: AppTheme.goldPrimary.withValues(alpha: 0.3),
                            ),
                          ),
                          Text(
                            hadith.text,
                            style: GoogleFonts.amiri(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.textPrimary,
                              height: 2.0,
                            ),
                            textAlign: TextAlign.justify,
                            textDirection: TextDirection.rtl,
                          ),
                          Text(
                            '❞',
                            style: GoogleFonts.amiri(
                              fontSize: 32,
                              color: AppTheme.goldPrimary.withValues(alpha: 0.3),
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ],
                      ),
                    ),
                    if (hadith.narrator != null && hadith.narrator!.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _buildInfoRow('الراوي', hadith.narrator!),
                    ],
                    if (hadith.subject != null && hadith.subject!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _buildInfoRow('الموضوع', hadith.subject!),
                    ],
                    if (hadith.chain != null && hadith.chain!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _buildInfoRow('السند', hadith.chain!),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.bgCard.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppTheme.goldPrimary.withValues(alpha: 0.08),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            label,
            style: GoogleFonts.notoKufiArabic(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppTheme.goldPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.amiri(
              fontSize: 16,
              color: AppTheme.textPrimary,
              height: 1.6,
            ),
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }

  void _share(BuildContext context) {
    final buf = StringBuffer();
    buf.writeln('══════ ❁ ══════');
    buf.writeln();
    buf.writeln('📖 ${hadith.sourceDisplayName}');
    buf.writeln('🔢 حديث رقم ${hadith.number}');
    buf.writeln();
    buf.writeln('❝');
    buf.writeln(hadith.text);
    buf.writeln('❞');
    buf.writeln();
    if (hadith.narrator != null && hadith.narrator!.isNotEmpty) {
      buf.writeln('عن ${hadith.narrator}');
      buf.writeln();
    }
    buf.writeln('══════ ❁ ══════');
    buf.writeln();
    buf.writeln('🤍 رفيق');
    Share.share(buf.toString());
    HapticFeedback.selectionClick();
  }
}

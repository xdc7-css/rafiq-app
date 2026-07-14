import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/arabic_strings.dart';
import '../../providers/adhkar_provider.dart';
import '../../theme/app_theme.dart';
import '../../theme/ds_components.dart';

class AdhkarScreen extends ConsumerWidget {
  const AdhkarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final w = MediaQuery.sizeOf(context).width;
    final categories = ref.watch(adhkarCategoriesProvider);

    return Scaffold(
      appBar: AppBar(title: Text(Ar.navAdhkar)),
      body: ListView.builder(
        padding: EdgeInsets.fromLTRB(w < 360 ? 12 : 16, 8, w < 360 ? 12 : 16, w < 360 ? 16 : 24),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final completedCount = category.adhkar
              .where((d) => d.isCompleted)
              .length;
          final totalCount = category.adhkar.length;
          final progress = totalCount > 0 ? completedCount / totalCount : 0.0;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: SimpleGlassCard(
              onTap: () => context.push('/adhkar/${category.id}'),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppTheme.goldPrimary.withValues( alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      _getCategoryIcon(index),
                      color: AppTheme.goldPrimary,
                      size: 28,
                    ),
                  ),
                  const Gap(16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.name,
                          style: GoogleFonts.notoKufiArabic(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const Gap(2),
                        Text(
                          category.nameArabic,
                          style: AppTheme.arabicText(
                            size: 16,
                            color: AppTheme.textMuted,
                          ),
                        ),
                        const Gap(10),
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: progress,
                                  minHeight: 5,
                                  backgroundColor: AppTheme.goldPrimary
                                      .withValues( alpha: 0.08),
                                  valueColor: const AlwaysStoppedAnimation(
                                    AppTheme.goldPrimary,
                                  ),
                                ),
                              ),
                            ),
                            const Gap(10),
                            Text(
                              '$completedCount/$totalCount',
                              style: GoogleFonts.notoKufiArabic(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.goldPrimary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Gap(8),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: AppTheme.textMuted,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _getCategoryIcon(int index) {
    const icons = [
      Icons.wb_sunny,
      Icons.wb_twilight,
      Icons.bedtime,
      Icons.flight,
      Icons.mosque,
    ];
    return icons[index % icons.length];
  }
}

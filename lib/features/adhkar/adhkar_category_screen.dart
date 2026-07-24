import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/arabic_strings.dart';
import '../../providers/adhkar_provider.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../theme/ds_components.dart';
import '../mercy_register/data/models/reward.dart';
import '../mercy_register/providers/mercy_register_providers.dart';

final Set<String> _pendingDedications = {};

class AdhkarCategoryScreen extends ConsumerStatefulWidget {
  final String categoryId;

  const AdhkarCategoryScreen({super.key, required this.categoryId});

  @override
  ConsumerState<AdhkarCategoryScreen> createState() =>
      _AdhkarCategoryScreenState();
}

class _AdhkarCategoryScreenState extends ConsumerState<AdhkarCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final memorialId = GoRouterState.of(context).uri.queryParameters['memorialId'];
    final categories = ref.watch(adhkarCategoriesProvider);
    final category = categories.firstWhere(
      (c) => c.id == widget.categoryId,
      orElse: () => AdhkarCategory(id: '', name: Ar.categoryNotFound),
    );

    if (category.id.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(Ar.navAdhkar)),
        body: Center(child: Text(Ar.categoryNotFound)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
        actions: [
          IconButton(
            onPressed: () {
              ref
                  .read(adhkarCategoriesProvider.notifier)
                  .resetCategory(widget.categoryId);
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.fromLTRB(
          w < 360 ? 12 : 16,
          8,
          w < 360 ? 12 : 16,
          memorialId != null ? 80 : (w < 360 ? 16 : 24),
        ),
        itemCount: category.adhkar.length,
        itemBuilder: (context, index) {
          final dhikr = category.adhkar[index];
          return _DhikrCard(dhikr: dhikr, categoryId: widget.categoryId);
        },
      ),
      bottomNavigationBar: memorialId != null
          ? _DedicationBar(
              memorialId: memorialId,
              rewardType: RewardType.dua,
            )
          : null,
    );
  }
}

class _DhikrCard extends ConsumerWidget {
  final AdhkarModel dhikr;
  final String categoryId;

  const _DhikrCard({required this.dhikr, required this.categoryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final w = MediaQuery.sizeOf(context).width;
    final progress = dhikr.targetCount > 0
        ? dhikr.currentCount.clamp(0, dhikr.targetCount) / dhikr.targetCount
        : 0.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SimpleGlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (dhikr.source != null)
                  Flexible(
                    child: GoldBadge(text: dhikr.source!, fontSize: 11),
                  )
                else
                  const SizedBox.shrink(),
                const SizedBox(width: 8),
                if (dhikr.isCompleted)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50).withValues( alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF4CAF50).withValues( alpha: 0.2),
                        width: 0.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.check_circle,
                          size: 14,
                          color: Color(0xFF4CAF50),
                        ),
                        const Gap(4),
                        Text(
                          Ar.completed,
                          style: GoogleFonts.notoKufiArabic(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF4CAF50),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const Gap(14),
            Text(
              dhikr.textArabic,
              style: AppTheme.arabicText(
                size: 20,
                color: AppTheme.textPrimary,
                height: 1.8,
              ),
              textDirection: TextDirection.rtl,
            ),
            const Gap(16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${dhikr.currentCount} / ${dhikr.targetCount}',
                        style: GoogleFonts.notoKufiArabic(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textMuted,
                        ),
                      ),
                      const Gap(4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 5,
                          backgroundColor: AppTheme.goldPrimary.withValues(
                            alpha: 0.08,
                          ),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            dhikr.isCompleted
                                ? const Color(0xFF4CAF50)
                                : AppTheme.goldPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(16),
                if (!dhikr.isCompleted)
                  ElevatedButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      ref
                          .read(adhkarCategoriesProvider.notifier)
                          .incrementDhikr(categoryId, dhikr.id);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.goldPrimary,
                      foregroundColor: AppTheme.bgPrimary,
                      padding: EdgeInsets.symmetric(
                        horizontal: w < 360 ? 16 : 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      Ar.count,
                      style: GoogleFonts.notoKufiArabic(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppTheme.borderGold, width: 0.5),
                  ),
                  child: IconButton(
                    onPressed: () => Share.share(dhikr.textArabic),
                    icon: const Icon(Icons.share_outlined, size: 18),
                    constraints: const BoxConstraints(
                      minWidth: 36,
                      minHeight: 36,
                    ),
                    padding: EdgeInsets.zero,
                    splashRadius: 18,
                    color: AppTheme.textMuted,
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

class _DedicationBar extends ConsumerWidget {
  final String memorialId;
  final RewardType rewardType;

  const _DedicationBar({required this.memorialId, required this.rewardType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        MediaQuery.paddingOf(context).bottom + 12,
      ),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        border: Border(
          top: BorderSide(color: AppTheme.borderSubtle, width: 0.5),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton.icon(
          onPressed: () => _dedicate(context, ref),
          icon: const Icon(Icons.favorite_outline_rounded, size: 18),
          label: Text(
            'إهداء لهذا المتوفى',
            style: GoogleFonts.notoKufiArabic(
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.goldPrimary,
            foregroundColor: AppTheme.bgPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 0,
          ),
        ),
      ),
    );
  }

  Future<void> _dedicate(BuildContext context, WidgetRef ref) async {
    if (_pendingDedications.contains(memorialId)) return;
    _pendingDedications.add(memorialId);
    try {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppTheme.bgCard,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'إهداء الدعاء',
            style: GoogleFonts.notoKufiArabic(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'هل تريد إهداء ثواب هذا الدعاء للمتوفى؟',
            style: GoogleFonts.notoKufiArabic(color: AppTheme.textMuted),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text('إلغاء', style: TextStyle(color: AppTheme.textMuted)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text('إهداء', style: TextStyle(color: AppTheme.goldPrimary)),
            ),
          ],
        ),
      );
      if (confirmed != true || !context.mounted) return;
      final repo = await ref.read(memorialRepositoryProvider.future);
      final reward = Reward.create(memorialId: memorialId, type: rewardType);
      await repo.addReward(reward);
      final updated = (await repo.getMemorialById(memorialId)).dataOrNull;
      if (updated != null) {
        ref.read(memorialsProvider.notifier).updateSingleMemorial(updated);
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'تم إهداء الدعاء بنجاح',
              style: GoogleFonts.notoKufiArabic(),
            ),
            backgroundColor: AppTheme.bgCard,
          ),
        );
        Navigator.pop(context);
      }
    } finally {
      _pendingDedications.remove(memorialId);
    }
  }
}

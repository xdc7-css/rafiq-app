import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vector_graphics/vector_graphics.dart';
import '../../data/models/memorial.dart';
import '../../data/models/reward.dart';
import '../../providers/mercy_register_providers.dart';
import '../../../../core/utils/hijri_date.dart';

// ═══════════════════════════════════════════════════════════════════
// Palette
// ═══════════════════════════════════════════════════════════════════

const _bgCard = Color(0xFF11264E);
const _bgElevated = Color(0xFF16335E);
const _bgSurface = Color(0xFF152D52);
const _gold = Color(0xFFD8A83A);
const _white = Color(0xFFFFFFFF);
const _textSecondary = Color(0xFFB0BDD4);
const _textTertiary = Color(0x66B0BDD4);
const _tonalOverlay = Color(0x08FFFFFF);

// ═══════════════════════════════════════════════════════════════════
// MemorialCard
// ═══════════════════════════════════════════════════════════════════

class MemorialCard extends ConsumerWidget {
  final Memorial memorial;
  final bool isOwner;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onArchive;
  final VoidCallback? onReport;
  final VoidCallback? onDedicateDua;
  final VoidCallback? onDedicateFatiha;
  final VoidCallback? onDedicateTasbeeh;

  const MemorialCard({
    super.key,
    required this.memorial,
    this.isOwner = false,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onArchive,
    this.onReport,
    this.onDedicateDua,
    this.onDedicateFatiha,
    this.onDedicateTasbeeh,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = memorial.displayName;
    final initial = name.isNotEmpty ? name[0] : '?';
    final gregDate =
        '${memorial.dateOfDeath.year}/${memorial.dateOfDeath.month.toString().padLeft(2, '0')}/${memorial.dateOfDeath.day.toString().padLeft(2, '0')}';
    final hijriDate = HijriDate.fromDate(memorial.dateOfDeath).format();

    return Material(
      color: _bgCard,
      elevation: 6,
      shadowColor: Colors.black.withValues(alpha: 0.5),
      borderRadius: BorderRadius.circular(28),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
        ),
        child: Stack(
          children: [
            // Watermark
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: Opacity(
                  opacity: 0.045,
                  child: Image.asset(
                    'assets/images/whitebg.PNG',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            // Subtle gold border (rendered on top of watermark)
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: _gold.withValues(alpha: 0.12),
                    width: 0.6,
                  ),
                ),
              ),
            ),

            // Content
            InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(28),
              splashColor: _gold.withValues(alpha: 0.06),
              highlightColor: _gold.withValues(alpha: 0.03),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildIdentity(initial, name, gregDate, hijriDate),
                    const SizedBox(height: 20),
                    _buildLastDeedPanel(context),
                    const SizedBox(height: 20),
                    _buildStats(),
                    const SizedBox(height: 20),
                    _buildPrimaryAction(context),
                  ],
                ),
              ),
            ),

            // SVG ornament
            Positioned(
              bottom: 10,
              left: 10,
              child: Opacity(
                opacity: 0.065,
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: VectorGraphic(
                    loader: AssetBytesLoader(
                        'assets/decorations/mashrabiya_corner.svg.vec'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // SECTION 1 — Identity
  // ═══════════════════════════════════════════════════════════════

  Widget _buildIdentity(
    String initial,
    String displayName,
    String gregDate,
    String hijriDate,
  ) {
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                _bgElevated,
                _bgCard,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: _gold.withValues(alpha: 0.15),
                blurRadius: 12,
                spreadRadius: 1,
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _bgElevated,
              border: Border.all(
                color: _gold.withValues(alpha: 0.25),
                width: 1.0,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              initial,
              style: GoogleFonts.notoKufiArabic(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: _gold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                displayName,
                style: GoogleFonts.notoKufiArabic(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: _white,
                  height: 1.25,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Text(
                    gregDate,
                    style: GoogleFonts.notoKufiArabic(
                      fontSize: 11,
                      color: _textTertiary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    hijriDate,
                    style: GoogleFonts.notoKufiArabic(
                      fontSize: 11,
                      color: _textTertiary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (isOwner)
          Padding(
            padding: const EdgeInsets.only(left: 6),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: _gold.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'مالك',
                style: GoogleFonts.notoKufiArabic(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: _gold,
                ),
              ),
            ),
          ),
        _OverflowMenu(
          isOwner: isOwner,
          onEdit: onEdit,
          onDelete: onDelete,
          onArchive: onArchive,
          onReport: onReport,
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // SECTION 2 — Last Deed (emotional focus)
  // Reads REAL latest reward from Firestore
  // ═══════════════════════════════════════════════════════════════

  Widget _buildLastDeedPanel(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final rewardsAsync = ref.watch(
          rewardsStreamProvider(memorial.id),
        );

        return rewardsAsync.when(
          data: (rewards) {
            if (rewards.isEmpty) return _emptyDeedPanel();
            final latest = rewards.first;
            return _filledDeedPanel(latest);
          },
          loading: () => _emptyDeedPanel(),
          error: (_, __) => _emptyDeedPanel(),
        );
      },
    );
  }

  Widget _emptyDeedPanel() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: _tonalOverlay,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'آخر عمل مُهدى',
            style: GoogleFonts.notoKufiArabic(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: _textTertiary,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'ابدأ بإهداء أول عمل صالح لهذا المتوفى',
            style: GoogleFonts.notoKufiArabic(
              fontSize: 13,
              color: _textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _filledDeedPanel(Reward reward) {
    final icon = _rewardIcon(reward.type);
    final label = _rewardDisplayName(reward);
    final timeAgo = _formatTimeAgo(reward.createdAt);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: _tonalOverlay,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'آخر عمل مُهدى',
            style: GoogleFonts.notoKufiArabic(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: _textTertiary,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: _gold.withValues(alpha: 0.80),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.notoKufiArabic(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _white,
                    height: 1.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            timeAgo,
            style: GoogleFonts.notoKufiArabic(
              fontSize: 11,
              color: _textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // SECTION 3 — Statistics
  // ═══════════════════════════════════════════════════════════════

  Widget _buildStats() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: _tonalOverlay,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatColumn(
              icon: Icons.favorite_rounded,
              value: memorial.duaCount,
              label: 'الأدعية',
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _StatColumn(
              icon: Icons.menu_book_rounded,
              value: memorial.khatmahCount,
              label: 'الفاتحة',
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _StatColumn(
              icon: Icons.spa_rounded,
              value: memorial.tasbeehCount,
              label: 'التسابيح',
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // SECTION 4 — Single Action → Bottom Sheet
  // ═══════════════════════════════════════════════════════════════

  Widget _buildPrimaryAction(BuildContext context) {
    return Material(
      color: _bgSurface,
      borderRadius: BorderRadius.circular(16),
      elevation: 1,
      shadowColor: Colors.black.withValues(alpha: 0.2),
      child: InkWell(
        onTap: () => _showDedicationSheet(context),
        borderRadius: BorderRadius.circular(16),
        splashColor: _gold.withValues(alpha: 0.08),
        highlightColor: _gold.withValues(alpha: 0.04),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                _gold.withValues(alpha: 0.95),
                _gold,
              ],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.volunteer_activism_rounded,
                size: 17,
                color: _bgCard,
              ),
              const SizedBox(width: 8),
              Text(
                'إهداء عمل صالح',
                style: GoogleFonts.notoKufiArabic(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: _bgCard,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDedicationSheet(BuildContext context) async {
    final action = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const _DedicationSheet(),
    );
    // Wait one frame for the pop animation to fully complete before pushing
    // a new route — prevents the Navigator key-reservation assertion.
    await Future<void>.delayed(Duration.zero);
    if (!context.mounted) return;
    switch (action) {
      case 'dua':
        onDedicateDua?.call();
      case 'fatiha':
        onDedicateFatiha?.call();
      case 'tasbeeh':
        onDedicateTasbeeh?.call();
    }
  }
}

// ═══════════════════════════════════════════════════════════════════
// Dedication Bottom Sheet
// ═══════════════════════════════════════════════════════════════════

class _DedicationSheet extends StatelessWidget {
  const _DedicationSheet();

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.viewPaddingOf(context).bottom;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      decoration: BoxDecoration(
        color: _bgCard,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 20),
              decoration: BoxDecoration(
                color: _tonalOverlay,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Title
            Text(
              'إهداء عمل صالح',
              style: GoogleFonts.notoKufiArabic(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: _white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'اختر نوع العمل الصالح',
              style: GoogleFonts.notoKufiArabic(
                fontSize: 12,
                color: _textTertiary,
              ),
            ),
            const SizedBox(height: 20),

            // Options
            _SheetOption(
              icon: Icons.favorite_rounded,
              label: 'دعاء',
              subtitle: 'ادعُ للمتوفى بدعاء مُستجاب',
              onTap: () => Navigator.pop(context, 'dua'),
            ),
            _SheetOption(
              icon: Icons.menu_book_rounded,
              label: 'الفاتحة',
              subtitle: 'اقرأ سورة الفاتحة على روحه',
              onTap: () => Navigator.pop(context, 'fatiha'),
            ),
            _SheetOption(
              icon: Icons.spa_rounded,
              label: 'التسبيح',
              subtitle: 'سبّح لله تسبيحة الزهراء',
              onTap: () => Navigator.pop(context, 'tasbeeh'),
            ),

            SizedBox(height: bottom + 8),
          ],
        ),
      ),
    );
  }
}

class _SheetOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  const _SheetOption({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: _gold.withValues(alpha: 0.08),
          highlightColor: _gold.withValues(alpha: 0.04),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: _tonalOverlay,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: _gold.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Icon(icon, size: 20, color: _gold),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: GoogleFonts.notoKufiArabic(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: _white,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: GoogleFonts.notoKufiArabic(
                          fontSize: 11,
                          color: _textTertiary,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 14,
                  color: _textTertiary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// Stat Column
// ═══════════════════════════════════════════════════════════════════

class _StatColumn extends StatefulWidget {
  final IconData icon;
  final int value;
  final String label;

  const _StatColumn({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  State<_StatColumn> createState() => _StatColumnState();
}

class _StatColumnState extends State<_StatColumn> {
  int _previousValue = 0;

  @override
  void didUpdateWidget(_StatColumn oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _previousValue = oldWidget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          widget.icon,
          size: 16,
          color: _gold.withValues(alpha: 0.55),
        ),
        const SizedBox(height: 8),
        TweenAnimationBuilder<int>(
          tween: IntTween(begin: _previousValue, end: widget.value),
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeOutCubic,
          builder: (context, v, _) {
            return Text(
              '$v',
              style: GoogleFonts.notoKufiArabic(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: _white,
                height: 1.0,
              ),
            );
          },
        ),
        const SizedBox(height: 4),
        Text(
          widget.label,
          style: GoogleFonts.notoKufiArabic(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: _textSecondary,
            height: 1.0,
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// Overflow Menu
// ═══════════════════════════════════════════════════════════════════

class _OverflowMenu extends StatelessWidget {
  final bool isOwner;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onArchive;
  final VoidCallback? onReport;

  const _OverflowMenu({
    required this.isOwner,
    this.onEdit,
    this.onDelete,
    this.onArchive,
    this.onReport,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert_rounded,
        size: 17,
        color: _textTertiary,
      ),
      color: _bgSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      padding: EdgeInsets.zero,
      onSelected: (value) {
        switch (value) {
          case 'edit':
            onEdit?.call();
          case 'delete':
            onDelete?.call();
          case 'archive':
            onArchive?.call();
          case 'report':
            onReport?.call();
        }
      },
      itemBuilder: (ctx) {
        if (isOwner) {
          return [
            _item('edit', Icons.edit_outlined, 'تعديل', const Color(0xFF6AADE4)),
            _item('delete', Icons.delete_outline_rounded, 'حذف', Colors.redAccent),
            _item('archive', Icons.archive_outlined, 'أرشفة', _textSecondary),
          ];
        }
        return [
          _item('report', Icons.flag_outlined, 'إبلاغ', Colors.orangeAccent),
        ];
      },
    );
  }

  PopupMenuItem<String> _item(
    String value,
    IconData icon,
    String label,
    Color color,
  ) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 10),
          Text(
            label,
            style: GoogleFonts.notoKufiArabic(fontSize: 13, color: _white),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// Helpers — Reward → Display
// ═══════════════════════════════════════════════════════════════════

IconData _rewardIcon(RewardType type) {
  switch (type) {
    case RewardType.dua:
      return Icons.favorite_rounded;
    case RewardType.quranKhatmah:
      return Icons.menu_book_rounded;
    case RewardType.tasbeeh:
      return Icons.spa_rounded;
    case RewardType.prayer:
      return Icons.favorite_rounded;
    case RewardType.surahRecitation:
      return Icons.menu_book_rounded;
    case RewardType.charity:
      return Icons.volunteer_activism_rounded;
  }
}

String _rewardDisplayName(Reward reward) {
  switch (reward.type) {
    case RewardType.dua:
      return 'دعاء';
    case RewardType.quranKhatmah:
      return 'سورة الفاتحة';
    case RewardType.tasbeeh:
      return 'تسبيح الزهراء';
    case RewardType.prayer:
      return 'صلاة';
    case RewardType.surahRecitation:
      return 'قراءة سورة';
    case RewardType.charity:
      return 'صدقة';
  }
}

String _formatTimeAgo(DateTime date) {
  final diff = DateTime.now().difference(date);
  if (diff.inMinutes < 1) return 'الآن';
  if (diff.inHours < 1) return 'منذ ${diff.inMinutes} دقيقة';
  if (diff.inHours < 24) return 'منذ ${diff.inHours} ساعة';
  if (diff.inDays < 30) return 'منذ ${diff.inDays} يوم';
  if (diff.inDays < 365) return 'منذ ${(diff.inDays / 30).floor()} شهر';
  return 'منذ ${(diff.inDays / 365).floor()} سنة';
}

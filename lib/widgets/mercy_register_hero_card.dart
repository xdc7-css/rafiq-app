import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../features/mercy_register/data/models/memorial.dart';
import '../features/mercy_register/data/models/reward.dart';
import '../features/mercy_register/providers/mercy_register_providers.dart';
import '../theme/app_theme.dart';

/// Redesigned Thawab Dedication (إهداء الثواب) component for Rafeeq Home Screen.
/// Provides a serene, tactile, accessible, and spiritually intentional experience
/// to dedicate righteous deeds to deceased loved ones or all believers.
class MercyRegisterHeroCard extends ConsumerStatefulWidget {
  const MercyRegisterHeroCard({super.key});

  @override
  ConsumerState<MercyRegisterHeroCard> createState() =>
      _MercyRegisterHeroCardState();
}

class _MercyRegisterHeroCardState extends ConsumerState<MercyRegisterHeroCard> {
  // null represents "عامة موتى المؤمنين والمؤمنات" (Universal recipient)
  String? _selectedMemorialId;
  bool _isCompleted = false;
  String _completedDeedName = '';
  bool _isSubmitting = false;

  static const String _universalName = 'عامة موتى المؤمنين والمؤمنات';
  static const String _universalSubtitle = 'لكل من ليس له ذاكر أو من يدعو له';

  static const List<String> _fatihaAyahs = [
    'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ (١)',
    'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ (٢)',
    'الرَّحْمَٰنِ الرَّحِيمِ (٣)',
    'مَالِكِ يَوْمِ الدِّينِ (٤)',
    'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ (٥)',
    'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ (٦)',
    'صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ (٧)',
  ];

  static const String _transmittedDua =
      'اللَّهُمَّ اغْفِرْ لَهُ وَارْحَمْهُ، وَعَافِهِ وَاعْفُ عَنْهُ، وَأَكْرِمْ نُزُلَهُ، وَوَسِّعْ مُدْخَلَهُ، وَاجْعَلْ قَبْرَهُ رَوْضَةً مِنْ رِيَاضِ الْجَنَّةِ، وَأَلْحِقْهُ بِالصَّالِحِينَ.';

  @override
  Widget build(BuildContext context) {
    final memorials = ref.watch(memorialsProvider);
    final Memorial? activeMemorial = _getActiveMemorial(memorials);
    final String recipientName =
        activeMemorial?.displayName ?? _universalName;
    final String recipientSubtitle = activeMemorial != null
        ? 'تغمّده الله بواسع رحمته ومغفرته'
        : _universalSubtitle;

    return Semantics(
      container: true,
      label: 'قسم إهداء الثواب لموتى المسلمين',
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          border: Border.all(
            color: AppTheme.borderGold,
            width: 0.8,
          ),
          gradient: const LinearGradient(
            colors: [
              AppTheme.bgCard,
              AppTheme.navyDeep,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          boxShadow: AppTheme.luxuryShadow,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          child: Stack(
            children: [
              // Subtle background watermark texture
              Positioned.fill(
                child: Opacity(
                  opacity: 0.04,
                  child: Image.asset(
                    'assets/images/whitebg.webp',
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Main content with smooth state transition
              Padding(
                padding: const EdgeInsets.all(AppTheme.cardPadding),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 280),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  child: _isCompleted
                      ? _buildCompletedState(recipientName)
                      : _buildMainContent(
                          memorials: memorials,
                          activeMemorial: activeMemorial,
                          recipientName: recipientName,
                          recipientSubtitle: recipientSubtitle,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Memorial? _getActiveMemorial(List<Memorial> memorials) {
    if (memorials.isEmpty) return null;
    if (_selectedMemorialId != null) {
      final found =
          memorials.where((m) => m.id == _selectedMemorialId).firstOrNull;
      if (found != null) return found;
    }
    // If not manually chosen or selected was deleted, default to first memorial
    return memorials.first;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Main Interactive Content
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildMainContent({
    required List<Memorial> memorials,
    required Memorial? activeMemorial,
    required String recipientName,
    required String recipientSubtitle,
  }) {
    return Column(
      key: const ValueKey<String>('main_content'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── 1. Header: Spiritual Intent & Quick Link to Registry ──
        Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.goldPrimary.withValues(alpha: 0.12),
                border: Border.all(
                  color: AppTheme.goldPrimary.withValues(alpha: 0.30),
                  width: 0.8,
                ),
              ),
              child: const Icon(
                Icons.volunteer_activism_rounded,
                size: 19,
                color: AppTheme.goldWarm,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'إهداء ثواب الأعمال',
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'صلة روحية ونورٌ يُهدى لأهل القبور',
                    style: GoogleFonts.cairo(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppTheme.textElevated,
                    ),
                  ),
                ],
              ),
            ),
            // Link to full Mercy Register screen
            Semantics(
              button: true,
              label: 'الانتقال إلى سجل الرحمة',
              child: InkWell(
                onTap: () => context.push('/mercy-register'),
                borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                child: Container(
                  constraints: const BoxConstraints(
                    minHeight: AppTheme.minTouchTarget,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'السجل',
                        style: GoogleFonts.cairo(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.goldWarm,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 11,
                        color: AppTheme.goldWarm,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: AppTheme.sp16),

        // ── 2. Recipient Banner (من يُهدى له الثواب) ──
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.bgSurface.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            border: Border.all(
              color: AppTheme.borderSubtle,
              width: 0.8,
            ),
          ),
          child: Row(
            children: [
              // Avatar
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.bgSecondary,
                  border: Border.all(
                    color: AppTheme.goldPrimary.withValues(alpha: 0.25),
                    width: 0.8,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  recipientName.isNotEmpty ? recipientName[0] : 'ع',
                  style: GoogleFonts.cairo(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.goldWarm,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipientName,
                      style: GoogleFonts.cairo(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      recipientSubtitle,
                      style: GoogleFonts.cairo(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppTheme.textMutedPremium,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Change recipient chip
              Semantics(
                button: true,
                label: 'تغيير المهدى له الثواب',
                child: InkWell(
                  onTap: () => _showRecipientPickerSheet(context, memorials),
                  borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                  child: Container(
                    constraints: const BoxConstraints(
                      minHeight: AppTheme.minTouchTarget,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.goldPrimary.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                      border: Border.all(
                        color: AppTheme.goldPrimary.withValues(alpha: 0.20),
                        width: 0.8,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'تغيير',
                          style: GoogleFonts.cairo(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.goldBright,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.swap_vert_rounded,
                          size: 14,
                          color: AppTheme.goldBright,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppTheme.sp16),

        // ── 3. Action Chips: Clear Spiritual Deeds ──
        Text(
          'اختر العمل الصالح للإهداء:',
          style: GoogleFonts.cairo(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.textElevated,
          ),
        ),
        const SizedBox(height: AppTheme.sp8),

        LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 340;
            return Row(
              children: [
                Expanded(
                  child: _DeedActionChip(
                    icon: Icons.menu_book_rounded,
                    title: 'الفاتحة',
                    subtitle: isNarrow ? null : 'تلاوة مباركة',
                    onTap: () => _handleDedicateFatiha(
                      context,
                      activeMemorial,
                      recipientName,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _DeedActionChip(
                    icon: Icons.spa_rounded,
                    title: 'تسبيح',
                    subtitle: isNarrow ? null : 'ذكر واستغفار',
                    onTap: () => _handleDedicateTasbeeh(
                      activeMemorial,
                      recipientName,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _DeedActionChip(
                    icon: Icons.favorite_rounded,
                    title: 'دعاء',
                    subtitle: isNarrow ? null : 'مأثور للميت',
                    onTap: () => _handleDedicateDua(
                      context,
                      activeMemorial,
                      recipientName,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Completed & Confirmation State
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildCompletedState(String recipientName) {
    return Container(
      key: const ValueKey<String>('completed_state'),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.goldPrimary.withValues(alpha: 0.15),
              border: Border.all(
                color: AppTheme.goldPrimary.withValues(alpha: 0.40),
                width: 1.0,
              ),
            ),
            child: const Icon(
              Icons.check_rounded,
              size: 26,
              color: AppTheme.goldBright,
            ),
          ),
          const SizedBox(height: AppTheme.sp12),
          Text(
            'تقبّل الله طاعتكم وأصل الثواب',
            style: GoogleFonts.cairo(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            'أُهدي ثواب $_completedDeedName لروح $recipientName',
            style: GoogleFonts.cairo(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppTheme.goldWarm,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppTheme.sp16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Semantics(
                button: true,
                label: 'إهداء عمل صالح آخر',
                child: TextButton.icon(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    setState(() => _isCompleted = false);
                  },
                  icon: const Icon(
                    Icons.replay_rounded,
                    size: 16,
                    color: AppTheme.goldBright,
                  ),
                  label: Text(
                    'إهداء عمل آخر',
                    style: GoogleFonts.cairo(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.goldBright,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    minimumSize: const Size(48, AppTheme.minTouchTarget),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Semantics(
                button: true,
                label: 'فتح سجل الرحمة الكامل',
                child: OutlinedButton(
                  onPressed: () => context.push('/mercy-register'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(48, AppTheme.minTouchTarget),
                    side: BorderSide(
                      color: AppTheme.borderGold,
                      width: 0.8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  child: Text(
                    'عرض السجل',
                    style: GoogleFonts.cairo(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textElevated,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Actions Handling
  // ═══════════════════════════════════════════════════════════════════════════

  void _recordDedication({
    required Memorial? memorial,
    required RewardType type,
    required String deedName,
  }) async {
    if (_isSubmitting) return;
    _isSubmitting = true;

    HapticFeedback.mediumImpact();

    // If dedicated to a registered memorial, persist to database
    if (memorial != null) {
      try {
        final repoAsync = ref.read(memorialRepositoryProvider);
        final repo = repoAsync.asData?.value;
        if (repo != null) {
          final reward = Reward.create(
            memorialId: memorial.id,
            type: type,
            count: 1,
          );
          await repo.addReward(reward);
        }
      } catch (e) {
        debugPrint('[ThawabDedication] Failed to add reward: $e');
      }
    }

    _isSubmitting = false;
    if (mounted) {
      setState(() {
        _completedDeedName = deedName;
        _isCompleted = true;
      });
    }
  }

  void _handleDedicateTasbeeh(Memorial? memorial, String recipientName) {
    _recordDedication(
      memorial: memorial,
      type: RewardType.tasbeeh,
      deedName: 'التسبيح والاستغفار',
    );
  }

  void _handleDedicateFatiha(
    BuildContext context,
    Memorial? memorial,
    String recipientName,
  ) {
    HapticFeedback.selectionClick();
    showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _FatihaRecitationSheet(
        recipientName: recipientName,
        ayahs: _fatihaAyahs,
      ),
    ).then((confirmed) {
      if (confirmed == true && mounted) {
        _recordDedication(
          memorial: memorial,
          type: RewardType.surahRecitation,
          deedName: 'سورة الفاتحة المباركة',
        );
      }
    });
  }

  void _handleDedicateDua(
    BuildContext context,
    Memorial? memorial,
    String recipientName,
  ) {
    HapticFeedback.selectionClick();
    showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _DuaRecitationSheet(
        recipientName: recipientName,
        duaText: _transmittedDua,
      ),
    ).then((confirmed) {
      if (confirmed == true && mounted) {
        _recordDedication(
          memorial: memorial,
          type: RewardType.dua,
          deedName: 'الدعاء المأثور',
        );
      }
    });
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Recipient Picker Bottom Sheet
  // ═══════════════════════════════════════════════════════════════════════════

  void _showRecipientPickerSheet(
    BuildContext context,
    List<Memorial> memorials,
  ) {
    HapticFeedback.selectionClick();
    showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _RecipientPickerSheet(
        memorials: memorials,
        selectedId: _selectedMemorialId,
        universalName: _universalName,
        universalSubtitle: _universalSubtitle,
      ),
    ).then((selectedId) {
      if (selectedId != null && mounted) {
        setState(() {
          // 'universal' maps to null for universal deceased
          _selectedMemorialId = selectedId == 'universal' ? null : selectedId;
          _isCompleted = false;
        });
      }
    });
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// Sub-component: Action Chip Button
// ═════════════════════════════════════════════════════════════════════════════

class _DeedActionChip extends StatefulWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _DeedActionChip({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  State<_DeedActionChip> createState() => _DeedActionChipState();
}

class _DeedActionChipState extends State<_DeedActionChip> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'إهداء ${widget.title}',
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeInOut,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            onTapDown: (_) => setState(() => _isPressed = true),
            onTapUp: (_) => setState(() => _isPressed = false),
            onTapCancel: () => setState(() => _isPressed = false),
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            splashColor: AppTheme.goldPrimary.withValues(alpha: 0.12),
            highlightColor: AppTheme.goldPrimary.withValues(alpha: 0.05),
            child: Container(
              constraints: const BoxConstraints(
                minHeight: AppTheme.minTouchTarget,
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                color: AppTheme.bgSurface.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                border: Border.all(
                  color: AppTheme.borderGold,
                  width: 0.8,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    widget.icon,
                    size: 20,
                    color: AppTheme.goldWarm,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.title,
                    style: GoogleFonts.cairo(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (widget.subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      widget.subtitle!,
                      style: GoogleFonts.cairo(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppTheme.textMutedPremium,
                        height: 1.1,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// Bottom Sheet: Surat Al-Fatihah Recitation
// ═════════════════════════════════════════════════════════════════════════════

class _FatihaRecitationSheet extends StatelessWidget {
  final String recipientName;
  final List<String> ayahs;

  const _FatihaRecitationSheet({
    required this.recipientName,
    required this.ayahs,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.viewPaddingOf(context).bottom;

    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTheme.cardRadius),
        ),
      ),
      padding: EdgeInsets.fromLTRB(20, 16, 20, bottomPadding + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.textMutedPremium.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          Text(
            'سورة الفاتحة المباركة',
            style: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.goldWarm,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'تُهدى نوراً ورحمةً لروح $recipientName',
            style: GoogleFonts.cairo(
              fontSize: 13,
              color: AppTheme.textElevated,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          // Quranic Text Frame
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: BoxDecoration(
              color: AppTheme.bgPrimary.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              border: Border.all(
                color: AppTheme.borderGold,
                width: 0.8,
              ),
            ),
            child: Column(
              children: ayahs.map((ayah) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    ayah,
                    style: GoogleFonts.notoNaskhArabic(
                      fontSize: 17,
                      height: 2.0,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 24),

          // Confirmation button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.goldPrimary,
                foregroundColor: AppTheme.bgPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                ),
                elevation: 2,
              ),
              child: Text(
                'أهديتُ ثواب الفاتحة',
                style: GoogleFonts.cairo(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// Bottom Sheet: Transmitted Dua Recitation
// ═════════════════════════════════════════════════════════════════════════════

class _DuaRecitationSheet extends StatelessWidget {
  final String recipientName;
  final String duaText;

  const _DuaRecitationSheet({
    required this.recipientName,
    required this.duaText,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.viewPaddingOf(context).bottom;

    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTheme.cardRadius),
        ),
      ),
      padding: EdgeInsets.fromLTRB(20, 16, 20, bottomPadding + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.textMutedPremium.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'دعاء مأثور للمتوفى',
            style: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.goldWarm,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'ليُهدى ثوابه إلى $recipientName',
            style: GoogleFonts.cairo(
              fontSize: 13,
              color: AppTheme.textElevated,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
            decoration: BoxDecoration(
              color: AppTheme.bgPrimary.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              border: Border.all(
                color: AppTheme.borderGold,
                width: 0.8,
              ),
            ),
            child: Text(
              duaText,
              style: GoogleFonts.notoNaskhArabic(
                fontSize: 16,
                height: 2.1,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.goldPrimary,
                foregroundColor: AppTheme.bgPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                ),
                elevation: 2,
              ),
              child: Text(
                'أهديتُ ثواب الدعاء',
                style: GoogleFonts.cairo(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// Bottom Sheet: Recipient Selection
// ═════════════════════════════════════════════════════════════════════════════

class _RecipientPickerSheet extends StatelessWidget {
  final List<Memorial> memorials;
  final String? selectedId;
  final String universalName;
  final String universalSubtitle;

  const _RecipientPickerSheet({
    required this.memorials,
    required this.selectedId,
    required this.universalName,
    required this.universalSubtitle,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.viewPaddingOf(context).bottom;

    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTheme.cardRadius),
        ),
      ),
      padding: EdgeInsets.fromLTRB(20, 16, 20, bottomPadding + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.textMutedPremium.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'اختر من تُهدي له الثواب',
            style: GoogleFonts.cairo(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            'يمكنك الاختيار من سجلك الخاص أو لعامة موتى المؤمنين',
            style: GoogleFonts.cairo(
              fontSize: 12,
              color: AppTheme.textMutedPremium,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // 1. Universal Believers Option
          _buildRecipientTile(
            context: context,
            title: universalName,
            subtitle: universalSubtitle,
            isSelected: selectedId == null,
            onTap: () => Navigator.pop(context, 'universal'),
          ),

          // 2. User's Memorials List
          if (memorials.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Divider(color: AppTheme.borderSubtle, height: 1),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 220),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: memorials.length,
                separatorBuilder: (_, __) => const SizedBox(height: 6),
                itemBuilder: (ctx, i) {
                  final m = memorials[i];
                  return _buildRecipientTile(
                    context: context,
                    title: m.displayName,
                    subtitle:
                        'تاريخ الوفاة: ${m.dateOfDeath.year}/${m.dateOfDeath.month}/${m.dateOfDeath.day}',
                    isSelected: selectedId == m.id,
                    onTap: () => Navigator.pop(context, m.id),
                  );
                },
              ),
            ),
          ],

          const SizedBox(height: 12),

          // 3. Action to Add a new Memorial
          Semantics(
            button: true,
            label: 'إضافة فقيد جديد إلى سجل الرحمة',
            child: TextButton.icon(
              onPressed: () {
                Navigator.pop(context);
                context.push('/mercy-register/add');
              },
              icon: const Icon(
                Icons.add_circle_outline_rounded,
                size: 18,
                color: AppTheme.goldWarm,
              ),
              label: Text(
                'إضافة فقيد جديد إلى سجلي',
                style: GoogleFonts.cairo(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.goldWarm,
                ),
              ),
              style: TextButton.styleFrom(
                minimumSize: const Size(48, AppTheme.minTouchTarget),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipientTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: '$title - $subtitle',
      child: Material(
        color: isSelected
            ? AppTheme.goldPrimary.withValues(alpha: 0.12)
            : AppTheme.bgSurface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          child: Container(
            constraints: const BoxConstraints(
              minHeight: AppTheme.minTouchTarget,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              border: Border.all(
                color: isSelected ? AppTheme.goldPrimary : AppTheme.borderSubtle,
                width: isSelected ? 1.2 : 0.8,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isSelected
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked_rounded,
                  size: 20,
                  color: isSelected
                      ? AppTheme.goldWarm
                      : AppTheme.textMutedPremium,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.cairo(
                          fontSize: 14,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w600,
                          color: isSelected
                              ? AppTheme.goldWarm
                              : AppTheme.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: GoogleFonts.cairo(
                          fontSize: 12,
                          color: AppTheme.textMutedPremium,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

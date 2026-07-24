import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../theme/ds_components.dart';
import '../../widget_framework/framework.dart';
import 'providers/widget_studio_provider.dart';
import 'sections/live_preview.dart';
import 'sections/widget_type_selector.dart';
import 'sections/widget_size_selector.dart';
import 'sections/theme_selector.dart';
import 'sections/appearance_section.dart';
import 'sections/typography_section.dart';
import 'sections/layout_section.dart';
import 'sections/advanced_section.dart';
import 'sections/preset_management.dart';

/// The Widget Studio — premium customization control center.
///
/// Layout:
/// - Mobile (<900px): Full-width vertical scroll
///   [Preview] → [Type] → [Size] → [Theme] → [Appearance] → [Typography] → [Layout] → [Advanced] → [Presets] → [Apply]
/// - Desktop (>=900px): Split layout
///   Left: Sticky Preview (55%) | Right: Scrollable controls (45%)
class WidgetStudioScreen extends ConsumerStatefulWidget {
  const WidgetStudioScreen({super.key});

  @override
  ConsumerState<WidgetStudioScreen> createState() => _WidgetStudioScreenState();
}

class _WidgetStudioScreenState extends ConsumerState<WidgetStudioScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutCubic,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final studio = ref.watch(widgetStudioProvider);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth >= 900;

    return Scaffold(
      backgroundColor: AppTheme.bgPrimary,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: isDesktop
            ? _buildDesktopLayout(studio)
            : _buildMobileLayout(studio),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════
  // DESKTOP LAYOUT — Side-by-side
  // ════════════════════════════════════════════════════════════════════════

  Widget _buildDesktopLayout(WidgetStudioState studio) {
    return Row(
      children: [
        // ── Left: Preview (55%) ──
        SizedBox(
          width: 500,
          child: _buildPreviewPanel(studio),
        ),
        // ── Divider ──
        Container(
          width: 1,
          color: AppTheme.borderSubtle,
        ),
        // ── Right: Controls (45%) ──
        Expanded(
          child: Container(
            color: AppTheme.bgPrimary,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              physics: const BouncingScrollPhysics(),
              children: _buildControlChildren(studio),
            ),
          ),
        ),
      ],
    );
  }

  // ════════════════════════════════════════════════════════════════════════
  // MOBILE LAYOUT — Vertical scroll
  // ════════════════════════════════════════════════════════════════════════

  Widget _buildMobileLayout(WidgetStudioState studio) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        // ── App Bar ──
        SliverAppBar(
          pinned: true,
          expandedHeight: 0,
          backgroundColor: AppTheme.bgPrimary,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
            color: AppTheme.textPrimary,
            onPressed: () => context.pop(),
          ),
          title: Text(
            'Widget Studio',
            style: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          centerTitle: true,
          actions: [
            if (studio.isDirty)
              TextButton(
                onPressed: () => _showSaveDialog(context, ref),
                child: Text(
                  'Save',
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.goldPrimary,
                  ),
                ),
              ),
          ],
        ),
        // ── Preview ──
        SliverToBoxAdapter(
          child: _buildPreviewPanel(studio),
        ),
        // ── Controls ──
        SliverToBoxAdapter(
          child: _buildControlsPanel(studio),
        ),
        // ── Bottom Apply Button ──
        SliverToBoxAdapter(
          child: _buildApplyButton(studio),
        ),
        // ── Bottom Spacing ──
        const SliverToBoxAdapter(
          child: SizedBox(height: 40),
        ),
      ],
    );
  }

  // ════════════════════════════════════════════════════════════════════════
  // SHARED PANELS
  // ════════════════════════════════════════════════════════════════════════

  Widget _buildPreviewPanel(WidgetStudioState studio) {
    return Container(
      color: AppTheme.bgSecondary,
      child: Column(
        children: [
          // ── Preview Header ──
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 16,
                  decoration: BoxDecoration(
                    gradient: AppTheme.goldGradient,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Live Preview',
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const Spacer(),
                // ── Size Quick-Select ──
                _SizeChip(
                  size: studio.widgetSize,
                  onTap: () => _showSizeSheet(context, ref),
                ),
              ],
            ),
          ),
          // ── The Preview ──
          const LivePreview(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  List<Widget> _buildControlChildren(WidgetStudioState studio) {
    return [
      // ── Widget Type ──
      const WidgetTypeSelector(),
      const SizedBox(height: 24),
      // ── Size ──
      const WidgetSizeSelector(),
      const SizedBox(height: 24),
      // ── Theme ──
      const ThemeSelector(),
      const SizedBox(height: 24),
      // ── Appearance ──
      const AppearanceSection(),
      const SizedBox(height: 24),
      // ── Typography ──
      const TypographySection(),
      const SizedBox(height: 24),
      // ── Layout ──
      const LayoutSection(),
      const SizedBox(height: 24),
      // ── Advanced ──
      const AdvancedSection(),
      const SizedBox(height: 24),
      // ── Presets ──
      const PresetManagement(),
      const SizedBox(height: 24),
      // ── Apply Button ──
      _buildApplyButton(studio),
      const SizedBox(height: 40),
    ];
  }

  Widget _buildControlsPanel(WidgetStudioState studio) {
    return Container(
      color: AppTheme.bgPrimary,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: _buildControlChildren(studio),
      ),
    );
  }

  Widget _buildApplyButton(WidgetStudioState studio) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GoldButton(
        label: 'Apply to Widget',
        icon: Icons.check_rounded,
        onTap: () async {
          await ConfigAdapter.save(studio.config);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Widget settings applied!',
                  style: GoogleFonts.cairo(),
                ),
                backgroundColor: AppTheme.cardBase,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
            ref.read(widgetStudioProvider.notifier).markClean();
          }
        },
      ),
    );
  }

  void _showSaveDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => IslamicDialog(
        title: 'Save Preset',
        content: TextField(
          controller: controller,
          autofocus: true,
          style: GoogleFonts.cairo(color: AppTheme.textPrimary),
          decoration: InputDecoration(
            hintText: 'Preset name...',
            hintStyle: GoogleFonts.cairo(color: AppTheme.textMuted),
            filled: true,
            fillColor: AppTheme.bgSurface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.borderGold),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.borderGold),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.goldPrimary),
            ),
          ),
          onSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              ref.read(widgetStudioProvider.notifier).savePreset(value.trim());
              Navigator.of(ctx).pop();
            }
          },
        ),
        confirmLabel: 'Save',
        onConfirm: () {
          if (controller.text.trim().isNotEmpty) {
            ref
                .read(widgetStudioProvider.notifier)
                .savePreset(controller.text.trim());
          }
        },
      ),
    );
  }

  void _showSizeSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: AppTheme.bgCard,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.textMuted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Widget Size',
              style: GoogleFonts.cairo(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            const WidgetSizeSelector(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _SizeChip extends StatelessWidget {
  final WidgetSize size;
  final VoidCallback onTap;

  const _SizeChip({required this.size, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: AppTheme.bgSurface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.borderSubtle),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              size.name.toUpperCase(),
              style: GoogleFonts.cairo(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppTheme.goldPrimary,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 14,
              color: AppTheme.goldPrimary,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../../theme/app_theme.dart';
import '../../../../quran_audio/providers/quran_audio_providers.dart';
import 'reciter_selector_sheet.dart';
import 'reading_settings_sheet.dart';
import 'download_manager_sheet.dart';

class PremiumFloatingTools extends ConsumerStatefulWidget {
  final int currentSurahNumber;

  const PremiumFloatingTools({
    super.key,
    required this.currentSurahNumber,
  });

  @override
  ConsumerState<PremiumFloatingTools> createState() =>
      _PremiumFloatingToolsState();
}

class _PremiumFloatingToolsState extends ConsumerState<PremiumFloatingTools>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<Offset> _slideAnim;
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _scaleAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    if (_expanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final audioState = ref.watch(audioPlayerNotifierProvider);
    final hasAudio = audioState.hasActivePlayback;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.translate(
              offset: _slideAnim.value * 20,
              child: Opacity(
                opacity: _controller.value,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildToolButton(
                      icon: Icons.headphones_rounded,
                      label: 'القارئ',
                      onTap: () {
                        _toggle();
                        _showReciterSheet();
                      },
                    ),
                    const SizedBox(height: 8),
                    _buildToolButton(
                      icon: Icons.tune_rounded,
                      label: 'الإعدادات',
                      onTap: () {
                        _toggle();
                        _showSettingsSheet();
                      },
                    ),
                    const SizedBox(height: 8),
                    _buildToolButton(
                      icon: Icons.download_rounded,
                      label: 'التحميلات',
                      onTap: () {
                        _toggle();
                        _showDownloadSheet();
                      },
                    ),
                    const SizedBox(height: 8),
                    if (hasAudio)
                      _buildToolButton(
                        icon: Icons.queue_music_rounded,
                        label: 'الشريط الكامل',
                        onTap: () {
                          _toggle();
                          context.push('/quran-audio/player');
                        },
                      ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            );
          },
        ),
        _buildMainFab(hasAudio, audioState),
      ],
    );
  }

  Widget _buildMainFab(bool hasAudio, AudioPlayerState audioState) {
    return GestureDetector(
      onTap: _toggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          gradient: _expanded
              ? const LinearGradient(
                  colors: [Color(0xFF3A3A3A), Color(0xFF2A2A2A)],
                )
              : AppTheme.goldGradient,
          borderRadius: BorderRadius.circular(_expanded ? 18 : 20),
          boxShadow: [
            BoxShadow(
              color: (_expanded ? Colors.black : AppTheme.goldPrimary)
                  .withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: AnimatedRotation(
          turns: _expanded ? 0.125 : 0,
          duration: const Duration(milliseconds: 250),
          child: Icon(
            _expanded ? Icons.close_rounded : Icons.tune_rounded,
            color: _expanded ? Colors.white : AppTheme.midnightNavy,
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildToolButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SlideTransition(
        position: _slideAnim,
        child: ScaleTransition(
          scale: _scaleAnim,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.bgCard.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppTheme.goldPrimary.withValues(alpha: 0.2),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 18, color: AppTheme.goldPrimary),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: GoogleFonts.notoKufiArabic(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showReciterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ReciterSelectorSheet(
        currentSurahNumber: widget.currentSurahNumber,
      ),
    );
  }

  void _showSettingsSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ReadingSettingsSheet(),
    );
  }

  void _showDownloadSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DownloadManagerSheet(
        currentSurahNumber: widget.currentSurahNumber,
      ),
    );
  }
}


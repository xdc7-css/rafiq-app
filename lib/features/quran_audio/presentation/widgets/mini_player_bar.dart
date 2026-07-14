import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../theme/app_theme.dart';
import '../../providers/quran_audio_providers.dart';

class MiniPlayerBar extends ConsumerStatefulWidget {
  const MiniPlayerBar({super.key});

  @override
  ConsumerState<MiniPlayerBar> createState() => _MiniPlayerBarState();
}

class _MiniPlayerBarState extends ConsumerState<MiniPlayerBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final playerState = ref.watch(audioPlayerNotifierProvider);

    if (!playerState.hasActivePlayback) {
      _slideController.reverse();
      return const SizedBox.shrink();
    }

    _slideController.forward();
    final w = MediaQuery.sizeOf(context).width;
    final elapsed = playerState.position;
    final total = playerState.duration;
    final progress = total.inMilliseconds > 0
        ? elapsed.inMilliseconds / total.inMilliseconds
        : 0.0;

    return SlideTransition(
      position: _slideAnimation,
      child: GestureDetector(
        onTap: () => context.push('/quran-audio/player'),
        child: Container(
          height: 64,
          margin: EdgeInsets.symmetric(horizontal: w < 360 ? 8 : 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.bgCard.withValues(alpha: 0.95),
                AppTheme.bgSurface.withValues(alpha: 0.95),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.borderGold, width: 0.5),
            boxShadow: [
              BoxShadow(
                color: AppTheme.shadowDark,
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
              BoxShadow(
                color: AppTheme.shadowGold,
                blurRadius: 12,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: AppTheme.goldGradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            '${playerState.currentSurahNumber}',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.bgPrimary,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              playerState.currentSurahName,
                              style: GoogleFonts.notoKufiArabic(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              playerState.currentReciter?.name ?? '',
                              style: GoogleFonts.notoKufiArabic(
                                fontSize: 10,
                                color: AppTheme.textMuted,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      if (playerState.isBuffering)
                        const Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppTheme.goldPrimary,
                            ),
                          ),
                        )
                      else
                        GestureDetector(
                          onTap: () {
                            ref.read(audioPlayerNotifierProvider.notifier).togglePlayPause();
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: AppTheme.goldPrimary.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              playerState.isPlaying
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              color: AppTheme.goldPrimary,
                              size: 24,
                            ),
                          ),
                        ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 2,
                    backgroundColor: AppTheme.goldPrimary.withValues(alpha: 0.08),
                    valueColor: const AlwaysStoppedAnimation(AppTheme.goldPrimary),
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

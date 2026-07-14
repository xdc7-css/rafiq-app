import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:share_plus/share_plus.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/ds_components.dart';
import '../../../services/time_formatter.dart';
import '../../../providers/settings_provider.dart';
import '../../../widgets/star_background.dart';
import '../data/models/quran_audio_models.dart';
import '../providers/quran_audio_providers.dart';

class FullPlayerScreen extends ConsumerStatefulWidget {
  const FullPlayerScreen({super.key});

  @override
  ConsumerState<FullPlayerScreen> createState() => _FullPlayerScreenState();
}

class _FullPlayerScreenState extends ConsumerState<FullPlayerScreen> {
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final state = ref.watch(audioPlayerNotifierProvider);
    final downloads = ref.watch(downloadsProvider);
    final favorites = ref.watch(audioFavoritesProvider);

    if (!state.hasActivePlayback && state.currentReciter == null) {
      return Scaffold(
        body: Stack(
          children: [
            const StarBackground(showParticles: false),
            SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.music_note_rounded, size: w < 360 ? 64 : 80, color: AppTheme.goldPrimary.withValues(alpha: 0.3)),
                    const SizedBox(height: 16),
                    Text(
                      'لم يتم تشغيل أي سورة',
                      style: GoogleFonts.notoKufiArabic(fontSize: 16, color: AppTheme.textMuted),
                    ),
                    SizedBox(height: w < 360 ? 18 : 24),
                    GoldButton(
                      label: 'اختيار قارئ',
                      onTap: () {
                        context.pop();
                        context.push('/quran-audio/reciters');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    final surahName = state.currentSurahName;
    final reciterName = state.currentReciter?.name ?? '';
    final moshafName = state.currentMoshaf?.name ?? '';
    final position = state.position;
    final duration = state.duration;
    final progress = duration.inMilliseconds > 0
        ? position.inMilliseconds / duration.inMilliseconds
        : 0.0;
    final isFav = favorites.isSurahFav(
      '${state.currentReciter?.id}_${state.currentSurahNumber}',
    );
    final isDown = downloads.isDownloaded(
      state.currentReciter?.id ?? 0,
      state.currentSurahNumber,
    );

    return Scaffold(
      body: Stack(
        children: [
          const StarBackground(showParticles: false),
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(state),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: w < 360 ? 16 : 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        _buildArtwork(state),
                        SizedBox(height: w < 360 ? 18 : 24),
                        _buildSurahInfo(surahName, reciterName, moshafName),
                        SizedBox(height: w < 360 ? 18 : 24),
                        _buildProgressSection(position, duration, progress),
                        SizedBox(height: w < 360 ? 18 : 24),
                        _buildMainControls(state),
                        const SizedBox(height: 20),
                        _buildSecondaryControls(state),
                        if (state.sleepTimerRemaining != null) ...[
                          const SizedBox(height: 16),
                          _buildSleepTimerBadge(),
                        ],
                        const SizedBox(height: 12),
                        _buildActionRow(isFav, isDown, state),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(AudioPlayerState state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.goldPrimary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.borderGold, width: 0.5),
              ),
              child: const Icon(Icons.keyboard_arrow_down_rounded, color: AppTheme.goldPrimary, size: 22),
            ),
          ),
          const Spacer(),
          Text(
            'مشغل القرآن',
            style: GoogleFonts.notoKufiArabic(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
          ),
          const Spacer(),
          GoldBadge(
            text: 'سورة ${state.currentSurahNumber}',
            icon: Icons.auto_stories_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildArtwork(AudioPlayerState state) {
    final w = MediaQuery.sizeOf(context).width;
    return Container(
      width: w < 360 ? 220 : 260,
      height: w < 360 ? 220 : 260,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.goldPrimary.withValues(alpha: 0.15),
            AppTheme.goldPrimary.withValues(alpha: 0.03),
            AppTheme.bgCard.withValues(alpha: 0.5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: AppTheme.borderGold, width: 0.5),
        boxShadow: [
          BoxShadow(color: AppTheme.shadowGold, blurRadius: 30, spreadRadius: 0),
          BoxShadow(color: AppTheme.shadowDark, blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppTheme.goldGradient,
            ),
            child: Center(
              child: Text(
                state.currentSurahNumber.toString(),
                style: GoogleFonts.inter(
                  fontSize: w < 360 ? 30 : 36,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.bgPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            surahName(state.currentSurahNumber),
            style: GoogleFonts.notoKufiArabic(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSurahInfo(String surah, String reciter, String moshaf) {
    final w = MediaQuery.sizeOf(context).width;
    return Column(
      children: [
        Text(
          surah,
          style: GoogleFonts.notoKufiArabic(
            fontSize: w < 360 ? 24 : 28,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          reciter,
          style: GoogleFonts.notoKufiArabic(
            fontSize: 16,
            color: AppTheme.goldPrimary,
          ),
        ),
        if (moshaf.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            moshaf,
            style: GoogleFonts.notoKufiArabic(
              fontSize: 12,
              color: AppTheme.textMuted,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildProgressSection(Duration position, Duration duration, double progress) {
    final posStr = _formatDuration(position);
    final durStr = _formatDuration(duration);

    return Column(
      children: [
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
            activeTrackColor: AppTheme.goldPrimary,
            inactiveTrackColor: AppTheme.goldPrimary.withValues(alpha: 0.1),
            thumbColor: AppTheme.goldPrimary,
            overlayColor: AppTheme.goldPrimary.withValues(alpha: 0.1),
          ),
          child: Slider(
            value: progress.clamp(0.0, 1.0),
            onChanged: (v) {
              final newPos = Duration(
                milliseconds: (v * duration.inMilliseconds).round(),
              );
              ref.read(audioPlayerNotifierProvider.notifier).seekTo(newPos);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(posStr, style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textMuted)),
              Text(durStr, style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textMuted)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMainControls(AudioPlayerState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _controlButton(
          Icons.skip_previous_rounded,
          () => ref.read(audioPlayerNotifierProvider.notifier).previousSurah(114),
          48,
        ),
        const SizedBox(width: 16),
        GestureDetector(
          onTap: () => ref.read(audioPlayerNotifierProvider.notifier).togglePlayPause(),
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              gradient: AppTheme.goldGradient,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: AppTheme.shadowGold, blurRadius: 20, spreadRadius: 0)],
            ),
            child: Icon(
              state.isBuffering
                  ? Icons.hourglass_top_rounded
                  : state.isPlaying
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
              color: AppTheme.bgPrimary,
              size: 36,
            ),
          ),
        ),
        const SizedBox(width: 16),
        _controlButton(
          Icons.skip_next_rounded,
          () => ref.read(audioPlayerNotifierProvider.notifier).nextSurah(114),
          48,
        ),
      ],
    );
  }

  Widget _buildSecondaryControls(AudioPlayerState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildSpeedButton(state.speed),
        _buildControlChip(
          state.loopMode == LoopMode.one
              ? Icons.repeat_one_rounded
              : state.loopMode == LoopMode.all
                  ? Icons.repeat_rounded
                  : Icons.repeat_rounded,
          state.loopMode != LoopMode.off,
          () {
            final next = state.loopMode == LoopMode.off
                ? LoopMode.one
                : state.loopMode == LoopMode.one
                    ? LoopMode.all
                    : LoopMode.off;
            ref.read(audioPlayerNotifierProvider.notifier).setLoopMode(next);
          },
        ),
        _buildControlChip(
          Icons.shuffle_rounded,
          state.shuffle,
          () => ref.read(audioPlayerNotifierProvider.notifier).toggleShuffle(),
        ),
        _buildControlChip(
          Icons.queue_music_rounded,
          false,
          () => context.push('/quran-audio/queue'),
        ),
        _buildControlChip(
          Icons.timer_rounded,
          state.sleepTimerRemaining != null,
          () => _showSleepTimerSheet(),
        ),
      ],
    );
  }

  Widget _buildActionRow(bool isFav, bool isDown, AudioPlayerState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _actionButton(
          isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          isFav ? Colors.redAccent : AppTheme.goldPrimary,
          () => ref.read(audioFavoritesProvider.notifier).toggleSurah(
            '${state.currentReciter?.id}_${state.currentSurahNumber}',
          ),
        ),
        _actionButton(
          isDown ? Icons.download_done_rounded : Icons.download_rounded,
          AppTheme.goldPrimary,
          () {
            if (!isDown) {
              final url = state.currentMoshaf?.audioUrl(state.currentSurahNumber) ?? '';
              ref.read(downloadsProvider.notifier).download(
                state.currentReciter?.id ?? 0,
                state.currentSurahNumber,
                url,
              );
            }
          },
        ),
        _actionButton(
          Icons.share_rounded,
          AppTheme.goldPrimary,
          () {
            final text = 'القرآن الكريم - ${state.currentSurahName}\n'
                '${state.currentReciter?.name ?? ''}'
                '\n\nتمت المشاركة من التطبيق الإسلامي';
            Share.share(text);
          },
        ),
      ],
    );
  }

  Widget _buildSpeedButton(double speed) {
    return GestureDetector(
      onTap: () {
        final speeds = [0.75, 1.0, 1.25, 1.5, 2.0];
        final idx = speeds.indexOf(speed);
        final next = speeds[(idx + 1) % speeds.length];
        ref.read(audioPlayerNotifierProvider.notifier).setSpeed(next);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppTheme.goldPrimary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.borderGold, width: 0.5),
        ),
        child: Text(
          '${speed}x',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppTheme.goldPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildControlChip(IconData icon, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: active
              ? AppTheme.goldPrimary.withValues(alpha: 0.2)
              : AppTheme.goldPrimary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: active
                ? AppTheme.goldPrimary.withValues(alpha: 0.3)
                : AppTheme.borderGold,
            width: 0.5,
          ),
        ),
        child: Icon(
          icon,
          color: active ? AppTheme.goldPrimary : AppTheme.textMuted,
          size: 22,
        ),
      ),
    );
  }

  Widget _controlButton(IconData icon, VoidCallback onTap, double size) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppTheme.goldPrimary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(size * 0.4),
        ),
        child: Icon(icon, color: AppTheme.goldPrimary, size: size * 0.45),
      ),
    );
  }

  Widget _actionButton(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppTheme.bgCard.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.borderGold, width: 0.5),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
    );
  }

  Widget _buildSleepTimerBadge() {
    final remaining = ref.read(audioPlayerNotifierProvider).sleepTimerRemaining;
    if (remaining == null) return const SizedBox.shrink();
    return GestureDetector(
      onTap: () => ref.read(audioPlayerNotifierProvider.notifier).cancelSleepTimer(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppTheme.goldPrimary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.borderGold),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.timer_rounded, size: 16, color: AppTheme.goldPrimary),
            const SizedBox(width: 8),
            Text(
              'مؤقت النوم: ${_formatDuration(remaining)}',
              style: GoogleFonts.notoKufiArabic(fontSize: 12, color: AppTheme.goldPrimary),
            ),
            const SizedBox(width: 8),
            Icon(Icons.close_rounded, size: 14, color: AppTheme.textMuted),
          ],
        ),
      ),
    );
  }

  void _showSleepTimerSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.bgSurface.withValues(alpha: 0.95),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          border: Border(top: BorderSide(color: AppTheme.borderGold, width: 1)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: AppTheme.goldPrimary.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 20),
            Text('مؤقت النوم', style: GoogleFonts.notoKufiArabic(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
            const SizedBox(height: 20),
            _sleepTimerOption('١٥ دقيقة', const Duration(minutes: 15)),
            _sleepTimerOption('٣٠ دقيقة', const Duration(minutes: 30)),
            _sleepTimerOption('٦٠ دقيقة', const Duration(minutes: 60)),
            _sleepTimerOption('مخصص', const Duration(minutes: 90)),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('إلغاء', style: GoogleFonts.notoKufiArabic(color: AppTheme.textMuted)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sleepTimerOption(String label, Duration duration) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: SizedBox(
        width: double.infinity,
        child: GoldButton(
          label: label,
          onTap: () {
            ref.read(audioPlayerNotifierProvider.notifier).startSleepTimer(duration);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    final numerals = ref.read(settingsNotifierProvider).numeralSystem;
    return TimeFormatter.formatDuration(d, numerals: numerals);
  }
}

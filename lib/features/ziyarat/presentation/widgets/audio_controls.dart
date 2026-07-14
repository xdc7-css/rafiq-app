import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../providers/settings_provider.dart';
import '../../../../services/time_formatter.dart';
import '../../../../theme/app_theme.dart';
import '../providers/audio_provider.dart';

class AudioControls extends ConsumerWidget {
  const AudioControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audio = ref.watch(audioPlayerProvider);
    final numerals = ref.watch(settingsNotifierProvider).numeralSystem;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.bgCard.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderGold),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: AppTheme.goldPrimary,
              inactiveTrackColor: AppTheme.goldPrimary.withValues(alpha: 0.2),
              thumbColor: AppTheme.goldPrimary,
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
            ),
            child: Slider(
              value: audio.progress.clamp(0.0, 1.0),
              onChanged: (v) => ref.read(audioPlayerProvider.notifier).seek(v * audio.duration),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              children: [
                Text(TimeFormatter.formatDuration(
                    Duration(seconds: audio.position.round()), numerals: numerals),
                    style: GoogleFonts.notoKufiArabic(fontSize: 11, color: AppTheme.textMuted)),
                const Spacer(),
                Text(TimeFormatter.formatDuration(
                    Duration(seconds: audio.duration.round()), numerals: numerals),
                    style: GoogleFonts.notoKufiArabic(fontSize: 11, color: AppTheme.textMuted)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _SpeedButton(speed: 0.5),
              const SizedBox(width: 8),
              _SpeedButton(speed: 1.0),
              const SizedBox(width: 8),
              _SpeedButton(speed: 1.5),
              const SizedBox(width: 8),
              _SpeedButton(speed: 2.0),
              const Spacer(),
              IconButton(
                icon: Icon(Icons.skip_previous_rounded, color: AppTheme.textPrimary, size: 28),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.goldPrimary.withValues(alpha: 0.15),
                ),
                child: IconButton(
                  icon: Icon(
                    audio.state == PlaybackState.playing
                        ? Icons.pause_circle_filled_rounded
                        : Icons.play_circle_filled_rounded,
                    color: AppTheme.goldPrimary,
                    size: 48,
                  ),
                  onPressed: () => ref.read(audioPlayerProvider.notifier).togglePlayPause(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(Icons.skip_next_rounded, color: AppTheme.textPrimary, size: 28),
                onPressed: () {},
              ),
              const Spacer(),
              IconButton(
                icon: Icon(
                  audio.isDownloaded ? Icons.download_done : Icons.download_rounded,
                  color: audio.isDownloaded ? AppTheme.goldPrimary : AppTheme.textMuted,
                  size: 20,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SpeedButton extends ConsumerWidget {
  final double speed;
  const _SpeedButton({required this.speed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSpeed = ref.watch(audioPlayerProvider.select((s) => s.speed));
    final isActive = currentSpeed == speed;
    return GestureDetector(
      onTap: () => ref.read(audioPlayerProvider.notifier).setSpeed(speed),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.goldPrimary.withValues(alpha: 0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isActive ? AppTheme.goldPrimary.withValues(alpha: 0.4) : AppTheme.borderColor,
          ),
        ),
        child: Text(
          '${speed}x',
          style: GoogleFonts.notoKufiArabic(
            fontSize: 11,
            color: isActive ? AppTheme.goldPrimary : AppTheme.textMuted,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

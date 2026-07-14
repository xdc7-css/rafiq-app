import 'package:flutter_riverpod/flutter_riverpod.dart';

enum PlaybackState { idle, playing, paused, loading }

class AudioPlayerState {
  final PlaybackState state;
  final double position;
  final double duration;
  final double speed;
  final bool isDownloaded;

  const AudioPlayerState({
    this.state = PlaybackState.idle,
    this.position = 0,
    this.duration = 0,
    this.speed = 1.0,
    this.isDownloaded = false,
  });

  AudioPlayerState copyWith({
    PlaybackState? state,
    double? position,
    double? duration,
    double? speed,
    bool? isDownloaded,
  }) {
    return AudioPlayerState(
      state: state ?? this.state,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      speed: speed ?? this.speed,
      isDownloaded: isDownloaded ?? this.isDownloaded,
    );
  }

  double get progress => duration > 0 ? position / duration : 0;
}

class AudioPlayerNotifier extends StateNotifier<AudioPlayerState> {
  AudioPlayerNotifier() : super(const AudioPlayerState());

  void play() {
    state = state.copyWith(state: PlaybackState.playing);
  }

  void pause() {
    state = state.copyWith(state: PlaybackState.paused);
  }

  void togglePlayPause() {
    if (state.state == PlaybackState.playing) {
      pause();
    } else {
      play();
    }
  }

  void seek(double pos) {
    state = state.copyWith(position: pos.clamp(0, state.duration));
  }

  void setDuration(double dur) {
    state = state.copyWith(duration: dur);
  }

  void setSpeed(double speed) {
    state = state.copyWith(speed: speed.clamp(0.5, 2.0));
  }

  void setDownloaded(bool downloaded) {
    state = state.copyWith(isDownloaded: downloaded);
  }

  void stop() {
    state = const AudioPlayerState();
  }
}

final audioPlayerProvider = StateNotifierProvider<AudioPlayerNotifier, AudioPlayerState>((ref) {
  return AudioPlayerNotifier();
});

enum ReadingMode { normal, night, focus, large }

final readingModeProvider = StateProvider<ReadingMode>((ref) => ReadingMode.normal);

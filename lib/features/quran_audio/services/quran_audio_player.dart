import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'quran_audio_handler.dart';
import '../data/models/quran_audio_models.dart';
import '../data/models/persisted_playback_state.dart';

class QuranAudioPlayer {
  final QuranAudioHandler _handler;

  QuranAudioPlayer({QuranAudioHandler? handler})
      : _handler = handler ?? QuranAudioHandler.instance;

  QuranAudioHandler get handler => _handler;

  Stream<PlayerState> get playerStateStream => _handler.playerStateStream;
  Stream<Duration> get positionStream => _handler.positionStream;
  Stream<Duration?> get durationStream => _handler.durationStream;
  Stream<LoopMode> get loopModeStream => _handler.player.loopModeStream;
  Stream<double> get speedStream => _handler.player.speedStream;
  ProcessingState get processingState => _handler.processingState;
  PlayerState? get currentState => _handler.player.playerState;
  LoopMode get currentLoopMode => _handler.loopMode;
  double get currentSpeed => _handler.speed;

  Future<void> init() async {}

  Future<void> play({
    required QuranReciter reciter,
    required Moshaf moshaf,
    required int surahNumber,
    String? localPath,
  }) async {
    if (localPath != null) {
      await _handler.setSurah(
        reciter: reciter,
        moshaf: moshaf,
        surahNumber: surahNumber,
        localPath: localPath,
      );
    } else {
      await _handler.setSurah(
        reciter: reciter,
        moshaf: moshaf,
        surahNumber: surahNumber,
      );
    }
  }

  Future<void> playQueue({
    required QuranReciter reciter,
    required Moshaf moshaf,
    required List<int> surahNumbers,
    required int startIndex,
  }) async {
    await _handler.setQueue(
      reciter: reciter,
      moshaf: moshaf,
      surahNumbers: surahNumbers,
      startIndex: startIndex,
    );
  }

  Future<void> restoreFromState(PersistedPlaybackState state) async {
    await _handler.restoreFromState(state);
  }

  Future<void> pause() async => _handler.pause();
  Future<void> resume() async => _handler.play();
  Future<void> stop() async => _handler.stop();
  Future<void> seek(Duration position) async => _handler.seek(position);
  Future<void> skipToNext() async => _handler.skipToNext();
  Future<void> skipToPrevious() async => _handler.skipToPrevious();
  Future<void> skipToQueueItem(int index) async =>
      _handler.skipToQueueItem(index);

  Future<void> setSpeed(double speed) async => _handler.setSpeed(speed);
  Future<void> setLoopMode(LoopMode mode) async => _handler.setLoopMode(mode);

  Future<void> addToQueue(QueueItem item, {required bool playNext}) async =>
      _handler.addToQueue(item, playNext: playNext);
  Future<void> removeFromQueue(int index) async =>
      _handler.removeFromQueue(index);
  Future<void> moveInQueue(int from, int to) async =>
      _handler.moveInQueue(from, to);
  Future<void> clearQueue() async => _handler.clearQueue();

  List<MediaItem> get currentQueue => _handler.queue.value;
  int? get currentIndex => _handler.currentIndex;
  MediaItem? get currentMediaItem => _handler.mediaItem.value;

  QuranReciter? get currentReciter => _handler.currentReciter;
  Moshaf? get currentMoshaf => _handler.currentMoshaf;
  List<QueueItem> get persistableQueue => _handler.persistableQueue;

  void dispose() {}
}

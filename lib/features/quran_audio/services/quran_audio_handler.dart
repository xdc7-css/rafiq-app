import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';
import '../data/models/quran_audio_models.dart';
import '../data/models/persisted_playback_state.dart';

class QuranAudioHandler extends BaseAudioHandler
    with QueueHandler, SeekHandler {
  static QuranAudioHandler? _instance;
  final AudioPlayer _player = AudioPlayer();
  final Map<String, MediaItem> _mediaItemCache = {};

  AudioPlayer get player => _player;

  static QuranAudioHandler get instance {
    assert(_instance != null,
        'QuranAudioHandler.instance called before AudioService.init()');
    return _instance!;
  }

  static bool get isInitialized => _instance != null;

  StreamSubscription<PlayerState>? _stateSub;
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<Duration?>? _durationSub;
  StreamSubscription<int?>? _indexSub;
  StreamSubscription<ProcessingState>? _processingSub;
  StreamSubscription<AudioInterruptionEvent>? _interruptionSub;

  int _retryCount = 0;
  static const int _maxRetries = 3;
  static const Duration _retryBaseDelay = Duration(seconds: 1);

  QuranReciter? _currentReciter;
  Moshaf? _currentMoshaf;
  List<QueueItem> _persistableQueue = [];

  QuranReciter? get currentReciter => _currentReciter;
  Moshaf? get currentMoshaf => _currentMoshaf;
  List<QueueItem> get persistableQueue => _persistableQueue;

  QuranAudioHandler() {
    _instance = this;
    _init();
  }

  Future<void> _init() async {
    if (!kIsWeb) {
      try {
        final session = await AudioSession.instance;
        await session.configure(const AudioSessionConfiguration(
          avAudioSessionCategory: AVAudioSessionCategory.playback,
          avAudioSessionCategoryOptions:
              AVAudioSessionCategoryOptions.mixWithOthers,
          avAudioSessionMode: AVAudioSessionMode.defaultMode,
          avAudioSessionRouteSharingPolicy:
              AVAudioSessionRouteSharingPolicy.defaultPolicy,
          avAudioSessionSetActiveOptions:
              AVAudioSessionSetActiveOptions.notifyOthersOnDeactivation,
          androidAudioAttributes: AndroidAudioAttributes(
            contentType: AndroidAudioContentType.music,
            usage: AndroidAudioUsage.media,
          ),
          androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
          androidWillPauseWhenDucked: true,
        ));

        _interruptionSub = session.interruptionEventStream.listen((event) {
          if (event.begin) {
            switch (event.type) {
              case AudioInterruptionType.duck:
                _player.setSpeed(max(_player.speed * 0.5, 0.3));
                break;
              case AudioInterruptionType.pause:
              case AudioInterruptionType.unknown:
                _player.pause();
                break;
            }
          } else {
            switch (event.type) {
              case AudioInterruptionType.duck:
                _player.setSpeed(1.0);
                break;
              case AudioInterruptionType.pause:
                _player.play();
                break;
              case AudioInterruptionType.unknown:
                break;
            }
          }
        });

        session.becomingNoisyEventStream.listen((_) {
          _player.pause();
        });
      } catch (e) {
        debugPrint('[QuranAudioHandler] audio_session init failed: $e');
      }
    }

    _stateSub = _player.playerStateStream.listen((playerState) {
      final playing = playerState.playing;
      playbackState.add(playbackState.value.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.stop,
          MediaControl.skipToNext,
        ],
        systemActions: const {
          MediaAction.seek,
          MediaAction.seekForward,
          MediaAction.seekBackward,
        },
        androidCompactActionIndices: const [0, 1, 3],
        processingState: _mapProcessingState(_player.processingState),
        playing: playing,
        updatePosition: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
        queueIndex: _player.currentIndex,
      ));
    });

    _positionSub = _player.positionStream.listen((pos) {
      final current = playbackState.value;
      playbackState.add(current.copyWith(updatePosition: pos));
    });

    _durationSub = _player.durationStream.listen((dur) {
      if (dur != null && _player.currentIndex != null) {
        final idx = _player.currentIndex!;
        if (idx < queue.value.length) {
          final old = queue.value[idx];
          final updated = old.copyWith(duration: dur);
          queue.value[idx] = updated;
          mediaItem.add(updated);
          _mediaItemCache[old.id] = updated;
        }
      }
    });

    _indexSub = _player.currentIndexStream.listen((idx) {
      if (idx != null && idx < queue.value.length) {
        final item = queue.value[idx];
        final surahNum = item.extras?['surahNumber'] as int? ?? 0;
        debugPrint('[QuranAudioHandler] CURRENT SURAH: $surahNum');
        mediaItem.add(item);
      }
    });

    _processingSub = _player.processingStateStream.listen((state) async {
      debugPrint('[QuranAudioHandler] PROCESSING STATE: $state');
      if (state == ProcessingState.completed) {
        playbackState.add(playbackState.value.copyWith(
          processingState: AudioProcessingState.completed,
          playing: false,
        ));
      } else if (state == ProcessingState.buffering) {
        _retryCount = 0;
      }
    });

    _player.playbackEventStream.listen(
      (_) {
        _retryCount = 0;
      },
      onError: (Object e, StackTrace st) async {
        if (e is PlayerException) {
          await _handlePlaybackError(e);
        }
      },
    );
  }

  Future<void> _handlePlaybackError(PlayerException error) async {
    if (_retryCount >= _maxRetries) return;
    _retryCount++;
    final delay = _retryBaseDelay * _retryCount;
    await Future.delayed(delay);
    if (_player.processingState != ProcessingState.idle && _player.playing) {
      await _player.play();
    }
  }

  AudioProcessingState _mapProcessingState(ProcessingState state) {
    switch (state) {
      case ProcessingState.idle:
        return AudioProcessingState.idle;
      case ProcessingState.loading:
        return AudioProcessingState.loading;
      case ProcessingState.buffering:
        return AudioProcessingState.buffering;
      case ProcessingState.ready:
        return AudioProcessingState.ready;
      case ProcessingState.completed:
        return AudioProcessingState.completed;
    }
  }

  MediaItem _buildMediaItem({
    required int surahNumber,
    required String surahName,
    required String reciterName,
    required String moshafName,
    required String audioUrl,
    required String reciterId,
    required String moshafId,
    String? artUri,
  }) {
    final id = '${reciterId}_${moshafId}_$surahNumber';
    if (_mediaItemCache.containsKey(id)) {
      return _mediaItemCache[id]!;
    }
    final item = MediaItem(
      id: id,
      album: '$reciterName — $moshafName',
      title: surahName,
      artist: reciterName,
      duration: _player.duration,
      artUri: artUri != null ? Uri.parse(artUri) : null,
      extras: {
        'surahNumber': surahNumber,
        'surahName': surahName,
        'reciterId': reciterId,
        'moshafId': moshafId,
        'reciterName': reciterName,
        'moshafName': moshafName,
        'audioUrl': audioUrl,
      },
    );
    _mediaItemCache[id] = item;
    return item;
  }

  Future<void> setSurah({
    required QuranReciter reciter,
    required Moshaf moshaf,
    required int surahNumber,
    String? localPath,
  }) async {
    debugPrint('[QuranAudioHandler] SET SURAH: reciter=${reciter.id} surah=$surahNumber localPath=$localPath');
    _currentReciter = reciter;
    _currentMoshaf = moshaf;

    final url = localPath ?? moshaf.audioUrl(surahNumber);
    final name = surahName(surahNumber);
    final item = _buildMediaItem(
      surahNumber: surahNumber,
      surahName: name,
      reciterName: reciter.name,
      moshafName: moshaf.name,
      audioUrl: moshaf.audioUrl(surahNumber),
      reciterId: reciter.id.toString(),
      moshafId: moshaf.id.toString(),
    );

    _persistableQueue = [
      QueueItem(
        surahNumber: surahNumber,
        surahName: name,
        audioUrl: moshaf.audioUrl(surahNumber),
        localPath: localPath,
      ),
    ];

    debugPrint('[QuranAudioHandler] STOP before setSurah');
    await _player.stop();
    debugPrint('[QuranAudioHandler] SET AUDIO SOURCE: $url');
    await _player.setAudioSource(
      AudioSource.uri(Uri.parse(url)),
      preload: true,
    );
    debugPrint('[QuranAudioHandler] SEEK zero before play');
    await _player.seek(Duration.zero);
    mediaItem.add(item);
    queue.add([item]);
    debugPrint('[QuranAudioHandler] PLAY after setSurah');
    await _player.play();
  }

  Future<void> setQueue({
    required QuranReciter reciter,
    required Moshaf moshaf,
    required List<int> surahNumbers,
    required int startIndex,
    String? Function(int surahNumber)? localPathForSurah,
  }) async {
    debugPrint('[QuranAudioHandler] SET QUEUE: reciter=${reciter.id} startSurah=${surahNumbers[startIndex]} localPaths=${localPathForSurah != null}');
    _currentReciter = reciter;
    _currentMoshaf = moshaf;

    final items = surahNumbers.map((num) {
      return _buildMediaItem(
        surahNumber: num,
        surahName: surahName(num),
        reciterName: reciter.name,
        moshafName: moshaf.name,
        audioUrl: moshaf.audioUrl(num),
        reciterId: reciter.id.toString(),
        moshafId: moshaf.id.toString(),
      );
    }).toList();

    _persistableQueue = surahNumbers
        .map((num) => QueueItem(
              surahNumber: num,
              surahName: surahName(num),
              audioUrl: moshaf.audioUrl(num),
              localPath: localPathForSurah?.call(num),
            ))
        .toList();

    final audioSources = surahNumbers.map((num) {
      final localPath = localPathForSurah?.call(num);
      final url = localPath ?? moshaf.audioUrl(num);
      return AudioSource.uri(Uri.parse(url));
    }).toList();

    debugPrint('[QuranAudioHandler] STOP before setQueue');
    await _player.stop();
    debugPrint('[QuranAudioHandler] SET AUDIO SOURCE (queue)');
    await _player.setAudioSource(
      ConcatenatingAudioSource(children: audioSources),
      preload: true,
      initialIndex: startIndex,
    );
    final targetItem = items[startIndex];
    final targetSurahNum = surahNumbers[startIndex];
    final targetLocalPath = localPathForSurah?.call(targetSurahNum);
    if (targetLocalPath != null) {
      debugPrint('[QuranAudioHandler] SEEK zero before play (downloaded start)');
      await _player.seek(Duration.zero);
    }
    mediaItem.add(targetItem);
    debugPrint('[QuranAudioHandler] PLAY after setQueue');
    await _player.play();
  }

  Future<void> restoreFromState(PersistedPlaybackState state) async {
    if (state.queue.isEmpty) return;

    debugPrint('[QuranAudioHandler] RESTORE POSITION: surah=${state.currentSurahNumber} reciter=${state.reciterName} positionMs=${state.positionMs}');

    final sourceItems = state.queue.map((q) {
      final url = q.localPath ?? q.audioUrl;
      return AudioSource.uri(Uri.parse(url));
    }).toList();

    final mediaItems = state.queue.map((q) {
      return MediaItem(
        id: 'restored_${q.surahNumber}',
        album: '${state.reciterName} — ${state.moshafName}',
        title: q.surahName,
        artist: state.reciterName,
        extras: {
          'surahNumber': q.surahNumber,
          'surahName': q.surahName,
          'audioUrl': q.audioUrl,
          'localPath': q.localPath,
        },
      );
    }).toList();

    _persistableQueue = state.queue;
    queue.add(mediaItems);

    final source = ConcatenatingAudioSource(children: sourceItems);
    debugPrint('[QuranAudioHandler] SET AUDIO SOURCE (restore) with position=${state.position}');
    await _player.stop();
    await _player.setAudioSource(
      source,
      preload: true,
      initialIndex: state.currentIndex,
      initialPosition: state.position,
    );
    await _player.setSpeed(state.speed);

    final loopModes = LoopMode.values;
    final loopIdx = state.loopModeIndex.clamp(0, loopModes.length - 1);
    await _player.setLoopMode(loopModes[loopIdx]);

    mediaItem.add(mediaItems[state.currentIndex]);
    debugPrint('[QuranAudioHandler] PLAY after restore');
    await _player.play();
  }

  // ─── Queue Management ───

  Future<void> addToQueue(QueueItem item, {required bool playNext}) async {
    final currentIdx = _player.currentIndex ?? 0;
    final insertIdx = playNext ? currentIdx + 1 : queue.value.length;

    final mediaItem_ = _buildMediaItem(
      surahNumber: item.surahNumber,
      surahName: item.surahName,
      reciterName: _currentReciter?.name ?? '',
      moshafName: _currentMoshaf?.name ?? '',
      audioUrl: item.audioUrl,
      reciterId: _currentReciter?.id.toString() ?? '0',
      moshafId: _currentMoshaf?.id.toString() ?? '0',
    );

    final qList = List<MediaItem>.from(queue.value);
    qList.insert(insertIdx.clamp(0, qList.length), mediaItem_);
    queue.add(qList);

    _persistableQueue.insert(
      insertIdx.clamp(0, _persistableQueue.length),
      item,
    );

    try {
      final src = AudioSource.uri(Uri.parse(item.localPath ?? item.audioUrl));
      final concat = _player.audioSource as ConcatenatingAudioSource;
      await concat.insert(insertIdx.clamp(0, concat.length), src);
    } catch (_) {}
  }

  Future<void> removeFromQueue(int index) async {
    if (index < 0 || index >= queue.value.length) return;
    if (queue.value.length <= 1) return;

    final qList = List<MediaItem>.from(queue.value);
    qList.removeAt(index);
    queue.add(qList);

    if (index < _persistableQueue.length) {
      _persistableQueue.removeAt(index);
    }

    try {
      final concat = _player.audioSource as ConcatenatingAudioSource;
      if (index < concat.length) {
        await concat.removeAt(index);
      }
    } catch (_) {}

    final curIdx = _player.currentIndex ?? 0;
    if (index < curIdx) {
      await _player.seek(Duration.zero, index: curIdx - 1);
    } else if (index == curIdx && curIdx >= qList.length) {
      await _player.seek(Duration.zero, index: qList.length - 1);
    }
  }

  Future<void> moveInQueue(int from, int to) async {
    if (from == to) return;
    if (from < 0 || from >= queue.value.length) return;
    if (to < 0 || to >= queue.value.length) return;

    final qList = List<MediaItem>.from(queue.value);
    final item = qList.removeAt(from);
    qList.insert(to, item);
    queue.add(qList);

    final qItem = _persistableQueue.removeAt(from);
    _persistableQueue.insert(to, qItem);

    try {
      final concat = _player.audioSource as ConcatenatingAudioSource;
      final src = concat.children[from];
      await concat.removeAt(from);
      await concat.insert(to, src);
    } catch (_) {}

    final curIdx = _player.currentIndex ?? 0;
    int newIdx = curIdx;
    if (curIdx == from) {
      newIdx = to;
    } else if (from < curIdx && to >= curIdx) {
      newIdx = curIdx - 1;
    } else if (from > curIdx && to <= curIdx) {
      newIdx = curIdx + 1;
    }
    await _player.seek(Duration.zero, index: newIdx);
  }

  Future<void> clearQueue() async {
    final curIdx = _player.currentIndex ?? 0;
    if (curIdx < queue.value.length) {
      final currentItem = queue.value[curIdx];
      final currentPersistable = curIdx < _persistableQueue.length
          ? _persistableQueue[curIdx]
          : null;

      queue.add([currentItem]);
      _persistableQueue = currentPersistable != null ? [currentPersistable] : [];
      await _player.seek(Duration.zero, index: 0);
    }
  }

  // ─── Overrides ───

  @override
  Future<void> play() async {
    debugPrint('[QuranAudioHandler] PLAY');
    await _player.play();
  }

  @override
  Future<void> pause() async {
    debugPrint('[QuranAudioHandler] PAUSE');
    await _player.pause();
  }

  @override
  Future<void> stop() async {
    debugPrint('[QuranAudioHandler] STOP');
    await _player.stop();
    playbackState.add(playbackState.value.copyWith(
      processingState: AudioProcessingState.idle,
      playing: false,
    ));
  }

  Future<void> closePlayback() async {
    debugPrint('[QuranAudioHandler] CLOSE PLAYBACK');
    await _player.stop();
    await _player.seek(Duration.zero);
    _currentReciter = null;
    _currentMoshaf = null;
    _persistableQueue = [];
    _mediaItemCache.clear();
    mediaItem.add(null);
    queue.add([]);
    playbackState.add(playbackState.value.copyWith(
      processingState: AudioProcessingState.idle,
      playing: false,
      updatePosition: Duration.zero,
      bufferedPosition: Duration.zero,
      queueIndex: null,
      controls: [],
    ));
  }

  @override
  Future<void> seek(Duration position) async {
    debugPrint('[QuranAudioHandler] SEEK: ${position.inMilliseconds}ms');
    await _player.seek(position);
  }

  @override
  Future<void> skipToNext() async {
    if (_player.hasNext) {
      await _player.seekToNext();
    }
  }

  @override
  Future<void> skipToPrevious() async {
    if (_player.position.inSeconds > 3) {
      await _player.seek(Duration.zero);
    } else if (_player.hasPrevious) {
      await _player.seekToPrevious();
    }
  }

  @override
  Future<void> skipToQueueItem(int index) async {
    if (index >= 0 && index < queue.value.length) {
      await _player.seek(Duration.zero, index: index);
      await _player.play();
    }
  }

  Future<void> setSpeed(double speed) async {
    final clamped = speed.clamp(0.5, 3.0);
    await _player.setSpeed(clamped);
  }

  Future<void> setLoopMode(LoopMode mode) async {
    await _player.setLoopMode(mode);
  }

  // ─── Streams / Getters ───

  Stream<bool> get playingStream => _player.playingStream;
  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;
  Stream<ProcessingState> get processingStateStream =>
      _player.processingStateStream;
  Stream<int?> get currentIndexStream => _player.currentIndexStream;
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  bool get isPlaying => _player.playing;
  Duration get position => _player.position;
  Duration? get duration => _player.duration;
  ProcessingState get processingState => _player.processingState;
  int? get currentIndex => _player.currentIndex;
  bool get hasNext => _player.hasNext;
  bool get hasPrevious => _player.hasPrevious;
  double get speed => _player.speed;
  LoopMode get loopMode => _player.loopMode;

  @override
  Future<void> onTaskRemoved() async {}

  @override
  Future<void> customAction(String name, [Map<String, dynamic>? extras]) async {
    switch (name) {
      case 'setSpeed':
        final speed = extras?['speed'] as double? ?? 1.0;
        await setSpeed(speed);
        break;
      case 'setLoopMode':
        final mode = extras?['loopMode'] as int? ?? 0;
        await setLoopMode(LoopMode.values[mode]);
        break;
    }
  }

  void dispose() {
    _stateSub?.cancel();
    _positionSub?.cancel();
    _durationSub?.cancel();
    _indexSub?.cancel();
    _processingSub?.cancel();
    _interruptionSub?.cancel();
    _player.dispose();
  }
}

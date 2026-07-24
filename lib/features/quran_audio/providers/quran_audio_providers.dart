import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../data/datasources/quran_audio_api.dart';
import '../data/models/quran_audio_models.dart';
import '../data/models/persisted_playback_state.dart';
import '../data/repositories/quran_audio_repository.dart';
import '../services/quran_audio_handler.dart';
import '../services/quran_audio_player.dart';
import '../services/download_service.dart';
import '../services/audio_storage_service.dart';

// ─── Repository Provider ───

final quranAudioRepositoryProvider = Provider<QuranAudioRepository>((ref) {
  final repo = QuranAudioRepository();
  ref.onDispose(() => repo.dispose());
  return repo;
});

// ─── Audio Handler (singleton — survives page changes) ───

final audioHandlerProvider = Provider<QuranAudioHandler>((ref) {
  final handler = QuranAudioHandler.instance;
  return handler;
});

// ─── Services ───

final quranAudioPlayerProvider = Provider<QuranAudioPlayer>((ref) {
  final handler = ref.watch(audioHandlerProvider);
  final player = QuranAudioPlayer(handler: handler);
  player.init();
  ref.onDispose(() => player.dispose());
  return player;
});

final downloadServiceProvider = Provider<DownloadService>((ref) {
  final svc = DownloadService();
  ref.onDispose(() => svc.dispose());
  return svc;
});

final audioStorageServiceProvider = Provider<AudioStorageService>((ref) {
  return AudioStorageService();
});

// ─── Reciters ───

enum RecitersStatus { initial, loading, loaded, error }

class RecitersState {
  final RecitersStatus status;
  final List<QuranReciter> reciters;
  final String? error;
  final String searchQuery;

  const RecitersState({
    this.status = RecitersStatus.initial,
    this.reciters = const [],
    this.error,
    this.searchQuery = '',
  });

  RecitersState copyWith({
    RecitersStatus? status,
    List<QuranReciter>? reciters,
    String? error,
    String? searchQuery,
  }) {
    return RecitersState(
      status: status ?? this.status,
      reciters: reciters ?? this.reciters,
      error: error ?? this.error,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  List<QuranReciter> get filtered {
    if (searchQuery.isEmpty) return reciters;
    final q = searchQuery.trim();
    return reciters.where((r) =>
      r.name.contains(q) || r.riwayah.contains(q)
    ).toList();
  }
}

class RecitersNotifier extends StateNotifier<RecitersState> {
  final QuranAudioRepository _repo;

  RecitersNotifier(this._repo) : super(const RecitersState());

  Future<void> load() async {
    state = state.copyWith(status: RecitersStatus.loading);
    try {
      final list = await _repo.getReciters();
      if (list.isEmpty) {
        state = state.copyWith(
          status: RecitersStatus.error,
          error: 'لا يوجد قراء متاحون',
        );
      } else {
        state = state.copyWith(status: RecitersStatus.loaded, reciters: list);
      }
    } on QuranAudioException catch (e) {
      state = state.copyWith(status: RecitersStatus.error, error: e.message);
    } catch (e) {
      state = state.copyWith(
        status: RecitersStatus.error,
        error: 'حدث خطأ أثناء تحميل القراء',
      );
    }
  }

  void search(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void retry() => load();
}

final recitersProvider =
    StateNotifierProvider<RecitersNotifier, RecitersState>((ref) {
  final repo = ref.watch(quranAudioRepositoryProvider);
  return RecitersNotifier(repo);
});

// ─── Audio Player State ───

class AudioPlayerState {
  final bool isPlaying;
  final bool isPaused;
  final bool isStopped;
  final bool isBuffering;
  final bool hasError;
  final String? errorMessage;
  final Duration position;
  final Duration duration;
  final double speed;
  final LoopMode loopMode;
  final bool shuffle;
  final Duration? sleepTimerRemaining;
  final QuranReciter? currentReciter;
  final Moshaf? currentMoshaf;
  final int currentSurahNumber;
  final String currentSurahName;
  final String? currentAudioUrl;
  final DateTime? playbackStartedAt;

  const AudioPlayerState({
    this.isPlaying = false,
    this.isPaused = false,
    this.isStopped = true,
    this.isBuffering = false,
    this.hasError = false,
    this.errorMessage,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.speed = 1.0,
    this.loopMode = LoopMode.off,
    this.shuffle = false,
    this.sleepTimerRemaining,
    this.currentReciter,
    this.currentMoshaf,
    this.currentSurahNumber = 1,
    this.currentSurahName = 'الفاتحة',
    this.currentAudioUrl,
    this.playbackStartedAt,
  });

  bool get hasActivePlayback => isPlaying || isPaused || isBuffering;

  AudioPlayerState copyWith({
    bool? isPlaying,
    bool? isPaused,
    bool? isStopped,
    bool? isBuffering,
    bool? hasError,
    String? errorMessage,
    Duration? position,
    Duration? duration,
    double? speed,
    LoopMode? loopMode,
    bool? shuffle,
    Duration? sleepTimerRemaining,
    QuranReciter? currentReciter,
    Moshaf? currentMoshaf,
    int? currentSurahNumber,
    String? currentSurahName,
    String? currentAudioUrl,
    DateTime? playbackStartedAt,
    bool clearError = false,
    bool clearReciter = false,
    bool clearSleepTimer = false,
  }) {
    return AudioPlayerState(
      isPlaying: isPlaying ?? this.isPlaying,
      isPaused: isPaused ?? this.isPaused,
      isStopped: isStopped ?? this.isStopped,
      isBuffering: isBuffering ?? this.isBuffering,
      hasError: hasError ?? this.hasError,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      position: position ?? this.position,
      duration: duration ?? this.duration,
      speed: speed ?? this.speed,
      loopMode: loopMode ?? this.loopMode,
      shuffle: shuffle ?? this.shuffle,
      sleepTimerRemaining: clearSleepTimer
          ? null
          : (sleepTimerRemaining ?? this.sleepTimerRemaining),
      currentReciter:
          clearReciter ? null : (currentReciter ?? this.currentReciter),
      currentMoshaf:
          clearReciter ? null : (currentMoshaf ?? this.currentMoshaf),
      currentSurahNumber: currentSurahNumber ?? this.currentSurahNumber,
      currentSurahName: currentSurahName ?? this.currentSurahName,
      currentAudioUrl: currentAudioUrl ?? this.currentAudioUrl,
      playbackStartedAt: playbackStartedAt ?? this.playbackStartedAt,
    );
  }
}

class AudioPlayerNotifier extends StateNotifier<AudioPlayerState> {
  final QuranAudioPlayer _player;
  final AudioStorageService _storage;

  StreamSubscription<PlayerState>? _stateSub;
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<Duration?>? _durationSub;
  StreamSubscription<MediaItem?>? _mediaItemSub;
  Timer? _sleepTimer;
  Timer? _persistDebounce;
  bool _shuffleQueue = false;
  List<int> _shuffleOrder = [];

  AudioPlayerNotifier(this._player, this._storage)
      : super(const AudioPlayerState()) {
    _listenToPlayer();
    _restoreOnStartup();
  }

  bool _hasRestored = false;
  bool _userStartedPlayback = false;
  bool _userExplicitlyClosed = false;

  Future<void> _restoreOnStartup() async {
    if (_hasRestored) return;
    _hasRestored = true;
    await Future.delayed(const Duration(milliseconds: 500));
    if (!_userStartedPlayback && !_userExplicitlyClosed) {
      await restorePlayback();
    } else {
      debugPrint('[AudioPlayerNotifier] SKIP restore — ${_userExplicitlyClosed ? "user explicitly closed" : "user already started playback"}');
    }
  }

  void _listenToPlayer() {
    _stateSub = _player.playerStateStream.listen((playerState) {
      if (mounted) {
        state = state.copyWith(
          isPlaying: playerState.playing,
          isPaused: !playerState.playing &&
              playerState.processingState != ProcessingState.idle,
          isStopped: playerState.processingState == ProcessingState.idle,
          isBuffering:
              playerState.processingState == ProcessingState.buffering,
        );
        _debouncePersist();
      }
    });
    _positionSub = _player.positionStream.listen((pos) {
      if (mounted) state = state.copyWith(position: pos);
    });
    _durationSub = _player.durationStream.listen((dur) {
      if (mounted && dur != null) state = state.copyWith(duration: dur);
    });
    _mediaItemSub = _player.handler.mediaItem.listen((item) {
      if (mounted && item != null) {
        final surahNum = item.extras?['surahNumber'] as int? ?? state.currentSurahNumber;
        final surahNm = item.extras?['surahName'] as String? ?? state.currentSurahName;
        final audioUrl = item.extras?['audioUrl'] as String?;
        state = state.copyWith(
          currentSurahNumber: surahNum,
          currentSurahName: surahNm,
          currentAudioUrl: audioUrl,
        );
        _debouncePersist();
      }
    });
  }

  void _debouncePersist() {
    _persistDebounce?.cancel();
    _persistDebounce = Timer(const Duration(seconds: 2), () {
      persistState();
    });
  }

  Future<void> persistState() async {
    if (!mounted) return;
    if (state.isStopped && !state.hasActivePlayback) return;

    final reciter = state.currentReciter ?? _player.currentReciter;
    final moshaf = state.currentMoshaf ?? _player.currentMoshaf;
    if (reciter == null || moshaf == null) return;

    final queue = _player.persistableQueue;
    final currentIndex = _player.currentIndex ?? 0;

    final persisted = PersistedPlaybackState(
      currentSurahNumber: state.currentSurahNumber,
      currentSurahName: state.currentSurahName,
      reciterId: reciter.id,
      reciterName: reciter.name,
      moshafId: moshaf.id,
      moshafName: moshaf.name,
      server: moshaf.server,
      currentIndex: currentIndex,
      positionMs: state.position.inMilliseconds,
      speed: state.speed,
      loopModeIndex: state.loopMode.index,
      shuffle: state.shuffle,
      queue: queue,
      savedAt: DateTime.now(),
    );

    await _storage.savePlaybackState(persisted);
  }

  Future<void> restorePlayback() async {
    final saved = await _storage.loadPlaybackState();
    if (saved == null || saved.queue.isEmpty) return;

    state = state.copyWith(
      currentSurahNumber: saved.currentSurahNumber,
      currentSurahName: saved.currentSurahName,
      currentAudioUrl: saved.queue[saved.currentIndex.clamp(0, saved.queue.length - 1)].audioUrl,
      speed: saved.speed,
      loopMode: LoopMode.values[saved.loopModeIndex.clamp(0, LoopMode.values.length - 1)],
      shuffle: saved.shuffle,
      isBuffering: true,
      isStopped: false,
      playbackStartedAt: saved.savedAt,
    );

    _shuffleQueue = saved.shuffle;

    try {
      await _player.restoreFromState(saved);
      _saveRecentlyPlayedFromPersisted(saved);
    } catch (e) {
      state = state.copyWith(
        hasError: true,
        errorMessage: 'تعذر استئناف التشغيل',
        isBuffering: false,
        isStopped: true,
      );
    }
  }

  Future<void> playSurah({
    required QuranReciter reciter,
    required Moshaf moshaf,
    required int surahNumber,
    String? localPath,
  }) async {
    debugPrint('[AudioPlayerNotifier] PLAY SURAH: reciter=${reciter.id} surah=$surahNumber localPath=$localPath');
    _userStartedPlayback = true;
    final name = surahName(surahNumber);

    state = state.copyWith(
      currentReciter: reciter,
      currentMoshaf: moshaf,
      currentSurahNumber: surahNumber,
      currentSurahName: name,
      currentAudioUrl: moshaf.audioUrl(surahNumber),
      playbackStartedAt: DateTime.now(),
      isStopped: false,
      isPlaying: false,
      isPaused: false,
      isBuffering: true,
      hasError: false,
      errorMessage: null,
      position: Duration.zero,
    );

    try {
      await _player.play(
        reciter: reciter,
        moshaf: moshaf,
        surahNumber: surahNumber,
        localPath: localPath,
      );
      _saveRecentlyPlayed(reciter, moshaf, surahNumber, name);
    } catch (e) {
      debugPrint('[AudioPlayerNotifier] PLAY SURAH error: $e');
      state = state.copyWith(
        hasError: true,
        errorMessage: 'تعذر تشغيل السورة',
        isBuffering: false,
        isStopped: true,
        isPlaying: false,
      );
    }
  }

  Future<void> playSurahQueue({
    required QuranReciter reciter,
    required Moshaf moshaf,
    required List<int> surahNumbers,
    required int startIndex,
    String? Function(int surahNumber)? localPathForSurah,
  }) async {
    final surahNum = surahNumbers[startIndex];
    final name = surahName(surahNum);
    final localPath = localPathForSurah?.call(surahNum);
    debugPrint('[AudioPlayerNotifier] PLAY SURAH QUEUE: reciter=${reciter.id} startSurah=$surahNum localPath=$localPath');
    _userStartedPlayback = true;

    state = state.copyWith(
      currentReciter: reciter,
      currentMoshaf: moshaf,
      currentSurahNumber: surahNum,
      currentSurahName: name,
      currentAudioUrl: moshaf.audioUrl(surahNum),
      playbackStartedAt: DateTime.now(),
      isStopped: false,
      isPlaying: false,
      isPaused: false,
      isBuffering: true,
      hasError: false,
      errorMessage: null,
      position: Duration.zero,
    );

    try {
      await _player.playQueue(
        reciter: reciter,
        moshaf: moshaf,
        surahNumbers: surahNumbers,
        startIndex: startIndex,
        localPathForSurah: localPathForSurah,
      );
      _saveRecentlyPlayed(reciter, moshaf, surahNum, name);
    } catch (e) {
      debugPrint('[AudioPlayerNotifier] PLAY SURAH QUEUE error: $e');
      state = state.copyWith(
        hasError: true,
        errorMessage: 'تعذر تشغيل السور',
        isBuffering: false,
        isStopped: true,
        isPlaying: false,
      );
    }
  }

  Future<void> togglePlayPause() async {
    debugPrint('[AudioPlayerNotifier] TOGGLE PLAY/PAUSE: isPlaying=${state.isPlaying} isPaused=${state.isPaused}');
    if (state.isPlaying) {
      debugPrint('[AudioPlayerNotifier] -> PAUSE');
      await _player.pause();
    } else if (state.isPaused || state.isStopped || state.isBuffering) {
      debugPrint('[AudioPlayerNotifier] -> PLAY/RESUME');
      await _player.resume();
    }
  }

  Future<void> stop() async {
    debugPrint('[AudioPlayerNotifier] STOP');
    await _player.stop();
    state = state.copyWith(
      isPlaying: false,
      isPaused: false,
      isStopped: true,
      position: Duration.zero,
      isBuffering: false,
    );
    await _storage.clearPlaybackState();
  }

  Future<void> close() async {
    debugPrint('[AudioPlayerNotifier] CLOSE — fully stopping and clearing player');
    _userExplicitlyClosed = true;
    _sleepTimer?.cancel();
    _persistDebounce?.cancel();
    await _player.handler.closePlayback();
    await _storage.clearPlaybackState();
    state = const AudioPlayerState();
  }

  Future<void> seekTo(Duration position) async {
    await _player.seek(position);
    _debouncePersist();
  }

  Future<void> setSpeed(double speed) async {
    await _player.setSpeed(speed);
    state = state.copyWith(speed: speed);
    _debouncePersist();
  }

  Future<void> setLoopMode(LoopMode mode) async {
    await _player.setLoopMode(mode);
    state = state.copyWith(loopMode: mode);
    _debouncePersist();
  }

  void toggleShuffle() {
    final newShuffle = !state.shuffle;
    _shuffleQueue = newShuffle;
    if (newShuffle) {
      _generateShuffleOrder();
    }
    state = state.copyWith(shuffle: newShuffle);
    _debouncePersist();
  }

  Future<void> nextSurah(int maxSurah) async {
    if (state.currentReciter == null || state.currentMoshaf == null) return;
    final queue = _player.currentQueue;
    if (queue.length > 1) {
      await _player.skipToNext();
    } else {
      int next;
      if (_shuffleQueue && _shuffleOrder.isNotEmpty) {
        final currentIdx = _shuffleOrder.indexOf(state.currentSurahNumber);
        next = currentIdx < _shuffleOrder.length - 1
            ? _shuffleOrder[currentIdx + 1]
            : _shuffleOrder.first;
      } else {
        next = state.currentSurahNumber >= maxSurah ? 1 : state.currentSurahNumber + 1;
      }
      await playSurah(
        reciter: state.currentReciter!,
        moshaf: state.currentMoshaf!,
        surahNumber: next,
      );
    }
  }

  Future<void> previousSurah(int maxSurah) async {
    if (state.currentReciter == null || state.currentMoshaf == null) return;
    if (state.position.inSeconds > 3) {
      await seekTo(Duration.zero);
      return;
    }
    final queue = _player.currentQueue;
    if (queue.length > 1) {
      await _player.skipToPrevious();
    } else {
      int prev;
      if (_shuffleQueue && _shuffleOrder.isNotEmpty) {
        final currentIdx = _shuffleOrder.indexOf(state.currentSurahNumber);
        prev = currentIdx > 0
            ? _shuffleOrder[currentIdx - 1]
            : _shuffleOrder.last;
      } else {
        prev = state.currentSurahNumber <= 1 ? maxSurah : state.currentSurahNumber - 1;
      }
      await playSurah(
        reciter: state.currentReciter!,
        moshaf: state.currentMoshaf!,
        surahNumber: prev,
      );
    }
  }

  void _generateShuffleOrder() {
    _shuffleOrder = List.generate(114, (i) => i + 1)..shuffle();
  }

  // ─── Queue Management ───

  Future<void> addToQueue(QueueItem item, {required bool playNext}) async {
    await _player.addToQueue(item, playNext: playNext);
    _debouncePersist();
  }

  Future<void> removeFromQueue(int index) async {
    await _player.removeFromQueue(index);
    _debouncePersist();
  }

  Future<void> moveInQueue(int from, int to) async {
    await _player.moveInQueue(from, to);
    _debouncePersist();
  }

  Future<void> clearQueue() async {
    await _player.clearQueue();
    _debouncePersist();
  }

  // ─── Sleep Timer ───

  void startSleepTimer(Duration duration) {
    _sleepTimer?.cancel();
    state = state.copyWith(sleepTimerRemaining: duration);
    _sleepTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final remaining = state.sleepTimerRemaining! - const Duration(seconds: 1);
      if (remaining <= Duration.zero) {
        timer.cancel();
        _player.pause();
        state = state.copyWith(
          sleepTimerRemaining: null,
          isPlaying: false,
          isPaused: true,
        );
      } else {
        state = state.copyWith(sleepTimerRemaining: remaining);
      }
    });
  }

  void cancelSleepTimer() {
    _sleepTimer?.cancel();
    state = state.copyWith(clearSleepTimer: true);
  }

  Future<void> _saveRecentlyPlayed(
    QuranReciter reciter,
    Moshaf moshaf,
    int surahNumber,
    String surahName,
  ) async {
    final entry = RecentlyPlayedEntry(
      reciterId: reciter.id,
      reciterName: reciter.name,
      moshafName: moshaf.name,
      server: moshaf.server,
      surahNumber: surahNumber,
      surahName: surahName,
      position: Duration.zero,
      playedAt: DateTime.now(),
      moshafId: moshaf.id.toString(),
    );
    await _storage.addRecentlyPlayed(entry);
  }

  Future<void> _saveRecentlyPlayedFromPersisted(
      PersistedPlaybackState saved) async {
    if (saved.reciterId == null) return;
    final entry = RecentlyPlayedEntry(
      reciterId: saved.reciterId!,
      reciterName: saved.reciterName,
      moshafName: saved.moshafName,
      server: saved.server,
      surahNumber: saved.currentSurahNumber,
      surahName: saved.currentSurahName,
      position: saved.position,
      playedAt: DateTime.now(),
      moshafId: saved.moshafId?.toString() ?? '',
    );
    await _storage.addRecentlyPlayed(entry);
  }

  @override
  void dispose() {
    _stateSub?.cancel();
    _positionSub?.cancel();
    _durationSub?.cancel();
    _mediaItemSub?.cancel();
    _sleepTimer?.cancel();
    _persistDebounce?.cancel();
    persistState();
    super.dispose();
  }
}

final audioPlayerNotifierProvider =
    StateNotifierProvider<AudioPlayerNotifier, AudioPlayerState>((ref) {
  final player = ref.watch(quranAudioPlayerProvider);
  final storage = ref.watch(audioStorageServiceProvider);
  return AudioPlayerNotifier(player, storage);
});

// ─── Downloads ───

class DownloadsState {
  final Set<String> downloadedKeys;
  final Map<String, double> progressMap;
  final Set<String> downloadingKeys;

  const DownloadsState({
    this.downloadedKeys = const {},
    this.progressMap = const {},
    this.downloadingKeys = const {},
  });

  DownloadsState copyWith({
    Set<String>? downloadedKeys,
    Map<String, double>? progressMap,
    Set<String>? downloadingKeys,
  }) {
    return DownloadsState(
      downloadedKeys: downloadedKeys ?? this.downloadedKeys,
      progressMap: progressMap ?? this.progressMap,
      downloadingKeys: downloadingKeys ?? this.downloadingKeys,
    );
  }

  String _key(int reciterId, int surah) => '${reciterId}_$surah';
  bool isDownloaded(int reciterId, int surah) =>
      downloadedKeys.contains(_key(reciterId, surah));
  bool isDownloading(int reciterId, int surah) =>
      downloadingKeys.contains(_key(reciterId, surah));
  double progress(int reciterId, int surah) =>
      progressMap[_key(reciterId, surah)] ?? 0.0;
}

class DownloadsNotifier extends StateNotifier<DownloadsState> {
  final DownloadService _service;

  DownloadsNotifier(this._service) : super(const DownloadsState());

  Future<void> checkDownloaded(int reciterId, int surah) async {
    final key = '${reciterId}_$surah';
    final isDown = await _service.isDownloaded(reciterId, surah);
    if (isDown) {
      state = state.copyWith(
        downloadedKeys: {...state.downloadedKeys, key},
      );
    }
  }

  Future<void> checkAllDownloaded(int reciterId, List<int> surahs) async {
    final newKeys = Set<String>.from(state.downloadedKeys);
    for (final surah in surahs) {
      final isDown = await _service.isDownloaded(reciterId, surah);
      if (isDown) newKeys.add('${reciterId}_$surah');
    }
    state = state.copyWith(downloadedKeys: newKeys);
  }

  void download(int reciterId, int surahNumber, String url) {
    final key = '${reciterId}_$surahNumber';
    state = state.copyWith(
      downloadingKeys: {...state.downloadingKeys, key},
    );

    _service.downloadSurah(reciterId, surahNumber, url).listen(
      (progress) {
        if (progress < 0) {
          state = state.copyWith(
            downloadingKeys: {...state.downloadingKeys}..remove(key),
          );
          return;
        }
        state = state.copyWith(
          progressMap: {...state.progressMap, key: progress},
        );
        if (progress >= 1.0) {
          state = state.copyWith(
            downloadedKeys: {...state.downloadedKeys, key},
            downloadingKeys: {...state.downloadingKeys}..remove(key),
          );
        }
      },
      onError: (_) {
        state = state.copyWith(
          downloadingKeys: {...state.downloadingKeys}..remove(key),
        );
      },
    );
  }

  void cancelDownload(int reciterId, int surahNumber) {
    _service.cancelDownload(reciterId, surahNumber);
    final key = '${reciterId}_$surahNumber';
    state = state.copyWith(
      downloadingKeys: {...state.downloadingKeys}..remove(key),
      progressMap: {...state.progressMap}..remove(key),
    );
  }

  Future<void> deleteDownload(int reciterId, int surahNumber) async {
    await _service.deleteDownload(reciterId, surahNumber);
    final key = '${reciterId}_$surahNumber';
    state = state.copyWith(
      downloadedKeys: {...state.downloadedKeys}..remove(key),
    );
  }

  Future<String?> getLocalPath(int reciterId, int surahNumber) async {
    return _service.getLocalPath(reciterId, surahNumber);
  }
}

final downloadsProvider =
    StateNotifierProvider<DownloadsNotifier, DownloadsState>((ref) {
  final svc = ref.watch(downloadServiceProvider);
  return DownloadsNotifier(svc);
});

// ─── Favorites ───

class AudioFavoritesState {
  final Set<String> favoriteReciterIds;
  final Set<String> favoriteSurahKeys;

  const AudioFavoritesState({
    this.favoriteReciterIds = const {},
    this.favoriteSurahKeys = const {},
  });

  AudioFavoritesState copyWith({
    Set<String>? favoriteReciterIds,
    Set<String>? favoriteSurahKeys,
  }) {
    return AudioFavoritesState(
      favoriteReciterIds: favoriteReciterIds ?? this.favoriteReciterIds,
      favoriteSurahKeys: favoriteSurahKeys ?? this.favoriteSurahKeys,
    );
  }

  bool isReciterFav(String id) => favoriteReciterIds.contains(id);
  bool isSurahFav(String key) => favoriteSurahKeys.contains(key);
}

class AudioFavoritesNotifier extends StateNotifier<AudioFavoritesState> {
  final AudioStorageService _storage;

  AudioFavoritesNotifier(this._storage) : super(const AudioFavoritesState());

  Future<void> load() async {
    final reciterIds = await _storage.getFavoriteReciterIds();
    final surahKeys = await _storage.getFavoriteSurahKeys();
    state = AudioFavoritesState(
      favoriteReciterIds: reciterIds,
      favoriteSurahKeys: surahKeys,
    );
  }

  Future<void> toggleReciter(String reciterId) async {
    await _storage.toggleFavoriteReciter(reciterId);
    final ids = await _storage.getFavoriteReciterIds();
    state = state.copyWith(favoriteReciterIds: ids);
  }

  Future<void> toggleSurah(String key) async {
    await _storage.toggleFavoriteSurah(key);
    final keys = await _storage.getFavoriteSurahKeys();
    state = state.copyWith(favoriteSurahKeys: keys);
  }
}

final audioFavoritesProvider =
    StateNotifierProvider<AudioFavoritesNotifier, AudioFavoritesState>((ref) {
  final storage = ref.watch(audioStorageServiceProvider);
  return AudioFavoritesNotifier(storage);
});

// ─── Recently Played ───

final recentlyPlayedProvider = FutureProvider<List<RecentlyPlayedEntry>>((ref) {
  final storage = ref.watch(audioStorageServiceProvider);
  return storage.getRecentlyPlayed();
});

// ─── Storage Stats ───

final storageStatsProvider = FutureProvider<StorageStats>((ref) async {
  final storage = ref.watch(audioStorageServiceProvider);
  final downloadedSize = await storage.getDownloadedSize();
  final downloadedCount = await storage.getDownloadedFileCount();
  final cacheSize = await storage.getCacheSize();
  return StorageStats(
    downloadedSize: downloadedSize,
    downloadedFileCount: downloadedCount,
    cacheSize: cacheSize,
  );
});

class StorageStats {
  final int downloadedSize;
  final int downloadedFileCount;
  final int cacheSize;

  const StorageStats({
    required this.downloadedSize,
    required this.downloadedFileCount,
    required this.cacheSize,
  });

  String get downloadedSizeFormatted => _formatSize(downloadedSize);
  String get cacheSizeFormatted => _formatSize(cacheSize);
  String get totalSizeFormatted => _formatSize(downloadedSize + cacheSize);

  static String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}

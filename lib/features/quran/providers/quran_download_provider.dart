import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/quran_page_repository.dart';

/// Notifier managing the state of the Quran SVG download process.
class QuranDownloadNotifier extends StateNotifier<QuranDownloadState> {
  QuranDownloadNotifier({QuranPageRepository? repository})
      : _repository = repository ?? QuranPageRepository(),
        super(const QuranDownloadState()) {
    _init();
  }

  final QuranPageRepository _repository;
  CancelToken? _cancelToken;
  bool _resourcesDisposed = false;

  Future<void> _init() async {
    final downloaded = await _repository.getDownloadedPagesCount();
    const total = 604;
    state = state.copyWith(
      downloadedCount: downloaded,
      totalCount: total,
      isCompleted: downloaded >= total,
    );
  }

  /// Checks if Quran is already fully downloaded.
  Future<bool> checkDownloaded() async {
    final isDone = await _repository.isQuranDownloaded();
    if (isDone) {
      state = state.copyWith(isCompleted: true);
    }
    return isDone;
  }

  /// Starts or resumes downloading all missing pages.
  Future<void> startDownload() async {
    if (state.isDownloading) return;

    _cancelToken = CancelToken();
    state = state.copyWith(
      isDownloading: true,
      error: null,
      isCompleted: false,
    );

    try {
      await _repository.downloadAllPages(
        cancelToken: _cancelToken,
        onProgress: (completed, total, currentPage) {
          if (!mounted) return;
          final percent = total > 0 ? completed / total : 0.0;
          state = state.copyWith(
            downloadedCount: completed,
            totalCount: total,
            currentPage: currentPage,
            progress: percent,
          );
        },
      );

      final isDone = await _repository.isQuranDownloaded();
      final finalCount = await _repository.getDownloadedPagesCount();

      if (mounted) {
        state = state.copyWith(
          isDownloading: false,
          isCompleted: isDone,
          downloadedCount: finalCount,
          progress: isDone ? 1.0 : state.progress,
        );
      }
    } catch (e) {
      if (mounted && !_cancelToken!.isCancelled) {
        state = state.copyWith(
          isDownloading: false,
          error: 'فشل تحميل صفحات القرآن. يرجى المحاولة مرة أخرى.',
        );
      }
    }
  }

  /// Cancels an in-progress download.
  void cancelDownload() {
    _cancelToken?.cancel('User cancelled');
    state = state.copyWith(isDownloading: false);
  }

  /// Retries the download from where it left off.
  Future<void> retryDownload() async {
    state = state.copyWith(error: null);
    await startDownload();
  }

  /// Disposes the underlying HTTP client after successful download.
  void disposeResources() {
    if (_resourcesDisposed) return;
    _resourcesDisposed = true;
    _cancelToken?.cancel('disposed');
    _repository.dispose();
  }

  @override
  void dispose() {
    _cancelToken?.cancel('disposed');
    if (!_resourcesDisposed) {
      _resourcesDisposed = true;
      _repository.dispose();
    }
    super.dispose();
  }
}

/// State for the Quran download process.
class QuranDownloadState {
  final bool isDownloading;
  final bool isCompleted;
  final int downloadedCount;
  final int totalCount;
  final int currentPage;
  final double progress;
  final String? error;

  const QuranDownloadState({
    this.isDownloading = false,
    this.isCompleted = false,
    this.downloadedCount = 0,
    this.totalCount = 604,
    this.currentPage = 0,
    this.progress = 0.0,
    this.error,
  });

  double get percentage => totalCount > 0 ? downloadedCount / totalCount : 0.0;

  QuranDownloadState copyWith({
    bool? isDownloading,
    bool? isCompleted,
    int? downloadedCount,
    int? totalCount,
    int? currentPage,
    double? progress,
    String? error,
  }) {
    return QuranDownloadState(
      isDownloading: isDownloading ?? this.isDownloading,
      isCompleted: isCompleted ?? this.isCompleted,
      downloadedCount: downloadedCount ?? this.downloadedCount,
      totalCount: totalCount ?? this.totalCount,
      currentPage: currentPage ?? this.currentPage,
      progress: progress ?? this.progress,
      error: error,
    );
  }
}

/// Provider for the Quran download notifier.
final quranDownloadProvider =
    StateNotifierProvider<QuranDownloadNotifier, QuranDownloadState>((ref) {
  return QuranDownloadNotifier();
});

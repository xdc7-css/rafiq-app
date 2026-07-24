import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../../../database/isar_service.dart';

/// Priority levels for download queue.
enum DownloadPriority {
  /// Current reading page — highest, preempts everything.
  critical,

  /// Adjacent pages (N±2 around current page).
  high,

  /// Background batch (10-page chunks).
  low,
}

/// Describes a single queued page download.
class _QueueEntry {
  final int pageNumber;
  final DownloadPriority priority;
  final Completer<String?> completer;

  _QueueEntry({
    required this.pageNumber,
    required this.priority,
    required this.completer,
  });
}

/// Production-grade streaming download manager for Quran SVG pages.
///
/// Architecture:
/// - Priority queue (critical > high > low)
/// - Background batch download in chunks of 10
/// - Exponential backoff retry (1s, 2s, 4s, 8s, 16s — max 5)
/// - Pause/resume on connectivity changes
/// - Persisted progress via Isar
/// - Read-through: Isar first, CDN fallback
class QuranPageStreamer {
  QuranPageStreamer({Dio? dio})
      : _dio = dio ?? _createDio(),
        _connectivity = Connectivity();

  final Dio _dio;
  final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;
  bool _paused = false;
  bool _disposed = false;

  // ── Queue ────────────────────────────────────────────────────────────────
  final Queue<_QueueEntry> _criticalQueue = Queue();
  final Queue<_QueueEntry> _highQueue = Queue();
  final Queue<_QueueEntry> _lowQueue = Queue();
  bool _processing = false;

  // ── In-flight deduplication ──────────────────────────────────────────────
  final Map<int, Future<String?>> _inFlight = {};
  final Set<int> _queuedPages = {};

  // ── Batch tracking ───────────────────────────────────────────────────────
  int _lastBatchEnd = 0;
  static const int batchSize = 10;
  static const int totalPages = 604;

  // ── CDN URL ──────────────────────────────────────────────────────────────
  static const String _cdnBase =
      'https://cdn.jsdelivr.net/gh/xdc7-css/quran-svg@main';

  static String _pageUrl(int page) {
    final padded = page.toString().padLeft(3, '0');
    final url = '$_cdnBase/$padded.svg';
    debugPrint('[QuranStreamer] Page: $page | File: $padded.svg | URL: $url');
    return url;
  }

  static Dio _createDio() {
    return Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 10),
    ));
  }

  bool _initialized = false;

  // ─── Lifecycle ───────────────────────────────────────────────────────────

  /// Start monitoring connectivity and resume any persisted download state.
  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    _connectivitySub = _connectivity.onConnectivityChanged.listen((results) {
      final wasPaused = _paused;
      _paused = results.contains(ConnectivityResult.none);
      if (_paused) {
        debugPrint('[QuranStreamer] Paused — no connectivity');
      } else if (wasPaused) {
        debugPrint('[QuranStreamer] Resumed — connectivity restored');
        _processQueue();
      }
    });

    _paused = await _connectivity.checkConnectivity().then(
          (r) => r.contains(ConnectivityResult.none),
        );

    await _restoreState();
  }

  Future<void> _restoreState() async {
    final batchStr =
        await IsarService.getDownloadStateValue('quran_last_batch_end');
    if (batchStr != null) {
      _lastBatchEnd = int.tryParse(batchStr) ?? 0;
      debugPrint('[QuranStreamer] Resumed from batch end: $_lastBatchEnd');

      // Re-queue failed pages that are still missing.
      final failedStr =
          await IsarService.getDownloadStateValue('quran_failed_pages');
      if (failedStr != null) {
        final failed = failedStr.split(',').where((s) => s.isNotEmpty);
        for (final p in failed) {
          final page = int.tryParse(p);
          if (page != null && page >= 1 && page <= totalPages) {
            final cached = await IsarService.getQuranSvgPage(page);
            if (cached == null) {
              _enqueueLow(page);
            }
          }
        }
        await IsarService.deleteDownloadStateKeys(['quran_failed_pages']);
      }
    }

    // Start or resume background batches.
    _scheduleNextBatch();
    _processQueue();
  }

  /// Call on app dispose.
  void dispose() {
    _disposed = true;
    _connectivitySub?.cancel();
  }

  // ─── Public API ──────────────────────────────────────────────────────────

  /// Returns the SVG content for [pageNumber] from cache, or from the CDN.
  ///
  /// This is the primary entry point for the UI layer.
  Future<String?> getPage(int pageNumber) async {
    if (_disposed) return null;
    // 1. Try Isar cache.
    final cached = await IsarService.getQuranSvgPage(pageNumber);
    if (cached != null) {
      final first100 = cached.svgContent.length > 100
          ? cached.svgContent.substring(0, 100)
          : cached.svgContent;
      debugPrint('[Cache] READ page $pageNumber: len=${cached.svgContent.length} first100="$first100"');
      return cached.svgContent;
    }
    debugPrint('[Cache] MISS page $pageNumber');
    // 2. Fetch from CDN with critical priority.
    debugPrint('[QuranStreamer] Priority download page $pageNumber');
    return _fetchWithPriority(pageNumber, DownloadPriority.critical);
  }

  /// Prefetch a range of pages at low priority (for background batches).
  void prefetchRange(int start, int end) {
    if (_disposed) return;
    for (var p = start; p <= end; p++) {
      if (p >= 1 && p <= totalPages && !_queuedPages.contains(p)) {
        _enqueueLow(p);
      }
    }
    _processQueue();
  }

  /// Ensure adjacent pages around [pageNumber] are preloaded.
  void prefetchAdjacent(int pageNumber) {
    if (_disposed) return;
    for (var offset = -2; offset <= 2; offset++) {
      final p = pageNumber + offset;
      if (p >= 1 && p <= totalPages && !_queuedPages.contains(p)) {
        _enqueueHigh(p);
      }
    }
    _processQueue();
  }

  /// Start or resume background batch download from where we left off.
  void startBackgroundDownload() {
    if (_disposed) return;
    _scheduleNextBatch();
    _processQueue();
  }

  /// Total number of pages currently cached.
  Future<int> getCachedCount() => IsarService.getCachedPageCount();

  // ─── Priority Enqueue ───────────────────────────────────────────────────

  Future<String?> _fetchWithPriority(int page, DownloadPriority priority) {
    // Deduplicate in-flight requests.
    if (_inFlight.containsKey(page)) return _inFlight[page]!;

    final completer = Completer<String?>();
    final entry = _QueueEntry(pageNumber: page, priority: priority, completer: completer);
    _queuedPages.add(page);

    if (priority == DownloadPriority.critical) {
      _criticalQueue.add(entry);
    } else {
      _highQueue.add(entry);
    }

    _processQueue();
    return _inFlight[page] = completer.future;
  }

  void _enqueueLow(int page) {
    _queuedPages.add(page);
    _lowQueue.add(_QueueEntry(
      pageNumber: page,
      priority: DownloadPriority.low,
      completer: Completer<String?>(),
    ));
  }

  void _enqueueHigh(int page) {
    _queuedPages.add(page);
    _highQueue.add(_QueueEntry(
      pageNumber: page,
      priority: DownloadPriority.high,
      completer: Completer<String?>(),
    ));
  }

  // ─── Queue Processing ───────────────────────────────────────────────────

  Future<void> _processQueue() async {
    if (_processing || _paused || _disposed) return;
    _processing = true;

    try {
      while ((_criticalQueue.isNotEmpty ||
              _highQueue.isNotEmpty ||
              _lowQueue.isNotEmpty) &&
          !_paused &&
          !_disposed) {
        _QueueEntry? entry;

        // Critical always first.
        if (_criticalQueue.isNotEmpty) {
          entry = _criticalQueue.removeFirst();
        } else if (_highQueue.isNotEmpty) {
          // Check if a batch page became critical since enqueue.
          entry = _highQueue.removeFirst();
        } else if (_lowQueue.isNotEmpty) {
          entry = _lowQueue.removeFirst();
        }

        if (entry == null) break;

        // Skip if already cached.
        final cached = await IsarService.getQuranSvgPage(entry.pageNumber);
        if (cached != null) {
          debugPrint('[Cache] READ (queue skip) page ${entry.pageNumber}: len=${cached.svgContent.length}');
          entry.completer.complete(cached.svgContent);
          _inFlight.remove(entry.pageNumber);
          _queuedPages.remove(entry.pageNumber);
          continue;
        }

        try {
          final content = await _downloadWithRetry(entry);
          _queuedPages.remove(entry.pageNumber);
          _inFlight.remove(entry.pageNumber);
          if (!entry.completer.isCompleted) {
            entry.completer.complete(content);
          }
          // Check batch completion and schedule next batch.
          await onPageDownloaded(entry.pageNumber);
        } catch (e) {
          _queuedPages.remove(entry.pageNumber);
          _inFlight.remove(entry.pageNumber);
          if (!entry.completer.isCompleted) {
            entry.completer.complete(null);
          }
          debugPrint('[QuranStreamer] Failed page ${entry.pageNumber}: $e');
          // Persist failed page for retry on next launch.
          await _persistFailedPage(entry.pageNumber);
        }
      }
    } finally {
      _processing = false;
    }
  }

  // ─── Download with retry ────────────────────────────────────────────────

  Future<String> _downloadWithRetry(_QueueEntry entry) async {
    final delays = [1000, 2000, 4000, 8000, 16000];

    for (var attempt = 0; attempt <= delays.length; attempt++) {
      if (_disposed) throw Exception('Streamer disposed');

      if (entry.priority != DownloadPriority.critical) {
        // Low-priority: don't retry as aggressively.
        if (attempt >= 3) throw Exception('Max retries exhausted');
      }

      try {
        debugPrint('[HTTP] GET ${_pageUrl(entry.pageNumber)}');
        final response = await _dio.get<List<int>>(
          _pageUrl(entry.pageNumber),
          options: Options(responseType: ResponseType.bytes),
        );

        // ── HTTP Response logging ──
        debugPrint('[HTTP] Status: ${response.statusCode}');
        debugPrint('[HTTP] Headers: ${response.headers.map}');
        final contentType = response.headers.value('content-type');
        final contentLength = response.headers.value('content-length');
        final realLength = response.data?.length;
        debugPrint('[HTTP] Content-Type: $contentType');
        debugPrint('[HTTP] Content-Length (header): $contentLength');
        debugPrint('[HTTP] Content-Length (actual bytes): $realLength');
        if (response.redirects.isNotEmpty) {
          debugPrint('[HTTP] Redirects: ${response.redirects.map((r) => r.location).toList()}');
        }

        if (response.statusCode == 200 && response.data != null) {
          final bytes = response.data!;
          // Use utf8.decode for correctness; allowMalformed prevents crash on
          // rare byte sequences. String.fromCharCodes would treat multi-byte
          // UTF-8 sequences as Latin-1, corrupting non-ASCII characters.
          final content = utf8.decode(bytes, allowMalformed: true);

          // ── Content validation logging ──
          final first200 = content.length > 200 ? content.substring(0, 200) : content;
          final last100 = content.length > 100 ? content.substring(content.length - 100) : content;
          debugPrint('[Content] Page ${entry.pageNumber}: bytes=${bytes.length} stringLen=${content.length}');
          debugPrint('[Content] First 200 chars: $first200');
          debugPrint('[Content] Last 100 chars: $last100');

          if (content.contains('<svg') || content.contains('<?xml')) {
            // ── Cache write logging ──
            try {
              await IsarService.putQuranSvgPage(entry.pageNumber, content);
              debugPrint('[Cache] WRITE page ${entry.pageNumber}: OK (len=${content.length})');
            } catch (e, st) {
              debugPrint('[Cache] WRITE page ${entry.pageNumber}: FAILED — $e\n$st');
              rethrow;
            }
            return content;
          }
          debugPrint('[Content] Page ${entry.pageNumber}: INVALID — no <svg or <?xml found');
          debugPrint('[Content] Page ${entry.pageNumber} first 500 chars: ${content.length > 500 ? content.substring(0, 500) : content}');
          throw Exception('Invalid SVG content');
        }
        throw Exception('HTTP ${response.statusCode}');
      } on DioException catch (e, st) {
        debugPrint('[HTTP] DioException page ${entry.pageNumber} attempt $attempt:');
        debugPrint('[HTTP]   type    : ${e.type}');
        debugPrint('[HTTP]   message : ${e.message}');
        debugPrint('[HTTP]   error   : ${e.error}');
        debugPrint('[HTTP]   status  : ${e.response?.statusCode}');
        debugPrint('[HTTP]   headers : ${e.response?.headers.map}');
        debugPrint('[HTTP]   stack   : $st');
        final shouldRetry = _shouldRetry(e) && attempt < delays.length - 1;
        if (!shouldRetry) rethrow;
        final delay = delays[attempt.clamp(0, delays.length - 1)];
        debugPrint('[QuranStreamer] Retry ${attempt + 1}/${delays.length} '
            'page ${entry.pageNumber} in ${delay}ms');
        await Future.delayed(Duration(milliseconds: delay));
      } catch (e, st) {
        debugPrint('[HTTP] Non-Dio exception page ${entry.pageNumber} attempt $attempt: $e\n$st');
        rethrow;
      }
    }
    throw Exception('Max retries exhausted');
  }

  bool _shouldRetry(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return true;
      // Do NOT retry bad certificates — they will never succeed without a fix.
      case DioExceptionType.badCertificate:
        debugPrint('[HTTP] badCertificate — NOT retrying: ${err.error}');
        return false;
      case DioExceptionType.badResponse:
        return err.response?.statusCode != null && err.response!.statusCode! >= 500;
      default:
        return false;
    }
  }

  // ─── Batch scheduling ───────────────────────────────────────────────────

  void _scheduleNextBatch() {
    if (_lastBatchEnd >= totalPages) {
      debugPrint('[QuranStreamer] All pages downloaded');
      return;
    }
    // Skip pages that are already cached.
    final start = _lastBatchEnd + 1;
    if (start > totalPages) return;
    final end = (start + batchSize - 1).clamp(1, totalPages);

    debugPrint('[QuranStreamer] Scheduling batch $start–$end');
    prefetchRange(start, end);

    // Update persisted state immediately.
    _persistBatchEnd(end);
  }

  Future<void> _persistBatchEnd(int end) async {
    _lastBatchEnd = end;
    await IsarService.putDownloadStateValue('quran_last_batch_end', end.toString());
  }

  Future<void> _persistFailedPage(int page) async {
    final existing =
        await IsarService.getDownloadStateValue('quran_failed_pages');
    final failed = <int>{};
    if (existing != null && existing.isNotEmpty) {
      failed.addAll(existing.split(',').map((s) => int.tryParse(s) ?? 0));
    }
    failed.add(page);
    await IsarService.putDownloadStateValue(
        'quran_failed_pages', failed.join(','));
  }

  // ─── Batch completion hook ──────────────────────────────────────────────

  /// Called after a batch page downloads. Checks if the batch is complete
  /// and schedules the next one.
  Future<void> onPageDownloaded(int page) async {
    final start = _lastBatchEnd - batchSize + 1;
    final end = _lastBatchEnd;
    if (page >= start && page <= end) {
      final allCached = await Future.wait(
        List.generate(end - start + 1, (i) => IsarService.getQuranSvgPage(start + i))
            .map((f) => f.then((p) => p != null)),
      );
      if (allCached.every((c) => c)) {
        debugPrint('[QuranStreamer] Batch $start–$end completed');
        _scheduleNextBatch();
      }
    }
  }

  /// Call when user navigates to a page — updates high-priority prefetch.
  void onPageChanged(int pageNumber) {
    if (_disposed) return;
    prefetchAdjacent(pageNumber);
  }
}

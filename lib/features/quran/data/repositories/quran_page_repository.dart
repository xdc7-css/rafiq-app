import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../datasources/quran_remote_datasource.dart';
import '../datasources/cache/quran_cache_data_source.dart';

/// Repository that coordinates remote downloads and local cache for Quran
/// SVG pages. Platform-agnostic — works on native and web.
class QuranPageRepository {
  QuranPageRepository({
    QuranRemoteDataSource? remote,
    QuranCacheDataSource? cache,
  })  : _remote = remote ?? QuranRemoteDataSource(),
        _cache = cache ?? createQuranCacheDataSource();

  final QuranRemoteDataSource _remote;
  final QuranCacheDataSource _cache;

  /// Whether all 604 pages are available locally.
  Future<bool> isQuranDownloaded() => _cache.isFullyDownloaded();

  /// Number of pages currently cached.
  Future<int> getDownloadedPagesCount() => _cache.getDownloadedPagesCount();

  /// Pages that still need to be downloaded.
  Future<List<int>> getMissingPages() => _cache.getMissingPages();

  /// Returns the SVG content string for a page (cross-platform).
  Future<String?> getPageContent(int pageNumber) =>
      _cache.loadPageContent(pageNumber);

  /// Returns a native File reference (null on web).
  Future<dynamic> getPageFile(int pageNumber) =>
      _cache.loadPageFile(pageNumber);

  /// Whether a specific page exists in cache.
  Future<bool> pageExists(int pageNumber) => _cache.pageExists(pageNumber);

  /// Downloads all missing pages and reports progress via [onProgress].
  ///
  /// [onProgress] receives (successfullyDownloadedCount, totalMissingPages, lastSuccessfulPage).
  /// Only successfully saved pages count toward progress.
  Future<void> downloadAllPages({
    void Function(int downloaded, int total, int currentPage)? onProgress,
    CancelToken? cancelToken,
  }) async {
    final missing = await _cache.getMissingPages();
    final total = missing.length;
    debugPrint('[QuranPageRepository] Starting download: $total missing pages');

    int downloaded = 0;
    const batchSize = 6;
    final errors = <int, String>{};

    for (var i = 0; i < missing.length; i += batchSize) {
      if (cancelToken?.isCancelled == true) {
        debugPrint('[QuranPageRepository] Download cancelled');
        break;
      }

      final batch = missing.sublist(
        i,
        (i + batchSize).clamp(0, missing.length),
      );

      final results = await Future.wait(
        batch.map((page) async {
          try {
            final bytes = await _remote.downloadPage(page);
            if (!_validateSvgBytes(bytes, page)) {
              return _BatchResult(page, false, 'Invalid SVG content');
            }
            await _cache.savePage(page, bytes);
            return _BatchResult(page, true, null);
          } catch (e) {
            return _BatchResult(page, false, e.toString());
          }
        }),
      );

      for (final result in results) {
        if (result.success) {
          downloaded++;
          onProgress?.call(downloaded, total, result.pageNumber);
        } else {
          errors[result.pageNumber] = result.error ?? 'Unknown error';
          debugPrint('[QuranPageRepository] Page ${result.pageNumber} failed: ${result.error}');
        }
      }
    }

    if (errors.isNotEmpty) {
      debugPrint('[QuranPageRepository] ${errors.length} pages failed: ${errors.keys.toList()}');
    }

    final finalCount = await _cache.getDownloadedPagesCount();
    debugPrint('[QuranPageRepository] Download complete: $finalCount/604 pages');
  }

  /// Validates that downloaded bytes look like a valid SVG file.
  bool _validateSvgBytes(List<int> bytes, int pageNumber) {
    if (bytes.isEmpty) {
      debugPrint('[QuranPageRepository] Page $pageNumber: empty bytes');
      return false;
    }
    if (bytes.length < 100) {
      debugPrint('[QuranPageRepository] Page $pageNumber: suspiciously small (${bytes.length} bytes)');
      return false;
    }
    final header = String.fromCharCodes(bytes.take(500).where((b) => b < 128));
    if (!header.contains('<svg') && !header.contains('<?xml')) {
      debugPrint('[QuranPageRepository] Page $pageNumber: not an SVG file');
      return false;
    }
    return true;
  }

  /// Downloads a single page. Used for retry logic.
  Future<bool> downloadPage(int pageNumber) async {
    try {
      final bytes = await _remote.downloadPage(pageNumber);
      if (!_validateSvgBytes(bytes, pageNumber)) return false;
      await _cache.savePage(pageNumber, bytes);
      return true;
    } catch (e) {
      debugPrint('[QuranPageRepository] Single page download failed: $e');
      return false;
    }
  }

  /// Checks the remote version and compares with local.
  Future<QuranVersionInfo?> checkRemoteVersion() => _remote.fetchVersion();

  /// Deletes all cached Quran pages.
  Future<void> clearCache() => _cache.clearCache();

  /// Total size of cached files in bytes.
  Future<int> getCacheSize() => _cache.getCacheSize();

  /// Disposes the underlying HTTP client. Call when permanently done.
  void dispose() => _remote.dispose();
}

class _BatchResult {
  final int pageNumber;
  final bool success;
  final String? error;
  _BatchResult(this.pageNumber, this.success, this.error);
}

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'quran_cache_data_source.dart';

QuranCacheDataSource createImpl() => NativeQuranCacheDataSource();

/// Native (Android / iOS / Windows / macOS / Linux) cache backed by the
/// application documents directory.
class NativeQuranCacheDataSource implements QuranCacheDataSource {
  static const String _cacheDirName = 'quran_cache';
  static const int totalPages = 604;
  static const int _minValidSize = 100;

  Directory? _cacheDir;

  // ── Directory ──────────────────────────────────────────────────────────────

  Future<Directory> get _dir async {
    if (_cacheDir != null && await _cacheDir!.exists()) return _cacheDir!;
    final appDir = await getApplicationDocumentsDirectory();
    _cacheDir = Directory('${appDir.path}/$_cacheDirName');
    if (!await _cacheDir!.exists()) {
      await _cacheDir!.create(recursive: true);
    }
    return _cacheDir!;
  }

  Future<String> _pagePath(int page) async {
    final d = await _dir;
    return '${d.path}/${page.toString().padLeft(3, '0')}.svg';
  }

  // ── QuranCacheDataSource ───────────────────────────────────────────────────

  @override
  Future<void> initialize() async {
    await _dir;
    debugPrint('[NativeCache] Ready: ${_cacheDir?.path}');
  }

  @override
  Future<void> savePage(int pageNumber, List<int> bytes) async {
    final path = await _pagePath(pageNumber);
    await File(path).writeAsBytes(bytes, flush: true);
  }

  @override
  Future<bool> pageExists(int pageNumber) async {
    final path = await _pagePath(pageNumber);
    return File(path).exists();
  }

  @override
  Future<bool> validatePage(int pageNumber) async {
    final path = await _pagePath(pageNumber);
    final file = File(path);
    if (!await file.exists()) return false;

    final length = await file.length();
    if (length < _minValidSize) {
      await file.delete();
      debugPrint('[NativeCache] Deleted corrupt page $pageNumber (${length}B)');
      return false;
    }

    try {
      final sink = file.openRead(0, 500);
      final header = await sink
          .fold<StringBuffer>(StringBuffer(), (buf, chunk) {
            buf.write(String.fromCharCodes(
              chunk.where((b) => b < 128),
            ));
            return buf;
          })
          .then((buf) => buf.toString());

      if (!header.contains('<svg') && !header.contains('<?xml')) {
        await file.delete();
        debugPrint('[NativeCache] Deleted invalid-header page $pageNumber');
        return false;
      }
      return true;
    } catch (e) {
      debugPrint('[NativeCache] Validation error page $pageNumber: $e');
      return false;
    }
  }

  @override
  Future<int> getDownloadedPagesCount() async {
    final d = await _dir;
    if (!await d.exists()) return 0;
    return d
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.svg'))
        .length;
  }

  @override
  Future<bool> isFullyDownloaded() async {
    final count = await getDownloadedPagesCount();
    return count >= totalPages;
  }

  @override
  Future<List<int>> getMissingPages() async {
    final downloaded = <int>{};
    final d = await _dir;
    if (await d.exists()) {
      for (final entity in d.listSync()) {
        if (entity is File && entity.path.endsWith('.svg')) {
          final name = entity.uri.pathSegments.last;
          final num = int.tryParse(name.replaceAll('.svg', ''));
          if (num != null) downloaded.add(num);
        }
      }
    }
    return List.generate(totalPages, (i) => i + 1)
        .where((n) => !downloaded.contains(n))
        .toList();
  }

  @override
  Future<void> deletePage(int pageNumber) async {
    final path = await _pagePath(pageNumber);
    final file = File(path);
    if (await file.exists()) await file.delete();
  }

  @override
  Future<void> clearCache() async {
    final d = await _dir;
    if (await d.exists()) {
      await d.delete(recursive: true);
      _cacheDir = null;
    }
  }

  @override
  Future<int> getCacheSize() async {
    final d = await _dir;
    if (!await d.exists()) return 0;
    int total = 0;
    for (final entity in d.listSync()) {
      if (entity is File) total += await entity.length();
    }
    return total;
  }

  @override
  Future<String?> loadPageContent(int pageNumber) async {
    final path = await _pagePath(pageNumber);
    final file = File(path);
    if (!await file.exists()) return null;
    try {
      return file.readAsString();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<File?> loadPageFile(int pageNumber) async {
    final path = await _pagePath(pageNumber);
    final file = File(path);
    if (await file.exists()) return file;
    return null;
  }
}

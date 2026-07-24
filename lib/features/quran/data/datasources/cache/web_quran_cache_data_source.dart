// ignore_for_file: avoid_web_libraries_in_flutter
// This file is only compiled on web via conditional import.
import 'dart:async';
import 'dart:js_interop';
import 'package:web/web.dart' as web;
import 'package:flutter/foundation.dart';
import 'quran_cache_data_source.dart';

QuranCacheDataSource createImpl() => WebQuranCacheDataSource();

class WebQuranCacheDataSource implements QuranCacheDataSource {
  static const String _dbName = 'quran_cache_db';
  static const String _storeName = 'svg_pages';
  static const int _version = 1;
  static const int totalPages = 604;
  static const int _minValidSize = 100;

  web.IDBDatabase? _db;

  Future<web.IDBDatabase> _openDb() async {
    if (_db != null) return _db!;
    final c = Completer<web.IDBDatabase>();

    final dbFactory = web.window.indexedDB;
    final request = dbFactory.open(_dbName, _version);

    request.addEventListener('success', ((web.Event _) {
      _db = request.result as web.IDBDatabase;
      if (!c.isCompleted) c.complete(_db!);
    }).toJS);

    request.addEventListener('error', ((web.Event _) {
      if (!c.isCompleted) c.completeError('IndexedDB open failed');
    }).toJS);

    return c.future;
  }

  Future<web.IDBObjectStore> _txStore(String mode) async {
    final db = await _openDb();
    final tx = db.transaction(
      [_storeName.toJS].jsify()!,
      mode,
    );
    return tx.objectStore(_storeName);
  }

  Future<dynamic> _req(web.IDBRequest req) async {
    final c = Completer<dynamic>();
    req.addEventListener('success', ((web.Event _) {
      if (!c.isCompleted) c.complete(req.result);
    }).toJS);
    req.addEventListener('error', ((web.Event _) {
      if (!c.isCompleted) c.complete(null);
    }).toJS);
    return c.future;
  }

  @override
  Future<void> initialize() async {
    await _openDb();
    debugPrint('[WebCache] IndexedDB ready: $_dbName');
  }

  @override
  Future<void> savePage(int pageNumber, List<int> bytes) async {
    final content = String.fromCharCodes(bytes);
    final record = <String, dynamic>{
      'content': content,
      'size': content.length,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    final store = await _txStore('readwrite');
    await _req(store.put(record.jsify(), pageNumber.jsify()));
  }

  @override
  Future<bool> pageExists(int pageNumber) async {
    final store = await _txStore('readonly');
    final result = await _req(store.getKey(pageNumber.jsify()));
    return result != null;
  }

  @override
  Future<bool> validatePage(int pageNumber) async {
    final content = await loadPageContent(pageNumber);
    if (content == null) return false;
    if (content.length < _minValidSize) {
      await deletePage(pageNumber);
      return false;
    }
    if (!content.contains('<svg') && !content.contains('<?xml')) {
      await deletePage(pageNumber);
      return false;
    }
    return true;
  }

  @override
  Future<int> getDownloadedPagesCount() async {
    final store = await _txStore('readonly');
    final result = await _req(store.count());
    return (result as int?) ?? 0;
  }

  @override
  Future<bool> isFullyDownloaded() async =>
      (await getDownloadedPagesCount()) >= totalPages;

  @override
  Future<List<int>> getMissingPages() async {
    final store = await _txStore('readonly');
    final keys = await _req(store.getAllKeys());
    final downloaded = <int>{};
    if (keys is List) {
      for (final key in keys) {
        final num = int.tryParse(key.toString());
        if (num != null) downloaded.add(num);
      }
    }
    return List.generate(totalPages, (i) => i + 1)
        .where((n) => !downloaded.contains(n))
        .toList();
  }

  @override
  Future<void> deletePage(int pageNumber) async {
    final store = await _txStore('readwrite');
    await _req(store.delete(pageNumber.jsify()));
  }

  @override
  Future<void> clearCache() async {
    final store = await _txStore('readwrite');
    await _req(store.clear());
    debugPrint('[WebCache] Cache cleared');
  }

  @override
  Future<int> getCacheSize() async {
    final store = await _txStore('readonly');
    final values = await _req(store.getAll());
    int total = 0;
    if (values is List) {
      for (final item in values) {
        if (item is Map) total += (item['size'] as int?) ?? 0;
      }
    }
    return total;
  }

  @override
  Future<String?> loadPageContent(int pageNumber) async {
    final store = await _txStore('readonly');
    final result = await _req(store.get(pageNumber.jsify()));
    if (result is Map && result['content'] is String) {
      return result['content'] as String;
    }
    return null;
  }

  @override
  Future<dynamic> loadPageFile(int pageNumber) async => null;
}

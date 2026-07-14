import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class DownloadService {
  final http.Client _client = http.Client();
  final Map<String, _DownloadTask> _activeDownloads = {};

  String _key(int reciterId, int surahNumber) => '${reciterId}_$surahNumber';
  String _fileName(int reciterId, int surahNumber) =>
      'quran_${reciterId}_${surahNumber.toString().padLeft(3, '0')}.mp3';

  Future<Directory> _getDownloadDir() async {
    final dir = await getApplicationDocumentsDirectory();
    final downloadDir = Directory('${dir.path}/quran_audio');
    if (!await downloadDir.exists()) {
      await downloadDir.create(recursive: true);
    }
    return downloadDir;
  }

  Future<bool> isDownloaded(int reciterId, int surahNumber) async {
    final dir = await _getDownloadDir();
    final file = File('${dir.path}/${_fileName(reciterId, surahNumber)}');
    return await file.exists();
  }

  Future<String?> getLocalPath(int reciterId, int surahNumber) async {
    final dir = await _getDownloadDir();
    final file = File('${dir.path}/${_fileName(reciterId, surahNumber)}');
    if (await file.exists()) return file.path;
    return null;
  }

  Stream<double> downloadSurah(int reciterId, int surahNumber, String url) async* {
    final key = _key(reciterId, surahNumber);
    if (_activeDownloads.containsKey(key)) return;

    final completer = Completer<void>();
    final task = _DownloadTask(completer: completer);
    _activeDownloads[key] = task;

    try {
      final response = await _client.send(
        http.Request('GET', Uri.parse(url)),
      );

      if (response.statusCode != 200) {
        throw HttpException('Download failed: ${response.statusCode}');
      }

      final dir = await _getDownloadDir();
      final file = File('${dir.path}/${_fileName(reciterId, surahNumber)}');
      final sink = file.openWrite();

      final contentLength = response.contentLength ?? 0;
      var received = 0;

      await for (final chunk in response.stream) {
        if (task.cancelled) {
          await sink.close();
          await file.delete();
          yield -1;
          return;
        }
        sink.add(chunk);
        received += chunk.length;
        if (contentLength > 0) {
          yield received / contentLength;
        }
      }

      await sink.flush();
      await sink.close();
      yield 1.0;
    } finally {
      _activeDownloads.remove(key);
      if (!completer.isCompleted) completer.complete();
    }
  }

  Future<void> deleteDownload(int reciterId, int surahNumber) async {
    final dir = await _getDownloadDir();
    final file = File('${dir.path}/${_fileName(reciterId, surahNumber)}');
    if (await file.exists()) {
      await file.delete();
    }
  }

  void cancelDownload(int reciterId, int surahNumber) {
    final key = _key(reciterId, surahNumber);
    final task = _activeDownloads[key];
    if (task != null) {
      task.cancelled = true;
    }
  }

  bool isDownloading(int reciterId, int surahNumber) {
    return _activeDownloads.containsKey(_key(reciterId, surahNumber));
  }

  void dispose() {
    for (final task in _activeDownloads.values) {
      task.cancelled = true;
    }
    _activeDownloads.clear();
    _client.close();
  }
}

class _DownloadTask {
  final Completer<void> completer;
  bool cancelled = false;
  _DownloadTask({required this.completer});
}

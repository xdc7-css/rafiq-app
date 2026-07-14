import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/mafatih_models.dart';

class MafatihLoadException implements Exception {
  final String message;
  const MafatihLoadException(this.message);
  @override
  String toString() => message;
}

class MafatihLocalSource {
  List<MafatihChapter>? _cached;

  Future<List<MafatihChapter>> loadChapters() async {
    if (_cached != null) return _cached!;
    try {
      final raw = await rootBundle.loadString('assets/data/mafatih/chapters.json');
      final decoded = jsonDecode(raw) as List<dynamic>;
      final chapters = decoded
          .map((e) => MafatihChapter.fromJson(e as Map<String, dynamic>))
          .toList();
      _cached = chapters;
      return chapters;
    } on FormatException {
      throw const MafatihLoadException('خطأ في تنسيق ملف البيانات');
    } catch (e) {
      throw MafatihLoadException('فشل تحميل البيانات: $e');
    }
  }

  List<MafatihChapter>? get cached => _cached;

  void clearCache() {
    _cached = null;
  }
}

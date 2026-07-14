import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/aqwal_model.dart';

class AqwalLocalSource {
  List<AqwalModel>? _allAqwal;
  Map<String, List<AqwalModel>> _categorized = {};
  List<AqwalCategory>? _categories;

  static const _imamFiles = [
    'ali', 'hasan', 'hussain', 'sajjad',
    'baqir', 'sadiq', 'kadhim', 'rida',
    'jawad', 'hadi', 'askari', 'mahdi',
  ];

  static const _imamInfo = {
    1:  ('imam_ali',     'الإمام علي بن أبي طالب',      'علي'),
    2:  ('imam_hasan',   'الإمام الحسن المجتبى',       'الحسن'),
    3:  ('imam_hussain', 'الإمام الحسين سيد الشهداء',   'الحسين'),
    4:  ('imam_sajjad',  'الإمام زين العابدين',        'زين العابدين'),
    5:  ('imam_baqir',   'الإمام محمد الباقر',         'الباقر'),
    6:  ('imam_sadiq',   'الإمام جعفر الصادق',         'الصادق'),
    7:  ('imam_kadhim',  'الإمام موسى الكاظم',         'الكاظم'),
    8:  ('imam_rida',    'الإمام علي الرضا',           'الرضا'),
    9:  ('imam_jawad',   'الإمام محمد الجواد',         'الجواد'),
    10: ('imam_hadi',    'الإمام علي الهادي',          'الهادي'),
    11: ('imam_askari',  'الإمام الحسن العسكري',       'العسكري'),
    12: ('imam_mahdi',   'الإمام المهدي المنتظر',      'المهدي'),
  };

  List<AqwalCategory> get categories {
    if (_categories != null) return _categories!;
    _categories = _imamInfo.entries.map((e) => AqwalCategory(
      id: e.value.$1,
      name: e.value.$2,
      shortName: e.value.$3,
      imamId: e.key,
    )).toList();
    return _categories!;
  }

  Future<List<AqwalModel>> loadAll() async {
    if (_allAqwal != null) return _allAqwal!;
    final List<AqwalModel> all = [];
    for (final f in _imamFiles) {
      try {
        final data = await rootBundle.loadString('assets/data/imams/quotes/$f.json');
        final List<dynamic> jsonList = json.decode(data);
        for (final e in jsonList) {
          all.add(AqwalModel.fromJson(e as Map<String, dynamic>));
        }
      } catch (_) {}
    }
    _allAqwal = all;
    _categorized = {};
    for (final a in _allAqwal!) {
      final cid = _imamInfo[a.imamId]?.$1 ?? 'unknown';
      _categorized.putIfAbsent(cid, () => []).add(a);
    }
    return _allAqwal!;
  }

  Future<List<AqwalModel>> getByCategory(String categoryId) async {
    await loadAll();
    return _categorized[categoryId] ?? [];
  }

  List<AqwalModel> getCachedByCategory(String categoryId) {
    return _categorized[categoryId] ?? [];
  }

  Future<List<AqwalModel>> search(String query) async {
    await loadAll();
    final q = query.trim();
    if (q.isEmpty) return [];
    return _allAqwal!
        .where((a) =>
            a.text.contains(q) ||
            a.topic.contains(q) ||
            a.tags.any((t) => t.contains(q)))
        .take(50)
        .toList();
  }

  AqwalModel? getDailyQawal() {
    if (_allAqwal == null || _allAqwal!.isEmpty) return null;
    final day = DateTime.now().millisecondsSinceEpoch ~/ 86400000;
    return _allAqwal![day % _allAqwal!.length];
  }

  int get totalCount => _allAqwal?.length ?? 0;

  void clearCache() {
    _allAqwal = null;
    _categorized.clear();
    _categories = null;
  }
}

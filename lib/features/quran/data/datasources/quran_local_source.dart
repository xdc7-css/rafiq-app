import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/surah_model.dart';

class QuranLocalSource {
  List<SurahModel>? _surahs;
  List<AyahModel>? _allAyahs;
  List<SajdaModel>? _sajdas;
  final Map<int, List<AyahModel>> _surahAyahs = {};

  Future<List<SurahModel>> loadSurahNames() async {
    if (_surahs != null) return _surahs!;
    try {
      final data = await rootBundle.loadString(AppConstants.surahNamesAssetPath);
      final List<dynamic> jsonList = json.decode(data);
      _surahs = jsonList.map((e) {
        final map = e as Map<String, dynamic>;
        return SurahModel(
          number: int.tryParse(map['number']?.toString() ?? '0') ?? 0,
          name: map['name'] ?? '',
          numberOfAyahs: 0,
          revelationType: '',
        );
      }).toList();
      return _surahs!;
    } catch (e) {
      throw JsonParseException(message: 'فشل تحميل أسماء السور', dataPath: AppConstants.surahNamesAssetPath);
    }
  }

  Future<List<AyahModel>> loadSurahAyahs(int surahNumber) async {
    if (_surahAyahs.containsKey(surahNumber)) {
      return _surahAyahs[surahNumber]!;
    }
    await _loadHafsQuran();
    return _surahAyahs[surahNumber] ?? [];
  }

  Future<List<AyahModel>> loadAllAyahs() async {
    if (_allAyahs != null) return _allAyahs!;
    await _loadHafsQuran();
    return _allAyahs ?? [];
  }

  Future<void> _loadHafsQuran() async {
    if (_allAyahs != null) return;
    try {
      final data = await rootBundle.loadString(AppConstants.hafsAssetPath);
      final List<dynamic> jsonList = json.decode(data);
      final allAyahs = <AyahModel>[];
      final surahMap = <int, List<AyahModel>>{};
      for (final entry in jsonList) {
        final map = entry as Map<String, dynamic>;
        final surahNum = map['sura_no'] ?? 0;
        final ayah = AyahModel(
          number: map['id'] ?? 0,
          numberInSurah: map['aya_no'] ?? 0,
          surahNumber: surahNum,
          text: map['aya_text'] ?? '',
          juz: map['jozz'] ?? 1,
          page: map['page'] ?? 1,
          hizbQuarter: 1,
          ruku: 1,
          manzil: 1,
        );
        allAyahs.add(ayah);
        surahMap.putIfAbsent(surahNum, () => []).add(ayah);
      }
      _surahAyahs.addAll(surahMap);
      _allAyahs = allAyahs;
    } catch (e) {
      throw JsonParseException(message: 'فشل تحميل القرآن', dataPath: AppConstants.hafsAssetPath);
    }
  }

  Future<List<SajdaModel>> loadSajdas() async {
    if (_sajdas != null) return _sajdas!;
    try {
      final data = await rootBundle.loadString(AppConstants.sejdaAssetPath);
      final Map<String, dynamic> jsonMap = json.decode(data);
      final ayahs = jsonMap['data']?['ayahs'] as List<dynamic>? ?? [];
      _sajdas = ayahs.map((e) => SajdaModel.fromJson(e as Map<String, dynamic>)).toList();
      return _sajdas!;
    } catch (e) {
      throw JsonParseException(message: 'فشل تحميل مواضع السجود', dataPath: AppConstants.sejdaAssetPath);
    }
  }

  Future<Map<int, List<AyahModel>>> getAyahsByJuz() async {
    await loadAllAyahs();
    final Map<int, List<AyahModel>> result = {};
    for (final ayah in _allAyahs ?? []) {
      result.putIfAbsent(ayah.juz, () => []).add(ayah);
    }
    return result;
  }

  Future<Map<int, List<AyahModel>>> getAyahsByPage() async {
    await loadAllAyahs();
    final Map<int, List<AyahModel>> result = {};
    for (final ayah in _allAyahs ?? []) {
      result.putIfAbsent(ayah.page, () => []).add(ayah);
    }
    return result;
  }

  Future<List<AyahModel>> searchAyahs(String query) async {
    await loadAllAyahs();
    final q = query.trim();
    if (q.isEmpty) return [];
    return _allAyahs!
        .where((a) => a.text.contains(q))
        .take(50)
        .toList();
  }

  void clearCache() {
    _surahs = null;
    _allAyahs = null;
    _sajdas = null;
    _surahAyahs.clear();
  }
}

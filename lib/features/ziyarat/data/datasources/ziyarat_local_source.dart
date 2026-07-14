import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/ziyarat_models.dart';

class ZiyaratLocalSource {
  List<ZiyaratModel>? _ziyarat;
  List<DuaModel>? _duas;
  List<SahifaModel>? _sahifa;
  List<MafatihSection>? _mafatih;
  List<IslamicOccasion>? _occasions;

  Future<List<ZiyaratModel>> loadZiyarat() async {
    if (_ziyarat != null) return _ziyarat!;
    final json = await rootBundle.loadString('assets/data/ziyarat/ziyarat.json');
    final list = (jsonDecode(json) as List).cast<Map<String, dynamic>>();
    _ziyarat = list.map((e) => ZiyaratModel.fromJson(e)).toList();
    return _ziyarat!;
  }

  Future<List<DuaModel>> loadDuas() async {
    if (_duas != null) return _duas!;
    final json = await rootBundle.loadString('assets/data/duas/duas.json');
    final list = (jsonDecode(json) as List).cast<Map<String, dynamic>>();
    _duas = list.map((e) => DuaModel.fromJson(e)).toList();
    return _duas!;
  }

  Future<List<SahifaModel>> loadSahifa() async {
    if (_sahifa != null) return _sahifa!;
    final json = await rootBundle.loadString('assets/data/sahifa/sahifa.json');
    final list = (jsonDecode(json) as List).cast<Map<String, dynamic>>();
    _sahifa = list.map((e) => SahifaModel.fromJson(e)).toList();
    return _sahifa!;
  }

  Future<List<MafatihSection>> loadMafatih() async {
    if (_mafatih != null) return _mafatih!;
    final json = await rootBundle.loadString('assets/data/mafatih/mafatih.json');
    final list = (jsonDecode(json) as List).cast<Map<String, dynamic>>();
    _mafatih = list.map((e) => MafatihSection.fromJson(e)).toList();
    return _mafatih!;
  }

  Future<List<IslamicOccasion>> loadOccasions() async {
    if (_occasions != null) return _occasions!;
    final json = await rootBundle.loadString('assets/data/occasions/occasions.json');
    final list = (jsonDecode(json) as List).cast<Map<String, dynamic>>();
    _occasions = list.map((e) => IslamicOccasion.fromJson(e)).toList();
    return _occasions!;
  }

  void clearCache() {
    _ziyarat = null;
    _duas = null;
    _sahifa = null;
    _mafatih = null;
    _occasions = null;
  }
}

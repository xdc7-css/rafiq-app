import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../datasources/quran_local_source.dart';
import '../datasources/quran_api_source.dart';
import '../models/surah_model.dart';

final quranLocalSourceProvider = Provider<QuranLocalSource>((ref) => QuranLocalSource());
final quranApiSourceProvider = Provider<QuranApiSource>((ref) => QuranApiSource());

class QuranRepository {
  final QuranLocalSource _local;
  final QuranApiSource _api;

  QuranRepository(this._local, this._api);

  Future<List<SurahModel>> getSurahs() async {
    try {
      return await _local.loadSurahNames();
    } catch (_) {
      return await _api.fetchSurahs();
    }
  }

  Future<List<AyahModel>> getSurahAyahs(int number) async {
    try {
      return await _local.loadSurahAyahs(number);
    } catch (_) {
      return await _api.fetchSurah(number);
    }
  }

  Future<List<AyahModel>> getAllAyahs() async {
    return await _local.loadAllAyahs();
  }

  Future<List<SajdaModel>> getSajdas() async {
    return await _local.loadSajdas();
  }

  Future<List<AyahModel>> getJuzAyahs(int number) async {
    try {
      final byJuz = await _local.getAyahsByJuz();
      return byJuz[number] ?? [];
    } catch (_) {
      return await _api.fetchJuz(number);
    }
  }

  Future<List<AyahModel>> getPageAyahs(int page) async {
    final byPage = await _local.getAyahsByPage();
    return byPage[page] ?? [];
  }

  Future<List<AyahModel>> searchAyahs(String query) async {
    return await _local.searchAyahs(query);
  }

  Future<Map<String, dynamic>> getDailyAyah() async {
    return await _api.getDailyAyah();
  }

  Future<ReciterModel?> getReciter(String id) async {
    try {
      final response = await http.get(
        Uri.parse('https://mp3quran.net/api/v3/reciters?language=en'),
      ).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final reciters = data['reciters'] as List<dynamic>? ?? [];
        for (final r in reciters) {
          final map = r as Map<String, dynamic>;
          if (map['id'].toString() == id) {
            final moshafList = (map['moshaf'] as List<dynamic>?) ?? [];
            final moshaf = moshafList.isNotEmpty
                ? moshafList.first as Map<String, dynamic>
                : null;
            return ReciterModel(
              id: id,
              name: map['name'] ?? '',
              arabicName: map['letter'] ?? '',
              style: moshaf?['name'] ?? '',
              baseUrl: moshaf?['server'] ?? '',
              availableSurahs: List.generate(114, (i) => i + 1),
            );
          }
        }
      }
    } catch (_) {}
    return null;
  }

  String getAudioUrl(String reciterId, int surahNumber, int ayahNumber) {
    return 'https://everyayah.com/data/$reciterId/${surahNumber.toString().padLeft(3, '0')}${ayahNumber.toString().padLeft(3, '0')}.mp3';
  }
}

final quranRepositoryProvider = Provider<QuranRepository>((ref) {
  return QuranRepository(
    ref.watch(quranLocalSourceProvider),
    ref.watch(quranApiSourceProvider),
  );
});

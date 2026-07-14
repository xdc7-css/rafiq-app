import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/surah_model.dart';

class QuranApiSource {
  final http.Client _client;
  QuranApiSource({http.Client? client}) : _client = client ?? http.Client();

  Future<List<SurahModel>> fetchSurahs() async {
    try {
      final response = await _client
          .get(Uri.parse('${ApiConstants.baseUrl}/surah'))
          .timeout(ApiConstants.timeout);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final surahsList = data['data'] as List<dynamic>? ?? [];
        return surahsList.map((e) {
          final s = e as Map<String, dynamic>;
          return SurahModel(
            number: s['number'] ?? 0,
            name: s['name'] ?? '',
            numberOfAyahs: s['numberOfAyahs'] ?? 0,
            revelationType: s['revelationType'] ?? '',
          );
        }).toList();
      }
      throw ServerException(message: 'فشل جلب السور', statusCode: response.statusCode);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException(message: 'لا يمكن الاتصال بالخادم');
    }
  }

  Future<List<AyahModel>> fetchSurah(int number) async {
    try {
      final response = await _client
          .get(Uri.parse('${ApiConstants.baseUrl}/surah/$number/quran-uthmani'))
          .timeout(ApiConstants.timeout);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final ayahsList = data['data']?['ayahs'] as List<dynamic>? ?? [];
        return ayahsList.map((e) => AyahModel.fromJson(e as Map<String, dynamic>)).toList();
      }
      throw ServerException(message: 'فشل جلب السورة', statusCode: response.statusCode);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException(message: 'لا يمكن الاتصال بالخادم');
    }
  }

  Future<List<AyahModel>> fetchJuz(int number) async {
    try {
      final response = await _client
          .get(Uri.parse('${ApiConstants.baseUrl}/juz/$number/quran-uthmani'))
          .timeout(ApiConstants.timeout);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final ayahsList = data['data']?['ayahs'] as List<dynamic>? ?? [];
        return ayahsList.map((e) => AyahModel.fromJson(e as Map<String, dynamic>)).toList();
      }
      throw ServerException(message: 'فشل جلب الجزء', statusCode: response.statusCode);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException(message: 'لا يمكن الاتصال بالخادم');
    }
  }

  Future<Map<String, dynamic>> getDailyAyah() async {
    try {
      final response = await _client
          .get(Uri.parse(
              '${ApiConstants.baseUrl}/ayah/random/editions/quran-uthmani,en.sahih'))
          .timeout(ApiConstants.timeout);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final editions = data['data'] as List<dynamic>? ?? [];
        if (editions.length >= 2) {
          final arabic = editions[0] as Map<String, dynamic>;
          final english = editions[1] as Map<String, dynamic>;
          final surah = arabic['surah'] as Map<String, dynamic>? ?? {};
          return {
            'text': arabic['text'] ?? '',
            'english': english['text'] ?? '',
            'surahName': surah['name'] ?? '',
            'surahNumber': surah['number'] ?? 0,
            'verseNumber': arabic['numberInSurah'] ?? 0,
            'juz': arabic['juz'] ?? 1,
          };
        }
      }
      return {};
    } catch (_) {
      return {};
    }
  }

  void dispose() => _client.close();
}

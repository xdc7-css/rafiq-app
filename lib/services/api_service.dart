import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/api_models.dart';

class AlQuranApiService {
  static const String _baseUrl = 'https://api.alquran.cloud/v1';

  static Future<RandomAyahResponse?> getRandomAyah() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/ayah/random/en.sahih'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return RandomAyahResponse.fromJson(data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<List<AyahData>?> getRandomAyahEditions() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/ayah/random/editions/quran-uthmani,en.sahih'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final ayahData = AyahEditionsResponse.fromJson(data);
        return ayahData.data;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<SurahResponse?> getSurah(int number) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/surah/$number'),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return SurahResponse.fromJson(data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<List<SurahInfo>?> getAllSurahs() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/surah'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final surahsData = SurahsListResponse.fromJson(data);
        return surahsData.data;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<AyahEditionsResponse?> getAyahEditions(int number) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/ayah/$number/editions/quran-uthmani,en.sahih'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return AyahEditionsResponse.fromJson(data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<SearchResponse?> searchQuran(String word) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/search/$word/all/en'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return SearchResponse.fromJson(data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<JuzResponse?> getJuz(int number) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/juz/$number'),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return JuzResponse.fromJson(data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}

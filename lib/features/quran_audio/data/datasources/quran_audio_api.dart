import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quran_audio_models.dart';

class QuranAudioApi {
  static const _baseUrl = 'https://mp3quran.net/api/v3';
  final http.Client _client;

  QuranAudioApi({http.Client? client}) : _client = client ?? http.Client();

  Future<List<QuranReciter>> fetchReciters({String language = 'ar'}) async {
    final uri = Uri.parse('$_baseUrl/reciters?language=$language');
    final response = await _client.get(uri).timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final body = json.decode(response.body) as Map<String, dynamic>;
      final list = body['reciters'] as List<dynamic>? ?? [];
      return list
          .map((e) => QuranReciter.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw QuranAudioException(
      'فشل تحميل القراء (${response.statusCode})',
      response.statusCode,
    );
  }

  Future<List<QuranReciter>> searchReciters(String query, {String language = 'ar'}) async {
    final all = await fetchReciters(language: language);
    if (query.isEmpty) return all;
    final q = query.trim();
    return all.where((r) =>
      r.name.contains(q) ||
      r.riwayah.contains(q) ||
      r.letter.contains(q)
    ).toList();
  }

  void dispose() {
    _client.close();
  }
}

class QuranAudioException implements Exception {
  final String message;
  final int? statusCode;
  const QuranAudioException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

import 'package:http/http.dart' as http;
import '../../domain/entities/fatwa_entity.dart';

class FatwaRemoteDataSource {
  static const String _searchUrl = 'https://www.sistani.org/arabic/search/';
  static const String _qaUrl = 'https://www.sistani.org/arabic/qa/';

  final http.Client _client;

  FatwaRemoteDataSource({http.Client? client})
      : _client = client ?? http.Client();

  Future<List<FatwaEntity>> searchOfficialSite(String query) async {
    try {
      final response = await _client
          .get(
            Uri.parse('$_searchUrl?q=${Uri.encodeComponent(query)}'),
            headers: _headers,
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return _parseSearchResults(response.body, query);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Map<String, String> get _headers => {
        'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
        'Accept': 'text/html,application/xhtml+xml',
        'Accept-Language': 'ar,en;q=0.9',
      };

  List<FatwaEntity> _parseSearchResults(String html, String query) {
    final fatwas = <FatwaEntity>[];
    try {
      final questionPattern = RegExp(
        '<div class="question">(.*?)</div>',
        dotAll: true,
      );
      final answerPattern = RegExp(
        '<div class="answer">(.*?)</div>',
        dotAll: true,
      );

      final questions = questionPattern.allMatches(html);
      final answers = answerPattern.allMatches(html);

      final minLen = [questions.length, answers.length]
          .reduce((a, b) => a < b ? a : b);

      for (int i = 0; i < minLen && i < 10; i++) {
        final question = _stripHtml(questions.elementAt(i).group(1) ?? '');
        final answer = _stripHtml(answers.elementAt(i).group(1) ?? '');

        if (question.isNotEmpty && answer.isNotEmpty) {
          fatwas.add(FatwaEntity(
            id: 'remote_${DateTime.now().millisecondsSinceEpoch}_$i',
            categoryId: '',
            categoryName: 'بحث عام',
            question: question,
            answer: answer,
            keywords: query.split(' '),
            sourceUrl: _qaUrl,
            date: '',
          ));
        }
      }
    } catch (_) {}

    return fatwas;
  }

  String _stripHtml(String html) {
    return html
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&quot;', '"')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .trim();
  }

  void dispose() {
    _client.close();
  }
}

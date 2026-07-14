import '../data/models/fatwa_model.dart';
import '../domain/repositories/fatwa_repository.dart';

class FatwaIndex {
  final List<FatwaModel> _fatwas = [];
  final Map<String, Set<int>> _wordIndex = {};
  final Map<String, Set<int>> _categoryIndex = {};
  final Map<String, Set<int>> _keywordIndex = {};
  final Map<String, Set<int>> _rootIndex = {};
  final Map<String, double> _popularity = {};
  final List<String> _allWords = [];
  final Set<String> _allCategories = {};
  final Map<String, String> _categoryNameById = {};
  final Map<String, String> _categoryIdByName = {};

  static const _stopWords = {
    'هل',
    'ما',
    'لا',
    'لم',
    'لن',
    'لما',
    'إن',
    'أن',
    'إنما',
    'إذا',
    'إذ',
    'حين',
    'عند',
    'فقد',
    'قد',
    'لقد',
    'سوف',
    'سي',
    'كان',
    'كانت',
    'يكون',
    'لكن',
    'بل',
    'أما',
    'بعد',
    'قبل',
    'أمام',
    'وراء',
    'فوق',
    'تحت',
    'على',
    'إلى',
    'في',
    'من',
    'عن',
    'مع',
    'بين',
    'خلال',
    'دون',
    'غير',
    'مثل',
    'كل',
    'بعض',
    'أي',
    'الذي',
    'التي',
    'الذين',
    'هذا',
    'هذه',
    'ذلك',
    'تلك',
    'هو',
    'هي',
    'هم',
    'هن',
    'أنا',
    'نحن',
    'أنت',
    'أنتم',
    'أنتما',
    'هما',
    'ثم',
    'أو',
    'أم',
    'ل',
    'ب',
    'و',
    'ف',
    'س',
    'بال',
    'فل',
    'ول',
    'اللهم',
    'بلى',
    'نعم',
    'كلا',
    'لعل',
    'رب',
    'ليت',
    'لولا',
    'لو',
    'كأن',
    'هلا',
    'ألا',
    'ألم',
    'أ',
    'إلا',
    'حاشا',
    'ليس',
    'ليسوا',
    'ليست',
    'كم',
    'كيف',
    'أين',
    'متى',
    'أيان',
    'حيث',
    'هنا',
    'هناك',
    'ماذا',
    'لماذا',
    'بماذا',
    'علي',
    'علينا',
    'عليك',
    'عليكم',
    'عنها',
    'عنهم',
    'منا',
    'منك',
    'بي',
    'بنا',
    'بك',
    'بكم',
    'به',
    'بها',
    'بهم',
    'لي',
    'لنا',
    'لك',
    'لكم',
    'له',
    'لها',
    'لهم',
  };

  static const _synonyms = {
    'صلاة': ['صلوة', 'صلاه'],
    'صوم': ['صيام', 'صيام'],
    'زكاة': ['زكوة', 'زكاه'],
    'حج': ['حجة', 'حجة الاسلام'],
    'وضوء': ['وضو', 'طهارة مائية'],
    'غسل': ['اغتسال', 'استحمام'],
    'تيمم': ['تيمم'],
    'ربا': ['فائدة', 'ربح', 'زيادة', 'فوائد'],
    'بنك': ['مصرف', 'بنوك', 'مصارف'],
    'بيع': ['شراء', 'مبيع', 'مشتريات', 'تبادل'],
    'زواج': ['نكاح', 'عقد', 'متعة', 'قران'],
    'طلاق': ['تطليق', 'فراق', 'خلع', 'مباراة'],
    'حجاب': ['خمار', 'غطاء الرأس', 'ساتر'],
    'خمس': ['خمس المال'],
    'نفقة': ['نفقة الزوجة'],
    'يمين': ['حلف', 'قسم'],
    'كذب': ['افتراء', 'بهتان', 'زور'],
    'غيبة': ['نميمة', 'بهتان'],
    'خمر': ['مسكر', 'شراب', 'كحول'],
    'مخدرات': ['مسكرات', 'حبوب', 'منشطات'],
    'تدخين': ['سجائر', 'دخان', 'تبغ'],
    'ذكاء': ['آي', 'ai', 'تقنية', 'تكنولوجيا'],
    'عملات': ['كربتو', 'بيتكوين', 'رقمية', 'نقود'],
    'ذهب': ['مجوهرات', 'حلي'],
    'بورصة': ['سوق مالي', 'أسهم', 'تداول'],
    'أسهم': ['سهم', 'حصص', 'مساهمة'],
    'تأمين': ['ضمان', 'تعويض'],
    'قرض': ['اقتراض', 'سلف', 'دين'],
    'شهادة': ['توثيق', 'محكمة', 'قضاء'],
    'حساب': ['وديعة', 'حساب جاري', 'حساب توفير'],
    'رجل': ['ذكر', 'رجال'],
    'مرأة': ['أنثى', 'نساء', 'امرأة'],
    'ولد': ['طفل', 'صبي', 'ابن'],
    'بنت': ['طفلة', 'صبية', 'ابنة'],
    'أب': ['والد', 'أبو'],
    'أم': ['والدة', 'أم'],
    'صحة': ['طب', 'علاج', 'دواء', 'مرض'],
    'طعام': ['أكل', 'مأكل', 'أطعمة'],
    'شراب': ['مشروب', 'أشربة'],
    'سفر': ['سافر', 'مسافر', 'سفري'],
    'نية': ['نيات', 'نوايا'],
    'ثوب': ['لباس', 'ملبس', 'ملابس', 'كسوة'],
    'بيت': ['دار', 'منزل', 'مسكن'],
    'أرض': ['عقار', 'قطعة', 'مزرعة'],
    'جماعة': ['مأموم', 'إمام', 'ائتمام'],
    'جمعة': ['جمعة', 'خطبة'],
    'مسجد': ['جامع'],
    'قرآن': ['مصحف', 'قران'],
    'حديث': ['رواية', 'خبر', 'أثر'],
    'دعاء': ['مناجاة', 'ابتهال', 'تضرع'],
    'صدقة': ['زكاة', 'تبرع', 'خير', 'احسان'],
    'حلال': ['جائز', 'مباح', 'حل'],
    'حرام': ['محرم', 'ممنوع', 'لا يجوز'],
    'مكروه': ['يكره', 'الأفضل تركه'],
    'مستحب': ['مندوب', 'نافلة', 'سنة'],
    'واجب': ['فرض', 'لازم', 'حتم'],
    'بدعة': ['محدثة'],
    'حسد': ['غيرة'],
    'كبر': ['غرور', 'تكبر', 'عجب'],
    'توبة': ['استغفار', 'ندم'],
    'جهاد': ['قتال', 'غزو'],
    'سلام': ['تحية'],
    'موت': ['وفاة', 'مات', 'ميت', 'متوفي'],
    'حياة': ['عيش', 'حي'],
    'حسن': ['جيد', 'طيب'],
    'سيئ': ['قبيح', 'شر'],
    'صبر': ['جلد', 'تحمل', 'صابر'],
    'شكر': ['حمد', 'ثناء'],
  };

  bool _built = false;

  bool get isBuilt => _built;

  void build(List<FatwaModel> fatwas, List<Map<String, String>> categories) {
    _fatwas.clear();
    _wordIndex.clear();
    _categoryIndex.clear();
    _keywordIndex.clear();
    _rootIndex.clear();
    _popularity.clear();
    _allWords.clear();
    _allCategories.clear();
    _categoryNameById.clear();
    _categoryIdByName.clear();

    for (final c in categories) {
      final id = c['id'] ?? '';
      final name = c['name'] ?? '';
      if (id.isNotEmpty && name.isNotEmpty) {
        _categoryNameById[id] = name;
        _categoryIdByName[name] = id;
        _allCategories.add(name);
      }
    }

    for (int i = 0; i < fatwas.length; i++) {
      final f = fatwas[i];

      _categoryIndex.putIfAbsent(f.categoryName, () => {}).add(i);

      final searchText = '${f.question} ${f.answer} ${f.keywords.join(' ')}';
      final tokens = _tokenize(searchText);
      for (final t in tokens) {
        _wordIndex.putIfAbsent(t, () => {}).add(i);
      }

      for (final k in f.keywords) {
        final normK = normalize(k);
        if (normK.isNotEmpty) {
          _keywordIndex.putIfAbsent(normK, () => {}).add(i);
          for (final token in normK.split(' ').where((w) => w.length > 1)) {
            _keywordIndex.putIfAbsent(token, () => {}).add(i);
          }
        }
      }

      for (final t in tokens) {
        if (t.length >= 3) {
          final root = _extractRoot(t);
          if (root.isNotEmpty) {
            _rootIndex.putIfAbsent(root, () => {}).add(i);
          }
        }
      }
    }

    _allWords.addAll(_wordIndex.keys);
    _allWords.sort();

    for (int i = 0; i < fatwas.length; i++) {
      _popularity[_fatwas[i].id] = 100.0 - (i * 0.1);
    }

    _built = true;
  }

  List<SearchResult> search(
    String query, {
    String? category,
    int maxResults = 30,
  }) {
    if (query.trim().isEmpty && category == null) return [];
    if (!_built || _fatwas.isEmpty) return [];

    final results = <ScoredResult>[];
    final normalizedQuery = normalize(query);
    final queryTokens = _tokenize(query);
    final queryWords = normalizedQuery
        .split(' ')
        .where((w) => w.length > 1)
        .toList();

    final categoryFilter = <int>{};
    if (category != null && _categoryIndex.containsKey(category)) {
      categoryFilter.addAll(_categoryIndex[category]!);
    } else if (category != null && _categoryIdByName.containsKey(category)) {
      final name = _categoryIdByName[category]!;
      if (_categoryIndex.containsKey(name)) {
        categoryFilter.addAll(_categoryIndex[name]!);
      }
    }

    for (int i = 0; i < _fatwas.length; i++) {
      if (categoryFilter.isNotEmpty && !categoryFilter.contains(i)) continue;

      final f = _fatwas[i];
      double score = _computeScore(
        f,
        i,
        normalizedQuery,
        queryTokens,
        queryWords,
      );
      if (score > 0) {
        results.add(ScoredResult(i, score));
      }
    }

    results.sort((a, b) => b.score.compareTo(a.score));
    final seen = <String>{};
    final finalResults = <SearchResult>[];
    for (final r in results) {
      if (finalResults.length >= maxResults) break;
      final id = _fatwas[r.index].id;
      if (seen.add(id)) {
        finalResults.add(
          SearchResult(
            fatwa: _fatwas[r.index].toEntity(),
            similarityScore: r.score,
            isFromLocal: true,
          ),
        );
      }
    }

    return finalResults;
  }

  FatwaModel? getById(String id) {
    for (final f in _fatwas) {
      if (f.id == id) return f;
    }
    return null;
  }

  List<FatwaModel> getByCategory(String categoryName) {
    final indices = _categoryIndex[categoryName];
    if (indices == null) return [];
    return indices.map((i) => _fatwas[i]).toList();
  }

  Set<String> getCategories() => Set.from(_allCategories);

  String getCategoryName(String categoryId) =>
      _categoryNameById[categoryId] ?? categoryId;

  String? getCategoryId(String categoryName) => _categoryIdByName[categoryName];

  List<FatwaModel> getAll() => List.unmodifiable(_fatwas);

  List<FatwaModel> getRelated(FatwaModel fatwa, {int limit = 5}) {
    if (!_built) return [];
    final currentTokens = _tokenize(
      '${fatwa.question} ${fatwa.answer} ${fatwa.keywords.join(' ')}',
    );
    final currentSet = currentTokens.toSet();

    final List<_IndexScore> related = [];
    for (int i = 0; i < _fatwas.length; i++) {
      final f = _fatwas[i];
      if (f.id == fatwa.id) continue;

      final ft = _tokenize('${f.question} ${f.answer} ${f.keywords.join(' ')}');
      final fs = ft.toSet();
      final intersection = currentSet.intersection(fs).length;
      final union = currentSet.union(fs).length;
      final jaccard = union > 0 ? intersection / union : 0.0;

      final catBonus = f.categoryName == fatwa.categoryName ? 0.2 : 0.0;
      final kwOverlap = f.keywords
          .where((k) => fatwa.keywords.contains(k))
          .length;
      final kwBonus = kwOverlap > 0 ? (kwOverlap * 0.1).clamp(0.0, 0.3) : 0.0;

      related.add(_IndexScore(i, jaccard + catBonus + kwBonus));
    }

    related.sort((a, b) => b.score.compareTo(a.score));
    return related
        .take(limit)
        .where((r) => r.score > 0)
        .map((r) => _fatwas[r.index])
        .toList();
  }

  List<String> suggest(String prefix, {int limit = 10}) {
    if (prefix.trim().isEmpty) return [];
    final norm = normalize(prefix);
    final suggestions = <String>{};

    for (final cat in _allCategories) {
      if (normalize(cat).contains(norm)) {
        suggestions.add(cat);
      }
    }

    final lower = norm;
    for (final word in _allWords) {
      if (suggestions.length >= limit) break;
      if (word.contains(lower) || _levenshtein(word, lower) <= 2) {
        suggestions.add(word);
      }
    }

    return suggestions.take(limit).toList();
  }

  double _computeScore(
    FatwaModel fatwa,
    int index,
    String normalizedQuery,
    List<String> queryTokens,
    List<String> queryWords,
  ) {
    if (normalizedQuery.isEmpty) {
      return 0.3;
    }

    final questionNorm = normalize(fatwa.question);
    final answerNorm = normalize(fatwa.answer);
    final combinedNorm = '$questionNorm $answerNorm';
    final fatwaTokens = _tokenize(
      '${fatwa.question} ${fatwa.answer} ${fatwa.keywords.join(' ')}',
    );
    final fatwaSet = fatwaTokens.toSet();

    if (normalize(fatwa.categoryName) == normalizedQuery) {
      return 1.0;
    }
    if (_categoryNameById.values.any((n) => normalize(n) == normalizedQuery)) {
      return 1.0;
    }

    if (questionNorm == normalizedQuery) {
      return 0.98;
    }
    if (questionNorm.contains(normalizedQuery)) {
      return 0.95;
    }

    double catScore = 0.0;
    for (final cat in _allCategories) {
      if (normalize(cat).contains(normalizedQuery) ||
          normalizedQuery.contains(normalize(cat))) {
        catScore = 0.85;
        break;
      }
    }

    double kwScore = 0.0;
    int kwMatches = 0;
    for (final token in queryTokens) {
      final normToken = normalize(token);
      for (final kw in fatwa.keywords) {
        final normKw = normalize(kw);
        if (normKw == normToken ||
            normKw.contains(normToken) ||
            normToken.contains(normKw)) {
          kwMatches++;
          break;
        }
      }
    }
    if (queryTokens.isNotEmpty) {
      kwScore = (kwMatches / queryTokens.length) * 0.85;
    }

    double exactWordScore = 0.0;
    if (queryWords.isNotEmpty && fatwaSet.isNotEmpty) {
      int exactMatches = 0;
      for (final w in queryWords) {
        if (fatwaSet.contains(w)) exactMatches++;
      }
      exactWordScore = (exactMatches / queryWords.length) * 0.8;
    }

    double rootScore = 0.0;
    if (queryWords.isNotEmpty) {
      int rootMatches = 0;
      for (final qw in queryWords) {
        if (qw.length >= 3) {
          final qRoot = _extractRoot(qw);
          if (qRoot.isNotEmpty) {
            for (final ft in fatwaSet) {
              if (ft.length >= 3) {
                final fRoot = _extractRoot(ft);
                if (fRoot == qRoot || _cognate(qRoot, fRoot)) {
                  rootMatches++;
                  break;
                }
              }
            }
          }
        }
      }
      rootScore = queryWords.isNotEmpty
          ? (rootMatches / queryWords.length) * 0.7
          : 0.0;
    }

    double synonymScore = 0.0;
    if (queryTokens.isNotEmpty) {
      int synMatches = 0;
      for (final qt in queryTokens) {
        final syns = _getSynonyms(normalize(qt));
        for (final syn in syns) {
          if (fatwaSet.contains(syn) || combinedNorm.contains(syn)) {
            synMatches++;
            break;
          }
        }
      }
      synonymScore = (synMatches / queryTokens.length) * 0.65;
    }

    double fuzzyScore = 0.0;
    if (queryWords.isNotEmpty) {
      int fuzzyMatches = 0;
      for (final qw in queryWords) {
        for (final ft in fatwaSet) {
          if (ft.length >= 3 && qw.length >= 3) {
            final dist = _levenshtein(qw, ft);
            if (dist <= 2 && dist > 0) {
              fuzzyMatches++;
              break;
            }
          }
        }
      }
      fuzzyScore = (fuzzyMatches / queryWords.length) * 0.5;
    }

    double fullTextScore = 0.0;
    if (combinedNorm.contains(normalizedQuery)) {
      fullTextScore = 0.4;
    } else {
      for (final qt in queryTokens) {
        if (combinedNorm.contains(normalize(qt))) {
          fullTextScore = 0.3;
          break;
        }
      }
    }

    final popularity = _popularity[fatwa.id] ?? 0.0;
    final popBonus = popularity / 1000.0;

    final scores = [
      catScore,
      kwScore,
      exactWordScore,
      rootScore,
      synonymScore,
      fuzzyScore,
      fullTextScore,
    ];

    final best = scores.reduce((a, b) => a > b ? a : b);
    if (best == 0.0) return 0.0;
    return (best + popBonus).clamp(0.0, 1.0);
  }

  String normalize(String text) {
    String s = text.trim();
    s = s.replaceAll(RegExp(r'[ًٌٍَُِّْ]'), '');
    s = s.replaceAll('ـ', '');
    s = s.replaceAll('\u0621', '\u0627');
    s = s.replaceAll('\u0622', '\u0627');
    s = s.replaceAll('\u0623', '\u0627');
    s = s.replaceAll('\u0625', '\u0627');
    s = s.replaceAll('\u0629', '\u0647');
    s = s.replaceAll('\u064A', '\u0649');
    s = s.replaceAll('\u0626', '\u0623');
    s = s.replaceAll('\u0670', '\u0627');
    s = s.replaceAll(RegExp(r'[0-9\u0660-\u0669\u06F0-\u06F9]'), '');
    s = s.replaceAll(RegExp(r'[^\u0600-\u06FF\s]'), '');
    s = s.replaceAll(RegExp(r'\s+'), ' ');
    return s.trim();
  }

  List<String> _tokenize(String text) {
    final norm = normalize(text);
    if (norm.isEmpty) return [];
    return norm
        .split(RegExp(r'\s+'))
        .where((w) => w.length > 1 && !_stopWords.contains(w))
        .toList();
  }

  String _extractRoot(String word) {
    if (word.length < 3) return '';
    final chars = word.runes.toList();
    final consonants = <int>[];
    for (final c in chars) {
      if (c >= 0x0621 && c <= 0x064A) {
        final str = String.fromCharCode(c);
        if (!'ااويىءؤ'.contains(str)) {
          consonants.add(c);
        }
      }
    }
    if (consonants.length >= 3) {
      return String.fromCharCodes(consonants.sublist(0, 3));
    }
    return '';
  }

  bool _cognate(String r1, String r2) {
    if (r1 == r2) return true;
    int common = 0;
    for (final c in r1.runes) {
      if (r2.runes.contains(c)) common++;
    }
    return common >= 2;
  }

  Set<String> _getSynonyms(String word) {
    final result = <String>{};
    for (final entry in _synonyms.entries) {
      final keyNorm = normalize(entry.key);
      if (keyNorm == word) {
        result.addAll(entry.value.map((s) => normalize(s)));
      }
      for (final val in entry.value) {
        if (normalize(val) == word) {
          result.add(keyNorm);
          result.addAll(
            entry.value.where((v) => v != val).map((s) => normalize(s)),
          );
        }
      }
    }
    return result;
  }

  int _levenshtein(String a, String b) {
    if (a.isEmpty) return b.length;
    if (b.isEmpty) return a.length;
    final matrix = List.generate(
      a.length + 1,
      (i) => List.filled(b.length + 1, 0),
    );
    for (int i = 0; i <= a.length; i++) {
      matrix[i][0] = i;
    }
    for (int j = 0; j <= b.length; j++) {
      matrix[0][j] = j;
    }
    for (int i = 1; i <= a.length; i++) {
      for (int j = 1; j <= b.length; j++) {
        final cost = a[i - 1] == b[j - 1] ? 0 : 1;
        matrix[i][j] = [
          matrix[i - 1][j] + 1,
          matrix[i][j - 1] + 1,
          matrix[i - 1][j - 1] + cost,
        ].reduce((a, b) => a < b ? a : b);
      }
    }
    return matrix[a.length][b.length];
  }
}

class ScoredResult {
  final int index;
  final double score;
  ScoredResult(this.index, this.score);
}

class _IndexScore {
  final int index;
  final double score;
  _IndexScore(this.index, this.score);
}

class ArabicNLP {
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
    'هما',
    'لي',
    'لنا',
    'لك',
    'لكم',
    'له',
    'لها',
    'لهم',
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
  };

  static String normalize(String text) {
    String result = text.trim();

    // Remove diacritics (tashkeel)
    result = result.replaceAll(RegExp(r'[ًٌٍَُِّْ]'), '');

    // Normalize alef variants
    result = result.replaceAll('أ', 'ا');
    result = result.replaceAll('إ', 'ا');
    result = result.replaceAll('آ', 'ا');

    // Normalize taa marbouta
    result = result.replaceAll('ة', 'ه');
    result = result.replaceAll('ۀ', 'ه');
    result = result.replaceAll('ۃ', 'ه');

    // Normalize alif maqsura
    result = result.replaceAll('ى', 'ي');

    // Remove tatweel/kashida
    result = result.replaceAll(RegExp(r'[ـ]'), '');

    // Remove special characters and digits
    result = result.replaceAll(RegExp(r'[0-9\u0660-\u0669\u06F0-\u06F9]'), '');
    result = result.replaceAll(RegExp(r'[^\u0600-\u06FF\s]'), '');

    // Collapse multiple spaces
    result = result.replaceAll(RegExp(r'\s+'), ' ');

    return result.trim();
  }

  static List<String> tokenize(String text) {
    final normalized = normalize(text);
    if (normalized.isEmpty) return [];
    final words = normalized.split(RegExp(r'\s+'));
    return words.where((w) => w.isNotEmpty && !_stopWords.contains(w)).toList();
  }

  static double computeSimilarity(String query, String target) {
    final queryTokens = tokenize(query);
    final targetTokens = tokenize(target);

    if (queryTokens.isEmpty || targetTokens.isEmpty) return 0.0;

    final normalizedQuery = normalize(query);
    final normalizedTarget = normalize(target);

    if (normalizedQuery == normalizedTarget) return 1.0;
    if (normalizedTarget.contains(normalizedQuery)) return 0.95;
    if (normalizedQuery.contains(normalizedTarget)) return 0.9;

    int matchCount = 0;
    double fuzzyScore = 0.0;

    for (final qToken in queryTokens) {
      double bestTokenScore = 0.0;

      for (final tToken in targetTokens) {
        final tokenScore = _tokenSimilarity(qToken, tToken);
        if (tokenScore > bestTokenScore) {
          bestTokenScore = tokenScore;
        }
      }

      fuzzyScore += bestTokenScore;
      if (bestTokenScore >= 0.8) {
        matchCount++;
      }
    }

    double rootScore = 0.0;
    final queryRoots = _extractRoots(queryTokens);
    final targetRoots = _extractRoots(targetTokens);

    if (queryRoots.isNotEmpty && targetRoots.isNotEmpty) {
      int rootMatches = 0;
      for (final qr in queryRoots) {
        if (targetRoots.any((tr) => _isCognate(qr, tr))) {
          rootMatches++;
        }
      }
      rootScore = rootMatches / queryRoots.length;
    }

    if (queryTokens.length <= 3) {
      final overlap = matchCount / queryTokens.length;
      final avgTokenScore = fuzzyScore / queryTokens.length;
      return (overlap * 0.6 + avgTokenScore * 0.4) * (0.85 + rootScore * 0.15);
    }

    final overlap = matchCount / queryTokens.length;
    final avgTokenScore = fuzzyScore / queryTokens.length;
    final wordOrderBonus = _wordOrderSimilarity(queryTokens, targetTokens);

    return (overlap * 0.45 +
        avgTokenScore * 0.25 +
        wordOrderBonus * 0.2 +
        rootScore * 0.1);
  }

  static double _tokenSimilarity(String a, String b) {
    if (a == b) return 1.0;
    final distance = _levenshtein(a, b);
    final maxLen = a.length > b.length ? a.length : b.length;
    if (distance == 0) return 1.0;
    return 1.0 - (distance / maxLen);
  }

  static int _levenshtein(String a, String b) {
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

  static double _wordOrderSimilarity(List<String> query, List<String> target) {
    int orderMatches = 0;
    int lastPos = -1;

    for (final qToken in query) {
      for (int j = 0; j < target.length; j++) {
        if (_tokenSimilarity(qToken, target[j]) >= 0.8) {
          if (j > lastPos) {
            orderMatches++;
            lastPos = j;
          }
          break;
        }
      }
    }

    if (orderMatches == 0) return 0.0;
    return orderMatches / query.length;
  }

  static Set<String> _extractRoots(List<String> tokens) {
    final roots = <String>{};
    for (final token in tokens) {
      if (token.length >= 3) {
        final chars = token.runes.toList();
        final consonants = chars
            .where(
              (c) =>
                  !'aeiouAEIOU'.contains(String.fromCharCode(c)) &&
                  !'ًٌٍَُِّْ'.contains(String.fromCharCode(c)),
            )
            .toList();

        if (consonants.length >= 3) {
          final root = String.fromCharCodes(consonants.sublist(0, 3));
          if (root.runes.every((r) => r >= 0x0621 && r <= 0x064A)) {
            roots.add(root);
          }
        }
      }
    }
    return roots;
  }

  static bool _isCognate(String root1, String root2) {
    if (root1 == root2) return true;
    int common = 0;
    final r1 = root1.runes.toSet();
    final r2 = root2.runes.toSet();
    for (final r in r1) {
      if (r2.contains(r)) common++;
    }
    return common >= 2;
  }

  static List<String> fuzzyGenerate(String query) {
    final tokens = tokenize(query);
    final variants = <String>[];

    for (final token in tokens) {
      if (token.length <= 2) {
        variants.add(token);
        continue;
      }

      if (token.contains('ا')) {
        variants.add(token.replaceAll('ا', 'أ'));
        variants.add(token.replaceAll('ا', 'إ'));
      }
      if (token.contains('ي')) {
        variants.add(token.replaceAll('ي', 'ى'));
      }
      if (token.contains('ة')) {
        variants.add(token.replaceAll('ة', 'ه'));
      }
      if (token.contains('و')) {
        variants.add(token.replaceAll('و', 'ؤ'));
      }
    }

    variants.addAll(tokens);
    return variants.toSet().toList();
  }
}

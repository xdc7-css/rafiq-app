enum SearchResultType { quran, hadith, adhkar, tafsir }

class SearchResult {
  final String id;
  final String text;
  final String? reference;
  final String? subReference;
  final SearchResultType type;

  const SearchResult({
    required this.id,
    required this.text,
    this.reference,
    this.subReference,
    required this.type,
  });
}

class SearchResults {
  final List<SearchResult> quran;
  final List<SearchResult> hadith;
  final List<SearchResult> adhkar;
  final List<SearchResult> tafsir;
  final int totalCount;

  const SearchResults({
    this.quran = const [],
    this.hadith = const [],
    this.adhkar = const [],
    this.tafsir = const [],
    this.totalCount = 0,
  });

  bool get isEmpty =>
      quran.isEmpty && hadith.isEmpty && adhkar.isEmpty && tafsir.isEmpty;
}

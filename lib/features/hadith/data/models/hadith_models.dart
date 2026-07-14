class HadithCollection {
  final String id;
  final String name;
  final String arabicName;
  final List<HadithBook> books;

  const HadithCollection({
    required this.id,
    required this.name,
    required this.arabicName,
    required this.books,
  });

  factory HadithCollection.fromJson(Map<String, dynamic> json) {
    return HadithCollection(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      arabicName: json['arabicName'] ?? json['name'] ?? '',
      books: (json['books'] as List<dynamic>? ?? [])
          .map((e) => HadithBook.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class HadithBook {
  final int id;
  final String name;
  final String arabicName;
  final List<HadithModel> hadiths;

  const HadithBook({
    required this.id,
    required this.name,
    required this.arabicName,
    required this.hadiths,
  });

  factory HadithBook.fromJson(Map<String, dynamic> json) {
    return HadithBook(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      arabicName: json['arabicName'] ?? json['name'] ?? '',
      hadiths: (json['hadiths'] as List<dynamic>? ?? [])
          .map((e) => HadithModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class HadithModel {
  final int id;
  final String text;
  final String? narrator;
  final String? source;
  final int bookNumber;
  final int hadithNumber;
  final String? grade;

  const HadithModel({
    required this.id,
    required this.text,
    this.narrator,
    this.source,
    required this.bookNumber,
    required this.hadithNumber,
    this.grade,
  });

  factory HadithModel.fromJson(Map<String, dynamic> json) {
    return HadithModel(
      id: json['id'] ?? 0,
      text: json['text'] ?? json['text'] ?? '',
      narrator: json['narrator'] ?? json['rawi'] ?? '',
      source: json['source'] ?? '',
      bookNumber: json['bookNumber'] ?? json['bab'] ?? 0,
      hadithNumber: json['hadithNumber'] ?? json['number'] ?? 0,
      grade: json['grade'] ?? json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'narrator': narrator,
        'source': source,
        'bookNumber': bookNumber,
        'hadithNumber': hadithNumber,
        'grade': grade,
      };
}

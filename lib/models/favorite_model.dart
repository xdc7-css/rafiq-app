enum FavoriteType { verse, hadith, adhkar }

class FavoriteModel {
  final String id;
  final FavoriteType type;
  final String textArabic;
  final String reference;
  final DateTime dateAdded;
  final Map<String, dynamic>? metadata;

  FavoriteModel({
    required this.id,
    required this.type,
    required this.textArabic,
    required this.reference,
    DateTime? dateAdded,
    this.metadata,
  }) : dateAdded = dateAdded ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.index,
      'textArabic': textArabic,
      'reference': reference,
      'dateAdded': dateAdded.toIso8601String(),
      'metadata': metadata,
    };
  }

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      id: json['id'],
      type: FavoriteType.values[json['type'] ?? 0],
      textArabic: json['textArabic'],
      reference: json['reference'],
      dateAdded: json['dateAdded'] != null
          ? DateTime.parse(json['dateAdded'])
          : DateTime.now(),
      metadata: json['metadata'],
    );
  }

  FavoriteModel copyWith({
    String? id,
    FavoriteType? type,
    String? textArabic,
    String? reference,
    DateTime? dateAdded,
    Map<String, dynamic>? metadata,
  }) {
    return FavoriteModel(
      id: id ?? this.id,
      type: type ?? this.type,
      textArabic: textArabic ?? this.textArabic,
      reference: reference ?? this.reference,
      dateAdded: dateAdded ?? this.dateAdded,
      metadata: metadata ?? this.metadata,
    );
  }
}

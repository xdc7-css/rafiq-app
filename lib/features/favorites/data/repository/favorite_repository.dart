import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/cache/cache_manager.dart';

enum FavoriteContentType { verse, hadith, adhkar, dua, tafsir }

class FavoriteItem {
  final String id;
  final FavoriteContentType type;
  final String textArabic;
  final String? reference;
  final DateTime dateAdded;
  final Map<String, dynamic>? metadata;

  const FavoriteItem({
    required this.id,
    required this.type,
    required this.textArabic,
    this.reference,
    required this.dateAdded,
    this.metadata,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.index,
        'textArabic': textArabic,
        'reference': reference,
        'dateAdded': dateAdded.toIso8601String(),
        'metadata': metadata,
      };

  factory FavoriteItem.fromJson(Map<String, dynamic> json) {
    return FavoriteItem(
      id: json['id'] ?? '',
      type: FavoriteContentType.values[json['type'] ?? 0],
      textArabic: json['textArabic'] ?? '',
      reference: json['reference'],
      dateAdded: json['dateAdded'] != null
          ? DateTime.parse(json['dateAdded'])
          : DateTime.now(),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }
}

class FavoriteRepository {
  static const String _key = 'favorites_v2';

  Future<List<FavoriteItem>> getAll() async {
    final data = CacheManager.getJsonList(_key);
    if (data == null) return [];
    return data
        .map((e) => FavoriteItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<FavoriteItem>> getByType(FavoriteContentType type) async {
    final all = await getAll();
    return all.where((f) => f.type == type).toList();
  }

  Future<void> toggle(FavoriteItem item) async {
    final all = await getAll();
    final index = all.indexWhere((f) => f.id == item.id);
    if (index >= 0) {
      all.removeAt(index);
    } else {
      all.insert(0, item);
    }
    await _save(all);
  }

  Future<bool> isFavorite(String id) async {
    final all = await getAll();
    return all.any((f) => f.id == id);
  }

  Future<void> remove(String id) async {
    final all = await getAll();
    all.removeWhere((f) => f.id == id);
    await _save(all);
  }

  Future<List<FavoriteItem>> search(String query) async {
    final all = await getAll();
    final q = query.toLowerCase();
    return all
        .where((f) =>
            f.textArabic.contains(q) ||
            (f.reference?.contains(q) ?? false))
        .toList();
  }

  Future<void> _save(List<FavoriteItem> items) async {
    final jsonList = items.map((f) => f.toJson()).toList();
    await CacheManager.cacheJsonList(_key, jsonList);
  }
}

final favoriteRepositoryProvider = Provider<FavoriteRepository>((ref) => FavoriteRepository());

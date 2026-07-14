import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../database/local_database.dart';
import '../services/storage_service.dart';

class FavoritesNotifier extends StateNotifier<List<FavoriteModel>> {
  FavoritesNotifier() : super(StorageService.getFavorites()) {
    _loadFromDb();
  }

  Future<void> _loadFromDb() async {
    final db = LocalDatabaseService.instance;
    if (!db.isInitialized) return;
    final entries = await db.getAllFavorites();
    if (entries.isNotEmpty) {
      final favorites = entries.map((e) => FavoriteModel(
        id: e.uniqueKey.split('_').skip(1).join('_'),
        type: FavoriteType.values[e.typeIndex],
        textArabic: e.textArabic,
        reference: e.reference,
        dateAdded: e.dateAdded,
      )).toList();
      if (mounted) state = favorites;
    }
  }

  Future<void> _saveFavorite(FavoriteModel fav, bool add) async {
    final db = LocalDatabaseService.instance;
    if (db.isInitialized) {
      if (add) {
        await db.putFavorite(FavoriteEntry(
          uniqueKey: '${fav.type.index}_${fav.id}',
          typeIndex: fav.type.index,
          textArabic: fav.textArabic,
          reference: fav.reference,
          dateAdded: fav.dateAdded,
          metadata: '{}',
        ));
      } else {
        await db.deleteFavoriteByKey('${fav.type.index}_${fav.id}');
      }
    }
  }

  void addVerse(VerseModel verse) {
    final id = 'verse_${verse.id}';
    if (isFavorite(id)) {
      remove(id);
      return;
    }
    final favorite = FavoriteModel(
      id: id,
      type: FavoriteType.verse,
      textArabic: verse.textArabic,
      reference: verse.reference,
      metadata: verse.toJson(),
    );
    state = [...state, favorite];
    _saveFavorite(favorite, true);
  }

  void addHadith(HadithModel hadith) {
    final id = 'hadith_${hadith.id}';
    if (isFavorite(id)) {
      remove(id);
      return;
    }
    final favorite = FavoriteModel(
      id: id,
      type: FavoriteType.hadith,
      textArabic: hadith.textArabic,
      reference: hadith.reference,
      metadata: hadith.toJson(),
    );
    state = [...state, favorite];
    _saveFavorite(favorite, true);
  }

  void addAdhkar(AdhkarModel adhkar) {
    final id = 'adhkar_${adhkar.id}';
    if (isFavorite(id)) {
      remove(id);
      return;
    }
    final favorite = FavoriteModel(
      id: id,
      type: FavoriteType.adhkar,
      textArabic: adhkar.textArabic,
      reference: adhkar.source ?? '',
      metadata: {'id': adhkar.id},
    );
    state = [...state, favorite];
    _saveFavorite(favorite, true);
  }

  void remove(String id) {
    final fav = state.firstWhere((f) => f.id == id, orElse: () => state.first);
    state = state.where((f) => f.id != id).toList();
    _saveFavorite(fav, false);
  }

  bool isFavorite(String id) {
    return state.any((f) => f.id == id);
  }

  List<FavoriteModel> getFavoritesByType(FavoriteType type) {
    return state.where((f) => f.type == type).toList();
  }

  List<FavoriteModel> searchFavorites(String query) {
    final q = query.trim();
    return state
        .where((f) =>
            f.textArabic.contains(q) ||
            f.reference.contains(q))
        .toList();
  }
}

final favoritesNotifierProvider =
    StateNotifierProvider<FavoritesNotifier, List<FavoriteModel>>((ref) {
  return FavoritesNotifier();
});

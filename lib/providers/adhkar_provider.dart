import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/arabic_strings.dart';
import '../models/models.dart';
import '../database/local_database.dart';
import '../services/storage_service.dart';

class AdhkarCategoriesNotifier extends StateNotifier<List<AdhkarCategory>> {
  AdhkarCategoriesNotifier() : super(_getDefaultCategories()) {
    _loadFromDb();
  }

  Future<void> _loadFromDb() async {
    final db = LocalDatabaseService.instance;
    if (!db.isInitialized) return;
    final entries = await db.getAllAdhkarState();
    if (entries.isEmpty) return;
    final stateMap = <String, AdhkarStateEntry>{};
    for (final e in entries) {
      stateMap[e.uniqueKey] = e;
    }
    state = state.map((cat) {
      final updatedAdhkar = cat.adhkar.map((dhikr) {
        final key = '${cat.id}_${dhikr.id}';
        final saved = stateMap[key];
        if (saved != null) {
          return dhikr.copyWith(
            currentCount: saved.currentCount,
            isFavorite: saved.isFavorite,
          );
        }
        return dhikr;
      }).toList();
      return cat.copyWith(adhkar: updatedAdhkar);
    }).toList();
  }

  void incrementDhikr(String categoryId, String dhikrId) {
    state = state.map((cat) {
      if (cat.id == categoryId) {
        final updatedAdhkar = cat.adhkar.map((dhikr) {
          if (dhikr.id == dhikrId && !dhikr.isCompleted) {
            return dhikr.copyWith(currentCount: dhikr.currentCount + 1);
          }
          return dhikr;
        }).toList();
        return cat.copyWith(adhkar: updatedAdhkar);
      }
      return cat;
    }).toList();
    _saveCategory(categoryId);
  }

  void toggleFavorite(String categoryId, String dhikrId) {
    state = state.map((cat) {
      if (cat.id == categoryId) {
        final updatedAdhkar = cat.adhkar.map((dhikr) {
          if (dhikr.id == dhikrId) {
            return dhikr.copyWith(isFavorite: !dhikr.isFavorite);
          }
          return dhikr;
        }).toList();
        return cat.copyWith(adhkar: updatedAdhkar);
      }
      return cat;
    }).toList();
    _saveCategory(categoryId);
  }

  void resetCategory(String categoryId) {
    state = state.map((cat) {
      if (cat.id == categoryId) {
        final resetAdhkar = cat.adhkar
            .map((dhikr) => dhikr.copyWith(currentCount: 0))
            .toList();
        return cat.copyWith(adhkar: resetAdhkar);
      }
      return cat;
    }).toList();
    _saveCategory(categoryId);
  }

  void _saveCategory(String categoryId) {
    final cat = state.firstWhere((c) => c.id == categoryId);
    StorageService.saveAdhkarCategory(cat);
    final db = LocalDatabaseService.instance;
    if (db.isInitialized) {
      final entries = cat.adhkar.map((d) => AdhkarStateEntry(
        uniqueKey: '${cat.id}_${d.id}',
        categoryId: cat.id,
        dhikrId: d.id,
        currentCount: d.currentCount,
        isFavorite: d.isFavorite,
      )).toList();
      db.putAllAdhkarState(entries);
    }
  }

  static List<AdhkarCategory> _getDefaultCategories() {
    return [
      AdhkarCategory(
        id: 'morning',
        name: 'أذكار الصباح',
        nameArabic: 'أذكار الصباح',
        description: 'أذكار الصباح',
        adhkar: [
          AdhkarModel(
            id: 'm1',
            textArabic: 'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
            targetCount: 1,
            source: Ar.sourceSahihMuslim,
          ),
          AdhkarModel(
            id: 'm2',
            textArabic: 'اللَّهُمَّ بِكَ أَصْبَحْنَا، وَبِكَ أَمْسَيْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ وَإِلَيْكَ النُّشُورُ',
            targetCount: 1,
            source: Ar.sourceSahihTirmidhi,
          ),
          AdhkarModel(
            id: 'm3',
            textArabic: 'اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَٰهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَىٰ عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ، أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ، أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ، وَأَبُوءُ بِذَنْبِي فَاغْفِرْ لِي فَإِنَّهُ لَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ',
            targetCount: 1,
            source: Ar.sourceSahihBukhari,
          ),
        ],
      ),
      AdhkarCategory(
        id: 'evening',
        name: 'أذكار المساء',
        nameArabic: 'أذكار المساء',
        description: 'أذكار المساء',
        adhkar: [
          AdhkarModel(
            id: 'e1',
            textArabic: 'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
            targetCount: 1,
            source: Ar.sourceSahihMuslim,
          ),
          AdhkarModel(
            id: 'e2',
            textArabic: 'اللَّهُمَّ بِكَ أَمْسَيْنَا، وَبِكَ أَصْبَحْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ وَإِلَيْكَ الْمَصِيرُ',
            targetCount: 1,
            source: Ar.sourceSahihTirmidhi,
          ),
          AdhkarModel(
            id: 'e3',
            textArabic: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ وَالْعَافِيَةَ فِي الدُّنْيَا وَالْآخِرَةِ',
            targetCount: 1,
            source: Ar.sourceSahihIbnMajah,
          ),
        ],
      ),
      AdhkarCategory(
        id: 'sleep',
        name: 'أذكار النوم',
        nameArabic: 'أذكار النوم',
        description: 'أذكار النوم',
        adhkar: [
          AdhkarModel(
            id: 's1',
            textArabic: 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
            targetCount: 3,
            source: Ar.sourceSahihMuslim,
          ),
          AdhkarModel(
            id: 's2',
            textArabic: 'اللَّهُمَّ قِنِي عَذَابَكَ يَوْمَ تَبْعَثُ عِبَادَكَ',
            targetCount: 3,
            source: Ar.sourceSahihMuslim,
          ),
        ],
      ),
      AdhkarCategory(
        id: 'prayer',
        name: 'أذكار الصلاة',
        nameArabic: 'أذكار الصلاة',
        description: 'أذكار بعد الصلاة',
        adhkar: [
          AdhkarModel(
            id: 'p1',
            textArabic: 'أَسْتَغْفِرُ اللَّهَ',
            targetCount: 3,
            source: Ar.sourceSahihMuslim,
          ),
          AdhkarModel(
            id: 'p2',
            textArabic: 'اللَّهُمَّ أَنْتَ السَّلَامُ وَمِنْكَ السَّلَامُ تَبَارَكْتَ يَا ذَا الْجَلَالِ وَالْإِكْرَامِ',
            targetCount: 1,
            source: Ar.sourceSahihMuslim,
          ),
          AdhkarModel(
            id: 'p3',
            textArabic: 'سُبْحَانَ اللَّهِ',
            targetCount: 33,
            source: Ar.sourceSahihMuslim,
          ),
          AdhkarModel(
            id: 'p4',
            textArabic: 'الْحَمْدُ لِلَّهِ',
            targetCount: 33,
            source: Ar.sourceSahihMuslim,
          ),
          AdhkarModel(
            id: 'p5',
            textArabic: 'اللَّهُ أَكْبَرُ',
            targetCount: 34,
            source: Ar.sourceSahihMuslim,
          ),
          AdhkarModel(
            id: 'p6',
            textArabic: 'لَا إِلَٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
            targetCount: 1,
            source: Ar.sourceSahihBukhari,
          ),
          AdhkarModel(
            id: 'p7',
            textArabic: 'اللَّهُمَّ لَا مَانِعَ لِمَا أَعْطَيْتَ وَلَا مُعْطِيَ لِمَا مَنَعْتَ وَلَا يَنْفَعُ ذَا الْجَدِّ مِنْكَ الْجَدُّ',
            targetCount: 1,
            source: Ar.sourceSahihBukhari,
          ),
        ],
      ),
      AdhkarCategory(
        id: 'travel',
        name: 'أذكار السفر',
        nameArabic: 'أذكار السفر',
        description: 'أذكار السفر',
        adhkar: [
          AdhkarModel(
            id: 't1',
            textArabic: 'اللَّهُ أَكْبَرُ، اللَّهُ أَكْبَرُ، اللَّهُ أَكْبَرُ، سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَٰذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ وَإِنَّا إِلَىٰ رَبِّنَا لَمُنْقَلِبُونَ',
            targetCount: 1,
            source: Ar.sourceSahihMuslim,
          ),
          AdhkarModel(
            id: 't2',
            textArabic: 'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنْ وَعْثَاءِ السَّفَرِ وَكَآبَةِ الْمَنْظَرِ وَسُوءِ الْمُنْقَلَبِ فِي الْمَالِ وَالْأَهْلِ',
            targetCount: 1,
            source: Ar.sourceSahihMuslim,
          ),
        ],
      ),
    ];
  }
}

final adhkarCategoriesProvider =
    StateNotifierProvider<AdhkarCategoriesNotifier, List<AdhkarCategory>>(
        (ref) {
  return AdhkarCategoriesNotifier();
});

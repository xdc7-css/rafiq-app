import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/models.dart';
import '../database/local_database.dart';
import '../services/storage_service.dart';
import '../services/home_widget_service.dart';

class TasbeehListNotifier extends StateNotifier<List<TasbeehModel>> {
  TasbeehListNotifier() : super(_loadDefault()) {
    _loadFromDb();
  }

  Future<void> _loadFromDb() async {
    final db = LocalDatabaseService.instance;
    if (!db.isInitialized) return;
    final entries = await db.getAllTasbeeh();
    if (entries.isNotEmpty) {
      final list = entries.map((e) => TasbeehModel(
        id: e.uniqueKey,
        name: e.name,
        nameArabic: e.nameArabic,
        count: e.count,
        target: e.target,
        lastUsed: e.lastUsed,
      )).toList();
      if (mounted) state = list;
    }
  }

  static List<TasbeehModel> _loadDefault() {
    return [
      TasbeehModel(
        id: const Uuid().v4(),
        name: 'سبحان الله',
        nameArabic: 'سبحان الله',
        target: 33,
      ),
      TasbeehModel(
        id: const Uuid().v4(),
        name: 'الحمد لله',
        nameArabic: 'الحمد لله',
        target: 33,
      ),
      TasbeehModel(
        id: const Uuid().v4(),
        name: 'الله أكبر',
        nameArabic: 'الله أكبر',
        target: 33,
      ),
      TasbeehModel(
        id: const Uuid().v4(),
        name: 'لا إله إلا الله',
        nameArabic: 'لا إله إلا الله',
        target: 100,
      ),
      TasbeehModel(
        id: const Uuid().v4(),
        name: 'أستغفر الله',
        nameArabic: 'أستغفر الله',
        target: 100,
      ),
      TasbeehModel(
        id: const Uuid().v4(),
        name: 'سبحان الله وبحمده',
        nameArabic: 'سبحان الله وبحمده',
        target: 100,
      ),
      TasbeehModel(
        id: const Uuid().v4(),
        name: 'سبحان الله العظيم',
        nameArabic: 'سبحان الله العظيم',
        target: 100,
      ),
      TasbeehModel(
        id: const Uuid().v4(),
        name: 'لا حول ولا قوة إلا بالله',
        nameArabic: 'لا حول ولا قوة إلا بالله',
        target: 100,
      ),
    ];
  }

  bool increment(String id) {
    bool reached = false;
    state = state.map((t) {
      if (t.id == id) {
        final newCount = t.count + 1;
        if (newCount >= t.target) {
          reached = true;
          return t.copyWith(count: 0, lastUsed: DateTime.now());
        }
        return t.copyWith(count: newCount, lastUsed: DateTime.now());
      }
      return t;
    }).toList();
    _saveAll();
    return reached;
  }

  void decrement(String id) {
    state = state.map((t) {
      if (t.id == id) {
        final newCount = (t.count - 1).clamp(0, 9999999);
        return t.copyWith(count: newCount, lastUsed: DateTime.now());
      }
      return t;
    }).toList();
    _saveAll();
  }


  void reset(String id) {
    state = state.map((t) {
      if (t.id == id) {
        return t.copyWith(count: 0);
      }
      return t;
    }).toList();
    _saveAll();
  }

  void updateTarget(String id, int target) {
    state = state.map((t) {
      if (t.id == id) {
        return t.copyWith(target: target);
      }
      return t;
    }).toList();
    _saveAll();
  }


  void addTasbeeh(String name, String nameArabic, int target) {
    final tasbeeh = TasbeehModel(
      id: const Uuid().v4(),
      name: name,
      nameArabic: nameArabic,
      target: target,
    );
    state = [...state, tasbeeh];
    _saveAll();
  }

  void removeTasbeeh(String id) {
    state = state.where((t) => t.id != id).toList();
    _saveAll();
  }

  void _saveAll() {
    final db = LocalDatabaseService.instance;
    for (final tasbeeh in state) {
      StorageService.saveTasbeeh(tasbeeh);
      if (db.isInitialized) {
        db.putTasbeeh(TasbeehEntry(
          uniqueKey: tasbeeh.id,
          name: tasbeeh.name,
          nameArabic: tasbeeh.nameArabic,
          count: tasbeeh.count,
          target: tasbeeh.target,
          lastUsed: tasbeeh.lastUsed,
        ));
      }
    }
    _syncTasbihWidget();
  }

  void _syncTasbihWidget() {
    if (state.isEmpty) return;
    final current = state.first;
    HomeWidgetService.updateTasbihWidget(
      name: current.nameArabic,
      count: current.count,
      target: current.target,
      id: current.id,
      index: 0,
      totalItems: state.length,
    );
  }
}

final tasbeehListNotifierProvider =
    StateNotifierProvider<TasbeehListNotifier, List<TasbeehModel>>((ref) {
  return TasbeehListNotifier();
});

final currentTasbeehProvider = StateProvider<String?>((ref) {
  final list = ref.watch(tasbeehListNotifierProvider);
  return list.isNotEmpty ? list.first.id : null;
});

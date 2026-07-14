import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/ziyarat_local_source.dart';
import '../../data/repository/ziyarat_repository.dart';
import '../../data/models/ziyarat_models.dart';

final ziyaratLocalSourceProvider = Provider<ZiyaratLocalSource>((ref) {
  return ZiyaratLocalSource();
});

final ziyaratRepositoryProvider = Provider<ZiyaratRepository>((ref) {
  return ZiyaratRepository(ref.watch(ziyaratLocalSourceProvider));
});

final ziyaratListProvider = FutureProvider<List<ZiyaratModel>>((ref) async {
  return ref.watch(ziyaratRepositoryProvider).getZiyarat();
});

final duasListProvider = FutureProvider<List<DuaModel>>((ref) async {
  return ref.watch(ziyaratRepositoryProvider).getDuas();
});

final sahifaListProvider = FutureProvider<List<SahifaModel>>((ref) async {
  return ref.watch(ziyaratRepositoryProvider).getSahifa();
});

final mafatihListProvider = FutureProvider<List<MafatihSection>>((ref) async {
  return ref.watch(ziyaratRepositoryProvider).getMafatih();
});

final occasionsListProvider = FutureProvider<List<IslamicOccasion>>((ref) async {
  return ref.watch(ziyaratRepositoryProvider).getOccasions();
});

final searchZiyaratProvider = FutureProvider.family<List<ContentSearchResult>, String>(
  (ref, query) async {
    return ref.watch(ziyaratRepositoryProvider).search(query);
  },
);

final ziyaratByIdProvider = FutureProvider.family<ZiyaratModel?, String>(
  (ref, id) async {
    final list = await ref.watch(ziyaratListProvider.future);
    try {
      return list.firstWhere((z) => z.id == id);
    } catch (_) {
      return null;
    }
  },
);

final duaByIdProvider = FutureProvider.family<DuaModel?, String>(
  (ref, id) async {
    final list = await ref.watch(duasListProvider.future);
    try {
      return list.firstWhere((d) => d.id == id);
    } catch (_) {
      return null;
    }
  },
);

final occasionByIdProvider = FutureProvider.family<IslamicOccasion?, String>(
  (ref, id) async {
    final list = await ref.watch(occasionsListProvider.future);
    try {
      return list.firstWhere((o) => o.id == id);
    } catch (_) {
      return null;
    }
  },
);

final occasionRelatedZiyaratProvider = FutureProvider.family<List<ZiyaratModel>, String>(
  (ref, occasionId) async {
    final occasion = await ref.watch(occasionByIdProvider(occasionId).future);
    if (occasion == null) return [];
    final allZiyarat = await ref.watch(ziyaratListProvider.future);
    return allZiyarat.where((z) => occasion.relatedZiyaratIds.contains(z.id)).toList();
  },
);

final occasionRelatedDuasProvider = FutureProvider.family<List<DuaModel>, String>(
  (ref, occasionId) async {
    final occasion = await ref.watch(occasionByIdProvider(occasionId).future);
    if (occasion == null) return [];
    final allDuas = await ref.watch(duasListProvider.future);
    return allDuas.where((d) => occasion.relatedDuaIds.contains(d.id)).toList();
  },
);

final currentOccasionProvider = Provider<IslamicOccasion?>((ref) {
  return null;
});

final ziyaratOfDayProvider = FutureProvider<ZiyaratModel?>((ref) async {
  final list = await ref.watch(ziyaratListProvider.future);
  if (list.isEmpty) return null;
  final day = DateTime.now().millisecondsSinceEpoch ~/ Duration.millisecondsPerDay;
  return list[day % list.length];
});

final duaOfDayProvider = FutureProvider<DuaModel?>((ref) async {
  final list = await ref.watch(duasListProvider.future);
  if (list.isEmpty) return null;
  final day = DateTime.now().millisecondsSinceEpoch ~/ Duration.millisecondsPerDay;
  return list[(day + 7) % list.length];
});

final sahifaOfDayProvider = FutureProvider<SahifaModel?>((ref) async {
  final list = await ref.watch(sahifaListProvider.future);
  if (list.isEmpty) return null;
  final day = DateTime.now().millisecondsSinceEpoch ~/ Duration.millisecondsPerDay;
  return list[day % list.length];
});

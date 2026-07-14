import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/adhkar_models.dart';

class AdhkarLocalSource {
  List<AdhkarCategoryModel>? _categories;

  Future<List<AdhkarCategoryModel>> loadAdhkar() async {
    if (_categories != null) return _categories!;
    try {
      final data = await rootBundle.loadString(AppConstants.adkarAssetPath);
      final List<dynamic> jsonList = json.decode(data);
      _categories = _groupByCategory(jsonList);
      return _categories!;
    } catch (e) {
      throw JsonParseException(message: 'فشل تحميل الأذكار', dataPath: AppConstants.adkarAssetPath);
    }
  }

  List<AdhkarCategoryModel> _groupByCategory(List<dynamic> items) {
    final Map<String, List<DhikrModel>> grouped = {};
    for (final item in items) {
      final map = item as Map<String, dynamic>;
      final category = map['category'] as String? ?? 'أذكار';
      final dhikr = DhikrModel.fromJson(map);
      grouped.putIfAbsent(category, () => []).add(dhikr);
    }
    return grouped.entries.map((entry) {
      return AdhkarCategoryModel(
        id: entry.key.replaceAll(' ', '_'),
        name: entry.key,
        adhkar: entry.value,
      );
    }).toList();
  }

  Future<List<DhikrModel>> searchAdhkar(String query) async {
    final cats = await loadAdhkar();
    final q = query.trim();
    if (q.isEmpty) return [];
    final results = <DhikrModel>[];
    for (final cat in cats) {
      for (final dhikr in cat.adhkar) {
        if (dhikr.text.contains(q)) {
          results.add(dhikr);
        }
      }
    }
    return results.take(50).toList();
  }

  void clearCache() {
    _categories = null;
  }
}

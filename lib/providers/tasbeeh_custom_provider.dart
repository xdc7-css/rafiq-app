import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/local_database.dart';

const _customKey = 'tasbeeh_custom';

class CustomTasbih {
  final String id;
  final String name;
  final String nameArabic;
  final int target;
  final bool isFavorite;
  final DateTime createdAt;

  const CustomTasbih({
    required this.id,
    required this.name,
    required this.nameArabic,
    this.target = 33,
    this.isFavorite = false,
    required this.createdAt,
  });

  CustomTasbih copyWith({
    String? name,
    String? nameArabic,
    int? target,
    bool? isFavorite,
  }) {
    return CustomTasbih(
      id: id,
      name: name ?? this.name,
      nameArabic: nameArabic ?? this.nameArabic,
      target: target ?? this.target,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'nameArabic': nameArabic,
        'target': target,
        'favorite': isFavorite,
        'createdAt': createdAt.toIso8601String(),
      };

  factory CustomTasbih.fromJson(Map<String, dynamic> json) => CustomTasbih(
        id: json['id'] as String? ?? '',
        name: json['name'] as String? ?? '',
        nameArabic: json['nameArabic'] as String? ?? '',
        target: json['target'] as int? ?? 33,
        isFavorite: json['favorite'] as bool? ?? false,
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'] as String)
            : DateTime.now(),
      );
}

final customTasbihListProvider =
    StateNotifierProvider<CustomTasbihNotifier, List<CustomTasbih>>((ref) {
  return CustomTasbihNotifier();
});

class CustomTasbihNotifier extends StateNotifier<List<CustomTasbih>> {
  CustomTasbihNotifier() : super([]) {
    _load();
  }

  Future<void> _load() async {
    final db = LocalDatabaseService.instance;
    if (db.isInitialized) {
      final entries = await db.getAllCustomTasbih();
      if (entries.isNotEmpty) {
        state = entries.map((e) => CustomTasbih(
          id: e.uniqueKey,
          name: e.name,
          nameArabic: e.nameArabic,
          target: e.target,
          isFavorite: e.isFavorite,
          createdAt: e.createdAt,
        )).toList();
        return;
      }
    }
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_customKey);
    if (raw == null) return;
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      state = list
          .map((e) => CustomTasbih.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {}
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_customKey, jsonEncode(state.map((e) => e.toJson()).toList()));
    final db = LocalDatabaseService.instance;
    if (db.isInitialized) {
      for (final c in state) {
        await db.putCustomTasbih(CustomTasbihEntry(
          uniqueKey: c.id,
          name: c.name,
          nameArabic: c.nameArabic,
          target: c.target,
          isFavorite: c.isFavorite,
          createdAt: c.createdAt,
        ));
      }
    }
  }

  void add(CustomTasbih item) {
    state = [...state, item];
    _save();
  }

  void update(String id, CustomTasbih updated) {
    state = state.map((e) => e.id == id ? updated : e).toList();
    _save();
  }

  void remove(String id) {
    state = state.where((e) => e.id != id).toList();
    _save();
  }

  void toggleFavorite(String id) {
    state = state.map((e) {
      if (e.id == id) return e.copyWith(isFavorite: !e.isFavorite);
      return e;
    }).toList();
    _save();
  }
}

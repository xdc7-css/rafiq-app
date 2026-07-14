import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/local_database.dart';

const _historyKey = 'tasbeeh_history';

class TasbihSession {
  final String id;
  final String type;
  final String label;
  final int count;
  final DateTime startedAt;
  final int durationSeconds;

  const TasbihSession({
    required this.id,
    required this.type,
    required this.label,
    required this.count,
    required this.startedAt,
    this.durationSeconds = 0,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'label': label,
        'count': count,
        'startedAt': startedAt.toIso8601String(),
        'duration': durationSeconds,
      };

  factory TasbihSession.fromJson(Map<String, dynamic> json) => TasbihSession(
        id: json['id'] as String? ?? '',
        type: json['type'] as String? ?? '',
        label: json['label'] as String? ?? '',
        count: json['count'] as int? ?? 0,
        startedAt: json['startedAt'] != null
            ? DateTime.parse(json['startedAt'] as String)
            : DateTime.now(),
        durationSeconds: json['duration'] as int? ?? 0,
      );
}

final tasbihHistoryProvider =
    StateNotifierProvider<TasbihHistoryNotifier, List<TasbihSession>>((ref) {
  return TasbihHistoryNotifier();
});

class TasbihHistoryNotifier extends StateNotifier<List<TasbihSession>> {
  TasbihHistoryNotifier() : super([]) {
    _load();
  }

  Future<void> _load() async {
    final db = LocalDatabaseService.instance;
    if (db.isInitialized) {
      final entries = await db.getAllTasbihHistory();
      if (entries.isNotEmpty) {
        state = entries.map((e) => TasbihSession(
          id: e.sessionId,
          type: e.type,
          label: e.label,
          count: e.count,
          startedAt: e.startedAt,
          durationSeconds: e.durationSeconds,
        )).toList();
        return;
      }
    }
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_historyKey);
    if (raw == null) return;
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      state = list
          .map((e) => TasbihSession.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {}
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _historyKey, jsonEncode(state.map((e) => e.toJson()).toList()));
    final db = LocalDatabaseService.instance;
    if (db.isInitialized) {
      for (final s in state) {
        await db.putTasbihHistory(TasbihHistoryEntry(
          sessionId: s.id,
          type: s.type,
          label: s.label,
          count: s.count,
          startedAt: s.startedAt,
          durationSeconds: s.durationSeconds,
        ));
      }
    }
  }

  void add(TasbihSession session) {
    state = [session, ...state.take(99)];
    _save();
  }

  void clear() {
    state = [];
    _save();
  }
}

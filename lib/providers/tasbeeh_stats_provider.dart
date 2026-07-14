import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/local_database.dart';

const _statsKey = 'tasbeeh_stats_v2';

class TasbihStats {
  final int todayCount;
  final int weeklyCount;
  final int monthlyCount;
  final int lifetimeCount;
  final int longestSession;
  final int sessionStartCount;

  const TasbihStats({
    this.todayCount = 0,
    this.weeklyCount = 0,
    this.monthlyCount = 0,
    this.lifetimeCount = 0,
    this.longestSession = 0,
    this.sessionStartCount = 0,
  });

  TasbihStats copyWith({
    int? todayCount,
    int? weeklyCount,
    int? monthlyCount,
    int? lifetimeCount,
    int? longestSession,
    int? sessionStartCount,
  }) {
    return TasbihStats(
      todayCount: todayCount ?? this.todayCount,
      weeklyCount: weeklyCount ?? this.weeklyCount,
      monthlyCount: monthlyCount ?? this.monthlyCount,
      lifetimeCount: lifetimeCount ?? this.lifetimeCount,
      longestSession: longestSession ?? this.longestSession,
      sessionStartCount: sessionStartCount ?? this.sessionStartCount,
    );
  }

  Map<String, dynamic> toJson() => {
        'today': todayCount,
        'weekly': weeklyCount,
        'monthly': monthlyCount,
        'lifetime': lifetimeCount,
        'longest': longestSession,
        'sessionStart': sessionStartCount,
      };

  factory TasbihStats.fromJson(Map<String, dynamic> json) => TasbihStats(
        todayCount: json['today'] as int? ?? 0,
        weeklyCount: json['weekly'] as int? ?? 0,
        monthlyCount: json['monthly'] as int? ?? 0,
        lifetimeCount: json['lifetime'] as int? ?? 0,
        longestSession: json['longest'] as int? ?? 0,
        sessionStartCount: json['sessionStart'] as int? ?? 0,
      );
}

final tasbihStatsProvider = StateNotifierProvider<TasbihStatsNotifier, TasbihStats>((ref) {
  return TasbihStatsNotifier();
});

class TasbihStatsNotifier extends StateNotifier<TasbihStats> {
  TasbihStatsNotifier() : super(const TasbihStats()) {
    _load();
  }

  Future<void> _load() async {
    final db = LocalDatabaseService.instance;
    if (db.isInitialized) {
      final entry = await db.getTasbihStats();
      if (entry != null) {
        state = TasbihStats(
          todayCount: entry.todayCount,
          weeklyCount: 0,
          monthlyCount: 0,
          lifetimeCount: entry.totalCount,
          longestSession: 0,
          sessionStartCount: 0,
        );
        _checkDateReset(entry.date);
        return;
      }
    }
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_statsKey);
    if (raw != null) {
      try {
        final map = jsonDecode(raw) as Map<String, dynamic>;
        state = TasbihStats.fromJson(map);
      } catch (_) {}
    }
    _checkDateReset(prefs.getString('tasbih_stats_date') ?? '');
  }

  void _checkDateReset(String lastDate) {
    final now = DateTime.now();
    final todayKey = '${now.year}-${now.month}-${now.day}';
    if (lastDate != todayKey) {
      state = state.copyWith(todayCount: 0);
      _save();
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_statsKey, jsonEncode(state.toJson()));
    final db = LocalDatabaseService.instance;
    if (db.isInitialized) {
      final now = DateTime.now();
      await db.saveTasbihStats(TasbihStatsEntry(
        todayCount: state.todayCount,
        totalCount: state.lifetimeCount,
        date: '${now.year}-${now.month}-${now.day}',
        weeklyCountsJson: '[]',
        monthlyCountsJson: '[]',
        dailyGoal: 1000,
      ));
    }
  }

  void recordTap() {
    final now = DateTime.now();
    final isNewWeek = now.weekday == 6;
    final isNewMonth = now.day == 1;

    state = state.copyWith(
      todayCount: state.todayCount + 1,
      weeklyCount: isNewWeek ? 1 : state.weeklyCount + 1,
      monthlyCount: isNewMonth ? 1 : state.monthlyCount + 1,
      lifetimeCount: state.lifetimeCount + 1,
      longestSession: state.sessionStartCount > 0
          ? (state.lifetimeCount - state.sessionStartCount + 1).clamp(
              state.longestSession, 999999)
          : state.longestSession,
    );
    _save();
  }

  void startSession() {
    state = state.copyWith(sessionStartCount: state.lifetimeCount);
    _save();
  }

  void endSession() {
    final sessionCount = state.lifetimeCount - state.sessionStartCount;
    if (sessionCount > state.longestSession) {
      state = state.copyWith(longestSession: sessionCount);
    }
    _save();
  }
}

// ─── Daily Goal ───

final tasbihDailyGoalProvider = StateProvider<int>((ref) => 1000);

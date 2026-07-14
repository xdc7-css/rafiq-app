import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/storage_service.dart';

class TasbeehAlZahraState {
  final int stage; // 1: الله أكبر (34), 2: الحمد لله (33), 3: سبحان الله (33)
  final int count;
  final int totalCount;
  final String date;
  final bool isCompleted;

  TasbeehAlZahraState({
    this.stage = 1,
    this.count = 0,
    this.totalCount = 0,
    this.date = '',
    this.isCompleted = false,
  });

  int get target {
    switch (stage) {
      case 1:
        return 34;
      case 2:
        return 33;
      case 3:
        return 33;
      default:
        return 34;
    }
  }

  String get nameArabic {
    switch (stage) {
      case 1:
        return 'الله أكبر';
      case 2:
        return 'الحمد لله';
      case 3:
        return 'سبحان الله';
      default:
        return 'الله أكبر';
    }
  }

  String get stageName {
    switch (stage) {
      case 1:
        return 'المرحلة الأولى';
      case 2:
        return 'المرحلة الثانية';
      case 3:
        return 'المرحلة الثالثة';
      default:
        return 'المرحلة الأولى';
    }
  }

  TasbeehAlZahraState copyWith({
    int? stage,
    int? count,
    int? totalCount,
    String? date,
    bool? isCompleted,
  }) {
    return TasbeehAlZahraState(
      stage: stage ?? this.stage,
      count: count ?? this.count,
      totalCount: totalCount ?? this.totalCount,
      date: date ?? this.date,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stage': stage,
      'count': count,
      'totalCount': totalCount,
      'date': date,
      'isCompleted': isCompleted,
    };
  }

  factory TasbeehAlZahraState.fromJson(Map<String, dynamic> json) {
    return TasbeehAlZahraState(
      stage: json['stage'] ?? 1,
      count: json['count'] ?? 0,
      totalCount: json['totalCount'] ?? 0,
      date: json['date'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}

class TasbeehAlZahraNotifier extends StateNotifier<TasbeehAlZahraState> {
  TasbeehAlZahraNotifier() : super(TasbeehAlZahraState()) {
    _loadState();
  }

  void _loadState() {
    final todayStr = _getTodayString();
    final savedJson = StorageService.getTasbeehAlZahraState();

    if (savedJson != null) {
      try {
        final parsed = TasbeehAlZahraState.fromJson(json.decode(savedJson));
        // Reset automatically at midnight if date doesn't match
        if (parsed.date == todayStr) {
          state = parsed;
          return;
        }
      } catch (_) {
        // Fallback to default state on parse error
      }
    }
    
    // Default initial state for today
    state = TasbeehAlZahraState(date: todayStr);
    _saveState();
  }

  void _saveState() {
    StorageService.saveTasbeehAlZahraState(json.encode(state.toJson()));
  }

  String _getTodayString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  /// Increments the counter according to Tasbih Al Zahra rules.
  /// Returns a map indicating if a transition occurred:
  /// `{'stageChanged': bool, 'sessionFinished': bool}`
  Map<String, bool> increment() {
    // Check for midnight reset on tap
    final todayStr = _getTodayString();
    if (state.date != todayStr) {
      reset();
      return {'stageChanged': false, 'sessionFinished': false};
    }

    if (state.isCompleted) {
      return {'stageChanged': false, 'sessionFinished': false};
    }

    final currentTarget = state.target;
    final newCount = state.count + 1;
    final newTotal = state.totalCount + 1;

    if (newCount < currentTarget) {
      // Regular increment within the same stage
      state = state.copyWith(
        count: newCount,
        totalCount: newTotal,
      );
      _saveState();
      return {'stageChanged': false, 'sessionFinished': false};
    } else {
      // Current stage target reached!
      if (state.stage < 3) {
        // Move to the next stage automatically
        state = state.copyWith(
          stage: state.stage + 1,
          count: 0,
          totalCount: newTotal,
        );
        _saveState();
        return {'stageChanged': true, 'sessionFinished': false};
      } else {
        // Stage 3 completed (reaches 33 taps, total 100) -> Session finished!
        state = state.copyWith(
          count: currentTarget, // Lock at max target (33)
          totalCount: 100,
          isCompleted: true,
        );
        _saveState();
        return {'stageChanged': false, 'sessionFinished': true};
      }
    }
  }

  void reset() {
    state = TasbeehAlZahraState(date: _getTodayString());
    _saveState();
  }
}

final tasbeehAlZahraProvider =
    StateNotifierProvider<TasbeehAlZahraNotifier, TasbeehAlZahraState>((ref) {
  return TasbeehAlZahraNotifier();
});

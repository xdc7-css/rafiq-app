import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/haptic_service.dart';

enum TasbihAlZahraStage { takbeer, tahmeed, tasbeeh }

class TasbihAlZahraState {
  final TasbihAlZahraStage stage;
  final int currentCount;
  final int totalCount;
  final bool isComplete;
  final bool justAdvanced;
  final String? completedDhikr;
  final bool vibration;

  const TasbihAlZahraState({
    this.stage = TasbihAlZahraStage.takbeer,
    this.currentCount = 0,
    this.totalCount = 0,
    this.isComplete = false,
    this.justAdvanced = false,
    this.completedDhikr,
    this.vibration = true,
  });

  int get target {
    switch (stage) {
      case TasbihAlZahraStage.takbeer:
        return 34;
      case TasbihAlZahraStage.tahmeed:
        return 33;
      case TasbihAlZahraStage.tasbeeh:
        return 33;
    }
  }

  double get progress => target > 0 ? currentCount / target : 0;

  int get remaining => 100 - totalCount;

  String get stageArabic {
    switch (stage) {
      case TasbihAlZahraStage.takbeer:
        return 'المرحلة الأولى';
      case TasbihAlZahraStage.tahmeed:
        return 'المرحلة الثانية';
      case TasbihAlZahraStage.tasbeeh:
        return 'المرحلة الثالثة';
    }
  }

  String get currentDhikr {
    switch (stage) {
      case TasbihAlZahraStage.takbeer:
        return 'الله أكبر';
      case TasbihAlZahraStage.tahmeed:
        return 'الحمد لله';
      case TasbihAlZahraStage.tasbeeh:
        return 'سبحان الله';
    }
  }

  TasbihAlZahraState copyWith({
    TasbihAlZahraStage? stage,
    int? currentCount,
    int? totalCount,
    bool? isComplete,
    bool? justAdvanced,
    String? completedDhikr,
    bool? vibration,
  }) {
    return TasbihAlZahraState(
      stage: stage ?? this.stage,
      currentCount: currentCount ?? this.currentCount,
      totalCount: totalCount ?? this.totalCount,
      isComplete: isComplete ?? this.isComplete,
      justAdvanced: justAdvanced ?? this.justAdvanced,
      completedDhikr: completedDhikr ?? this.completedDhikr,
      vibration: vibration ?? this.vibration,
    );
  }
}

class TasbihAlZahraNotifier extends StateNotifier<TasbihAlZahraState> {
  Timer? _advanceTimer;

  TasbihAlZahraNotifier() : super(const TasbihAlZahraState());

  void setVibration(bool enabled) => state = state.copyWith(vibration: enabled);

  void increment() {
    if (state.isComplete) return;

    final newCount = state.currentCount + 1;
    final newTotal = state.totalCount + 1;

    if (state.stage == TasbihAlZahraStage.takbeer && newCount >= 34) {
      _advanceTo(
        stage: TasbihAlZahraStage.tahmeed,
        totalCount: newTotal,
        completedDhikr: 'الله أكبر',
      );
    } else if (state.stage == TasbihAlZahraStage.tahmeed && newCount >= 33) {
      _advanceTo(
        stage: TasbihAlZahraStage.tasbeeh,
        totalCount: newTotal,
        completedDhikr: 'الحمد لله',
      );
    } else if (state.stage == TasbihAlZahraStage.tasbeeh && newCount >= 33) {
      state = state.copyWith(
        currentCount: newCount,
        totalCount: newTotal,
        isComplete: true,
      );
      if (state.vibration) HapticService.instance.strongTap();
    } else {
      state = state.copyWith(
        currentCount: newCount,
        totalCount: newTotal,
      );
      if (state.vibration) {
        switch (state.stage) {
          case TasbihAlZahraStage.tasbeeh:
            HapticService.instance.mediumTap();
            break;
          case TasbihAlZahraStage.tahmeed:
            HapticService.instance.lightTap();
            break;
          case TasbihAlZahraStage.takbeer:
            HapticService.instance.mediumTap();
            break;
        }
      }
    }
  }

  void _advanceTo({
    required TasbihAlZahraStage stage,
    required int totalCount,
    required String completedDhikr,
  }) {
    if (state.vibration) HapticService.instance.strongTap();

    state = state.copyWith(
      stage: stage,
      currentCount: 0,
      totalCount: totalCount,
      justAdvanced: true,
      completedDhikr: completedDhikr,
    );

    _advanceTimer?.cancel();
    _advanceTimer = Timer(const Duration(milliseconds: 1200), () {
      if (mounted) {
        state = state.copyWith(justAdvanced: false, completedDhikr: null);
      }
    });
  }

  void reset() {
    _advanceTimer?.cancel();
    state = const TasbihAlZahraState();
    if (state.vibration) HapticService.instance.mediumTap();
  }

  @override
  void dispose() {
    _advanceTimer?.cancel();
    super.dispose();
  }
}

final tasbihAlZahraProvider =
    StateNotifierProvider<TasbihAlZahraNotifier, TasbihAlZahraState>((ref) {
  return TasbihAlZahraNotifier();
});

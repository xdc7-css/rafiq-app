import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../services/permission_service.dart';

enum OnboardingStep {
  welcome,
  notifications,
  exactAlarm,
  batteryOptimization,
  backgroundActivity,
  autoStart,
  audio,
  summary,
}

class OnboardingState {
  final OnboardingStep step;
  final bool notificationsGranted;
  final bool exactAlarmGranted;
  final bool batteryOptimized;
  final bool autoStartSupported;

  const OnboardingState({
    this.step = OnboardingStep.welcome,
    this.notificationsGranted = false,
    this.exactAlarmGranted = false,
    this.batteryOptimized = true,
    this.autoStartSupported = false,
  });

  OnboardingState copyWith({
    OnboardingStep? step,
    bool? notificationsGranted,
    bool? exactAlarmGranted,
    bool? batteryOptimized,
    bool? autoStartSupported,
  }) {
    return OnboardingState(
      step: step ?? this.step,
      notificationsGranted: notificationsGranted ?? this.notificationsGranted,
      exactAlarmGranted: exactAlarmGranted ?? this.exactAlarmGranted,
      batteryOptimized: batteryOptimized ?? this.batteryOptimized,
      autoStartSupported: autoStartSupported ?? this.autoStartSupported,
    );
  }

  int get totalSteps => OnboardingStep.values.length;
  int get currentStepIndex => OnboardingStep.values.indexOf(step);
  double get progress => (currentStepIndex + 1) / totalSteps;

  bool get isLastStep => step == OnboardingStep.summary;
}

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  OnboardingNotifier() : super(const OnboardingState()) {
    _checkInitialPermissions();
  }

  Future<void> _checkInitialPermissions() async {
    final notifications = await PermissionService.checkNotificationPermission();
    final exactAlarm = await PermissionService.checkExactAlarmPermission();
    final battery = await PermissionService.checkBatteryOptimizationExemption();
    final autoStart = PermissionService.supportsAutoStart;

    state = state.copyWith(
      notificationsGranted: notifications,
      exactAlarmGranted: exactAlarm,
      batteryOptimized: battery,
      autoStartSupported: autoStart,
    );
  }

  void next() {
    if (state.isLastStep) return;
    final steps = OnboardingStep.values;
    final nextIndex = state.currentStepIndex + 1;
    if (nextIndex < steps.length) {
      state = state.copyWith(step: steps[nextIndex]);
    }
  }

  void previous() {
    if (state.step == OnboardingStep.welcome) return;
    final steps = OnboardingStep.values;
    final prevIndex = state.currentStepIndex - 1;
    if (prevIndex >= 0) {
      state = state.copyWith(step: steps[prevIndex]);
    }
  }

  void goTo(OnboardingStep step) {
    state = state.copyWith(step: step);
  }

  Future<void> requestNotifications() async {
    final granted = await PermissionService.requestNotificationPermission();
    state = state.copyWith(notificationsGranted: granted);
  }

  Future<void> requestExactAlarm() async {
    await PermissionService.requestExactAlarmPermission();
    final granted = await PermissionService.checkExactAlarmPermission();
    state = state.copyWith(exactAlarmGranted: granted);
  }

  Future<void> requestBatteryExemption() async {
    final granted = await PermissionService.requestBatteryOptimizationExemption();
    state = state.copyWith(batteryOptimized: granted);
  }

  Future<void> openAutoStart() async {
    await PermissionService.openAutoStartSettings();
  }

  Future<void> openBatterySettings() async {
    await PermissionService.openBatterySettings();
  }

  Future<void> refreshPermissions() async {
    await _checkInitialPermissions();
  }
}

final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
  return OnboardingNotifier();
});

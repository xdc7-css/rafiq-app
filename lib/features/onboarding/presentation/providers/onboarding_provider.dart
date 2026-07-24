import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/permission_models.dart';
import '../../../../services/permission_request_controller.dart';

// ═══════════════════════════════════════════════════════════════════
// State
// ═══════════════════════════════════════════════════════════════════

class OnboardingState {
  /// Current screen: 0 = welcome, 1 = permissions, 2 = finished
  final int screen;

  /// The shared permission controller (platform-aware)
  final PermissionRequestController controller;

  const OnboardingState({
    required this.screen,
    required this.controller,
  });

  OnboardingState copyWith({int? screen}) {
    return OnboardingState(
      screen: screen ?? this.screen,
      controller: controller,
    );
  }

  bool get isWelcome => screen == 0;
  bool get isPermissions => screen == 1;
  bool get isFinished => screen == 2;
}

// ═══════════════════════════════════════════════════════════════════
// Notifier
// ═══════════════════════════════════════════════════════════════════

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  late final PermissionRequestController _controller;

  OnboardingNotifier()
      : super(OnboardingState(
          screen: 0,
          controller: PermissionRequestController(
            PermissionRegistry.onboardingPermissions(),
          ),
        )) {
    _controller = state.controller;
    _controller.addListener(_onControllerUpdate);
    _controller.checkInitialPermissions();
  }

  void _onControllerUpdate() {
    state = state.copyWith();
  }

  // ── Navigation ──────────────────────────────────────────────────

  void goToScreen(int screen) {
    state = state.copyWith(screen: screen);
  }

  // ── Permission Requests (delegated to controller) ──────────────

  Future<void> requestAllPermissions() async {
    await _controller.requestAllPermissions();

    // If blocked by a denied root permission, stay on permissions screen
    if (_controller.blockedByRoot) {
      return;
    }

    await Future.delayed(const Duration(milliseconds: 400));
    if (mounted) {
      state = state.copyWith(screen: 2);
    }
  }

  Future<void> retryPermission(PermissionKey key) async {
    await _controller.retryPermission(key);
  }

  /// Re-checks permissions (e.g., after returning from system settings).
  Future<void> recheckPermissions() async {
    await _controller.checkInitialPermissions();
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerUpdate);
    _controller.dispose();
    super.dispose();
  }
}

final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
  return OnboardingNotifier();
});

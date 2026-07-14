import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

extension GoRouterGuard on BuildContext {
  void pushRoute(String location, {Object? extra}) {
    final currentPath = GoRouterState.of(this).uri.toString();
    if (currentPath == location) return;
    if (currentPath.startsWith('$location?')) return;
    GoRouter.of(this).push(location, extra: extra);
  }

  bool isCurrentRoute(String location) {
    final currentPath = GoRouterState.of(this).uri.toString();
    return currentPath == location || currentPath.startsWith('$location?');
  }
}

import 'dart:async';
import '../models/permission_models.dart';
import 'permission_analytics_service.dart';
import 'permission_dependency_graph.dart';
import 'permission_request_controller.dart';

/// Orchestrates the permission request flow using the dependency graph.
///
/// Single responsibility: determine which permissions can be requested,
/// request them in the correct order, handle dependency blocks, and
/// report analytics. Contains no UI logic.
class PermissionFlowCoordinator {
  final PermissionRequestController _controller;
  final PermissionDependencyGraph _graph;

  PermissionFlowCoordinator({
    required this._controller,
    PermissionDependencyGraph? graph,
  }) : _graph = graph ?? PermissionDependencyGraph.defaultGraph;

  PermissionRequestController get controller => _controller;

  /// Runs the full permission request flow, respecting the dependency graph.
  ///
  /// Returns a [FlowResult] indicating what happened.
  Future<FlowResult> runFlow(List<PermissionDefinition> permissions) async {
    final statuses = _controller.statuses;
    final requestable = permissions
        .where((p) => p.isRequestable && !p.isInformational)
        .toList();
    final tiers = _graph.tiers(requestable.map((p) => p.key).toList());

    int granted = 0;
    int total = requestable.length;

    for (final tier in tiers) {
      for (final key in tier) {
        if (statuses[key] == PermissionUIStatus.granted) {
          granted++;
          continue;
        }

        if (!_graph.canRequest(key, statuses)) {
          final root = _findBlockingRoot(key, statuses);
          if (root != null) {
            PermissionAnalyticsService.dependencyBlocked(
              blocked: key,
              root: root,
            );
          }
          PermissionAnalyticsService.flowAbandoned(
            atPermission: key.name,
            granted: granted,
            total: total,
          );
          return FlowResult.blocked(
            blockedKey: key,
            blockingRoot: root,
            grantedCount: granted,
            totalCount: total,
          );
        }

        // Request this permission
        PermissionAnalyticsService.permissionRequested(key);
        await _controller.retryPermission(key);
        final newStatus = _controller.status(key);
        if (newStatus == PermissionUIStatus.granted) {
          granted++;
          PermissionAnalyticsService.permissionGranted(key);
        } else {
          PermissionAnalyticsService.permissionDenied(key);
        }
      }
    }

    PermissionAnalyticsService.flowCompleted(granted: granted, total: total);
    return FlowResult.completed(grantedCount: granted, totalCount: total);
  }

  PermissionKey? _findBlockingRoot(
    PermissionKey key,
    Map<PermissionKey, PermissionUIStatus> statuses,
  ) {
    final root = _graph.rootOf(key);
    if (root != null && statuses[root] != PermissionUIStatus.granted) {
      return root;
    }
    return null;
  }

  /// Handles the case where the user manually grants notifications
  /// (e.g., from the OEM guidance card) and returns to the app.
  ///
  /// Re-checks the root permission and returns true if it's now granted.
  Future<bool> recheckRoot(List<PermissionDefinition> permissions) async {
    final roots = _graph.roots;
    for (final root in roots) {
      final granted = await PermissionRegistry.checkPermission(root);
      if (granted) {
        _controller.updateStatus(root, PermissionUIStatus.granted);
      }
    }
    return _graph.canRequest(
      permissions.firstWhere((p) => p.isRequestable).key,
      _controller.statuses,
    );
  }
}

/// Result of a permission flow execution.
class FlowResult {
  final FlowResultType type;
  final PermissionKey? blockedKey;
  final PermissionKey? blockingRoot;
  final int grantedCount;
  final int totalCount;

  const FlowResult._({
    required this.type,
    this.blockedKey,
    this.blockingRoot,
    required this.grantedCount,
    required this.totalCount,
  });

  factory FlowResult.completed({
    required int grantedCount,
    required int totalCount,
  }) => FlowResult._(
    type: FlowResultType.completed,
    grantedCount: grantedCount,
    totalCount: totalCount,
  );

  factory FlowResult.blocked({
    required PermissionKey blockedKey,
    PermissionKey? blockingRoot,
    required int grantedCount,
    required int totalCount,
  }) => FlowResult._(
    type: FlowResultType.blocked,
    blockedKey: blockedKey,
    blockingRoot: blockingRoot,
    grantedCount: grantedCount,
    totalCount: totalCount,
  );

  bool get isBlocked => type == FlowResultType.blocked;
  bool get isCompleted => type == FlowResultType.completed;
}

enum FlowResultType { completed, blocked }

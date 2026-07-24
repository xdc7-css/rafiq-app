import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/permission_models.dart';
import 'permission_analytics_service.dart';
import 'permission_dependency_graph.dart';

enum PermissionUIStatus { waiting, requesting, granted, denied }

class PermissionRequestController extends ChangeNotifier {
  /// The list of permissions that apply on this platform.
  final List<PermissionDefinition> _permissions;

  /// The dependency graph governing request order.
  final PermissionDependencyGraph _graph;

  /// Dynamic status map — only keys from the registry exist here.
  final Map<PermissionKey, PermissionUIStatus> _statuses = {};

  bool _requesting = false;
  int _activeIndex = -1;
  bool _blockedByRoot = false;
  PermissionKey? _blockedRoot;

  PermissionRequestController(
    List<PermissionDefinition> permissions, {
    PermissionDependencyGraph? graph,
  })  : _permissions = permissions,
        _graph = graph ?? PermissionDependencyGraph.defaultGraph {
    for (final p in _permissions) {
      _statuses[p.key] = PermissionUIStatus.waiting;
    }
  }

  Map<PermissionKey, PermissionUIStatus> get statuses =>
      Map.unmodifiable(_statuses);
  bool get requesting => _requesting;
  int get activeIndex => _activeIndex;
  int get totalCount => _permissions.length;
  bool get blockedByRoot => _blockedByRoot;
  PermissionKey? get blockedRoot => _blockedRoot;

  int get grantedCount =>
      _statuses.values.where((s) => s == PermissionUIStatus.granted).length;

  bool get allGranted =>
      _statuses.values.isNotEmpty &&
      _statuses.values.every((s) => s == PermissionUIStatus.granted);

  PermissionUIStatus status(PermissionKey key) =>
      _statuses[key] ?? PermissionUIStatus.waiting;

  /// Manually sets the status for a permission (e.g., after external recheck).
  void updateStatus(PermissionKey key, PermissionUIStatus newStatus) {
    if (_statuses[key] != newStatus) {
      _statuses[key] = newStatus;
      notifyListeners();
    }
  }

  // ── Initial Check ─────────────────────────────────────────────

  Future<void> checkInitialPermissions() async {
    for (final perm in _permissions) {
      if (perm.isInformational) {
        _statuses[perm.key] = PermissionUIStatus.granted;
      } else {
        final granted = await PermissionRegistry.checkPermission(perm.key);
        _statuses[perm.key] =
            granted ? PermissionUIStatus.granted : PermissionUIStatus.waiting;
      }
    }
    notifyListeners();
  }

  // ── Sequential Request (dependency-graph-aware) ───────────────

  Future<void> requestAllPermissions() async {
    if (_requesting) return;
    _requesting = true;
    _blockedByRoot = false;
    _blockedRoot = null;
    notifyListeners();

    final requestable =
        _permissions.where((p) => p.isRequestable && !p.isInformational).toList();
    final tiers = _graph.tiers(requestable.map((p) => p.key).toList());

    int index = 0;
    for (final tier in tiers) {
      for (final key in tier) {
        if (_statuses[key] == PermissionUIStatus.granted) {
          index++;
          continue;
        }

        if (!_graph.canRequest(key, _statuses)) {
          _blockedByRoot = true;
          _blockedRoot = _graph.rootOf(key);
          _activeIndex = -1;
          _requesting = false;
          if (_blockedRoot != null) {
            PermissionAnalyticsService.dependencyBlocked(
              blocked: key,
              root: _blockedRoot!,
            );
          }
          PermissionAnalyticsService.flowAbandoned(
            atPermission: key.name,
            granted: grantedCount,
            total: requestable.length,
          );
          notifyListeners();
          return;
        }

        _activeIndex = index;
        _statuses[key] = PermissionUIStatus.requesting;
        notifyListeners();

        try {
          PermissionAnalyticsService.permissionRequested(key);
          final granted = await PermissionRegistry.requestPermission(key);
          _statuses[key] =
              granted ? PermissionUIStatus.granted : PermissionUIStatus.denied;
          if (granted) {
            PermissionAnalyticsService.permissionGranted(key);
          } else {
            PermissionAnalyticsService.permissionDenied(key);
          }
        } catch (_) {
          _statuses[key] = PermissionUIStatus.denied;
          PermissionAnalyticsService.permissionDenied(key);
        }
        index++;
      }
    }

    _activeIndex = -1;
    _requesting = false;
    PermissionAnalyticsService.flowCompleted(
      granted: grantedCount,
      total: requestable.length,
    );
    notifyListeners();
  }

  // ── Individual Retry ──────────────────────────────────────────

  Future<void> retryPermission(PermissionKey key) async {
    _statuses[key] = PermissionUIStatus.requesting;
    notifyListeners();

    try {
      PermissionAnalyticsService.permissionRequested(key);
      final granted = await PermissionRegistry.requestPermission(key);
      _statuses[key] =
          granted ? PermissionUIStatus.granted : PermissionUIStatus.denied;
      if (granted) {
        PermissionAnalyticsService.permissionGranted(key);
      } else {
        PermissionAnalyticsService.permissionDenied(key);
      }
    } catch (_) {
      _statuses[key] = PermissionUIStatus.denied;
      PermissionAnalyticsService.permissionDenied(key);
    }

    notifyListeners();
  }
}

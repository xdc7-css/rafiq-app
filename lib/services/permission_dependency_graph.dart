import '../models/permission_models.dart';
import 'permission_request_controller.dart';

/// Defines dependency relationships between permissions.
///
/// Permissions form a tree where [PermissionKey.notifications] is the root.
/// If the root is denied, dependent permissions are not requested automatically.
class PermissionDependencyGraph {
  final Map<PermissionKey, List<PermissionKey>> _dependencies;

  const PermissionDependencyGraph(this._dependencies);

  /// The default dependency graph for this application.
  ///
  /// ```
  /// Notifications (root)
  ///   ├── ExactAlarm
  ///   ├── Battery
  ///   └── Foreground
  /// ```
  static final defaultGraph = PermissionDependencyGraph({
    PermissionKey.notifications: [
      PermissionKey.exactAlarm,
      PermissionKey.battery,
      PermissionKey.foreground,
    ],
  });

  /// Returns the direct dependents of [key].
  List<PermissionKey> dependentsOf(PermissionKey key) =>
      _dependencies[key] ?? const [];

  /// Returns the root permission that [key] depends on, or null if [key] is a root.
  PermissionKey? rootOf(PermissionKey key) {
    for (final entry in _dependencies.entries) {
      if (entry.value.contains(key)) return entry.key;
    }
    return null;
  }

  /// Returns the root permissions (those with no dependents in the map as values).
  List<PermissionKey> get roots {
    final dependedOn = _dependencies.values.expand((e) => e).toSet();
    return _dependencies.keys
        .where((k) => !dependedOn.contains(k))
        .toList();
  }

  /// Checks whether [key] can be requested given the current grant statuses.
  ///
  /// A permission can be requested if ALL of its prerequisites are granted.
  /// Prerequisites are determined by finding which root permission depends on [key].
  bool canRequest(
    PermissionKey key,
    Map<PermissionKey, PermissionUIStatus> statuses,
  ) {
    for (final entry in _dependencies.entries) {
      if (entry.value.contains(key)) {
        final rootStatus = statuses[entry.key];
        if (rootStatus != PermissionUIStatus.granted) return false;
      }
    }
    return true;
  }

  /// Returns the ordered list of permissions to request, respecting dependencies.
  ///
  /// Permissions are grouped into tiers. Tier 0 (roots) is always first.
  /// Tier 1 depends on tier 0, etc. Within a tier, order is preserved.
  List<List<PermissionKey>> tiers(List<PermissionKey> all) {
    final assigned = <PermissionKey, int>{};
    bool changed = true;
    while (changed) {
      changed = false;
      for (final key in all) {
        if (assigned.containsKey(key)) continue;
        final deps = dependentsOf(key);
        if (deps.isEmpty) {
          assigned[key] = 0;
          changed = true;
        } else if (deps.every((d) => assigned.containsKey(d))) {
          assigned[key] = deps.map((d) => assigned[d]!).reduce((a, b) => a > b ? a : b) + 1;
          changed = true;
        }
      }
    }
    if (assigned.isEmpty) return [all];

    final maxTier = assigned.values.reduce((a, b) => a > b ? a : b);
    final result = <List<PermissionKey>>[];
    for (var i = 0; i <= maxTier; i++) {
      result.add(all.where((k) => assigned[k] == i).toList());
    }
    return result;
  }
}

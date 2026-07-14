import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../../core/arabic_strings.dart';

class PermissionDialog {
  static Future<void> showGpsDisabled(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.location_off, color: Theme.of(context).colorScheme.error),
            const SizedBox(width: 12),
            Expanded(child: Text(Ar.gpsDisabledTitle)),
          ],
        ),
        content: Text(Ar.gpsDisabledMsg),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          FilledButton.icon(
            onPressed: () {
              Navigator.pop(ctx);
              Geolocator.openLocationSettings();
            },
            icon: const Icon(Icons.settings),
            label: Text(Ar.openLocationSettings),
          ),
        ],
      ),
    );
  }

  static Future<void> showPermissionDenied(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.shield, color: Theme.of(context).colorScheme.error),
            const SizedBox(width: 12),
            Expanded(child: Text(Ar.permissionDeniedTitle)),
          ],
        ),
        content: Text(Ar.permissionDeniedMsg),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          FilledButton.icon(
            onPressed: () {
              Navigator.pop(ctx);
              Geolocator.openAppSettings();
            },
            icon: const Icon(Icons.settings),
            label: Text(Ar.openAppSettings),
          ),
        ],
      ),
    );
  }

  static Future<void> showLocationRequest({
    required BuildContext context,
    required VoidCallback onGranted,
  }) async {
    final perm = await Geolocator.requestPermission();
    if (perm == LocationPermission.whileInUse ||
        perm == LocationPermission.always) {
      onGranted();
    } else if (perm == LocationPermission.deniedForever) {
      await showPermissionDenied(context);
    }
  }
}

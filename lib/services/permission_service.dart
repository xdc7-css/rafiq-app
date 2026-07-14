import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static bool get hasRequestedExactAlarm => true;

  static Future<bool> requestNotificationPermission() async {
    // Platform.operatingSystem throws on Web — check kIsWeb first.
    if (kIsWeb || !Platform.isAndroid) return true;

    final androidPlugin =
        _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin == null) return false;

    final granted = await androidPlugin.requestNotificationsPermission();

    return granted ?? false;
  }

  static Future<bool> checkNotificationPermission() async {
    if (kIsWeb || !Platform.isAndroid) return true;

    final androidPlugin =
        _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin == null) return false;

    try {
      final granted = await androidPlugin.areNotificationsEnabled() ?? false;
      return granted;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> requestExactAlarmPermission() async {
    if (kIsWeb || !Platform.isAndroid) return true;

    final androidPlugin =
        _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin == null) return false;

    final granted = await androidPlugin.requestExactAlarmsPermission();

    return granted ?? false;
  }

  static Future<bool> checkExactAlarmPermission() async {
    if (kIsWeb || !Platform.isAndroid) return true;
    try {
      return await Permission.scheduleExactAlarm.isGranted;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> requestBatteryOptimizationExemption() async {
    if (kIsWeb || !Platform.isAndroid) return true;
    
    try {
      final status = await Permission.ignoreBatteryOptimizations.status;
      if (status.isGranted) return true;
      final result = await Permission.ignoreBatteryOptimizations.request();
      return result.isGranted;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> checkBatteryOptimizationExemption() async {
    if (kIsWeb || !Platform.isAndroid) return true;
    try {
      return await Permission.ignoreBatteryOptimizations.isGranted;
    } catch (_) {
      return false;
    }
  }

  static bool get supportsAutoStart => Platform.isAndroid;

  static bool get isXiaomi => false;
  static bool get isHuawei => false;
  static bool get isOppo => false;
  static bool get isVivo => false;
  static bool get isOnePlus => false;
  static bool get isSamsung => false;

  static Future<void> openAutoStartSettings() async {
    if (kIsWeb || !Platform.isAndroid) return;
    try {
      await openAppSettings();
    } catch (_) {}
  }

  static Future<void> openBatterySettings() async {
    if (kIsWeb || !Platform.isAndroid) return;
    try {
      await openAppSettings();
    } catch (_) {}
  }
}

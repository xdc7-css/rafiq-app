import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Result of an OEM battery settings open attempt.
enum OemSettingsResult {
  openedOemSettings,
  openedBatterySettings,
  openedAppSettings,
  unsupportedDevice,
  failed,
}

/// OEM type matching the Kotlin OemType enum.
enum OemType {
  vivo,
  iqoo,
  xiaomi,
  redmi,
  poco,
  oppo,
  realme,
  oneplus,
  huawei,
  honor,
  harmonyOs,
  generic,
}

/// A single instruction step for a specific OEM.
class InstructionStep {
  final String title;
  final String description;
  final String icon;

  const InstructionStep({
    required this.title,
    required this.description,
    required this.icon,
  });

  factory InstructionStep.fromMap(Map<dynamic, dynamic> map) => InstructionStep(
        title: map['title'] as String? ?? '',
        description: map['description'] as String? ?? '',
        icon: map['icon'] as String? ?? 'info',
      );
}

/// Full device diagnostics returned by the native module.
class DeviceDiagnostics {
  final String manufacturer;
  final String manufacturerRaw;
  final String brand;
  final String model;
  final String display;
  final String product;
  final int sdkInt;
  final String androidVersion;
  final OemType oemType;
  final bool isSupportedOem;
  final bool isIgnoringBatteryOptimizations;
  final bool isHarmonyOs;
  final List<InstructionStep> instructions;
  final String instructionsSummary;

  const DeviceDiagnostics({
    required this.manufacturer,
    required this.manufacturerRaw,
    required this.brand,
    required this.model,
    required this.display,
    required this.product,
    required this.sdkInt,
    required this.androidVersion,
    required this.oemType,
    required this.isSupportedOem,
    required this.isIgnoringBatteryOptimizations,
    required this.isHarmonyOs,
    required this.instructions,
    required this.instructionsSummary,
  });

  factory DeviceDiagnostics.fromMap(Map<dynamic, dynamic> map) {
    final instructionsRaw = map['instructions'] as List<dynamic>? ?? [];
    return DeviceDiagnostics(
      manufacturer: map['manufacturer'] as String? ?? 'Unknown',
      manufacturerRaw: map['manufacturerRaw'] as String? ?? '',
      brand: map['brand'] as String? ?? '',
      model: map['model'] as String? ?? '',
      display: map['display'] as String? ?? '',
      product: map['product'] as String? ?? '',
      sdkInt: (map['sdkInt'] as num?)?.toInt() ?? 0,
      androidVersion: map['androidVersion'] as String? ?? '',
      oemType: _parseOemType(map['oemType'] as String?),
      isSupportedOem: map['isSupportedOem'] as bool? ?? false,
      isIgnoringBatteryOptimizations:
          map['isIgnoringBatteryOptimizations'] as bool? ?? false,
      isHarmonyOs: map['isHarmonyOs'] as bool? ?? false,
      instructions: instructionsRaw
          .map((e) => InstructionStep.fromMap(e as Map<dynamic, dynamic>))
          .toList(),
      instructionsSummary: map['instructionsSummary'] as String? ?? '',
    );
  }

  static OemType _parseOemType(String? value) {
    if (value == null) return OemType.generic;
    for (final type in OemType.values) {
      if (type.name == value) return type;
    }
    return OemType.generic;
  }

  /// Human-readable device description.
  String get deviceDescription {
    final parts = <String>[manufacturer];
    if (model.isNotEmpty && model != manufacturer) parts.add(model);
    if (isHarmonyOs) parts.add('HarmonyOS');
    parts.add('Android $androidVersion (SDK $sdkInt)');
    return parts.join(' · ');
  }

  /// Battery status text for UI.
  String get batteryStatusText {
    return isIgnoringBatteryOptimizations
        ? 'تم تقييد البطارية — قد لا يعمل الأذان بشكل موثوق'
        : 'تم تثبيت البطارية — يعمل بشكل طبيعي';
  }
}

/// Structured result of opening OEM battery settings.
class OemSettingsOutcome {
  final OemSettingsResult result;
  final String manufacturer;
  final bool isSupportedOem;
  final bool isIgnoringBatteryOptimizations;

  const OemSettingsOutcome({
    required this.result,
    required this.manufacturer,
    required this.isSupportedOem,
    required this.isIgnoringBatteryOptimizations,
  });

  factory OemSettingsOutcome.fromMap(Map<dynamic, dynamic> map) {
    return OemSettingsOutcome(
      result: _parseResult(map['result'] as String? ?? 'failed'),
      manufacturer: map['manufacturer'] as String? ?? 'Unknown',
      isSupportedOem: map['isSupportedOem'] as bool? ?? false,
      isIgnoringBatteryOptimizations:
          map['isIgnoringBatteryOptimizations'] as bool? ?? false,
    );
  }

  static OemSettingsResult _parseResult(String code) {
    switch (code) {
      case 'opened_oem_settings':
        return OemSettingsResult.openedOemSettings;
      case 'opened_battery_settings':
        return OemSettingsResult.openedBatterySettings;
      case 'opened_app_settings':
        return OemSettingsResult.openedAppSettings;
      case 'unsupported_device':
        return OemSettingsResult.unsupportedDevice;
      default:
        return OemSettingsResult.failed;
    }
  }
}

/// Reusable Flutter helper for OEM battery optimization settings.
///
/// Wraps the MethodChannel calls to the native OemCompatibility module.
class AdhanBatteryHelper {
  static const _channel = MethodChannel('com.dailyislamicwidget/adhan');

  AdhanBatteryHelper._();
  static final AdhanBatteryHelper instance = AdhanBatteryHelper._();

  /// Opens OEM-specific battery/AutoStart settings with full fallback chain.
  Future<OemSettingsOutcome> openBatteryOptimizationSettings() async {
    if (kIsWeb) {
      return const OemSettingsOutcome(
        result: OemSettingsResult.failed,
        manufacturer: 'Web',
        isSupportedOem: false,
        isIgnoringBatteryOptimizations: false,
      );
    }
    try {
      final result = await _channel.invokeMethod<Map<dynamic, dynamic>>(
        'openOemBatterySettings',
      );
      if (result == null) {
        return const OemSettingsOutcome(
          result: OemSettingsResult.failed,
          manufacturer: 'Unknown',
          isSupportedOem: false,
          isIgnoringBatteryOptimizations: false,
        );
      }
      return OemSettingsOutcome.fromMap(result);
    } catch (e, st) {
      debugPrint('[AdhanBatteryHelper] openBatteryOptimizationSettings failed: $e\n$st');
      return const OemSettingsOutcome(
        result: OemSettingsResult.failed,
        manufacturer: 'Unknown',
        isSupportedOem: false,
        isIgnoringBatteryOptimizations: false,
      );
    }
  }

  /// Returns full device diagnostics including battery status, OEM detection,
  /// and manufacturer-specific instructions.
  Future<DeviceDiagnostics> getDeviceDiagnostics() async {
    if (kIsWeb) {
      return const DeviceDiagnostics(
        manufacturer: 'Web',
        manufacturerRaw: 'web',
        brand: 'web',
        model: '',
        display: '',
        product: '',
        sdkInt: 0,
        androidVersion: '',
        oemType: OemType.generic,
        isSupportedOem: false,
        isIgnoringBatteryOptimizations: false,
        isHarmonyOs: false,
        instructions: [],
        instructionsSummary: '',
      );
    }
    try {
      final result = await _channel.invokeMethod<Map<dynamic, dynamic>>(
        'getDeviceDiagnostics',
      );
      if (result == null) {
        return const DeviceDiagnostics(
          manufacturer: 'Unknown',
          manufacturerRaw: '',
          brand: '',
          model: '',
          display: '',
          product: '',
          sdkInt: 0,
          androidVersion: '',
          oemType: OemType.generic,
          isSupportedOem: false,
          isIgnoringBatteryOptimizations: false,
          isHarmonyOs: false,
          instructions: [],
          instructionsSummary: '',
        );
      }
      return DeviceDiagnostics.fromMap(result);
    } catch (e, st) {
      debugPrint('[AdhanBatteryHelper] getDeviceDiagnostics failed: $e\n$st');
      return const DeviceDiagnostics(
        manufacturer: 'Unknown',
        manufacturerRaw: '',
        brand: '',
        model: '',
        display: '',
        product: '',
        sdkInt: 0,
        androidVersion: '',
        oemType: OemType.generic,
        isSupportedOem: false,
        isIgnoringBatteryOptimizations: false,
        isHarmonyOs: false,
        instructions: [],
        instructionsSummary: '',
      );
    }
  }
}

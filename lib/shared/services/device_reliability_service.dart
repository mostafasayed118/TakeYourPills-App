import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

import 'notification_service.dart';

/// OEM / OS guidance for reliable medication reminders.
///
/// Aggressive battery managers (Xiaomi, Huawei, Oppo, …) and Android 12+
/// exact-alarm restrictions are the main failure modes for dose alerts.
class DeviceReliabilityService {
  DeviceReliabilityService({
    required NotificationService notificationService,
    DeviceInfoPlugin? deviceInfo,
  }) : _notifications = notificationService,
       _deviceInfo = deviceInfo ?? DeviceInfoPlugin();

  final NotificationService _notifications;
  final DeviceInfoPlugin _deviceInfo;

  /// Manufacturers known to kill background / alarm work by default.
  static const aggressiveManufacturers = <String>{
    'xiaomi',
    'redmi',
    'poco',
    'huawei',
    'honor',
    'oppo',
    'oneplus',
    'realme',
    'vivo',
    'iqoo',
    'meizu',
    'tecno',
    'infinix',
    'samsung', // Adaptive Battery can delay alarms
  };

  String? _manufacturer;
  bool _loaded = false;

  Future<void> ensureLoaded() async {
    if (_loaded) return;
    _loaded = true;
    if (!Platform.isAndroid) {
      _manufacturer = null;
      return;
    }
    try {
      final info = await _deviceInfo.androidInfo;
      _manufacturer = info.manufacturer.toLowerCase().trim();
    } on Object catch (e) {
      if (kDebugMode) {
        debugPrint('DeviceReliability: manufacturer lookup failed: $e');
      }
      _manufacturer = null;
    }
  }

  String get manufacturerLabel {
    final m = _manufacturer;
    if (m == null || m.isEmpty) return 'your device';
    return m[0].toUpperCase() + m.substring(1);
  }

  bool get isAggressiveOem {
    final m = _manufacturer;
    if (m == null) return false;
    return aggressiveManufacturers.any(m.contains);
  }

  Future<bool> get notificationsGranted =>
      _notifications.isPermissionGranted();

  Future<bool> get exactAlarmsAllowed =>
      _notifications.canScheduleExactAlarms();

  /// True when the user should see an in-app reliability warning.
  Future<bool> shouldShowGuidance() async {
    if (!Platform.isAndroid) return false;
    await ensureLoaded();
    final granted = await notificationsGranted;
    final exact = await exactAlarmsAllowed;
    if (!granted || !exact) return true;
    return isAggressiveOem;
  }

  Future<ReliabilityStatus> loadStatus() async {
    await ensureLoaded();
    final granted = await notificationsGranted;
    final exact = !Platform.isAndroid || await exactAlarmsAllowed;
    return ReliabilityStatus(
      manufacturer: manufacturerLabel,
      isAggressiveOem: isAggressiveOem,
      notificationsGranted: granted,
      exactAlarmsAllowed: exact,
      platformIsAndroid: Platform.isAndroid,
    );
  }

  String guidanceMessage(ReliabilityStatus status) {
    if (!status.platformIsAndroid) {
      return 'Keep TakeYourPills installed and notifications enabled so dose '
          'reminders can appear on time.';
    }

    final parts = <String>[];
    if (!status.notificationsGranted) {
      parts.add('Notification permission is off — reminders cannot appear.');
    }
    if (!status.exactAlarmsAllowed) {
      parts.add(
        'Exact alarms are not allowed — dose times may drift on Android 12+.',
      );
    }
    if (status.isAggressiveOem) {
      parts.add(
        '${status.manufacturer} may pause background apps. Disable battery '
        'optimization for TakeYourPills and allow autostart if available.',
      );
    }
    if (parts.isEmpty) {
      return 'Reminders look correctly configured on this device.';
    }
    return parts.join(' ');
  }

  /// Used by unit tests without Android device plugins.
  static bool isAggressiveManufacturer(String? manufacturer) {
    if (manufacturer == null || manufacturer.isEmpty) return false;
    final m = manufacturer.toLowerCase();
    return aggressiveManufacturers.any(m.contains);
  }

  Future<void> openNotificationSettings() =>
      AppSettings.openAppSettings(type: AppSettingsType.notification);

  Future<void> openBatteryOptimizationSettings() =>
      AppSettings.openAppSettings(type: AppSettingsType.batteryOptimization);

  /// Opens Android alarm / exact-alarm related settings when available.
  Future<void> openAlarmSettings() =>
      AppSettings.openAppSettings(type: AppSettingsType.alarm);

  Future<void> openAppSettings() => AppSettings.openAppSettings();

  Future<bool> requestExactAlarms() =>
      _notifications.requestExactAlarmPermission();

  Future<bool> requestNotificationPermission() =>
      _notifications.requestPermission();
}

@immutable
class ReliabilityStatus {
  const ReliabilityStatus({
    required this.manufacturer,
    required this.isAggressiveOem,
    required this.notificationsGranted,
    required this.exactAlarmsAllowed,
    required this.platformIsAndroid,
  });

  final String manufacturer;
  final bool isAggressiveOem;
  final bool notificationsGranted;
  final bool exactAlarmsAllowed;
  final bool platformIsAndroid;

  /// Hard issues: missing notification permission or exact alarms.
  bool get needsAttention =>
      !notificationsGranted || (platformIsAndroid && !exactAlarmsAllowed);

  /// Soft tip: OEM battery managers even when permissions look OK.
  bool get showOemTip => platformIsAndroid && isAggressiveOem;
}

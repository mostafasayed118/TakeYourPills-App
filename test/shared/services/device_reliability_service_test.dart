import 'package:flutter_test/flutter_test.dart';
import 'package:takeyourpills_healthcare_app/shared/services/device_reliability_service.dart';

void main() {
  group('DeviceReliabilityService.isAggressiveManufacturer', () {
    test('flags known OEMs', () {
      expect(
        DeviceReliabilityService.isAggressiveManufacturer('Xiaomi'),
        isTrue,
      );
      expect(
        DeviceReliabilityService.isAggressiveManufacturer('HUAWEI'),
        isTrue,
      );
      expect(
        DeviceReliabilityService.isAggressiveManufacturer('samsung'),
        isTrue,
      );
      expect(
        DeviceReliabilityService.isAggressiveManufacturer('Google'),
        isFalse,
      );
      expect(
        DeviceReliabilityService.isAggressiveManufacturer(null),
        isFalse,
      );
    });
  });

  group('ReliabilityStatus', () {
    test('needsAttention when notifications denied', () {
      const status = ReliabilityStatus(
        manufacturer: 'Google',
        isAggressiveOem: false,
        notificationsGranted: false,
        exactAlarmsAllowed: true,
        platformIsAndroid: true,
      );
      expect(status.needsAttention, isTrue);
      expect(status.showOemTip, isFalse);
    });

    test('needsAttention when exact alarms denied on Android', () {
      const status = ReliabilityStatus(
        manufacturer: 'Pixel',
        isAggressiveOem: false,
        notificationsGranted: true,
        exactAlarmsAllowed: false,
        platformIsAndroid: true,
      );
      expect(status.needsAttention, isTrue);
    });

    test('showOemTip for aggressive OEMs', () {
      const status = ReliabilityStatus(
        manufacturer: 'Xiaomi',
        isAggressiveOem: true,
        notificationsGranted: true,
        exactAlarmsAllowed: true,
        platformIsAndroid: true,
      );
      expect(status.needsAttention, isFalse);
      expect(status.showOemTip, isTrue);
    });
  });
}

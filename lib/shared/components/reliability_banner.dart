import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../routing/routes.dart';
import '../services/device_reliability_service.dart';
import '../theme/app_text_styles.dart';
import '../theme/theme_context.dart';

/// Compact banner shown when dose reminders may be unreliable.
class ReliabilityBanner extends StatefulWidget {
  const ReliabilityBanner({super.key});

  @override
  State<ReliabilityBanner> createState() => _ReliabilityBannerState();
}

class _ReliabilityBannerState extends State<ReliabilityBanner> {
  ReliabilityStatus? _status;
  bool _dismissed = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (!GetIt.instance.isRegistered<DeviceReliabilityService>()) {
      return;
    }
    final service = GetIt.instance<DeviceReliabilityService>();
    final status = await service.loadStatus();
    if (!mounted) return;
    setState(() => _status = status);
  }

  @override
  Widget build(BuildContext context) {
    if (_dismissed) return const SizedBox.shrink();
    final status = _status;
    if (status == null) return const SizedBox.shrink();
    if (!status.needsAttention && !status.showOemTip) {
      return const SizedBox.shrink();
    }

    final service = GetIt.instance<DeviceReliabilityService>();
    final message = service.guidanceMessage(status);
    final scheme = context.scheme;
    final isError = status.needsAttention;
    final bg = isError ? scheme.errorContainer : scheme.primaryContainer;
    final fg = isError ? scheme.onErrorContainer : scheme.onPrimaryContainer;

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  isError
                      ? Icons.notification_important_outlined
                      : Icons.battery_alert_outlined,
                  color: fg,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    message,
                    style: AppTextStyles.bodySmall.copyWith(color: fg),
                  ),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Icon(Icons.close, size: 18, color: fg),
                  onPressed: () => setState(() => _dismissed = true),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                if (!status.notificationsGranted)
                  TextButton(
                    onPressed: () async {
                      await service.requestNotificationPermission();
                      await _load();
                    },
                    child: const Text('Allow notifications'),
                  ),
                if (status.platformIsAndroid && !status.exactAlarmsAllowed)
                  TextButton(
                    onPressed: () async {
                      await service.requestExactAlarms();
                      await _load();
                    },
                    child: const Text('Allow exact alarms'),
                  ),
                if (status.platformIsAndroid && status.isAggressiveOem)
                  TextButton(
                    onPressed: service.openBatteryOptimizationSettings,
                    child: const Text('Battery settings'),
                  ),
                TextButton(
                  onPressed: () => context.go(AppRoutes.settingsNotifications),
                  child: const Text('Open settings'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

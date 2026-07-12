import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../shared/services/notification_service.dart';
import '../../../shared/services/preference_service.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_text_styles.dart';
import 'settings_subpage_scaffold.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  final PreferenceServiceImpl _prefs = GetIt.instance<PreferenceService>()
      as PreferenceServiceImpl;
  final NotificationService _notifications =
      GetIt.instance<NotificationService>();

  bool _loading = true;
  bool _enabled = true;
  bool _systemGranted = false;
  bool _exactAlarms = false;
  int _snoozeMinutes = 10;
  int _quietStart = 1380;
  int _quietEnd = 420;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final enabled = await _prefs.getNotificationsEnabled();
    final snooze = await _prefs.getDefaultSnoozeMinutes();
    final granted = await _notifications.isPermissionGranted();
    final exact = await _notifications.canScheduleExactAlarms();
    final quietStart = await _prefs.getQuietHoursStart();
    final quietEnd = await _prefs.getQuietHoursEnd();
    if (!mounted) {
      return;
    }
    setState(() {
      _enabled = enabled;
      _snoozeMinutes = snooze;
      _systemGranted = granted;
      _exactAlarms = exact;
      _quietStart = quietStart;
      _quietEnd = quietEnd;
      _loading = false;
    });
  }

  Future<void> _setEnabled(bool value) async {
    await _prefs.setNotificationsEnabled(value);
    if (value) {
      final granted = await _notifications.requestPermission();
      final exact = await _notifications.canScheduleExactAlarms();
      if (!mounted) {
        return;
      }
      setState(() {
        _enabled = value;
        _systemGranted = granted;
        _exactAlarms = exact;
      });
    } else {
      setState(() => _enabled = value);
    }
  }

  Future<void> _requestPermissions() async {
    final granted = await _notifications.requestPermission();
    final exact = await _notifications.canScheduleExactAlarms();
    if (!mounted) {
      return;
    }
    setState(() {
      _systemGranted = granted;
      _exactAlarms = exact;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          granted
              ? 'Notification permission granted'
              : 'Notification permission denied — enable in system settings',
        ),
      ),
    );
  }

  Future<void> _setSnooze(int minutes) async {
    await _prefs.setDefaultSnoozeMinutes(minutes);
    setState(() => _snoozeMinutes = minutes);
  }

  String _minutesLabel(int totalMinutes) {
    final h = totalMinutes ~/ 60;
    final m = totalMinutes % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
  }

  Future<void> _pickQuietHour({required bool isStart}) async {
    final current = isStart
        ? await _prefs.getQuietHoursStart()
        : await _prefs.getQuietHoursEnd();
    final initial = TimeOfDay(hour: current ~/ 60, minute: current % 60);
    if (!mounted) {
      return;
    }
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
    );
    if (picked == null) {
      return;
    }
    final minutes = picked.hour * 60 + picked.minute;
    if (isStart) {
      await _prefs.setQuietHoursStart(minutes);
      setState(() => _quietStart = minutes);
    } else {
      await _prefs.setQuietHoursEnd(minutes);
      setState(() => _quietEnd = minutes);
    }
  }

  @override
  Widget build(BuildContext context) => SettingsSubpageScaffold(
      title: 'Notifications',
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                const SettingsInfoCard(
                  icon: Icons.notifications_active_outlined,
                  message:
                      'Reminders use on-device notifications. Exact alarms '
                      'keep dose times accurate on Android 12+.',
                ),
                const SettingsSectionLabel('Reminders'),
                SwitchListTile(
                  title: const Text('Medication reminders'),
                  subtitle: Text(
                    _systemGranted
                        ? 'System permission: allowed'
                        : 'System permission: not granted',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  value: _enabled,
                  activeThumbColor: AppColors.primary,
                  onChanged: _setEnabled,
                ),
                ListTile(
                  title: const Text('Request permissions'),
                  subtitle: Text(
                    _exactAlarms
                        ? 'Notifications & exact alarms ready'
                        : 'Exact alarms may need system approval',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _requestPermissions,
                ),
                const SettingsSectionLabel('Defaults'),
                ListTile(
                  title: const Text('Default snooze'),
                  subtitle: Text('$_snoozeMinutes minutes'),
                  trailing: DropdownButton<int>(
                    value: _snoozeMinutes,
                    underline: const SizedBox.shrink(),
                    items: const [5, 10, 15, 20, 30]
                        .map(
                          (m) => DropdownMenuItem(
                            value: m,
                            child: Text('$m min'),
                          ),
                        )
                        .toList(),
                    onChanged: (v) {
                      if (v != null) {
                        _setSnooze(v);
                      }
                    },
                  ),
                ),
                const SettingsSectionLabel('Quiet hours'),
                ListTile(
                  title: const Text('Quiet hours start'),
                  subtitle: Text(_minutesLabel(_quietStart)),
                  trailing: const Icon(Icons.schedule),
                  onTap: () => _pickQuietHour(isStart: true),
                ),
                ListTile(
                  title: const Text('Quiet hours end'),
                  subtitle: Text(_minutesLabel(_quietEnd)),
                  trailing: const Icon(Icons.schedule),
                  onTap: () => _pickQuietHour(isStart: false),
                ),
                const SizedBox(height: 24),
              ],
            ),
    );
}

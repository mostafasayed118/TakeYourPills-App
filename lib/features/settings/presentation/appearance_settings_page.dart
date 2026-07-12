import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../shared/services/preference_service.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/theme/theme_context.dart';
import '../../../shared/theme/theme_controller.dart';
import 'settings_subpage_scaffold.dart';

class AppearanceSettingsPage extends StatefulWidget {
  const AppearanceSettingsPage({super.key});

  @override
  State<AppearanceSettingsPage> createState() => _AppearanceSettingsPageState();
}

class _AppearanceSettingsPageState extends State<AppearanceSettingsPage> {
  final PreferenceServiceImpl _prefs =
      GetIt.instance<PreferenceService>() as PreferenceServiceImpl;
  final ThemeController _theme = GetIt.instance<ThemeController>();

  bool _loading = true;
  String _themeMode = 'system';
  double _fontScale = 1;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final theme = await _prefs.getThemeMode();
    final font = await _prefs.getFontSizeMultiplier();
    if (!mounted) {
      return;
    }
    setState(() {
      _themeMode = theme;
      _fontScale = font;
      _loading = false;
    });
  }

  Future<void> _setTheme(String mode) async {
    await _theme.setModeFromString(mode);
    setState(() => _themeMode = mode);
  }

  Future<void> _setFontScale(double value) async {
    await _prefs.setFontSizeMultiplier(value);
    setState(() => _fontScale = value);
  }

  Widget _themeTile({
    required String value,
    required String title,
    String? subtitle,
  }) {
    final selected = _themeMode == value;
    final scheme = context.scheme;
    return ListTile(
      title: Text(title),
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle,
              style: AppTextStyles.bodySmall.copyWith(
                color: context.mutedText,
              ),
            ),
      trailing: Icon(
        selected ? Icons.check_circle : Icons.circle_outlined,
        color: selected ? scheme.primary : scheme.outlineVariant,
      ),
      onTap: () => _setTheme(value),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = context.scheme;
    return SettingsSubpageScaffold(
      title: 'Appearance',
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                const SettingsInfoCard(
                  icon: Icons.palette_outlined,
                  message:
                      'Choose a calm look that works for you. Preferences '
                      'are stored on this device and apply immediately.',
                ),
                const SettingsSectionLabel('Theme'),
                _themeTile(
                  value: 'system',
                  title: 'System default',
                  subtitle: 'Follow device light / dark mode',
                ),
                _themeTile(value: 'light', title: 'Light'),
                _themeTile(value: 'dark', title: 'Dark'),
                const SettingsSectionLabel('Text size'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Preview scale: ${(_fontScale * 100).round()}%',
                        style: AppTextStyles.bodyMedium,
                      ),
                      Slider(
                        value: _fontScale.clamp(0.85, 1.3),
                        min: 0.85,
                        max: 1.3,
                        divisions: 9,
                        activeColor: scheme.primary,
                        label: '${(_fontScale * 100).round()}%',
                        onChanged: (v) => setState(() => _fontScale = v),
                        onChangeEnd: _setFontScale,
                      ),
                      Text(
                        'Aa sample text at this size',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontSize: 16 * _fontScale,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
    );
  }
}

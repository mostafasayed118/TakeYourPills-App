import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../shared/services/preference_service.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_text_styles.dart';
import 'settings_subpage_scaffold.dart';

class AppearanceSettingsPage extends StatefulWidget {
  const AppearanceSettingsPage({super.key});

  @override
  State<AppearanceSettingsPage> createState() => _AppearanceSettingsPageState();
}

class _AppearanceSettingsPageState extends State<AppearanceSettingsPage> {
  final PreferenceServiceImpl _prefs = GetIt.instance<PreferenceService>()
      as PreferenceServiceImpl;

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
    await _prefs.setThemeMode(mode);
    setState(() => _themeMode = mode);
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Theme preference saved. Full theme switching applies on next app update.',
        ),
      ),
    );
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
    return ListTile(
      title: Text(title),
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
      trailing: selected
          ? const Icon(Icons.check_circle, color: AppColors.primary)
          : const Icon(Icons.circle_outlined, color: AppColors.outlineVariant),
      onTap: () => _setTheme(value),
    );
  }

  @override
  Widget build(BuildContext context) => SettingsSubpageScaffold(
      title: 'Appearance',
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                const SettingsInfoCard(
                  icon: Icons.palette_outlined,
                  message:
                      'Choose a calm look that works for you. Preferences '
                      'are stored on this device.',
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
                        activeColor: AppColors.primary,
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

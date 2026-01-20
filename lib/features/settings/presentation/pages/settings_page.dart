import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/languages/app_localizations.dart';
import '../../../../core/providers/language_provider.dart';
import '../../../../core/providers/theme_provider.dart';

/// Settings page for app preferences
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = Locale(context.read<LanguageProvider>().languageCode);
    final appLocalizations = AppLocalizations(locale);

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.settingsTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Language Section
          _buildSectionHeader(context, appLocalizations.language),
          const SizedBox(height: 12),
          _buildLanguageSelector(context, appLocalizations),
          const SizedBox(height: 24),

          // Theme Section
          _buildSectionHeader(context, appLocalizations.theme),
          const SizedBox(height: 12),
          _buildThemeSelector(context, appLocalizations),
          const SizedBox(height: 24),

          // Security Section
          _buildSectionHeader(context, appLocalizations.security),
          const SizedBox(height: 12),
          _buildSecurityOptions(context, appLocalizations),
          const SizedBox(height: 24),

          // About Section
          _buildSectionHeader(context, appLocalizations.about),
          const SizedBox(height: 12),
          _buildAboutSection(context, appLocalizations),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildLanguageSelector(BuildContext context, AppLocalizations appLocalizations) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
          child: Column(
            children: [
              _buildLanguageOption(
                context,
                'English',
                'en',
                languageProvider.languageCode == 'en',
                () => languageProvider.setLanguage('en'),
              ),
              Divider(
                height: 1,
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
              _buildLanguageOption(
                context,
                'বাংলা',
                'bn',
                languageProvider.languageCode == 'bn',
                () => languageProvider.setLanguage('bn'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    String label,
    String code,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeSelector(BuildContext context, AppLocalizations appLocalizations) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
          child: Column(
            children: [
              _buildThemeOption(
                context,
                appLocalizations.lightMode,
                ThemeMode.light,
                themeProvider.themeMode == ThemeMode.light,
                () => themeProvider.setThemeMode(ThemeMode.light),
              ),
              Divider(
                height: 1,
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
              _buildThemeOption(
                context,
                appLocalizations.darkMode,
                ThemeMode.dark,
                themeProvider.themeMode == ThemeMode.dark,
                () => themeProvider.setThemeMode(ThemeMode.dark),
              ),
              Divider(
                height: 1,
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
              _buildThemeOption(
                context,
                appLocalizations.systemMode,
                ThemeMode.system,
                themeProvider.themeMode == ThemeMode.system,
                () => themeProvider.setThemeMode(ThemeMode.system),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    String label,
    ThemeMode mode,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(
              mode == ThemeMode.light
                  ? Icons.light_mode
                  : mode == ThemeMode.dark
                      ? Icons.dark_mode
                      : Icons.brightness_auto,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityOptions(BuildContext context, AppLocalizations appLocalizations) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
      child: Column(
        children: [
          _buildSecurityOption(
            context,
            appLocalizations.pinLock,
            Icons.lock_outline,
            false,
            () {
              // TODO: Implement PIN lock
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('PIN Lock coming soon')),
              );
            },
          ),
          Divider(
            height: 1,
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          _buildSecurityOption(
            context,
            appLocalizations.biometricLock,
            Icons.fingerprint_outlined,
            false,
            () {
              // TODO: Implement biometric lock
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Biometric Lock coming soon')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityOption(
    BuildContext context,
    String label,
    IconData icon,
    bool isEnabled,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(
              icon,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const Spacer(),
            Switch(
              value: isEnabled,
              onChanged: (_) => onTap(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context, AppLocalizations appLocalizations) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
      child: Column(
        children: [
          _buildAboutItem(
            context,
            appLocalizations.version,
            '1.0.0',
          ),
          Divider(
            height: 1,
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          _buildAboutItem(
            context,
            'Build',
            '1.0.0+1',
          ),
        ],
      ),
    );
  }

  Widget _buildAboutItem(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

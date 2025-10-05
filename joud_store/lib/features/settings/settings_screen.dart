import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/localization/localization_service.dart';
import '../../core/widgets/ui_states.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final localizationService = LocalizationService.instance;
    
    return ScreenScaffold(
      title: localizationService.getString('settings'),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(localizationService.getString('language')),
            subtitle: const Text('العربية'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: _changeLanguage,
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: Text(localizationService.getString('darkMode')),
            trailing: Switch(
              value: false,
              onChanged: (value) {},
            ),
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: Text(localizationService.getString('notificationsEnabled')),
            trailing: Switch(
              value: true,
              onChanged: (value) {},
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info),
            title: Text(localizationService.getString('about')),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: _showAbout,
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: Text(localizationService.getString('privacyPolicy')),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: Text(localizationService.getString('termsOfService')),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  void _changeLanguage() {
    // Show language selection dialog
  }

  void _showAbout() {
    showAboutDialog(
      context: context,
      applicationName: LocalizationService.instance.getString('appName'),
      applicationVersion: '1.0.0',
      applicationLegalese: '© 2024 Syria Store',
    );
  }
}

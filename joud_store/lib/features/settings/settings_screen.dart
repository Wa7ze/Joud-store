import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/localization/localization_service.dart';
import '../../core/router/app_router.dart';
import '../../core/widgets/ui_states.dart';
import '../settings/providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final localization = LocalizationService.instance;
    final textAlign =
        localization.textDirection == TextDirection.rtl ? TextAlign.right : TextAlign.left;
    final isArabic = localization.currentLocale.languageCode == 'ar';

    return ScreenScaffold(
      title: localization.getString('settings'),
      showBackButton: true,
      currentIndex: 4,
      centerContent: false,
      contentPadding: EdgeInsets.zero,
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 780),
          child: ListView(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 16),
            children: [
              ListTile(
                leading: const Icon(Icons.language),
                title: Text(
                  isArabic ? 'English' : 'عربي',
                  textAlign: textAlign,
                ),
                subtitle: Text(localization.getString('language'), textAlign: textAlign),
                trailing: const Icon(Icons.swap_horiz),
                onTap: () async {
                  final newLocale = isArabic ? const Locale('en', 'US') : const Locale('ar', 'SY');
                  final notifier = ref.read(settingsProvider.notifier);
                  final messenger = ScaffoldMessenger.of(context);
                  await notifier.setLocale(newLocale);
                  LocalizationService.instance.setLocale(newLocale);
                  final newTextAlign =
                      LocalizationService.instance.textDirection == TextDirection.rtl
                          ? TextAlign.right
                          : TextAlign.left;
                  messenger
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text(
                          LocalizationService.instance.getString('settingsSaved'),
                          textAlign: newTextAlign,
                        ),
                      ),
                    );
                },
              ),
              SwitchListTile(
                secondary: const Icon(Icons.dark_mode),
                title: Text(localization.getString('darkMode'), textAlign: textAlign),
                value: settings.themeMode == ThemeMode.dark,
                onChanged: (value) => ref
                    .read(settingsProvider.notifier)
                    .setThemeMode(value ? ThemeMode.dark : ThemeMode.light),
              ),
              SwitchListTile(
                secondary: const Icon(Icons.notifications),
                title: Text(localization.getString('notificationsEnabled'), textAlign: textAlign),
                value: settings.notificationsEnabled,
                onChanged: (value) => ref
                    .read(settingsProvider.notifier)
                    .setNotificationsEnabled(value),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.info),
                title: Text(localization.getString('about'), textAlign: textAlign),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => _showAbout(context),
              ),
              ListTile(
                leading: const Icon(Icons.privacy_tip),
                title: Text(localization.getString('privacyPolicy'), textAlign: textAlign),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => context.push(AppRouter.privacy),
              ),
              ListTile(
                leading: const Icon(Icons.description),
                title: Text(localization.getString('termsOfService'), textAlign: textAlign),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => context.push(AppRouter.terms),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAbout(BuildContext context) {
    final localization = LocalizationService.instance;
    final textAlign =
        localization.textDirection == TextDirection.rtl ? TextAlign.right : TextAlign.left;

    showAboutDialog(
      context: context,
      applicationName: localization.getString('appName'),
      applicationVersion: '1.0.0',
      applicationLegalese: '© 2025 ${localization.getString('appName')}',
      children: [
        Text(
          localization.getString('aboutDescription'),
          textAlign: textAlign,
        ),
      ],
    );
  }
}

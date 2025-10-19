import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/localization/localization_service.dart';
import '../../core/router/app_router.dart';
import '../../core/widgets/language_picker.dart';
import '../../core/widgets/screen_scaffold.dart';
import '../../core/widgets/ui_states.dart';
import '../settings/providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final localization = LocalizationService.instance;
    final isRtl = localization.textDirection == TextDirection.rtl;
    final textAlign = isRtl ? TextAlign.right : TextAlign.left;
    final localeLabel = LanguagePicker.describeLocale(settings.locale);

    return ScreenScaffold(
      title: localization.getString('settings'),
      showBackButton: true,
      currentIndex: 3,
      centerContent: false,
      contentPadding: EdgeInsets.zero,
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 780),
          child: ListView(
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            children: [
              ListTile(
                leading: const Icon(Icons.language),
                title: Text(
                  localization.getString('language'),
                  textAlign: textAlign,
                ),
                subtitle: Text(localeLabel, textAlign: textAlign),
                trailing: const Icon(Icons.swap_horiz),
                onTap: () async {
                  final selected = await LanguagePicker.show(
                    context,
                    settings.locale,
                  );
                  if (selected != null && selected != settings.locale) {
                    await ref
                        .read(settingsProvider.notifier)
                        .setLocale(selected);
                    final newAlign =
                        LocalizationService.instance.textDirection ==
                            TextDirection.rtl
                        ? TextAlign.right
                        : TextAlign.left;
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: Text(
                            LocalizationService.instance.getString(
                              'settingsSaved',
                            ),
                            textAlign: newAlign,
                          ),
                        ),
                      );
                  }
                },
              ),
              SwitchListTile(
                secondary: const Icon(Icons.dark_mode),
                title: Text(
                  localization.getString('darkMode'),
                  textAlign: textAlign,
                ),
                value: settings.themeMode == ThemeMode.dark,
                onChanged: (value) => ref
                    .read(settingsProvider.notifier)
                    .setThemeMode(value ? ThemeMode.dark : ThemeMode.light),
              ),
              SwitchListTile(
                secondary: const Icon(Icons.notifications),
                title: Text(
                  localization.getString('notificationsEnabled'),
                  textAlign: textAlign,
                ),
                value: settings.notificationsEnabled,
                onChanged: (value) => ref
                    .read(settingsProvider.notifier)
                    .setNotificationsEnabled(value),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.info),
                title: Text(
                  localization.getString('about'),
                  textAlign: textAlign,
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => _showAbout(context),
              ),
              ListTile(
                leading: const Icon(Icons.privacy_tip),
                title: Text(
                  localization.getString('privacyPolicy'),
                  textAlign: textAlign,
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => context.push(AppRouter.privacy),
              ),
              ListTile(
                leading: const Icon(Icons.description),
                title: Text(
                  localization.getString('termsOfService'),
                  textAlign: textAlign,
                ),
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
    final textAlign = localization.textDirection == TextDirection.rtl
        ? TextAlign.right
        : TextAlign.left;

    showAboutDialog(
      context: context,
      applicationName: localization.getString('appName'),
      applicationVersion: '1.0.0',
      applicationLegalese:
          'Copyright 2025 ${localization.getString('appName')}',
      children: [
        Text(localization.getString('aboutDescription'), textAlign: textAlign),
      ],
    );
  }
}

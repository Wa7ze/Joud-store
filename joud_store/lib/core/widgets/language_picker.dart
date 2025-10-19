import 'package:flutter/material.dart';

import '../localization/app_localization.dart';
import '../localization/localization_service.dart';

class LanguagePicker {
  static String describeLocale(Locale locale) {
    final language =
        AppLocalization.languageNames[locale.languageCode] ??
        locale.languageCode;
    final countryCode = locale.countryCode;
    if (countryCode == null || countryCode.isEmpty) {
      return language;
    }
    final country = AppLocalization.countryNames[countryCode] ?? countryCode;
    return '$language ($country)';
  }

  static Future<Locale?> show(BuildContext context, Locale currentLocale) {
    final localization = LocalizationService.instance;
    final locales = AppLocalization.supportedLocales;
    final direction = localization.textDirection;
    final theme = Theme.of(context);

    return showModalBottomSheet<Locale>(
      context: context,
      builder: (sheetContext) {
        return Directionality(
          textDirection: direction,
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Text(
                    localization.getString('language'),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                for (final locale in locales)
                  ListTile(
                    leading: Icon(
                      locale == currentLocale
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      color: theme.colorScheme.primary,
                    ),
                    title: Text(describeLocale(locale)),
                    onTap: () => Navigator.of(sheetContext).pop(locale),
                  ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }
}

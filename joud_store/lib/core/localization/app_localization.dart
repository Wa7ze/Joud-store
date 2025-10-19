import 'package:flutter/material.dart';

/// Static helpers describing the locales supported by the app.
class AppLocalization {
  static const List<Locale> supportedLocales = [
    Locale('en', 'US'), // English (US) - Default
    Locale('ar', 'SY'), // Arabic (Syria)
    Locale('tr', 'TR'), // Turkish
  ];

  static const Locale defaultLocale = Locale('en', 'US');

  static const Map<String, String> languageNames = {
    'en': 'English',
    'ar': 'Arabic',
    'tr': 'Turkish',
  };

  static const Map<String, String> countryNames = {
    'US': 'United States',
    'SY': 'Syria',
    'TR': 'Turkey',
  };

  static const List<String> rtlLanguages = ['ar', 'he', 'fa', 'ur'];

  static bool isRTL(String languageCode) => rtlLanguages.contains(languageCode);

  static TextDirection getTextDirection(String languageCode) =>
      isRTL(languageCode) ? TextDirection.rtl : TextDirection.ltr;
}

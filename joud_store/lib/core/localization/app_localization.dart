/// Localization configuration and supported locales
import 'package:flutter/material.dart';

class AppLocalization {
  static const List<Locale> supportedLocales = [
    Locale('en', 'US'), // English (US) - Default
    Locale('ar', 'SY'), // Arabic (Syria)
  ];

  static const Locale defaultLocale = Locale('en', 'US');

  static const Map<String, String> languageNames = {
    'en': 'English',
    'ar': 'العربية',
  };

  static const Map<String, String> countryNames = {
    'US': 'United States',
    'SY': 'سوريا',
  };

  // RTL languages
  static const List<String> rtlLanguages = ['ar', 'he', 'fa', 'ur'];

  static bool isRTL(String languageCode) {
    return rtlLanguages.contains(languageCode);
  }

  static TextDirection getTextDirection(String languageCode) {
    return isRTL(languageCode) ? TextDirection.rtl : TextDirection.ltr;
  }
}

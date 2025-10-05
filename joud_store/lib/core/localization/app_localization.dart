/// Localization configuration and supported locales
import 'package:flutter/material.dart';

class AppLocalization {
  static const List<Locale> supportedLocales = [
    Locale('ar', 'SY'), // Arabic (Syria) - Default
    Locale('en', 'US'), // English (US) - Fallback
  ];
  
  static const Locale defaultLocale = Locale('ar', 'SY');
  
  static const Map<String, String> languageNames = {
    'ar': 'العربية',
    'en': 'English',
  };
  
  static const Map<String, String> countryNames = {
    'SY': 'سوريا',
    'US': 'United States',
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

import 'package:flutter/material.dart';

import '../localization/localization_service.dart';

class CurrencyUtils {
  static const Map<String, double> _conversionRates = <String, double>{
    'SYP': 1.0,
    'USD': 1 / 13000, // Approximate conversion from Syrian Pound to USD
    'TRY': 1 / 400, // Approximate conversion from Syrian Pound to Turkish Lira
  };

  static const Map<String, int> _fractionDigits = <String, int>{
    'SYP': 0,
    'USD': 2,
    'TRY': 2,
  };

  static String? _overrideCurrencyCode;

  static List<String> get availableCurrencies =>
      _conversionRates.keys.toList(growable: false);

  static void setOverrideCurrency(String? code) {
    if (code == null || !_conversionRates.containsKey(code)) {
      _overrideCurrencyCode = null;
      return;
    }
    _overrideCurrencyCode = code;
  }

  static String _effectiveCurrencyCode({Locale? locale}) {
    if (_overrideCurrencyCode != null &&
        _conversionRates.containsKey(_overrideCurrencyCode)) {
      return _overrideCurrencyCode!;
    }
    final targetLocale = locale ?? LocalizationService.instance.currentLocale;
    return currencyCodeForLocale(targetLocale);
  }

  static String currencyCodeForLocale(Locale locale) {
    switch (locale.languageCode) {
      case 'ar':
        return 'SYP';
      case 'tr':
        return 'TRY';
      default:
        return 'USD';
    }
  }

  static String format(double baseAmount, {Locale? locale}) {
    final targetLocale = locale ?? LocalizationService.instance.currentLocale;
    final currencyCode = _effectiveCurrencyCode(locale: targetLocale);
    final converted = convert(
      baseAmount,
      locale: targetLocale,
      currencyCode: currencyCode,
    );
    final digits = _fractionDigits[currencyCode] ?? 0;
    return '${converted.toStringAsFixed(digits)} $currencyCode';
  }

  static double convert(
    double baseAmount, {
    Locale? locale,
    String? currencyCode,
  }) {
    final targetLocale = locale ?? LocalizationService.instance.currentLocale;
    final code = currencyCode ?? _effectiveCurrencyCode(locale: targetLocale);
    final rate = _conversionRates[code] ?? 1.0;
    return baseAmount * rate;
  }
}

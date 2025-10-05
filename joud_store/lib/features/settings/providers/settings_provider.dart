import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/localization/app_localization.dart';

/// Settings state
class SettingsState {
  final Locale locale;
  final ThemeMode themeMode;
  final bool notificationsEnabled;
  final bool showCurrencyEquivalent;
  final String currency;
  
  SettingsState({
    Locale? locale,
    this.themeMode = ThemeMode.system,
    this.notificationsEnabled = true,
    this.showCurrencyEquivalent = false,
    this.currency = 'SYP',
  }) : locale = locale ?? AppLocalization.defaultLocale;
  
  SettingsState copyWith({
    Locale? locale,
    ThemeMode? themeMode,
    bool? notificationsEnabled,
    bool? showCurrencyEquivalent,
    String? currency,
  }) {
    return SettingsState(
      locale: locale ?? this.locale,
      themeMode: themeMode ?? this.themeMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      showCurrencyEquivalent: showCurrencyEquivalent ?? this.showCurrencyEquivalent,
      currency: currency ?? this.currency,
    );
  }
}

/// Settings notifier
class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(SettingsState()) {
    _loadSettings();
  }
  
  static const String _localeKey = 'locale';
  static const String _themeModeKey = 'theme_mode';
  static const String _notificationsKey = 'notifications_enabled';
  static const String _currencyEquivalentKey = 'show_currency_equivalent';
  static const String _currencyKey = 'currency';
  
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Load locale
      final localeCode = prefs.getString(_localeKey);
      final locale = localeCode != null 
          ? Locale(localeCode.split('_')[0], localeCode.split('_')[1])
          : AppLocalization.defaultLocale;
      
      // Load theme mode
      final themeModeIndex = prefs.getInt(_themeModeKey) ?? ThemeMode.system.index;
      final themeMode = ThemeMode.values[themeModeIndex];
      
      // Load other settings
      final notificationsEnabled = prefs.getBool(_notificationsKey) ?? true;
      final showCurrencyEquivalent = prefs.getBool(_currencyEquivalentKey) ?? false;
      final currency = prefs.getString(_currencyKey) ?? 'SYP';
      
      state = state.copyWith(
        locale: locale,
        themeMode: themeMode,
        notificationsEnabled: notificationsEnabled,
        showCurrencyEquivalent: showCurrencyEquivalent,
        currency: currency,
      );
    } catch (e) {
      // Use default settings if loading fails
      state = SettingsState();
    }
  }
  
  Future<void> setLocale(Locale locale) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_localeKey, '${locale.languageCode}_${locale.countryCode}');
      state = state.copyWith(locale: locale);
    } catch (e) {
      // Handle error silently
    }
  }
  
  Future<void> setThemeMode(ThemeMode themeMode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeModeKey, themeMode.index);
      state = state.copyWith(themeMode: themeMode);
    } catch (e) {
      // Handle error silently
    }
  }
  
  Future<void> setNotificationsEnabled(bool enabled) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_notificationsKey, enabled);
      state = state.copyWith(notificationsEnabled: enabled);
    } catch (e) {
      // Handle error silently
    }
  }
  
  Future<void> setShowCurrencyEquivalent(bool show) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_currencyEquivalentKey, show);
      state = state.copyWith(showCurrencyEquivalent: show);
    } catch (e) {
      // Handle error silently
    }
  }
  
  Future<void> setCurrency(String currency) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_currencyKey, currency);
      state = state.copyWith(currency: currency);
    } catch (e) {
      // Handle error silently
    }
  }
}

/// Settings provider
final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});

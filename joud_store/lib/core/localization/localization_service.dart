import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';

import 'app_localization.dart';
import 'remote_translator.dart';
import 'strings_en.dart';

/// Central service that exposes localized strings and switches languages on demand.
class LocalizationService {
  LocalizationService._() {
    _activeStrings = Map<String, String>.from(AppStringsEn.values);
  }

  static LocalizationService? _instance;
  static LocalizationService get instance =>
      _instance ??= LocalizationService._();

  static const _prefsKeyPrefix = 'dynamic_locale_cache_';
  static const _cacheVersion = 1;
  static const _minTranslatedEntries = 10;
  final GoogleTranslator _translator = GoogleTranslator();
  final RemoteTranslator _remoteTranslator = RemoteTranslator();
  final Map<String, Map<String, String>> _cachedTranslations = {};
  late Map<String, String> _activeStrings;
  Locale _currentLocale = AppLocalization.defaultLocale;

  Locale get currentLocale => _currentLocale;

  bool get isRTL => AppLocalization.isRTL(_currentLocale.languageCode);

  TextDirection get textDirection =>
      AppLocalization.getTextDirection(_currentLocale.languageCode);

  /// Returns the localized value for the provided [key].
  String getString(String key) {
    return _activeStrings[key] ?? AppStringsEn.get(key);
  }

  /// Loads the given [locale], translating content if needed.
  Future<void> loadLocale(Locale locale) async {
    if (_currentLocale == locale && _activeStrings.isNotEmpty) {
      return;
    }

    _currentLocale = locale;

    if (locale.languageCode == 'en') {
      _activeStrings = Map<String, String>.from(AppStringsEn.values);
      return;
    }

    final cacheKey = _cacheKey(locale);
    final cached = await _getCachedTranslations(cacheKey);
    if (cached != null) {
      if (_hasEnoughTranslatedEntries(cached)) {
        _cachedTranslations[cacheKey] = cached;
        _activeStrings = cached;
        return;
      }
      await _removeCachedTranslations(cacheKey);
    }

    final translated = await _translateAll(locale.languageCode);
    if (_hasEnoughTranslatedEntries(translated)) {
      _cachedTranslations[cacheKey] = translated;
      _activeStrings = translated;
      await _storeCachedTranslations(cacheKey, translated);
    } else {
      _activeStrings = Map<String, String>.from(AppStringsEn.values);
    }
  }

  String _cacheKey(Locale locale) =>
      '${locale.languageCode}_${locale.countryCode ?? ''}';

  Future<Map<String, String>?> _getCachedTranslations(String cacheKey) async {
    if (_cachedTranslations.containsKey(cacheKey)) {
      return _cachedTranslations[cacheKey];
    }

    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('$_prefsKeyPrefix$cacheKey');
    if (raw == null) {
      return null;
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        final version = decoded['__version'] as int?;
        final values = decoded['values'];
        if (version == _cacheVersion && values is Map<String, dynamic>) {
          return values.map((key, value) => MapEntry(key, value as String));
        }
      }
      await _removeCachedTranslations(cacheKey);
      return null;
    } catch (_) {
      await _removeCachedTranslations(cacheKey);
      return null;
    }
  }

  Future<void> _storeCachedTranslations(
    String cacheKey,
    Map<String, String> translations,
  ) async {
    if (!_hasEnoughTranslatedEntries(translations)) {
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        '$_prefsKeyPrefix$cacheKey',
        jsonEncode({'__version': _cacheVersion, 'values': translations}),
      );
    } catch (_) {
      // Ignore persistence issues and rely on in-memory cache.
    }
  }

  Future<void> _removeCachedTranslations(String cacheKey) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('$_prefsKeyPrefix$cacheKey');
    } catch (_) {
      // Ignore persistence issues and rely on in-memory cache.
    }
    _cachedTranslations.remove(cacheKey);
  }

  Future<Map<String, String>> _translateAll(String languageCode) async {
    final entries = AppStringsEn.values.entries.toList(growable: false);
    final Map<String, String> translated = {};

    for (final entry in entries) {
      final translatedEntry = await _translateEntry(entry, languageCode);
      translated[translatedEntry.key] = translatedEntry.value;
      await Future<void>.delayed(const Duration(milliseconds: 60));
    }

    return translated;
  }

  bool _hasEnoughTranslatedEntries(Map<String, String> candidate) {
    final english = AppStringsEn.values;
    var changed = 0;
    for (final entry in candidate.entries) {
      final base = english[entry.key];
      if (base != null && base != entry.value) {
        changed++;
        if (changed >= _minTranslatedEntries) {
          return true;
        }
      }
    }
    return false;
  }

  Future<MapEntry<String, String>> _translateEntry(
    MapEntry<String, String> entry,
    String languageCode,
  ) async {
    final normalizedTarget = _normalizeLanguageCode(languageCode);
    final sourceText = entry.value;

    try {
      final remote = await _remoteTranslator.translate(
        text: sourceText,
        target: normalizedTarget,
        source: 'en',
      );
      if (remote != null && remote.trim().isNotEmpty) {
        return MapEntry(entry.key, remote);
      }
    } catch (_) {
      // fall back to secondary translator.
    }

    try {
      final response = await _translator.translate(
        sourceText,
        from: 'en',
        to: normalizedTarget,
      );
      final text = response.text.trim().isEmpty ? sourceText : response.text;
      return MapEntry(entry.key, text);
    } catch (_) {
      return MapEntry(entry.key, sourceText);
    }
  }

  String _normalizeLanguageCode(String code) {
    switch (code) {
      case 'ar':
      case 'tr':
        return code;
      default:
        return code;
    }
  }
}

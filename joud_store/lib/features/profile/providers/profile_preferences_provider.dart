import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/profile_preferences.dart';

final profilePreferencesProvider =
    AsyncNotifierProvider<ProfilePreferencesNotifier, ProfilePreferences>(
  ProfilePreferencesNotifier.new,
);

class ProfilePreferencesNotifier
    extends AsyncNotifier<ProfilePreferences> {
  static const _sizesKey = 'preferred_sizes';
  static const _stylesKey = 'preferred_styles';
  static const _darkModeKey = 'dark_mode_enabled';

  late SharedPreferences _prefs;

  @override
  Future<ProfilePreferences> build() async {
    _prefs = await SharedPreferences.getInstance();
    final sizes = _prefs.getStringList(_sizesKey) ?? <String>[];
    final styles = _prefs.getStringList(_stylesKey) ?? <String>[];
    final darkMode = _prefs.getBool(_darkModeKey) ?? false;

    return ProfilePreferences(
      preferredSizes: sizes.toSet(),
      preferredStyles: styles.toSet(),
      darkMode: darkMode,
    );
  }

  Future<void> toggleSize(String size) async {
    final current = state.value;
    if (current == null) return;
    final updated = <String>{...current.preferredSizes};
    if (updated.contains(size)) {
      updated.remove(size);
    } else {
      updated.add(size);
    }
    final next = current.copyWith(preferredSizes: updated);
    state = AsyncData(next);
    await _prefs.setStringList(_sizesKey, updated.toList());
  }

  Future<void> toggleStyle(String style) async {
    final current = state.value;
    if (current == null) return;
    final updated = <String>{...current.preferredStyles};
    if (updated.contains(style)) {
      updated.remove(style);
    } else {
      updated.add(style);
    }
    final next = current.copyWith(preferredStyles: updated);
    state = AsyncData(next);
    await _prefs.setStringList(_stylesKey, updated.toList());
  }

  Future<void> setDarkMode(bool enabled) async {
    final current = state.value;
    if (current == null) return;
    final next = current.copyWith(darkMode: enabled);
    state = AsyncData(next);
    await _prefs.setBool(_darkModeKey, enabled);
  }
}


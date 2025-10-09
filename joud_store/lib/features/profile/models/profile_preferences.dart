class ProfilePreferences {
  final Set<String> preferredSizes;
  final Set<String> preferredStyles;
  final bool darkMode;

  const ProfilePreferences({
    required this.preferredSizes,
    required this.preferredStyles,
    required this.darkMode,
  });

  ProfilePreferences copyWith({
    Set<String>? preferredSizes,
    Set<String>? preferredStyles,
    bool? darkMode,
  }) {
    return ProfilePreferences(
      preferredSizes: preferredSizes ?? this.preferredSizes,
      preferredStyles: preferredStyles ?? this.preferredStyles,
      darkMode: darkMode ?? this.darkMode,
    );
  }
}


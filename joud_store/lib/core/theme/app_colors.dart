import 'package:flutter/material.dart';

const kPrimaryGradient = LinearGradient(
  colors: [Color(0xFFFF7A9E), Color(0xFFB032FF)],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF9B28F0);
  static const Color primaryLight = Color(0xFFFF7A9E);
  static const Color primaryDark = Color(0xFF6614A9);

  // Secondary/Accent Colors
  static const Color accent = Color(0xFFFF7A9E);
  static const Color accentLight = Color(0xFFFF9FC0);
  static const Color accentDark = Color(0xFFE35F87);

  // Background Colors
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Colors.white;
  static const Color surfaceVariant = Color(0xFFF3EAFB);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color headerBackground = Colors.white;

  // Text Colors
  static const Color onPrimary = Colors.white;
  static const Color onBackground = Color(0xFF222222);
  static const Color onSurface = Color(0xFF222222);
  static const Color onSurfaceVariant = Color(0xFF888888);
  static const Color textPrimary = Color(0xFF222222);
  static const Color textSecondary = Color(0xFF888888);
  static const Color textLight = Color(0xFFB0B0B0);
  static const Color icon = Color(0xFF444444);

  // Status Colors
  static const Color error = Color(0xFFB00020);
  static const Color onError = Colors.white;
  static const Color success = Color(0xFF4CAF50);
  static const Color onSuccess = Colors.white;
  static const Color warning = Color(0xFFFFA000);
  static const Color onWarning = Colors.white;

  // Sale and Status Colors
  static const Color sale = Color(0xFFFF61A6);
  static const Color onSale = Colors.white;
  static const Color new_ = primaryLight;
  static const Color outOfStock = Color(0xFF9E9E9E);

  // Border and Divider Colors
  static const Color outline = Color(0xFFE0E0E0);
  static const Color outlineVariant = Color(0xFFD6D6D6);

  // Disabled State Colors
  static const Color disabled = Color(0xFFEAEAEA);
  static const Color onDisabled = Color(0xFF9E9E9E);

  // Gradients
  static const LinearGradient headerGradient = kPrimaryGradient;

  static const List<Color> primaryGradient = [
    Color(0xFFFF7A9E),
    Color(0xFFB032FF),
  ];

  // Get color scheme for MaterialApp
  static ColorScheme get colorScheme => ColorScheme(
        primary: primary,
        primaryContainer: primaryLight,
        secondary: accent,
        secondaryContainer: accentLight,
        surface: surface,
        background: background,
        error: error,
        onPrimary: onPrimary,
        onSecondary: onPrimary,
        onSurface: onSurface,
        onBackground: onBackground,
        onError: onError,
        brightness: Brightness.light,
      );

  // Get dark color scheme for MaterialApp
  static ColorScheme get darkColorScheme => ColorScheme(
        primary: primaryLight,
        primaryContainer: primary,
        secondary: accentLight,
        secondaryContainer: accent,
        surface: const Color(0xFF121212),
        background: const Color(0xFF121212),
        error: error,
        onPrimary: onPrimary,
        onSecondary: onPrimary,
        onSurface: Colors.white,
        onBackground: Colors.white,
        onError: onError,
        brightness: Brightness.dark,
      );
}

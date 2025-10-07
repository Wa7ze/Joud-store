import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF6A1B9A);
  static const Color primaryLight = Color(0xFF8E24AA);
  static const Color primaryDark = Color(0xFF4A148C);

  // Secondary/Accent Colors
  static const Color accent = Color(0xFFD500F9);
  static const Color accentLight = Color(0xFFE040FB);
  static const Color accentDark = Color(0xFFAA00FF);

  // Background Colors
  static const Color background = Colors.white;
  static const Color surface = Colors.white;
  static const Color surfaceVariant = Color(0xFFF3E5F5);
  static const Color cardBackground = Color(0xFFF5F5F5);

  // Text Colors
  static const Color onPrimary = Colors.white;
  static const Color onBackground = Color(0xFF1A1A1A);
  static const Color onSurface = Color(0xFF1A1A1A);
  static const Color onSurfaceVariant = Color(0xFF757575);
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = Color(0xFF9E9E9E);

  // Status Colors
  static const Color error = Color(0xFFB00020);
  static const Color onError = Colors.white;
  static const Color success = Color(0xFF4CAF50);
  static const Color onSuccess = Colors.white;
  static const Color warning = Color(0xFFFFA000);
  static const Color onWarning = Colors.white;

  // Sale and Status Colors
  static const Color sale = Color(0xFFD500F9);
  static const Color onSale = Colors.white;
  static const Color new_ = primaryLight;
  static const Color outOfStock = Color(0xFF9E9E9E);

  // Border and Divider Colors
  static const Color outline = Color(0xFFE0E0E0);
  static const Color outlineVariant = Color(0xFFBDBDBD);

  // Disabled State Colors
  static const Color disabled = Color(0xFFE0E0E0);
  static const Color onDisabled = Color(0xFF9E9E9E);

  // Gradients
  static const headerGradient = LinearGradient(
    colors: [primaryLight, primary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const List<Color> primaryGradient = [
    primaryLight,
    primary,
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
        surface: Color(0xFF121212),
        background: Color(0xFF121212),
        error: error,
        onPrimary: onPrimary,
        onSecondary: onPrimary,
        onSurface: Colors.white,
        onBackground: Colors.white,
        onError: onError,
        brightness: Brightness.dark,
      );
}

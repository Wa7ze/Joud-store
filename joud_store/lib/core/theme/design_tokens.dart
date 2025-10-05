import 'package:flutter/material.dart';

class DesignTokens {
  static const spacing = _Spacing();
  static final typography = _Typography();

  // Brand Colors
  static const primaryColor = Color(0xFF2E7D32); // Syria green
  static const secondaryColor = Color(0xFF757575);
  static const accentColor = Color(0xFFFFB300); // Accent gold/yellow
  
  // Semantic Colors
  static const errorColor = Color(0xFFD32F2F);
  static const successColor = Color(0xFF388E3C);
  static const warningColor = Color(0xFFFFA000);
  static const infoColor = Color(0xFF1976D2);
  
  // Neutral Colors
  static const backgroundLight = Color(0xFFFAFAFA);
  static const backgroundDark = Color(0xFF121212);
  static const surfaceLight = Color(0xFFFFFFFF);
  static const surfaceDark = Color(0xFF242424);
  
  // Text Colors
  static const textPrimaryLight = Color(0xFF212121);
  static const textSecondaryLight = Color(0xFF757575);
  static const textDisabledLight = Color(0xFFBDBDBD);
  static const textPrimaryDark = Color(0xFFE0E0E0);
  static const textSecondaryDark = Color(0xFF9E9E9E);
  static const textDisabledDark = Color(0xFF616161);
  
  // Border Colors
  static const borderLight = Color(0xFFE0E0E0);
  static const borderDark = Color(0xFF424242);

  // Typography Scales (adjusted for Arabic)
  static const fontFamily = 'Cairo';
  static const fontWeightLight = FontWeight.w300;
  static const fontWeightRegular = FontWeight.w400;
  static const fontWeightMedium = FontWeight.w500;
  static const fontWeightSemiBold = FontWeight.w600;
  static const fontWeightBold = FontWeight.w700;
  
  // Font Sizes
  static const fontSizeXSmall = 12.0;
  static const fontSizeSmall = 14.0;
  static const fontSizeBase = 16.0;
  static const fontSizeLarge = 18.0;
  static const fontSizeXLarge = 20.0;
  static const fontSizeXXLarge = 24.0;
  static const fontSizeDisplay = 32.0;
  
  // Line Heights
  static const lineHeightTight = 1.2;
  static const lineHeightBase = 1.5;
  static const lineHeightRelaxed = 1.75;

  // Spacing
  static const spacing0 = 0.0;
  static const spacing1 = 4.0;
  static const spacing2 = 8.0;
  static const spacing3 = 12.0;
  static const spacing4 = 16.0;
  static const spacing5 = 24.0;
  static const spacing6 = 32.0;
  static const spacing7 = 48.0;
  static const spacing8 = 64.0;

  // Border Radius
  static const radiusNone = 0.0;
  static const radiusSmall = 4.0;
  static const radiusMedium = 8.0;
  static const radiusLarge = 12.0;
  static const radiusXLarge = 16.0;
  static const radiusCircular = 999.0;
  
  // Border Widths
  static const borderWidthNone = 0.0;
  static const borderWidthThin = 1.0;
  static const borderWidthMedium = 2.0;
  static const borderWidthThick = 4.0;

  // Shadows
  static List<BoxShadow> get shadowSmall => [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get shadowMedium => [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ];
      
  static List<BoxShadow> get shadowLarge => [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
      ];
      
  static List<BoxShadow> get shadowElevated => [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 24,
          offset: const Offset(0, 12),
        ),
      ];

  // Touch Targets
  static const minTouchTarget = 48.0;
  static const maxTouchTarget = 64.0;
  
  // Input Fields
  static const inputHeight = 48.0;
  static const inputRadius = radiusMedium;
  static const inputBorderWidth = borderWidthThin;
  static const inputPadding = EdgeInsets.symmetric(
    horizontal: spacing4,
    vertical: spacing3,
  );
  
  // Buttons
  static const buttonHeightLarge = 56.0;
  static const buttonHeightMedium = 48.0;
  static const buttonHeightSmall = 40.0;
  static const buttonRadius = radiusMedium;
  static const buttonPaddingVertical = spacing3;
  static const buttonPaddingHorizontal = spacing4;
  
  // Cards
  static const cardRadius = radiusMedium;
  static const cardPadding = spacing4;
  static const cardElevation = 1.0;
  
  // Animation Durations
  static const durationFast = Duration(milliseconds: 200);
  static const durationNormal = Duration(milliseconds: 300);
  static const durationSlow = Duration(milliseconds: 400);
  
  // Animation Curves
  static const curveDefault = Curves.easeInOut;
  static const curveAccelerate = Curves.easeIn;
  static const curveDecelerate = Curves.easeOut;
  static const curveSharp = Curves.easeInOutCubic;
  
  // Z-Index (Elevation)
  static const zIndexDefault = 1;
  static const zIndexRaised = 2;
  static const zIndexDropdown = 3;
  static const zIndexModal = 4;
  static const zIndexToast = 5;
  
  // Opacity
  static const opacityDisabled = 0.38;
  static const opacityHover = 0.08;
  static const opacityPress = 0.12;
  static const opacityOverlay = 0.32;
  static const opacityScrim = 0.60;
}

class _Spacing {
  const _Spacing();
  double get small => DesignTokens.spacing2;
  double get medium => DesignTokens.spacing4;
  double get large => DesignTokens.spacing6;
  double get xlarge => DesignTokens.spacing7;
  double get xxlarge => DesignTokens.spacing8;
}

class _Typography {
  TextStyle get h1 => const TextStyle(
    fontFamily: DesignTokens.fontFamily,
    fontSize: DesignTokens.fontSizeDisplay,
    fontWeight: DesignTokens.fontWeightBold,
    height: DesignTokens.lineHeightTight,
  );

  TextStyle get h2 => const TextStyle(
    fontFamily: DesignTokens.fontFamily,
    fontSize: DesignTokens.fontSizeXXLarge,
    fontWeight: DesignTokens.fontWeightBold,
    height: DesignTokens.lineHeightTight,
  );

  TextStyle get h3 => const TextStyle(
    fontFamily: DesignTokens.fontFamily,
    fontSize: DesignTokens.fontSizeXLarge,
    fontWeight: DesignTokens.fontWeightSemiBold,
    height: DesignTokens.lineHeightBase,
  );

  TextStyle get body => const TextStyle(
    fontFamily: DesignTokens.fontFamily,
    fontSize: DesignTokens.fontSizeBase,
    fontWeight: DesignTokens.fontWeightRegular,
    height: DesignTokens.lineHeightBase,
  );

  TextStyle get subtitle => const TextStyle(
    fontFamily: DesignTokens.fontFamily,
    fontSize: DesignTokens.fontSizeLarge,
    fontWeight: DesignTokens.fontWeightMedium,
    height: DesignTokens.lineHeightBase,
  );

  TextStyle get caption => const TextStyle(
    fontFamily: DesignTokens.fontFamily,
    fontSize: DesignTokens.fontSizeSmall,
    fontWeight: DesignTokens.fontWeightRegular,
    height: DesignTokens.lineHeightBase,
  );
}

import 'package:flutter/material.dart';

class AppColors {
  // Primary brand colors
  static const primaryGradientStart = Color(0xFFFF69B4); // Pink
  static const primaryGradientEnd = Color(0xFFFF1493);   // Deep pink
  
  // Secondary colors
  static const accent = Color(0xFF333333);        // Dark gray for text
  static const background = Colors.white;         // Clean white background
  static const cardBackground = Color(0xFFF5F5F5); // Light gray for cards
  
  // Text colors
  static const textPrimary = Color(0xFF333333);
  static const textSecondary = Color(0xFF666666);
  static const textLight = Color(0xFF999999);
  
  // Status colors
  static const sale = Color(0xFFFF4081);         // Bright pink for sales/discounts
  static const new_ = Color(0xFF2196F3);         // Blue for new items
  static const outOfStock = Color(0xFF9E9E9E);   // Gray for out of stock
  
  // Static gradients
  static const headerGradient = LinearGradient(
    colors: [primaryGradientStart, primaryGradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

import 'package:flutter/material.dart';

class AppColors {
  // Primary — SMKMC Forest Green
  static const primary        = Color(0xFF1B5E20);
  static const primaryLight   = Color(0xFF2E7D32);
  static const primaryTonal   = Color(0xFFA5D6A7);
  static const primarySurface = Color(0xFFE8F5E9);

  // Semantic
  static const error    = Color(0xFFC62828);
  static const errorSurface = Color(0xFFFFEBEE);
  static const warning  = Color(0xFFF57F17);
  static const warningSurface = Color(0xFFFFF8E1);
  static const success  = Color(0xFF2E7D32);

  // Neutrals
  static const surface    = Color(0xFFFFFFFF);
  static const background = Color(0xFFF1F8E9);
  static const onSurface  = Color(0xFF1C1C1E);
  static const subtle     = Color(0xFF6B6B6B);
  static const border     = Color(0xFFE0E0E0);

  // Status colors
  static const present  = Color(0xFF2E7D32);
  static const absent   = Color(0xFFC62828);
  static const late     = Color(0xFFF57F17);
  static const holiday  = Color(0xFF1565C0);
  static const exception = Color(0xFF6A1B9A);
}

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      primary: AppColors.primary,
      surface: AppColors.surface,
      error: AppColors.error,
    ),

    fontFamily: 'NotoSans',
    scaffoldBackgroundColor: AppColors.background,

    // AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontFamily: 'NotoSans',
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),

    // Cards
    cardTheme: CardThemeData(
      elevation: 0,
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border, width: 1),
      ),
      margin: EdgeInsets.zero,
    ),

    // Filled Button
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(
          fontFamily: 'NotoSans',
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // Outlined Button
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary),
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),

    // Input fields
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
    ),

    // Bottom Navigation
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.surface,
      indicatorColor: AppColors.primarySurface,
      indicatorShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      labelTextStyle: WidgetStateProperty.all(
        const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
      ),
    ),

    // Chip
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.primarySurface,
      labelStyle: const TextStyle(fontSize: 12, color: AppColors.primary),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    ),
  );
}

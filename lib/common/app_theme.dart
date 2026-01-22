import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData lightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.seedColor,
        brightness: Brightness.light,
      ),
      textTheme: GoogleFonts.ralewayTextTheme(ThemeData.light().textTheme),
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.lightScaffoldBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.lightAppBarBackground,
        foregroundColor: AppColors.deleteIcon,
      ),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.seedColor,
        brightness: Brightness.dark,
      ),
      textTheme: GoogleFonts.ralewayTextTheme(ThemeData.dark().textTheme),
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.darkScaffoldBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkAppBarBackground,
        foregroundColor: AppColors.deleteIcon,
      ),
      cardTheme: const CardThemeData(color: AppColors.darkCard),
    );
  }
}

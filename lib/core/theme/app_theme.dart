import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryLight,
        primary: AppColors.primaryLight,
        secondary: AppColors.primaryDark,
        background: AppColors.background,
      ),
      scaffoldBackgroundColor: AppColors.background,
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        displayLarge: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        displayMedium: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        displaySmall: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        headlineLarge: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        headlineMedium: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
        headlineSmall: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
        titleLarge: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
        titleMedium: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.w500),
        titleSmall: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.w500),
        bodyLarge: GoogleFonts.poppins(color: AppColors.textPrimary),
        bodyMedium: GoogleFonts.poppins(color: AppColors.textSecondary),
        bodySmall: GoogleFonts.poppins(color: AppColors.textSecondary),
        labelLarge: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryDark,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: Color(0xFFE0E0E0)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

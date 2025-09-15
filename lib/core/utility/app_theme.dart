import 'package:flutter/material.dart';
import 'package:gamenova2_mad1/core/utility/colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.skyBlue,
        primary: AppColors.skyBlue,
        secondary: AppColors.lightGray,
        brightness: Brightness.light,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.skyBlue,
        foregroundColor: Colors.black,
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        bodyMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
        bodySmall: TextStyle(fontSize: 14, color: Colors.black54),
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(fontSize: 16),
        hintStyle: TextStyle(fontSize: 16),
        floatingLabelStyle: TextStyle(fontSize: 14),
        helperStyle: TextStyle(fontSize: 12),
        errorStyle: TextStyle(fontSize: 12),
        border: OutlineInputBorder(),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.darkSkyBlue,
        primary: AppColors.darkSkyBlue,
        secondary: AppColors.darkGray,
        brightness: Brightness.dark,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.black,
        foregroundColor: AppColors.skyBlue,
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        bodyMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.white70,
        ),
        bodySmall: TextStyle(fontSize: 14, color: Colors.white60),
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(fontSize: 16),
        hintStyle: TextStyle(fontSize: 16),
        floatingLabelStyle: TextStyle(fontSize: 14),
        helperStyle: TextStyle(fontSize: 12),
        errorStyle: TextStyle(fontSize: 12),
        border: OutlineInputBorder(),
      ),
    );
  }
}

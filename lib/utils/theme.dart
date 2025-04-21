import 'package:flutter/material.dart';

// Uygulamanın genel renk paleti
class AppColors {
  static const Color primaryColor = Colors.purple;
  static const Color secondaryColor = Colors.green;
  static const Color accentColor = Colors.orange;
  static const Color backgroundColor = Color(0xFF242424);
  static const Color textColor = Colors.white;
  static const Color errorColor = Colors.red;
  static const Color appNameColor = Colors.lightGreenAccent;
  static const Color foregroundColor = Colors.white;
  static Color? fillColor = Colors.grey[900];
}

// Uygulama fontları
class AppFonts {
  static const String primaryFont = 'Roboto';
  static const String secondaryFont = 'Arial';
}

// Uygulama tema ayarları
class AppTheme {
  static ThemeData get theme {
    return ThemeData.dark().copyWith(
      // Renkler
      scaffoldBackgroundColor: AppColors.backgroundColor,
      primaryColor: AppColors.primaryColor,
      hintColor: AppColors.accentColor,

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.fillColor,
        foregroundColor: AppColors.foregroundColor,
        elevation: 0,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: AppColors.foregroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.fillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade600),
        ),
        labelStyle: TextStyle(color: Colors.grey.shade300),
      ),

      // Yazı tipleri

      // TextTheme
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontFamily: AppFonts.primaryFont,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.textColor,
        ),
        displayMedium: TextStyle(
          fontFamily: AppFonts.primaryFont,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: AppColors.appNameColor,
        ),
        bodyLarge: TextStyle(
          fontFamily: AppFonts.primaryFont,
          fontSize: 16,
          color: AppColors.textColor,
        ),
        bodyMedium: TextStyle(
          fontFamily: AppFonts.primaryFont,
          fontSize: 14,
          color: AppColors.textColor,
        ),
      ),

      // ButtonTheme
      buttonTheme: ButtonThemeData(
        buttonColor: AppColors.primaryColor,
        textTheme: ButtonTextTheme.primary,
      ),
    );
  }
}

import 'package:flutter/material.dart';

class HarvestHubTheme {
  // Design Language Colors
  static const growthGreen = Color(0xFF4CAF50);
  static const harvestGold = Color(0xFFFFC107);
  static const barnRed = Color(0xFFE53935);
  static const skyBlue = Color(0xFFE1F5FE);
  static const soilBrown = Color(0xFF795548);
  static const darkGrey = Color(0xFF263238);
  static const lightGrey = Color(0xFFBDBDBD);

  // Typography
  static const fontFamily = 'Rubik';

  // Spacing (8px grid)
  static const spacingSmall = 8.0;
  static const spacingMedium = 16.0;
  static const spacingLarge = 24.0;

  // Border Radius
  static const buttonRadius = 20.0;
  static const cardRadius = 24.0;
  
  // Theme Data
  static ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      fontFamily: fontFamily,
      colorScheme: ColorScheme.fromSeed(
        seedColor: growthGreen,
        brightness: Brightness.light,
        surface: skyBlue,
      ),
      scaffoldBackgroundColor: skyBlue,
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 48, 
          fontWeight: FontWeight.bold, 
          color: darkGrey,
        ),
        titleLarge: TextStyle(
          fontSize: 32, 
          fontWeight: FontWeight.w600, 
          color: darkGrey,
        ),
        labelLarge: TextStyle(
          fontSize: 24, 
          fontWeight: FontWeight.w500, 
          color: Colors.white,
        ),
        bodyLarge: TextStyle(
          fontSize: 18, 
          fontWeight: FontWeight.normal, 
          color: darkGrey,
        ),
        bodySmall: TextStyle(
          fontSize: 14, 
          fontWeight: FontWeight.normal, 
          color: darkGrey,
        ),
      ),
    );
  }
}

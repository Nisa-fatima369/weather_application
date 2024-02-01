import 'package:flutter/material.dart';

String robotoFontFamily = "Roboto";

ThemeData themeData = ThemeData(
  fontFamily: robotoFontFamily,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  iconTheme: const IconThemeData(
    color: Colors.white,
  ),
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w700,
      fontSize: 26,
    ),
    // headlineMedium: TextStyle(
    //   color: AppColors.primaryText,
    //   fontWeight: FontWeight.w600,
    //   fontSize: 30,
    // ),
    // headlineSmall: TextStyle(
    //   color: AppColors.secondary,
    //   fontWeight: FontWeight.w600,
    //   fontSize: 28,
    // ),

    titleLarge: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w600,
      fontSize: 28,
    ),
    // labelLarge: TextStyle(
    //   color: AppColors.primaryText,
    //   fontWeight: FontWeight.w500,
    //   fontSize: 20,
    // ),
    bodyLarge: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w300,
      fontSize: 20,
    ),
    // bodyMedium: TextStyle(
    //   color: AppColors.primaryText,
    //   fontWeight: FontWeight.w400,
    //   fontSize: 17,
    // ),
    bodySmall: TextStyle(
      color: Colors.white,
      fontSize: 14,
      fontWeight: FontWeight.w300,
    ),
  ),
);

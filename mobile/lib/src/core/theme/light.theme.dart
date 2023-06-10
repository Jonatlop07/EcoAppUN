import 'package:flutter/material.dart';
import 'package:mobile/src/shared/constants/app.sizes.dart';

import '../../shared/constants/app.colors.dart';
import '../../shared/constants/palette.dart';

const TextStyle labelMediumStyle = TextStyle(
  color: AppColors.darkGreen,
  fontSize: Sizes.p16,
  fontWeight: FontWeight.w400,
);

ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Palette.normalGreen,
  ).copyWith(
    secondary: Palette.lightGreen,
    tertiary: Palette.darkerGreen,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.normalGreen,
    foregroundColor: AppColors.white,
    elevation: 0,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.lightGreen,
      foregroundColor: AppColors.darkestGreen,
      textStyle: const TextStyle(
        fontSize: Sizes.p16,
        fontWeight: FontWeight.w400,
      ),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.darkGreen,
      side: const BorderSide(
        width: Sizes.p2,
        color: AppColors.darkGreen,
      ),
      textStyle: const TextStyle(
        fontSize: Sizes.p16,
        fontWeight: FontWeight.w400,
      ),
    ),
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(
      fontSize: Sizes.p24,
      fontWeight: FontWeight.w600,
      color: AppColors.darkGreen,
    ),
    titleMedium: TextStyle(
      fontSize: Sizes.p18,
      fontWeight: FontWeight.w500,
      color: AppColors.darkGreen,
    ),
    bodyMedium: TextStyle(
      fontSize: Sizes.p16,
      fontWeight: FontWeight.normal,
    ),
    bodySmall: TextStyle(
      fontSize: Sizes.p12,
    ),
    labelMedium: labelMediumStyle,
  ),
  inputDecorationTheme: const InputDecorationTheme(
    labelStyle: labelMediumStyle,
    hintStyle: TextStyle(
      color: AppColors.normalGreen,
      fontSize: Sizes.p12,
      fontWeight: FontWeight.w300,
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: AppColors.normalGreen,
      ),
    ),
  ),
  cardTheme: const CardTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(Sizes.p4)),
      side: BorderSide(color: AppColors.grey),
    ),
  ),
);

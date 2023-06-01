import 'package:flutter/material.dart';

import '../../shared/constants/app.colors.dart';
import '../../shared/constants/palette.dart';

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
    ),
  ),
);

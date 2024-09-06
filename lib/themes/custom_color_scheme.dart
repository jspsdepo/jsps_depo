import 'package:flutter/material.dart';

class CustomColorScheme {
  CustomColorScheme._();

  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: ColorName.neonBlue,
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFCCE7FF),
    onPrimaryContainer: Color(0xFF00274D),
    secondary: ColorName.futuristicTeal,
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFC2F2E9),
    onSecondaryContainer: Color(0xFF004D40),
    tertiary: ColorName.neonYellow,
    onTertiary: Color(0xFF000000),
    tertiaryContainer: Color(0xFFFFFFE0),
    onTertiaryContainer: Color(0xFF3E2723),
    error: ColorName.crimsonRed,
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFF9DEDC),
    onErrorContainer: Color(0xFF410E0B),
    outline: Color(0xFF79747E),
    background: Color(0xFFF5F5F5),
    onBackground: Color(0xFF1C1B1F),
    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF1C1B1F),
    surfaceVariant: Color(0xFFE7E0EC),
    onSurfaceVariant: Color(0xFF49454F),
    inverseSurface: Color(0xFF313033),
    onInverseSurface: Color(0xFFF4EFF4),
    inversePrimary: Color(0xFF67A1D7),
    shadow: Color(0xFF000000),
    surfaceTint: ColorName.neonBlue,
    outlineVariant: Color(0xFFCAC4D0),
    scrim: Color(0xFF000000),
  );

  static const darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: ColorName.neonBlue,
    onPrimary: Color(0xFFCCE7FF),
    primaryContainer: Color(0xFF00274D),
    onPrimaryContainer: Color(0xFFE1F5FE),
    secondary: ColorName.futuristicTeal,
    onSecondary: Color(0xFFC2F2E9),
    secondaryContainer: Color(0xFF004D40),
    onSecondaryContainer: Color(0xFFFFEBEE),
    tertiary: ColorName.neonYellow,
    onTertiary: Color(0xFF3E2723),
    tertiaryContainer: Color(0xFFFFFFE0),
    onTertiaryContainer: Color(0xFF6D4C41),
    error: Color(0xFFF2B8B5),
    onError: Color(0xFF601410),
    errorContainer: Color(0xFF8C1D18),
    onErrorContainer: Color(0xFFF9DEDC),
    outline: Color(0xFF938F99),
    background: Color(0xFF121212),
    onBackground: Color(0xFFE6E1E5),
    surface: Color(0xFF121212),
    onSurface: Color(0xFFE6E1E5),
    surfaceVariant: Color(0xFF49454F),
    onSurfaceVariant: Color(0xFFCAC4D0),
    inverseSurface: Color(0xFFE6E1E5),
    onInverseSurface: Color(0xFF313033),
    inversePrimary: Color(0xFF67A1D7),
    shadow: Color(0xFF000000),
    surfaceTint: ColorName.neonBlue,
    outlineVariant: Color(0xFF49454F),
    scrim: Color(0xFF000000),
  );
}

class ColorName {
  static const crimsonRed = Color(0xFFDC143C);
  static const neonBlue = Color(0xFF1E90FF);
  static const futuristicTeal = Color(0xFF008080);
  static const neonYellow = Color(0xFFFFFF00);
}

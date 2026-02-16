import 'package:flutter/material.dart';
class AppColors {
  AppColors._();
  static const Color pinterestRed = Color(0xFFE60023);
  static const Color pinterestRedDark = Color(0xFFAD081B);
  static const Color pinterestRedLight = Color(0xFFFF4D6A);
  static const Color darkBackground = Colors.black;
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkCard = Color(0xFF2C2C2C);
  static const Color darkSurfaceVariant = Color(0xFF2A2A2A);
  static const Color darkBorder = Color(0xFF3A3A3A);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB3B3B3);
  static const Color darkTextTertiary = Color(0xFF808080);
  static const Color darkTextDisabled = Color(0xFF4D4D4D);
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFF7F7F7);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE0E0E0);
  static const Color lightTextPrimary = Color(0xFF000000);
  static const Color lightTextSecondary = Color(0xFF5F5F5F);
  static const Color lightTextTertiary = Color(0xFF999999);
  static const Color lightTextDisabled = Color(0xFFCCCCCC);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);
  static const Color accent = Color(0xFF00BCD4);
  static const LinearGradient pinterestGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      pinterestRed,
      pinterestRedDark,
    ],
  );
  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      darkSurface,
      darkBackground,
    ],
  );
}

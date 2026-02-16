import 'package:flutter/material.dart';
import 'app_theme.dart';
class ThemeConfig {
  ThemeConfig._();
  static ThemeData get darkTheme => AppTheme.darkTheme;
  static ThemeData get lightTheme => AppTheme.lightTheme;
  static ThemeMode get defaultThemeMode => ThemeMode.dark;
  static void initialize() {
  }
}

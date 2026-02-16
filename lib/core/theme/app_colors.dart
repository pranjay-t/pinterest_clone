import 'package:flutter/material.dart';

/// Pinterest-inspired color palette for the application
/// Provides both light and dark theme color schemes
class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // ============================================================================
  // BRAND COLORS
  // ============================================================================
  
  /// Pinterest's signature red color
  static const Color pinterestRed = Color(0xFFE60023);
  
  /// Darker shade of Pinterest red for hover/pressed states
  static const Color pinterestRedDark = Color(0xFFAD081B);
  
  /// Lighter shade of Pinterest red for backgrounds
  static const Color pinterestRedLight = Color(0xFFFF4D6A);

  // ============================================================================
  // DARK THEME COLORS
  // ============================================================================
  
  /// Primary background color for dark theme
  static const Color darkBackground = Colors.black;
  
  /// Surface color for elevated components in dark theme
  static const Color darkSurface = Color(0xFF1E1E1E);
  
  /// Card background color in dark theme
  static const Color darkCard = Color(0xFF2C2C2C);
  
  /// Slightly lighter surface for hover states
  static const Color darkSurfaceVariant = Color(0xFF2A2A2A);
  
  /// Border color for dark theme
  static const Color darkBorder = Color(0xFF3A3A3A);
  
  /// Primary text color for dark theme (high emphasis)
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  
  /// Secondary text color for dark theme (medium emphasis)
  static const Color darkTextSecondary = Color(0xFFB3B3B3);
  
  /// Tertiary text color for dark theme (low emphasis)
  static const Color darkTextTertiary = Color(0xFF808080);
  
  /// Disabled text color for dark theme
  static const Color darkTextDisabled = Color(0xFF4D4D4D);

  // ============================================================================
  // LIGHT THEME COLORS
  // ============================================================================
  
  /// Primary background color for light theme
  static const Color lightBackground = Color(0xFFFFFFFF);
  
  /// Surface color for elevated components in light theme
  static const Color lightSurface = Color(0xFFF7F7F7);
  
  /// Card background color in light theme
  static const Color lightCard = Color(0xFFFFFFFF);
  
  /// Border color for light theme
  static const Color lightBorder = Color(0xFFE0E0E0);
  
  /// Primary text color for light theme (high emphasis)
  static const Color lightTextPrimary = Color(0xFF000000);
  
  /// Secondary text color for light theme (medium emphasis)
  static const Color lightTextSecondary = Color(0xFF5F5F5F);
  
  /// Tertiary text color for light theme (low emphasis)
  static const Color lightTextTertiary = Color(0xFF999999);
  
  /// Disabled text color for light theme
  static const Color lightTextDisabled = Color(0xFFCCCCCC);

  // ============================================================================
  // ACCENT & SEMANTIC COLORS
  // ============================================================================
  
  /// Success color (green)
  static const Color success = Color(0xFF4CAF50);
  
  /// Warning color (amber)
  static const Color warning = Color(0xFFFFC107);
  
  /// Error color (red)
  static const Color error = Color(0xFFF44336);
  
  /// Info color (blue)
  static const Color info = Color(0xFF2196F3);
  
  /// Accent color for CTAs and highlights
  static const Color accent = Color(0xFF00BCD4);
  
  // ============================================================================
  // GRADIENT COLORS
  // ============================================================================
  
  /// Gradient for Pinterest-themed backgrounds
  static const LinearGradient pinterestGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      pinterestRed,
      pinterestRedDark,
    ],
  );
  
  /// Dark gradient for backgrounds
  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      darkSurface,
      darkBackground,
    ],
  );
}

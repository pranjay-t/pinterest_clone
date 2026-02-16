import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CustomButton {
  static Widget solid({
    required BuildContext context,
    required String text,
    required VoidCallback? onPressed,
    bool isLoading = false,
    bool isFullWidth = false,
    Widget? prefixIcon,
    Widget? suffixIcon,
    Color? backgroundColor,
    Color? textColor,
    double height = 48.0,
    double? width,
    double fontSize = 16.0,
    FontWeight fontWeight = FontWeight.w500,
    double radius = 24.0,
    EdgeInsetsGeometry? padding,
  }) {
    final theme = Theme.of(context);
    final effectiveBackgroundColor = backgroundColor ?? AppColors.pinterestRed;
    final effectiveTextColor = textColor ?? Colors.white;

    return SizedBox(
      width: isFullWidth ? double.infinity : width,
      // height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isLoading
              ? Color.fromRGBO(
                  effectiveBackgroundColor.red,
                  effectiveBackgroundColor.green,
                  effectiveBackgroundColor.blue,
                  0.3,
                )
              : effectiveBackgroundColor,
          padding:
              padding ??
              const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: effectiveTextColor,
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (prefixIcon != null) ...[
                    prefixIcon,
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontSize: fontSize,
                      fontWeight: fontWeight,
                      color: effectiveTextColor,
                    ),
                  ),
                  if (suffixIcon != null) ...[
                    const SizedBox(width: 8),
                    suffixIcon,
                  ],
                ],
              ),
      ),
    );
  }

  static Widget outlined({
    required BuildContext context,
    required String text,
    required VoidCallback? onPressed,
    bool isLoading = false,
    bool isFullWidth = false,
    Widget? prefixIcon,
    Widget? suffixIcon,
    Color? borderColor,
    Color? textColor,
    Color? backgroundColor,
    double height = 48.0,
    double? width,
    double fontSize = 16.0,
    FontWeight fontWeight = FontWeight.w500,
    double radius = 24.0,
    EdgeInsetsGeometry? padding,
  }) {
    final theme = Theme.of(context);
    final effectiveBorderColor = borderColor ?? AppColors.pinterestRed;
    final effectiveTextColor = textColor ?? AppColors.pinterestRed;
    final effectiveBackgroundColor = backgroundColor ?? Colors.transparent;

    return SizedBox(
      width: isFullWidth ? double.infinity : width,
      height: height,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: effectiveBackgroundColor,
          padding:
              padding ??
              const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          side: BorderSide(color: effectiveBorderColor, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: effectiveBorderColor,
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (prefixIcon != null) ...[
                    prefixIcon,
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontSize: fontSize,
                      fontWeight: fontWeight,
                      color: effectiveTextColor,
                    ),
                  ),
                  if (suffixIcon != null) ...[
                    const SizedBox(width: 8),
                    suffixIcon,
                  ],
                ],
              ),
      ),
    );
  }

  static Widget text({
    required BuildContext context,
    required String text,
    required VoidCallback? onPressed,
    bool isLoading = false,
    Widget? prefixIcon,
    Widget? suffixIcon,
    Color? textColor,
    double fontSize = 16.0,
    FontWeight fontWeight = FontWeight.w500,
    double radius = 8.0,
    EdgeInsetsGeometry? padding,
  }) {
    final theme = Theme.of(context);
    final effectiveTextColor = textColor ?? AppColors.pinterestRed;

    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: effectiveTextColor,
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: effectiveTextColor,
                strokeWidth: 2,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (prefixIcon != null) ...[
                  prefixIcon,
                  const SizedBox(width: 8),
                ],
                Text(
                  text,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontSize: fontSize,
                    fontWeight: fontWeight,
                    color: effectiveTextColor,
                  ),
                ),
                if (suffixIcon != null) ...[
                  const SizedBox(width: 8),
                  suffixIcon,
                ],
              ],
            ),
    );
  }

  static Widget gradient({
    required BuildContext context,
    required String text,
    required VoidCallback? onPressed,
    bool isLoading = false,
    bool isFullWidth = false,
    Widget? prefixIcon,
    Widget? suffixIcon,
    Gradient? gradient,
    Color? textColor,
    double height = 48.0,
    double? width,
    double fontSize = 16.0,
    FontWeight fontWeight = FontWeight.w500,
    double radius = 24.0,
    EdgeInsetsGeometry? padding,
  }) {
    final theme = Theme.of(context);
    final effectiveGradient = gradient ?? AppColors.pinterestGradient;
    final effectiveTextColor = textColor ?? Colors.white;

    return Container(
      width: isFullWidth ? double.infinity : width,
      height: height,
      decoration: BoxDecoration(
        gradient: effectiveGradient,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: effectiveTextColor,
          shadowColor: Colors.transparent,
          elevation: 0,
          padding:
              padding ??
              const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: effectiveTextColor,
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (prefixIcon != null) ...[
                    prefixIcon,
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontSize: fontSize,
                      fontWeight: fontWeight,
                      color: effectiveTextColor,
                    ),
                  ),
                  if (suffixIcon != null) ...[
                    const SizedBox(width: 8),
                    suffixIcon,
                  ],
                ],
              ),
      ),
    );
  }
}

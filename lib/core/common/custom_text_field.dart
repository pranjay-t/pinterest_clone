import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinterest_clone/core/theme/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final String? countertext;
  final String? errorText;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final bool readOnly;
  final bool enabled;
  final bool autofocus;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final TextStyle? errorStyle;
  final TextStyle? helperStyle;
  final TextAlign? textAlign;
  final Widget? prefix;
  final Widget? prefixIcon;
  final Widget? suffix;
  final Widget? suffixIcon;
  final Color? fillColor;
  final Color? cursorColor;
  final double borderRadius;
  final InputBorder? border;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final InputBorder? errorBorder;
  final InputBorder? focusedErrorBorder;
  final InputBorder? disabledBorder;
  final TextCapitalization textCapitalization;
  final ValueChanged<String>? onSubmitted;
  final EdgeInsetsGeometry? contentPadding;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final FormFieldValidator<String>? validator;

  final List<TextInputFormatter>? inputFormatters;

  const CustomTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.hintText,
    this.labelText,
    this.helperText,
    this.errorText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.textCapitalization = TextCapitalization.none,
    this.onSubmitted,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.readOnly = false,
    this.enabled = true,
    this.autofocus = false,
    this.textStyle,
    this.hintStyle,
    this.labelStyle,
    this.errorStyle,
    this.helperStyle,
    this.textAlign,
    this.prefix,
    this.prefixIcon,
    this.inputFormatters,
    this.suffix,
    this.suffixIcon,
    this.fillColor,
    this.cursorColor,
    this.borderRadius = 12.0,
    this.border,
    this.enabledBorder,
    this.focusedBorder,
    this.errorBorder,
    this.focusedErrorBorder,
    this.disabledBorder,
    this.contentPadding,
    this.onChanged,
    this.onTap,
    this.validator,
    this.countertext,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final defaultBorderRadius = BorderRadius.circular(borderRadius);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SizedBox(
      width: w,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        maxLines: maxLines,
        minLines: minLines,
        maxLength: maxLength,
        textCapitalization: textCapitalization,
        inputFormatters: inputFormatters,
        readOnly: readOnly,
        enabled: enabled,
        autofocus: autofocus,
        cursorColor: cursorColor ?? AppColors.pinterestRed,
        style: textStyle,
        textAlign: textAlign ?? TextAlign.start,
        onChanged: onChanged,
        onTap: onTap,
        validator: validator,
        onFieldSubmitted: onSubmitted,
        decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          helperText: helperText,
          errorText: errorText,
          counterText: countertext,
          hintStyle:
              hintStyle ??
              TextStyle(
                color: isDark
                    ? AppColors.darkTextTertiary
                    : AppColors.lightTextTertiary,
              ),
          labelStyle:
              labelStyle ??
              TextStyle(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
          helperStyle: helperStyle,
          errorStyle: errorStyle,
          prefix: prefix,
          prefixIcon: prefixIcon,
          suffix: suffix,
          suffixIcon: suffixIcon,
          contentPadding:
              contentPadding ??
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          filled: fillColor != null || true,
          fillColor:
              fillColor ??
              (isDark ? AppColors.darkBackground : AppColors.lightBackground),
          border:
              border ?? OutlineInputBorder(borderRadius: defaultBorderRadius),
          enabledBorder:
              enabledBorder ??
              OutlineInputBorder(
                borderRadius: defaultBorderRadius,
                borderSide: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
          focusedBorder:
              focusedBorder ??
              OutlineInputBorder(
                borderRadius: defaultBorderRadius,
                borderSide: const BorderSide(
                  color: AppColors.lightSurface,
                  width: 1.5,
                ),
              ),
          errorBorder:
              errorBorder ??
              OutlineInputBorder(
                borderRadius: defaultBorderRadius,
                borderSide: BorderSide(
                  color: AppColors.error.withAlpha(250),
                  width: 2,
                ),
              ),
          focusedErrorBorder:
              focusedErrorBorder ??
              OutlineInputBorder(
                borderRadius: defaultBorderRadius,
                borderSide: const BorderSide(
                  color: AppColors.error,
                  width: 1.5,
                ),
              ),
          disabledBorder:
              disabledBorder ??
              OutlineInputBorder(
                borderRadius: defaultBorderRadius,
                borderSide: BorderSide(
                  color: isDark
                      ? AppColors.darkBorder.withOpacity(0.3)
                      : AppColors.lightBorder.withOpacity(0.3),
                ),
              ),
        ),
      ),
    );
  }
}

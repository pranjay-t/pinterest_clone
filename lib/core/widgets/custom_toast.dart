import 'package:flutter/material.dart';
import 'package:pinterest_clone/core/common/custom_button.dart';

class CustomToast {
  static void show(
    BuildContext context,
    String message, {
    VoidCallback? onUndo,
    String undoText = 'Undo',
    EdgeInsetsGeometry? margin,
  }) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
      _buildSnackBar(
        context,
        message,
        onUndo: onUndo,
        undoText: undoText,
        onHide: messenger.hideCurrentSnackBar,
        margin: margin,
      ),
    );
  }

  static void showWithMessenger(
    ScaffoldMessengerState messenger,
    String message, {
    VoidCallback? onUndo,
    String undoText = 'Undo',
    EdgeInsetsGeometry? margin,
  }) {
    messenger.showSnackBar(
      _buildSnackBar(
        messenger.context,
        message,
        onUndo: onUndo,
        undoText: undoText,
        onHide: messenger.hideCurrentSnackBar,
        margin: margin,
      ),
    );
  }

  static SnackBar _buildSnackBar(
    BuildContext context,
    String message, {
    VoidCallback? onUndo,
    String undoText = 'Undo',
    VoidCallback? onHide,
    EdgeInsetsGeometry? margin,
  }) {
    final hasUndo = onUndo != null;

    return SnackBar(
      content: hasUndo
          ? Row(
              children: [
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CustomButton.solid(
                  context: context,
                  text: undoText,
                  onPressed: () {
                    onHide?.call();
                    onUndo();
                  },
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  height: 36,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 0,
                  ),
                  fontSize: 14,
                  radius: 18,
                ),
              ],
            )
          : Text(
              message,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
      backgroundColor: Colors.white,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin:
          margin ?? const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      duration: const Duration(seconds: 4),
      elevation: 6,
    );
  }
}

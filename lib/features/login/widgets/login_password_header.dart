import 'package:flutter/material.dart';
import 'package:pinterest_clone/features/login/constants/login_constants.dart';

class LoginPasswordHeader extends StatelessWidget {
  const LoginPasswordHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.clear, size: 24),
        ),
        Text(
          LoginConstants.loginHeaderText,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 48), // Balance the layout
      ],
    );
  }
}

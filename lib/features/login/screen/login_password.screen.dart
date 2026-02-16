import 'package:flutter/material.dart';
import 'package:pinterest_clone/features/login/widgets/login_background.dart';
import 'package:pinterest_clone/features/login/widgets/login_password_form.dart';
import 'package:pinterest_clone/features/login/widgets/login_password_header.dart';
import 'package:pinterest_clone/features/login/widgets/login_terms.dart';

class LoginPasswordScreen extends StatelessWidget {
  final String email;
  const LoginPasswordScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(12),
                child: LoginPasswordHeader(),
              ),
              const SizedBox(height: 16),
              const Divider(thickness: 1.5),
              const SizedBox(height: 16),
              LoginPasswordForm(email: email),
            ],
          ),
        ),
      ),
    );
  }
}

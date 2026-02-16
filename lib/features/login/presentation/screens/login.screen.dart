import 'package:flutter/material.dart';
import 'package:pinterest_clone/features/login/presentation/widgets/login_background.dart';
import 'package:pinterest_clone/features/login/presentation/widgets/login_form.dart';
import 'package:pinterest_clone/features/login/presentation/widgets/login_terms.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final topPadding = MediaQuery.of(context).padding.bottom;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: size.height - topPadding,
            child: Stack(
              children: [
                const LoginBackground(),
                Column(
                  children: [
                    const Expanded(child: LoginForm()),
                    const SizedBox(height: 16),
                    const LoginTerms(),
                    const SizedBox(height: 16),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

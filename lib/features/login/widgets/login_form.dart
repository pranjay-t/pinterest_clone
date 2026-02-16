import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:pinterest_clone/core/theme/app_colors.dart';
import 'package:pinterest_clone/core/widgets/custom_button.dart';
import 'package:pinterest_clone/core/widgets/custom_text_field.dart';
import 'package:pinterest_clone/features/login/constants/login_constants.dart';
import 'package:go_router/go_router.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      setState(() {
        _hasText = _emailController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: LoginConstants.horizontalPadding,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: size.height * LoginConstants.logoTopSpacing),
            Image.asset(
              LoginConstants.logoPath,
              height: LoginConstants.logoSize,
            ),

            const SizedBox(height: 10),
            Text(
              LoginConstants.headingLine1,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              LoginConstants.headingLine2,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 18),
            CustomTextField(
              controller: _emailController,
              hintText: LoginConstants.emailHint,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              contentPadding: const EdgeInsets.symmetric(
                vertical: LoginConstants.textFieldPaddingVertical,
                horizontal: LoginConstants.textFieldPaddingHorizontal,
              ),
              borderRadius: LoginConstants.textFieldBorderRadius,
              suffixIcon: _hasText
                  ? IconButton(
                      icon: const Icon(Icons.highlight_off, size: 20),
                      onPressed: () {
                        _emailController.clear();
                      },
                    )
                  : null,
              validator: _validateEmail,
            ),

            const SizedBox(height: 24),
            CustomButton.solid(
              padding: const EdgeInsets.all(
                LoginConstants.buttonPaddingVertical,
              ),
              text: LoginConstants.continueButtonText,
              onPressed: _handleContinue,
              context: context,
              radius: LoginConstants.buttonBorderRadius,
              fontWeight: FontWeight.w400,
              isFullWidth: true,
            ),

            const SizedBox(height: 24),
            CustomButton.outlined(
              text: LoginConstants.googleButtonText,
              textColor: AppColors.darkTextPrimary,
              radius: LoginConstants.googleButtonBorderRadius,
              onPressed: _handleGoogleSignIn,
              borderColor: AppColors.darkTextSecondary,
              isFullWidth: true,
              context: context,
              prefixIcon: Image.asset(
                LoginConstants.googleIconPath,
                height: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email address';
    }
    if (!value.contains('@')) {
      return 'Sorry, this doesn\'t look like a valid email \naddress';
    }
    return null;
  }

  void _handleContinue() {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text.trim();
      context.push('/login_password', extra: email);
    }
  }

  void _handleGoogleSignIn() {
    showBottomSheet(
      context: context,
      builder: (context) => ClerkAuthentication(),
    );
  }
}

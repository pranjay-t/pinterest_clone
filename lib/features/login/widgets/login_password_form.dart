import 'package:flutter/material.dart';
import 'package:pinterest_clone/core/theme/app_colors.dart';
import 'package:pinterest_clone/core/widgets/custom_button.dart';
import 'package:pinterest_clone/core/widgets/custom_text_field.dart';
import 'package:pinterest_clone/features/login/constants/login_constants.dart';

class LoginPasswordForm extends StatefulWidget {
  final String email;
  const LoginPasswordForm({super.key, required this.email});

  @override
  State<LoginPasswordForm> createState() => _LoginPasswordFormState();
}

class _LoginPasswordFormState extends State<LoginPasswordForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isPasswordObscure = true;

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.email;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: LoginConstants.horizontalPadding,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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

            const SizedBox(height: 24),
            Text(
              LoginConstants.orDividerText,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
            ),

            const SizedBox(height: 24),
            CustomTextField(
              controller: _emailController,
              hintText: LoginConstants.emailHint,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              // readOnly: true,
              // enabled: false,
              contentPadding: const EdgeInsets.symmetric(
                vertical: LoginConstants.textFieldPaddingVertical,
                horizontal: LoginConstants.textFieldPaddingHorizontal,
              ),
              borderRadius: LoginConstants.textFieldBorderRadius,
              validator: _validateEmail,
            ),

            const SizedBox(height: 16),
            CustomTextField(
              controller: _passwordController,
              hintText: LoginConstants.passwordHint,
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.done,
              obscureText: _isPasswordObscure,
              contentPadding: const EdgeInsets.symmetric(
                vertical: LoginConstants.textFieldPaddingVertical,
                horizontal: LoginConstants.textFieldPaddingHorizontal,
              ),
              borderRadius: LoginConstants.textFieldBorderRadius,
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      _isPasswordObscure
                          ? Icons.visibility_rounded
                          : Icons.visibility_off_rounded,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordObscure = !_isPasswordObscure;
                      });
                    },
                  ),
                ],
              ),
              validator: _validatePassword,
            ),

            const SizedBox(height: 24),
            CustomButton.solid(
              padding: const EdgeInsets.all(
                LoginConstants.buttonPaddingVertical,
              ),
              text: LoginConstants.loginButtonText,
              onPressed: _handleLogin,
              context: context,
              radius: LoginConstants.buttonBorderRadius,
              fontWeight: FontWeight.w400,
              isFullWidth: true,
            ),

            const SizedBox(height: 16),
            Text(
              LoginConstants.forgotPasswordText,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.darkTextTertiary,
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

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter password';
    }
    return null;
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      debugPrint('Login with email: ${_emailController.text}');
      
      
    }
  }

  Future<void> _handleGoogleSignIn() async {
    
  }
}

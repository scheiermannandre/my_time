import 'package:flutter/material.dart';
import 'package:my_time/config/theme/tokens/space_tokens.dart';
import 'package:my_time/config/theme/tokens/text_style_tokens.dart';
import 'package:my_time/core/widgets/action_button.dart';
import 'package:my_time/core/widgets/password_checker/password_checker.dart';
import 'package:my_time/core/widgets/spaced_column.dart';
import 'package:my_time/features/8_authentication/presentation/pages/widgets/auth_password_field.dart';

/// A customizable widget for changing the password.
class AuthChangePasswordWidget extends StatelessWidget {
  /// Constructs an [AuthChangePasswordWidget].
  const AuthChangePasswordWidget({
    required this.title,
    required this.passwordController,
    required this.obscurePassword,
    required this.toggleObscurePassword,
    required this.onChanged,
    required this.isSubmitEnabled,
    required this.onSubmit,
    required this.submitButtonLabel,
    required this.isLoading,
    required this.onCancel,
    required this.cancelButtonLabel,
    super.key,
  });

  /// The title of the authentication page.
  final String title;

  /// The controller for the password text field.
  final TextEditingController passwordController;

  /// Whether the password is obscured or not.
  final bool obscurePassword;

  /// Toggles the password obscuration.
  final VoidCallback toggleObscurePassword;

  /// The callback for when the password changes.
  // ignore: avoid_positional_boolean_parameters
  final void Function(String value, bool isValid, PasswordStrength? strength)
      onChanged;

  /// Whether the submit button is enabled or not.
  final bool isSubmitEnabled;

  /// The callback for when the submit button is pressed.
  final VoidCallback onSubmit;

  /// The label of the submit button.
  final String submitButtonLabel;

  /// Whether the submit button is loading or not.
  final bool isLoading;

  /// The callback for when the cancel button is pressed.
  final VoidCallback onCancel;

  /// The label of the cancel button.
  final String cancelButtonLabel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: SpaceTokens.medium),
          child: Center(
            child: SingleChildScrollView(
              child: SpacedColumn(
                spacing: SpaceTokens.medium,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Display the title of the authentication page
                  Text(
                    title,
                    style: TextStyleTokens.getHeadline1(null),
                  ),
                  // Password text field for sign-up
                  AuthCheckedPasswordField(
                    passwordController: passwordController,
                    obscurePassword: obscurePassword,
                    toggleObscurePassword: toggleObscurePassword,
                    onChanged: onChanged,
                  ),
                  ActionButton.primary(
                    onPressed: !isSubmitEnabled ? null : onSubmit,
                    isLoading: isLoading,
                    child: Text(
                      submitButtonLabel,
                    ),
                  ),
                  ActionButton.secondary(
                    onPressed: onCancel,
                    child: Text(cancelButtonLabel),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

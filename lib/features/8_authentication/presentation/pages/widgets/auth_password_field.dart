import 'package:flutter/material.dart';
import 'package:my_time/config/theme/corner_radius_tokens.dart';
import 'package:my_time/config/theme/mighty_theme.dart';
import 'package:my_time/config/theme/space_tokens.dart';
import 'package:my_time/core/widgets/mighty_text_form_field.dart';
import 'package:my_time/core/widgets/password_checker/password_checker.dart';
import 'package:my_time/core/widgets/spaced_column.dart';

/// A widget representing the password field for authentication.
class AuthPasswordField extends StatelessWidget {
  /// Constructs an [AuthPasswordField] with required parameters.
  const AuthPasswordField({
    required this.passwordController,
    required this.themeController,
    required this.obscurePassword,
    required this.toggleObscurePassword,
    required this.onChanged,
    super.key,
  });

  /// The controller for the password text field.
  final TextEditingController passwordController;

  /// The theme controller for managing the appearance.
  final MightyThemeController themeController;

  /// Represents whether the password is obscured or visible.
  final bool obscurePassword;

  /// Callback function to toggle password visibility.
  final VoidCallback toggleObscurePassword;

  /// Callback function for handling changes in the password field.
  // ignore: avoid_positional_boolean_parameters
  final void Function(String, bool) onChanged;

  @override
  Widget build(BuildContext context) {
    // Builds a MightyTextFormField for password input.
    // Includes a suffix icon to toggle password visibility.
    return MightyTextFormField(
      controller: passwordController,
      mightyThemeController: themeController,
      labelText: 'Your password',
      hintText: '1-Strong-Password-Or-Passphrase!',
      textInputType: TextInputType.visiblePassword,
      obscureText: obscurePassword,
      suffixIcon: GestureDetector(
        onTap: toggleObscurePassword,
        child: Icon(
          obscurePassword ? Icons.visibility : Icons.visibility_off,
          color: themeController.secondaryTextColor,
        ),
      ),
      onChanged: onChanged,
    );
  }
}

/// A widget representing the password field for authentication with a
/// password strength meter.
class AuthCheckedPasswordField extends StatelessWidget {
  /// Constructs an [AuthCheckedPasswordField] with required parameters.
  AuthCheckedPasswordField({
    required this.passwordController,
    required this.themeController,
    required this.obscurePassword,
    required this.toggleObscurePassword,
    required this.onChanged,
    super.key,
  });

  /// The controller for the password text field.
  final TextEditingController passwordController;

  /// The theme controller for managing the appearance.
  final MightyThemeController themeController;

  /// Represents whether the password is obscured or visible.
  final bool obscurePassword;

  /// Callback function to toggle password visibility.
  final VoidCallback toggleObscurePassword;

  /// Callback function for handling changes in the password field.
  // ignore: avoid_positional_boolean_parameters
  final void Function(String, bool, PasswordStrength?) onChanged;

  /// Value notifier for tracking password strength.
  final _passNotifier = ValueNotifier<PasswordStrength?>(null);

  @override
  Widget build(BuildContext context) {
    // Calculates password strength and updates the notifier.
    _passNotifier.value =
        PasswordStrengthExtension.calculate(text: passwordController.text);

    return SpacedColumn(
      spacing: SpaceTokens.medium,
      children: [
        AuthPasswordField(
          // This is the AuthPasswordField widget
          passwordController: passwordController,
          themeController: themeController,
          obscurePassword: obscurePassword,
          toggleObscurePassword: toggleObscurePassword,
          onChanged: (value, isValid) {
            _passNotifier.value =
                PasswordStrengthExtension.calculate(text: value);
            onChanged(value, isValid, _passNotifier.value);
          },
        ),
        PasswordStrengthChecker(
          strength: _passNotifier,
          configuration: PasswordStrengthCheckerConfiguration(
            statusMargin: const EdgeInsets.only(top: SpaceTokens.small),
            borderWidth: 1,
            borderColor: themeController.nonDecorativeBorderColor,
            externalBorderRadius: const BorderRadius.all(
              Radius.circular(
                CornerRadiusTokens.slightySmall,
              ),
            ),
            internalBorderRadius: const BorderRadius.all(
              Radius.circular(
                CornerRadiusTokens.verySmall,
              ),
            ),
          ),
        ),
      ],
    );
  }
}